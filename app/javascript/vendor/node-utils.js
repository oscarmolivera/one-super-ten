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

import '../vendor/morris-global';

document.addEventListener("turbo:load", () => {
  const lineChart = document.getElementById('morris-line-chart');
  if (lineChart && window.Morris && typeof window.Morris.Line === 'function') {
    new window.Morris.Line({
      element: 'morris-line-chart',
      data: [
        { year: '2019', value: 10 },
        { year: '2020', value: 25 },
        { year: '2021', value: 30 },
        { year: '2022', value: 20 },
        { year: '2023', value: 35 }
      ],
      xkey: 'year',
      ykeys: ['value'],
      labels: ['Value'],
      lineColors: ['#007bff'],
      resize: true
    });
  }
});
import '../vendor/owl-caroussel';
// Initialize Owl Carousel
document.addEventListener("turbo:load", () => {
  const owl = document.querySelector('.owl-carousel');
  if (owl && typeof jQuery !== 'undefined') {
    const images = owl.querySelectorAll("img");

    // Esperar que todas las imágenes se carguen
    let loadedCount = 0;
    images.forEach((img) => {
      if (img.complete) {
        loadedCount++;
      } else {
        img.addEventListener("load", () => {
          loadedCount++;
          if (loadedCount === images.length) initOwl();
        });
      }
    });

    // En caso todas estén ya cargadas
    if (loadedCount === images.length) initOwl();

    function initOwl() {
      jQuery(owl).owlCarousel({
        loop: true,
        margin: 10,
        nav: true,
        dots: true,
        autoplay: true,
        autoplayTimeout: 3000,
        items: 1
      });
    }
  }
});

import '../vendor/vis';
import '../vendor/labella';
import '../vendor/flexslider';

document.addEventListener('turbo:load', () => {
  $('.flexslider').flexslider({
    animation: 'slide',
    controlNav: true,
    directionNav: true
  });
});

import '../vendor/prism';
document.addEventListener('turbo:load', () => {
  Prism.highlightAll();
});