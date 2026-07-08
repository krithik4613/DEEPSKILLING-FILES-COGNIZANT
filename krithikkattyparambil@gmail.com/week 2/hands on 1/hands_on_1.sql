-- ============================================
-- HANDS-ON 1: Schema Design & Core SQL (DDL)
-- Student Course Registration System
-- ============================================

-- Create database
CREATE DATABASE college_db;

-- ===== TASK 1: Create Tables =====
-- departments first, others reference it

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT REFERENCES departments(department_id),
    enrollment_year INT
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT REFERENCES departments(department_id)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE,
    grade CHAR(2)
);

CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT REFERENCES departments(department_id),
    salary DECIMAL(10,2)
);

-- Verify: \d students   (or DESCRIBE students; in MySQL)


-- ===== TASK 2: Normalisation Analysis =====

-- 1NF: every column holds a single atomic value.
-- Violation example: storing '9876543210,9998887777' in one phone field.

-- 2NF: enrollments has candidate key (student_id, course_id).
-- grade and enrollment_date depend on BOTH columns together, not just one -> satisfies 2NF.

-- 3NF: students.department_id points to departments, not dept_name directly.
-- Storing dept_name in students would be a transitive dependency (violates 3NF)
-- because dept_name depends on department_id, which depends on student_id.

-- enrollments 3NF check: grade depends only on (student_id, course_id) together,
-- no column here depends on another non-key column -> no transitive dependency.


-- ===== TASK 3: Alter and Extend Schema =====

ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

ALTER TABLE courses ADD COLUMN max_seats INT DEFAULT 60;

ALTER TABLE enrollments
    ADD CONSTRAINT chk_grade CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

-- PostgreSQL rename column
ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;
-- MySQL equivalent: ALTER TABLE departments CHANGE hod_name head_of_dept VARCHAR(100);

-- Rollback simulation: drop the column added earlier
ALTER TABLE students DROP COLUMN phone_number;

-- Verify changes (PostgreSQL)
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'students';
