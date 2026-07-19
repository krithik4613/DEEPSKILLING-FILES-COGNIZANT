import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  fetchAllCourses,
  selectCourses,
  selectCoursesLoading,
  selectCoursesError,
} from '../store/coursesSlice.js';

export default function CoursesPage() {
  const dispatch = useDispatch();
  const courses = useSelector(selectCourses);
  const loading = useSelector(selectCoursesLoading);
  const error = useSelector(selectCoursesError);

  useEffect(() => {
    dispatch(fetchAllCourses());
  }, [dispatch]);

  if (loading) return <p>Loading courses...</p>;
  if (error) return <p className="error">Error: {error}</p>;

  return (
    <section id="courses">
      <h2>Courses</h2>
      <div className="course-grid">
        {courses.map((course) => (
          <article className="course-card" key={course.id}>
            <h3>{course.name}</h3>
            <p>{course.code}</p>
            <span>{course.credits} credits</span>
          </article>
        ))}
      </div>
    </section>
  );
}
