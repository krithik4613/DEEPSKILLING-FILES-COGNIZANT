export default function CourseCard({ id, name, code, credits, grade, onEnroll }) {
  return (
    <article className="course-card">
      <h3>{name}</h3>
      <p>{code}</p>
      <span className="credits">{credits} credits</span>
      {grade && <span className="grade">Grade: {grade}</span>}
      {onEnroll && (
        <button type="button" onClick={() => onEnroll(id)}>
          Enroll
        </button>
      )}
    </article>
  );
}
