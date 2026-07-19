<script setup>
defineProps({
  id: Number,
  name: String,
  code: String,
  credits: Number,
  grade: String,
});

const emit = defineEmits(['enroll']);
</script>

<template>
  <article class="course-card" tabindex="0">
    <RouterLink :to="`/courses/${id}`">
      <h3>{{ name }}</h3>
    </RouterLink>
    <p>{{ code }}</p>
    <span class="credits">{{ credits }} credits</span>
    <button type="button" @click="emit('enroll', { id, name, code, credits, grade })">
      Enroll
    </button>
  </article>
</template>

<style scoped>
h3 { color: #1f3a5f; }
</style>
