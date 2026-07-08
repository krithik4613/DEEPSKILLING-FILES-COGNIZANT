import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-course-card',
  templateUrl: './course-card.component.html',
  styleUrls: ['./course-card.component.css'],
})
export class CourseCardComponent {
  @Input() name = '';
  @Input() code = '';
  @Input() credits = 0;
  @Input() grade = '';
}
