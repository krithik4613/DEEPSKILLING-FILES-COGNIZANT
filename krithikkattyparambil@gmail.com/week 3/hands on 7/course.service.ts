import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Course {
  id: number;
  name: string;
  code: string;
  credits: number;
  grade: string;
}

interface Post {
  id: number;
  title: string;
}

@Injectable({
  providedIn: 'root', // singleton service shared across the whole app
})
export class CourseService {
  private readonly apiUrl = 'https://jsonplaceholder.typicode.com/posts?_limit=5';

  constructor(private http: HttpClient) {}

  getCourses(): Observable<Course[]> {
    return new Observable<Course[]>((subscriber) => {
      this.http.get<Post[]>(this.apiUrl).subscribe({
        next: (posts) => {
          const courses: Course[] = posts.map((post, index) => ({
            id: post.id,
            name: post.title.slice(0, 24),
            code: `CS${100 + index}`,
            credits: 3 + (index % 2),
            grade: 'TBD',
          }));
          subscriber.next(courses);
          subscriber.complete();
        },
        error: (err) => subscriber.error(err),
      });
    });
  }
}
