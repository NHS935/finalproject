<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>dpunhan-index</title>
<c:set var="isLoginPage" value="${fn:contains(pageContext.request.requestURI, '/login')}" />

<!-- Favicons -->
<link rel="stylesheet" href="/css/global/cuteModal.css">
<link rel="stylesheet" href="/css/global/modalScroll.css">
<link rel="shortcut icon" href="/images/logo/logologo.png" type="image/png">
<link rel="icon" href="/images/logo/logologo.png" type="image/png">
<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link
    href="https://fonts.googleapis.com/css2?family=Roboto:wght@100..900&family=Raleway:wght@100..900&family=Inter:wght@100..900&display=swap"
    rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="/dewi/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/dewi/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
<!-- ✅ 아이콘 경로 보정용 CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link href="/dewi/assets/vendor/aos/aos.css" rel="stylesheet">

<!-- Main CSS File -->
<link href="/dewi/assets/css/main.css" rel="stylesheet">

<!-- (옵션) Summernote 등 AdminLTE 플러그인 CSS 필요 시 -->
<link rel="stylesheet" href="/adminlte/plugins/summernote/summernote-bs4.min.css">

<!-- WebSocket & SweetAlert2 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>

<!-- 알림.js -->
<c:if test="${not fn:contains(pageContext.request.requestURI, '/login')}">
<script type="text/javascript" src="/js/global/ntcn.js"></script>
<link rel="stylesheet" href="/css/global/ntcn.css">
<link rel="stylesheet" href="/css/global/chat.css">
</c:if>

<style>
:root {
    --frame-width: 480px;
    --frame-radius: 18px;
}

/* Webkit (Chrome, Edge, Safari) */
.mobile-frame::-webkit-scrollbar {
    width: 0 !important;
    height: 0 !important;
    display: none !important;
}
html, body {
    height: 100%;
    overflow-y: auto;
    overflow-x: hidden;
    background-color:rgba(218, 212, 210, 0.5) !important;
}

body.index-page {
    background: #fff;
    min-height: 100vh;
    display: flex;
    justify-content: center;
}

.mobile-frame {
    width: 100%;
    max-width: var(--frame-width);
    margin: 0 auto;
    min-height: 100vh;
    box-shadow: 0 50px 90px rgba(0, 0, 0, .5);
    border-radius: var(--frame-radius);
    overflow-x: hidden;
    overflow-y: auto;
    position: relative !important;
    display: flex;
    flex-direction: column;
    padding-top: 60px;
    padding-bottom: 60px;
    box-sizing: border-box;
    background-color: #F1F4FA;
    z-index: 0 !important;
}

header#header {
    position: fixed;
    top: 0;
    margin: 0 auto;
    left: 0;
    right: 0;
    width: 100%;
    max-width: var(--frame-width);
    height: 60px;
    background-color: #648ca4;
    border-top-left-radius: var(--frame-radius);
    border-top-right-radius: var(--frame-radius);
    box-shadow: 0 2px 8px rgba(0, 0, 0, .06);
    z-index: 1001;
    display: flex;
    align-items: center;
}

