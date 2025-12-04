<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@include file="../include/headerContents.jsp"%>
<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="/css/main/cvpl.css">

<style>
/* 전체 컨테이너 */
.modern-cvpl-wrapper {
    margin: 1rem 0;
    padding: 0 0.5rem;
}

/* 민원 카드 */
.modern-cvpl-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    margin-bottom: 1rem;
}

/* 민원 헤더 */
.modern-cvpl-header {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    padding: 0.8rem 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modern-cvpl-title {
    color: white;
    font-size: 1.2rem;
    font-weight: 700;
    margin: 0;
}

/* 검색 필터 버튼 */
.filter-toggle-btn {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    padding: 0.4rem 1rem;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.3s ease;
    font-size: 0.9rem;
    font-weight: 600;
}

.filter-toggle-btn:hover {
    background: rgba(255, 255, 255, 0.3);
}

/* 필터 아코디언 */
.filter-accordion {
    background: #fafbfc;
    padding: 1.5rem;
    display: none;
    border-top: 2px solid #e9ecef;
}

.filter-accordion.show {
    display: block;
}

.filter-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
    margin-bottom: 1rem;
}

.filter-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.filter-label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #495057;
}

.filter-checkbox-group {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
}

.filter-checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    cursor: pointer;
    font-size: 0.9rem;
    color: #495057;
}

.filter-radio-group {
    display: flex;
    gap: 1rem;
}

.filter-radio-label {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    cursor: pointer;
    font-size: 0.9rem;
    color: #495057;
}

.filter-date-group {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.filter-input {
    padding: 0.5rem 0.75rem;
    border: 1px solid #dee2e6;
    border-radius: 6px;
    font-size: 0.9rem;
}

.filter-input:focus {
    outline: none;
    border-color: #648ca4;
}

.filter-select {
    padding: 0.5rem 0.75rem;
    border: 1px solid #dee2e6;
    border-radius: 6px;
    font-size: 0.9rem;
    background: white;
    width: 100%;
}

.filter-select:focus {
    outline: none;
    border-color: #648ca4;
}

.filter-divider {
    height: 1px;
    background: #e0e0e0;
    margin: 1rem 0;
}

/* 검색 입력 */
.filter-search-input {
    flex: 1;
    padding: 0.7rem 1rem;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    font-size: 0.95rem;
    transition: all 0.3s ease;
}

.filter-search-input:focus {
    outline: none;
    border-color: #648ca4;
    box-shadow: 0 0 0 3px rgba(100, 140, 164, 0.1);
}

.filter-search-btn {
    padding: 0.7rem 1.8rem;
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.95rem;
    white-space: nowrap;
}

.filter-search-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(100, 140, 164, 0.3);
}

/* 검색 영역 래퍼 */
.filter-footer {
    display: flex;
    gap: 0.75rem;
    padding: 1rem 0 0 0;
}

/* 테이블 */
.modern-table-wrapper {
    overflow-x: auto;
    overflow-y: visible;
}

.modern-table {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
}

.modern-table thead {
    background: #f8f9fa;
}

.modern-table th {
    padding: 1rem 1.5rem;
    font-weight: 600;
    color: #495057;
    font-size: 0.9rem;
    border-bottom: 2px solid #e9ecef;
    letter-spacing: 0.5px;
}

.modern-table th:nth-child(1) {
    width: 80px;
    text-align: center;
}

.modern-table th:nth-child(2) {
    text-align: left;
}

.modern-table th:nth-child(3) {
    width: 100px;
    text-align: center;
    padding-right:0.2rem;
}

.modern-table th:nth-child(4) {
    width: 110px;
    text-align: right;
}

.modern-table td {
    padding: 1rem 1.5rem;
    font-size: 0.95rem;
    color: #495057;
}

.modern-table tbody tr {
    border-bottom: 1px solid #e9ecef;
    transition: all 0.2s ease;
    cursor: pointer;
}

.modern-table tbody tr:hover {
    background: linear-gradient(90deg, rgba(100, 140, 164, 0.05) 0%, rgba(100, 140, 164, 0.02) 100%);
    box-shadow: inset 0 0 8px rgba(100, 140, 164, 0.05);
}

.modern-cell-number {
    width: 80px;
    text-align: center;
    font-weight: 600;
    color: #648ca4;
}

