import { Link } from 'react-router-dom';

export default function HomePage() {
  return (
    <section id="hero">
      <h1>Welcome to the Student Portal</h1>
      <p>Browse your courses, manage your profile, and track enrollment.</p>
      <Link to="/courses">
        <button type="button">Explore Courses</button>
      </Link>
    </section>
  );
}
