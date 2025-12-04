<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
/* ===== Footer 기본 구조 ===== */
footer.footer {
  background-color: #1b1f22; /* dark 배경 */
  color: #fff;
  width: 100%;
  position: relative;
  bottom: 0;
  left: 0;
  z-index: 50;
  padding: 8px 0;
  text-align: center;
  border-top: 1px solid rgba(255,255,255,0.1);
}

/* ===== Footer 메뉴 정확히 5등분 ===== */
#footer-navmenu ul {
  display: grid !important;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  justify-items: center;
  align-items: start;
  margin: 0;
  padding: 0;
  list-style: none;
  gap: 24px; /* 항목 간격 확대 */
}

/* ===== Footer 각 항목 ===== */
#footer-navmenu li {
  width: 100%;
  text-align: center;
}

/* ===== 링크 (아이콘 + 글자) ===== */
#footer-navmenu a {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  color: #fff !important;
  text-decoration: none !important;
  font-size: 0.8rem;
  font-weight: 500;
  line-height: 1.1;
  padding-top: 0;
}

/* 아이콘 크기 */
#footer-navmenu a i {
  font-size: 1.5rem;
  margin-bottom: 2px;
  transform: translateY(0px);
  transition: color 0.25s ease-in-out;
}

/* hover 시 아이콘만 주황색 */
#footer-navmenu a:hover i {
  color: #ff4a17 !important;
}

/* active 상태(현재 섹션)에 있을 때 아이콘 주황색 */
#footer-navmenu a.active i {
  color: #ff4a17 !important;
}

/* 글자는 항상 흰색 유지 */
#footer-navmenu a span {
  color: #fff !important;
}

/* footer 높이 확보 */
.mobile-frame {
  padding-bottom: 60px !important;
}

/* ===== 반응형 ===== */
@media (max-width: 480px) {
  #footer-navmenu ul {
    grid-template-columns: repeat(5, 1fr);
  }
  #footer-navmenu a {
    font-size: 0.72rem;
  }
  #footer-navmenu a i {
    font-size: 1.2rem;
  }
}
</style>

<!-- ===== Footer (Dewi / Bootstrap 5) ===== -->
<footer id="footer" class="footer dark-background">
  <!-- ❌ 여기에 d-flex 절대 넣지 말 것 -->
  <div class="px-0">  
    <nav id="footer-navmenu" class="footer-menu mx-auto">
      <ul>
        <li><a href="/main#levy"><i class="bi bi-cash-coin"></i><span>관리비</span></a></li>
        <li><a href="/main#resve1"><i class="bi bi-building-fill"></i><span>편의시설</span></a></li>
        <li><a href="/main#home"><i class="bi bi-house-fill"></i><span>홈</span></a></li>
        <li><a href="/main#visitVhcle"><i class="bi bi-car-front-fill"></i><span>방문차량</span></a></li>
        <li><a class="chatBtn"><i class="bi bi-chat-square-dots-fill"></i><span>채팅</span></a></li>
      </ul>
    </nav>
  </div>
</footer>

<!-- Scroll Top -->
<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>
</div> <!-- ✅ mobile-frame 닫음 -->

<!-- Preloader -->
<div id="preloader"></div>

<!-- ===== JS (Bootstrap 5 / Dewi) ===== -->
<script src="/dewi/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/dewi/assets/vendor/php-email-form/validate.js"></script>
<script src="/dewi/assets/vendor/aos/aos.js"></script>
<script src="/dewi/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="/dewi/assets/vendor/purecounter/purecounter_vanilla.js"></script>
<script src="/dewi/assets/vendor/swiper/swiper-bundle.min.js"></script>
<script src="/dewi/assets/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
<script src="/dewi/assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js" async defer></script>
<script src="/dewi/assets/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const frame  = document.querySelector('.mobile-frame');
    const header = frame?.querySelector('#header');
    if (!frame || !header) return;

    const TH = 60;
    const onScroll = () => header.classList.toggle('scrolled', frame.scrollTop > TH);
    onScroll();
    frame.addEventListener('scroll', onScroll, { passive: true });

    const navToggle = header.querySelector('.mobile-nav-toggle');
    if (navToggle) {
        navToggle.addEventListener('click', () => {
            const isActive = document.body.classList.contains('mobile-nav-active');
            header.classList.toggle('nav-open', !isActive);
//         	header.classList.toggle('nav-open');
        });
    }

    frame.addEventListener('scroll', () => AOS.refresh());
    AOS.init({ once: false, duration: 800, easing: 'ease-out' });
});

