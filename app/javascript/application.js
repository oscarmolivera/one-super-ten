// Entry point for the build script in your package.json
import "./vendor/jquery"
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import AOS from "aos";


document.addEventListener("DOMContentLoaded", () => {
  AOS.init({
    offset: 120, // distance in px before element is revealed
    delay: 100, // delay in ms before animation starts
    duration: 800, // duration in ms
    easing: 'ease-in-out', // AOS built-in easing options
    once: true, // whether animation should happen only once
    mirror: false, // whether elements should animate out while scrolling past
    anchorPlacement: 'top-bottom', // defines trigger point relative to viewport
  });
});