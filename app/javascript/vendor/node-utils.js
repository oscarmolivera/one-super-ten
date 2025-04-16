//Aniimate.css - AOS
import "animate.css/animate.css";
import AOS from "aos";
import "aos/dist/aos.css";
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

// Dropzone
import '../vendor/dropzone';
document.addEventListener("turbo:load", () => {
  const el = document.getElementById("my-dropzone")
  if (el) {
    new Dropzone(el, {
      url: "/upload", // Replace with your actual upload path
      paramName: "file", // The name that will be used to transfer the file
      maxFilesize: 2, // MB
      acceptedFiles: ".jpg,.png,.gif,.pdf",
      addRemoveLinks: true,
      dictDefaultMessage: "Drop files here or click to upload"
    })
  }
})

//Bootstrap Markdown
import '../vendor/bootstrap3-editable/bootstrap-markdown.min.css'
import '../vendor/bootstrap3-editable/bootstrap-markdown.js'

document.addEventListener("turbo:load", () => {
  const el = document.getElementById("markdown-editor")
  if (el) {
    $(el).markdown({
      autofocus: true,
      savable: true
    })
  }
  const content = $('#markdown-editor').val()
  console.log("Markdown content:", content)
})
// SweetAlert
import swal from 'sweetalert'

document.addEventListener("turbo:load", () => {
  // Example bind
  const trigger = document.getElementById('sweetalert-btn')
  if (trigger) {
    trigger.addEventListener('click', () => {
      swal("Hello!", "SweetAlert is working!", "success")
      swal("Good job!", "You clicked the button!", "success");

      swal("Are you sure?", {
        buttons: true,
        dangerMode: true
      });

      swal({
        title: "Auto close alert!",
        text: "This will close in 2 seconds.",
        timer: 2000,
        buttons: false
      });
    })
  }
})

// Bootstrap3 Editable'
import '../vendor/bootstrap3-editable/bootstrap-editable.css'
import '../vendor/bootstrap3-editable/bootstrap-editable.min.js'

document.addEventListener("turbo:load", () => {
  // Initialize editable elements
  $('#username').editable({
    url: '/post',         // fake url for demonstration
    title: 'Enter username'
  });
})

// JSVectormap
import jsVectorMap from 'jsvectormap/dist/jsvectormap.js';
import 'jsvectormap/dist/maps/world.js';

const map = new jsVectorMap({
  selector: '#map',
  map: 'world',
})

// Ekko Lightbox
import '../vendor/ekko-lightbox';
document.addEventListener("turbo:load", () => {
  document.querySelectorAll('[data-toggle="lightbox"]').forEach(el => {
    el.addEventListener("click", function (e) {
      e.preventDefault();
      const lightbox = window.jQuery(this).ekkoLightbox();

      // Optional fix: delay and then fix accessibility flags
      setTimeout(() => {
        const modal = document.querySelector('.ekko-lightbox');
        if (modal) {
          modal.removeAttribute('aria-hidden');
          modal.setAttribute('aria-modal', 'true');
          modal.removeAttribute('inert');
        }
      }, 100);
    });
  });
});

// Perfect Scrollbar
import PerfectScrollbar from 'perfect-scrollbar';
import 'perfect-scrollbar/css/perfect-scrollbar.css';
document.addEventListener("DOMContentLoaded", () => {
  const container = document.querySelector('#scrollable-content');
  if (container) {
    new PerfectScrollbar(container);
  }
});

// Morris.js
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

// Owl Carousel
import '../vendor/owl-caroussel';
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

// FlexSlider
import '../vendor/flexslider';
document.addEventListener('turbo:load', () => {
  $('.flexslider').flexslider({
    animation: 'slide',
    controlNav: true,
    directionNav: true
  });
});

// Prism.js
import '../vendor/prism';
document.addEventListener('turbo:load', () => {
  Prism.highlightAll();
});

// dataTables
import './dataTables'
document.addEventListener('turbo:load', () => {
  $('#example').DataTable()
});

// Magnific Popup
import './magnific-popup'
document.addEventListener('turbo:load', () => {
  $('.popup-gallery').magnificPopup({
    delegate: 'a',
    type: 'image',
    gallery: {
      enabled: true
    }
  })
});

// Masonry
import './masonry-layout'
document.addEventListener('turbo:load', () => {
  const grid = document.querySelector('.masonry-grid')

  if (!grid) return

  imagesLoaded(grid, () => {
    new Masonry(grid, {
      itemSelector: '.masonry-item',
      columnWidth: '.masonry-sizer',
      percentPosition: true
    })
  })
})