.header-inner {
    width: 100%;
    padding: 0 14px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-left {
    display: flex;
    align-items: center;
}

.header-left img {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    object-fit: cover;
}

.header-right {
    display: flex;
    align-items: center;
    gap: 18px;
}

.header-icon {
    position: relative;
    color: #fff;
    cursor: pointer;
    padding: 0 4px 0 0;
}
.bi-bell-fill::before {
    font-size: 22px;
}
.bi-list::before {
    font-size: 32px;
}
.header-icon .badge {
    position: absolute;
    top: -4px;
    right: -8px;
    background: #dc3545;
    color: #fff;
    font-size: 10px;
    border-radius: 50%;
    padding: 2px 6px;
    display: none;
}

/* footer */
.mobile-frame .footer {
    position: fixed;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 100%;
    max-width: var(--frame-width);
    height: 60px;
    background-color: #648ca4;
    border-bottom-left-radius: var(--frame-radius);
    border-bottom-right-radius: var(--frame-radius);
    box-shadow: 0 -2px 8px rgba(0, 0, 0, .06);
    z-index: 1001;
}

/* //////////////////////////////알림NTCN//////////////////////////////*/
.notification-text {
  word-break: break-word;
  white-space: normal;
  overflow-wrap: anywhere;
  display: block;
}

.dropdown-menu {
    padding-top: 0 !important;
    margin-top: 0 !important;
}

/* 배지 깜빡임 */
@keyframes blink-badge {
    0%, 100% { background-color: #ff7a00; color: #000; }
    50% { background-color: #dc3545; color: #fff; }
}

.badge-blinking {
    animation: blink-badge 1s infinite;
}

/* 배지 */
.ntcn-badge {
    position: absolute;
    top: -7px;
    left: 12px;
    background: #dc3545;
    color: #fff;
    font-size: 0.65rem;
    padding: 2px 4.5px;
    display: none;
}

/* 드롭다운 메뉴 */
.ntcn-dropdown-menu {
    min-width: 350px;
    max-width: 380px;
    max-height: 350px;
    overflow-y: auto;
    padding-top: 0;
    margin-top: 0;
    transform: translate(68px, 41px) !important;
    border-top-right-radius: 0px !important;
    border-bottom-right-radius: 0px !important;
}

/* 드롭다운 헤더 */
.ntcn-dropdown-header {
    background-color: rgba(100, 140, 164, 0.9) !important;
}

/* 알림 목록 영역 */
.ntcn-dropdown-list {
    max-height: 280px;
    overflow-y: auto;
}

/* footer 버튼 */
.ntcn-dropdown-footer {
    display: block;
/*     padding: 10px 0; */
}
/* //////////////////////////////알림NTCN//////////////////////////////*/

/* ================= 전체 햄버거 메뉴 오버레이 ================= */
.full-menu-overlay {
    position: fixed; /* frame 내부 기준 */
    top: 0; left: 0; right: 0; bottom: 0;
    transform: translateX(100%); /* 기본: 화면 오른쪽 밖 */
    
    width: 100%;
    max-width: var(--frame-width);
    height: 100% !important;
    min-height: 100vh;
    
    background: #F1F4FA;
    border-radius: var(--frame-radius); /* 동일한 둥근정도 */
    z-index: 3000;
    
    opacity: 1;                 /* 완전 투명 */
    visibility: hidden;         /* DOM 상에서도 안 보이는 상태 */
    pointer-events: none;       /* 클릭도 안 됨 */
    
    transition: transform 0.55s ease; /* 더 천천히 부드럽게 */
}

.full-menu-overlay.active {
    transform: translateX(0); /* 화면 중앙으로 */
    visibility: visible;    /* 화면에 등장 */
    pointer-events: auto;   /* 클릭 가능 */
}

.full-menu-overlay.closing {
    visibility: visible;           /* 나갈 동안 살아있어야 애니메이션 됨 */
    pointer-events: none;
    transform: translateX(100%);
}

/* 닫힌 뒤 완전히 숨길 때는 transition OFF */
.full-menu-overlay.closed {
    transition: none !important;
    visibility: hidden !important;
    pointer-events: none !important;
    transform: translateX(100%) !important;
    opacity: 0 !important;
}

.full-menu-inner {
    padding: 20px;
    height: 100%;
    display: flex;
    flex-direction: column;
    min-height: 0;
}

.full-menu-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 14px;
    border-bottom: 1px solid #e0e0e0;
}

.full-menu-title {
    font-size: 1.3rem;
    font-weight: 700;
}

.full-menu-close-btn {
    background: transparent;
    border: none;
    font-size: 1.4rem;
    cursor: pointer;
}

/* 왼쪽/오른쪽 각각 독립 스크롤 가능하도록 */
.full-menu-content {
    display: flex;
    flex-direction: column;
    padding-top: 20px;
    gap: 18px;
  /*  overflow: hidden;*/
    background: #fff;
    flex: 1 1 auto;
    min-height: 0;
}

/* 전체 스플릿 영역 */
.full-menu-split {
    display: flex;
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    flex: 1 1 auto;
    min-height: 0;
}

/* 왼쪽 카테고리 영역 */
.full-menu-left {
    width: 40%;
    border-right: 1px solid #eee;
    overflow-y: auto;
    padding: 10px 0;
}

.full-menu-item {
    font-size: 1.2rem;
    padding: 12px 16px;
    text-decoration: none;
    cursor: pointer;
    font-weight: 600;
}
.full-menu-item:hover {
    color: #648ca4;
}

/* 카테고리 활성화 */
.full-menu-item.active {
    background: #eaf2f6;
    color: #648ca4;
    border-right: 3px solid #648ca4;
}

/* 오른쪽 상세 기능 영역 */
.full-menu-right {
    width: 60%;
    background: #fff;
    padding: 0 0 480px 10px;
    overflow-y: auto;
    display: block;
    white-space: normal !important;
    flex: 1 1 auto;
    position: relative;
    max-height: 678px;
}

/* 오른쪽 작은 메뉴 */
.full-menu-small-item-group {
    display: flex;
    flex-direction: column;
    gap: 20px;
    padding: 4px 10px;
}

.full-menu-small-item {
    font-size: 1.1rem;
    color: #648ca4;
    font-weight: 600;
    text-decoration: none;
}

.full-profile-box {
    display: flex;
    align-items: center !important;
    background: #ffffff;
    padding: 18px 16px;
    margin-top: 16px;
    border-radius: 14px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    gap: 14px;
}

.menu-section {
    padding: 0 12px 14px 12px; /* 상하 여백 */
    background: #fff;
}

.menu-title {
    position: sticky; 
    top: 0; 
    background: #fff;
    padding: 10px 0;
    font-size: 1.3rem;
    font-weight: 700;
    border-bottom: 4px solid #648ca4;
    padding-left: 10px;
    z-index: 5;
    margin: 0;
}

.profile-icon {
    font-size: 48px;
    color: #648ca4;
}

.full-profile-center {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.profile-name {
    font-size: 1.15rem;
    font-weight: 700;
    color: #333;
    margin-bottom: 3px;
}

.profile-id {
    font-size: 0.85rem;
    color: #777;
}

.full-profile-right {
    display: flex;
    align-items: center;
    padding-top: 30px;
    padding-bottom: 12px;
}

.full-profile-right .logout-btn {
    border: none;
    background: none;
    font-size: 0.9rem;
    color: #648ca4;
    font-weight: 600;
    cursor: pointer;
    padding: 6px 8px;
    border-radius: 8px;
}

.full-profile-right .logout-btn:hover {
    background: rgba(100, 140, 164, 0.1);
}
.full-profile-right form button {
    all: unset; /* 기본 버튼 스타일 완전히 제거 */
    cursor: pointer;
    color: #648ca4;
    font-size: 1rem;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 4px;
}
body.menu-open {
    position: fixed !important;
    top: 0 !important;
    left: 50% !important;
    transform: translateX(-50%) !important;

    width: 100%;
    max-width: var(--frame-width);
    height: 100%;
    overflow: hidden !important;
}
/* Chrome, Safari, Edge */
.full-menu-left::-webkit-scrollbar,
.full-menu-right::-webkit-scrollbar,
.full-menu-small-item-group::-webkit-scrollbar {
    width: 0 !important;
    height: 0 !important;
    display: none !important;
}

/* Firefox */
.full-menu-left,
.full-menu-right,
.full-menu-small-item-group {
    scrollbar-width: none;
    -ms-overflow-style: none; /* IE/Edge */
}

/* ================= 게시판 관리 버튼 ================= */
.btn-manage-bbs {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 0.85rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 4px;
    text-decoration: none;
    transition: all 0.3s ease;
    margin-right: 10px;
    font-weight: 600;
    white-space: nowrap;
}

.btn-manage-bbs:hover {
    background: linear-gradient(135deg, #5a7d94 0%, #4a6d84 100%);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    color: white;
}

.btn-manage-bbs i {
    font-size: 0.9rem;
}
/* ================= 전체 햄버거 메뉴 오버레이 ================= */

/* 모바일 ~ 태블릿 대응 */
.modal-dialog {
    max-width: 90%;
    margin: 1rem auto;
}
@media (min-width: 500px) {
    .modal-dialog {
        max-width: 480px;
    }
}

.modal {
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    bottom: 0 !important;
    position: fixed !important;
    inset: 0 !important;
    overflow: hidden !important;
}
</style>

</head>
<sec:authorize access="isAuthenticated()">
   <sec:authentication property="principal.mberVO" var="mberVO" />
</sec:authorize>
<body class="index-page" data-context-path="${pageContext.request.contextPath}" data-user="${mberVO.mberId}" data-group="${mberVO.aptcmpl}" data-name="${mberVO.mberNm}">

<!-- 나혜선 채팅 시작 -->      
<!-- === CHAT WRAPPER (iframe 제거 버전) === -->
<c:if test="${not (fn:contains(pageContext.request.requestURI, '/login') 
                or fn:contains(pageContext.request.requestURI, '/signup'))}">
<div id="chatBox">

    <!-- 드래그 핸들 (PC 용) -->
    <div id="dragHandle"></div>

    <!-- 전체 채팅 레이아웃 -->
    <div class="chat-wrapper">

        <!-- 고정 헤더 -->
        <header class="chat-header" id="chatHeader">
            <span>💬 D-편한세상</span>
            <div class="chatcontrols">
                <button id="miniBtn">-</button>
                <button id="closeBtn">x</button>
            </div>
        </header>

        <!-- 채팅 내용 영역 -->
        <div class="chat-body">
            <div class="chat-area" id="chatLog"></div>
        </div>

        <!-- 고정 입력 영역 -->
        <div class="chat-input input-area">
            <input id="input" placeholder="메시지를 입력하세요..." autocomplete="off">
            <button id="send">전송</button>
        </div>

    </div>
</div>
</c:if>
<!-- 나혜선 채팅 끝 -->

    <div class="mobile-frame">

        <header id="header">
            <div class="header-inner">

                <div class="header-left">
                    <a href="/main"> <img src="/images/logo/logologo.png" alt="로고">
                    </a>
                </div>
                
                <div class="header-right">
                    <c:if test="${not (fn:contains(pageContext.request.requestURI, '/login') 
                or fn:contains(pageContext.request.requestURI, '/signup'))}">
                    <div class="dropdown ntcn-wrapper">
                    <div class="modal-scroll-area">
                        <a href="#"
                            class="text-white text-decoration-none position-relative ntcn-btn-wrapper"
                            id="ntcnDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-bell-fill"></i> <span
                            class="badge rounded-pill ntcn-badge" id="ntcnBadge">0</span>
                        </a>

                        <div
                            class="dropdown-menu dropdown-menu-end shadow ntcn-dropdown-menu"
                            aria-labelledby="ntcnDropdown">
                            <h6 class="dropdown-header text-white ntcn-dropdown-header"
                                id="ntcnHeader">알림 없음</h6>

                            <div id="ntcnDropdownList" class="ntcn-dropdown-list">
                                <div class="dropdown-item text-center text-muted">새 알림이
                                    없습니다</div>
                            </div>

                            <div class="dropdown-divider m-0"></div>

                            <a href="#"
                                class="dropdown-item text-center text-primary fw-bold ntcn-dropdown-footer"
                                onclick="event.stopPropagation(); showAllNotifications(); return false;">
                                <i class="bi bi-arrow-down-circle"></i> 모든 알림 보기
                            </a>
                        </div>
                        </div>
                    </div>
                    <div class="header-icon" id="menuBtn">
                        <i class="bi bi-list"></i>
                    </div>
                    </c:if>
                </div>

            </div>
        </header>

