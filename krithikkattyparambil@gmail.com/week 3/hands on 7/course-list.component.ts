import { Component, OnInit } from '@angular/core';
import { Course, CourseService } from '../course.service';

@Component({
  selector: 'app-course-list',
  templateUrl: './course-list.component.html',
  styleUrls: ['./course-list.component.css'],
})
export class CourseListComponent implements OnInit {
  courses: Course[] = [];
  searchTerm = '';
  loading = false;

  constructor(private courseService: CourseService) {}

  ngOnInit(): void {
    this.loading = true;
    this.courseService.getCourses().subscribe({
      next: (courses) => {
        this.courses = courses;
        this.loading = false;
      },
      error: () => {
        this.loading = false;
      },
    });
  }

  get filteredCourses(): Course[] {
    return this.courses.filter((c) =>
      c.name.toLowerCase().includes(this.searchTerm.toLowerCase())
    );
  }
}
