<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title> </title>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<title></title>
					<!-- ========== 필수 CSS (순서 중요) ========== -->

					<!-- 1. Google Fonts -->
					<link rel="stylesheet"
						href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap">

					<!-- 2. Font Awesome (아이콘) -->
					<link rel="stylesheet" href="/adminlte/plugins/fontawesome-free/css/all.min.css">

					<!-- 3. iCheck Bootstrap (라디오 버튼) -->
					<link rel="stylesheet" href="/adminlte/plugins/icheck-bootstrap/icheck-bootstrap.min.css">

					<!-- 4. Daterangepicker CSS -->
					<link rel="stylesheet" href="/adminlte/plugins/daterangepicker/daterangepicker.css">

					<!-- 5. AdminLTE CSS (마지막) -->
					<link rel="stylesheet" href="/adminlte/dist/css/adminlte.min.css">

					<style>
						.fa-rotate-180 {
							transform: rotate(180deg) !important;
							transition: transform 0.3s ease;
						}

						/* HTML, Body 설정 */
						html,
						body {
							height: 100%;
							margin: 0;
							padding: 0;
						}

						/* Wrapper는 내용에 맞게, 최소 100vh */
						.wrapper {
							min-height: calc(100vh - 50px);
							display: flex;
							flex-direction: column;
						}

						/* Content 영역 */
						.content-area {
							flex: 1;
							padding: 20px;
						}

						/* Footer 항상 맨 아래 */
						.footer {
							height: 50px;
							background: #f8f9fa;
							border-top: 1px solid #dee2e6;
							display: flex;
							align-items: center;
							justify-content: space-between;
							padding: 0 15px;
							flex-shrink: 0;
							box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.05);
						}

						/* Footer 텍스트 스타일 */
						.footer strong,
						.footer div {
							white-space: nowrap;
							font-size: 0.875rem;
							margin: 0;
						}

						.footer .float-right {
							margin-left: auto;
						}

						/* 필터 레이블 스타일 */
						.filter-label {
							min-width: 90px;
							display: inline-block;
							font-weight: 500;
							color: #495057;
							margin-right: 10px;
							flex-shrink: 0;
						}

						hr.my-2 {
							margin: 0.5rem 0;
							border-top: 1px solid rgba(0, 0, 0, 0.1);
						}

						/* ==================== 헤더 전문 디자인 (심플 버전) ==================== */

						.content-header.bg-primary {
							background-color: #2c3e50 !important;
							padding: 20px 0;
							box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
							margin-bottom: 20px;
							border-bottom: 3px solid #3498db;
						}

						.content-header .container-fluid {
							padding: 0 20px;
						}

						/* 로고 + 타이틀 영역 */
						.content-header h1 {
							color: white;
							font-size: 1.5rem;
							font-weight: 600;
							margin: 0;
							display: flex;
							align-items: center;
							gap: 15px;
						}

						.content-header h1::before {
							content: '';
							display: inline-block;
							width: 45px;
							height: 45px;
							background: url('/images/logo2.png') center/contain no-repeat;
							background-color: white;
							border-radius: 8px;
							padding: 5px;
						}

						/* Breadcrumb 개선 */
						.breadcrumb {
							background-color: transparent;
							padding: 0;
							margin: 0;
						}

						.breadcrumb-item {
							font-size: 0.875rem;
						}

						.breadcrumb-item a {
							color: rgba(255, 255, 255, 0.85) !important;
							text-decoration: none;
							transition: all 0.2s ease;
							padding: 4px 8px;
							border-radius: 4px;
							font-weight: 500;
						}

						.breadcrumb-item a:hover {
							color: white !important;
							background: rgba(255, 255, 255, 0.1);
						}

						.breadcrumb-item+.breadcrumb-item::before {
							color: rgba(255, 255, 255, 0.5) !important;
							content: "›";
							font-size: 1.1rem;
							padding: 0 6px;
						}

						.breadcrumb-item.active {
							color: white;
							font-weight: 500;
						}

						/* 반응형 */
						@media (max-width: 768px) {
							.content-header h1 {
								font-size: 1.25rem;
							}

							.content-header h1::before {
								width: 35px;
								height: 35px;
							}
						}

						.sort-label {
							min-width: 50px;
							/* 레이블 최소 너비 */
							display: inline-block;
							font-weight: 500;
							color: white;
							margin-right: 5px;
							flex-shrink: 0;
							/* 레이블이 줄어들지 않도록 */
						}
					</style>


					<!-- ========== 필수 JavaScript (순서 중요) ========== -->

					<!-- 1. jQuery -->
					<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

					<!-- 2. Bootstrap Bundle (Popper 포함) -->
					<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

					<!-- 3. Moment.js (daterangepicker 의존성) -->
					<script src="/adminlte/plugins/moment/moment.min.js"></script>

					<!-- 4. Daterangepicker -->
					<script src="/adminlte/plugins/daterangepicker/daterangepicker.js"></script>

					<!-- 5. AdminLTE App -->
					<script src="/adminlte/dist/js/adminlte.min.js"></script>

					<script>
						document.addEventListener("DOMContentLoaded", function () {
							document.querySelectorAll(".bdderVORow").forEach(row => {
								row.addEventListener("click", function () {
									const bdderSn = this.querySelector("#bdderSn").value;
									location.href = ""
								})
							});
						});
					</script>
				</head>


				<body class="layout-boxed">
					<div class="wrapper">
						<%@ include file="../bidPblanc/include/header.jsp" %>
							<!-- 필터 폼 시작 -->
							<div class="card p-0 mb-2">
								<!-- ./card-header -->
								<table class="table table-bordered table-hover m-0">
									<tbody>
										<tr class="bg-lightblue disabled" data-widget="expandable-table"
											aria-expanded="false">
											<td class="d-flex justify-content-between">
												<div class="ml-2">
													<b>검색 필터</b>
												</div>
												<div>
													<span class="mr-2">설정</span><i class="fas fa-chevron-up"></i>
												</div>
											</td>
										</tr>
										<tr class="expandable-body d-none p-0">
											<td class="p-3">
												<form id="searchForm" method="get" action="/bidPblanc/getBidPblancList">
													<input type="hidden" id="startDate" name="startDate" />
													<input type="hidden" id="endDate" name="endDate" />

													<div class="d-flex justify-content p-1 pl-3 pr-3">
														<!-- 제목 + 분류 -->
														<div class="col-4 m-0">
															<!-- 입찰 상태 (bidSttus) -->
															<div class="d-flex align-items-center m-2">
																<span class="filter-label">입찰상태</span>
																<div class="d-flex flex-wrap">
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="bidSttus0" name="bidSttus" value="0"
																			checked>
																		<label for="bidSttus0"
																			class="custom-control-label small">신규공고</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="bidSttus1" name="bidSttus" value="1">
																		<label for="bidSttus1"
																			class="custom-control-label small">재공고</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="bidSttus2" name="bidSttus" value="2">
																		<label for="bidSttus2"
																			class="custom-control-label small">선정완료</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="bidSttusAll" name="bidSttus" value="">
																		<label for="bidSttusAll"
																			class="custom-control-label small">전체</label>
																	</div>
																</div>
															</div>

															<hr class="my-2">

															<!-- 입찰 제목 (bidSj) -->
															<div class="d-flex align-items-center m-2">
																<span class="filter-label">제목</span>
																<input type="text" id="keyword" name="keyword"
																	class="form-control" placeholder="제목 입력">
															</div>
														</div>

														<!-- 낙찰방법 + 필수제출서류 -->
														<div class="col-4 m-0">
															<!-- 낙찰방법 (scsbMth) -->
															<div class="d-flex align-items-center m-2">
																<span class="filter-label">낙찰방법</span>
																<div class="d-flex flex-wrap">
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="scsbMth0" name="scsbMth" value="0"
																			checked>
																		<label for="scsbMth0"
																			class="custom-control-label small">적격심사</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="scsbMth1" name="scsbMth" value="1">
																		<label for="scsbMth1"
																			class="custom-control-label small">최저낙찰</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="scsbMth2" name="scsbMth" value="2">
																		<label for="scsbMth2"
																			class="custom-control-label small">최고낙찰</label>
																	</div>
																	<div class="custom-control custom-radio mr-2">
																		<input class="custom-control-input" type="radio"
																			id="scsbMthAll" name="scsbMth" value="">
																		<label for="scsbMthAll"
																			class="custom-control-label small">전체</label>
																	</div>
																</div>
															</div>

															<hr class="my-2">

															<!-- 필수제출서류 -->
															<div class="d-flex align-items-center m-2">
																<span class="filter-label">필수제출서류</span>
																<div class="custom-control custom-checkbox mr-2">
																	<input class="custom-control-input" type="checkbox"
																		id="cdltPresentnAt" name="cdltPresentnAt"
																		value="1">
																	<label for="cdltPresentnAt"
																		class="custom-control-label small">신용평가등급확인서</label>
																</div>
																<div class="custom-control custom-checkbox">
																	<input class="custom-control-input" type="checkbox"
																		id="acmsltproofPresentnAt"
																		name="acmsltproofPresentnAt" value="1">
																	<label for="acmsltproofPresentnAt"
																		class="custom-control-label small">관리실적증명서</label>
																</div>
															</div>
														</div>

														<!-- 검색일자 기준 + 조회기간 -->
														<div class="col-4 m-0">
															<!-- 검색일자 기준 -->
															<div class="d-flex align-items-center m-2">
																<span class="filter-label">검색일자</span>
																<div class="custom-control custom-radio mr-2">
																	<input class="custom-control-input" type="radio"
																		id="dateTypePblanc" name="dateType"
																		value="pblancDt" checked>
																	<label for="dateTypePblanc"
																		class="custom-control-label small">공고시작일</label>
																</div>
																<div class="custom-control custom-radio">
																	<input class="custom-control-input" type="radio"
																		id="dateTypeClos" name="dateType"
																		value="bidClosDt">
																	<label for="dateTypeClos"
																		class="custom-control-label small">입찰마감일</label>
																</div>
															</div>

															<hr class="my-2">

															<!-- 조회기간 -->
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
														<button type="button" class="btn btn-secondary mr-2"
															id="resetBtn">초기화</button>
														<button type="submit" class="btn btn-warning">검색</button>
													</div>
												</form>
											</td>
										</tr>
									</tbody>
								</table>
								<!-- /.card-body -->
							</div>

							<!--필터 검색 폼 끝-->
							<div class="card">
								<div class="card-header bg-lightblue">
									<h3 class="card-title">참여중인 입찰 목록</h3>
								</div>
								<!-- /.card-header -->
								<div class="card-body">
									<table class="table table-bordered table-hover text-center">
										<thead>
											<tr>
												<th>순번</th>
												<th>입찰제목</th>
												<th>입찰가액</th>
												<th>입찰보증금</th>
												<th>입찰일시</th>
												<th>입찰마감일</th>
												<th>입찰여부</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="bdderVO" items="${articlePage.content }">
												<tr class="bdderVORow" style="cursor: pointer;">
													<td>${bdderVO.rnum }
														<input type="hidden" id="bdderSn" value="${bdderVO.bdderSn}" />
													</td>
													<td>${bdderVO.bidPblancVO.bidSj}</td>
													<td>
														<fmt:formatNumber value="${bdderVO.bidAmount }"
															pattern="#,### 원">
														</fmt:formatNumber>
													</td>
													<td>
														<fmt:formatNumber value="${bdderVO.bidGtn }" pattern="#,### 원">
														</fmt:formatNumber>
													</td>
													<td>
														<fmt:formatDate value="${bdderVO.bidSportDt }"
															pattern="yyyy-MM-dd HH:mm" />
													</td>
													<td>
														<fmt:formatDate value="${bdderVO.bidPblancVO.bidClosDtAsDate }"
															pattern="yyyy-MM-dd HH:mm" />
													</td>
													<td>
														<c:choose>
															<c:when test="${bdderVO.bidAt==2}">
																<span class="badge badge-danger"
																	style="font-size: 0.9rem">${bdderVO.bidAtAsStr
																	}</span>
															</c:when>
															<c:when test="${bdderVO.bidAt==1}">
																<span class="badge badge-success"
																	style="font-size: 0.9rem">${bdderVO.bidAtAsStr
																	}</span>
															</c:when>
															<c:otherwise>
																<span class="badge badge-info"
																	style="font-size: 0.9rem">${bdderVO.bidAtAsStr
																	}</span>
															</c:otherwise>
														</c:choose>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								<!-- /.card-body -->
								${articlePage.pagingAreaBorderedTable}
							</div>
							<footer class="footer">
								<div class="float-right d-none d-sm-block">
									<b>Version</b> 3.2.0
								</div>
								<strong>Copyright © 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.
								</strong> All rights reserved.
							</footer>

					</div>
				</body>

				</html>