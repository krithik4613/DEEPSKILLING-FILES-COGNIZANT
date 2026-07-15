from django.urls import path

from .views import (
    get_students,
    add_student,
    update_student,
    delete_student,
)

urlpatterns = [

    path("students/", get_students),

    path("students/add/", add_student),

    path("students/update/<int:student_id>/", update_student),

    path("students/delete/<int:student_id>/", delete_student),

]