<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<style>
/* 공통 카드별 상단 영역 시작 */
body { /* 그냥 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}

.card {
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

.card-header .card-title {
	font-size: 1.2rem !important; /* 글자 크기 */
	font-weight: 700 !important;
	/* 글자 두께 살짝 굵게  400이 기본, 700이 bord정도 입니다. */
	padding-top: 4px !important; /* 상단패딩*/
	padding-bottom: 4px !important;
}
/* 공통 카드별 상단 영역 끝 */
.card-body {
	padding: 1rem !important;
}

.card-footer {
	padding: 1rem !important;
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 시작 */
.tight-table, .tight-table th, .tight-table td {
	padding: 3px 5px !important; /* 테이블들 행간격 */
	overflow: hidden !important; /* 삐져나가는거 잡아줘요 */
	text-overflow: ellipsis; /* 길어진 글은 ...처리 */
	white-space: nowrap; /* 줄바꿈 X */
	text-align: center;
}
/* 줄무늬 효과(odd는 홀수, even은 짝수) */
.tight-table tbody tr:nth-child(odd) {
	background-color: #ffffff; /* 흰색 */
}

.tight-table tbody tr:nth-child(even) {
	background-color: #f1f4fa; /* 연한 회색(AdminLTE 느낌) */
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 끝 */
/* 호버이벤트 시작 */
/* tight-table호버이벤트시작 */
.table tbody tr {
	transition: background-color 0.25s ease, box-shadow 0.25s ease,
		transform 0.2s ease;
}

.table tbody tr:hover {
	background-color: rgba(100, 140, 164, 0.12) !important; /* 은은한 파스텔 */
	box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15); /* 은은한 그림자 */
	transform: translateY(-1px); /* 살짝 띄우기 */
	cursor: pointer;
}
/* 호버이벤트 끝 */

/* 모달 css영역 시작입니다 */
/* 모달 프레임 자체 */
.cute-modal .modal-content {
	border: 0 !important;
	border-radius: 14px !important;
	box-shadow: 0 6px 24px rgba(0, 0, 0, .12) !important;
	overflow: hidden !important;
}

/* 헤더 영역 */
.cute-modal .modal-header {
	background: rgba(100, 140, 164, .85) !important;
	color: #fff !important;
	padding: .6rem .9rem !important;
}

/* 제목(좌측) */
.cute-modal .modal-title {
	font-size: 1rem !important;
	display: flex !important;
	gap: .5rem !important;
	align-items: center !important;
	margin: 0 !important;
}

.cute-modal .modal-title small {
	font-size: .85rem !important;
}

/* 닫기 버튼 */
.cute-modal .close, .cute-modal .btn-close, .cute-modal .btn-close-white
	{
	color: #fff !important;
	opacity: .9 !important;
	text-shadow: none !important;
}

.cute-modal .close:hover, .cute-modal .btn-close:hover, .cute-modal .btn-close-white:hover
	{
	opacity: 1 !important;
}

/* 본문 기본 패딩 */
.cute-modal .modal-body {
	padding: .9rem !important;
}

/* 필드 라벨 (제목, 기간, 내용 등) */
.cute-modal .field-label {
	color: #6b7b86 !important;
	font-size: .875rem !important;
	margin-bottom: .25rem !important;
}

/* 상단 메타 정보(기간 + 내용) 박스 */
.cute-modal .cute-meta-box {
	display: grid !important;
	grid-template-columns: 92px 1fr !important;
	row-gap: .35rem !important;
	column-gap: .75rem !important;
	padding: .8rem !important;
	border: 1px solid rgba(0, 0, 0, .06) !important;
	border-radius: 10px !important;
	background: rgba(100, 140, 164, .12) !important;
	margin-bottom: .75rem !important;
}

.cute-modal .cute-meta-label {
	color: #6b7b86 !important;
	font-size: .875rem !important;
	align-self: center !important;
}

.cute-modal .cute-meta-label.top {
	align-self: flex-start !important;
}

.cute-modal .cute-meta-value {
	font-weight: 600 !important;
	font-size: .95rem !important;
}

/* 내용 textarea */
.cute-modal textarea.form-control {
	resize: none !important;
}

/* 섹션 제목 (ex. 투표 항목, 첨부파일 등) */
.cute-modal .cute-section-title {
	margin: 0 0 .5rem 0 !important;
}

/* 테이블 – Dewi/BS5/BS4 모두 공통 느낌 */
.cute-modal .cute-table {
	margin-top: .25rem !important;
}

.cute-modal .cute-table thead th {
	background: #f6f8fa !important;
	border-bottom: 1px solid rgba(0, 0, 0, .06) !important;
}

/* 버튼 줄 */
.cute-modal .cute-btn-row {
	margin-top: .5rem !important;
}

/* 버튼 */
.cute-modal .btn-round-sm {
	padding: .35rem .7rem !important;
	border-radius: 10px !important;
}
/* 모달 css영역 끝 입니다 */

/* 이전 다음글 css */
.modern-nav-section {
	padding: 0.75rem 1rem;
	margin-bottom: 0.5rem;
	border: 1px solid #e9ecef;
	border-radius: 8px;
	background: #f8f9fa;
	cursor: pointer;
	transition: all 0.2s ease;
}

.modern-nav-section:hover {
	background: rgba(100, 140, 164, 0.1);
	border-color: rgba(100, 140, 164, 0.3);
	transform: translateX(3px);
}

.modern-nav-section[style*="opacity: 0.5"] {
	cursor: not-allowed;
}

.modern-nav-badge {
	font-size: 0.85rem;
	color: #6c757d;
	margin-bottom: 0.25rem;
	font-weight: 500;
}

.modern-nav-badge i {
	margin-right: 0.3rem;
}

.modern-nav-title {
	font-size: 0.95rem;
	color: #495057;
	font-weight: 600;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.modern-nav-section[style*="pointer-events: none"] .modern-nav-title {
	color: #adb5bd;
}

	/* 필터 레이블 스타일 */
					.filter-label {
						min-width: 90px;
						/* 레이블 최소 너비 */
						display: inline-block;
						font-weight: 500;
						color: #495057;
						margin-right: 10px;
						flex-shrink: 0;
						/* 레이블이 줄어들지 않도록 */
					}

					hr.my-2 {
						margin: 0.5rem 0;
						border-top: 1px solid rgba(0, 0, 0, 0.1);
					}
</style>

<%@ include file="../include/header.jsp"%>


<section class="content" style="margin: 20px">
	<div class="container-fluid">
		<!-- 섹션/컨테이너 영역 -->
		<div class="row">
			<div class="col-md-12">




				<!-- 카드 시작 -->
				<div class="card card bg-light">
				    		<!-- ./card-header -->
							<table class="table table-bordered table-hover m-0">
								<tbody>
									<tr class="bg-lightblue disabled" data-widget="expandable-table"
										aria-expanded="false">
										<td class="d-flex justify-content-between">
											<div class="ml-2">
												<b>
													검색 필터
												</b>
											</div>
											<div>
												<span class="mr-2">설정</span><i class="fas fa-chevron-up"></i>
											</div>
										</td>
									</tr>
									<tr class="expandable-body d-none p-0">
										<td class="p-3">
											<div class="d-flex justify-content p-1 pl-3 pr-3">
												<!-- 제목 + 분류 -->
												<div class="col-4 m-0">
													<!-- 제목 -->
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">제목</span>
														<input type="text" class="form-control"
															placeholder="제목 입력">
													</div>
			

													<!-- 분류 -->
									
												</div>

												<!-- 결재자 + 결재상태 -->
												<div class="col-4 m-0">
													<!-- 결재자 -->
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">작성자</span>
														<input type="text" class="form-control"
															placeholder="이름 입력">
													</div>


													<!-- 결재상태 -->
										
												</div>

												<!-- 제목 또는 작성자 input -->
												<div class="col-4 m-0">
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">조회기간</span>
														<button type="button" class="btn btn-default flex-fill"
															id="daterange-btn">
															<i class="far fa-calendar-alt"></i> 기간선택
															<i class="fas fa-caret-down"></i>
														</button>
													</div>
												</div>
											
											</div>
											<hr class="my-2 m-1">
											<div class="d-flex justify-content-end align-items-center m-1 p-1">
												<button class="btn btn-default">검색</button>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<!-- /.card-body -->
					<!-- 카드헤더 시작 -->
					<div
						class="card-header d-flex justify-content-between align-items-center">
						<!-- 좌 제목 -->
						<h5 class="card-title mb-0">사내 공지사항</h5>
						<!-- 우 검색 -->
						<div class="search-area ml-auto d-flex"></div>
					</div>
					<!-- 카드헤더 끝 -->
					<!-- 테이블 영역 시작 -->
					<table class="table tight-table">
						<thead>
							<tr>
								<th>순번</th>
								<th>제목</th>
								<th>작성일시</th>
								<th>작성자</th>
								<th>첨부파일</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="noticeVO" items="${articlePage.content}"
								varStatus="status">
								<tr onclick="noticeDetail(${noticeVO.noticeSn})"
									style="cursor: pointer;">
									<td>${(articlePage.currentPage-1) * 10 + status.count}</td>
									<td>${noticeVO.noticeSj}</td>
									<td class="text-muted mt-1"><img
										src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
										alt="시계 아이콘"> <fmt:formatDate
											value="${noticeVO.noticeWritngDt}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
									<td>${noticeVO.nm}</td>
									<td class="text-center"><c:choose>
											<c:when test="${noticeVO.fileGroupSn > 0}">
												<i class="far fa-file text-primary"></i>
											</c:when>
											<c:otherwise>
												<i class="far fa-file" style="color: #d0d0d0;"></i>

											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="card-footer clearfix">${articlePage.pagingArea}</div>
					<!-- 테이블 영역 끝 -->


					<!-- 모달영역 시작 -->
					<div class="modal fade cute-modal" id="detailModal">
						<div class="modal-dialog modal-xl">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title">공지사항</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<table class="table cute-table">
										<thead>
											<tr>
												<th>순번</th>
												<td><div id="noticeSn"></div></td>
											</tr>
											<tr>
												<th>제목</th>
												<td><div id="noticeSj"></div></td>
											</tr>
											<tr>
												<th>내용</th>
												<td><div id="noticeCn"></div></td>
											</tr>
											<tr>
												<th style="white-space: nowrap;">작성일시</th>
												<td class="text-muted"><img
													src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
													alt="시계 아이콘" style="width: 20px; vertical-align: middle;">
													<span id="noticeWritngDt" style="margin-left: 4px;"></span>
												</td>
											</tr>
											<tr>
												<th>작성자</th>
												<td><div id="empId"></div></td>
											</tr>
											<tr>
												<th>파일</th>
												<td><div id="fileDetailVOList"></div></td>
											</tr>
										</thead>
									</table>
									<div
										style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 2px solid #f1f3f5;">
										<div id="prevSection" onclick="clickPrev()"
											class="modern-nav-section">
											<div class="modern-nav-badge">
												<i class="fas fa-chevron-up"></i> 이전글
											</div>
											<div id="prevTitle" class="modern-nav-title">이전글 없음</div>
										</div>

										<div id="nextSection" onclick="clickNext()"
											class="modern-nav-section">
											<div class="modern-nav-badge">
												<i class="fas fa-chevron-down"></i> 다음글
											</div>
											<div id="nextTitle" class="modern-nav-title">다음글 없음</div>
										</div>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button"
										class="btn btn-secondary btn-sm btn-round-sm"
										data-dismiss="modal">닫기</button>
								</div>
							</div>
						</div>
					</div>
					<!-- 모달 영역 끝 -->


				</div>
			</div>
		</div>
		<!-- 섹션/컨테이너 영역 끝 -->
</section>
<!-- 섹션/컨테이너 영역 끝 -->

<%@ include file="../include/footer.jsp"%>



<script type="text/javascript">
let noticeList = [];
let currentIndex = -1;

	document.addEventListener("DOMContentLoaded", function(){
		fetch("/notice/listJson")
        .then(resp => resp.json())
        .then(data => {
            noticeList = data.noticeList;
            console.log("공지사항 리스트 로드 완료:", noticeList.length, "개");
        })
        .catch(error => console.log("리스트 로드 에러:", error));		
	})
		noticeDetail = function(noticeSn){
			
			let data = {
					"noticeSn" : noticeSn
			}
			
			fetch("/notice/detail", {
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
				const notice = data.noticeVO;
				const fileDetailVOList = data.fileDetailVOList;
				
				currentIndex = noticeList.findIndex(n => n.noticeSn === notice.noticeSn);
				
				console.log("data : ",data);
				console.log("fileDetailVOList : ", fileDetailVOList);
				
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
				            ? '<i class="fas fa-file-pdf text-danger mr-2"></i>'
				            : '<i class="fas fa-file mr-2"></i>';
				        
				        filesHtml += `
				            <div>
			                <a href="/notice/download?fileGroupSn=\${file.fileGroupSn}&fileNo=\${file.fileNo}">
				                <span>
				                    \${icon}
				                    \${fileName}
				                </span>
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
		//검색 필터 토글
		function toggleFilter() {
			  const filterBody = document.getElementById('filterBody');
			  const toggleBtn = document.querySelector('.filter-btn-toggle i');
			  
			  filterBody.classList.toggle('collapsed');
			  toggleBtn.classList.toggle('rotated');
			}
</script>
