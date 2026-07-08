import { courses } from './data.js';

/* ---------------------------------------------------------
   Task 1: ES6+ syntax practice
   --------------------------------------------------------- */

// Destructuring inside a loop
for (const { name, credits } of courses) {
  console.log(`${name} is worth ${credits} credits`);
}

// map() -> formatted strings
const formatted = courses.map(
  ({ code, name, credits }) => `${code} — ${name} (${credits} credits)`
);
console.log('Formatted courses:', formatted);

// filter() -> courses with credits >= 4
const heavyCourses = courses.filter((course) => course.credits >= 4);
console.log('Courses with 4+ credits:', heavyCourses.length);

// reduce() -> total credits
const totalCreditsValue = courses.reduce((sum, course) => sum + course.credits, 0);
console.log('Total credits enrolled:', totalCreditsValue);

/* ---------------------------------------------------------
   Task 2: DOM selection & dynamic rendering
   --------------------------------------------------------- */

const courseGrid = document.querySelector('.course-grid');
const totalCreditsEl = document.getElementById('total-credits');

function renderCourses(list) {
  // Clear before re-rendering to avoid duplicate cards
  courseGrid.innerHTML = '';

  const fragment = document.createDocumentFragment();

  list.forEach((course) => {
    const article = document.createElement('article');
    article.className = 'course-card';
    article.dataset.id = course.id;
    article.tabIndex = 0; // keyboard accessible (see Hands-On 9)
    article.innerHTML = `
      <h3>${course.name}</h3>
      <p>${course.code}</p>
      <span class="credits">${course.credits} credits</span>
    `;
    fragment.appendChild(article);
  });

  courseGrid.appendChild(fragment);

  const sumCredits = list.reduce((sum, c) => sum + c.credits, 0);
  totalCreditsEl.textContent = `Total credits: ${sumCredits}`;
}

renderCourses(courses);

/* ---------------------------------------------------------
   Task 3: Event listeners & interactivity
   --------------------------------------------------------- */

const searchInput = document.getElementById('search-courses');
const sortBtn = document.getElementById('sort-credits-btn');
const selectedCourseEl = document.getElementById('selected-course');

// Live search filter
searchInput.addEventListener('input', (event) => {
  const term = event.target.value.toLowerCase();
  const filtered = courses.filter((course) =>
    course.name.toLowerCase().includes(term)
  );
  renderCourses(filtered);
});

// Sort by credits (descending)
sortBtn.addEventListener('click', () => {
  const sorted = [...courses].sort((a, b) => b.credits - a.credits);
  renderCourses(sorted);
});

// Event delegation: one listener on the grid handles all card clicks
courseGrid.addEventListener('click', (event) => {
  const card = event.target.closest('.course-card');
  if (!card) return;

  const course = courses.find((c) => c.id === Number(card.dataset.id));
  if (course) {
    selectedCourseEl.textContent = `Selected: ${course.name} — Grade: ${course.grade}`;
  }
});

// Keyboard accessibility: Enter on a focused card acts like a click
courseGrid.addEventListener('keydown', (event) => {
  if (event.key === 'Enter') {
    const card = event.target.closest('.course-card');
    if (card) card.click();
  }
});
