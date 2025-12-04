<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!-- sec시작 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.empVO" var="empVO" />
</sec:authorize>

<!-- sec끝 -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- ===============================LINK 추가영역시작입니다=============================== -->
<link rel="icon" type="image/png" href="/images/logologo.png">
<link rel="shortcut icon" type="image/png" href="/images/logologo.png">
<!-- Google Font: Source Sans Pro -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="/adminlte/plugins/fontawesome-free/css/all.min.css">
<!-- Ionicons -->
<link rel="stylesheet"
	href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
<!-- Tempusdominus Bootstrap 4 -->
<link rel="stylesheet"
	href="/adminlte/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
<!-- iCheck -->
<link rel="stylesheet"
	href="/adminlte/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
<!-- JQVMap -->
<!--   <link rel="stylesheet" href="/adminlte/plugins/jqvmap/jqvmap.min.css"> -->
<!-- Theme style -->
<link rel="stylesheet" href="/adminlte/dist/css/adminlte.min.css">
<!-- overlayScrollbars -->
<link rel="stylesheet"
	href="/adminlte/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
<!-- Daterange picker -->
<link rel="stylesheet"
	href="/adminlte/plugins/daterangepicker/daterangepicker.css">
<!-- summernote -->
<link rel="stylesheet"
	href="/adminlte/plugins/summernote/summernote-bs4.min.css">
<!-- ===============================LINK 추가영역끝입니다=============================== -->
<!-- ===============================STYLE 추가영역시작입니다=============================== -->
<style>
/* /////채팅css영역시작///// */
.chatBtn {
	border: 0;
	background: none;
	cursor: pointer;
}

.main-header, .main-header .nav-link, .main-header .navbar-nav .nav-item>a
	{
	color: white !important;
}

#chatBox {
	display: none;
	position: fixed;
	bottom: 20px;
	right: 20px;
	width: 400px;
	height: 650px;
	border-radius: 10px;
	overflow: hidden;
	transition: all 0.3s ease;
	z-index: 9999;
	background: #fff;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

#chatBox iframe {
	width: 100%;
	height: 100%;
	border: none;
}

#dragHandle {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 20px;
	cursor: move;
	z-index: 10000;
	background: transparent;
}
/* 최소화: 부모 박스도 함께 줄이기 + iframe 숨김 */
#chatBox.minimized {
	width: auto !important;
	height: 40px !important; /* 헤더만 남김 */
	background: transparent !important;
	box-shadow: none !important;
	border: none !important;
	overflow: visible !important;
}

#chatBox.minimized iframe {
	display: none !important;
}

#chatBox.dragging iframe {
	pointer-events: none;
}
/* 배지 깜빡임 */
@keyframes blink-badge { 0%, 100% {
	background-color: #ff7a00;
	color: #000;
	}50%
	{background-color:#dc3545;
	color:#fff;
	}
}
.badge-blinking {
	animation: blink-badge 1s infinite;
}
/* /////////////////////////////////////채팅css영역끝////////////////////////////////// */

/* /////////////////////////// 헤더 / 사이드 / 푸터 css입니다 ////////////////////////////// */
.card {
    border: 0;
    box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}
.card-header {
    background: #DCE6F3 !important;
}

/* 헤더 푸터 css 토스랑 비슷한데, 단정한 느낌의 색들로 했습니다. */
.main-header, .main-sidebar, .main-footer {
	/*background: rgb(100, 140, 164) !important; */ /* 입주민쪽과 같은색 */
	background: rgb(5, 49, 99) !important; /*  */
	backdrop-filter: blur(20px) saturate(150%);
	-webkit-backdrop-filter: blur(20px) saturate(150%);
	border: 1px solid rgba(255, 255, 255, 0.8);
	box-shadow: 0 10px 28px rgba(15, 23, 42, 0.16);
	color: #fff;
}

.main-footer { /* 푸터 */
	background: rgb(5, 49, 99) !important; /* 밝은 반투명 */
	backdrop-filter: blur(20px) saturate(150%);
	-webkit-backdrop-filter: blur(20px) saturate(150%);
	border: 1px solid rgba(255, 255, 255, 0.8);
	box-shadow: 0 10px 28px rgba(15, 23, 42, 0.16);
	color: #fff;
}

