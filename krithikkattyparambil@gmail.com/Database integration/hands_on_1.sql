
-- TASK 1: CREATE DATABASE AND TABLES

CREATE DATABASE college_db;
USE college_db;

-- Create Departments Table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

-- Create Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- Create Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- Create Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);

-- Create Professors Table
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- Verify Tables
SHOW TABLES;

-- TASK 2: NORMALISATION ANALYSIS (1NF, 2NF, 3NF)

-- 1NF:
-- All columns contain atomic values.
-- Example violation: storing multiple phone numbers
-- in a single column such as '9876543210,9876543211'.

-- 2NF:
-- All non-key attributes are fully dependent on
-- the primary key.
-- Example: In enrollments table, enrollment_date
-- and grade depend on both student and course details.

-- 3NF:
-- No transitive dependencies exist.
-- Department details are stored separately in
-- departments table and referenced using department_id.

-- Storing dept_name directly in students table
-- would violate 3NF because dept_name depends on
-- department_id, not directly on student_id.

-- Enrollments table satisfies 3NF because all
-- non-key attributes depend only on enrollment_id.

-- TASK 3: ALTER AND EXTEND SCHEMA

-- Add phone number column to students table
ALTER TABLE students
ADD phone_number VARCHAR(15);

-- Add max_seats column to courses table
ALTER TABLE courses
ADD max_seats INT DEFAULT 60;

-- Add CHECK constraint for grade
ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

-- Rename hod_name to head_of_dept
ALTER TABLE departments
RENAME COLUMN hod_name TO head_of_dept;

-- Drop phone_number column (schema rollback)
ALTER TABLE students
DROP COLUMN phone_number;

-- Verify final structure
DESC departments;
DESC students;
DESC courses;
DESC enrollments;
DESC professors;