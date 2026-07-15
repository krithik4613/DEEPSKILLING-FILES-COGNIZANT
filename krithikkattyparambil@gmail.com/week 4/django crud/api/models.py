from django.db import models


class Student(models.Model):

    name = models.CharField(max_length=100)

    department = models.CharField(max_length=50)

    age = models.IntegerField()

    def __str__(self):
        return self.name