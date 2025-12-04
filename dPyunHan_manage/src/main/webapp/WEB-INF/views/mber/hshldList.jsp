<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>
<!-- /// header 끝 /// -->


<!-- ///// content 시작 ///// -->
<section class="content">
	<div class="container-fluid">

		<!-- 상단 타이틀·요약 -->
		<div class="row mb-2">
			<div class="col-12 d-flex justify-content-between align-items-end">
			</div>
		</div>

		<!-- 목록 카드 -->
		<div class="row">
			<div class="col-12">
				<div class="card">

					<!-- 카드 헤더 -->
					<div
						class="card-header d-flex justify-content-between align-items-center">
						<!-- 좌측 제목 -->
						<h3 class="card-title mb-0" style="font-size: 1.1rem;">
							세대 · 입주민 목록 <span class="badge badge-secondary"> 입주민 : <strong>${articlePage.total}</strong>
								명
							</span>
						</h3>
					</div>
					<!-- 카드 바디 -->
					<div class="card-body p-2">
						<div class="table-responsive">
							<table class="table table-hover table-striped tight-table mb-0"
								style="border-collapse: collapse; width: 100%;">
								<thead>
									<tr class="bg-light">
										<th style="width: 40px;">순번</th>
										<th>동</th>
										<th>호</th>
										<th>입주민 ID</th>
										<th>입주민명</th>
										<th>연락처</th>
										<th>이메일</th>
										<th>구분</th>
										<th>사용여부</th>
										<th>세대 ID</th>
										<th>거주상태</th>
										<th>입주일</th>
										<th>퇴거일</th>
									</tr>
								</thead>

								<tbody>
									<c:forEach var="vo" items="${hshldListVO}" varStatus="stat">
										<tr class="hshld-row"
											data-href="${pageContext.request.contextPath}/mber/hshldDetail?hshldId=${vo.hshldId}">
											<!-- 순번 -->
											<td>${stat.count}</td>

											<!-- 동 / 호  -->
											<td>${vo.aptcmpl}</td>
											<td>${vo.ho}</td>

											<!-- 입주민 정보 -->
											<td>${vo.mberId}</td>
											<td>${vo.mberNm}</td>
											<td>${vo.telno}</td>
											<td>${vo.email}</td>

											<!-- 구분 (0 임대, 1 자가, 2 임차) -->
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

											<!-- ENABLED -->
											<td><c:choose>
													<c:when test="${vo.enabled == '1' || vo.enabled == 1}">
														<span class="badge badge-primary">회원</span>
													</c:when>
													<c:otherwise>
														<span class="badge badge-secondary">미사용</span>
													</c:otherwise>
												</c:choose></td>

											<!-- 주소 / 세대ID / 거주상태 -->
											<td>${vo.hshldId}</td>
											<td><c:choose>
													<c:when test="${vo.residesttus == 1}">거주중</c:when>
													<c:when test="${vo.residesttus == 2}">퇴거</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose></td>

											<!-- 입주일 -->
											<td><c:choose>
													<c:when test="${empty vo.mvnDe}">
                            -
                          </c:when>
													<c:otherwise>
														<img
															src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
															alt="시계 아이콘" style="width: 20px; vertical-align: middle;">${vo.mvnDe}
                          </c:otherwise>
												</c:choose></td>

											<!-- 퇴거일 -->
											<td><c:choose>
													<c:when test="${empty vo.lvhsDe}">
                            -
                          </c:when>
													<c:otherwise>
														<img
															src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png"
															alt="시계 아이콘" style="width: 20px; vertical-align: middle;">${vo.lvhsDe}
                          </c:otherwise>
												</c:choose></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

					<!-- 카드 푸터 -->
					<div class="card-footer py-2 text-right">
						<small class="text-muted">
							<div
								class="card-footer d-flex justify-content-between align-items-center">
								<!-- 중앙 페이징 -->
								<div class="flex-grow-1 text-center">
									${articlePage.pagingArea}</div>
							</div>
						</small>
					</div>

				</div>
			</div>
		</div>

	</div>
</section>
<!-- ///// content 끝 ///// -->


<!-- /// footer 시작  -->
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->


<style>
/* 공통 카드별 상단 영역 시작 */

/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 */
.tight-table, .tight-table th, .tight-table td {
	padding: 3px 5px !important; /* 행간 줄이기 */
	overflow: hidden !important; /* 삐져나가는 것 숨김 */
	text-overflow: ellipsis; /* ... 처리 */
	white-space: nowrap; /* 줄바꿈 X */
	text-align: center;
}

/* 줄무늬 효과 */
.tight-table tbody tr:nth-child(odd) {
	background-color: #ffffff;
}

.tight-table tbody tr:nth-child(even) {
	background-color: #f1f4fa;
}

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
</style>
<!-- 행클릭시 이동 이벤트 -->
<script>
	document.addEventListener('DOMContentLoaded', function() {
		const rows = document.querySelectorAll('.hshld-row');
		rows.forEach(function(row) {
			row.addEventListener('click', function() {
				const url = this.dataset.href;
				if (url) {
					window.location.href = url;
				}
			});
		});
	});
</script>