<!-- ================= 전체화면 햄버거 메뉴 ================= -->
<c:if test="${not (fn:contains(pageContext.request.requestURI, '/login') 
                or fn:contains(pageContext.request.requestURI, '/signup'))}">
<div id="fullMenuOverlay" class="full-menu-overlay">
    <div class="full-menu-inner">

        <div class="full-menu-header">
            <span class="full-menu-title">전체메뉴</span>
            <button id="menuCloseBtn" class="full-menu-close-btn">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        
        <div class="full-profile-box">
            
            <div class="full-profile-left" onclick="location.href='/mypage'">
                <i class="bi bi-person-circle profile-icon"></i>
            </div>
            
            <div class="full-profile-center">
                <div class="profile-name" onclick="location.href='/mypage'">
                    <c:out value="${mberVO.mberNm}"/>
                </div>
                <div class="profile-add" onclick="location.href='/mypage'">
                    <c:out value="${mberVO.aptcmpl}"/>동 <c:out value="${mberVO.ho}"/>호
                </div>
            </div>
        
            <div class="full-profile-right">
                <form action="/logout" method="post" >
                    <button type="submit">
                        로그아웃<i class="bi bi-box-arrow-right"></i>
                    </button>
                </form>
            </div>
        </div>
        
        <div class="full-menu-content">
        <div class="full-menu-split">
            <!-- 왼쪽 카테고리 -->
            <div class="full-menu-left">
                <div class="full-menu-item" data-menu="life">생활</div>
                <div class="full-menu-item" data-menu="managect">관리비</div>
                <div class="full-menu-item" data-menu="market">마켓</div>
                <div class="full-menu-item" data-menu="cvpl">민원</div>
                <div class="full-menu-item" data-menu="resve">예약</div>
                <div class="full-menu-item" data-menu="free">커뮤니티</div>
                <div class="full-menu-item" data-menu="vote">투표</div>
            </div>
            
            <!-- 오른쪽 상세 메뉴 -->
            <div class="full-menu-right">

                <div id="life" class="menu-section">
                <div id="life-anchor"></div>
                    <div class="menu-title">생활</div>
                    <div class="full-menu-small-item-group">
                        <a href="/notice/list" class="full-menu-small-item">공지사항</a>
                        <a href="/bbs/board/1" class="full-menu-small-item">분실물</a>
                        <a href="/dPyunHan/dPyunHan" class="full-menu-small-item">우리 아파트</a>
                    </div>
                </div>
                 
                <div id="managect" class="menu-section">
                <div id="managect-anchor"></div>
                    <div class="menu-title">관리비</div>
                    <div class="full-menu-small-item-group">
                        <a href="/main#levy" class="full-menu-small-item">관리비 조회</a>
                        <a href="/main#levy" class="full-menu-small-item">관리비 납부</a>
                        <a href="/main#levy" class="full-menu-small-item">관리비 예측</a>
                    </div>
                </div>
            
                <div id="market" class="menu-section">
                <div id="market-anchor"></div>
                    <div class="menu-title">마켓</div>
                    <div class="full-menu-small-item-group">
                        <a href="/bbs/board/2" class="full-menu-small-item">당근 마켓</a>
                        <a href="/bbs/board/3" class="full-menu-small-item">당근 거래 후기</a>
                    </div>
                </div>

                <div id="cvpl" class="menu-section">
                <div id="cvpl-anchor"></div>
                    <div class="menu-title">민원</div>
                    <div class="full-menu-small-item-group">
                        <a href="/cvpl/list?open=registerModal" class="full-menu-small-item">민원 접수</a>
                        <a href="/cvpl/list" class="full-menu-small-item">내 민원</a>
                        <a href="/bbs/board/4" class="full-menu-small-item">신고해요</a>
                        <a href="/bbs/board/5" class="full-menu-small-item">건의해요</a>
                    </div>
                </div>
            
                <div id="resve" class="menu-section">
                <div id="resve-anchor"></div>
                    <div class="menu-title">예약</div>
                    <div class="full-menu-small-item-group">
                        <a href="/main?open=visitVhcle#visitVhcle" class="full-menu-small-item">방문차량 예약</a>
                        <a href="/visit/history" class="full-menu-small-item">방문차량 예약 내역</a>
                        <a href="/main#resve1" class="full-menu-small-item">커뮤니티 시설 예약</a>
                        <a href="/main?open=resveMber#resve1" class="full-menu-small-item">커뮤니티 시설 예약 내역</a>
                    </div>
                </div>
                
                <div id="free" class="menu-section">
                    <div id="free-anchor"></div>

                    <div style="display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; background: #fff; padding: 10px 0; border-bottom: 4px solid #648ca4; padding-left: 10px; z-index: 5; margin: 0;">
                        
                        <div style="font-size: 1.3rem; font-weight: 700; padding: 0; margin: 0;">커뮤니티</div>
                        
                        <!-- 입주민 대표 전용 관리 버튼 -->
                        <sec:authorize access="hasRole('ROLE_MBER_HEAD')">
                            <a href="/bbs/bbsGroupList" class="btn-manage-bbs">
                                <i class="bi bi-gear-fill"></i> 관리
                            </a>
                        </sec:authorize>
                    </div>

                    <div class="full-menu-small-item-group" id="bbsMenuList">
                        <div class="text-center text-muted" style="font-size: 0.9rem; padding: 10px 0;">
                            <i class="bi bi-hourglass-split"></i> 게시판 로드 중...
                        </div>
                    </div>
                </div>
                
                <div id="vote" class="menu-section">
                <div id="vote-anchor"></div>          
                    <div class="menu-title">투표</div>
                    <div class="full-menu-small-item-group">
                        <a href="/vote/memVoteList" class="full-menu-small-item">투표 목록</a>
                        <a href="/vote/memVoteList" class="full-menu-small-item">현재 진행 중인 투표</a>
                        <a href="/bbs/board/6" class="full-menu-small-item">제안해요</a>
                    </div>
                </div>
            </div>
        </div>
        </div>

    </div>
