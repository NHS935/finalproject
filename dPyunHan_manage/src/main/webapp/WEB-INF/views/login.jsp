<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>D-편한세상</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="icon" href="<c:url value='/images/logologo.png' />">
<link rel="shortcut icon" href="<c:url value='/images/logologo.png' />">
<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700&display=swap"
	rel="stylesheet">

<style>
html, body {
	height: 100%;
	font-family: 'Noto Sans KR', sans-serif;
	background: #000;
	overflow-x: hidden;
	overflow-y: scroll;
	scrollbar-width: none;
	/* html,body영역의 스크롤을 안보이게하기. 내부 div에도 스크롤이 생겨서 적용 */
}

/* 배경 영상 */
.bg video {
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	object-fit: cover;
	z-index: 0;
	opacity: 0.95;
}

/* 오른쪽 버튼 영역 */
.side-accordion {
	position: fixed;
	top: 50%;
	right: 0;
	transform: translateY(-50%);
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 3; /* 버튼이 패널보다 위로 오도록 */
}

/* 버튼 스타일 */
.side-btn {
	writing-mode: vertical-rl;
	text-orientation: mixed;
	background: rgba(255, 255, 255, 0.9);
	color: #333;
	font-weight: 900;
	border: none;
	cursor: pointer;
	width: 65px;
	height: 200px;
	font-size: 1rem;
	border-radius: 14px 0 0 14px;
	letter-spacing: 0.05em; /* 세로 텍스트 시 보정 */
	box-shadow: 0 4px 12px rgba(0, 0, 0, .25);
	transition: all 0.3s ease;
	transform-origin: right center;
}

.side-btn:hover {
	transform: scaleX(1.1); /* 왼쪽으로 쭈욱 늘어나는정도 */
	background: #ff6a00;
	color: #fff;
}

.side-btn.active {
	background: #ff6a00;
	color: #fff;
	box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.3);
}

/* 공통 패널 */
.side-panel {
	position: fixed;
	right: -620px;
	top: 50%; /* 모든 패널을 세로 중앙 기준으로 */
	transform: translateY(-50%);
	width: 400px;
	height: auto;
	max-height: 92vh;
	background: rgba(0, 0, 0, 0.75);
	backdrop-filter: blur(10px);
	border-radius: 16px 0 0 16px;
	padding: 48px 36px;
	transition: right 0.4s ease;
	z-index: 10;
}

.side-panel.active { /*버튼과 패널 사이 간격*/
	right: 72px;
}

/* 내용 공통 */
.side-panel h3 {
	margin-top: 0;
	font-size: 1.45rem;
	font-weight: 700;
	border-bottom: 1px solid rgba(255, 255, 255, 0.2);
	padding-bottom: 10px;
	margin-bottom: 24px;
	color: #fff;
	text-align: center;
}

/* 로그인 */
.field {
	margin-bottom: 14px;
}

.field input {
	width: 100%;
	padding: 12px;
	border: none;
	border-radius: 8px;
	font-size: 14px;
	margin-left: 40px;
	margin-right: 40px;
}

.actions {
	display: flex;
	gap: 8px;
}

.btn {
	flex: 1;
	padding: 10px 0;
	border: none;
	border-radius: 8px;
	font-weight: 700;
	cursor: pointer;
}

.btn.submit {
	background: #ff6a00;
	color: #fff;
}

.btn.submit:hover {
	background: #e95c00;
}

.btn.secondary {
	background: #e0e0e0;
	color: #333;
}

.btn.secondary:hover {
	background: #ccc;
}

/* 공지 / 입찰 리스트 */
.list {
	display: grid;
	gap: 10px;
}

