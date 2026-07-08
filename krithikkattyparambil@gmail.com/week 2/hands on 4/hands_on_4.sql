-- ============================================
-- HANDS-ON 4: Query Optimisation - Indexes & EXPLAIN
-- ============================================

-- ===== TASK 1: Baseline (no indexes) =====

EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- Baseline result (example, will vary by dataset size):
-- Seq Scan on students (cost=0.00..1.20 rows=4) -- no index on enrollment_year yet


-- ===== TASK 2: Add Indexes =====

CREATE INDEX idx_students_enrollment_year ON students(enrollment_year);

-- Composite unique index: speeds lookups AND blocks duplicate enrollments
CREATE UNIQUE INDEX idx_enrollments_student_course ON enrollments(student_id, course_id);

CREATE INDEX idx_courses_course_code ON courses(course_code);

-- Re-run EXPLAIN, compare
EXPLAIN
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- After indexing: Seq Scan on students -> Index Scan using idx_students_enrollment_year

-- Partial index: only rows needing grade evaluation
CREATE INDEX idx_enrollments_ungraded ON enrollments(student_id) WHERE grade IS NULL;