</div>
</c:if>

<!-- ====================================================== -->
<script>
document.addEventListener("DOMContentLoaded", () => {
    const menuBtn = document.getElementById("menuBtn");
    const menuOverlay = document.getElementById("fullMenuOverlay");
    const closeBtn = document.getElementById("menuCloseBtn");

    // 열기
    if (menuBtn && menuOverlay && closeBtn) {
        menuBtn.addEventListener("click", () => {
            menuOverlay.classList.remove("closed");
            menuOverlay.classList.add("active");
            document.body.classList.add("menu-open");
    
            loadMenuList();
        });
    
    
        // 닫기
        closeBtn.addEventListener("click", () => {
            menuOverlay.classList.add("closing");
    
            setTimeout(() => {
                menuOverlay.classList.remove("active");
                menuOverlay.classList.remove("closing");
    
                // transition 없는 숨김 상태
                menuOverlay.classList.add("closed");
    
                document.body.classList.remove("menu-open");
            }, 550);
        });
    }
});

// 햄버거 스플릿 메뉴
document.addEventListener("DOMContentLoaded", () => {
    const leftItems = document.querySelectorAll(".full-menu-item");
    const rightPanel = document.querySelector(".full-menu-right");
    const sections = document.querySelectorAll(".menu-section");

    if (!rightPanel || leftItems.length === 0 || sections.length === 0) {
        return;
    }
    
    // 각 섹션 위치 캐싱
    const sectionPositions = {};
    sections.forEach(sec => {
        let y = 0;
        let node = sec;
        while (node && node !== rightPanel) {
            y += node.offsetTop;
            node = node.offsetParent;
        }
        sectionPositions[sec.id] = y;
    });

    // 스크롤 시 자동 활성화
    rightPanel.addEventListener("scroll", () => {
        const scrollPos = rightPanel.scrollTop + 120; // 보정값 120px

        let currentSection = null;

        sections.forEach(sec => {
            if (scrollPos >= sectionPositions[sec.id]) {
                currentSection = sec.id;
            }
        });

        if (currentSection) {
            leftItems.forEach(i => i.classList.remove("active"));
            const target = document.querySelector(`.full-menu-item[data-menu="\${currentSection}"]`);
            if (target) target.classList.add("active");
        }
    });

    // 클릭 시 스크롤 이동 (기존 코드 유지)
    leftItems.forEach(item => {
        item.addEventListener("click", () => {
            const target = item.dataset.menu;
            const anchor = rightPanel.querySelector(`#\${target}-anchor`);
            const offsetTop = anchor.offsetTop;

            rightPanel.scrollTo({
                top: offsetTop,
                behavior: "smooth"
            });

            leftItems.forEach(i => i.classList.remove("active"));
            item.classList.add("active");
        });
    });

    leftItems[0].classList.add("active");
});