.item {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.badge {
	font-size: 12px;
	font-weight: 700;
	padding: 2px 6px;
	border-radius: 999px;
	color: #fff;
}

.badge.notice {
	background: #ff6a00;
}

.badge.bid {
	background: #ff6a00;
}

.title a {
	color: #fff;
	text-decoration: none;
	font-size: 14px;
	max-width: 280px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.date {
	font-size: 12px;
	color: rgba(255, 255, 255, 0.8);
}

.more-links {
	margin-top: 12px;
	text-align: right;
}

.more-links a {
	color: #fff;
	font-size: 13px;
	text-decoration: none;
}

.more-links a:hover {
	color: #ff6a00;
}

/* 푸터 */
footer {
	position: absolute;
	bottom: 15px;
	width: 100%;
	text-align: center;
	color: rgba(255, 255, 255, 0.6);
	font-size: 12px;
}

/* 로그인 패널만 세로 길이 줄이기 */
#login.side-panel {
	top: 50%; /* 화면 중앙 정렬 */
	transform: translateY(-50%); /* 위아래 가운데 정렬 */
	/* height: 300px; 내용에 맞게 자동 조정 */
	max-height: 92vh; /* 너무 커지면 제한 */
	border-radius: 16px 0 0 16px; /* 살짝 둥글게 하면 깔끔 */
}

#login form {
	/* margin-top: 36px; 원하는 만큼 아래로 내리기 */
	margin-bottom: 10px; /* 원하는 만큼 아래로 내리기 */
}

#login .field input {
	width: 78%; /* 70 → 78 */
	height: 38px; /* 25 → 38 */
	padding: 10px 12px; /* 8/10 → 10/12 */
	font-size: 14px; /* 13 → 14 */
}

#login .btn {
	flex: none;
	width: 50%;
	height: 45px;
}

/* 최종: 간격 좁게 + 버튼 폭 확 줄이기 */
#login .actions {
	display: flex;
	justify-content: center; /* 중앙 배치 */
	align-items: center;
	gap: 8px; /* 간격 최소화 */
	flex-wrap: nowrap; /* 줄바꿈 방지 */
}

#login .actions .btn {
	flex: 0 0 160px !important;
	width: 160px !important;
	height: 44px;
	line-height: 44px;
	padding: 0;
	font-size: 13px;
	border-radius: 8px;
	box-sizing: border-box;
}

/*새로추가 시작 20251112*/
/* --- Scroll Landing 기본 --- */
main.landing {
	position: relative;
	z-index: 1; /* 배경영상(z-index:0) 위, 패널(z-index:10/1000) 아래로 */
	color: #fff;
	scroll-snap-type: y mandatory; /* 섹션 단위로 착 붙는 스냅 */
}

/* 풀 스크린 섹션 */
.section {
	min-height: 100vh;
	padding: 120px 8vw 100px; /* 상단 여백 */
	display: grid;
	align-items: center;
	scroll-snap-align: start;
	backdrop-filter: blur(1px);
}

/* 섹션별 배경 톤(네 블랙 기반 유지) */
.section.bg-dark {
	background: rgba(0, 0, 0, 0.35);
}

.section.bg-darker {
	background: rgba(0, 0, 0, 0.55);
}

.section.bg-glass {
	background: rgba(0, 0, 0, 0.20);
}

/* 타이틀/텍스트 */
.section h2 {
	font-size: clamp(28px, 4vw, 48px);
	line-height: 1.2;
	margin: 0 0 12px;
	font-weight: 700;
}

.section p.lead {
	font-size: clamp(16px, 2vw, 20px);
	opacity: .9;
	margin-bottom: 24px;
}

/* 버튼 */
.btn-ghost {
	display: inline-block;
	padding: 12px 18px;
	border: 2px solid #ff6a00;
	color: #fff;
	text-decoration: none;
	border-radius: 10px;
	font-weight: 700;
	transition: .25s ease;
}

.btn-ghost:hover {
	background: #ff6a00;
}

/* 3열/2열 카드 그리드 (특장점, 기능 등) */
.grid {
	display: grid;
	gap: 18px;
}

