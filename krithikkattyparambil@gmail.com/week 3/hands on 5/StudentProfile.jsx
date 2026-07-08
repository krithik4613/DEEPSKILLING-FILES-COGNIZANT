import { useState } from 'react';

export default function StudentProfile() {
  const [profile, setProfile] = useState({
    name: '',
    email: '',
    semester: '',
  });

  function handleChange(event) {
    const { name, value } = event.target;
    setProfile((prev) => ({ ...prev, [name]: value }));
  }

  return (
    <section id="profile" className="profile-section">
      <h2>Student Profile</h2>
      <form onSubmit={(e) => e.preventDefault()}>
        <label>
          Name
          <input name="name" value={profile.name} onChange={handleChange} />
        </label>
        <label>
          Email
          <input name="email" type="email" value={profile.email} onChange={handleChange} />
        </label>
        <label>
          Semester
          <input name="semester" type="number" min="1" max="8" value={profile.semester} onChange={handleChange} />
        </label>
      </form>
      <p className="preview">
        Preview: {profile.name || '—'} · {profile.email || '—'} · Semester {profile.semester || '—'}
      </p>
    </section>
  );
}