// 게시판 목록 로드
function loadMenuList(){
    fetch("/bbs/bbsGroupList/data",{
        method:"GET"
    })
    .then(response => {
        if(!response.ok){
            throw new Error("서버 응답 오류");
        }
        return response.json();
    })
    .then(data=>{
        displayBbsMenu(data);//data = 게시판 목록
    })
    .catch(error=>{
        document.querySelector("#bbsMenuList").innerHTML = 
        '<div class="text-center text-muted" style="font-size: 0.9rem; padding: 10px 0;">' +
            '<i class="bi bi-exclamation-triangle"></i> 게시판을 불러올 수 없습니다' +
        '</div>';
    })
}

// 게시판 메뉴 표시
function displayBbsMenu(bbsGroupList){
    const bbsMenuList = document.querySelector("#bbsMenuList");

    //게시판이 없는 경우
    if(!bbsGroupList || bbsGroupList.length === 0){
        bbsMenuList.innerHTML =
            '<div class="text-center text-muted" style="font-size: 0.9rem; padding: 10px 0;">' +
                '등록된 게시판이 없습니다' +
            '</div>';
        return;
    }

    // 게시판 목록 생성
    let html = '';

    
    bbsGroupList.forEach(function(bbsGroup, index){

        // 고정 게시판 6개 건너뛰기
        if(index < 6) return;

        // Oracle hashMap은 대문자 키 반환
        const bbsGroupSn = bbsGroup.BBS_GROUP_SN || bbsGroup.bbsGroupSn;
        const bbsNm = bbsGroup.BBS_NM || bbsGroup.bbsNm;

        html +=
            '<a href="/bbs/board/' + bbsGroupSn + '" class="full-menu-small-item">' +
                bbsNm +
            '</a>';
    });

    bbsMenuList.innerHTML = html;

}

document.addEventListener("DOMContentLoaded", () => {
    const menuOverlay = document.getElementById("fullMenuOverlay");

    // 상세 메뉴(오른쪽 작은 메뉴) 클릭 시 햄버거 닫기
    document.querySelectorAll(".full-menu-small-item").forEach(item => {
        item.addEventListener("click", () => {
            // 닫기 애니메이션 적용
            menuOverlay.classList.add("closing");

            setTimeout(() => {
                menuOverlay.classList.remove("active", "closing");
                menuOverlay.classList.add("closed");
                document.body.classList.remove("menu-open");
            }, 550); // 기존 0.55s 애니메이션과 동기화
        });
    });
});

</script>
<c:if test="${not (fn:contains(pageContext.request.requestURI, '/login') 
                or fn:contains(pageContext.request.requestURI, '/signup'))}">
<script type="text/javascript" src="/js/global/chat.js"></script>
</c:if>
        <!-- 여기서부터 각 페이지의 본문이 들어갑니다. 푸터에서 </div> </body> </html> 을 닫아주세요. -->