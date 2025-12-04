<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.12.2/lottie.min.js"></script>

<!-- 헤더 -->
<script>
    const prc = "${pageContext.request.contextPath}";
</script>
<style>
h2 {
    font-size: 1.5rem !important;
    font-weight: 700;
    color: #374E5C !important;
}

.title-row h2 {
    display: inline-flex;
    align-items: center;
    margin: 0;
    padding: 0;
    line-height: 1;
}

.icon-circle-wrap {
    padding: 8px 15px;
    background: #374E5C;
    border-radius: 30px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    transition: 0.25s;
    border: 2px solid #374E5C; /* 겉 테두리 */
    background: #ABBECA;   /* 배경 투명하게 */
}

.icon-circle-wrap i {
    font-size: 28px;
    color: #374E5C;
}

#resve1 .title-row h2::after {
    content: "";
    display: block;
    width: 240px !important;
    height: 2px;
    background: #ff4a17;
    margin: 0;
}

.title-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.title-row button {
    margin-left: auto !important;
    margin-right: 0 !important;
}
/**/

#vote .title-row h2::after {
    content: "";
    display: block;
    width: 288px !important;
    height: 2px;
    background: #ff4a17;
    margin: 0;
}

#visitVhcle .title-row h2::after {
    content: "";
    display: block;
    width: 240px !important;
    height: 2.5px;
    background: #ff4a17;
    margin: 0;
}

#levy .title-row h2::after {
    content: "";
    display: block;
    width: 385px !important;
    height: 2px;
    background: #ff4a17;
    margin: 0;
}

#calender .title-row h2::after {
    content: "";
    display: block;
    width: 275px !important;
    height: 2px;
    background: #ff4a17;
    margin: 0;
}

.footer-info .social-links .ms-auto a:hover,
.footer-info .credits a:hover {
    color: #124A8B !important;
}

/* 스피너 적용 */
.spinner-container {
  display: inline-block;
}

.ai-spinner {
  width: 60px;
  height: 60px;
  border: 4px solid rgba(102, 126, 234, 0.1);
  border-top: 4px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@include file="./include/headerContents.jsp"%>
<!-- Testimonials Section -->
<section id="home" style="padding:0px;"></section>
<section id="testimonials" class="testimonials section dark-background">
<c:set var="hshldId" value="${mberVO.hshldId}" scope="session" />
   <link rel="stylesheet" href="/css/main/swiper.css">
   <script type="text/javascript" src="/js/main/swiper.js"></script>
   <link href="/dewi/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

   <div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="swiper testimonial-swiper">
         <div class="swiper-wrapper">
            <div class="swiper-slide">
               <div class="testimonial-item">
                  <img src="images/mainBanner/hello.png" alt="안녕하세요">
               </div>
            </div>
            <div class="swiper-slide">
               <div class="testimonial-item">
                  <img src="images/mainBanner/newYear.png" alt="새해인사">
               </div>
            </div>
            <div class="swiper-slide">
               <div class="testimonial-item">
                  <a href="/bbs/board/2"> <img src="images/mainBanner/danggunPost.png"
                     alt="당근 게시물" style="height: 250px; weight: 475px">
                  </a>
               </div>
            </div>
            <div class="swiper-slide">
               <div class="testimonial-item">
                  <img src="images/mainBanner/recycling.png" alt="분리수거">
               </div>
            </div>
         </div>
         <div class="swiper-pagination"></div>
      </div>
   </div>
</section>
<!-- /Testimonials Section -->

<!-- ===== 최근 공지사항 슬라이드 ===== -->
<section id="noticeBanner" class="light-background" style="padding: 0;">
  <div class="notice-line-wrapper" data-aos="fade-up">
  
    <i class="fas fa-bullhorn notice-icon"></i>

    <!-- 슬라이더 -->
    <div class="swiper notice-line-swiper">
      <div class="swiper-wrapper">
        <c:forEach var="n" items="${articlePage.content}">
          <div class="swiper-slide">
            <div class="notice-line-item" data-notice-sn="${n.noticeSn}">
              <span class="notice-title">${n.noticeSj}</span>
              <span class="notice-date">
                <fmt:formatDate value="${n.noticeWritngDt}" pattern="yyyy-MM-dd" />
              </span>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>

	  <!-- 우측 이모티콘 -->
	  <button type="button" class="notice-expand-btn" id="noticeExpandBtn">
	     ➕
	  </button>

	</div>
	  <!-- 전체 공지사항 목록 (숨김 상태) -->
	<div class="notice-full-list" id="noticeFullList">
	  <ul class="notice-items">
	    <c:forEach var="n" items="${articlePage.content}">
	      <li class="notice-full-item" data-notice-sn="${n.noticeSn}">
	        <div class="notice-full-content">
	          <span class="notice-full-title">${n.noticeSj}</span>
	          <span class="notice-full-date">
	            <fmt:formatDate value="${n.noticeWritngDt}" pattern="yyyy-MM-dd" />
	          </span>
	        </div>
	        <i class="fas fa-chevron-right"></i>
	      </li>
	    </c:forEach>
	  </ul>
	</div>
</section>

<!-- ///// 관리비 조회SECTION 시작 ///// -->
<style>
/* ✅ 모달 애니메이션 빠르게 */
#predictModal.fade .modal-dialog {
  transition: transform 0.15s ease-out; /* 기본 0.3s → 0.15s */
}