.modern-cell-title {
    font-weight: 500;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.modern-cell-status {
    width: 80px;
    text-align: center;
    font-size: 0.85rem;
    padding: 0.35rem 0.7rem;
    border-radius: 6px;
    font-weight: 600;
    display: inline-block;
}

.modern-cell-status.receipt {
    background: #e7f3ff;
    color: #0066cc;
}

.modern-cell-status.processing {
    background: #fff7e6;
    color: #ff9800;
}

.modern-cell-status.completed {
    background: #e8f5e9;
    color: #27ae60;
}

.modern-cell-date {
    width: 110px;
    text-align: right;
    color: #6c757d;
    font-size: 0.9rem;
    white-space: nowrap;
}

/* 페이징 */
.modern-pagination {
    padding: 1.5rem;
    display: flex;
    justify-content: center;
}

/* 모달 z-index */
.modal {
    z-index: 9999 !important;
}

.modal-backdrop {
    z-index: 9998 !important;
}

.modal-dialog {
    z-index: 10000 !important;
}

/* 모달 스타일 */
.modern-modal-header {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    color: white;
    padding: 1.2rem 1.5rem;
    border: none;
}

.modern-modal-title {
    font-size: 1.1rem;
    font-weight: 600;
    display: flex;
    gap: 0.7rem;
    align-items: center;
    margin: 0;
}

.modern-modal-body {
    padding: 1.5rem;
}

.modern-field-label {
    color: #6c757d;
    font-size: 0.85rem;
    font-weight: 600;
    margin-bottom: 0.4rem;
}

.modern-field-value {
    background: #f8f9fa;
    padding: 0.7rem 1rem;
    border-radius: 8px;
    border: 1px solid #e9ecef;
    font-size: 0.95rem;
    margin-bottom: 1rem;
    word-break: break-word;
}

.modern-nav-section {
    padding: 0.7rem 1rem;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.7rem;
    margin-bottom: 0.7rem;
}

.modern-nav-section:hover {
    border-color: #648ca4;
    background: #f8f9fa;
}

.modern-nav-badge {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    color: white;
    padding: 0.35rem 0.7rem;
    border-radius: 6px;
    font-size: 0.8rem;
    font-weight: 600;
    white-space: nowrap;
}

.modern-nav-title {
    font-size: 0.9rem;
    color: #495057;
    font-weight: 500;
    flex: 1;
}

.modern-btn-close-modal {
    background: #6c757d;
    color: white;
    padding: 0.65rem 1.5rem;
    border: none;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.9rem;
}

.modern-btn-close-modal:hover {
    background: #5a6268;
    transform: translateY(-2px);
}

/* 반응형 */
@media (max-width: 768px) {
    .filter-row {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    .modern-cvpl-header {
        padding: 0.7rem 1rem;
    }
    
    .modern-cvpl-title {
        font-size: 1rem;
    }
    
    .modern-table th,
    .modern-table td {
        padding: 0.8rem;
        font-size: 0.85rem;
    }
    
    .filter-footer {
        flex-direction: column;
    }
    
    .filter-search-btn {
        white-space: normal;
    }
    
    .modern-cell-title {
        max-width: 150px;
    }
}

/* Swal을 모달보다 위에 표시 */
.swal-high-zindex {
    z-index: 10001 !important;
}
</style>

<div class="modern-cvpl-wrapper">
    <div class="modern-cvpl-card">
        
        <!-- 1. 헤더 -->
        <div class="modern-cvpl-header">
            <h4 class="modern-cvpl-title">입주민 민원</h4>
            <button type="button" onclick="toggleFilter()" class="filter-toggle-btn">
                <span>검색 필터</span>
                <i class="fas fa-chevron-down filter-toggle-icon" style="transition: transform 0.3s ease;"></i>
            </button>
        </div>

        <!-- 2. 필터 (헤더 밖) -->
        <form action="/cvpl/list" method="get">
            <div id="filterAccordion"  class="filter-accordion">
           
                        <!-- Row 1: 검색필드 + 정렬 -->
                        <div class="filter-row">
                            <div class="filter-group">
                                <label class="filter-label">검색 필드</label>
                                <div class="filter-checkbox-group">
                                    <label class="filter-checkbox-label">
                                        <input type="checkbox" name="searchField" value="cvplSj" class="filter-checkbox" />
                                        <span>제목</span>
                                    </label>
                                    <label class="filter-checkbox-label">
                                        <input type="checkbox" name="searchField" value="rceptCn" class="filter-checkbox" />
                                        <span>내용</span>
                                    </label>
                                    <label class="filter-checkbox-label">
                                        <input type="checkbox" name="searchField" value="reqsterNm" class="filter-checkbox" />
                                        <span>신청자</span>
                                    </label>
                                </div>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">정렬</label>
                                <div class="filter-radio-group">
                                    <label class="filter-radio-label">
                                        <input type="radio" name="sortOrder" value="desc" checked class="filter-radio" />
                                        <span>최신순</span>
                                    </label>
                                    <label class="filter-radio-label">
                                        <input type="radio" name="sortOrder" value="asc" class="filter-radio" />
                                        <span>오래된순</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="filter-divider"></div>

                        <!-- Row 2: 처리상태 + 날짜범위 -->
                        <div class="filter-row">
                            <div class="filter-group">
                                <label class="filter-label">신청 날짜 범위</label>
                                <div class="filter-date-group">
                                    <input type="date" name="startDate" class="filter-input" value="${param.startDate}" />
                                    <span>~</span>
                                    <input type="date" name="endDate" class="filter-input" value="${param.endDate}" />
                                </div>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">처리 상태</label>
                                <select name="status" class="filter-select">
                                    <option value="">전체</option>
                                    <option value="0">처리대기</option>
                                    <option value="1">처리중</option>
                                    <option value="2">처리완료</option>
                                </select>
                            </div>
                        </div>
                    
                    <div class="filter-divider"></div>

                    <div style="display: flex; gap: 0.75rem;">
                        <input type="text" name="keyword" class="filter-search-input" placeholder="검색어를 입력해주세요" value="${keyword}" />
                        <button type="submit" class="filter-search-btn">
                        <i class="fas fa-search"></i>검색
                        </button>
                    </div>
                </div>
        	</form>

        <!-- 3. 테이블 -->
        <div class="modern-table-wrapper">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th style="width: 80px; text-align: center;">순번</th>
                        <th style="width: auto;">제목</th>
                        <th style="width: 110px; text-align: center;">처리현황</th>
                        <th style="width: 120px; text-align: right;">등록일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cvplVO" items="${articlePage.content}" varStatus="status">
                        <tr onclick="cvplDetailModal(${cvplVO.cvplSn})">
                            <td class="modern-cell-number"><span class="badge bg-secondary text-white rounded-pill px-2">${(articlePage.currentPage-1) * 10 + status.count}</span></td>
                            <td class="modern-cell-title">${cvplVO.cvplSj}</td>
                            <td class="modern-cell-status">
                                <c:set var="rceptSttus" value="${cvplVO.cvplManageVO.cvplRceptVO.rceptSttus}" />
                                <c:choose>
                                    <c:when test="${empty rceptSttus}">
                                        <span class="modern-cell-status receipt">처리대기</span>
                                    </c:when>
                                    <c:when test="${rceptSttus == 1}">
                                        <span class="modern-cell-status processing">처리중</span>
                                    </c:when>
                                    <c:when test="${rceptSttus == 2}">
                                        <span class="modern-cell-status completed">처리완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="modern-cell-status">오류</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="modern-cell-date" >
                                <fmt:formatDate value="${cvplVO.reqstDt}" pattern="yyyy-MM-dd" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 4. 페이징 -->
        <div class="modern-pagination" style="display: flex; align-items: center;">
  			<div style="flex: 1; text-align: center; margin-left:5rem">
   				 ${articlePage.pagingArea}
  			</div>
  		<button type="button" class="btn btn-success btn-sm" onclick="cvplRegisterModal()" style="margin-left: 1rem;">
   		 민원등록
  		</button>
		</div>
    </div>
</div>

<script>
function toggleFilter() {
    const filterAccordion = document.getElementById('filterAccordion');
    const toggleIcon = document.querySelector('.filter-toggle-icon');
    const isVisible = filterAccordion.style.display === 'block';
    
    filterAccordion.style.display = isVisible ? 'none' : 'block';
    if (toggleIcon) {
        toggleIcon.style.transform = isVisible ? 'rotate(0deg)' : 'rotate(180deg)';
    }
}
</script>



<!-- ===== 상세보기 모달 시작 ===== -->

<div class="modal fade cute-modal" id="detailModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content" style="border: 0; border-radius: 14px; box-shadow: 0 6px 24px rgba(0, 0, 0, .12); overflow: hidden;">
      
      <!-- 헤더 -->
      <div class="modal-header" style="background: rgba(100, 140, 164, .85); color: #fff; padding: .6rem .9rem; border: none;">
        <h5 class="modal-title" style="font-size: 1rem; display: flex; gap: .5rem; align-items: center; margin: 0;">
          <span>민원번호<span id="cvplSn" style="font-size: .85rem;">-</span></span> 
          <span class="text-white-50">|</span> 
          <small class="fw-normal" style="font-size: .85rem;">신청일: <span id="reqstDt" style="font-size: .85rem;">-</span></small>
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body" style="padding: .9rem;">
<div class="modal-scroll-area">
  <!-- 민원인 + 처리상태 (맨 위) -->
  <div style="display: flex; justify-content: space-between; align-items: center; gap: .5rem; margin-bottom: .75rem;">
          <div style="display: flex; align-items: center; gap: .5rem;">
            <div style="color: #6b7b86; font-size: .75rem; font-weight: 600; white-space: nowrap;">민원인</div>
            <div id="mberId" style="font-size: .85rem; font-weight: 600; color: #495057;">-</div>
          </div>
          
          <div style="display: flex; align-items: center; gap: .5rem;">
            <span style="color: #6b7b86; font-size: .75rem; font-weight: 600; white-space: nowrap;">처리현황</span>
            <span id="rceptSttus" class="badge bg-warning text-dark" style="font-size: .75rem; padding: .4rem .6rem;">처리대기</span>
          </div>
        </div>


  <!-- 민원제목 -->
   <div class="mb-2">
          <div style="color: #6b7b86; font-size: .75rem; margin-bottom: .25rem; font-weight: 600;">민원제목</div>
          <div id="cvplSj" class="form-control form-control-sm" style="display: block; background-color: #f8f9fa; padding: .375rem .75rem; border: 1px solid #dee2e6; font-size: .85rem;"></div>
          <input type="text" id="cvplSjInput" class="form-control form-control-sm" style="display: none; font-size: .85rem;">
        </div>

<!-- 민원내용 -->
<div style="display: grid; grid-template-columns: 92px 1fr; row-gap: .35rem; column-gap: .75rem; padding: .8rem; border: 1px solid rgba(0, 0, 0, .06); border-radius: 10px; background: rgba(100, 140, 164, .12); margin-bottom: .75rem;">
  <!-- 부서명 추가 (민원내용 아래) -->

            <span style="color: #6b7b86; font-size: .75rem; font-weight: 600; margin-right: .5rem;">신청부서</span>
            <span id="deptNm" style="font-size: .85rem; font-weight: 500; color: #495057;">-</span>
          <div style="color: #6b7b86; font-size: .75rem; font-weight: 600; align-self: start;">민원내용</div>
          <div style="font-weight: 500;">
            <textarea id="cvplCn" class="form-control form-control-sm" rows="5" style="resize: none; display: block; background-color: #f8f9fa; font-size: .85rem;" readonly></textarea>
            <textarea id="cvplCnInput" class="form-control form-control-sm" rows="5" style="resize: none; display: none; font-size: .85rem;"></textarea>
          </div>
   <!-- 답변내용 라벨 (grid 첫번째 열) -->
  <div style="color: #6b7b86; font-size: .75rem; font-weight: 600; align-self: start;">답변내용</div>
  
  <!-- 답변내용 (grid 두번째 열) -->
  <div style="font-weight: 500;">
    <div id="responseContent" style="min-height: 5rem; background-color:  #f8f9fa; padding: .5rem; border-radius: 5px; border: 1px solid #dee2e6; color: #495057; font-size: .85rem;">
      <span id="responseText">답변이 없습니다.</span>
    </div>
  </div>
  
        </div>

  <!-- 첨부파일 -->
   <div class="mb-2">
          <h6 style="margin: 0 0 .5rem 0; font-size: .75rem; color: #6b7b86; font-weight: 600;">첨부파일</h6>
          <div id="fileDetailVOList" style="font-size: .85rem;"></div>
        </div>

  <!-- 숨겨진 필드 (수정용) -->
  <input type="hidden" id="cvplSnHidden">
</div>

<!-- 이전글/다음글 네비게이션 -->
  <div style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 2px solid #f1f3f5;">
                    <div id="prevSection" onclick="clickPrev()" class="modern-nav-section">
                        <div class="modern-nav-badge">
                            <i class="fas fa-chevron-up"></i> 이전글
                        </div>
                        <div id="prevTitle" class="modern-nav-title">이전글 없음</div>
                    </div>

                    <div id="nextSection" onclick="clickNext()" class="modern-nav-section">
                        <div class="modern-nav-badge">
                            <i class="fas fa-chevron-down"></i> 다음글
                        </div>
                        <div id="nextTitle" class="modern-nav-title">다음글 없음</div>
                    </div>
                </div>

			<!-- 버튼 영역 -->
			<div class="d-flex justify-content-end gap-2"
				style="padding: .9rem; border-top: 1px solid rgba(0, 0, 0, .06);">
				<button type="button" id="editBtn" class="btn btn-light btn-sm"
					onclick="editMode()"
					style="padding: .35rem .7rem; border-radius: 10px; background-color: #fffacd; border: 1px solid #dee2e6; color: #495057; font-weight: 500;">수정</button>
				<button type="button" id="saveBtn" class="btn btn-info btn-sm"
					onclick="saveCvpl()"
					style="padding: .35rem .7rem; border-radius: 10px; display: none;">저장</button>
					<button type="button" class="modern-btn-close-modal"
					data-bs-dismiss="modal"
					style="padding: .35rem .7rem; border-radius: 10px; font-weight: 500;">닫기</button>
			</div>
			</div>
		</div>
	</div>
</div>

<!-- ===== 상세보기 모달 끝 ===== -->


<!-- ===== 등록보기 모달 시작 ===== -->

  <div class="modal fade cute-modal" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content" style="border: 0; border-radius: 14px; box-shadow: 0 6px 24px rgba(0, 0, 0, .12); overflow: hidden;">
		<form id="registerForm" enctype="multipart/form-data">        
        <!-- 헤더 -->
        <div class="modal-header" style="background: rgba(100, 140, 164, .85); color: #fff; padding: .6rem .9rem; border: none;">
          <h5 class="modal-title" style="font-size: 1rem; margin: 0;">민원신청</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <!-- 본문 -->
        <div class="modal-body" style="padding: .9rem;">
<div class="modal-scroll-area">
          <!-- 민원 제목 -->
          <div class="mb-2">
            <div style="color: #6b7b86; font-size: .75rem; margin-bottom: .25rem; font-weight: 600;">민원제목</div>
            <input id="registerCvplSj" type="text" name="cvplSj" class="form-control form-control-sm" style="font-size: .85rem;" required />
          </div>

          <!-- 신청 부서 -->
          <div style="margin-bottom: .75rem;">
            <div style="color: #6b7b86; font-size: .75rem; margin-bottom: .25rem; font-weight: 600;">부서선택</div>
            <select id="registerDeptCode" name="deptCode" class="form-control form-control-sm" style="font-size: .85rem;" required></select>
          </div>

          <!-- 민원 내용 -->
          <div style="display: grid; grid-template-columns: 92px 1fr; row-gap: .35rem; column-gap: .75rem; padding: .8rem; border: 1px solid rgba(0, 0, 0, .06); border-radius: 10px; background: rgba(100, 140, 164, .12); margin-bottom: .75rem;">
            <div style="color: #6b7b86; font-size: .75rem; font-weight: 600; align-self: start;">민원내용</div>
            <div style="font-weight: 500;">
              <textarea id="registerCvplCn" name="cvplCn" class="form-control form-control-sm" rows="5" style="resize: none; font-size: .85rem;" required></textarea>
            </div>
          </div>

          <!-- 첨부파일 -->
          <div class="mb-2">
            <h6 style="margin: 0 0 .5rem 0; font-size: .75rem; color: #6b7b86; font-weight: 600;">첨부파일</h6>
            <input type="file" id="multipartFiles" name="multipartFiles" class="form-control form-control-sm" style="font-size: .85rem;" multiple />
          </div>

        </div>
</div>

        <!-- 버튼 영역 -->
        <div class="d-flex justify-content-end gap-2" style="padding: .9rem; border-top: 1px solid rgba(0, 0, 0, .06);">
          <button type="button" class="btn btn-info btn-sm" onclick="cvplRegister()" style="padding: .35rem .7rem; border-radius: 10px;">등록</button>
          <button type="button" class="modern-btn-close-modal" data-bs-dismiss="modal" style="padding: .35rem .7rem; border-radius: 10px;">취소</button>
        </div>
        <!-- 푸터 -->
        <div class="modal-footer" style="padding: 0 0; background: #fff; border: none;"></div>
        </form>
      </div>
    </div>
  </div>

<!-- ===== 등록보기 모달 끝 ===== -->

<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function(){
		
		let cvplList = [];
		let currentIndex = -1;
		
		const detailModal = document.querySelector('#detailModal');
		detailModal.addEventListener('hidden.bs.modal', function() {
		  document.querySelector("#cvplSj").style.display = 'block';
		  document.querySelector("#cvplCn").style.display = 'block';
		  document.querySelector("#cvplSjInput").style.display = 'none';
		  document.querySelector("#cvplCnInput").style.display = 'none';
		  
		  document.querySelector("#editBtn").style.display = 'block';
		  document.querySelector("#saveBtn").style.display = 'none';
		});

		const registerModal = document.querySelector('#registerModal');
		registerModal.addEventListener('hidden.bs.modal', function() {
		  document.querySelector("#registerForm").reset();
		});
		
		<!-- ===== 리스트 리로드 함수 script 시작 ===== -->
		window.listAjax = function(){
			fetch("/cvpl/listAjax",{
				method:"post",
				body: new URLSearchParams({ currentPage: 1, keyword: '', size: 10 })
			})
			.then(resp =>{
				return resp.json();
			})
			.then(data =>{
				console.log("data", data);
				
				 // 나중에 이거 함수 따로 빼도됨 공부해보고 빼자
			    const tbody = document.querySelector("#cvplListTbody");
			    tbody.innerHTML = '';
			    
			    //데이터 확인을 위한 정상적으로 없으면 
			    //데이터가 있으면 forEach실행
			    if(!data.articlePage.content || data.articlePage.content.length === 0) {
			      tbody.innerHTML = '<tr><td colspan="3">데이터가 없습니다</td></tr>';
			      return;
			    } 
			    
			    data.articlePage.content.forEach(item => {
			      const tr = document.createElement("tr");
			      tr.onclick = () => cvplDetailModal(item.cvplSn);
			      tr.className = "cvpl-table-row"; 
			      tr.style.cursor = "pointer";
			      const dateStr = new Date(item.reqstDt).toLocaleDateString();
			      tr.innerHTML = `
			    	  <td class="cvpl-cell-number">\${item.cvplSn}</td>
			          <td class="cvpl-cell-title">\${item.cvplSj}</td>
			          <td class="cvpl-cell-date">\${dateStr}</td>
			        /*
			        <td>\${item.mberNm}</td>
			        <td>\${new Date(item.reqstDt).toLocaleString()}</td>
			        <td>\${item.deptVO.deptNm}</td>*/
			        <td class="cvpl-cell-status">\${getStatus(item.cvplManageVO?.cvplRceptVO?.rceptSttus)}</td>
			      `;
			      tbody.appendChild(tr);
			    });
			  })
			  .catch(error => console.log("리로드 에러:", error));
			}

		
		
		<!-- ===== 상세보기 모달 script 시작 ===== -->
		
		window.cvplDetailModal = function(cvplSn){
			
			let data ={
				"cvplSn" : cvplSn
			};
			
			fetch("/cvpl/cvplDetailModal", {
				method: "post",
				headers: {
					"Content-type":"application/json;charset=UTF-8"
				},
				body: JSON.stringify(data)	
				})
				.then(resp => {
					return resp.json();
				})
				.then(data => {
					const cvpl = data.cvplVO;
					const fileDetailVOList = data.fileDetailVOList;	
					cvplList = data.cvplList;
					const rceptCn = cvpl.cvplManageVO?.cvplRceptVO?.rceptCn || ""; 
					
					console.log("data : ",data);
					console.log("fileDetailVOList: ",fileDetailVOList);	
					console.log("cvplList size: ", cvplList.length);
			      
					console.log("data 전체:", data);
					console.log("data.rceptCn:", data.rceptCn);
					console.log("cvpl.cvplManageVO:", cvpl.cvplManageVO);
					console.log("cvpl.cvplManageVO?.cvplRceptVO:", cvpl.cvplManageVO?.cvplRceptVO);
					console.log("cvpl.cvplManageVO?.cvplRceptVO?.rceptSttus:", cvpl.cvplManageVO?.cvplRceptVO?.rceptSttus);
					
				  document.querySelector("#cvplSj").style.display = 'block';
				  document.querySelector("#cvplCn").style.display = 'block';
				  document.querySelector("#cvplSjInput").style.display = 'none';
				  document.querySelector("#cvplCnInput").style.display = 'none';
				  document.querySelector("#editBtn").style.display = 'block';
				  document.querySelector("#saveBtn").style.display = 'none';
				  	
					
				  document.querySelector("#cvplSn").textContent = cvpl.cvplSn;
			      document.querySelector("#mberId").textContent = cvpl.mberNm;
			      document.querySelector("#cvplSj").textContent = cvpl.cvplSj;
			      document.querySelector("#cvplCn").textContent = cvpl.cvplCn;
			      document.querySelector("#reqstDt").textContent = new Date(cvpl.reqstDt).toLocaleString();
			      document.querySelector("#deptNm").textContent = cvpl.deptVO.deptNm;
			      document.querySelector("#rceptSttus").textContent = getStatus(cvpl.cvplManageVO?.cvplRceptVO?.rceptSttus);
		 
			      // 답변 영역 표시
			      const rceptSttus = cvpl.cvplManageVO?.cvplRceptVO?.rceptSttus;
			      updateResponseContent(rceptSttus, rceptCn);  // 상태에 따라 답변 표시
			      
		          //수정용
		          document.querySelector("#cvplSnHidden").value = cvpl.cvplSn;
		          document.querySelector("#cvplSjInput").value = cvpl.cvplSj;
		          document.querySelector("#cvplCnInput").value = cvpl.cvplCn;

		          // 파일 처리
		          let filesHtml = '';
		          if (fileDetailVOList && fileDetailVOList.length > 0) {
		            filesHtml = fileDetailVOList.map(fileDetailVO => `<img src="/upload\${fileDetailVO.fileStrelc}" style="height: 100px; margin: 5px;">`).join('');
		          } else {
		            filesHtml = '<p>첨부된 파일이 없습니다.</p>';
		          }
		          document.querySelector("#fileDetailVOList").innerHTML = filesHtml;
		          
		          // 처리상태에 따른 수정버튼 제어
		          const editBtn = document.querySelector("#editBtn");
		          const saveBtn = document.querySelector("#saveBtn");
		          
		          // 처리대기(null 또는 undefined)일 때만 수정버튼 표시
		          if (!rceptSttus) {
		            editBtn.style.display = 'block';
		            saveBtn.style.display = 'none';
		            
		          } else {
		            editBtn.style.display = 'none';
		            saveBtn.style.display = 'none';
		          }
		          
		          // 현재 인덱스 찾기
		          currentIndex = cvplList.findIndex(c => c.cvplSn === cvpl.cvplSn);
		          
		          // 이전/다음 텍스트
		          updateNavText();
		          
		          // 모달 띄우기
		          const detailModal = new bootstrap.Modal(document.getElementById('detailModal'));
		          detailModal.show();
		          
		        })
		        .catch(error => console.log('에러:', error));
		      };
		      
		      // ✅ 이전글 클릭
		      window.clickPrev = function() {
		        if (currentIndex > 0) {
		          const backdrop = document.querySelector('.modal-backdrop');
		          if (backdrop) backdrop.remove();
		          document.body.classList.remove('modal-open');
		          
		          cvplDetailModal(cvplList[currentIndex - 1].cvplSn);
		        }
		      };

		      // ✅ 다음글 클릭
		      window.clickNext = function() {
		        if (currentIndex < cvplList.length - 1) {
		          const backdrop = document.querySelector('.modal-backdrop');
		          if (backdrop) backdrop.remove();
		          document.body.classList.remove('modal-open');
		          
		          cvplDetailModal(cvplList[currentIndex + 1].cvplSn);
		        }
		      };

		      // ✅ 이전/다음글 텍스트 업데이트
		      window.updateNavText = function() {
		        const prevSection = document.querySelector("#prevSection");
		        const nextSection = document.querySelector("#nextSection");
		        
		        if (!prevSection || !nextSection) return;
		        
		        // 이전글
		        if (currentIndex > 0) {
		          const prevCvpl = cvplList[currentIndex - 1];
		          document.querySelector("#prevTitle").textContent = prevCvpl.cvplSj;
		          prevSection.style.opacity = "1";
		          prevSection.style.pointerEvents = "auto";
		          prevSection.style.cursor = "pointer";
		        } else {
		          document.querySelector("#prevTitle").textContent = "이전글 없음";
		          prevSection.style.opacity = "0.5";
		          prevSection.style.pointerEvents = "none";
		          prevSection.style.cursor = "not-allowed";
		        }
		        
		        // 다음글
		        if (currentIndex < cvplList.length - 1) {
		          const nextCvpl = cvplList[currentIndex + 1];
		          document.querySelector("#nextTitle").textContent = nextCvpl.cvplSj;
		          nextSection.style.opacity = "1";
		          nextSection.style.pointerEvents = "auto";
		          nextSection.style.cursor = "pointer";
		        } else {
		          document.querySelector("#nextTitle").textContent = "다음글 없음";
		          nextSection.style.opacity = "0.5";
		          nextSection.style.pointerEvents = "none";
		          nextSection.style.cursor = "not-allowed";
		        }
		      };
		      
		      
		      // 상태 변환 함수
		      window.getStatus = function(rceptSttus) {
		        if (!rceptSttus) return '처리대기';
		        if (rceptSttus == 1) return '처리중';
		        if (rceptSttus == 2) return '처리완료';
		        return '오류';
		      };
		    
		      window.updateResponseContent = function(rceptSttus, rceptCn) {
		    	  const responseTextElem = document.getElementById("responseText");
		    	  
		    	  if (rceptSttus === null || rceptSttus === undefined || rceptSttus === 0) {
		    	    responseTextElem.textContent = "답변 내용이 없습니다.";
		    	  } else if (rceptSttus === 1) {
		    	    responseTextElem.innerHTML = rceptCn || "답변 내용이 없습니다.";
		    	  } else if (rceptSttus === 2) {
		    	    responseTextElem.innerHTML = rceptCn || "답변 내용이 없습니다.";
		    	  } else {
		    	    responseTextElem.textContent = "잘못된 상태 입니다.";
		    	  }
		    	};
		// ===== 상세보기 모달 script 끝 =====
		
		
		// ===== 등록보기 모달 시작 ===== 
			
		window.cvplRegisterModal = function(){
			
			fetch("/cvpl/cvplRegisterModal",{
				method: "GET"	
			})
				.then(resp => {
					return resp.json();
				})
				.then(data => {
					
					let deptOptions = `<option value="">선택하세요</option>`;
					data.deptVOList.forEach(dept =>{
						deptOptions += `<option value="\${dept.deptCode}">\${dept.deptNm}</option>`;
						console.log("deptOptions", deptOptions);
					});
					document.querySelector("#registerDeptCode").innerHTML = deptOptions;
					
					const registerModal = new bootstrap.Modal(document.getElementById('registerModal'));
					registerModal.show();
					
			})
			.catch(error => console.log(error));
		}
				
		// ===== 등록보기 모달 끝 =====
			
			
		// ===== 등록 슛  =====
			
		window.cvplRegister = function(){
			  const form = document.querySelector("#registerForm");	  
			  console.log("form:", form);
			  //유효성검사
			  const cvplSj = form.querySelector("#registerCvplSj").value.trim();
			  const cvplCn = form.querySelector("#registerCvplCn").value.trim();
			  const deptCode = form.querySelector("#registerDeptCode").value;
			  console.log("cvplSj:", form.querySelector("#registerCvplSj"));
			  console.log("cvplCn:", form.querySelector("#registerCvplCn"));
			  console.log("deptCode:", form.querySelector("#registerDeptCode"));
			  
			  if (!cvplSj) {
			    Swal.fire({
			      icon: 'warning',
			      title: '입력 오류',
			      text: '민원 제목을 입력해주세요.',
			      confirmButtonColor: '#648ca4',
			      confirmButtonText: '확인',
			    	  customClass: {
			    	        container: 'swal-high-zindex' 
			    	      }
			    }).then(() => {
			      form.querySelector("#registerCvplSj").focus();
			    });
			    return;
			  }
			  
			  if (!deptCode) {
			    Swal.fire({
			      icon: 'warning',
			      title: '선택 오류',
			      text: '부서를 선택해주세요.',
			      confirmButtonColor: '#648ca4',
			      confirmButtonText: '확인',
			    	  customClass: {
			    	        container: 'swal-high-zindex' 
			    	      }
			    }).then(() => {
			      form.querySelector("#registerDeptCode").focus();
			    });
			    return;
			  }
			  
			  if (!cvplCn) {
			    Swal.fire({
			      icon: 'warning',
			      title: '입력 오류',
			      text: '민원 내용을 입력해주세요.',
			      confirmButtonColor: '#648ca4',
			      confirmButtonText: '확인',
			    	  customClass: {
			    	        container: 'swal-high-zindex' 
			    	      }
			    }).then(() => {
			      form.querySelector("#registerCvplCn").focus();
			    });
			    return;
			  }
			  
			  //등록 진행
			  const formData = new FormData(form);

			  fetch("/cvpl/cvplRegister", { method: "POST", body: formData })
			  .then(resp => resp.json())
			  .then(data => {
				  
			      const registerModal = bootstrap.Modal.getInstance(document.getElementById('registerModal'));
			      if(registerModal) {
			    	registerModal.hide();
			      }
			     
			      const modalElement = document.getElementById('registerModal');
			      modalElement.addEventListener('hidden.bs.modal', function onModalHidden() {
			    Swal.fire({
			      icon: 'success',
			      title: '성공!',
			      text: '민원이 등록되었습니다.',
			      confirmButtonColor: '#648ca4',
			      confirmButtonText: '확인'
			    }).then(() => {	      
			      window.location.reload();
			    });
			    modalElement.removeEventListener('hidden.bs.modal', onModalHidden);
			  });
			  })
			  .catch(error => {
				  console.log(error);
			  });
			}
			
		// ===== 등록 끝 ===== 
			
	    
		// ===== 수정 시작 =====
window.editMode = function() {
  document.querySelector("#cvplSj").style.display = 'none';
  document.querySelector("#cvplCn").style.display = 'none';
  
  document.querySelector("#cvplSjInput").style.display = 'block';
  document.querySelector("#cvplCnInput").style.display = 'block';
  
  document.querySelector("#editBtn").style.display = 'none';
  document.querySelector("#saveBtn").style.display = 'block';
}

window.saveCvpl = function() {
  const cvplVO = {
    cvplSn: document.querySelector("#cvplSnHidden").value,
    cvplSj: document.querySelector("#cvplSjInput").value,
    cvplCn: document.querySelector("#cvplCnInput").value
  };
  
  fetch("/cvpl/update", {
    method: "POST",
    headers: { "Content-type": "application/json;charset=UTF-8" },
    body: JSON.stringify(cvplVO)
  })
  .then(resp => resp.json())
  .then(data => {
    Swal.fire({
      icon: 'success',
      title: '성공!',
      text: '수정되었습니다.',
      confirmButtonColor: '#648ca4',
      confirmButtonText: '확인'
    }).then(() => {
      document.querySelector("#cvplSj").style.display = 'block';
      document.querySelector("#cvplCn").style.display = 'block';
      document.querySelector("#cvplSjInput").style.display = 'none';
      document.querySelector("#cvplCnInput").style.display = 'none';
      document.querySelector("#editBtn").style.display = 'block';
      document.querySelector("#saveBtn").style.display = 'none';
      
      const detailModal = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
      if(detailModal) detailModal.hide();
      
      window.location.reload();
    });
  })
  .catch(error => console.log("수정 에러:", error));
}
// ===== 수정 끝 =====
			
 });
	
document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const open = params.get("open");

    if (open === "registerModal") {
		
/*     	 // 모달 인스턴스 찾기
        const modalEl = document.getElementById("registerModal");
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);

        // 모달 SHOW
        modal.show();  이러면 부서코드 못가져와서 지웠습니다. */
    	cvplRegisterModal();

        // URL 파라미터 제거
        const url = new URL(window.location.href);
        url.searchParams.delete("open");
        window.history.replaceState({}, "", url.toString());
    }

}); 
</script>

<%@ include file="../include/footerContents.jsp"%>