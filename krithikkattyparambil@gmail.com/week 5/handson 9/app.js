import { courses } from './data.js';

const courseGrid = document.querySelector('.course-grid');
const totalCreditsEl = document.getElementById('total-credits');
const resultsCountEl = document.getElementById('results-count');
const searchInput = document.getElementById('search-courses');
const sortBtn = document.getElementById('sort-credits-btn');
const selectedCourseEl = document.getElementById('selected-course');

function renderCourses(list) {
  courseGrid.innerHTML = '';
  const fragment = document.createDocumentFragment();

  list.forEach((course) => {
    const article = document.createElement('article');
    article.className = 'course-card';
    article.dataset.id = course.id;
    article.setAttribute('role', 'listitem');
    // a11y: tabindex + keydown below make cards reachable and operable by keyboard
    article.tabIndex = 0;
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

  // a11y: aria-live="polite" region announces the new count without stealing focus
  resultsCountEl.textContent = `${list.length} course${list.length === 1 ? '' : 's'} found`;
}

renderCourses(courses);

searchInput.addEventListener('input', (event) => {
  const term = event.target.value.toLowerCase();
  const filtered = courses.filter((course) =>
    course.name.toLowerCase().includes(term)
  );
  renderCourses(filtered);
});

sortBtn.addEventListener('click', () => {
  const sorted = [...courses].sort((a, b) => b.credits - a.credits);
  renderCourses(sorted);
});

function selectCourse(id) {
  const course = courses.find((c) => c.id === id);
  if (course) {
    selectedCourseEl.textContent = `Selected: ${course.name} — Grade: ${course.grade}`;
  }
}

// Mouse click via event delegation
courseGrid.addEventListener('click', (event) => {
  const card = event.target.closest('.course-card');
  if (card) selectCourse(Number(card.dataset.id));
});

// a11y: keyboard equivalent — Enter (and Space, per WAI-ARIA button pattern) on a
// focused card triggers the same action as a click
courseGrid.addEventListener('keydown', (event) => {
  const card = event.target.closest('.course-card');
  if (!card) return;
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault(); // stop Space from scrolling the page
    selectCourse(Number(card.dataset.id));
  }
});