#predictModal.show .modal-dialog {
  transform: none;
}
</style>
<section id="levy" class="services-2 section light-background">
    <div class="container section-title" data-aos="fade-up" style="padding-bottom: 15px;">
    <div class="title-row">
        <h2>관리비</h2>
        </div>
    </div>
    
    <!-- 관리비 조회, 납부 11-->
    <div class="container-fluid" data-aos="fade-up" data-aos-delay="120">
        <div class="row justify-content-center gy-4">
            <div class="col-12 col-md-12">
                <div class="manage-container"> 
                    <div class="service-item manage-card">
                        <div class="details position-relative">
                            <div class="manage-wrapper">
                                
                                <form>
                                    <label class="form-label me-2">조회 연월:</label>
                                    <input type="month" id="searchYm" name="ym" value="${yearMonth}"
                                        class="form-control form-control-sm d-inline-block">
                                    <input type="hidden" name="hshldId" value="${hshldId}" />
                                      <input type="hidden" name="mberNm" value="${mberVO.mberNm}" />
                                      <input type="hidden" name="email" value="${mberVO.email}" />
            
                                    
                                    <button type="button" data-sn="${rq.rqestSn}" id="searchBtn"
                                        class="btn btn-primary btn-sm ms-2">
                                        <i class="fas fa-search"></i> 조회
                                    </button>
                                    <button type="button" data-sn="${rq.rqestSn}" id="predictBtn"
                                        class="btn btn-primary btn-sm ms-2">
                                        <i class="fas fa-search"></i> 예측
                                    </button>
                                </form>

                                <div id="rqestResult" class="mt-3">
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 예측 차트 모달 -->
	<div class="modal fade cute-modal" id="predictModal" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog modal-lg modal-dialog-centered" style="max-height: 80vh;">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">
	          <i class="fas fa-chart-line"></i> 관리비 예상 사용량 예측
	        </h5>
	        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body" style="padding: 30px; max-height: calc(90vh - 120px); overflow-y: auto;">
	  
	   <div id="predictSpinner" style="display:none; text-align:center; padding: 10px 10px;">
	  <!-- Lottie 컨테이너 -->
	  <div id="lottie-container" style="width: 300px; height:300px; margin: 0 auto;"></div>
	  
	  <div style="margin-top: 20px;">
	    <p style="font-size: 18px; font-weight: 600; color: #667eea; margin-bottom: 8px;">
	      <i class="fas fa-brain"></i> 단순 선형 회귀 분석 중...
	    </p>
	    <p style="font-size: 14px; color: #6b7280;">
	      관리비 사용 패턴을 학습하고 있습니다
	    </p>
	  </div>
	</div>
	  
	  
	  <!-- 결과 영역 + 범례 -->
	  <div id="predictResult" style="display:none; background: #66A5EA; color: white; border-radius: 10px; padding: 15px; margin-bottom: 20px;">
	  <div style="text-align: center; margin-bottom: 12px;">
	    <div id="predictResultText"></div>
	  </div>
	  <div id="customLegend" style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; padding-top: 10px; border-top: 1px solid rgba(255,255,255,0.2);"></div>
	</div>
	  <!-- 그래프 영역 -->
	  <div id="predictChart"></div>  
	</div>
	    </div>
	  </div>
	</div>
<%--     
    <!-- 관리비 예측 -->
    <div class="container-fluid" data-aos="fade-up" data-aos-delay="120">
        <div class="row justify-content-center gy-4">
            <div class="col-12 col-md-12">
                <div class="manage-container"> 
                    <div class="service-item manage-card">
                        <div class="details position-relative">
                            <div class="manage-wrapper">
                                
                                <form>
                                    <label class="form-label me-2">예측 연월</label>
                                    <input type="month" id="searchYm" name="ym" value="${yearMonth}"
                                        class="form-control form-control-sm d-inline-block">
                                    <input type="hidden" name="hshldId" value="${hshldId}" />
                                    
                                    <button type="button" data-sn="${rq.rqestSn}" id="searchBtn"
                                        class="btn btn-primary btn-sm ms-2">
                                        <i class="fas fa-search"></i> 예측
                                    </button>
                                </form>

                                <div id="rqestResult" class="mt-3">
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> --%>
</section>
<!-- ///// 관리비 조회SECTION 끝 ///// -->

<!-- ///// 일정 조회 시작 ///// -->
<!-- Section -->
<section id="calender" class="noticeSection light-background">
   <div class="container section-title" data-aos="fade-up" style="padding-bottom: 15px;">
   <div class="title-row">
      <h2>우리 아파트 일정</h2>
      </div>
   </div>
   <div class="container-fluid" data-aos="fade-up" data-aos-delay="120">
      <div class="row justify-content-center gy-4">
         <div class="col-12 col-md-12">
            <div class="service-item manage-card">
               <div class="details position-relative">
                  <div class="manage-wrapper">
                     <div id="Wrapper">
                        <div id="calendar"></div>
                     </div>
                     <!--상세보기 모달 시작-->
                     <input type="hidden" id="detailschdulSn" name="detailschdulSn"
                        value="${fxVO.schdulSn}" />
                  </div>
               </div>
            </div>
         </div>
      </div>