.grid.cols-3 {
	grid-template-columns: repeat(3, minmax(0, 1fr));
}

.grid.cols-2 {
	grid-template-columns: repeat(2, minmax(0, 1fr));
}

/* ===== 반응형 보정 (작은 화면에서는 과도한 확대를 억제) ===== */
@media ( max-width : 992px) {
	.side-btn {
		width: 56px;
		height: 180px;
		font-size: .95rem;
	}
	.side-panel {
		width: 480px;
		right: -540px;
	}
	.side-panel.active {
		right: 64px;
	}
	.title a {
		max-width: 240px;
	}
}

@media ( max-width : 640px) {
	.side-accordion {
		right: 2px;
	} /* 모바일에서 너무 붙지 않게 */
	.side-btn {
		width: 48px;
		height: 160px;
		font-size: .9rem;
	}
	.side-panel {
		width: 86vw; /* 모바일에서는 화면 비율로 */
		right: -92vw;
		padding: 28px 20px;
	}
	.side-panel.active {
		right: 56px;
	}
	.title a {
		max-width: 58vw;
	}
}

.card-glass {
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.12);
	border-radius: 16px;
	padding: 20px;
	transition: transform .25s ease, background .25s ease, border-color .25s;
}

.card-glass:hover {
	transform: translateY(-4px);
	background: rgba(255, 255, 255, 0.10);
	border-color: rgba(255, 255, 255, 0.24);
}

/* 카운터 숫자 */
.kpi {
	font-size: clamp(28px, 5vw, 56px);
	font-weight: 700;
}

.kpi-sub {
	opacity: .85;
}

/* Reveal 애니메이션 */
.reveal {
	opacity: 0;
	transform: translateY(24px);
	transition: opacity .6s ease, transform .6s ease;
}

.reveal.show {
	opacity: 1;
	transform: translateY(0);
}

/* 사이드 패널/버튼이 랜딩 위에 잘 보이도록 보정 */
.side-accordion {
	z-index: 1000;
}

.side-panel {
	z-index: 1001;
}
/*새로추가 끝 20251112*/
</style>


</head>

