(function() {
  "use strict";

  /**
   * Apply .scrolled class to the body as the page is scrolled down
   */
  function toggleScrolled() {
    const selectBody = document.querySelector('body');
    const selectHeader = document.querySelector('#header');
    if (!selectHeader) return;
    if (!selectHeader.classList.contains('scroll-up-sticky') &&
        !selectHeader.classList.contains('sticky-top') &&
        !selectHeader.classList.contains('fixed-top')) return;
    window.scrollY > 100
      ? selectBody.classList.add('scrolled')
      : selectBody.classList.remove('scrolled');
  }

  document.addEventListener('scroll', toggleScrolled);
  window.addEventListener('load', toggleScrolled);

  /**
   * Mobile nav toggle (for header only)
   */
  const mobileNavToggleBtn = document.querySelector('#header .mobile-nav-toggle');
  const mobileNavToggle = () => {
    document.querySelector('body').classList.toggle('mobile-nav-active');
    if (mobileNavToggleBtn) {
      mobileNavToggleBtn.classList.toggle('bi-list');
      mobileNavToggleBtn.classList.toggle('bi-x');
    }
  };

  if (mobileNavToggleBtn != null) {
    mobileNavToggleBtn.addEventListener('click', mobileNavToggle);
  }

  /**
   * Hide mobile nav on same-page/hash links (header only)
   */
  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll('#header-navmenu .toggle-dropdown').forEach(btn => {
      btn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();

        const li = this.closest('li');
        if (!li) return;

        li.classList.toggle('active');

        const sub = li.querySelector(':scope > ul');
        if (sub) sub.classList.toggle('dropdown-active');
      });
    });

    // ✅ 메뉴 외부 클릭 시 닫힘 처리
    document.addEventListener('click', function(e) {
      const nav = document.getElementById('header-navmenu');
      if (nav && !nav.contains(e.target)) {
        nav.querySelectorAll('li.active').forEach(li => li.classList.remove('active'));
        nav.querySelectorAll('ul.dropdown-active').forEach(ul => ul.classList.remove('dropdown-active'));
      }
    });
  });

  // ===============================
  // USER MENU DROPDOWN (고길동 전용)
  // ===============================
  // ===============================
  // USER MENU DROPDOWN (고길동)
  // ===============================
  document.addEventListener("DOMContentLoaded", () => {

      const userDropdown = document.querySelector('#user-menu .dropdown');
      if (!userDropdown) return;

      const userToggle = userDropdown.querySelector('a');

      // 클릭해서 토글
      userToggle.addEventListener('click', function(e) {
          e.preventDefault();
          e.stopPropagation();
          userDropdown.classList.toggle('active');
      });

      // 바깥 클릭 → 닫기
      document.addEventListener('click', function(e) {
          if (!userDropdown.contains(e.target)) {
              userDropdown.classList.remove('active');
          }
      });

  });

  
  /**
   * Preloader
   */
  const preloader = document.querySelector('#preloader');
  if (preloader) {
    window.addEventListener('load', () => preloader.remove());
  }

  /**
   * Scroll top button
   */
  const scrollTop = document.querySelector('.scroll-top');
  if (scrollTop) {
    const toggleScrollTop = () => {
      window.scrollY > 100
        ? scrollTop.classList.add('active')
        : scrollTop.classList.remove('active');
    };
    scrollTop.addEventListener('click', e => {
      e.preventDefault();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
    window.addEventListener('load', toggleScrollTop);
    document.addEventListener('scroll', toggleScrollTop);
  }

  /**
   * Animation on scroll function and init
   */
  function aosInit() {
    if (typeof AOS !== 'undefined') {
      AOS.init({
        duration: 600,
        easing: 'ease-in-out',
        once: true,
        mirror: false
      });
    }
  }
  window.addEventListener('load', aosInit);

  /**
   * Initiate glightbox
   */
  if (typeof GLightbox !== 'undefined') {
    GLightbox({ selector: '.glightbox' });
  }

  /**
   * Initiate Pure Counter
   */
  if (typeof PureCounter !== 'undefined') new PureCounter();

  /**
   * Init swiper sliders
   */
  function initSwiper() {
    document.querySelectorAll(".init-swiper").forEach(swiperElement => {
      let configEl = swiperElement.querySelector(".swiper-config");
      if (!configEl) return;
      let config = JSON.parse(configEl.innerHTML.trim());
      new Swiper(swiperElement, config);
    });
  }
  window.addEventListener("load", initSwiper);

  /**
   * Init isotope layout and filters
   */
  document.querySelectorAll('.isotope-layout').forEach(isotopeItem => {
    let layout = isotopeItem.getAttribute('data-layout') ?? 'masonry';
    let filter = isotopeItem.getAttribute('data-default-filter') ?? '*';
    let sort = isotopeItem.getAttribute('data-sort') ?? 'original-order';
    let initIsotope;
    if (typeof imagesLoaded !== 'undefined') {
      imagesLoaded(isotopeItem.querySelector('.isotope-container'), () => {
        initIsotope = new Isotope(isotopeItem.querySelector('.isotope-container'), {
          itemSelector: '.isotope-item',
          layoutMode: layout,
          filter: filter,
          sortBy: sort
        });
      });
    }
    isotopeItem.querySelectorAll('.isotope-filters li').forEach(f => {
      f.addEventListener('click', function() {
        isotopeItem.querySelector('.isotope-filters .filter-active')
          ?.classList.remove('filter-active');
        this.classList.add('filter-active');
        if (initIsotope) {
          initIsotope.arrange({ filter: this.getAttribute('data-filter') });
        }
        aosInit();
      });
    });
  });

  /**
   * Correct scrolling position upon page load for URLs containing hash links.
   */
  window.addEventListener('load', function() {
    if (window.location.hash) {
      let section = document.querySelector(window.location.hash);
      if (section) {
        setTimeout(() => {
          let scrollMarginTop = getComputedStyle(section).scrollMarginTop;
          window.scrollTo({
            top: section.offsetTop - parseInt(scrollMarginTop),
            behavior: 'smooth'
          });
        }, 100);
      }
    }
  });

  /**
   * Navmenu Scrollspy (header only)
   */
  let navmenulinks = document.querySelectorAll('#header-navmenu a');
  if (navmenulinks.length > 0) {
    function navmenuScrollspy() {
      navmenulinks.forEach(link => {
        if (!link.hash) return;
        let section = document.querySelector(link.hash);
        if (!section) return;
        let position = window.scrollY + 200;
        if (position >= section.offsetTop && position <= (section.offsetTop + section.offsetHeight)) {
          document.querySelectorAll('#header-navmenu a.active').forEach(l => l.classList.remove('active'));
          link.classList.add('active');
        } else {
          link.classList.remove('active');
        }
      });
    }
    window.addEventListener('load', navmenuScrollspy);
    document.addEventListener('scroll', navmenuScrollspy);
  }

})();