</section>

<!-- /// 캘린더 모달 시작 /// -->
<div class="modal fade cute-modal" id="calendarModal" tabindex="-1" aria-labelledby="calendarModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">

      <!-- 헤더 -->
      <div class="modal-header">
        <h5 class="modal-title" id="calendarModalLabel" style="font-size:0.95rem; margin:0;">
          일정 상세 보기
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <!-- 바디 -->
      <div class="modal-body">
      <div class="modal-scroll-area">
        <form id="detailscheduleForm">
          <!-- 숨겨진 담당자 정보 (JS 위해 유지) -->
          <input type="hidden"
                 id="calendarempId"
                 name="calendarempId"
                 class="form-control form-control-sm" />

          <div class="task-panel">

            <!-- 카드 1: 제목 + 시작/종료 + 장소 -->
            <div class="calendar-main-card">
              <!-- 제목 -->
              <div class="calendar-row">
                <div class="calendar-field-label">제목</div>
                <input type="text"
                       id="calendarSj"
                       name="calendarSj"
                       class="form-control form-control-sm"
                       readonly />
              </div>

              <!-- 구분 (데이터용, 화면에서 숨김) -->
              <div class="calendar-row" style="display:none;">
                <div class="calendar-field-label">구분</div>
                <select id="calendarIem"
                        name="calendarIem"
                        class="form-control form-control-sm">
                  <option value="">선택</option>
                  <option value="시설">시설</option>
                  <option value="커뮤니티">커뮤니티</option>
                  <option value="개인일정">개인일정</option>
                </select>
              </div>

              <!-- 시작/종료 일시 -->
              <div class="calendar-row">
                <div class="calendar-field-inline-grid">
                  <div>
                    <span class="calendar-field-label-sub">시작일시</span>
                    <input type="datetime-local"
                           id="calendarBeginDt"
                           name="calendarBeginDt"
                           class="form-control form-control-sm"
                           readonly />
                  </div>
                  <div>
                    <span class="calendar-field-label-sub">종료일시</span>
                    <input type="datetime-local"
                           id="calendarEndDt"
                           name="calendarEndDt"
                           class="form-control form-control-sm"
                           readonly />
                  </div>
                </div>
              </div>

              <!-- 장소 -->
              <div class="calendar-row">
                <div class="calendar-field-label">장소</div>
                <input type="text"
                       id="calendarPlace"
                       name="calendarPlace"
                       class="form-control form-control-sm"
                       readonly />
              </div>
            </div>

            <!-- 카드 2: 내용 -->
            <div class="calendar-main-card mb-0">
              <div class="calendar-section-title">내용</div>
              <textarea id="calendarCn"
                        name="calendarCn"
                        class="form-control form-control-sm"
                        rows="3"
                        style="resize:none;"
                        readonly></textarea>
            </div>

          </div>
        </form>
      </div>

      <!-- 푸터 -->
      <div class="modal-footer">
        <!-- 필요하면 버튼 추가 -->
      </div>
    </div>
    </div>
  </div>
</div>
<!--캘린더 모달 끝-->
<!-- 일정 Section끝 -->

<!-- /////////////////////////시설 예약///////////////////////// -->
<section id="resve1" class="services-2 section light-background">
   <!-- Section Title -->
    <div class="container section-title" data-aos="fade-up" style="padding-bottom: 15px;">
   <div class="title-row">
          <h2>편의시설 예약</h2>
          <a href="#" class="open-resvember-btn" data-bs-toggle="modal" data-bs-target="#resveMberModal">
              <div class="icon-circle-wrap">
                  <i class="bi bi-card-list" style="font-size:30px;"></i>
              </div>
          </a>
       </div>
   </div>
   <!-- End Section Title -->

   <div class="container">
      <div class="row gy-4">
         <!-- 1~4 카드 -->
         <c:forEach var="cmmntyVO" items="${cmmntyVOList}" varStatus="stat">
            <c:if test="${stat.count <= 9}">
               <div class="col-md-4" data-aos="fade-up"
                  data-aos-delay="${stat.count * 100}">
                  <div class="service-item d-flex position-relative h-100 js-resve-card"
                     data-cmmntysn="${cmmntyVO.cmmntySn}" role="button" tabindex="0" style="cursor: pointer;">

                     <div>
                        <h4 class="title">
                           <a href="#" class="stretched-link">${cmmntyVO.cmmntyNm}</a>
                        </h4>
                        <p class="description mb-2">
                           <strong>총 수용인원:</strong> ${cmmntyVO.totAceptncNmpr}<br><br>
                           <strong>운영시간</strong><br>${cmmntyVO.cmmntyOpnVwpoint} ~ ${cmmntyVO.cmmntyClosVwpoint}
                        </p>
                        <!-- 숨김 버튼 -->
                        <button type="button" class="open-resve-btn d-none" data-cmmntysn="${cmmntyVO.cmmntySn}">예약</button>
                     </div>
                  </div>
               </div>
            </c:if>
         </c:forEach>
      </div>
   </div>
