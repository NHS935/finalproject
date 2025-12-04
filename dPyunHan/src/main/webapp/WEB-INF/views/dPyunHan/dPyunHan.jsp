<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- /// header 시작  -->
<%@ include file="../include/headerContents.jsp"%>

<style>
/* 스크롤바 전체 */
.terms-scroll::-webkit-scrollbar {
    width: 8px; 
}

/* 스크롤 트랙(배경) */
.terms-scroll::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 8px;
}

/* 스크롤 thumb(움직이는 부분) */
.terms-scroll::-webkit-scrollbar-thumb {
    background: #F66214;     /* 스크롤 색 */
    border-radius: 8px;
}

/* hover 시 색 진하게 */
.terms-scroll::-webkit-scrollbar-thumb:hover {
    background: #e06626;
}

</style>
<!-- /// body 시작 /// -->
<div class="card" style="margin:10px; padding:10px; border:3px solid rgba(100, 140, 164, 0.75); border-radius:14px;">
    <div class="card-title" style="text-align:center; font-size:20px; font-weight:bold; margin-bottom:6px;">
    <img src="/images/logo/logologo.png" alt="로고" style="height:24px; width:24px; margin-bottom:6px;"> D-편한세상
    </div>
	<!-- 목록 -->
	<div class="mobile-list">
	   <div class="input-block" >
			<div class="form-group privacy">
			    <div class="terms-scroll" tabindex="0" style="height: calc(100vh - 204px);  border: 0px solid #dfe0df; border-radius: 4px; padding: 12px 14px; overflow-y: auto; background: #fff; color: #000;">
	                <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">단지가 가진 품격과 시스템을 소개합니다!</strong><br>
                    <br>D-편한세상은 주거 공간을 넘어, 일상 전반의 품질을 높이는 스마트 커뮤니티 단지입니다.
                    <br>Dreamneer가 설계한 관리 시스템을 기반으로, 입주민과 관리자가 모두 편안하고 명확한 서비스를 누립니다.<br><br><br>
                    
	                <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">커뮤니티 시설</strong>
                    <br>생활과 여가, 자기계발이 자연스럽게 공존하도록 구성되어 있습니다.
                    <br>모든 시설은 Dreamneer 예약 시스템으로 정원·시간대가 명확하게 관리되어 입주민 누구나 공평하게 이용할 수 있습니다.
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;📚 독서실 – 조용하고 쾌적한 집중 공간<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🏊 수영장 – 사계절 이용 가능한 힐링·운동 공간<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🎱 당구장 – 가볍게 즐기는 실내 여가<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🎾 테니스장 – 활동적인 주민을 위한 대표 인기 시설<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🏟️ 세미나실 – 모임·스터디·강의까지 커버<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🏋️ 헬스장 – PT존급 장비 구성<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🧖 사우나 – 운동 후 피로회복에 최적화<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;⛳ 골프장 – 스크린 골프 이상의 만족도를 주는 공간<br>
                    <br>&nbsp;&nbsp;&nbsp;&nbsp;🏓 탁구장 – 남녀노소 즐기는 커뮤니티의 중심<br><br><br>
                    
	                <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">생활을 단순하게 하는 관리 서비스</strong>
	                <br>복잡한 절차를 하나의 흐름으로 정리하여 입주민은 사용에 집중하고 관리자는 운영에 집중할 수 있습니다.
                    <br>&nbsp;&nbsp;①&nbsp;&nbsp;관리비 조회·납부 — 모바일로 간편하게 처리<br>
                    <br>&nbsp;&nbsp;②&nbsp;&nbsp;민원 접수·확인 — 진행상황을 실시간으로 확인<br>
                    <br>&nbsp;&nbsp;③&nbsp;&nbsp;방문 차량 예약 — 사전 등록으로 혼잡 없이 통과<br>
                    <br>&nbsp;&nbsp;④&nbsp;&nbsp;커뮤니티 시설 예약 — 중복 방지·정원 관리 자동화<br><br><br>
                    
	                <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">소통과 참여를 담은 입주민 플랫폼</strong>
	                <br>단지 운영에 입주민이 직접 참여하며 의견이 반영되는 구조를 마련했습니다.
                    <br>&nbsp;&nbsp;①&nbsp;&nbsp;자율 게시판 — 단지 내 소통을 자유롭게<br>
                    <br>&nbsp;&nbsp;②&nbsp;&nbsp;전자 투표 — 중요한 결정사항을 공정하고 투명하게 처리<br><br><br>
                    
                    <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">Dreamneer 관리자의 역할</strong>
                    <br>Dreamneer 시스템은 결재·시설·예약·민원 등 관리 업무의 전체 흐름을 체계적으로 통합했습니다.
                    <br>관리자는 반복 업무에서 벗어나, D-편한세상 단지를 더 좋은 방향으로 이끄는 ‘관리 역할’에 집중할 수 있습니다.
	            </div>
	        </div>
	    </div>
	</div>
</div>

<!-- /// footer 시작 /// -->
<%@ include file="../include/footerContents.jsp"%>
<!-- /// footer 끝 /// -->