function smoothScrollToSection(frame, target) {
    const headerHeight = 60; // 고정 헤더 높이
    const targetTop = target.offsetTop - headerHeight;

    frame.scrollTo({
        top: targetTop,
        behavior: "smooth"
    });
}

document.addEventListener("DOMContentLoaded", function () {
	  const frame = document.querySelector(".mobile-frame");
	  const links = document.querySelectorAll("#footer-navmenu a");
	  const sections = Array.from(document.querySelectorAll("section[id]"));
	  const homeLink = document.querySelector('#footer-navmenu a[href="/main#home"]');
	  let lockActive = false;
	  // === 현재 페이지가 /main 인지 판별 ===
	  const isMainPage = window.location.pathname.includes("/main");

	// 클릭 시 부드럽게 이동
	links.forEach(link => {
		link.addEventListener("click", e => {
			const href = link.getAttribute("href");
			if (!href || href.indexOf("#") == -1) return;
			
			// 클릭 보호 시작
			lockActive = true;
			setTimeout(() => lockActive = false, 600);
			
			// 클릭 시 즉시 active
			links.forEach(a => a.classList.remove("active"));
			link.classList.add("active");
			
			const [page, hash] = href.split("#");

			// === /main 페이지일 때만 scrollIntoView 작동 ===
			if (isMainPage && hash) {
			e.preventDefault();
			const targetSection = document.getElementById(hash);
			
			if (targetSection) {
			    smoothScrollToSection(frame, targetSection);
			}
			} else if (!isMainPage && page.includes("/main")) {
				// 다른 페이지(예: /mber) → /main으로 이동
				window.location.href = href;
			}
			// /mber 등은 그냥 이동 (기존 동작)
		});
	});

	  // === /main 페이지일 때만 IntersectionObserver 활성화 ===
    if (isMainPage) {
	    const observer = new IntersectionObserver(function (entries) {

	    	if (lockActive) return;
	    	
			const visible = entries.filter(e => e.isIntersecting).sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
			
			if (frame && frame.scrollTop < 150) {
				links.forEach(a => a.classList.remove("active"));
				if (homeLink) homeLink.classList.add("active");
			    return;
			}
			
			if (visible.length > 0) {
				const id = visible[0].target.getAttribute("id");
				links.forEach(a => a.classList.remove("active"));
				
				if (["testimonials", "hero", "mainBanner"].includes(id)) {
				    if (homeLink) homeLink.classList.add("active");
				} else {
					const selector = `#footer-navmenu a[href="/main#\${id}"]`.replace("\\${id}", id);
				    const link = document.querySelector(selector);
				    if (link) link.classList.add("active");
				}
			}
			}, {
				root: frame || null,
				threshold: 0,
				rootMargin: "0px 0px -90% 0px" 
			});
			
			sections.forEach(section => observer.observe(section));
			links.forEach(a => a.classList.remove("active"));
			if (homeLink) homeLink.classList.add("active");
	  }
	
	  // frame 스크롤 시 AOS 갱신
	  if (frame) frame.addEventListener("scroll", () => AOS.refresh());
});
</script>
<script>
// DOM에 새로운 노드가 추가될 때마다 모달을 감지해서 body로 이동
const observer = new MutationObserver(() => {
    document.querySelectorAll(".modal").forEach(modal => {
        if (modal.parentElement !== document.body) {
            document.body.appendChild(modal);
        }
    });
});

// body 전체를 감시
observer.observe(document.body, {
    childList: true,
    subtree: true
});

// 이미 있는 모달도 즉시 이동
window.addEventListener("load", () => {
    document.querySelectorAll(".modal").forEach(modal => {
        if (modal.parentElement !== document.body) {
            document.body.appendChild(modal);
        }
    });
});
</script>

</body>
</html>
