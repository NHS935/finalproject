document.addEventListener('DOMContentLoaded', () => {
  new Swiper('.testimonial-swiper', {
    loop: true,
    loopedSlides: 4,
    centeredSlides: true,
    centeredSlidesBounds: true,
    slidesPerView: 1.03,
    spaceBetween: 10,
    speed: 600,
    autoplay: {
      delay: 4000,
      disableOnInteraction: false
    },
    pagination: {
      el: '.swiper-pagination', // 👈 전역 pagination 하나만 연결
      clickable: true
    }
  });
});
