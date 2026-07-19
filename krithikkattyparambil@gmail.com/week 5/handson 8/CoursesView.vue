<script setup>
import { ref, onMounted, computed } from 'vue';
import CourseCard from '../components/CourseCard.vue';
import { useEnrollmentStore } from '../stores/enrollment.js';

const courses = ref([]);
const searchTerm = ref('');
const store = useEnrollmentStore();

onMounted(() => {
  courses.value = [
    { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, grade: 'A' },
    { id: 2, name: 'Web Development', code: 'CS102', credits: 3, grade: 'A-' },
    { id: 3, name: 'Database Systems', code: 'CS201', credits: 4, grade: 'B+' },
    { id: 4, name: 'Operating Systems', code: 'CS202', credits: 4, grade: 'B' },
    { id: 5, name: 'Cloud Computing', code: 'CS301', credits: 3, grade: 'A' },
  ];
});

const filteredCourses = computed(() =>
  courses.value.filter((c) =>
    c.name.toLowerCase().includes(searchTerm.value.toLowerCase())
  )
);

function handleEnroll(course) {
  store.enroll(course);
}
</script>

<template>
  <section id="courses">
    <h2>Courses</h2>
    <input
      type="text"
      placeholder="Search courses..."
      v-model="searchTerm"
      aria-label="Search courses"
    >
    <div class="course-grid">
      <CourseCard
        v-for="course in filteredCourses"
        :key="course.id"
        v-bind="course"
        @enroll="handleEnroll"
      />
    </div>
  </section>
</template>