</section>

<!-- 예약 모달 -->
<div class="modal fade cute-modal" id="resveModal" tabindex="-1" aria-hidden="true" >
   <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content">
         <div class="modal-header">
            <h5 class="modal-title">예약</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body" id="modalResveContent">
            <p class="text-center text-muted">불러오는 중...</p>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn-cancel" data-bs-dismiss="modal">취소</button>
            <button type="button" class="btn-reserve" onclick="submitReservation()">예약</button>
         </div>
      </div>
   </div>
</div>

<!-- 예약현황 모달 -->
<div class="modal fade cute-modal" id="resveMberModal" tabindex="-1" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
      <div class="modal-content">
     <!-- 모달 전용 스크롤 스타일 (이 모달 안에서만 적용됨) -->
         <style>
            #resveMberModal .modal-body::-webkit-scrollbar {
                width: 8px !important;
                height: 8px !important;
            }
            #resveMberModal .modal-body::-webkit-scrollbar-track {
                background: #f1f1f1 !important;
                border-radius: 8px !important;
            }
            #resveMberModal .modal-body::-webkit-scrollbar-thumb {
                background: #F66214 !important;
                border-radius: 8px !important;
            }
            #resveMberModal .modal-body::-webkit-scrollbar-thumb:hover {
                background: #e06626 !important;
            }
         </style>
      
         <div class="modal-header">
            <h5 class="modal-title">내 예약 현황</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body" id="modalMberContent" style="max-height:70vh !important; overflow-y:auto !important; scrollbar-width:auto !important; -ms-overflow-style:auto !important;">
<div class="modal-scroll-area">
            <!-- 탭 버튼 -->
            <ul class="nav nav-pills" id="resveTabs">
               <li class="nav-item"><button class="nav-link active" data-tab="all">전체</button></li>
               <li class="nav-item"><button class="nav-link" data-tab="plan">방문 예정</button></li>
               <li class="nav-item"><button class="nav-link" data-tab="success">방문 완료</button></li>
               <li class="nav-item"><button class="nav-link" data-tab="cancel">취소</button></li>
            </ul>

            <!-- 단일 테이블 (헤더 고정) -->
            <table class="table table-striped align-middle text-center mt-3">
               <thead class="table-dark">
                  <tr>
                     <th>번호</th>
                     <th>커뮤니티시설</th>
                     <th>예약 날짜</th>
                     <th>예약 시간</th>
                     <th>인원 수</th>
                     <th>예약 상태</th>
                  </tr>
               </thead>
               <tbody id="resveTabBody">
                  <tr>
                     <td colspan="6" class="text-muted py-3">예약 내역이 없습니다.</td>
                  </tr>
               </tbody>
            </table>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn-cancel" data-bs-dismiss="modal">닫기</button>
         </div>
         </div>
      </div>
   </div>
</div>

<!-- 예약상세 모달 -->
<div class="modal fade cute-modal" id="resveMberDetailModal" tabindex="-1" aria-hidden="true">
   <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content">
         <div class="modal-header">
            <h5 class="modal-title">내 예약 상세</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body" id="modalMberDetailContent">
            <p class="text-center text-muted">불러오는 중...</p>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn-cancel" data-bs-dismiss="modal">닫기</button>
            <button type="button" class="btn-reserve" onclick="resveCancel()">예약 취소</button>
         </div>
      </div>
   </div>
</div>
<!-- /////////////////////////////예약끝///////////////////////////// -->



<!-- visitVhcle Section -->
<section id="visitVhcle" class="services-2 section light-background">
  <div class="container section-title" data-aos="fade-up" style="padding-bottom: 15px;">
    <div class="title-row">
    <h2>방문차량 예약</h2>
    <a href="/visit/history"><div class="icon-circle-wrap"><i class="bi bi-card-list" style="font-size:30px;"></i></div></a>
    </div>
    </div>

  <div class="visit-time-card">
    <div class="visit-time-info" style="display:flex; align-items:center; justify-content:center; gap:12px; text-align:center;">
      <p class="monthly-limit" style="margin:0;">
        세대별 월 예약 가능 시간은 <span class="highlight">120시간</span> 입니다.<br>
        매월 <span class="highlight">1일</span> 사용시간이 초기화 됩니다.
      </p>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#reserveModal"
              style="background-color: rgba(135, 163, 179, 0.7); border: 2px solid rgb(135, 163, 179);">
        예약
      </button>
    </div>
      <hr>
      <div class="visit-time-info">
      <p class="remaining-time">
        이번달 방문 예약 가능한<br>
        <strong>주차시간이 <span class="highlight" id="remainingTime">--</span> 남았습니다.</strong>
      </p>
      <p class="monthly-limit">
        <span>누적 사용시간 : </span>
         <strong> <span class="highlight" id="accmltTime">--</span> </strong>
      </p>
      </div>
  </div>
</section>

