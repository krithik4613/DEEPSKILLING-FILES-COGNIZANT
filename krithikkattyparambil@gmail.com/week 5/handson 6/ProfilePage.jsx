import { useSelector, useDispatch } from 'react-redux';
import { selectEnrolledCourses, unenroll } from '../store/enrollmentSlice.js';

export default function ProfilePage() {
  const enrolledCourses = useSelector(selectEnrolledCourses);
  const dispatch = useDispatch();

  return (
    <section id="profile">
      <h2>My Profile</h2>
      <h3>Enrolled Courses ({enrolledCourses.length})</h3>
      {enrolledCourses.length === 0 && <p>No courses enrolled yet.</p>}
      <ul className="enrolled-list">
        {enrolledCourses.map((course) => (
          <li key={course.id}>
            {course.name} ({course.credits} credits)
            <button type="button" onClick={() => dispatch(unenroll(course.id))}>
              Remove
            </button>
          </li>
        ))}
      </ul>
    </section>
  );
}
