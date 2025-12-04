<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ include file="../include/header.jsp"%>
<!-- ==================캘린더 스타일 지정 시작================== -->
<style>
/*날짜 숫자 색상*/
#calendar {
	max-width: 600px;
	/* 전체 폭 줄이기 */
	max-height: 400px;
	/* 전체 폭 줄이기 */
	font-size: 0.5rem;
	/* 전체 글자 크기줄이기 */
	margin: 0 auto;
	/* 가운데 정렬 */
}
.fc-daygrid-day-number {
	color: gray;
}
/*요일 헤더 색상*/
.fc-col-header-cell-cushion {
	color: black;
}
/*오늘 날짜 배경색*/
.fc-day-today {
	background-color: beige;
}
/*이벤트 일정 스타일*/
.fc-event {
	background-color: plum;
	color: blueviolet;
	border-radius: 3px;
}
/* Week number 색상 */
.fc .fc-daygrid-week-number {
	color: #888888;
}
<!-- ==================캘린더 스타일 지정끝================== -->

/* 민원ck에디터 시작 */
.ck.ck-editor {
	max-width: 300px;
}
.ck-editor__editable {
	min-height: 100px;
}
/* 민원ck에디터 끝 */

/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 시작 */
 .tight-table,
 .tight-table th, 
 .tight-table td {
  padding:3px 5px !important;   /* 테이블들 행간격 */
  overflow: hidden; 
  text-overflow: ellipsis;	/* 길어진 글은 ...처리 */
  white-space: nowrap;		/* 줄바꿈 X */
 }
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 끝 */
/* 공통 바로가기 버튼 스타일! 카드 상단의 바로가기 버튼입니다. 변경 필요시 여기서 변경 */
.go-link-btn {
    font-size: 0.6rem;        /* 글자 크기 조금 작게 */
    font-weight: 700;          /* 글자 두께 살짝 굵게 */
    padding: 0.15rem 0.3rem;   /* 버튼 높이·좌우 여백 조절 */
    border-radius: 8px;        /* 버튼 모서리 부드럽게 */
    display: inline-flex;      /* 텍스트 + 아이콘 정렬용 */
    align-items: center;       /* 세로 중앙 정렬 */
    gap: 3px;                  /* 텍스트와 아이콘 사이 간격 */
}

.go-link-btn.btn-outline-primary:hover {
	transform: scaleX(1.05); /* 버튼 확대 */
    color: #fff;               /* 글씨 흰색 */
    background-color: rgba(255, 106, 0, 0.8); /* 디편한 시그니쳐 색상 */
}
/* 공통 바로가기 버튼 끝 */
/* 공통 카드별 상단 영역 시작 */
.card-title {
    font-size: 0.8rem !important;        /* 글자 크기 조금 작게 */
    font-weight: 700 !important;          /* 글자 두께 살짝 굵게 */
    padding-top:4px !important;
    padding-bottom:4px !important;
}
/* 공통 카드별 상단 영역 끝 */
.card-body {
	padding: 0.1rem !important;
	font-size: 0.8rem !important;
}
.card {
 	padding: 0.3rem !important;
	border-radius: 1.2rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}
/* tight-table호버이벤트시작 */
.tight-table tbody tr {
    transition: background-color 0.25s ease, 
                box-shadow 0.25s ease,
                transform 0.2s ease !important; 
}
.tight-table tbody tr:hover {
    background-color: rgba(100, 140, 164, 0.12) !important; /* 은은한 파스텔 */
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15) !important;              /* 은은한 그림자 */
    transform: translateY(-2px) !important;                           /* 살짝 띄우기 */
    cursor: pointer;
}
/* tight-table호버이벤트끝 */

 
</style>


