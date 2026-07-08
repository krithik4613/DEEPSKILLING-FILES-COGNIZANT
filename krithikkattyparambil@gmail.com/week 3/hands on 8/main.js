import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';
import './style.css';

const app = createApp(App);

app.use(createPinia());
app.use(router);

// Global error handler (used again in Hands-On 10)
app.config.errorHandler = (err, instance, info) => {
  console.error('Global Vue error:', err, info);
};

app.mount('#app');