.main-header { /* 헤더색 */
	background: rgb(5, 49, 99) !important; /* 밝은 반투명 */
	backdrop-filter: blur(20px) saturate(150%);
	-webkit-backdrop-filter: blur(20px) saturate(150%);
	border: 1px solid rgba(255, 255, 255, 0.8);
	box-shadow: 0 10px 28px rgba(15, 23, 42, 0.16);
	color: #fff;
}
/* 사이드바 오른쪽 경계선 */
.main-sidebar {
	border-right: 1px solid rgba(148, 163, 184, 0.5) !important;
	scrollbar-width: none; /* 왼쪽 사이드바 가로 스크롤 제거, css잡다보니 생겨서 넣었습니다. */
}
/* 전체 배경색과 그라데이션입니다. */
body {
	background: linear-gradient(140deg, /* 각도 */
    #fff 0%, /* 색들 */
    #fff 35%, #fff 100%);
	color: #333;
}
/* 기본회색 배경 제거 */
.content-wrapper {
	background-color: transparent !important;
}
/*  사이드바 메뉴 */
.main-sidebar .brand-text {
	color: #fff !important; /* 로고 색 */
}

.main-sidebar .nav-sidebar .nav-link {
	background: transparent !important;
	color: #fff !important;
}

.main-sidebar .nav-sidebar .nav-link i {
	color: #fff !important; /* 네비바에 있는 아이콘 살짝 연한 회색 */
}
/* 활성 메뉴 */
.main-sidebar .nav-sidebar .nav-link.active {
	background: rgba(255, 255, 255, 0.3) !important;
	border-radius: 8px;
	color: #0f172a !important;
}

.main-sidebar .nav-sidebar .nav-link.active i {
	color: #0f172a !important;
}
/* hover 효과 살짝 */
.main-sidebar .nav-sidebar .nav-link:hover {
	background: rgba(255, 255, 255, 0.18) !important;
}

body::-webkit-scrollbar {
	display: none; /* 스크롤바제거 */
}

/* 버튼색이랑, 버튼 호버이벤트 시작 */
.btn-primary {
    background: #AECFFF !important;
    border-color: #AECFFF !important;
    color: #0F2B5B !important;
}
.btn-primary:hover {
    background: #377FE3 !important;
    border-color: #377FE3 !important;
}
/* 버튼색이랑, 버튼 호버이벤트 시작 */

/* ///////////////////////////////////////헤더,푸터,사이드바 css끝////////////////////////////////////// */
</style>
<!-- ===============================STYLE 추가영역끝입니다=============================== -->
<!-- ===============================SCRIPT 추가영역시작입니다=============================== -->
<script>
let stompClient = null;

// 알림 타입별 아이콘 & 색상 결정
const iconMap = {
    'CVPL': { icon: 'fa-comments', color: 'text-info' },
    'RESVE': { icon: 'fa-calendar-check', color: 'text-success' },
    'ELCTRNSANCTN': { icon: 'fa-file-alt', color: 'text-primary' },
    'NOTICE': { icon: 'fa-bullhorn', color: 'text-warning' },
    'FCLTY': { icon: 'fa-building', color: 'text-secondary' },
    'BBS': { icon: 'fa-clipboard', color: 'text-info' },
    'VOTE': { icon: 'fa-thumbs-up', color: 'text-primary' },
    'MANAGECT': { icon: 'fa-money-bill-wave', color: 'text-warning' },
    'SYSTEM': { icon: 'fa-cog', color: 'text-danger' },
    'SIGN': { icon: 'fa-user-plus', color: 'text-success' },
    'ANOMALY': { icon: 'fa-exclamation-triangle', color: 'text-danger' }
};

const user = "${empVO.empId}";
const dept = "${empVO.deptCode}";
const userAll = "ALL_EMP";
const system = "SYSTEM";

// 로그인 후 1번만 새알림 모달이 뜨기 위한 함수
const gContextPath = "${pageContext.request.contextPath}";

(function() {
	  const lastUser = sessionStorage.getItem('lastLoggedInUser');
	  
	  if (lastUser !== user) {
	    sessionStorage.clear();
	    sessionStorage.setItem('lastLoggedInUser', user);
	  }
})();

function connectWebSocket() {
  const socket = new SockJS(gContextPath + "/ws-ntcn");
  stompClient = Stomp.over(socket);
  
  const rcverIds = [user, dept, userAll, system];
  
  stompClient.connect({}, function(frame) {
    console.log("WebSocket 연결" + frame);
    
    // 토픽 모두 구독
    rcverIds.forEach(id => {
    	  stompClient.subscribe("/topic/ntcn/" + id, function(message) {
    	    const ntcn = JSON.parse(message.body);
    	    
    	 	// 1. 새 알림이 있으면 팝업 + 배지 증가 + 드롭다운 업데이트
			if (ntcn.ntcnCn) {
			    showNtcnSwal(ntcn);
			    
			    const badge = document.querySelector('#ntcnBadge');
			    const header = document.querySelector('#ntcnHeader');
			    const dropdownList = document.querySelector('#ntcnDropdownList');
			    
			    // 배지 깜빡임 시작
			    badge.classList.remove('badge-warning');
			    badge.classList.add('badge-blinking');
			    
			    // 배지 증가
			    const currentCount = parseInt(badge.textContent) || 0;
			    const newCount = currentCount + 1;
			    badge.textContent = newCount;
			    badge.style.display = 'inline-block';
			    
			    // 전체 알림 다시 조회
			    fetch('/ntcn/unread')
			        .then(r => r.json())
			        .then(data => {
			            header.textContent = data.unreadList.length + '개의 새 알림';
			            
			            let html = '';
			            const recentList = data.unreadList.slice(0, 5);  // 최신 5개
			            
			            recentList.forEach(function(n) {
			                const date = new Date(n.registDt);
			                const ntcnType = n.ntcnTy || 'SYSTEM';
			                const iconInfo = iconMap[ntcnType] || { icon: 'fa-bell', color: 'text-secondary' };
			                
			                html += `
			                    <a href="\${n.ntcnUrl}" class="dropdown-item d-flex" onclick="markNotificationAsRead(\${n.ntcnSn})">
			                        <i class="fas \${iconInfo.icon} \${iconInfo.color} mr-2" style="margin-top: 3px;"></i>
			                        <div style="flex: 1; display: flex; justify-content: space-between;">
			                            <div>\${n.ntcnCn}</div>
			                            <span class="text-muted text-sm" style="white-space: nowrap; margin-left: 10px;">\${getTimeAgo(date)}</span>
			                        </div>
			                    </a>
			                    <div class="dropdown-divider"></div>
			                `;
			            });
			            
			            dropdownList.innerHTML = html;
			        })
			}
    	    
			// 2. 초기 로딩 (ntcnCn 없을 때만) - REST API로 전체 알림 조회
	   	    if (ntcn.unreadList && !ntcn.ntcnCn && id === user) {
	   	        
	   	        // 개인 + 부서 알림 통합 조회
	   	        fetch('/ntcn/unread')
	   	            .then(r => r.json())
	   	            .then(data => {
	   	                // UI 업데이트 (배지 + 드롭다운)
	   	                updateNotificationUI(data.unreadList);
	   	                
	   	                // 첫 로그인 시 모달
	   	                if (!sessionStorage.getItem('initialNtcnShown') && data.unreadList.length > 0) {
	   	                    // 모달은 UI 업데이트 후에!
	   	                    setTimeout(() => {
	   	                        showUnreadModal(data.unreadList);
	   	                    }, 500);
	   	                    sessionStorage.setItem('initialNtcnShown', 'true');
	   	                }
	   	            })
	   	    }
	   	});

   	console.log("구독: /topic/ntcn/" + id);
   	});
 });
} 
		

//미확인 알림 UI 업데이트
function updateNotificationUI(unreadList) {
  
  const badge = document.querySelector('#ntcnBadge');
  const header = document.querySelector('#ntcnHeader');
  const dropdownList = document.querySelector('#ntcnDropdownList');
  
  const count = unreadList.length;

  if (count > 0) {
    badge.textContent = count;
    badge.style.display = 'inline-block';
    header.textContent = count + '개의 새 알림';
    
    let html = '';
    const recentList = unreadList.slice(0, 5);
    
    recentList.forEach(function(n) {
        const date = new Date(n.registDt);
        const ntcnType = n.ntcnTy || 'SYSTEM';
        const iconInfo = iconMap[ntcnType] || { icon: 'fa-bell', color: 'text-secondary' };
     
    	html += `
		    <a href="\${n.ntcnUrl}" class="dropdown-item d-flex" onclick="markNotificationAsRead(\${n.ntcnSn})">
		        <i class="fas \${iconInfo.icon} \${iconInfo.color} mr-2" style="margin-top: 3px;"></i>
		        <div style="flex: 1; display: flex; justify-content: space-between;">
		            <div>\${n.ntcnCn}</div>
		            <span class="text-muted text-sm" style="white-space: nowrap; margin-left: 10px;">\${getTimeAgo(date)}</span>
		        </div>
		    </a>
		    <div class="dropdown-divider"></div>
		`;
    });
    
    dropdownList.innerHTML = html;
  } else {
    badge.textContent = '0';
    badge.style.display = 'none';
    header.textContent = '알림 없음';
    dropdownList.innerHTML = '<a href="#" class="dropdown-item">새 알림이 없습니다</a>';
  }
}

// 첫 로딩 시 미확인 알림 모달
function showUnreadModal(unreadList) {
  const count = unreadList.length;
  const firstNtcn = unreadList[0];
  
  Swal.fire({
    icon: "info",
    title: "읽지 않은 알림",
    html: firstNtcn.ntcnCn + "<br><br>읽지 않은 " + count + "개의 알림이 있습니다.",
    showConfirmButton: true,
    confirmButtonText: "확인"
  });
}

// 새 알림 팝업
function showNtcnSwal(ntcn) {
	const icons = {
		CVPL: "info",
		RESVE: "success",
		ELCTRNSANCTN: "info",
		NOTICE: "info",
		FCLTY: "info",
		BBS: "info",
		VOTE: "info",
		MANAGECT: "warning",
		SYSTEM: "error",
		SIGN: "info",
		ANOMALY : "warning"
	};

	const titles = {
		CVPL: "민원 알림",
		RESVE: "예약 알림",
		ELCTRNSANCTN: "결재 알림",
		NOTICE: "공지 알림",
		FCLTY: "시설 알림",
		BBS: "게시판 알림",
		VOTE: "투표 알림",
		MANAGECT: "관리비 알림",
		SYSTEM: "시스템 알림",
		SIGN : "회원가입 알림",
		ANOMALY : "검침량 이상 알림"
	};

	const icon = icons[ntcn.ntcnTy] || "info";
	const title = titles[ntcn.ntcnTy] || "알림";
	const message = ntcn.ntcnCn || "새로운 알림이 도착했습니다.";

	Swal.fire({
		icon: icon,
		title: title,
		html: message,
		showConfirmButton: true,
		confirmButtonText: "확인",
		showDenyButton: true,
		denyButtonText: "바로가기",
		denyButtonColor: "#3085d6"
	}).then((result) => {
		if (result.isDenied && ntcn.ntcnSn && ntcn.ntcnUrl) {
			// 바로가기 클릭 시: 읽음 처리 + URL 이동
			markNotificationAsRead(ntcn.ntcnSn);
			window.location.href = ntcn.ntcnUrl;
		}
	});
}

// 시간 표시 함수
function getTimeAgo(date) {
  const now = new Date();
  const diff = Math.floor((now - date) / 1000);
  
  if (diff < 60) return '방금 전';
  if (diff < 3600) return Math.floor(diff / 60) + '분 전';
  if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
  return Math.floor(diff / 86400) + '일 전';
}

//알림 읽음 처리
function markNotificationAsRead(ntcnSn) {
  fetch('/ntcn/read/' + ntcnSn, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    }
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      console.log('알림 읽음 처리 완료:', ntcnSn);
      
      // 배지 숫자 감소
      const badge = document.querySelector('#ntcnBadge');
      const currentCount = parseInt(badge.textContent) || 0;
      if (currentCount > 0) {
        const newCount = currentCount - 1;
        badge.textContent = newCount;
        if (newCount === 0) {
          badge.style.display = 'none';
        }
      }
    }
  })
  .catch(error => {
    console.error('알림 읽음 처리 실패:', error);
  });
}