<!-- 좌측 섹션 -->
<!-- <section class="content"> -->
<div class="row">
	<!-- 좌측 섹션 -->
	<section class="col-lg-4 connectedSortable ui-sortable">
		<!-- 일정 시작 -->
		<div class="card card bg-light">
			<!-- 카드 헤더 시작 -->
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="far fa-calendar-alt"></i>&nbsp;일정
				</h3>
				<div class="card-tools">
					<div class="nav nav-pills ml-auto">
						<div class="nav-item ">
							<button type="button" id="registerBtn"
								class="btn btn-primary btn-sm mr-3 mt-1 go-link-btn">일정
								등록</button>
						</div>
						<div class="card-tools">
							<a href="/fx/list" class="btn btn-sm btn-outline-primary mt-1 go-link-btn">
								캘린더 바로가기 <i class="fas fa-arrow-circle-right ml-2"></i>
							</a>
						</div>
					</div>
				</div>
			</div>
			<!-- 카드 헤더 끝 -->
			<div class="card-body bg-white">
				<div class="tab-content pt-0">
					<!--// body 시작 //-->
					<!-- 실제 화면을 담을 영역 -->
					<div id="Wrapper">
						<div id='calendar'></div>
					</div>

					<!-- 일정 등록 모달 시작 -->
					<input type="hidden" id="schdulSn" name="schdulSn"
						value="${fxVO.schdulSn}" />
					<div class="modal fade" id="scheduleModal" tabindex="-1"
						aria-labelledby="scheduleModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<!-- 헤더 -->
								<div class="modal-header">
									<h5 class="modal-title" id="scheduleModalLabel">일정 등록</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="닫기">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<!-- 바디 -->
								<div class="modal-body">
									<form id="scheduleForm">
										<div class="form-group row">
											<label class="col-sm-2 col-form-label">담당자 ID</label>
											<div class="col-sm-10">
												<input type="text" id="empId" name="empId"
													class="form-control" placeholder="담당자 ID 입력">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">제목</label>
											<div class="col-sm-10">
												<input type="text" id="fxSj" name="fxSj"
													class="form-control" placeholder="제목 입력">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">구분</label>
											<div class="col-sm-10">
												<select id="fxIem" name="fxIem" class="form-control">
													<option value="">선택</option>
													<option value="시설">시설</option>
													<option value="커뮤니티">커뮤니티</option>
													<option value="개인일정">개인일정</option>
												</select>
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">시작일시</label>
											<div class="col-sm-4">
												<input type="datetime-local" id="fxBeginDt" name="fxBeginDt"
													class="form-control">
											</div>
											<label class="col-sm-2 col-form-label text-right">종료일시</label>
											<div class="col-sm-4">
												<input type="datetime-local" id="fxEndDt" name="fxEndDt"
													class="form-control">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">내용</label>
											<div class="col-sm-10">
												<textarea id="fxCn" name="fxCn" class="form-control"
													rows="3" placeholder="내용 입력"></textarea>
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">장소</label>
											<div class="col-sm-10">
												<input type="text" id="fxPlace" name="fxPlace"
													class="form-control" placeholder="장소 입력">
											</div>
										</div>
									</form>
								</div>

								<!-- 푸터 -->
								<div class="modal-footer">
									<button type="button" class="btn btn-primary" id="saveBtn">등록</button>
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">취소</button>
								</div>

							</div>
						</div>
					</div>

					<!-- 일정 등록 모달 끝 -->



					<!--상세보기 모달 시작-->
					<input type="hidden" id="detailschdulSn" name="detailschdulSn"
						value="${fxVO.schdulSn}" />

					<div class="modal fade" id="detailModal" tabindex="-1"
						aria-labelledby="detailModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">

								<!-- 헤더 -->
								<div class="modal-header">
									<h5 class="modal-title" id="detailModalLabel">상세 보기</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="닫기">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>

								<!-- 바디 -->
								<div class="modal-body">
									<form id="detailscheduleForm">
										<div class="form-group row">
											<label class="col-sm-2 col-form-label">담당자</label>
											<div class="col-sm-10">
												<input type="text" id="detailempId" name="detailempId"
													class="form-control">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">제목</label>
											<div class="col-sm-10">
												<input type="text" id="detailfxSj" name="detailfxSj"
													class="form-control">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">구분</label>
											<div class="col-sm-10">
												<select id="detailfxIem" name="detailfxIem"
													class="form-control">
													<option value="">선택</option>
													<option value="시설">시설</option>
													<option value="커뮤니티">커뮤니티</option>
													<option value="개인일정">개인일정</option>
												</select>
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">시작일시</label>
											<div class="col-sm-4">
												<input type="datetime-local" id="detailfxBeginDt"
													name="detailfxBeginDt" class="form-control">
											</div>
											<label class="col-sm-2 col-form-label text-right">종료일시</label>
											<div class="col-sm-4">
												<input type="datetime-local" id="detailfxEndDt"
													name="detailfxEndDt" class="form-control">
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">내용</label>
											<div class="col-sm-10">
												<textarea id="detailfxCn" name="detailfxCn"
													class="form-control" rows="3"></textarea>
											</div>
										</div>

										<div class="form-group row">
											<label class="col-sm-2 col-form-label">장소</label>
											<div class="col-sm-10">
												<input type="text" id="detailfxPlace" name="detailfxPlace"
													class="form-control">
											</div>
										</div>
									</form>
								</div>

								<!-- 푸터 -->
								<div class="modal-footer">
									<button type="button" class="btn btn-primary"
										id="detailsaveBtn">수정</button>
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">취소</button>
								</div>

							</div>
						</div>
					</div>
					<!--상세보기 모달 끝-->
				</div>
			</div>
		</div>

		<!-- 일정 끝 -->




		<!-- 투표 바로가기 -->
		<div class="card bg-light" style="font-size: 0.75em;">
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="fas fa-th mr-1"></i>진행중인 투표
				</h3>
				<div class="card-tools">
					<a href="/vote/voteMtr" class="btn btn-sm btn-outline-primary go-link-btn">
						투표 바로가기 <i class="fas fa-arrow-circle-right ml-2"></i>
					</a>
				</div>
			</div>
			<div class="card-body bg-white p-0">
				 <div class="card-body pt-0">
				<!-- 셀+테두리합쳐서 하나로 만들기;        테두리 none;     넓이 100%; -->
				<table class="table tight-table"  
					style="border-collapse: collapse; border: none; width: 100%;">
					<thead>
						<tr>
							<th style="width: 10%; text-align: center;">순번</th>
							<th style="width: 35%; text-align: center;">제목</th>
							<th style="width: 15%; text-align: center;">시작시간</th>
							<th style="width: 15%; text-align: center;">마감시간</th>
							<th style="width: 10%; text-align: center;">상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="p" items="${articlePage1.content}"
							varStatus="stat">
							<tr>
								<td style="text-align: center;"><a
									href="/vote/voteDetail?voteMtrSn=${p.voteMtrSn}">${p.voteMtrSn}</a>
								</td>
								<td><a href="/vote/voteDetail?voteMtrSn=${p.voteMtrSn}">
										<c:out value="${p.mtrSj}" />
								</a></td>
								<td class="small text-muted mt-1" style="text-align: center;">
									${fn:substring(p.voteBeginDt, 0, 10)}</td>
								<td class="small text-muted mt-1" style="text-align: center;">
									${fn:substring(p.voteEndDt, 0, 10)}</td>
									<!-- 상태 별 색 추가 업데이트 2025-11-01 kbh -->
								<td style="text-align: center;">
									<c:choose>
										<c:when test="${p.stat eq '진행중'}">
											<span class="badge badge-success">${p.stat}</span>
										</c:when>
										<c:when test="${p.stat eq '예정'}">
											<span class="badge badge-secondary">${p.stat}</span>
										</c:when>
										<c:when test="${p.stat eq '마감'}">
											<span class="badge badge-warning">${p.stat}</span>
										</c:when>
										<c:otherwise>
											<span class="badge badge-light">${p.stat}</span>
										</c:otherwise>
									</c:choose>

								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				</div>
				<!-- 카드 끝 -->
	</section>
	<!-- 좌측영역 끝 -->



	<!-- 여기부터 중앙 영역 시작-->
	<section class="col-lg-4 connectedSortable ui-sortable">



		<!-- 민원관리 영역 카드시작 -->
		<div class="card bg-light" style="font-size: 0.75em;">
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="fas fa-th mr-1"></i> 민원관리
				</h3>
				<div class="card-tools">
					<a href="/cvplRcept/list" class="btn btn-sm btn-outline-primary go-link-btn">민원관리 바로가기<i class="fas fa-arrow-circle-right ml-2"></i>
					</a>
				</div>
			</div>

			<div class="card-body bg-white p-0">
				<div class="card-body pt-0">
					<div id="mainListWrap" style="width: 100%">
						<form id="searchForm" action="/cvplRcept/list" method="get" class="row g-2 align-items-end">
							<input type="hidden" name="currentPage" id="currentPage"
								value="${param.currentPage != null ? param.currentPage : 1}">
						</form>
						</div>
						<table class="table tight-table no-row-click" style="border-collapse: collapse; border: none; width: 100%; padding-bottom:0px;margin-bottom: 0px;">
							<thead>
								<tr>
									<th>순번</th>
									<th>제목</th>
									<th>작성자</th>
									<th>요청일자</th>
									<th>접수일자</th>
									<th>처리상태</th>
									<th>남은 기간</th>
									<th>관리</th>
								</tr>
							</thead>
							<tbody id="cvplTableBody">
								<tr>
									<td colspan="8" class="text-center text-muted py-4">해당 조건에
										맞는 민원이 없습니다.</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- 상세/접수 통합 영역 -->
				<div id="detailWrap" style="display: none; gap: 30px;">
					<div id="detailLeft" style="flex: 1; border-right: 1px solid #ccc; padding-right: 20px;"></div>
					<div id="detailRight" style="flex: 1; padding-left: 20px;"></div>
				</div>
			</div>
		<!-- 민원관리 영역 카드끝 -->



		<!-- 결재 카드영역시작 -->
		<div class="card bg-light" style="font-size: 0.75em;">
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="fas fa-th mr-1"></i> 결재
					<c:set var="rejectCnt" value="0" />
					<c:set var="pendingCnt" value="0" />
					<c:forEach var="vo" items="${articlePage2.content}">
						<c:choose>
							<c:when test="${vo.totSanctnStts eq '반려'}">
								<c:set var="rejectCnt" value="${rejectCnt + 1}" />
							</c:when>
							<c:when test="${vo.totSanctnStts eq '미결'}">
								<c:set var="pendingCnt" value="${pendingCnt + 1}" />
							</c:when>
						</c:choose>
					</c:forEach>

					<span class="badge badge-danger ml-2">반려 ${rejectCnt}</span> <span
						class="badge badge-warning ml-2">미결 ${pendingCnt}</span>
				</h3>
				<div class="card-tools">
					<a href="/elctrnsanctn/getElctrnsanctnList"
						class="btn btn-sm btn-outline-primary go-link-btn">결재관리 바로가기<i
						class="fas fa-arrow-circle-right ml-2"></i></a>
				</div>
			</div>

			<div class="card-body bg-white p-0">
				<div class="card-body pt-0">
					<div style="width: 100%">
						<table class="table tight-table mb-0" 
							style="border-collapse: collapse; border: none; width: 100%;">
							<thead>
								<tr>
									<th>순번</th>
									<th>분류</th>
									<th>제목</th>
									<th>등록일시</th>
									<th>기안일시</th>
									<th>기안상태</th>
									<th>결재상태</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="elctrnsanctnVO" items="${articlePage2.content}">
									<tr class="elctrnsanctnRow">
										<td>${elctrnsanctnVO.rnum}<input type="hidden"
											id="elctrnsanctnSn" value="${elctrnsanctnVO.elctrnsanctnSn}">
										</td>
										<td>${elctrnsanctnVO.drftDocVO.elctrnsanctnManageVO.sanctnSecode}/${elctrnsanctnVO.drftDocVO.drftDocNm}</td>
										<td>${elctrnsanctnVO.drftSj }</td>
										<td class="small text-muted mt-1"><fmt:formatDate value="${elctrnsanctnVO.creatDt}" pattern="yyyy-MM-dd" /></td>
										<td class="small text-muted mt-1"><fmt:formatDate value="${elctrnsanctnVO.drftDt}" pattern="yyyy-MM-dd" /></td>
										<td><c:choose>
												<c:when test="${elctrnsanctnVO.drftTmprstreStts eq '임시저장'}">
													<span class="badge badge-success">
														${elctrnsanctnVO.drftTmprstreStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.drftTmprstreStts eq '기안완료'}">
													<span class="badge badge-primary">
														${elctrnsanctnVO.drftTmprstreStts} </span>
												</c:when>
											</c:choose></td>
										<td><c:choose>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '미결'}">
													<span class="badge badge-warning">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '반려'}">
													<span class="badge badge-danger">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '결재 완료'}">
													<span class="badge badge-primary">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '진행중'}">
													<span class="badge badge-success">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
											</c:choose></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 결재 카드영역 끝 -->

		<!-- 중앙 섹션 끝 -->
	</section>








	<!-- 여기부터 우측 영역 시작-->
	<section class="col-lg-4 connectedSortable ui-sortable">


		<!-- 임시 영역 카드시작 -->
		<div class="card bg-light" style="font-size: 0.75em;">
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="fas fa-th mr-1"></i> 임시영역
					<c:set var="rejectCnt" value="0" />
					<c:set var="pendingCnt" value="0" />
					<c:forEach var="vo" items="${articlePage2.content}">
						<c:choose>
							<c:when test="${vo.totSanctnStts eq '반려'}">
								<c:set var="rejectCnt" value="${rejectCnt + 1}" />
							</c:when>
							<c:when test="${vo.totSanctnStts eq '미결'}">
								<c:set var="pendingCnt" value="${pendingCnt + 1}" />
							</c:when>
						</c:choose>
					</c:forEach>

					<span class="badge badge-danger ml-2">반려 ${rejectCnt}</span> <span
						class="badge badge-warning ml-2">미결 ${pendingCnt}</span>
				</h3>
				<div class="card-tools">
					<a href="#"
						class="btn btn-sm btn-outline-primary go-link-btn">결재관리 바로가기<i
						class="fas fa-arrow-circle-right ml-2"></i></a>
				</div>
			</div>

			<div class="card-body bg-white p-0">
				<div class="card-body pt-0">
					<div style="width: 100%">
						<table class="table tight-table mb-0" 
							style="border-collapse: collapse; border: none; width: 100%;">
							<thead>
								<tr>
									<th>순번</th>
									<th>분류</th>
									<th>제목</th>
									<th>등록일시</th>
									<th>기안일시</th>
									<th>기안상태</th>
									<th>결재상태</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="elctrnsanctnVO" items="${articlePage2.content}">
									<tr class="elctrnsanctnRow">
										<td>${elctrnsanctnVO.rnum}<input type="hidden"
											id="elctrnsanctnSn" value="${elctrnsanctnVO.elctrnsanctnSn}">
										</td>
										<td>${elctrnsanctnVO.drftDocVO.elctrnsanctnManageVO.sanctnSecode}/${elctrnsanctnVO.drftDocVO.drftDocNm}</td>
										<td>${elctrnsanctnVO.drftSj }</td>
										<td class="small text-muted mt-1"><fmt:formatDate value="${elctrnsanctnVO.creatDt}" pattern="yyyy-MM-dd" /></td>
										<td class="small text-muted mt-1"><fmt:formatDate value="${elctrnsanctnVO.drftDt}" pattern="yyyy-MM-dd" /></td>
										<td><c:choose>
												<c:when test="${elctrnsanctnVO.drftTmprstreStts eq '임시저장'}">
													<span class="badge badge-success">
														${elctrnsanctnVO.drftTmprstreStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.drftTmprstreStts eq '기안완료'}">
													<span class="badge badge-primary">
														${elctrnsanctnVO.drftTmprstreStts} </span>
												</c:when>
											</c:choose></td>
										<td><c:choose>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '미결'}">
													<span class="badge badge-warning">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '반려'}">
													<span class="badge badge-danger">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '결재 완료'}">
													<span class="badge badge-primary">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
												<c:when test="${elctrnsanctnVO.totSanctnStts eq '진행중'}">
													<span class="badge badge-success">
														${elctrnsanctnVO.totSanctnStts} </span>
												</c:when>
											</c:choose></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 민원관리 영역 카드끝 -->



		<!-- 임시 영역 카드시작 -->
		<div class="card bg-light" style="font-size: 0.75em;">
			<div class="card-header card-title">
				<h3 class="card-title">
					<i class="fas fa-th mr-1"></i> 임시영역
				</h3>
				<div class="card-tools">
					<a href="#"
						class="btn btn-sm btn-outline-primary go-link-btn">결재관리 바로가기<i
						class="fas fa-arrow-circle-right ml-2"></i></a>
				</div>
			</div>

			<div class="card-body bg-white p-0">
				<div class="card-body pt-0">
					<div style="width: 100%">
						<table class="table tight-table mb-0" 
							style="border-collapse: collapse; border: none; width: 100%;">
							<thead>
								<tr>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
								</tr>
							</thead>
							<tbody>
