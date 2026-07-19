<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useEnrollmentStore } from '../stores/enrollment.js';

const route = useRoute();
const router = useRouter();
const store = useEnrollmentStore();

const allCourses = [
  { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, grade: 'A' },
  { id: 2, name: 'Web Development', code: 'CS102', credits: 3, grade: 'A-' },
  { id: 3, name: 'Database Systems', code: 'CS201', credits: 4, grade: 'B+' },
  { id: 4, name: 'Operating Systems', code: 'CS202', credits: 4, grade: 'B' },
  { id: 5, name: 'Cloud Computing', code: 'CS301', credits: 3, grade: 'A' },
];

const course = ref(null);

onMounted(() => {
  course.value = allCourses.find((c) => c.id === Number(route.params.id));
});

function handleEnroll() {
  if (course.value) {
    store.enroll(course.value);
    router.push('/profile'); // programmatic navigation after enrolling
  }
}
</script>

<template>
  <section id="course-detail">
    <div v-if="course">
      <h2>{{ course.name }}</h2>
      <p>Code: {{ course.code }}</p>
      <p>Credits: {{ course.credits }}</p>
      <p>Grade: {{ course.grade }}</p>
      <button type="button" @click="handleEnroll">Enroll</button>
    </div>
    <p v-else>Course not found.</p>
    <RouterLink to="/courses">Back to Courses</RouterLink>
  </section>
</template>
