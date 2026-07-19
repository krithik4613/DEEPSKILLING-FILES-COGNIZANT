import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { initialCourses } from '../data/courses.js';
import { enroll } from '../store/enrollmentSlice.js';

export default function CoursesPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const filtered = initialCourses.filter((c) =>
    c.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  function handleEnroll(course) {
    dispatch(enroll(course));
    navigate('/profile'); // useNavigate: redirect after enrolling
  }

  return (
    <section id="courses">
      <h2>Courses</h2>
      <input
        type="text"
        placeholder="Search courses..."
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
      />
      <div className="course-grid">
        {filtered.map((course) => (
          <article className="course-card" key={course.id}>
            <Link to={`/courses/${course.id}`}>
              <h3>{course.name}</h3>
            </Link>
            <p>{course.code}</p>
            <span className="credits">{course.credits} credits</span>
            <button type="button" onClick={() => handleEnroll(course)}>
              Enroll
            </button>
          </article>
        ))}
      </div>
    </section>
  );
}
