<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!-- FontAwesome -->
<!-- <link rel="stylesheet" -->
<!-- 	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> -->
<link rel="stylesheet" href="/css/global/cuteModal.css">
<!-- 헤더 -->
<%@include file="../include/headerContents.jsp"%>

<style>
/* 전체 컨테이너 */
.modern-notice-wrapper {
	margin: 1rem 0;
	padding: 0 0.5rem;
}

/* 공지사항 카드 */
.modern-notice-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	overflow: hidden;
	margin-bottom: 1rem;
}

/* 공지사항 헤더 */
.modern-notice-header {
	background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
	padding: 0.8rem 1.5rem;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.modern-notice-title {
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
}

.filter-search-btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(100, 140, 164, 0.3);
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
	padding-right: 0.2rem;
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
	border-bottom: 1px solid #f1f3f5;
	transition: all 0.2s ease;
	cursor: pointer;
}

.modern-table tbody tr:hover {
	background: linear-gradient(90deg, rgba(100, 140, 164, 0.05) 0%,
		rgba(100, 140, 164, 0.02) 100%);
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

/* 모달 안 라벨/값 */
.modern-field-label {
  color: #6c757d;
  font-size: 0.85rem;
  font-weight: 600;
  margin-bottom: 0.40rem;
}

.modern-field-value {
  background: #f8f9fa;
  padding: 0.70rem 1.00rem;
  border-radius: 8.00px;
  border: 1.00px solid #e9ecef;
  font-size: 0.95rem;
  margin-bottom: 1.00rem;
}

/* 이전/다음글 네비 */
.modern-nav-section {
  padding: 0.70rem 1.00rem;
  border: 2.00px solid #e9ecef;
  border-radius: 8.00px;
  cursor: pointer;
  transition: all 0.30s ease;
  display: flex;
  align-items: center;
  gap: 0.70rem;
  margin-bottom: 0.70rem;
  background: #ffffff;
}

.modern-nav-section:hover {
  border-color: #648ca4;
  background: #f8f9fa;
}

.modern-nav-badge {
  background: linear-gradient(135deg, #648ca4 0.00%, #5a7d94 100.00%);
  color: #ffffff;
  padding: 0.35rem 0.70rem;
  border-radius: 6.00px;
  font-size: 0.80rem;
  font-weight: 600;
  white-space: nowrap;
}

.modern-nav-title {
  font-size: 0.90rem;
  color: #495057;
  font-weight: 500;
  flex: 1;
}

/* 닫기 버튼 */
.modern-btn-close-modal {
  background: #6c757d;
  color: #ffffff;
  padding: 0.65rem 1.50rem;
  border: none;
  border-radius: 8.00px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.30s ease;
  font-size: 0.90rem;
}

.modern-btn-close-modal:hover {
  background: #5a6268;
  transform: translateY(-2.00px);
}

/* 반응형 */
@media ( max-width : 768px) {
	.filter-row {
		grid-template-columns: 1fr;
		gap: 1rem;
	}
	.modern-notice-header {
		padding: 0.7rem 1rem;
	}
	.modern-notice-title {
		font-size: 1rem;
	}
	.modern-table th, .modern-table td {
		padding: 0.8rem;
		font-size: 0.85rem;
	}
}
</style>

<script type="text/javascript">
let noticeList = [];
let currentIndex = -1;

document.addEventListener("DOMContentLoaded", function(){

	const autoSn = localStorage.getItem("openNoticeSn"); 
    if (autoSn) localStorage.removeItem("openNoticeSn");
    
    fetch("/notice/listJson")
        .then(resp => resp.json())
        .then(data => {
            noticeList = data.noticeList;
            console.log("공지사항 리스트 로드 완료:", noticeList.length, "개");
            
            if (autoSn) noticeDetail(autoSn);
        })
        .catch(error => console.log("리스트 로드 에러:", error));
});

noticeDetail = function(noticeSn){
    let data = { "noticeSn" : noticeSn }

    fetch("/notice/detail", {
        method: "post",
        headers: { "Content-type":"application/json;charset=UTF-8" },
        body: JSON.stringify(data)
    })
    .then(resp => resp.json())
    .then(data => {
        const notice = data.noticeVO;
        const fileDetailVOList = data.fileDetailVOList;

        currentIndex = noticeList.findIndex(n => n.noticeSn === notice.noticeSn);

        document.querySelector("#noticeSn").textContent = notice.noticeSn;
        document.querySelector("#noticeSj").textContent = notice.noticeSj;
        document.querySelector("#noticeCn").innerHTML = notice.noticeCn;
        document.querySelector("#noticeWritngDt").textContent = new Date(notice.noticeWritngDt).toLocaleString();
        document.querySelector("#empId").textContent = notice.nm;

        let filesHtml = ''; 
		if (fileDetailVOList && fileDetailVOList.length > 0) {
			filesHtml = '<div>';
		    fileDetailVOList.forEach(file => {
		        // 파일명과 확장자 확인
		        const fileName = file.fileOrginlNm || '파일명 없음';
		        const isPdf = fileName.toLowerCase().endsWith('.pdf');
		        
		        // 아이콘 선택 (PDF만 구분)
		        const icon = isPdf 
		       			 ? '<i class="fas fa-file-pdf mr-2" style="color: #333;"></i>'
		                 : '<i class="fas fa-file mr-2" style="color: #333;"></i>';
		        
		        filesHtml += `
		        	<div style="margin-bottom: 0.5rem;">
	                <a href="/notice/download?fileGroupSn=\${file.fileGroupSn}&fileNo=\${file.fileNo}" 
	                   style="text-decoration: none; color: #333;">
	                    \${icon}
	                    \${fileName}
	                </a>
	            </div>
		        `;
		    });
		    filesHtml += '</div>';
		} else {
		    filesHtml = '<p class="text-muted mb-0">첨부된 파일이 없습니다.</p>';
		}
		document.querySelector("#fileDetailVOList").innerHTML = filesHtml;

        updateNavText();
        new bootstrap.Modal(document.querySelector('#detailModal')).show();
    })
    .catch(error => console.log("에러:",error));
}

function clickPrev() {
    if (currentIndex > 0) {
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
        document.body.classList.remove('modal-open');
        noticeDetail(noticeList[currentIndex - 1].noticeSn);
    }
}

function clickNext() {
    if (currentIndex < noticeList.length - 1) {
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
        document.body.classList.remove('modal-open');
        noticeDetail(noticeList[currentIndex + 1].noticeSn);
    }
}

function updateNavText() {
    const prevSection = document.querySelector("#prevSection");
    const nextSection = document.querySelector("#nextSection");
    
    if (!prevSection || !nextSection) return;
    
    if (currentIndex > 0) {
        const prevNotice = noticeList[currentIndex - 1];
        document.querySelector("#prevTitle").textContent = prevNotice.noticeSj;
        prevSection.style.opacity = "1";
        prevSection.style.pointerEvents = "auto";
    } else {
        document.querySelector("#prevTitle").textContent = "이전글 없음";
        prevSection.style.opacity = "0.5";
        prevSection.style.pointerEvents = "none";
    }
    
    if (currentIndex < noticeList.length - 1) {
        const nextNotice = noticeList[currentIndex + 1];
        document.querySelector("#nextTitle").textContent = nextNotice.noticeSj;
        nextSection.style.opacity = "1";
        nextSection.style.pointerEvents = "auto";
    } else {
        document.querySelector("#nextTitle").textContent = "다음글 없음";
        nextSection.style.opacity = "0.5";
        nextSection.style.pointerEvents = "none";
    }
}

// 검색 필터 토글
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

<div class="modern-notice-wrapper">
	<div class="modern-notice-card">

		<!-- 1. 헤더 -->
		<div class="modern-notice-header">
			<h4 class="modern-notice-title">입주민 공지사항</h4>
			<button type="button" onclick="toggleFilter()"
				class="filter-toggle-btn">
				<span>검색 필터</span> <i class="fas fa-chevron-down filter-toggle-icon"
					style="transition: transform 0.3s ease;"></i>
			</button>
		</div>

		<!-- 2. 검색 필터 아코디언 (헤더 바로 밑) -->
		<form action="/notice/list" method="get">
			<div id="filterAccordion" class="filter-accordion">
				<!-- 검색 필드 & 정렬 -->
				<div class="filter-row">
					<div class="filter-group">
						<label class="filter-label">검색 필드</label>
						<div class="filter-checkbox-group">
							<label class="filter-checkbox-label"> <input
								type="checkbox" name="searchField" value="noticeSj" /> <span>순번</span>
							</label> <label class="filter-checkbox-label"> <input
								type="checkbox" name="searchField" value="noticeCn" checked /> <span>제목</span>
							</label> <label class="filter-checkbox-label"> <input
								type="checkbox" name="searchField" value="nm" checked /> <span>내용</span>
							</label>
						</div>
					</div>

					<div class="filter-group">
						<label class="filter-label">정렬</label>
						<div class="filter-radio-group">
							<label class="filter-radio-label"> <input type="radio"
								name="sortOrder" value="desc" checked /> <span>최신순</span>
							</label> <label class="filter-radio-label"> <input type="radio"
								name="sortOrder" value="asc" /> <span>오래된순</span>
							</label>
						</div>
					</div>
				</div>

				<div class="filter-divider"></div>

				<!-- 날짜 범위 & 상태 -->
				<div class="filter-row">
					<div class="filter-group">
						<label class="filter-label">날짜 범위</label>
						<div class="filter-date-group">
							<input type="date" name="startDate" class="filter-input"
								value="${param.startDate}" /> <span>~</span> <input type="date"
								name="endDate" class="filter-input" value="${param.endDate}" />
						</div>
					</div>

					<div class="filter-group">
						<label class="filter-label">상태</label> <select name="status"
							class="filter-select">
							<option value="">전체</option>
							<option value="1">활성</option>
							<option value="0">비활성</option>
						</select>
					</div>
				</div>

				<div class="filter-divider"></div>

				<!-- 검색 영역 -->
				<div style="display: flex; gap: 0.75rem;">
					<input type="text" name="keyword" class="filter-search-input"
						placeholder="검색어를 입력해주세요" value="${keyword}" />
					<button type="submit" class="filter-search-btn">
						<i class="fas fa-search"></i> 검색
					</button>
				</div>
			</div>
		</form>

		<!-- 3. 테이블 -->
		<div class="modern-table-wrapper">
			<table class="modern-table">
				<thead>
					<tr>
						<th style="width: 100px;">순번</th>
						<th>제목</th>
						<th style="width: 150px;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="noticeVO" items="${articlePage.content}"
						varStatus="status">
						<tr onclick="noticeDetail(${noticeVO.noticeSn})">
							<td class="modern-cell-number"><span
								class="badge bg-secondary text-white rounded-pill px-2">${(articlePage.currentPage-1) * 10 + status.count}</span></td>
							<td class="modern-cell-title">${noticeVO.noticeSj}</td>
							<td class="modern-cell-date"><fmt:formatDate
									value="${noticeVO.noticeWritngDt}" pattern="yyyy-MM-dd" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 4. 페이징 -->
		<div class="modern-pagination">${articlePage.pagingArea}</div>
	</div>
</div>

<!-- 상세보기 모달 -->
<div class="modal fade cute-modal" id="detailModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      
      <!-- 헤더 -->
      <div class="modal-header">
        <h5 class="modal-title d-flex align-items-center gap-2 mb-0" style="font-size:0.95rem;">
          <span class="task-chip">
            공지사항
            <span class="text-white-50 ms-1">#<span id="noticeSn">-</span></span>
          </span>
          <small class="fw-normal ms-2" style="font-size:0.85rem;">
            <i class="bi bi-calendar-check"></i>
            <span id="noticeWritngDt" class="ms-1">-</span>
          </small>
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <!-- 본문 -->
      <div class="modal-body">
      <div class="modal-scroll-area">
        <div class="task-panel">
          
          <!-- 작성자 -->
          <div class="mb-2">
            <span class="task-meta-label">작성자</span>
            <div id="empId"
                 style="font-weight:600; color:#495057; font-size:0.90rem;">
              -
            </div>
          </div>

          <!-- 제목 -->
          <div class="task-section">
            <div class="task-section-title">공지 제목</div>
            <div id="noticeSj"
                 class="form-control form-control-sm"
                 style="display:block; background-color:#f8f9fa;
                        padding:0.38rem 0.75rem; border:1.00px solid #dee2e6;
                        font-size:0.85rem; font-weight:600;">
            </div>
          </div>

          <!-- 내용 -->
          <div class="task-section">
            <div class="task-section-title">공지 내용</div>
            <textarea id="noticeCn"
                      class="form-control form-control-sm task-description"
                      rows="6"
                      style="resize:none; width:100.00%;"
                      readonly></textarea>
          </div>

          <!-- 첨부파일 -->
          <div class="task-section mb-0">
            <div class="task-section-title">첨부파일</div>
            <div id="fileDetailVOList"
                 class="attach-list"
                 style="padding:0.50rem 0.00rem;">
            </div>
          </div>

        </div>
      </div>

      <!-- 이전/다음글 + 닫기 -->
      <div class="modal-footer"
           style="display:block; padding:1.00rem; background:#f8f9fa; border-top:2.00px solid #e9ecef;">
        
        <div id="prevSection" onclick="clickPrev()" class="modern-nav-section" style="margin-bottom:0.50rem;">
          <div class="modern-nav-badge">
            <i class="fas fa-chevron-up"></i> 이전글
          </div>
          <div id="prevTitle" class="modern-nav-title">이전글 없음</div>
        </div>

        <div id="nextSection" onclick="clickNext()" class="modern-nav-section" style="margin-bottom:0.50rem;">
          <div class="modern-nav-badge">
            <i class="fas fa-chevron-down"></i> 다음글
          </div>
          <div id="nextTitle" class="modern-nav-title">다음글 없음</div>
        </div>

        <div class="d-flex justify-content-end" style="margin-top:0.50rem;">
          <button type="button"
                  class="modern-btn-close-modal"
                  data-bs-dismiss="modal">
            닫기
          </button>
        </div>
      </div>
</div>
    </div>
  </div>
</div>


<%@ include file="../include/footerContents.jsp"%>