//모든 알림 보기
function showAllNotifications() {
  fetch('/ntcn/unread')
    .then(r => r.json())
    .then(data => {
      const dropdownList = document.querySelector('#ntcnDropdownList');
      dropdownList.innerHTML = '';
      
      data.unreadList.forEach(n => {
        const date = new Date(n.registDt);
        const icon = iconMap[n.ntcnTy] || { icon: 'fa-bell', color: 'text-secondary' };
        dropdownList.innerHTML += `
            <a href="\${n.ntcnUrl}" class="dropdown-item d-flex" onclick="markNotificationAsRead(\${n.ntcnSn})">
                <i class="fas \${icon.icon} \${icon.color} mr-2" style="margin-top: 3px;"></i>
                <div style="flex: 1; display: flex; justify-content: space-between;">
                    <div>\${n.ntcnCn}</div>
                    <span class="text-muted text-sm" style="white-space: nowrap; margin-left: 10px;">\${getTimeAgo(date)}</span>
                </div>
            </a>
            <div class="dropdown-divider"></div>
        `;
      });
      
      dropdownList.style.maxHeight = '400px';
      dropdownList.style.overflowY = 'auto';
      
      // 모든 알림 보기 버튼 숨기기
      const footer = document.querySelector('#ntcnFooter');
      
      if (footer) {
          footer.style.display = 'none';
      }
    });
}

