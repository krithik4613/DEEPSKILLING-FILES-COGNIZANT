-- ============================================
-- HANDS-ON 3: Subqueries, Views & Transactions
-- (PostgreSQL syntax; MySQL notes where it differs)
-- ============================================

-- ===== TASK 1: Subqueries =====

-- Students enrolled in more courses than average
SELECT student_id, COUNT(*) AS course_count
FROM enrollments
GROUP BY student_id
HAVING COUNT(*) > (
    SELECT AVG(course_count) FROM (
        SELECT COUNT(*) AS course_count FROM enrollments GROUP BY student_id
    ) sub
);

-- Courses where ALL enrolled students got 'A' (NOT EXISTS pattern)
SELECT c.course_name
FROM courses c
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e
    WHERE e.course_id = c.course_id AND (e.grade <> 'A' OR e.grade IS NULL)
)
AND EXISTS (SELECT 1 FROM enrollments e WHERE e.course_id = c.course_id);

-- Highest paid professor per department (correlated subquery)
SELECT p.*
FROM professors p
WHERE p.salary = (
    SELECT MAX(p2.salary) FROM professors p2 WHERE p2.department_id = p.department_id
);

-- Derived table: departments where avg salary > 85000
SELECT d.dept_name, dept_avg.avg_salary
FROM departments d
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM professors GROUP BY department_id
) dept_avg ON d.department_id = dept_avg.department_id
WHERE dept_avg.avg_salary > 85000;


-- ===== TASK 2: Views =====

CREATE VIEW vw_student_enrollment_summary AS
SELECT s.student_id,
       s.first_name || ' ' || s.last_name AS full_name,
       d.dept_name,
       COUNT(e.enrollment_id) AS courses_enrolled,
       ROUND(AVG(CASE e.grade
            WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2
            WHEN 'D' THEN 1 WHEN 'F' THEN 0 END), 2) AS gpa
FROM students s
JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, full_name, d.dept_name;

CREATE VIEW vw_course_stats AS
SELECT c.course_name, c.course_code,
       COUNT(e.enrollment_id) AS total_enrollments,
       ROUND(AVG(CASE e.grade
            WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2
            WHEN 'D' THEN 1 WHEN 'F' THEN 0 END), 2) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name, c.course_code;

-- Students with GPA above 3.0
SELECT * FROM vw_student_enrollment_summary WHERE gpa > 3.0;

-- Attempting UPDATE through the multi-table view fails:
-- Postgres/MySQL reject it because the view mixes aggregates and
-- multiple base tables, so engine can't map rows back to a single table.
-- UPDATE vw_student_enrollment_summary SET gpa = 4.0 WHERE student_id = 1; -- ERROR

DROP VIEW vw_student_enrollment_summary;
DROP VIEW vw_course_stats;

-- Single-table view with CHECK OPTION
CREATE VIEW vw_active_2022_students AS
SELECT * FROM students WHERE enrollment_year = 2022
WITH CHECK OPTION;
-- Inserting/updating a row through this view that breaks the WHERE clause is rejected.


-- ===== TASK 3: Stored Procedures / Functions & Transactions =====

-- PostgreSQL function: enroll student, block duplicates
CREATE OR REPLACE FUNCTION fn_enroll_student(p_student_id INT, p_course_id INT, p_date DATE)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = p_student_id AND course_id = p_course_id) THEN
        RAISE EXCEPTION 'Duplicate enrollment for student % in course %', p_student_id, p_course_id;
    END IF;
    INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (p_student_id, p_course_id, p_date);
END;
$$ LANGUAGE plpgsql;

-- Transfer student between departments, logged, all-or-nothing
CREATE TABLE IF NOT EXISTS department_transfer_log (
    log_id SERIAL PRIMARY KEY,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transferred_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION sp_transfer_student(p_student_id INT, p_new_dept INT)
RETURNS VOID AS $$
DECLARE
    v_old_dept INT;
BEGIN
    SELECT department_id INTO v_old_dept FROM students WHERE student_id = p_student_id;

    UPDATE students SET department_id = p_new_dept WHERE student_id = p_student_id;
    INSERT INTO department_transfer_log (student_id, old_department_id, new_department_id)
    VALUES (p_student_id, v_old_dept, p_new_dept);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Transfer failed, rolled back automatically';
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- Test: invalid department_id triggers FK error, both statements roll back
-- SELECT sp_transfer_student(1, 9999);

-- SAVEPOINT demo
BEGIN;
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES (2, 4, '2024-01-01', 'B');
SAVEPOINT after_first_insert;
-- deliberately invalid course_id to force failure
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES (2, 9999, '2024-01-01', 'B');
ROLLBACK TO SAVEPOINT after_first_insert;
COMMIT;
-- Result: only the first insert persists.
