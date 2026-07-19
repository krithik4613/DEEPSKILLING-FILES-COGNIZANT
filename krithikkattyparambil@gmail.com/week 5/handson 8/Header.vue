<script setup>
import { useEnrollmentStore } from '../stores/enrollment.js';

const store = useEnrollmentStore();
</script>

<template>
  <header class="app-header">
    <div class="site-name">Student Portal</div>
    <nav aria-label="Main navigation">
      <RouterLink to="/">Home</RouterLink>
      <RouterLink to="/courses">Courses</RouterLink>
      <RouterLink to="/profile">Profile</RouterLink>
    </nav>
    <span class="enrolled-badge">Enrolled: {{ store.enrolledCourses.length }}</span>
  </header>
</template>