// 페이지 로드 시 실행
document.addEventListener("DOMContentLoaded", function() {
  connectWebSocket();
  
  // 알림 드롭다운 클릭 시 깜빡임 멈춤
  document.querySelector('#ntcnDropdown').addEventListener('click', function() {
      const badge = document.querySelector('#ntcnBadge');
      // 배지 깜빡임 멈춤
      badge.classList.remove('badge-blinking');
      badge.classList.add('badge-warning');
  });
});
</script>
<!-- ===============================SCRIPT 추가영역끝입니다=============================== -->

<!--/////////////////////////////////////////////// 채팅 script영역시작(나혜선 추가) ///////////////////////////////////////////////-->
<script>
								//버튼으로 최소화 처리
								function handleClick() {
									document.querySelector("#chatBox").style.display = "none";
								}
								/* function handleClick2(){
									document.querySelector("#chatBox").style.display="block";
								} */
								document.addEventListener("DOMContentLoaded", function () {
									let chatWindow = null;  // 빈 객체
									const chatUrl = "/chat";
									const messageBtn = document.querySelector(".chatBtn");
									const messageBox = document.getElementById("chatBox");
									const dragHandle = document.getElementById("dragHandle");
									messageBtn.addEventListener("click", function () {  //메신저 버튼을 클릭하면
										//토글이용 : 열려 있으면 닫기, 닫혀 있으면 열기
										if (messageBox.style.display == "none" || messageBox.style.display == "") {
											messageBox.style.display = "block";
											if (!messageBox.style.left || messageBox.style.left == "auto") {
												messageBox.style.left = (window.innerWidth - 450) + "px";
												messageBox.style.top = (window.innerHeight - 730) + "px";
											}
										} else {
											messageBox.style.display = "none";
										}
										const iframe = document.getElementById("chatFrame");

										if (!iframe.src) iframe.src = chatUrl;
										document.getElementById("chatBox").style.display = "block";
									}); //메신저 버튼 
									//채팅창 위치 옮기기 위해
									let possibledrag = false, offsetX = 0, offsetY = 0;   //offsetX : 가로,  offsetY: 세로
									let pending = false;
									dragHandle.addEventListener("mousedown", (e) => {  //마우스 버튼을 누르면
										if (e.target.tagName !== "IFRAME") {   //채팅창 테두리 또는 배경 클릭 시에만 드래그 가능하게 함
											possibledrag = true;
											messageBox.classList.add("dragging");
											const position = messageBox.getBoundingClientRect(); //BoundingClientRect은 내장된 api 메서드
											messageBox.style.left = position.left + "px";
											messageBox.style.top = position.top + "px";
											messageBox.style.right = "auto";
											messageBox.style.bottom = "auto";
											offsetX = e.clientX - position.left;
											offsetY = e.clientY - position.top;
											e.preventDefault(); //텍스트 선택 방지
										}
									});
									document.addEventListener("mousemove", (e) => {  //마우스가 움직일때마다
										if (!possibledrag || pending) return;
										pending = true;
										messageBox.classList.remove("dragging");

										requestAnimationFrame(() => {
											messageBox.style.left = (e.clientX - offsetX) + "px";
											messageBox.style.top = (e.clientY - offsetY) + "px";
											pending = false;
										});
									});
									document.addEventListener("mouseup", () => {  //마우스 버튼 클릭을 떼면
										possibledrag = false;
									})
								}); //전체 끝


								window.addEventListener("message", (event) => {
									const box = document.querySelector("#chatBox");

									if (event.data.action == "closeChat") {  //chat.jsp로부터 상태값 받음
										console.log("message event:", event.data);
										box.style.display = "none";
									}

									if (event.data.action == "openChat") {
										box.style.display = "block";
									}

								});
							</script>
