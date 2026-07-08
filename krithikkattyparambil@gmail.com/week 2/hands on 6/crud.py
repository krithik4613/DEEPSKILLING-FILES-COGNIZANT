"""
HANDS-ON 6 - Task 2 & 3: CRUD via SQLAlchemy session + fixing N+1 with joinedload.

echo=True logs every SQL statement -- used to count query counts below.
Without joinedload: READ all enrollments triggers 1 + N lazy-load queries (N+1).
With joinedload: same result in a single JOIN query.
"""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, joinedload
from models import Base, Department, Student, Course, Enrollment

engine = create_engine("postgresql+psycopg2://postgres:postgres@localhost/college_db_orm", echo=True)
Session = sessionmaker(bind=engine)
session = Session()


def seed_data():
    """Task 2: INSERT departments, students, courses, enrollments."""
    depts = [
        Department(dept_name="Computer Science", hod_name="Dr. Ramesh Kumar", budget=850000),
        Department(dept_name="Electronics", hod_name="Dr. Priya Nair", budget=620000),
        Department(dept_name="Mechanical", hod_name="Dr. Suresh Iyer", budget=540000),
    ]
    session.add_all(depts)
    session.commit()

    students = [
        Student(first_name="Arjun", last_name="Mehta", email="arjun.mehta@college.edu", department_id=1, enrollment_year=2022),
        Student(first_name="Priya", last_name="Suresh", email="priya.suresh@college.edu", department_id=1, enrollment_year=2022),
        Student(first_name="Rohan", last_name="Verma", email="rohan.verma@college.edu", department_id=2, enrollment_year=2021),
        Student(first_name="Sneha", last_name="Patel", email="sneha.patel@college.edu", department_id=3, enrollment_year=2023),
        Student(first_name="Vikram", last_name="Das", email="vikram.das@college.edu", department_id=1, enrollment_year=2022),
    ]
    session.add_all(students)
    session.commit()

    courses = [
        Course(course_name="Data Structures & Algorithms", course_code="CS101", credits=4, department_id=1),
        Course(course_name="Database Management Systems", course_code="CS102", credits=3, department_id=1),
        Course(course_name="Circuit Theory", course_code="EC101", credits=3, department_id=2),
    ]
    session.add_all(courses)
    session.commit()

    enrollments = [
        Enrollment(student_id=1, course_id=1, grade="A"),
        Enrollment(student_id=1, course_id=2, grade="B"),
        Enrollment(student_id=2, course_id=1, grade="B"),
        Enrollment(student_id=3, course_id=3, grade="A"),
    ]
    session.add_all(enrollments)
    session.commit()


def read_cs_students():
    """READ: students in Computer Science dept."""
    return session.query(Student).join(Department).filter(Department.dept_name == "Computer Science").all()


def read_enrollments_n_plus_1():
    """Lazy-loading version -- triggers N+1 (watch the echo=True log)."""
    enrollments = session.query(Enrollment).all()
    for e in enrollments:
        print(e.student.first_name, e.course.course_name)  # each access = 1 extra query


def read_enrollments_eager():
    """Task 3: eager loading -- collapses N+1 into a single JOIN query."""
    enrollments = session.query(Enrollment).options(
        joinedload(Enrollment.student), joinedload(Enrollment.course)
    ).all()
    for e in enrollments:
        print(e.student.first_name, e.course.course_name)


def update_student_year(email, new_year):
    student = session.query(Student).filter_by(email=email).first()
    student.enrollment_year = new_year
    session.commit()


def delete_enrollment(enrollment_id):
    enrollment = session.query(Enrollment).get(enrollment_id)
    session.delete(enrollment)
    session.commit()


if __name__ == "__main__":
    seed_data()
    read_cs_students()
    read_enrollments_n_plus_1()   # observe query count in log: N+1
    read_enrollments_eager()      # observe query count in log: 1
    session.close()

# Comment block: query count went from 13 (N+1) to 1 (joinedload)