<!-- 예약 모달 -->
<!-- 방문차량 예약 모달 -->
<div class="modal fade cute-modal" id="reserveModal" tabindex="-1" aria-labelledby="reserveModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg"> <div class="modal-content">
      
      <div class="modal-header">
        <h5 class="modal-title" id="reserveModalLabel"><i class="fas fa-car"></i> 방문차량 예약</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      
      <div class="modal-body">
        <form id="reserveForm" method="post">

          <div class="mb-4">
            <label class="form-label fw-bold">차량 번호</label>
            <input type="text" name="vhcleNo" id="vhcleNo" class="form-control" placeholder="예: 12가3456" required>
          </div>

          <div class="reservation-selector border rounded p-3 mb-4">
            
            <div class="date-selector text-center mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <button type="button" class="btn btn-sm btn-outline-secondary date-nav" id="prevWeekBtn">
                        <i class="bi bi-chevron-left"></i> 지난 주
                    </button>
                    <span id="currentMonthYear" class="fw-bold fs-5">2025년 11월</span>
                    <button type="button" class="btn btn-sm btn-outline-secondary date-nav" id="nextWeekBtn">
                        다음 주 <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
                <div class="d-flex text-secondary mb-2 fw-bold date-header">
                    <span class="day-label w-100">일</span>
                    <span class="day-label w-100">월</span>
                    <span class="day-label w-100">화</span>
                    <span class="day-label w-100">수</span>
                    <span class="day-label w-100">목</span>
                    <span class="day-label w-100">금</span>
                    <span class="day-label w-100">토</span>
                </div>
                <div class="d-flex justify-content-between date-group" id="dateButtons">
                    </div>
            </div>
            
            <hr>

            <div class="row text-center selector-body">
                
                <div class="col-6"> 
                    <h6 class="fw-bold mb-3">시작 시간 선택</h6>
                    <div id="timeSlots" class="list-group list-group-flush time-slots-group">
                        </div>
                </div>

                <div class="col-6"> 
                    <h6 class="fw-bold mb-3">끝나는 시간 선택</h6>
                    <div id="endTimeSlots" class="list-group list-group-flush end-time-slots-group">
                        </div>
                </div>
            </div>
          </div>
          
          <input type="hidden" name="VISIT_REQST_DT" id="selectedDateInput">
          <input type="hidden" name="PARKNG_BEGIN_DT" id="selectedStartTimeInput">
          <input type="hidden" name="PARKNG_END_DT" id="selectedEndTimeInput">
          
          <div class="text-center mt-4 d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            <button type="submit" class="btn btn-primary reserve-btn">예약</button>
          </div>

        </form>
      </div>
    </div>
  </div>
</div>
<!-- 방문차량 예약 모달 -->
<!--방문차량예약 끝 -->

<!-- //////////////////////////투표 Section//////////////////////////// -->
<section id="vote" class="services-2 section light-background" data-aos="fade-up" data-aos-delay="400">
   <!-- Section Title시작 -->
<div class="container section-title" data-aos="fade-up" style="padding-bottom: 15px;">
    <div class="title-row">
      <h2>최근 투표</h2>
      <a href="/vote/memVoteList"><div class="icon-circle-wrap"><i class="bi bi-card-list" style="font-size:30px;"></i></div></a>
   </div>
</div>
   <!-- Section Title끝 -->

   <div class="card" style="margin: 8px; padding: 5px; border: 3px solid rgba(100, 140, 164, 0.75); border-radius: 14px;">
      <!-- 목록 -->
      <div class="mobile-list" style="margin: 5px;">
         <c:forEach var="p" items="${votePage.content}" varStatus="stat">
   <c:if test="${stat.index < 3}">

            <c:set var="badgeClass" value="bg-light text-muted" />
            <c:if test="${p.stat eq '진행중'}">
               <c:set var="badgeClass" value="bg-success" />
            </c:if>
            <c:if test="${p.stat eq '예정'}">
               <c:set var="badgeClass" value="bg-secondary" />
            </c:if>
            <c:if test="${p.stat eq '마감'}">
               <c:set var="badgeClass" value="bg-warning text-dark" />
            </c:if>

            <div class="card mb-2 shadow-sm border-0 open-vote" data-sn="${p.voteMtrSn}" style="cursor:pointer;">
               <div class="card-body py-3 px-3">
                  <!-- 제목/상태 -->
                  <div class="d-flex justify-content-between align-items-start gap-2">
                        <div class="fw-semibold text-truncate" style="max-width: 100%;">
                            <!-- 글번호 -->
                            <span class="badge bg-secondary text-white rounded-pill px-2">${(articlePage.currentPage-1) * 10 + stat.count}</span> 
                            ${p.mtrSj}
                         </div>
                   <span class="badge ${badgeClass}">${p.stat}</span>
               </div>

                  <!-- 기간 -->
                  <div class="small text-muted mt-1"><i class="bi bi-calendar-check"></i>
                     ${fn:substring(p.voteBeginDt, 0, 10)} ~ ${fn:substring(p.voteEndDt, 0, 10)}
                  </div>

                  <!-- 인원/참여여부 -->
                  <div class="d-flex justify-content-between align-items-center mt-2">
                     <div class="small"> 투표인원: <span class="fw-semibold"><c:out value="${p.votedNum}" /></span>
                     </div>
                     <div>
                        <c:choose>
                           <c:when test='${p.isVoted eq "참여"}'>
                              <span class="badge bg-info">참여완료</span>
                           </c:when>
                           <c:otherwise>
                              <span class="badge bg-light text-danger">미참여</span>
                           </c:otherwise>
                        </c:choose>
                     </div>
                  </div>
               </div>
            </div>
            </c:if>
         </c:forEach>
      </div>
      </div>
