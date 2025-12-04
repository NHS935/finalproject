<!-- JPS로 출력하는거. (미완성이니까 참고만) -->
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>
<!-- /// header 끝 /// -->
<!-- 섹션/컨테이너 영역 시작 -->
<section class="content" style="margin: 20px">
	<div class="container-fluid"><!-- 섹션/컨테이너 영역 -->
		<div class="row">
			<div class="col-md-12">



				<!-- 카드 시작 -->
				<div class="card card bg-light">
				<!-- 카드헤더 시작 -->
					<div class="card-header d-flex justify-content-between align-items-center">
						<!-- 좌 제목 -->
						<h5 class="card-title mb-0">투표 목록</h5>
						<!-- 우 검색 -->
						<div class="search-area ml-auto d-flex">
							<form id="frm" name="frm" action="/vote/voteMtr" method="get"
								class="form-inline">
								<!-- 초기화 -->
								<input type="hidden" name="currentPage" value="1" />

								<!-- 키워드 -->
								<label class="mr-2 mb-0"> <input type="search"
									name="keyword" class="form-control form-control-sm"
									placeholder="검색어(제목/내용)" value="${fn:escapeXml(param.keyword)}" />
								</label>

								<!-- 기간 -->
								<label class="mr-2 mb-0"> <input type="date"
									name="periodFrom" class="form-control form-control-sm"
									value="${param.periodFrom}" />
								</label> <span class="mr-2">~</span> <label class="mr-2 mb-0"> <input
									type="date" name="periodTo"
									class="form-control form-control-sm" value="${param.periodTo}" />
								</label>

								<!-- 상태 -->
								<label class="mr-2 mb-0"> <select name="stat"
									class="form-control form-control-sm">
										<option value="" ${empty param.stat ? 'selected' : ''}>전체</option>
										<option value="진행중" ${param.stat eq '진행중' ? 'selected' : ''}>진행중</option>
										<option value="예정" ${param.stat eq '예정'   ? 'selected' : ''}>예정</option>
										<option value="마감" ${param.stat eq '마감'   ? 'selected' : ''}>마감</option>
								</select>
								</label>

								<!-- 검색 / 초기화 -->
								<button type="submit" class="btn btn-info btn-sm mr-2">검색</button>
								<a href="/vote/voteMtr" class="btn btn-default btn-sm">초기화</a>

							</form>
						</div>
					</div>
					<!-- 카드헤더 끝 -->


					<!-- 카드바디 시작 -->
					<div class="card-body">
						<table class="table tight-table"
							style="border-collapse: collapse; border: none; width: 100%;">
							<thead>
								<tr>
									<th style="width: 10%; text-align: center;">순번</th>
									<th>제목</th>
									<th style="width: 10%; text-align: center;">투표 시작일시</th>
									<th style="width: 10%; text-align: center;">투표 마감일시</th>
									<th style="width: 10%; text-align: center;">등록자</th>
									<th style="width: 10%; text-align: center;">상태</th>
								</tr>
							</thead>
							<tbody>


								<c:forEach var="p" items="${articlePage.content}" varStatus="stat">
									<tr>
										<td style="text-align: center;"><a style="color:black;" href="/vote/voteDetail?voteMtrSn=${p.voteMtrSn}">${(articlePage.currentPage-1) * 15 + stat.count}</a></td>
										<td><a href="/vote/voteDetail?voteMtrSn=${p.voteMtrSn}" style="color:black;"><c:out
													value="${p.mtrSj}" /></a></td>
										<td class="small text-muted mt-1" style="text-align: center;"><img
											src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
											alt="시계 아이콘">${fn:substring(p.voteBeginDt, 0, 10)}</td>
										<td class="small text-muted mt-1" style="text-align: center;"><img
											src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
											alt="시계 아이콘">${fn:substring(p.voteEndDt, 0, 10)}</td>
										<td style="text-align: center;"><c:out value="${p.nm}" />
										</td>
										<td style="text-align: center;">
											<!-- 상태 별 색 추가 업데이트 2025-11-01 --> <c:choose>
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
					<!-- 카드바디 끝 -->
					
					
					<div class="card-footer d-flex justify-content-between align-items-center">
					    <!-- 중앙 페이징 -->
					    <div class="flex-grow-1 text-center">
					        ${articlePage.pagingArea}
					    </div>
					    <!-- 오른쪽 등록 버튼 -->
					    <div>
					        <a href="/vote/addVotePage" class="btn btn-info btn-sm mr-3">등록</a>
					    </div>
					</div>
				</div>
				<!-- 카드 끝 -->
				
				
			</div>
		</div>
	</div><!-- 섹션/컨테이너 영역 끝 -->
</section>
<!-- 섹션/컨테이너 영역 끝 -->

<!-- /// body 끝 /// -->
<!-- /// footer 시작  -->
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->




<style>
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
    background-color: rgba(255, 106, 0, 0.8); /* 디편한 시그니쳐 주황 색상 */
}
/* 공통 바로가기 버튼 끝 */
/*=================== 위는 이 페이지에서 사용하지 않아요=================*/
body {	/* 폰트 */
  font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}
/* 공통 카드별 상단 영역 시작 */
.card {
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}
.card-header{
	background-color: rgba(193, 179, 180, 0.5);
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
  background-color: #f1f1f1; /* 연한 회색(AdminLTE 느낌) */
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
</style>
