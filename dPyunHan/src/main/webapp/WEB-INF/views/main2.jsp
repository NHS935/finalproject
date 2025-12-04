<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<%@ include file="./include/header.jsp" %>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
<!-- ///// content 시작 ///// -->

<h1>메인페이지!!</h1>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/vote/voteMtr';">투표</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/bbs/bbsGroupList';">게시판 목록</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/resve/list';">커뮤니티 예약</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/cvpl/list';">민원게시판</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/notice/list';">공지사항</button>
	
	<sec:authorize access="isAuthenticated()">
        <h3>로그인 정보 (Spring Security)</h3>
        <p><b>아이디 :</b> <sec:authentication property="principal.username" /></p>
        <p><b>권한 :</b> <sec:authentication property="principal.authorities" /></p>
    </sec:authorize>
	
	<!-- 세션 정보 확인 (CustomLoginSuccessHandler에서 저장한 값) -->
    <h3> 세션 정보</h3>
    <p><b>세션 ID :</b> <%= session.getId() %></p>
    <p><b>회원 아이디 (mberId) :</b> <%= session.getAttribute("mberId") %></p>
    <p><b>세대 ID (hshldId) :</b> <%= session.getAttribute("hshldId") %></p>
	
        <button type="button" onclick="location.href='/rqest/rqest'" class="btn btn-primary">
            관리비 납부 내역 보기
        </button>
        <button type="button" onclick="location.href='/visit/reserve'" class="btn btn-primary">
            방문 주차 예약
        </button>
        <button type="button" onclick="location.href='/logout'" class="btn btn-secondary">
            로그아웃
        </button>
    
    
    
        <p style="color: red;">로그인 후 이용 가능합니다.</p>
        <button type="button" onclick="location.href='/login'" class="btn btn-primary">
            로그인 페이지로 이동
        </button>
        <button type="button" onclick="location.href='/signup'" class="btn btn-primary">
            회원가입
        </button>
    

<!-- ///// content 끝 ///// -->

<%@ include file="./include/footer.jsp" %>   