<button type="button" class="btn btn-secondary" onclick="location.href='/elctrnsanctn/getElctrnsanctnList'">결재</button>
<button type="button" class="btn btn-secondary" onclick="location.href='/cntrct/postCntrct'">계약을 해보잨</button>
<button type="button" class="btn btn-secondary" onclick="location.href='/bidPblanc/getBidPblancList'">입찰 공고를 보자!</button>
<button type="button" class="btn btn-secondary" onclick="location.href='/bdder/getMyBdderList'">나의 입찰 공고를 보자!</button>
<button type="button" class="btn btn-secondary" onclick="location.href='/bidPblanc/getBidPblancListAsEmp'">공고+신청한업체를 보자!</button>
<button type="button" class="btn btn-secondary" onclick="location.href='/cvplRcept/list'">민원</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/vote/voteMtr';">투표</button>   
<button type="button" class="btn btn-secondary" onclick="window.location.href='/ccpyManage/postCcpyManage';">협력업체 등록</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/ccpyManage/getCcpyManageGuestList';">협력업체 신청 목록</button>
<button type="button" class="btn btn-secondary" onclick="window.location.href='/notice/wnmpy_notice';">사내 공지사항</button>
<sec:authorize access="hasRole('ADMIN')">
    <button type="button" class="btn btn-secondary" onclick="window.location.href='/notice/list';">
        공지사항 관리
    </button>
