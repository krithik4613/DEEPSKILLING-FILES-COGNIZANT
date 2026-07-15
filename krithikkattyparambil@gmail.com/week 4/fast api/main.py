from fastapi import FastAPI
import models
from database import engine
from schemas import Student

models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="CTS Week 4 FastAPI",
    version="1.0"
)

students = []


@app.get("/")
def home():
    return {
        "message": "Welcome to FastAPI"
    }


@app.get("/students")
def get_students():
    return students


@app.post("/students")
def create_student(student: Student):

    new_student = student.model_dump()

    new_student["id"] = len(students) + 1

    students.append(new_student)

    return {
        "message": "Student Created",
        "student": new_student
    }


@app.put("/students/{student_id}")
def update_student(student_id: int, student: Student):

    for s in students:
        if s["id"] == student_id:
            s.update(student.model_dump())
            return {
                "message": "Student Updated",
                "student": s
            }

    return {
        "message": "Student Not Found"
    }


@app.delete("/students/{student_id}")
def delete_student(student_id: int):

    for s in students:
        if s["id"] == student_id:
            students.remove(s)
            return {
                "message": "Student Deleted"
            }

    return {
        "message": "Student Not Found"
    }