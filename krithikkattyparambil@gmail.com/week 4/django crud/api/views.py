from rest_framework.response import Response
from rest_framework.decorators import api_view

students = [
    {
        "id": 1,
        "name": "Abinithin",
        "department": "CSE",
        "age": 20
    },
    {
        "id": 2,
        "name": "Balaji",
        "department": "ECE",
        "age": 21
    }
]


@api_view(["GET"])
def get_students(request):
    return Response(students)


@api_view(["POST"])
def add_student(request):

    student = request.data

    student["id"] = len(students) + 1

    students.append(student)

    return Response(student)


@api_view(["PUT"])
def update_student(request, student_id):

    for student in students:
        if student["id"] == student_id:
            student.update(request.data)
            return Response(student)

    return Response({"message": "Student not found"})


@api_view(["DELETE"])
def delete_student(request, student_id):

    for student in students:
        if student["id"] == student_id:
            students.remove(student)
            return Response({"message": "Student deleted"})

    return Response({"message": "Student not found"})