export default function Header({ siteName, enrolledCount = 0 }) {
  return (
    <header className="app-header">
      <div className="site-name">{siteName}</div>
      <nav>
        <ul>
          <li><a href="#hero">Home</a></li>
          <li><a href="#courses">Courses</a></li>
          <li><a href="#profile">Profile</a></li>
        </ul>
      </nav>
      <span className="enrolled-badge">Enrolled: {enrolledCount}</span>
    </header>
  );
}
