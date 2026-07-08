// Toggles the mobile nav and keeps aria-expanded in sync (used in Hands-On 9 for a11y)
const hamburgerBtn = document.getElementById('hamburger-btn');
const mainNav = document.getElementById('main-nav');

hamburgerBtn.addEventListener('click', () => {
  const isOpen = mainNav.classList.toggle('open');
  hamburgerBtn.setAttribute('aria-expanded', String(isOpen));
});