<!--/////////////////////////////////////////////// 채팅 script영역끝 ///////////////////////////////////////////////-->



<title>D-PYUNHAN</title>

</head>

<c:set var="uri" value="${pageContext.request.requestURI}" />

<body
	class="hold-transition sidebar-mini layout-fixed layout-footer-fixed layout-navbar-fixed  <c:if test="${uri ne '/WEB-INF/views/main.jsp'}"> sidebar-collapse</c:if>">

	<div class="wrapper">


		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img class="animation__shake"
				src="/images/logo.png" alt="AdminLTELogo"
				height="300" width="400">
		</div>

		<!-- Navbar -->
		<nav
			class="main-header navbar navbar-expand navbar-white navbar-light">
			<!-- Left navbar links -->
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" data-widget="pushmenu"
					href="#" role="button"><i class="fas fa-bars"></i></a></li>
			</ul>

			<!-- 우측상단 네비바 시작 -->
			<ul class="navbar-nav ml-auto">

				<!-- /////로그인/로그아웃/프로필 드롭다운으로 시작///// -->
				<li class="nav-item dropdown"><sec:authorize
						access="isAuthenticated()">
						<a class="nav-link" data-toggle="dropdown" href="#"
							style="display: flex; align-items: center; gap: 8px;"> <i
							class="fas fa-user-circle"></i> <sec:authentication
								property="principal.empVO" var="empVO" /> <span>${empVO.nm}님<i
								class="fas fa-chevron-down"></i></span> <i class="bi bi-chevron-down"></i>
						</a>

						<div class="dropdown-menu dropdown-menu-right">
							<!-- 내정보 -->
							<a class="dropdown-item" href="/emp/empMyPage/${empVO.empId}">
								<i class="far fa-user-circle mr-2"></i> 내정보
							</a>
							<div class="dropdown-divider"></div>
							<!-- 로그아웃 -->
							<form action="/logout" method="post" class="dropdown-item p-0">
								<button type="submit" class="btn btn-link dropdown-item pl-3">
									<i class="fas fa-sign-out-alt mr-2"></i> 로그아웃
								</button>
							</form>
						</div>
					</sec:authorize> <sec:authorize access="isAnonymous()">
						<a href="/login" class="nav-link"
							style="display: flex; align-items: center; gap: 6px;"> <i
							class="fas fa-user-lock"></i> 로그인
						</a>
					</sec:authorize></li>
				<!-- /////로그인/로그아웃/프로필 드롭다운으로 끝///// -->


				<!--///// 채팅창영역 시작 /////-->
				<li class="nav-item">
					<button type="button" class="nav-link chatBtn"
						style="display: flex; align-items: center; gap: 8px; border: none; background: none;">
						<i class="fas fa-comment-dots"></i> 메신저
					</button>
					<div id="chatBox">
						<div id="dragHandle"></div>
						<!-- 드래그 하기 위해 잡는 영역 -->
						<iframe id="chatFrame"></iframe>
						<!-- 내부 내용은 jsp에서 작성 -->
					</div>
				</li>
				<!-- /////채팅창영역 끝///// -->





				<!-- Notifications Dropdown Menu -->
				<li class="nav-item dropdown"><a class="nav-link"
					data-toggle="dropdown" href="#" id="ntcnDropdown"> <i
						class="far fa-bell"></i> <span
						class="badge badge-warning navbar-badge" id="ntcnBadge">0</span>
				</a>
					<div class="dropdown-menu dropdown-menu-lg dropdown-menu-right"
						style="min-width: 400px;">
						<span class="dropdown-item dropdown-header" id="ntcnHeader">알림
							없음</span>
						<div class="dropdown-divider"></div>
						<div id="ntcnDropdownList">
							<!-- 알림 목록 추가 영역 -->
						</div>
						<div class="dropdown-divider"></div>
						<!-- 이벤트 버블링 막기 -->
						<a href="#" class="dropdown-item dropdown-footer" id="ntcnFooter"
							onclick="event.stopPropagation(); showAllNotifications(); return false;">
							모든 알림 보기 </a>
					</div></li>
			</ul>
		</nav>
		<!-- /.navbar -->

		<!-- Main Sidebar Container -->
		<aside class="main-sidebar sidebar-light elevation-4">
			<!-- Brand Logo -->
