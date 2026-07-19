import { Component } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-student-profile',
  templateUrl: './student-profile.component.html',
  styleUrls: ['./student-profile.component.css'],
})
export class StudentProfileComponent {
  profileForm = new FormGroup({
    name: new FormControl('', [Validators.required]),
    email: new FormControl('', [Validators.required, Validators.email]),
    semester: new FormControl('', [
      Validators.required,
      Validators.min(1),
      Validators.max(8),
    ]),
  });

  onSubmit(): void {
    if (this.profileForm.valid) {
      console.log('Profile submitted:', this.profileForm.value);
    }
  }
}
