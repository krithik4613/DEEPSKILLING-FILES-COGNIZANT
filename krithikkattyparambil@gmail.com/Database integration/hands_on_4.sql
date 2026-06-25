USE college_db;

-- ==========================================================
-- TASK 1 : BASELINE PERFORMANCE (WITHOUT INDEXES)
-- ==========================================================

-- 48. Run EXPLAIN on the query

EXPLAIN FORMAT=JSON
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- ----------------------------------------------------------
-- COMMENT:
--
-- Initially MySQL may perform Full Table Scan
-- on students and enrollments tables because
-- no indexes exist.
--
-- Rows examined and cost can be viewed from
-- EXPLAIN JSON output.
--
-- Example observation:
--
-- "access_type": "ALL"
--
-- means Full Table Scan.
--
-- ==========================================================



-- ==========================================================
-- TASK 2 : ADD INDEXES
-- ==========================================================

-- 51. B-Tree Index on enrollment_year

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);



-- 52. Composite UNIQUE Index

CREATE UNIQUE INDEX idx_enrollments_student_course
ON enrollments(student_id, course_id);



-- 53. Index on course_code

CREATE INDEX idx_course_code
ON courses(course_code);



-- 54. Re-run EXPLAIN

EXPLAIN FORMAT=JSON
SELECT
    s.first_name,
    s.last_name,
    c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;


-- ----------------------------------------------------------
-- COMMENT:
--
-- Before Index:
-- access_type = ALL
-- (Full Table Scan)
--
-- After Index:
-- access_type = ref/range
-- (Index Scan)
--
-- Query becomes faster because MySQL
-- uses idx_students_enrollment_year.
--
-- ==========================================================



-- ==========================================================
-- 55. Partial Index
-- ==========================================================

/*

MySQL does not support PostgreSQL-style
partial indexes.

Equivalent optimization can be simulated
using composite indexes.

Example:

CREATE INDEX idx_grade_student
ON enrollments(grade, student_id);

This helps queries searching for
grade IS NULL.

*/

CREATE INDEX idx_grade_student
ON enrollments(grade, student_id);



-- ==========================================================
-- TEST UNIQUE INDEX
-- ==========================================================

/*

Try inserting duplicate enrollment.

INSERT INTO enrollments
(student_id, course_id, enrollment_date, grade)
VALUES (1,1,CURDATE(),'A');

MySQL should throw Duplicate Entry error.

*/



-- ==========================================================
-- TASK 3 : N+1 PROBLEM DOCUMENTATION
-- ==========================================================

/*

N+1 Problem Example:

Query 1:

SELECT * FROM enrollments;

Suppose 100 enrollment rows are returned.

Then application executes:

SELECT first_name,last_name
FROM students
WHERE student_id=?;

100 times.

Total Queries:

1 + 100 = 101 Queries

This is called N+1 problem.

For 10,000 enrollments:

1 + 10000 = 10001 Queries

Huge performance issue.

*/


-- ==========================================================
-- SOLUTION USING SINGLE JOIN
-- ==========================================================

SELECT
    e.enrollment_id,
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade

FROM enrollments e

JOIN students s
ON e.student_id = s.student_id

JOIN courses c
ON e.course_id = c.course_id;



-- ==========================================================
-- PERFORMANCE COMPARISON NOTES
-- ==========================================================

/*

N+1 Version:
-----------------
1 Query for enrollments
+ N Queries for students

For 100 rows:
101 Queries

JOIN Version:
-----------------
Only 1 Query

Database Round Trips Reduced:
101 -> 1

Performance Improvement:
Very High

*/