<a href="/main" class="brand-link">
  <img src="/images/logo.png" alt="로고"
       class="brand-image img-circle elevation-3"
       style="width: 35px; height: 35px; object-fit: cover; background: white; padding: 3px; border-radius: 50%;">

  <span class="brand-text font-weight-bord ml-2">D PYUNHAN</span>
</a>


			<!-- Sidebar -->
			<div class="sidebar">
				<!-- Sidebar user panel (optional) -->
				<card style="margin:5px;"> </card>
				<!-- SidebarSearch Form -->

				<!-- Sidebar Menu -->
				<nav class="mt-2">
					<ul class="nav nav-pills nav-sidebar flex-column"
						data-widget="treeview" role="menu" data-accordion="false">
						<li class="nav-item"><a href="/mber/hshldList"
							class="nav-link"> <i class="nav-icon fas fa-user"></i>
								<p>세대관리</p>
						</a></li>
						<li class="nav-item"><a href="#" class="nav-link"> <i
								class="nav-icon fas fa-chart-pie"></i>
								<p>
									관리비 <i class="right fas fa-angle-left"></i>
								</p>
						</a>
							<ul class="nav nav-treeview">
								<li class="nav-item"><a href="/managect/managectView" class="nav-link"> <i
										class="far fa-circle nav-icon"></i>
										<p>관리비 관리</p>
								</a></li>
								<li class="nav-item"><a href="/mtinsp/mtinspView"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>검침관리</p>
								</a></li>
							</ul></li>
						<li class="nav-item"><a href="#" class="nav-link"> <i
								class="nav-icon fas fa-file-contract"></i>
								<p>
									입찰 <i class="right fas fa-angle-left"></i>
								</p>
						</a>
							<ul class="nav nav-treeview">
								<li class="nav-item"><a
									href="/bidPblanc/getBidPblancListAsEmp" class="nav-link"> <i
										class="far fa-circle nav-icon"></i>
										<p>입찰자/공고등록</p>
								</a></li>
								<li class="nav-item"><a
									href="/ccpyManage/getCcpyManageGuestList" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>협력업체_신청목록/승인</p>
								</a></li>
							</ul></li>
						<li class="nav-item"><a href="/contract/contractlist"
							class="nav-link"> <i class="nav-icon fas fa-file-alt"></i>
								<p>계약</p>
						</a></li>
						<li class="nav-item"><a href="#" class="nav-link"> <i
								class="nav-icon fas fa-inbox"></i>
								<p>
									결재 <i class="right fas fa-angle-left"></i>
								</p>
						</a>
							<ul class="nav nav-treeview">
								<li class="nav-item"><a
									href="/elctrnsanctn/getElctrnsanctnList" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>결재</p>
								</a></li>
								<li class="nav-item"><a
									href="/elctrnsanctn/getElctrnsanctnSentList" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>보낸 기안함</p>
								</a></li>
								<li class="nav-item"><a
									href="/elctrnsanctn/getElctrnsanctnRcpttList" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>받은 기안함</p>
								</a></li>
								<li class="nav-item"><a
									href="/elctrnsanctn/postElctrnsanctn" class="nav-link"> <i
										class="far fa-circle nav-icon"></i>
										<p>신규 작성</p>
								</a></li>
							</ul></li>
						<li class="nav-item"><a href="#" class="nav-link"> <i
								class="nav-icon fas fa-tree"></i>
								<p>
									아파트시설물 <i class="fas fa-angle-left right"></i>
								</p>
						</a>
							<ul class="nav nav-treeview">
								<li class="nav-item"><a href="/cmmnty/cmmntylist"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>커뮤니티 목록</p>
								</a></li>
								<li class="nav-item"><a href="/fclty/list" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>시설/보안 목록</p>
								</a></li>
								<!-- <li class="nav-item"><a href="/fcltyManage/register"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>시설 관리 등록</p>
								</a></li> -->
								<li class="nav-item"><a href="/fcltyManage/list"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>시설/커뮤니티 점검 이력</p>
								</a></li>
							</ul></li>
						<li class="nav-item"><a href="#" class="nav-link"> <i
								class="nav-icon fas fa-edit"></i>
								<p>
									입주민관리<i class="fas fa-angle-left right"></i>
								</p>
						</a>
							<ul class="nav nav-treeview">
								<li class="nav-item"><a href="/cvplRcept/list"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>
											민원&nbsp;&nbsp;&nbsp;
											<c:if
												test="${pageContext.request.requestURI eq '/WEB-INF/views/main.jsp'}">
												<span class="badge badge-warning"
													style="font-size: 0.85rem;">대기:${cvplRceptNum}</span>
											</c:if>
										</p>
								</a></li>
								<li class="nav-item"><a href="/vote/voteMtr"
									class="nav-link"> <i class="far fa-circle nav-icon"></i>
										<p>투표</p>
								</a></li>
								<li class="nav-item"><a href="/mber/list" class="nav-link">
										<i class="far fa-circle nav-icon"></i>
										<p>
											가입승인&nbsp;&nbsp;&nbsp;
											<c:if
												test="${pageContext.request.requestURI eq '/WEB-INF/views/main.jsp'}">
												<span class="badge badge-warning"
													style="font-size: 0.85rem;">대기:${memNum}</span>
											</c:if>
										</p>
								</a></li>
							</ul></li>

						<li class="nav-item"><a href="/fx/list" class="nav-link">
								<i class="nav-icon far fa-calendar-alt"></i>
								<p>일정관리</p>
						</a></li>
						<!-- 공지사항관리는 admin으로 로그인했을 때만 볼 수 있습니다 시작 -->
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<li class="nav-item"><a href="/notice/list" class="nav-link">
									<i class="nav-icon fas fa-pencil-alt"></i>
									<p>공지사항관리</p>
							</a></li>
						</sec:authorize>
						<!-- 공지사항관리는 admin으로 로그인했을 때만 볼 수 있습니다 끝 -->
						<li class="nav-item"><a href="/notice/wnmpy_notice"
							class="nav-link"> <i class="nav-icon fas fa-bullhorn"></i>
								<p>사내 공지사항</p>
						</a></li>
					</ul>
				</nav>
				<!-- /.sidebar-menu -->
			</div>
			<!-- /.sidebar -->
		</aside>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<div class="content-header mb-0 pb-0">
				<div class="container-fluid"></div>
				<!-- /.container-fluid -->
			</div>
			<!-- /.content-header -->

			<!-- Main content -->
			<section class="content">
				<div class="container-fluid">