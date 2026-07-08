"""
HANDS-ON 6 - Task 1: SQLAlchemy models mirroring college_db schema.
"""
from sqlalchemy import Column, Integer, String, Date, Numeric, ForeignKey, create_engine
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()


class Department(Base):
    __tablename__ = "departments"
    department_id = Column(Integer, primary_key=True)
    dept_name = Column(String(100), nullable=False)
    hod_name = Column(String(100))
    budget = Column(Numeric(12, 2))

    students = relationship("Student", back_populates="department")
    courses = relationship("Course", back_populates="department")
    professors = relationship("Professor", back_populates="department")


class Student(Base):
    __tablename__ = "students"
    student_id = Column(Integer, primary_key=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    date_of_birth = Column(Date)
    department_id = Column(Integer, ForeignKey("departments.department_id"))
    enrollment_year = Column(Integer)

    department = relationship("Department", back_populates="students")
    enrollments = relationship("Enrollment", back_populates="student")


class Course(Base):
    __tablename__ = "courses"
    course_id = Column(Integer, primary_key=True)
    course_name = Column(String(150), nullable=False)
    course_code = Column(String(20), unique=True)
    credits = Column(Integer)
    department_id = Column(Integer, ForeignKey("departments.department_id"))

    department = relationship("Department", back_populates="courses")
    enrollments = relationship("Enrollment", back_populates="course")


class Enrollment(Base):
    __tablename__ = "enrollments"
    enrollment_id = Column(Integer, primary_key=True)
    student_id = Column(Integer, ForeignKey("students.student_id"))
    course_id = Column(Integer, ForeignKey("courses.course_id"))
    enrollment_date = Column(Date)
    grade = Column(String(2))

    student = relationship("Student", back_populates="enrollments")
    course = relationship("Course", back_populates="enrollments")


class Professor(Base):
    __tablename__ = "professors"
    professor_id = Column(Integer, primary_key=True)
    prof_name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True)
    department_id = Column(Integer, ForeignKey("departments.department_id"))
    salary = Column(Numeric(10, 2))

    department = relationship("Department", back_populates="professors")


if __name__ == "__main__":
    # Fresh database for ORM-created tables
    engine = create_engine("postgresql+psycopg2://postgres:postgres@localhost/college_db_orm")
    Base.metadata.create_all(engine)
    print("Tables created in college_db_orm")
