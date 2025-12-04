<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>
<!-- /// header 끝 /// -->


<div class="mypage-wrap">


	<c:if test="${empty hshldDetailVO}">
		<div class="alert alert-warning">조회된 세대 정보가 없습니다.</div>
	</c:if>

	<c:if test="${not empty hshldDetailVO}">

		<c:set var="vo" value="${hshldDetailVO[0]}" />

		<div class="card">
			<div
				class="card-header d-flex justify-content-between align-items-center">
				<div>
					<h5 class="card-title mb-0 mr-3">입주민 정보</h5>
					<small class="text-muted "> <span class="mypage-badge">
							동: ${vo.aptcmpl} / 호: ${vo.ho} </span>
					</small>
				</div>

			</div>

			<div class="card-body">
				<div class="row">
					<!-- 세대 기본 정보 -->
					<div class="col-md-4 mb-3 mb-md-0">


						<ul class="list-group list-group-flush">
							<li class="list-group-item px-0 py-1"><strong>주소</strong><br>
								<span class="text-muted">${vo.adres}</span></li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>동 / 호</strong></span> <span class="text-muted">${vo.aptcmpl}동&nbsp;${vo.ho}호</span>
							</li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>전용면적</strong></span> <span class="text-muted">${vo.prvuseAr}</span>
							</li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>공급면적</strong></span> <span class="text-muted">${vo.suplyAr}</span>
							</li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>입주일</strong></span> <span class="text-muted"><img
									src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
									alt="시계 아이콘" style="width: 20px; vertical-align: middle;">${vo.mvnDe}</span>
							</li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>퇴거일</strong></span> <span class="text-muted">
									<c:choose>
										<c:when test="${empty vo.lvhsDe}">
      -
    </c:when>
										<c:otherwise>
											<td class="text-muted"><img
												src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
												alt="시계 아이콘" style="width: 20px; vertical-align: middle;">${vo.lvhsDe}
										</c:otherwise>
									</c:choose>
							</span>
							</li>
							<li
								class="list-group-item px-0 py-1 d-flex justify-content-between">
								<span><strong>거주상태</strong></span> <span class="text-muted">
									<c:choose>
										<c:when test="${vo.residesttus == 1}">거주중</c:when>
										<c:when test="${vo.residesttus == 2}">퇴거</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
							</span>
							</li>
						</ul>
						<hr />
						<div class="mb-3">
							<div class="mypage-left-title mb-1">세대 특이사항</div>
							<textarea class="form-control special-note-box" rows="3"
								style="width: 100%; height: 200px; color: red;" readonly>
<c:if test="${vo.hshldId == '11020101'}">연세 많으신 아버님이 혼자 살고계십니다.
특이사항 발생 시 꼭 방문해서 도와주시기 바랍니다.</c:if>
        						</textarea>
						</div>
					</div>

					<!-- 입주민 목록 테이블 -->
					<div class="col-md-8">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<div class="mypage-left-title mb-0">입주민 목록</div>
							<!-- 우리 아파트는 1주택 1입주자 원칙이지만, 혹시모르니 만들었다. -->
							<small class="text-muted">총 ${fn:length(hshldDetailVO)}명</small>
						</div>

						<div class="table-responsive">
							<table class="table tight-table mb-0">
								<thead>
									<tr style="background: #f1f1f1;">
										<th>#</th>
										<th>ID</th>
										<th>이름</th>
										<th>연락처</th>
										<th>이메일</th>
										<th>구분</th>
										<th>사용여부</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="vo" items="${hshldDetailVO}" varStatus="stat">
										<tr>
											<td>${stat.count}</td>
											<td>${vo.mberId}</td>
											<td>${vo.mberNm}</td>
											<td>${vo.telno}</td>
											<td>${vo.email}</td>
											<td><c:choose>
													<c:when test="${vo.mberTy == '0'}">
														<span class="badge badge-info">임대</span>
													</c:when>
													<c:when test="${vo.mberTy == '1'}">
														<span class="badge badge-success">자가</span>
													</c:when>
													<c:when test="${vo.mberTy == '2'}">
														<span class="badge badge-warning">임차</span>
													</c:when>
													<c:otherwise>
														<span class="badge badge-secondary">${vo.mberTy}</span>
													</c:otherwise>
												</c:choose></td>
											<td><c:choose>
													<c:when test="${vo.enabled == '1' || vo.enabled == 1}">
														<span class="badge badge-primary">회원</span>
													</c:when>
													<c:otherwise>
														<span class="badge badge-secondary">미사용</span>
													</c:otherwise>
												</c:choose></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>

					</div>
				</div>
			</div>

			<div class="card-footer text-right">
				<a href="/mber/hshldList" class="btn btn-sm btn-secondary">목록으로</a>
				<c:forEach var="vo" items="${hshldDetailVO}">
					<a href="/mtinsp/mtinspView?hshldId=${vo.hshldId}"
						class="btn btn-sm btn-success">검침 보기</a>
				</c:forEach>
			</div>
		</div>
	</c:if>

</div>

<!-- /// footer 시작  -->
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->



<style>
body { /* 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}

/* 마이페이지 느낌 레이아웃 */
.mypage-wrap {
	max-width: 1100px;
	margin: 3rem auto;
	transform: scale(1.1)
}
/* 공통 카드별 상단 영역 시작 */
.card {
	min-height: 500px;
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

.card-header {
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
	min-height: 520px;
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

/* 왼쪽 프로필/세대 정보 박스 */
.mypage-left-title {
	font-size: 1rem;
	font-weight: 600;
	margin-bottom: .5rem;
}

.mypage-badge {
	display: inline-block;
	padding: .15rem .5rem;
	border-radius: 999px;
	font-size: .75rem;
	background: rgba(100, 140, 164, 0.12);
	color: #445a6f;
}
</style>