</section>
<!-- modal시작 : 투표 상세 -->
<div class="modal fade" id="goVoteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">

      <!-- 상단 헤더 -->
      <div class="modal-header">
        <div class="d-flex align-items-center gap-2">
          <!-- 순번 표시 -->
          <span class="task-chip">
            <span class="me-1">투표</span>
          </span>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <!-- 본문 -->
      <div class="modal-body">
      <div class="modal-scroll-area">
        <div class="task-panel">

          <!-- 제목 영역 -->
          <div class="mb-2">
            <span class="task-meta-label">제목</span>
            <input type="text"
                   id="md-mtrSj"
                   class="form-control form-control-sm border-0 bg-transparent px-0"
                   style="font-size:.95rem; font-weight:600;"
                   readonly>
          </div>

          <!-- 작성자 / 기간 / 상태 -->
          <div class="task-meta-grid">
            <div>
              <span class="task-meta-label">투표 기간</span>
              <input type="text" id="md-voteTime"
                     class="form-control form-control-sm" readonly>
            </div>
          </div>

          <!-- 내용 / 그래프  -->
          <div class="task-split">
            <!-- 내용 -->
            <div class="task-section">
              <div class="task-section-title">투표 내용</div>
              <textarea id="md-mtrCn"
                        class="form-control form-control-sm task-description"
                        rows="5"
                        style="resize:none;"
                        readonly></textarea>
            </div>

            <!-- 그래프 -->
            <div class="task-section">
              <div class="task-section-title">투표 결과</div>
              <div id="voteGraph"></div>
            </div>
          </div>

          <!-- 투표 항목 -->
          <div class="task-table-wrap">
            <div class="task-table-header">
              <h6 class="mb-0 d-flex align-items-center" style="gap:8px;">투표 항목 <div id="myVoteBadge"></div></h6>
			  <small class="ml-2 text-muted">항목을 선택 후 투표 버튼을 눌러주세요.</small>
            </div>

            <div class="px-2 pt-1 pb-2">
              <form id="frmVote" method="post" action="/vote/haveAVote">
                <input type="hidden" name="voteMtrSn" id="md-voteMtrSn-hidden">

                <div class="table-responsive">
                  <table id="voteIemTable"
                         class="table table-sm table-hover align-middle">
                    <thead>
                      <tr>
                        <th style="width:10%;">순번</th>
                        <th style="width:25% text-align:left;">투표 항목</th>
<!--                         <th style="width:45%;">내용</th> -->
                        <th style="width:10%;">투표</th>
                        <th style="width:10%;">투표수</th>
                      </tr>
                    </thead>
                    <tbody id="md-iem-tbody"></tbody>
                  </table>
                </div>

                <!-- 버튼 영역 -->
                <div class="d-flex justify-content-end gap-2 mt-2">
                  <button type="button"
                          class="btn btn-light btn-sm"
                          data-bs-dismiss="modal"
                          style="padding:.35rem .7rem; border-radius:10px;">
                    닫기
                  </button>
                  <button type="submit"
                          class="btn btn-info btn-sm"
                          style="padding:.35rem .7rem; border-radius:10px;">
                    <i class="far fa-envelope"></i> 투표하기
                  </button>
                </div>
              </form>
            </div>
          </div>

        </div>
      </div>

      <!-- 푸터  -->
      <div class="modal-footer"></div>
      </div>
    </div>
  </div>
</div>
<!--투표의 모달끝-->

