import { useEffect, useState } from 'react';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import CourseCard from './components/CourseCard.jsx';
import StudentProfile from './components/StudentProfile.jsx';

export default function App() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [enrolledCourses, setEnrolledCourses] = useState([]);

  // Fetch courses on mount (maps JSONPlaceholder posts to course-like objects)
  useEffect(() => {
    async function loadCourses() {
      try {
        setLoading(true);
        const res = await fetch('https://jsonplaceholder.typicode.com/posts?_limit=5');
        if (!res.ok) throw new Error(`Request failed: ${res.status}`);
        const posts = await res.json();
        const mapped = posts.map((post, index) => ({
          id: post.id,
          name: post.title.slice(0, 24),
          code: `CS${100 + index}`,
          credits: 3 + (index % 2),
          grade: 'TBD',
        }));
        setCourses(mapped);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    loadCourses();
  }, []);

  // Runs whenever `courses` changes — demonstrates the dependency array
  useEffect(() => {
    console.log('Courses updated');
    // An empty [] array here would run this only once (mount);
    // [courses] re-runs it every time the courses array changes.
  }, [courses]);

  function handleEnroll(courseId) {
    const course = courses.find((c) => c.id === courseId);
    if (course && !enrolledCourses.some((c) => c.id === courseId)) {
      setEnrolledCourses((prev) => [...prev, course]);
    }
  }

  const filteredCourses = courses.filter((c) =>
    c.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <>
      <Header siteName="Student Portal" enrolledCount={enrolledCourses.length} />

      <section id="hero">
        <h1>Welcome to the Student Portal</h1>
        <p>Browse, search, and enroll in your courses.</p>
      </section>

      <section id="courses">
        <h2>Courses</h2>

        <input
          type="text"
          placeholder="Search courses..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />

        {loading && <p>Loading...</p>}
        {error && <p className="error">Error: {error}</p>}

        <div className="course-grid">
          {filteredCourses.map((course) => (
            <CourseCard key={course.id} {...course} onEnroll={handleEnroll} />
          ))}
        </div>
      </section>

      <StudentProfile />

      <Footer />
    </>
  );
}
