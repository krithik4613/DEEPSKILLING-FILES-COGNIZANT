import { courses as localCourses } from './data.js';

const API_BASE = 'https://jsonplaceholder.typicode.com';

/* ---------------------------------------------------------
   Task 1: Promises and async/await
   --------------------------------------------------------- */

// .then()-based version
function fetchUserThen(id) {
  return fetch(`${API_BASE}/users/${id}`)
    .then((res) => res.json())
    .then((user) => {
      console.log('[.then] User name:', user.name);
      return user;
    });
}

// async/await version with try/catch
async function fetchUser(id) {
  try {
    const res = await fetch(`${API_BASE}/users/${id}`);
    const user = await res.json();
    console.log('[async/await] User name:', user.name);
    return user;
  } catch (err) {
    console.error('fetchUser failed:', err.message);
  }
}

// Simulated network delay returning local course data
function fetchAllCourses() {
  return new Promise((resolve) => {
    setTimeout(() => resolve(localCourses), 1000);
  });
}

async function loadCourses() {
  const statusEl = document.getElementById('courses-status');
  const grid = document.querySelector('.course-grid');

  statusEl.textContent = 'Loading courses...';
  const courses = await fetchAllCourses();
  statusEl.textContent = '';

  grid.innerHTML = courses
    .map(
      (c) => `
      <article class="course-card">
        <h3>${c.name}</h3>
        <p>${c.code}</p>
        <span class="credits">${c.credits} credits</span>
      </article>`
    )
    .join('');
}

// Promise.all demo
async function loadTwoUsers() {
  const [user1, user2] = await Promise.all([fetchUserThen(1), fetchUserThen(2)]);
  console.log('Promise.all results:', user1.name, user2.name);
}

loadCourses();
fetchUser(1);
loadTwoUsers();

/* ---------------------------------------------------------
   Task 2: Fetch API with error handling
   --------------------------------------------------------- */

async function apiFetch(url) {
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`Request failed: ${res.status} ${res.statusText}`);
  }
  return res.json();
}

async function loadNotifications(url = `${API_BASE}/posts?_limit=5`) {
  const statusEl = document.getElementById('notif-status');
  const errorBox = document.getElementById('notif-error');
  const errorMsg = document.getElementById('notif-error-message');
  const list = document.querySelector('.notif-list');

  errorBox.classList.add('hidden');
  statusEl.textContent = 'Loading notifications...';
  list.innerHTML = '';

  try {
    const posts = await apiFetch(url);
    statusEl.textContent = '';
    list.innerHTML = posts
      .map(
        (p) => `
        <div class="notif-card">
          <h4>${p.title}</h4>
          <p>${p.body}</p>
        </div>`
      )
      .join('');
  } catch (err) {
    statusEl.textContent = '';
    errorMsg.textContent = `Couldn't load notifications: ${err.message}`;
    errorBox.classList.remove('hidden');
  }
}

document.getElementById('retry-btn').addEventListener('click', () => {
  // Retry the valid endpoint after a simulated failure
  loadNotifications(`${API_BASE}/posts?_limit=5`);
});

loadNotifications();

// Uncomment to simulate a 404 error on load:
// loadNotifications(`${API_BASE}/nonexistent`);

/* ---------------------------------------------------------
   Task 3: Introduction to Axios
   --------------------------------------------------------- */

// axios auto-parses JSON and throws automatically on non-2xx responses,
// so no manual response.ok check is required (unlike fetch).
async function apiFetchAxios(url, params = {}) {
  const response = await axios.get(url, { params, timeout: 5000 });
  return response.data;
}

axios.interceptors.request.use((config) => {
  console.log(`API call started: ${config.url}`);
  return config;
});

async function loadUser1Posts() {
  try {
    const posts = await apiFetchAxios(`${API_BASE}/posts`, { userId: 1 });
    console.log(`User 1 has ${posts.length} posts (via Axios)`);
  } catch (err) {
    console.error('Axios request failed:', err.message);
  }
}

loadUser1Posts();

/*
  fetch vs axios — 3 key differences:
  1. axios auto-parses JSON; fetch requires an explicit .json() call.
  2. axios rejects automatically on non-2xx status codes; fetch only
     rejects on network failure, so response.ok must be checked manually.
  3. axios supports request/response interceptors and a built-in
     `timeout` option out of the box; fetch needs AbortController for timeouts.
*/
