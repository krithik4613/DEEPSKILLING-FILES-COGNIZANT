-- ============================================
-- HANDS-ON 2: DML, Joins & Aggregations
-- ============================================

-- ===== TASK 1: Insert, Update, Delete =====

-- Sample data (run once)
INSERT INTO departments (dept_name, hod_name, budget) VALUES
 ('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
 ('Electronics', 'Dr. Priya Nair', 620000.00),
 ('Mechanical', 'Dr. Suresh Iyer', 540000.00),
 ('Civil', 'Dr. Ananya Sharma', 430000.00);

INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
 ('Arjun', 'Mehta', 'arjun.mehta@college.edu', '2003-04-12', 1, 2022),
 ('Priya', 'Suresh', 'priya.suresh@college.edu', '2003-07-25', 1, 2022),
 ('Rohan', 'Verma', 'rohan.verma@college.edu', '2002-11-08', 2, 2021),
 ('Sneha', 'Patel', 'sneha.patel@college.edu', '2004-01-30', 3, 2023),
 ('Vikram', 'Das', 'vikram.das@college.edu', '2003-09-14', 1, 2022),
 ('Kavya', 'Menon', 'kavya.menon@college.edu', '2002-05-17', 2, 2021),
 ('Aditya', 'Singh', 'aditya.singh@college.edu', '2004-03-22', 4, 2023),
 ('Deepika','Rao', 'deepika.rao@college.edu', '2003-08-09', 1, 2022);

INSERT INTO courses (course_name, course_code, credits, department_id) VALUES
 ('Data Structures & Algorithms', 'CS101', 4, 1),
 ('Database Management Systems', 'CS102', 3, 1),
 ('Object Oriented Programming', 'CS103', 4, 1),
 ('Circuit Theory', 'EC101', 3, 2),
 ('Thermodynamics', 'ME101', 3, 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
 (1, 1, '2022-07-01', 'A'), (1, 2, '2022-07-01', 'B'),
 (2, 1, '2022-07-01', 'B'), (2, 3, '2022-07-01', 'A'),
 (3, 4, '2021-07-01', 'A'), (4, 5, '2023-07-01', NULL),
 (5, 1, '2022-07-01', 'C'), (5, 2, '2022-07-01', 'A'),
 (6, 4, '2021-07-01', 'B'), (7, 5, '2023-07-01', NULL),
 (8, 1, '2022-07-01', 'A'), (8, 3, '2022-07-01', 'B');

INSERT INTO professors (prof_name, email, department_id, salary) VALUES
 ('Dr. Anand Krishnan', 'anand.k@college.edu', 1, 95000.00),
 ('Dr. Meena Pillai', 'meena.p@college.edu', 1, 88000.00),
 ('Dr. Sunil Rajan', 'sunil.r@college.edu', 2, 82000.00),
 ('Dr. Latha Gopal', 'latha.g@college.edu', 3, 79000.00),
 ('Dr. Kartik Bose', 'kartik.b@college.edu', 4, 76000.00);

-- Two additional students
INSERT INTO students (first_name, last_name, email, date_of_birth, department_id, enrollment_year) VALUES
 ('Ishaan', 'Kapoor', 'ishaan.kapoor@college.edu', '2003-02-19', 2, 2022),
 ('Meera', 'Iyer', 'meera.iyer@college.edu', '2004-06-11', 3, 2023);

-- Update grade
UPDATE enrollments SET grade = 'B' WHERE student_id = 5 AND course_id = 1;

-- Preview before delete
SELECT * FROM enrollments WHERE grade IS NULL;

-- Delete ungraded enrollments
DELETE FROM enrollments WHERE grade IS NULL;

-- Row count checks
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM enrollments;


-- ===== TASK 2: Single-Table Queries =====

-- Students enrolled in 2022, alphabetical
SELECT * FROM students WHERE enrollment_year = 2022 ORDER BY last_name;

-- Courses with more than 3 credits
SELECT * FROM courses WHERE credits > 3 ORDER BY credits DESC;

-- Professors salary between 80k and 95k
SELECT * FROM professors WHERE salary BETWEEN 80000 AND 95000;

-- Emails ending with @college.edu
SELECT * FROM students WHERE email LIKE '%@college.edu';

-- Students per enrollment year
SELECT enrollment_year, COUNT(*) AS total_students
FROM students GROUP BY enrollment_year;


-- ===== TASK 3: Multi-Table Joins =====

-- Student full name + department
SELECT s.first_name || ' ' || s.last_name AS full_name, d.dept_name
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Enrollment + student + course
SELECT s.first_name || ' ' || s.last_name AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Students not enrolled in any course
SELECT s.*
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- Every course + enrolment count (incl. zero)
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Departments + professors + salary (incl. no-professor depts)
SELECT d.dept_name, p.prof_name, p.salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id;


-- ===== TASK 4: Aggregations =====

-- Enrollments per course
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Avg professor salary per department
SELECT d.dept_name, ROUND(AVG(p.salary), 2) AS avg_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.dept_name;

-- Departments with budget over 600,000
SELECT * FROM departments WHERE budget > 600000;

-- Grade distribution for CS101
SELECT e.grade, COUNT(*) AS grade_count
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101'
GROUP BY e.grade;

-- Departments with more than 2 students enrolled (HAVING)
SELECT d.dept_name, COUNT(e.enrollment_id) AS total_enrollments
FROM departments d
JOIN students s ON d.department_id = s.department_id
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY d.dept_name
HAVING COUNT(e.enrollment_id) > 2;