<body>

	<!-- 배경 동영상 -->
	<div class="bg">
		<video autoplay muted loop playsinline>
			<source src="/video/intro.mp4" type="video/mp4">
		</video>
	</div>

	<!-- 오른쪽 버튼 -->
	<div class="side-accordion">
		<button class="side-btn" data-target="login">로그인</button>
		<button class="side-btn" data-target="notice">공지사항</button>
		<button class="side-btn" data-target="bid">입찰공고</button>
	</div>

	<!-- 오른쪽 패널 (슬라이드 아코디언) -->
	<div class="side-panel" id="login">
		<h3>로그인</h3>
		<form action="/login" method="POST">
			<div class="field">
				<input type="text" name="username" placeholder="아이디" required>
			</div>
			<div class="field">
				<input type="password" name="password" placeholder="비밀번호" required>
			</div>
			<div class="actions">
				<button type="submit" class="btn submit">로그인</button>
			</div>
		</form>

	</div>

	<div class="side-panel" id="notice">
		<h3>공지사항</h3>
		<div class="list">
			<c:forEach var="noticeVO" items="${noticeVOList}">
				<div class="item">
					<span class="badge notice">공지</span> 
					  <span class="title">

                    <c:choose>
					  <c:when test="${isgetauth}">
                        <a href="/notice/wnmpy_notice">${noticeVO.noticeSj}</a>
					  </c:when>
                    <c:otherwise>
                         <a href="#" class="needlogin">${noticeVO.noticeSj}</a>
					</c:otherwise>
					</c:choose>
                      </span>
				        <span class="date">
						   <fmt:formatDate value="${noticeVO.noticeWritngDt}" pattern="MM/dd" />
					    </span>
				</div>
			</c:forEach>
		</div>
		<div class="more-links">
			<a href="/notice/wnmpy_notice">더보기 ></a>
		</div>
	</div>

	<div class="side-panel" id="bid">
		<h3>입찰공고</h3>
		<div class="list">
			<c:forEach var="bidPblancVO" items="${bidPblancVOList}">
				<div class="item">
					<span class="badge bid">${bidPblancVO.bidSttusAsStr}</span>
					<span class="title">
					  <a href="/bidPblanc/getBidPblancList"
					     title="${bidPblancVO.bidSj}"> ${fn:length(bidPblancVO.bidSj) > 20 ? fn:substring(bidPblancVO.bidSj, 0, 20).concat('...') : bidPblancVO.bidSj}
					  </a>
					</span> 
					<span class="date">
						<fmt:formatDate value="${bidPblancVO.pblancDt}" pattern="MM/dd" />
					</span>
				</div>
			</c:forEach>
		</div>
		
		<div class="more-links">
			<a href="/bidPblanc/getBidPblancList">더보기 ></a>
		</div>
	</div>

	<footer>ⓒ D-편한세상. All rights reserved.</footer>

  <script>
		const buttons = document.querySelectorAll('.side-btn');
		const panels = document.querySelectorAll('.side-panel');
		
		buttons.forEach(btn => {
		  btn.addEventListener('click', () => {
		    const target = document.getElementById(btn.dataset.target);
		    const isActive = target.classList.contains('active');
		    panels.forEach(p => p.classList.remove('active'));
		    buttons.forEach(b => b.classList.remove('active'));
		    if (!isActive) {
		      target.classList.add('active');
		      btn.classList.add('active');
		    }
		  });
		});
		
		<!-- 로그인 페이지 접속 시 세션스토리지 초기화 -->
		  document.addEventListener("DOMContentLoaded" ,function(){
		    sessionStorage.removeItem('initialNtcnShown');
		    sessionStorage.removeItem('lastLoggedInUser');
		});
	</script>


	<script>
 //관리자 랜딩페이지 공지사항 접근권한
 document.addEventListener('DOMContentLoaded',()=>{
    const confirm =  document.querySelectorAll('.needlogin');

    confirm.forEach(el=>{
		el.addEventListener('click',(e)=>{
			e.preventDefault();
        Swal.fire({
          icon:'info',
		  title: '로그인 필요',
		  text: '로그인 후 이용 가능합니다.',
		  confirmButtonColor:'#ff6a00',
		  confirmButtonText:'확인'
	    });
	  })
	})
  });
	

 document.addEventListener('DOMContentLoaded', () => {
  // 1) reveal 애니메이션
  const reveals = document.querySelectorAll('.reveal');
  const io = new IntersectionObserver((entries) => {
    entries.forEach(ent => {
      if (ent.isIntersecting) {
        ent.target.classList.add('show');
        io.unobserve(ent.target);
      }
    });
  }, { threshold: 0.15 });
  reveals.forEach(el => io.observe(el));

  // 2) KPI 숫자 카운트업
  const kpis = document.querySelectorAll('.kpi[data-count]');
  const countIo = new IntersectionObserver((entries) => {
    entries.forEach(ent => {
      if (!ent.isIntersecting) return;
      const el = ent.target;
      const target = parseFloat(el.dataset.count);
      const isInt = Number.isInteger(target);
      const duration = 1200; // ms
      const start = performance.now();

      function tick(now) {
        const p = Math.min(1, (now - start) / duration);
        const val = target * (0.2 + 0.8 * p); // 처음에 살짝 튕기듯
        el.textContent = isInt ? Math.round(val).toLocaleString() : (val).toFixed(1);
        if (p < 1) requestAnimationFrame(tick);
      }
      requestAnimationFrame(tick);
      countIo.unobserve(el);
    });
  }, { threshold: 0.6 });
  kpis.forEach(el => countIo.observe(el));

	// 현재 URL의 파라미터(?error)를 직접 가져옵니다.
	const urlParams = new URLSearchParams(window.location.search);

	// 'error'라는 파라미터가 존재하는지 확인 (값이 비어있어도 존재만 하면 true)
	if (urlParams.has('error')) {
		Swal.fire({
			icon: 'error',
			title: '로그인 실패',
			text: '아이디 또는 비밀번호를 확인해주세요.',
			confirmButtonColor: '#ff6a00',
			confirmButtonText: '확인'
		}).then((result) => {
			// 확인 버튼 누르면 닫혀있던 로그인 패널 다시 열기
			const loginBtn = document.querySelector('.side-btn[data-target="login"]');
			if(loginBtn) {
				loginBtn.click();
			}
		});

		// (선택사항) 알림을 띄운 후 URL에서 ?error를 지워서 새로고침 시 또 뜨는 것 방지
		// history.replaceState({}, document.title, window.location.pathname);
	}
});

