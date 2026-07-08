<script setup>
import { storeToRefs } from 'pinia';
import { useEnrollmentStore } from '../stores/enrollment.js';

const store = useEnrollmentStore();
// storeToRefs keeps reactivity when destructuring state/getters
// (plain destructuring like `const { enrolledCourses } = store` would break it)
const { enrolledCourses, totalCredits } = storeToRefs(store);
</script>

<template>
  <section id="profile">
    <h2>My Profile</h2>
    <p>Total credits enrolled: {{ totalCredits }}</p>

    <p v-if="enrolledCourses.length === 0">No courses enrolled yet.</p>

    <ul class="enrolled-list">
      <li v-for="course in enrolledCourses" :key="course.id">
        {{ course.name }} ({{ course.credits }} credits)
        <button type="button" @click="store.unenroll(course.id)">Remove</button>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.enrolled-list {
  list-style: none;
  max-width: 500px;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.enrolled-list li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  background: #fff;
  border: 1px solid #d9dee4;
  border-radius: 6px;
}

.enrolled-list button {
  padding: 0.3rem 0.7rem;
  border: none;
  background-color: #c0392b;
  color: #fff;
  border-radius: 4px;
  cursor: pointer;
}
</style>
