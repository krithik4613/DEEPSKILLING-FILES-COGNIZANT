from sqlalchemy import *
from sqlalchemy.orm import *

# ==========================================================
# TASK 1 : SQLAlchemy - Define Models and Connect
# Tasks 75 - 79
# ==========================================================

# Database Connection

engine = create_engine(
    "mysql+mysqlconnector://root:YOUR_PASSWORD@localhost/college_db_orm",
    echo=True
)

Base = declarative_base()

# ---------------------------
# Department Model
# ---------------------------

class Department(Base):
    __tablename__ = "departments"

    department_id = Column(Integer, primary_key=True)
    dept_name = Column(String(100))

    students = relationship(
        "Student",
        back_populates="department"
    )


# ---------------------------
# Student Model
# ---------------------------

class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True)
    first_name = Column(String(50))
    last_name = Column(String(50))
    email = Column(String(100))
    enrollment_year = Column(Integer)

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


# ---------------------------
# Course Model
# ---------------------------

class Course(Base):
    __tablename__ = "courses"

    course_id = Column(Integer, primary_key=True)
    course_name = Column(String(100))
    course_code = Column(String(20))

    enrollments = relationship(
        "Enrollment",
        back_populates="course"
    )


# ---------------------------
# Enrollment Model
# ---------------------------

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


# ---------------------------
# Professor Model
# ---------------------------

class Professor(Base):
    __tablename__ = "professors"

    professor_id = Column(Integer, primary_key=True)
    professor_name = Column(String(100))
    salary = Column(Float)


# Create Tables

Base.metadata.create_all(engine)

print("\nTASK 1 COMPLETED")
print("All Tables Created Successfully")


# ==========================================================
# TASK 2 : CRUD Operations via ORM
# Tasks 80 - 86
# ==========================================================

Session = sessionmaker(bind=engine)
session = Session()

# Insert Departments

d1 = Department(dept_name="Computer Science")
d2 = Department(dept_name="Mechanical")
d3 = Department(dept_name="Electronics")

session.add_all([d1, d2, d3])
session.commit()

# Insert Students

s1 = Student(
    first_name="Krithik",
    last_name="Rajesh",
    email="krithik@gmail.com",
    enrollment_year=2022,
    department=d1
)

s2 = Student(
    first_name="Arun",
    last_name="Kumar",
    email="arun@gmail.com",
    enrollment_year=2021,
    department=d1
)

s3 = Student(
    first_name="Rahul",
    last_name="Raj",
    email="rahul@gmail.com",
    enrollment_year=2022,
    department=d2
)

s4 = Student(
    first_name="Ajay",
    last_name="K",
    email="ajay@gmail.com",
    enrollment_year=2023,
    department=d3
)

s5 = Student(
    first_name="Priya",
    last_name="S",
    email="priya@gmail.com",
    enrollment_year=2022,
    department=d1
)

session.add_all([s1, s2, s3, s4, s5])
session.commit()

# Insert Courses

c1 = Course(
    course_name="Database Management",
    course_code="CS101"
)

c2 = Course(
    course_name="Python Programming",
    course_code="CS102"
)

c3 = Course(
    course_name="Artificial Intelligence",
    course_code="CS103"
)

session.add_all([c1, c2, c3])
session.commit()

# Insert Enrollments

e1 = Enrollment(student=s1, course=c1)
e2 = Enrollment(student=s2, course=c2)
e3 = Enrollment(student=s3, course=c1)
e4 = Enrollment(student=s5, course=c3)

session.add_all([e1, e2, e3, e4])
session.commit()

# Read Students

print("\nComputer Science Students")

students = session.query(Student)\
.join(Department)\
.filter(
Department.dept_name == "Computer Science"
).all()

for s in students:
    print(s.first_name, s.last_name)

# Read Enrollment Details

print("\nEnrollment Details")

enrollments = session.query(Enrollment).all()

for e in enrollments:
    print(
        e.student.first_name,
        "->",
        e.course.course_name
    )

# Update Student

student = session.query(Student)\
.filter_by(
email="krithik@gmail.com"
).first()

student.enrollment_year = 2024

session.commit()

print("\nStudent Updated")

# Delete Enrollment

enrollment = session.query(Enrollment).first()

session.delete(enrollment)

session.commit()

print("Enrollment Deleted")

print("\nTASK 2 COMPLETED")


# ==========================================================
# TASK 3 : Eager Loading to Fix N+1 Problem
# Tasks 87 - 90
# ==========================================================

print("\nUsing joinedload")

enrollments = session.query(
    Enrollment
).options(
    joinedload(Enrollment.student),
    joinedload(Enrollment.course)
).all()

for e in enrollments:
    print(
        e.student.first_name,
        "->",
        e.course.course_name
    )

"""
Comparison:

Without joinedload:
1 query for enrollments
+ multiple queries for students and courses.

This creates the N+1 problem.

With joinedload:
Only one JOIN query executes.

Performance improves significantly.
"""

print("\nTASK 3 COMPLETED")

session.close()

print("\nHands-On 6 Completed Successfully")