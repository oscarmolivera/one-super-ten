import "animate.css/animate.css";
import AOS from "aos";
import "aos/dist/aos.css";
import PerfectScrollbar from 'perfect-scrollbar';
import 'perfect-scrollbar/css/perfect-scrollbar.css';

document.addEventListener("DOMContentLoaded", () => {
  AOS.init({
    // 👇 YOUR CUSTOM CONFIG
    offset: 120, // distance in px before element is revealed
    delay: 100, // delay in ms before animation starts
    duration: 800, // duration in ms
    easing: 'ease-in-out', // AOS built-in easing options
    once: true, // whether animation should happen only once
    mirror: false, // whether elements should animate out while scrolling past
    anchorPlacement: 'top-bottom', // defines trigger point relative to viewport
  });
});


// OPTIONAL: Auto-initialize scrollbar on a specific container after page load
document.addEventListener("DOMContentLoaded", () => {
  const container = document.querySelector('#scrollable-content');
  if (container) {
    new PerfectScrollbar(container);
  }
});