import { useParams, Link } from 'react-router-dom';
import { initialCourses } from '../data/courses.js';

export default function CourseDetailPage() {
  const { courseId } = useParams();
  const course = initialCourses.find((c) => c.id === Number(courseId));

  if (!course) {
    return (
      <section id="course-detail">
        <p>Course not found.</p>
        <Link to="/courses">Back to Courses</Link>
      </section>
    );
  }

  return (
    <section id="course-detail">
      <h2>{course.name}</h2>
      <p>Code: {course.code}</p>
      <p>Credits: {course.credits}</p>
      <p>Grade: {course.grade}</p>
      <Link to="/courses">Back to Courses</Link>
    </section>
  );
}
