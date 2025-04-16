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
//---------------------------------------------------------------------

// Bootstrap Tagsinput
import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.css'
import 'bootstrap-tagsinput/dist/bootstrap-tagsinput.min.js'
document.addEventListener("turbo:load", () => {
  const tagInput = document.getElementById('tags')
  if (tagInput) {
    $('#tags').tagsinput()
  }
});

// Bootstrap Select
import 'bootstrap-select/dist/css/bootstrap-select.min.css'
import 'bootstrap-select/dist/js/bootstrap-select.min.js'
document.addEventListener("turbo:load", () => {
  $('.bootstrap-select').selectpicker()

  // Optional: watch for changes
  $('.bootstrap-select').on('changed.bs.select', function () {
    console.log("Selected:", $(this).val())
  })
});

// Bootstrap-colorpicker
import '@claviska/jquery-minicolors/jquery.minicolors.css'
import '@claviska/jquery-minicolors'
document.addEventListener("turbo:load", () => {
  const colorInput = document.getElementById("colorpicker")
  if (colorInput) {
    $('#colorpicker').minicolors({
      control: 'hue',
      defaultValue: '#563d7c',
      format: 'hex',
      theme: 'bootstrap'
    })

    $('#colorpicker').on('change', function () {
      console.log("Selected color:", $(this).val())
    })
  }
});

// Bootstrap DateRangePicker
import moment from 'moment'
import 'bootstrap-daterangepicker/daterangepicker.css'
import 'bootstrap-daterangepicker'
document.addEventListener("turbo:load", () => {
  const el = document.getElementById("daterange")
  if (el) {
    $(el).daterangepicker({
      startDate: moment().subtract(7, 'days'),
      endDate: moment(),
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }, function (start, end) {
      console.log("Selected range: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'))
    })
  }
});

// Daterangepicker
import 'daterangepicker/daterangepicker.css'
import 'daterangepicker'
document.addEventListener("turbo:load", () => {
  const el = document.getElementById("daterange")
  if (el) {
    $(el).daterangepicker({
      startDate: moment().subtract(7, 'days'),
      endDate: moment(),
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      }
    }, function (start, end) {
      console.log("Date range selected: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'))
    })
  }
});

// Select2
import './select2';
document.addEventListener("turbo:load", () => {

  $('.select2-basic').select2()

  $('.select2-tags').select2({
    tags: true,
    tokenSeparators: [',', ' ']
  })

  $('.select2-ajax').select2({
    ajax: {
      url: 'https://pokeapi.co/api/v2/pokemon',
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          limit: 20,
          offset: 0
        }
      },
      processResults: function (data) {
        return {
          results: data.results.map(p => ({
            id: p.name,
            text: p.name.charAt(0).toUpperCase() + p.name.slice(1)
          }))
        }
      }
    },
    placeholder: 'Search Pokémon',
    minimumInputLength: 1
  })
});

// Dropzone
import './dropzone';
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
});

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
});

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
});

// Bootstrap3 Editable'
import '../vendor/bootstrap3-editable/bootstrap-editable.css'
import '../vendor/bootstrap3-editable/bootstrap-editable.min.js'
document.addEventListener("turbo:load", () => {
  // Initialize editable elements
  $('#username').editable({
    url: '/post',         // fake url for demonstration
    title: 'Enter username'
  });
});

// JSVectormap
import jsVectorMap from 'jsvectormap/dist/jsvectormap.js';
import 'jsvectormap/dist/maps/world.js';
const map = new jsVectorMap({
  selector: '#map',
  map: 'world',
});

// Ekko Lightbox
import './ekko-lightbox';
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
import './morris-global';
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
import './owl-caroussel';
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
import './flexslider';
document.addEventListener('turbo:load', () => {
  $('.flexslider').flexslider({
    animation: 'slide',
    controlNav: true,
    directionNav: true
  });
});

// Prism.js
import './prism';
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
});