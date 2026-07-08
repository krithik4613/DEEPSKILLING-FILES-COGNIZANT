import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useEnrollmentStore = defineStore('enrollment', () => {
  const enrolledCourses = ref([]);

  const totalCredits = computed(() =>
    enrolledCourses.value.reduce((sum, c) => sum + c.credits, 0)
  );

  function enroll(course) {
    const alreadyEnrolled = enrolledCourses.value.some((c) => c.id === course.id);
    if (!alreadyEnrolled) {
      enrolledCourses.value.push(course);
    }
  }

  function unenroll(courseId) {
    enrolledCourses.value = enrolledCourses.value.filter((c) => c.id !== courseId);
  }

  // Advanced pattern (Hands-On 10): fetch + enroll in a single async action
  async function fetchAndEnroll(courseId, fetchFn) {
    const course = await fetchFn(courseId);
    enroll(course);
  }

  function $reset() {
    enrolledCourses.value = [];
  }

  return { enrolledCourses, totalCredits, enroll, unenroll, fetchAndEnroll, $reset };
});
