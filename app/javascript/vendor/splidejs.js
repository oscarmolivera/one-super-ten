import Splide from '@splidejs/splide';

document.addEventListener('turbo:load', () => {
  const carousel = document.querySelector('#splide');
  if (carousel) {
    new Splide(carousel, {
      type: 'loop',
      perPage: 1,
      pagination: true,
      arrows: true,
    }).mount();
  }
});