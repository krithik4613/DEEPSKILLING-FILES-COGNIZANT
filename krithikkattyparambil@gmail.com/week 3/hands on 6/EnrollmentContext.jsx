import { createContext, useState } from 'react';

// Task 2: Context API version of enrollment state.
// Superseded by Redux Toolkit in Task 3 (see src/store/), but kept here
// to demonstrate the prop-drilling-free Context pattern.

export const EnrollmentContext = createContext(null);

export function EnrollmentProvider({ children }) {
  const [enrolledCourses, setEnrolledCourses] = useState([]);

  function enroll(course) {
    setEnrolledCourses((prev) =>
      prev.some((c) => c.id === course.id) ? prev : [...prev, course]
    );
  }

  function remove(courseId) {
    setEnrolledCourses((prev) => prev.filter((c) => c.id !== courseId));
  }

  return (
    <EnrollmentContext.Provider value={{ enrolledCourses, enroll, remove }}>
      {children}
    </EnrollmentContext.Provider>
  );
}