</sec:authorize>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 민원관리 영역 카드끝 -->

		<!-- 우측 섹션 끝 -->
	</section>





















	<!-- 푸터 시작 -->
	<%@ include file="../include/footer.jsp"%>
	<!-- 푸터 끝 -->







	<script>
	////////////////////////////////////////////////캘린더의 script 영역////////////////////////////////////////////////
	document.addEventListener("DOMContentLoaded", function () {
		//캘린더 
		//캘린더 헤더 옵션
		const headerToolbar = {
			left: 'prevYear,prev,next,nextYear today',
			center: 'title',
			right: 'dayGridMonth,dayGridWeek,timeGridDay'
		}
		// 캘린더 생성 옵션
		const calendarOption = {
			height: '500px', // calendar 높이 설정
			expandRows: true, // 화면에 맞게 높이 재설정
			slotMinTime: '09:00', // Day 캘린더 시작 시간
			slotMaxTime: '18:00', // Day 캘린더 종료 시간
			// 맨 위 헤더 지정
			headerToolbar: headerToolbar,
			initialView: 'dayGridMonth',  // default: dayGridMonth 'dayGridWeek', 'timeGridDay', 'listWeek'
			locale: 'kr',        // 언어 설정
			selectable: true,    // 영역 선택
			selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
			navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
			weekNumbers: true,   // WeekNumber 출력여부, default false
			editable: true,      // event(일정) 
			dayMaxEventRows: true,  // Row 높이보다 많으면 +숫자 more 링크 보임!
			nowIndicator: true,
			events: function (info, successCallback, failureCallback) {
				const url = "/fx/listAjax";
				$.ajax({
					url: url,
					contentType: "application/json",
					type: 'get',
					dataType: 'json',
					success: function (param) {
						var events = [];
						console.log("param : ", param);
						$.each(param, function (index, data) {
							console.log("data : ", data);
							//구분(시설,커뮤니티,일정)에 따라 색상 다르게 반영
							let bgColor = "";
							let texColor = "white";
							switch (data.fxIem) {
								case "커뮤니티":
									bgColor = "lightblue";
									break;

								case "개인일정":
									bgColor = "lightgreen";
									texColor = "black";
									break;
							}
							events.push({
								id: data.schdulSn,
								title: data.fxSj,
								start: data.fxBeginDt,
								end: data.fxEndDt,
								allDay: false,
								backgroundColor: bgColor, //배경색
								textColor: texColor,    //글자색
								extendedProps: {  //추가 데이터
									empId: data.empId,
									fxIem: data.fxIem,
									fxCn: data.fxCn,
									fxPlace: data.fxPlace
								}
							});
						})
						successCallback(events);
					}
				});
			}
		}
		// 캘린더 생성
		const calendarEl = document.querySelector("#calendar");
		const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
		// 캘린더 그리기
		calendar.render();
		// 캘린더 이벤트 등록
		calendar.on("eventAdd", info => console.log("Add:", info));
		calendar.on("eventChange", info => console.log("Change:", info));
		calendar.on("eventRemove", info => console.log("Remove:", info));
		calendar.on("eventClick", info => {
			console.log("eClick:", info);
			console.log('Event: ', info.event.extendedProps);
			console.log('Coordinates: ', info.jsEvent);
			console.log('View: ', info.view);
		});
		calendar.on("eventMouseEnter", info => console.log("eEnter:", info));
		calendar.on("eventMouseLeave", info => console.log("eLeave:", info));
		calendar.on("dateClick", info => console.log("dateClick:", info));
		calendar.on("select", info => {
			console.log("체크:", info);
			document.querySelector("#fxBeginDt").value = info.startStr;
			document.querySelector("#fxEndDt").value = info.endStr;
			fxBeginDt.value = info.startStr;   //달력화면에서 날짜 클릭 or 드래크해서 일정 영역을 선택했을때 실행
			fxEndDt.value = info.endStr;
			$("#scheduleModal").modal('show');
		});
		//데이터값
		const modalBtn = document.querySelector("#registerBtn");
		modalBtn.addEventListener("click", function (e) {   //일정 추가 버튼을 누르면
			e.preventDefault();
			$("#scheduleModal").modal('show');
		});
		const saveBtnn = document.querySelector("#saveBtn");
		saveBtnn.addEventListener("click", function () {  //저장 버튼을 누르면
			const schdulSn = document.querySelector("#schdulSn").value;
			const empId = document.querySelector("#empId").value;
			const fxSj = document.querySelector("#fxSj").value;
			const fxIem = document.querySelector("#fxIem").value;
			const fxBeginDt = document.querySelector("#fxBeginDt").value;
			const fxEndDt = document.querySelector("#fxEndDt").value;
			const fxCn = document.querySelector("#fxCn").value;
			const fxPlace = document.querySelector("#fxPlace").value;
			let nhs = {
				"schdulSn": schdulSn,
				"empId": empId,
				"fxSj": fxSj,
				"fxIem": fxIem,
				"fxBeginDt": fxBeginDt,
				"fxEndDt": fxEndDt,
				"fxCn": fxCn,
				"fxPlace": fxPlace
			}
			//일정 등록 요청
			fetch("/fx/insert", {
				method: "post",
				headers: { 'Content-Type': "application/json;charset=utf-8" },
				body: JSON.stringify(nhs)
			})
				.then(response => {
					return response.text();
				})
				.then(result => {
					console.log("result :", result);

					if (result == "success") {
						alert("등록이 완료되었습니다.");
						$("#scheduleModal").modal('hide');  //모달 닫기
						$("#scheduleForm")[0].reset();
						calendar.refetchEvents();
					} else {
						alert("등록에 실패했습니다.")
					}
				})
				.catch(error => {
					console.log("error : ", error);
				})
		})
		//일정 클릭 시 상세보기
		calendar.on("eventClick", function (info) {  //info:fullcalendar가 event를 클릭했을때 자동으로 전달해주는 객체
			console.log("info.event: ", info.event);
			const period = info.event;
			//수정모달 일련번호 넣기
			$("#detailschdulSn").val(period.id);
			//이전 모달 내용 가지고오기
			$("#detailempId").val(period.extendedProps.empId);
			$("#detailfxSj").val(period.title);
			$("#detailfxIem").val(period.extendedProps.fxIem);
			$("#detailfxBeginDt").val(period.startStr.substring(0, 16));
			$("#detailfxEndDt").val(period.endStr.substring(0, 16));
			$("#detailfxCn").val(period.extendedProps.fxCn);
			$("#detailfxPlace").val(period.extendedProps.fxPlace);
			//모달 띄우기
			$("#detailModal").modal('show');
		});
		const modifyBtn = document.querySelector("#detailsaveBtn");
		modifyBtn.addEventListener("click", function () {  //수정 버튼을 누르면
			const schdulSn = document.querySelector("#detailschdulSn").value;
			const empId = document.querySelector("#detailempId").value;
			const fxSj = document.querySelector("#detailfxSj").value;
			const fxIem = document.querySelector("#detailfxIem").value;
			const fxBeginDt = document.querySelector("#detailfxBeginDt").value;
			const fxEndDt = document.querySelector("#detailfxEndDt").value;
			const fxCn = document.querySelector("#detailfxCn").value;
			const fxPlace = document.querySelector("#detailfxPlace").value;
			let nhs = {
				"schdulSn": schdulSn,
				"empId": empId,
				"fxSj": fxSj,
				"fxIem": fxIem,
				"fxBeginDt": fxBeginDt,
				"fxEndDt": fxEndDt,
				"fxCn": fxCn,
				"fxPlace": fxPlace
			}
			//일정 수정 요청
			fetch("/fx/modify", {
				method: "post",
				headers: { 'Content-Type': "application/json;charset=utf-8" },
				body: JSON.stringify(nhs)
			})
				.then(response => {
					return response.text();
				})
				.then(result => {
					console.log("result :", result);

					if (result == "success") {
						alert("수정이 완료되었습니다.");
						$("#detailModal").modal('hide');  //모달 닫기
						calendar.refetchEvents();
					} else {
						alert("수정에 실패했습니다.")
					}
				})
				.catch(error => {
					console.log("error : ", error);
				})
		})
	});
