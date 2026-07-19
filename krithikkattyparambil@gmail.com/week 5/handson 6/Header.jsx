import { Link } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { selectEnrolledCount } from '../store/enrollmentSlice.js';

export default function Header() {
  const enrolledCount = useSelector(selectEnrolledCount);

  return (
    <header className="app-header">
      <div className="site-name">Student Portal</div>
      <nav>
        <ul>
          <li><Link to="/">Home</Link></li>
          <li><Link to="/courses">Courses</Link></li>
          <li><Link to="/profile">Profile</Link></li>
        </ul>
      </nav>
      <span className="enrolled-badge">Enrolled: {enrolledCount}</span>
    </header>
  );
}