<!-- 하단 info 시작 -->
<section id="info-section" class="footer-info dark-background" style="padding: 20px 0 !important;">
    <div class="container footer-top">
        <div class="row gy-4">

            <div class="col-12">
                 <a href="http://localhost:8020/login" class="logo d-flex align-items-center" style="width: 100%; display: flex; justify-content: space-between; align-items: center;">                 
                                    <img src="/images/logo/dreamneerLogo(1).png" style="height:50px;">
                <!--                     <span class="sitename" style="font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; line-height: 1.2;">DREAMNEER</span> -->
                <!--                     <span class="sitenameSm" style="font-size: 0.85rem; font-weight: 300; letter-spacing: 2.5px; opacity: 0.75;  white-space: nowrap;">DREAM BEYOND</span> -->
                                </a>
                <div class="footer-contact pt-3">
                    <p class="mt-3"><strong>Team:</strong> <span style="font-size: 0.85rem;">김우현 · 곽정원 · 김병호 · 나혜선 · 박시현 · 백지웅 · 송인선 · 이승주</span></p>
                    <p class="mt-3"><strong>Addr:</strong> <span style="font-size: 0.85rem;">대전광역시 중구 계룡로 846, 3-4층</span></p>
                    <p class="mt-3"><strong>Phone:</strong> <span style="font-size: 0.85rem;">042-222-8202</span></p>
                    <p><strong>Email:</strong> <span style="font-size: 0.85rem;">DPyunHan@ddit.com</span></p>
                </div>
                <div class="social-links d-flex mt-4">
                    <a href="https://www.youtube.com/channel/UC-Q4WCYdovIVVj4WxVC11kg"><img src="images/logo/YouTube.png" alt="유튜브" style="width:32px; height:24px; margin-right: 12px;"></a>
                    <a href="https://www.ddit.or.kr/"><img src="images/logo/Internet.png" alt="인터넷" style="width:24px; height:24px; margin-right: 12px;"></a>
                    <a href="https://blog.naver.com/dditorkr"><img src="images/logo/naverBlog.png" alt="블로그" style="width:24px; height:24px; margin-right: 12px;"></a>
                    <a href="https://cafe.naver.com/dditorkr"><img src="images/logo/naverCafe.png" alt="카페" style="width:24px; height:24px; "></a>
                    
                    <div class="ms-auto d-flex">
                       <a href="./dPyunHan/termsofService" style="font-size: 0.9rem; margin-right: 12px; white-space: nowrap; color: #fff;">개인정보처리방침</a>
                       <a href="./dPyunHan/privacyPolicy" style="font-size: 0.9rem; white-space: nowrap; color: #fff;">서비스 이용약관</a>
                   </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container copyright text-center mt-4">
        <p>© <span>Copyright</span> <strong class="px-1 sitename">DREAMNEER</strong> <span>All Rights Reserved</span></p>
        <div class="credits">
            Designed by <a href="http://localhost:8020/login" style="color:  #0ABCDD;"><strong>DREAMNEER</strong></a>
            Distributed by <a href="https://www.ddit.or.kr/" style="color:  #0ABCDD;"><strong>(재)대덕인재개발원</strong></a>
        </div>
    </div>
</section>

<!-- 차량등록 script -->
<script type="text/javascript" src="/js/main/visitVhcle.js"></script>
<link rel="stylesheet" href="/css/main/visitReserve.css">
<link rel="stylesheet" href="/css/main/levy.css">
<!-- 차량등록 script끝 -->

<!--주민공지사항 script시작-->
<script type="text/javascript" src="/js/main/notice.js"></script>
<link rel="stylesheet" href="/css/main/notice.css">
<link rel="stylesheet" href="/css/main/noticeModal.css">
<!--주민공지사항 script끝-->

<!-- /////편의시설 예약///// -->
<script type="text/javascript" src="/js/main/resve.js"></script>
<link rel="stylesheet" href="/css/main/resve.css">
<!-- /////편의시설 예약끝///// -->

<!-- /////관리비조회///// -->
<script type="text/javascript" src="/js/main/managect.js"></script>
<!-- ✅ uPlot 라이브러리 -->
<link rel="stylesheet" href="https://leeoniya.github.io/uPlot/dist/uPlot.min.css">
<script src="https://leeoniya.github.io/uPlot/dist/uPlot.iife.js"></script>
<script src="/js/main/slr.js"></script>
<!-- /////관리비조회 코드끝///// -->