</script>
	<!--/////////////////////////////////////////////// 캘린더의 script 영역 ///////////////////////////////////////////////-->
	<!--/////////////////////////////////////////////// 민원의 script 영역 ///////////////////////////////////////////////-->
	<script>
	// 민원 테이블 전체에 이벤트 위임
	// 페이지 최상단, renderTable 밖에서 딱 한 번만 등록
	document.getElementById("cvplTableBody").addEventListener("click", e => {
	    // 버튼이면 tr 클릭은 아예 실행 안 함
	    if (e.target.closest("button")) {
	        return; 
	    }
	
	    // 버튼이 아니면 tr 클릭 로직 실행
	    const tr = e.target.closest("tr");
	    if (tr) {
	        // 네가 원래 넣었던 이동 코드 여기 배치
	        const cvplSn = tr.dataset.cvplsn;
	        if (cvplSn) {
	            // 예: 상세 이동
	            console.log("행 클릭:", cvplSn);
	        }
	    }
	});

						document.addEventListener("DOMContentLoaded", () => {
							// 테이블과 폼 요소 캐싱
							const tableBody = document.getElementById("cvplTableBody");			// 민원 리스트 테이블 본문 영역
							const pagingArea = document.getElementById("pagingAreaWrap");		// 페이지네이션 영역
							const form = document.getElementById("searchForm");					// 검색 폼
							const currentPageInput = document.getElementById("currentPage");	// 현재 페이지 hidden input
							const sizeSelect = document.getElementById("sizeSelect");			// 보기 개수
							const mainListWrap = document.getElementById("mainListWrap");		// 리스트/검색 전체 영역
							const detailWrap = document.getElementById("detailWrap");			// 상세+접수 통합 화면 영역
							const detailLeft = document.getElementById("detailLeft");			// 상세 영역
							const detailRight = document.getElementById("detailRight");			// 접수 입력 영역
							// 초기 로딩 시 리스트 자동 조회 (0.3초 지연 후 실행)
							setTimeout(() => loadList(), 300);
							// 페이지당 개수 변경 시 리스트 다시 로드
							sizeSelect.addEventListener("change", () => {
								currentPageInput.value = 1; // 첫 페이지부터
								loadList();
							});
							// 검색 이벤트 등록
							form.addEventListener("submit", e => {
								e.preventDefault();				// 기본 form submit 동작 차단
								currentPageInput.value = 1;		// 검색 시 항상 첫 페이지부터
								loadList();						// 리스트 재조회
							});
							// 초기화 버튼 클릭 시 폼 리셋
							document.getElementById("resetBtn").addEventListener("click", () => {
								form.reset();
								currentPageInput.value = 1;
								loadList();
							});
							// 리스트 데이터 로드 함수
							function loadList() {
								const params = new URLSearchParams(new FormData(form)).toString();
								console.log([...new FormData(form).entries()]);
								// 로딩 표시
								tableBody.innerHTML = `
												<tr>
													<td colspan="7" class="text-center text-muted py-4">
														<div class="spinner-border text-primary" role="status">
															<span class="visually-hidden">Loading...</span>
														</div>
													</td>
												</tr>
											`;
								// 비동기 요청으로 리스트 조회 //List fetch
								fetch("/cvplRcept/listAjax?" + params)
									.then(res => res.json())
									.then(data => {
										renderTable(data.cvplVOList, data.articlePage);			// 민원 리스트 렌더링
										renderPagination(data.articlePage);		// 페이지네이션 갱신
									})
									.catch(err => console.error("민원 리스트 요청 오류:", err));
							}
							// 테이블 렌더링
							function renderTable(list, articlePage) {
							    
								// 테이블 내부 클릭 시 tr 클릭 이벤트 무효화 (스크립트 침범 방지)
								tableBody.addEventListener("click", e => {
								    if (e.target.closest("button")) {
								        e.stopImmediatePropagation();
								        e.stopPropagation();
								        e.preventDefault();
								    }
								}, true);
								
								if (!list || list.length == 0) {
									tableBody.innerHTML = `
										<table class="table tight-table">
											<td>해당 조건에 맞는 민원이 없습니다.</td>
										</table>`;
									return;
								}
								const fragment = document.createDocumentFragment();
								// 행 생성
								list.forEach((vo, index) => {
									const row = document.createElement("tr");
									// 민원 처리 상태
									const statusText =
										vo.rceptSttus == 0 ? `<span style="color:gray;">대기 중</span>` :
											vo.rceptSttus == 1 ? `<span style="color:orange;">처리 중</span>` :
												`<span style="color:green;">완료</span>
			`;
									// 남은일수 계산
									let remainHtml = "-";
									if (vo.rceptSttus == 2) {
										remainHtml = '-';
									} else if (vo.reqstDt) {
										const requestDate = new Date(vo.reqstDt.substring(0, 10));
										const deadline = new Date(requestDate);
										deadline.setDate(deadline.getDate() + 14);
										const today = new Date();
										const diffTime = deadline.getTime() - today.getTime();
										const remainDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

										if (remainDays <= 0) {
											remainHtml = `<span style="color:gray;">기한 만료</span>`;
										} else if (remainDays <= 3) {
											remainHtml = `<span style="color:red;">D-\${remainDays}</span>`;
										} else if (remainDays <= 7) {
											remainHtml = `<span style="color:orange;">D-\${remainDays}</span>`;
										} else {
											remainHtml = `<span style="color:green;">D-\${remainDays}</span>`;
										}
									}
									// 상태별 버튼 구성
									let actionBtns = "";
									// 접수 버튼 추가
									if (vo.rceptSttus == 0) {
										actionBtns += `
					<button type="button" class="btn btn-primary btn-sm ms-1 rceptBtn" style="font-size: 0.5em; padding: 0.1rem 0.1rem; font-weight:700; font-size:8px; " data-cvplsn="\${vo.cvplSn}">
						접수
					</button>
				`;
									}
									// 종결 버튼 추가
									else if (vo.rceptSttus == 1) {
										actionBtns += `
					<button type="button" class="btn btn-success btn-sm ms-1 endBtn" style="font-size: 0.5em; padding: 0.1rem 0.1rem; font-weight:700; font-size:8px; " data-cvplrceptid="\${vo.cvplRceptId}" data-cvplsn="\${vo.cvplSn}">
						종결
					</button>
				`;
									}
									// 상세 버튼 추가
									else if (vo.rceptSttus == 2) {
										actionBtns += `
					<button type="button" class="btn btn-secondary btn-sm ms-1 detailBtn" style="font-size: 0.5em; padding: 0.1rem 0.1rem; font-weight:700; font-size:8px; " data-cvplsn="\${vo.cvplSn}">
						상세
					</button>
				`;
									}
									const startIndex = (articlePage.currentPage - 1) * articlePage.size;
									const rowNumber = startIndex + index + 1;
									// 행 내용 채우기
									row.innerHTML = `
										<td>\${rowNumber}</td>
										<td>\${vo.cvplSj}</td>
										<td>\${vo.mberNm || vo.mberId}</td>
										<td class="small text-muted mt-1">\${vo.reqstDt ? vo.reqstDt.substring(0,10) : '-'}</td>
										<td class="small text-muted mt-1">\${vo.rceptDt ? vo.rceptDt.substring(0,10) : '-'}</td>
										<td>\${statusText}</td>
										<td>\${remainHtml}</td>
										<td>\${actionBtns}</td>
									`;
									fragment.appendChild(row);
								});
								// 기존 내용 교체
								tableBody.replaceChildren(fragment);
								// 접수 버튼 클릭 시 리스트 숨기고 상세/접수 레이아웃 표시
								tableBody.querySelectorAll(".rceptBtn").forEach(btn => {
									btn.addEventListener("click", (e) => {
										e.stopImmediatePropagation();
									    e.stopPropagation();
									    e.preventDefault();                     // 최상위 강제 차단 // 행 클릭 이벤트 버블링 차단
										const cvplSn = btn.dataset.cvplsn;
										mainListWrap.style.display = "none";	// 리스트 숨김
										detailWrap.style.display = "flex";		// 상세/접수 표시
										loadDetailAndForm(cvplSn, false);
									});
								});
								// 종결 버튼 클릭 시 상세와 접수 보기
								tableBody.querySelectorAll(".endBtn").forEach(btn => {
									btn.addEventListener("click", (e) => {
										e.stopImmediatePropagation();
                                        e.stopPropagation();
                                        e.preventDefault();                     // 최상위 강제 차단 // 행 클릭 이벤트 버블링 차단
										mainListWrap.style.display = "none";
										detailWrap.style.display = "flex";
										loadDetailAndForm(btn.dataset.cvplsn, "end");
									});
								});
								// 완료된 민원 상세 버튼 클릭 시
								tableBody.querySelectorAll(".detailBtn").forEach(btn => {
									btn.addEventListener("click", (e) => {
										e.stopImmediatePropagation();
                                        e.stopPropagation();
                                        e.preventDefault();                     // 최상위 강제 차단 // 행 클릭 이벤트 버블링 차단
										mainListWrap.style.display = "none";
										detailWrap.style.display = "flex";
										loadDetailAndForm(btn.dataset.cvplsn, true); // readOnly 모드로 열기
									});
								});
							}
							// 상세 + 접수 레이아웃 로드
							function loadDetailAndForm(cvplSn, readOnly) {
								fetch("/cvplRcept/cvplDetailAjax?cvplSn=" + cvplSn)
									.then(res => res.json())
									.then(data => {
										const cvplVO = data.cvplVO;
										const cvplRceptVO = data.cvplRceptVO;
										console.log("읽기모드? =>", readOnly, typeof readOnly, "상태값:", cvplVO.rceptSttus);
										//왼족 민원 상세
										let fileHtml = "";
										if (cvplVO.fileGroupVO && cvplVO.fileGroupVO.fileDetailVOList && cvplVO.fileGroupVO.fileDetailVOList.length > 0) {
											fileHtml = `
						<p><strong>첨부 이미지:</strong></p>
						<div style="display:flex; gap:10px; flex-wrap:wrap;">
					`;
											cvplVO.fileGroupVO.fileDetailVOList.forEach(file => {
												const fileUrl = "/upload" + file.fileStrelc;
												if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(file.fileExtsn?.toLowerCase())) {
													fileHtml += `<img src="\${fileUrl}" alt="\${file.fileOrginlNm || ''}" 
								style="width:100px;height:100px;object-fit:cover;border:1px solid #ccc;border-radius:5px;">`;
												}
											});
											fileHtml += `</div>`;
										} else {
											fileHtml = `<p class="text-muted">첨부 이미지가 없습니다.</p>`;
										}
										detailLeft.innerHTML = `
					<h5 class="fw-bold mb-3">\${cvplVO.cvplSj}</h5>
					<p><strong>작성자:</strong> \${cvplVO.mberNm || cvplVO.mberId}</p>
					<p><strong>요청일시:</strong> \${cvplVO.reqstDt ? cvplVO.reqstDt.substring(0,10) : '-'}</p>
					<p><strong>내용:</strong></p>
					<div class="border rounded p-3 bg-light mb-3">\${cvplVO.cvplCn}</div>
					<p><strong>접수일시:</strong> \${cvplVO.rceptDt ? cvplVO.rceptDt.substring(0,10) : '-'}</p><hr>
					<p>\${fileHtml}</p>
				`;
										// 오른쪽(접수버튼 & 종결버튼)(작성 & 읽기)
										if (readOnly) {
											let rceptFileHtml = "";
											if (cvplRceptVO && cvplRceptVO.fileGroupVO && cvplRceptVO.fileGroupVO.fileDetailVOList.length > 0) {
												rceptFileHtml = cvplRceptVO.fileGroupVO.fileDetailVOList.map(f =>
													`<img src="/upload\${f.fileStrelc}" style="width:100px;height:100px;object-fit:cover;border:1px solid #ccc;border-radius:5px;">`
												).join('');
											} else {
												rceptFileHtml = `<p class="text-muted">첨부 없음</p>`;
											}
											const isCompleted = String(cvplVO.rceptSttus) === "2";	// 완료 상태
											const isProcessing = String(cvplVO.rceptSttus) === "1";	// 처리중 상태
											let endButtonHtml = "";
											if (readOnly == "end") {
												endButtonHtml = `<button type="button" class="btn btn-success" id="endBtn" data-cvplrceptid="\${cvplRceptVO.cvplRceptId}">
							종결
						</button>`;
											}
											detailRight.innerHTML = `
						<h5 class="fw-bold mb-3">접수 내용</h5>
						<div class="border rounded p-3 bg-light mb-3">\${cvplRceptVO.rceptCn}</div>
						<p><strong>접수자:</strong> \${cvplRceptVO.empNm || cvplRceptVO.empId}</p>
						<p><strong>접수일:</strong> \${cvplRceptVO.rceptDt ? cvplRceptVO.rceptDt.substring(0,10) : '-'}</p>
						<hr>
						<p><strong>처리 첨부파일:</strong></p>
						<div style="display:flex; gap:10px; flex-wrap:wrap;">\${rceptFileHtml}</div>
						<div class="text-end mt-4">
							<button type="button" class="btn btn-secondary" id="cancelBtn">닫기</button>
							\${endButtonHtml}
						</div>
					`;
											//닫기 버튼
											document.getElementById("cancelBtn").addEventListener("click", () => {
												detailWrap.style.display = "none";
												mainListWrap.style.display = "block";
											});
											// 종결 버튼
											const endBtn = document.getElementById("endBtn");
											if (endBtn) {
												endBtn.addEventListener("click", () => {
													const cvplRceptId = cvplRceptVO.cvplRceptId;
													Swal.fire({
														title: "민원을 종결하시겠습니까?",
														icon: "warning",
														showCancelButton: true,
														confirmButtonText: "예",
														cancelButtonText: "아니오"
													}).then(result => {
														if (result.isConfirmed) {
															fetch("/cvplRcept/cvplEnPost", {
																method: "POST",
																headers: { "Content-Type": "application/x-www-form-urlencoded" },
																body: `cvplRceptId=\${cvplRceptId}`
															})
																.then(res => res.text())
																.then(result => {
																	if (parseInt(result) > 0) {
																		Swal.fire({
																			icon: "success",
																			title: "민원이 종결되었습니다.",
																			timer: 1500,
																			showConfirmButton: false
																		});
																		setTimeout(() => {
																			detailWrap.style.display = "none";
																			mainListWrap.style.display = "block";
																			loadList();
																		}, 1500);
																	} else {
																		Swal.fire({
																			icon: "warning",
																			title: "종결 실패",
																			timer: 1500,
																			showConfirmButton: false
																		});
																	}
																})
																.catch(() => {
																	Swal.fire({
																		icon: "error",
																		title: "서버 오류",
																		timer: 1500,
																		showConfirmButton: false
																	});
																});
														}
													});
												});
											}
											return;
										}
										// 작성모드(false): CKEditor + 파일업로드 활성
										detailRight.innerHTML = `
					<h5 class="fw-bold mb-3">민원 접수</h5>
					<form id="cvplForm" enctype="multipart/form-data">
						<input type="hidden" name="cvplSn" value="\${cvplVO.cvplSn}">
						<textarea id="cvplText" name="rceptCn" rows="5" cols="50" placeholder="처리 내용을 입력하세요."></textarea><br>
						<input type="file" id="cvplFile" name="uploadFiles" multiple accept="image/*"><br>
						<div id="previewArea" style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;"></div><br>
						<div class="text-end">
							<button type="button" class="btn btn-secondary me-2" id="cancelBtn">취소</button>
							<button type="button" class="btn btn-primary" id="successBtn">접수</button>
						</div>
					</form>
				`;
										//닫기 버튼
										document.getElementById("cancelBtn").addEventListener("click", () => {
											detailWrap.style.display = "none";
											mainListWrap.style.display = "block";
										});
										let cvplEditor;
										ClassicEditor.create(document.querySelector('#cvplText'))
											.then(newEditor => window.cvplEditor = newEditor)
											.catch(error => console.error('Editor error:', error));
										$("#cvplFile").on("change", function () {
											const files = this.files;
											const preview = $("#previewArea");
											preview.empty();
											Array.from(files).forEach(file => {
												const reader = new FileReader();
												reader.onload = e => {
													preview.append($("<img>").attr("src", e.target.result).css({
														width: "100px", height: "100px", "object-fit": "cover", border: "1px solid #ccc", "border-radius": "5px"
													}));
												};
												reader.readAsDataURL(file);
											});
										});
										//접수 버튼
										$("#successBtn").click(function (e) {
											e.preventDefault();
											const content = window.cvplEditor.getData().trim();
											if (content == "") {
												Swal.fire({ icon: 'warning', title: '처리 내용을 입력하세요.', timer: 1500, showConfirmButton: false });
												return;
											}
											const formData = new FormData();
											formData.append("cvplSn", cvplVO.cvplSn);
											formData.append("rceptCn", content);
											formData.append("empId", "${sessionScope.emp.empId}");
											const files = $("#cvplFile")[0].files;
											for (let i = 0; i < files.length; i++) formData.append("uploadFiles", files[i]);
											$.ajax({
												url: "/cvplRcept/cvplRceptPost",
												type: "POST",
												data: formData, processData: false, contentType: false,
												success: function (result) {
													if (parseInt(result) > 0) {
														Swal.fire({ icon: 'success', title: '민원이 접수되었습니다.', timer: 1500, showConfirmButton: false });
														setTimeout(() => { detailWrap.style.display = "none"; mainListWrap.style.display = "block"; loadList(); }, 1500);
													} else {
														Swal.fire({ icon: 'warning', title: '접수 실패', timer: 1500, showConfirmButton: false });
													}
												},
												error: function () {
													Swal.fire({ icon: 'error', title: '서버 오류', timer: 1500, showConfirmButton: false });
												}
											});
										});
									});
							}
							// 페이지네이션 렌더링
							function renderPagination(articlePage) {
								if (!pagingArea) return;							//페이지 영역 DOM이 없으면 바로 종료 (예외 처리)
								//서버에서 articlePage 객체가 없거나 내부에 pagingArea HTML 코드가 없으면 영역을 비움
								if (!articlePage || !articlePage.pagingArea) {
									pagingArea.innerHTML = "";
									return;
								}
								pagingArea.innerHTML = articlePage.pagingArea;		//서버에서 받은 페이징 HTML(articlePage.pagingArea)을 삽입
								//페이징 영역 내부의 링크 클릭 이벤트를 위임 처리 (a 태그 클릭 시 화면 이동 대신 goPage() 호출)
								pagingArea.onclick = (e) => {
									const target = e.target.closest("a");			// 클릭된 a 태그 탐색
									if (!target) return;							// a 태그가 아니면 무시
									e.preventDefault();								// 기본 링크 이동 방지
									// href 속성에서 currentPage=숫자 패턴 추출
									const href = target.getAttribute("href");
									const match = href.match(/currentPage=(\d+)/);
									if (match) goPage(match[1]);					//정규식으로 추출한 페이지 번호를 goPage()에 전달
								};
							}
							// 페이지 이동 처리
							function goPage(pageNo) {
								document.getElementById("currentPage").value = pageNo;				//선택된 페이지 번호를 hidden input에 반영
								const params = new URLSearchParams(new FormData(form)).toString();	//현재 검색 폼(form)의 모든 데이터(FormData)를 직렬화하여 쿼리스트링으로 변환

								//List fetch
								fetch("/cvplRcept/listAjax?" + params)
									.then(res => res.json())
									.then(data => {
										renderTable(data.cvplVOList, data.articlePage);		// 민원 리스트 렌더링
										renderPagination(data.articlePage);	// 페이지네이션 갱신
									})
									.catch(err => console.error("페이지 이동 오류:", err));
							}
						});
						// 백업용 페이지네이션 함수
						
						
						
				</script>
	<!--/////////////////////////////////////////////// 민원의 script 영역 ///////////////////////////////////////////////-->

	<!--/////////////////////////////////////////////// 결재관련 script영역 ///////////////////////////////////////////////-->
	<script>
	const elSection = document.querySelector("#elctrnsanctnSection");
	if (elSection) {
	    elSection.querySelectorAll(".elctrnsanctnRow").forEach(row => {
	        row.addEventListener("click", function () {
	            location.href = "/elctrnsanctn/getElctrnsanctn?elctrnsanctnSn="
	                + this.querySelector("#elctrnsanctnSn").value;
	        });
	    });
	}
	</script>	
	<!--/////////////////////////////////////////////// 결재관련 script영역끝 ///////////////////////////////////////////////-->



	<!--/////////////////////////////////////////////// 채팅 script영역시작 ///////////////////////////////////////////////-->
