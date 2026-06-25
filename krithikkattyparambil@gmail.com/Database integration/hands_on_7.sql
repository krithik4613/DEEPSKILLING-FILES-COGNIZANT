# ==========================================================
# HANDS-ON 7
# Migrations & Versioning
# ==========================================================

from sqlalchemy import *
from sqlalchemy.orm import *

Base = declarative_base()

# ==========================================================
# TASK 1
# Initial Models
# ==========================================================

class Department(Base):
    __tablename__ = "departments"

    department_id = Column(Integer, primary_key=True)
    dept_name = Column(String(100))

    students = relationship(
        "Student",
        back_populates="department"
    )


class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True)
    first_name = Column(String(50))
    last_name = Column(String(50))
    email = Column(String(100))
    enrollment_year = Column(Integer)

    # Added in Migration 2
    is_active = Column(Boolean, default=True)

    department_id = Column(
        Integer,
        ForeignKey("departments.department_id")
    )

    department = relationship(
        "Department",
        back_populates="students"
    )

    enrollments = relationship(
        "Enrollment",
        back_populates="student"
    )


class Course(Base):
    __tablename__ = "courses"

    course_id = Column(Integer, primary_key=True)
    course_name = Column(String(100))
    course_code = Column(String(20))

    enrollments = relationship(
        "Enrollment",
        back_populates="course"
    )


class Enrollment(Base):
    __tablename__ = "enrollments"

    enrollment_id = Column(Integer, primary_key=True)

    student_id = Column(
        Integer,
        ForeignKey("students.student_id")
    )

    course_id = Column(
        Integer,
        ForeignKey("courses.course_id")
    )

    student = relationship(
        "Student",
        back_populates="enrollments"
    )

    course = relationship(
        "Course",
        back_populates="enrollments"
    )


class Professor(Base):
    __tablename__ = "professors"

    professor_id = Column(Integer, primary_key=True)
    professor_name = Column(String(100))
    salary = Column(Float)


# ==========================================================
# TASK 2
# New Table Added Through Migration
# ==========================================================

class CourseSchedule(Base):
    __tablename__ = "course_schedules"

    schedule_id = Column(Integer, primary_key=True)

    course_id = Column(
        Integer,
        ForeignKey("courses.course_id")
    )

    day_of_week = Column(String(20))
    start_time = Column(String(20))
    end_time = Column(String(20))


# ==========================================================
# TASK 3
# Migration Comments
# ==========================================================

"""
Migration 1:
Created tables:
- departments
- students
- courses
- enrollments
- professors

Migration 2:
Added column:
- students.is_active

Migration 3:
Created table:
- course_schedules

Rollback:
- downgrade -1 removes latest migration
- downgrade base removes all migrations
- upgrade head reapplies all migrations
"""

print("Hands-On 7 Completed")