</script>


	<main class="landing" id="landing">
		<section class="section"
			style="padding-top: 100px; align-items: start;">
			<div class="reveal">
				<h2>
					아파트 관리, <br>더 쉽고 깔끔하게.
				</h2>
				<p class="lead">D-편한세상 관리시스템으로 공지·민원·결재·입찰까지 한 번에.</p>
			</div>
			<div class="grid cols-3">
				<div class="card-glass reveal">
					<h3>간편</h3>
					<p>로그인부터 결제까지 클릭 몇 번으로 끝. 주민도 관리사무소도 편해집니다.</p>
				</div>
				<div class="card-glass reveal">
					<h3>생활</h3>
					<p>D-편한세상과 함께하는 여러분께 편리한 생활을을 약속합니다</p>
				</div>
				<div class="card-glass reveal">
					<h3>보안</h3>
					<p>투표·전자결재·파일그룹·AI 분석까지 안전한 아파트 생활을 보장합니다.</p>
				</div>
			</div>
		</section>

		<!-- FEATURE: 기능 하이라이트 2열 -->
		<section class="section bg-darker">
			<div class="grid cols-2">
				<div class="card-glass reveal">
					<h3>전자결재 & 파일그룹</h3>
					<p>결재라인/첨부/서명까지과 함께 안정 저장.</p>
					<a href="/elctrnsanctn/list" class="btn-ghost">자세히 보기</a>
				</div>
				<div class="card-glass reveal">
					<h3>입찰 & 공지</h3>
					<p>입찰공고/질의응답/첨부와 공지 확산을 한 번에. 모바일도 최적화.</p>
					<a href="/bidPblanc/getBidPblancList" class="btn-ghost">입찰 보러가기</a>
				</div>
				<div class="card-glass reveal">
					<h3>투표관리</h3>
					<p>간편한 투표 등록과 실시간 현황 제공.</p>
				</div>
				<div class="card-glass reveal">
					<h3>관리비 조회/결제</h3>
					<p>월별 관리비 내역·상세 항목·카드 결제까지 원샷 처리.</p>
				</div>
			</div>
		</section>

		<!-- KPI: 숫자 카운트업 -->
		<section class="section bg-dark">
			<div class="reveal" style="text-align: center">
				<h2>지금 바로 도입해 보세요</h2>
				<p class="lead">관리 효율, 주민 만족—둘 다 잡을 수 있습니다.</p>
			</div>

			<div class="grid cols-3">
				<div class="reveal">
					<div class="kpi" data-count="128">0</div>
					<div class="kpi-sub">입주단지</div>
				</div>
				<div class="reveal">
					<div class="kpi" data-count="9472">0</div>
					<div class="kpi-sub">활성 세대</div>
				</div>
				<div class="reveal">
					<div class="kpi" data-count="99.3">0</div>
					<div class="kpi-sub">월간 만족도(%)</div>
				</div>
			</div>
		</section>
	</main>

</body>
</html>