<script>
//버튼으로 최소화 처리
function handleClick(){
	document.querySelector("#chatBox").style.display="none";
}
/* function handleClick2(){
	document.querySelector("#chatBox").style.display="block";
} */
document.addEventListener("DOMContentLoaded",function(){
    let chatWindow = null;  // 빈 객체
   const chatUrl = "/chat";
   const messageBtn = document.querySelector(".chatBtn");
   const messageBox = document.getElementById("chatBox");
    const dragHandle = document.getElementById("dragHandle");
   messageBtn.addEventListener("click",function(){  //메신저 버튼을 클릭하면
     //토글이용 : 열려 있으면 닫기, 닫혀 있으면 열기
     if(messageBox.style.display=="none" || messageBox.style.display==""){
    	 messageBox.style.display="block";
     if(!messageBox.style.left || messageBox.style.left=="auto"){
    	 messageBox.style.left = (window.innerWidth - 450) + "px";
         messageBox.style.top = (window.innerHeight - 730) + "px";
     }	     	 
     }else{
    	 messageBox.style.display="none";
     }
     const iframe = document.getElementById("chatFrame");
     
     if(!iframe.src) iframe.src  = chatUrl;
     document.getElementById("chatBox").style.display="block";     
   }); //메신저 버튼 
   //채팅창 위치 옮기기 위해
   let possibledrag = false, offsetX = 0, offsetY=0;   //offsetX : 가로,  offsetY: 세로
   let pending = false;
   dragHandle.addEventListener("mousedown",(e)=>{  //마우스 버튼을 누르면
      if(e.target.tagName !== "IFRAME"){   //채팅창 테두리 또는 배경 클릭 시에만 드래그 가능하게 함
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
    document.addEventListener("mousemove",(e)=>{  //마우스가 움직일때마다
       if(!possibledrag || pending) return;
        pending = true;
        messageBox.classList.remove("dragging");
        
        requestAnimationFrame(()=>{
         messageBox.style.left = (e.clientX - offsetX) + "px";
         messageBox.style.top = (e.clientY - offsetY) + "px";
         pending=false;
        });
      });
       document.addEventListener("mouseup",()=>{  //마우스 버튼 클릭을 떼면
         possibledrag=false;
       })        
}); //전체 끝


window.addEventListener("message",(event)=>{
  const box = document.querySelector("#chatBox");

  if(event.data.action=="closeChat"){  //chat.jsp로부터 상태값 받음
	  console.log("message event:", event.data);
      box.style.display="none";
   }  
  
   if(event.data.action=="openChat"){
	   box.style.display="block";
   }
  
});
</script>
<!--/////////////////////////////////////////////// 채팅 script영역끝 ///////////////////////////////////////////////-->











	<!-- <script src="/js/jquery-3.6.0.js"></script> -->
	<!-- footer.jsp에서 jquery호출해서 중복호출되고있어서 주석처리했습니다. -->
	<!-- 캘린더 사용 -->
	<script
		src='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.19/index.min.js'></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.19/index.global.min.js"></script>
	<!-- 캘린더 사용끝 -->
	<!-- 민원에서 사용 -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script
		src="https://cdn.ckeditor.com/ckeditor5/41.2.0/classic/ckeditor.js"></script>
	<!-- 민원에서 사용끝 -->