<!-- fx 일정 캘린더 시작 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.19/index.global.min.js"></script>
<!-- 일정 캘린더 스타일 시작 -->
<link rel="stylesheet" href="/css/main/calendar.css">
<!-- 일정 캘린더 스타일 끝 -->
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
   //캘린더 헤더 옵션
   const headerToolbar = {
      left : 'prevYear,prev,next,nextYear today',
      center : 'title',
      right : 'dayGridMonth,dayGridWeek,timeGridDay'
   }
   // 캘린더 생성 옵션(참공)
   const calendarOption = {
      height : '700px', // calendar 높이 설정
      expandRows : true, // 화면에 맞게 높이 재설정
      slotMinTime : '09:00', // Day 캘린더 시작 시간
      slotMaxTime : '18:00', // Day 캘린더 종료 시간
      // 맨 위 헤더 지정
      headerToolbar : headerToolbar,
      initialView : 'dayGridMonth', // default: dayGridMonth 'dayGridWeek', 'timeGridDay', 'listWeek'
      locale : 'ko', // 언어 설정
      selectable : false, // 영역 선택
      selectMirror : true, // 오직 TimeGrid view에만 적용됨, default false
      navLinks : true, // 날짜,WeekNumber 클릭 여부, default false
      weekNumbers : false, // WeekNumber 출력여부, default false
      editable : false, // 입주민은 수정 불가 
      dayMaxEventRows : true, // Row 높이보다 많으면 +숫자 more 링크 보임!
      nowIndicator : true,
      events : function(info, successCallback,
            failureCallback) {
         const url = "/fx/listAjax";
         $.ajax({
            url : url,
            contentType : "application/json",
            type : 'get',
            dataType : 'json',
            success : function(param) {
               var events = [];
               console.log("param : ", param);
               $.each(param, function(index, data) {
                  console.log("data : ", data);
                  //구분(시설,커뮤니티,일정)에 따라 색상 다르게 반영
                  let bgColor = "";
                  let texColor="white";

                  switch(data.fxIem){
                  case "시설":
                      bgColor="plum";
                      texColor= "blueviolet";
                      break
                    case "커뮤니티":
                         bgColor="lightblue";
                         texColor="#787878";
                         break;
                  }
                  events.push({
                     id : data.schdulSn,
                     title : data.fxSj,
                     start : data.fxBeginDt,
                     end : data.fxEndDt,
                     allDay : false,
                     backgroundColor : bgColor, //배경색
                     textColor : texColor, //글자색
                     extendedProps : { //추가 데이터
                        empId : data.empId,
                        fxIem : data.fxIem,
                        fxCn : data.fxCn,
                        fxPlace : data.fxPlace
                     }
                  });
               })
               successCallback(events);
            }
         });
      }
   }
   const calendarEl = document.querySelector("#calendar");
   // 캘린더 생성
   const calendar = new FullCalendar.Calendar(calendarEl,
         calendarOption);
   // 모달 인스턴스
   const modalEl = document
         .getElementById("calendarModal");
   const modal = bootstrap.Modal
         .getOrCreateInstance(modalEl);
   //일정 클릭 시 상세보기
   calendar.on("eventClick", function(info) { //info:fullcalendar가 event를 클릭했을때 자동으로 전달해주는 객체
                  console.log("info.event: ", info.event);
                  const period = info.event;
                  console.log("period.extendedProps: ", period.extendedProps);
                  document.getElementById("calendarempId").value = period.extendedProps.empId;
                  document.getElementById("calendarSj").value = period.title;
                  document.getElementById("calendarIem").value = period.extendedProps.fxIem;
                  document.getElementById("calendarBeginDt").value = period.startStr.substring(0, 16);
                  document.getElementById("calendarEndDt").value = period.endStr.substring(0, 16);
                  document.getElementById("calendarCn").value = period.extendedProps.fxCn;
                  document.getElementById("calendarPlace").value = period.extendedProps.fxPlace;
                  modal.show();
               });
   // 캘린더 그리기
   calendar.render();

}); //전체 끝
</script>
<!-- fx 일정 캘린더 끝 -->

<!-- vote 투표 스크립트 시작 -->
<script type="text/javascript" src="/js/main/vote.js"></script>
<!-- 투표 그래프 그리는거입니다 시작 그래프 그리기가 .js파일로 옮겼을 때 작동을 안합니다. -->
<script src='https://cdn.plot.ly/plotly-3.2.0.min.js'></script>
<script>
//스크립트 시작
document.addEventListener("DOMContentLoaded", function() {
   function drawVoteGraph() {
      //  투표 항목 테이블에서 데이터 읽어오기
      const rows = document.querySelectorAll("#voteIemTable tbody tr");
      const labels = []; // 투표 항목명 (iemNm)
      const values = []; // 투표수 (cnt)

      rows.forEach(function(row) {
         const cells = row.querySelectorAll("td");

         // 없는 행 건너뛰기
         if (cells.length < 4)
            return;

         // 순번, 투표항목, 내용, 투표수
         const label = cells[1].textContent.trim(); // 투표항목
         const valueText = cells[3].textContent.trim(); // 투표수 문자열
         const value = parseInt(valueText.replace(/,/g,""), 10) || 0;

         labels.push(label);
         values.push(value);
      });

      // 데이터가 없으면 안내 문구만 출력
      if (labels.length === 0) {
         const div = document.getElementById("voteGraph");
         if (div) {
            div.innerHTML = "<p style='text-align:center; margin-top:1rem;'>투표 항목 데이터가 없습니다.</p>";
         }
         return;
      }

      // 데이터
      const data = [ {
         values : values,
         labels : labels,
         type : "pie",
         textinfo : "none",
         hoverinfo : "label+value+percent",
         hole : 0.1, // 도넛 형태
         marker:{ line: {width: 0} }
      // marker: { colors: [...] } // 색상지정가능
      } ];
      // 레이아웃 설정
      const layout = {
         title : "투표 결과",
         height : 200,
         width : 260,
         legend : {
            orientation : "h",
            x : 0.5,
            xanchor : "center",
            y : -0.15
         },
         margin : {
            t : 40,
            l : 10,
            r : 10,
            b : 40
         }
      };
      // 그래프 그리기
      Plotly.newPlot("voteGraph", data, layout, {
         displayModeBar: false,  // 모드바 전체 제거
         displaylogo: false,      // Plotly 로고 제거
      });
   }
   const voteModalEl = document.getElementById("goVoteModal");
   if (voteModalEl) {
      voteModalEl.addEventListener("shown.bs.modal",function() {
               drawVoteGraph();
            });
   }
    
    
});
</script>
<!-- 그래프 그리는거입니다 끝 -->
<link rel="stylesheet" href="/css/main/vote.css">
<!-- vote 투표 스크립트 끝 -->

<!-- 푸터 -->
<%@ include file="./include/footerContents.jsp"%>
