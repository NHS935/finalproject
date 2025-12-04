<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title></title>
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

					<script type="text/javascript">
						document.addEventListener("DOMContentLoaded", function () {
							const checkAll = document.getElementById("checkAll");
							const fileChecks = document.querySelectorAll(".fileCheck");

							checkAll.addEventListener("change", function () {
								fileChecks.forEach(chk => chk.checked = checkAll.checked);
							});

							// 선택 다운로드
							document.getElementById("downloadSelectedBtn").addEventListener("click", function () {
								const selectedFiles = Array.from(document.querySelectorAll(".fileCheck:checked"));

								if (selectedFiles.length === 0) {
									alert("다운로드할 파일을 선택해주세요.");
									return;
								}

								const form = document.createElement("form");
								form.method = "POST";
								form.action = "/bidPblanc/downloadSelected";

								selectedFiles.forEach(checkbox => {
									const listItem = checkbox.closest("a");
									const fileGroupSn = listItem.getAttribute("data-file-group-sn");
									const fileNo = listItem.getAttribute("data-file-no");

									const groupInput = document.createElement("input");
									groupInput.type = "hidden";
									groupInput.name = "fileGroupSnList";
									groupInput.value = fileGroupSn;
									form.appendChild(groupInput);

									const noInput = document.createElement("input");
									noInput.type = "hidden";
									noInput.name = "fileNoList";
									noInput.value = fileNo;
									form.appendChild(noInput);
								});

								document.body.appendChild(form);
								form.submit();
							});

							// 전체 다운로드
							document.getElementById("downloadAllBtn").addEventListener("click", function () {
								const firstFile = document.querySelector("a[data-file-group-sn]");
								if (firstFile) {
									const fileGroupSn = firstFile.getAttribute("data-file-group-sn");
									window.location.href = "/bidPblanc/downloadAll?fileGroupSn=" + fileGroupSn;
								}
							});
						});
					</script>
				</head>

				<body>

					<body class="layout-boxed">
						<div class="wrapper">
							<%@ include file="./include/header.jsp" %>

								<!-- /// body /// -->
								<div class="card card-primary">
									<div class="bg-lightblue card-header">
										<h3 class="card-title">
											입찰 공고 상세
											<c:choose>
												<c:when test="${bidPblancVO.bidSttus==2}">
													<span class="badge badge-danger ml-2" style="font-size: large;">
														선정 완료</span>
												</c:when>
												<c:otherwise>
													<c:if test="${hasAlreadyBid}">
														<span class="badge badge-danger ml-2" style="font-size: large;">
															입찰 완료</span>
													</c:if>
												</c:otherwise>
											</c:choose>
										</h3>
									</div>
									<!-- /.card-header -->
									<div class="card-body">
										<table class="table table-bordered">
											<tbody>
												<tr>
													<th class="bg-light col-2 text-center">입찰번호</th>
													<td colspan="3">${bidPblancVO.bidPblancSnAsStr}</td>
												</tr>
												<tr>
													<th class="bg-light col-2 text-center">입찰제목</th>
													<td colspan="3">${bidPblancVO.bidSj}</td>
												</tr>
												<tr>
													<th class="bg-light col-2 text-center">낙찰방법</th>
													<td class="col-4">${bidPblancVO.scsbMthAsStr}</td>
													<th class="bg-light col-2 text-center">보증금률</th>
													<td class="col-4">
														<span>
															${bidPblancVO.bidGtnRt}
														</span>
														<span class="ml-1" style="color:gray; font-size: smaller;">
															(입찰가격의[${bidPblancVO.bidGtnRt}]%이상 제출)</span>
													</td>
												</tr>
												<tr>
													<th class="bg-light col-2 text-center">공고 시작일</th>
													<td>
														<fmt:formatDate value="${bidPblancVO.pblancDt}"
															pattern="yyyy-MM-dd" />
													</td>
													<th class="bg-light col-2 text-center">입찰 마감일</th>
													<td>
														<fmt:formatDate value="${bidPblancVO.bidClosDtAsDate}"
															pattern="yyyy-MM-dd" />
													</td>
												</tr>
												<tr>
													<th class="bg-light col-2 text-center">필수 제출 서류</th>
													<td colspan="3">
														<div class="d-flex justify-content">
															<div class="custom-control custom-checkbox">
																<input
																	class="custom-control-input custom-control-input-primary"
																	type="checkbox" id="cdltPresentnAt" <c:if
																	test="${bidPblancVO.cdltPresentnAt == 1}">checked
																</c:if>
																disabled>
																<label for="cdltPresentnAt"
																	class="custom-control-label">
																	신용평가등급확인서
																</label>
															</div>

															<div class="custom-control custom-checkbox ml-2">
																<input
																	class="custom-control-input custom-control-input-primary"
																	type="checkbox" id="acmsltproofPresentnAt" <c:if
																	test="${bidPblancVO.acmsltproofPresentnAt == 1}">checked
																</c:if>
																disabled>
																<label for="acmsltproofPresentnAt"
																	class="custom-control-label">
																	관리실적증명서
																</label>
															</div>
														</div>
													</td>
												</tr>
												<tr>
													<th class="bg-light col-2 text-center">현장설명</th>
													<td colspan="3">${bidPblancVO.sptdcAtAsStr}</td>
												</tr>
												<c:if test="${bidPblancVO.sptdcAt == 1}">
													<tr>
														<th class="bg-light col-2 text-center">현장설명일시</th>
														<td>
															<fmt:formatDate value="${bidPblancVO.sptdcDtAsDate}"
																pattern="yyyy-MM-dd HH:mm" />
														</td>
														<th class="bg-light col-2 text-center">현장설명장소</th>
														<td>
															${bidPblancVO.sptdcPlace}
														</td>
													</tr>
												</c:if>
												<tr>
													<th class="bg-light col-2 text-center">내용</th>
													<td colspan="3">${bidPblancVO.bidCn}</td>
												</tr>

												<tr>
													<th class="bg-light col-2 text-center">첨부파일</th>
													<td colspan="3">
														<c:choose>
															<c:when test="${empty fileDetailVOList}">
																<p class="text-muted">첨부파일이 없습니다.</p>
															</c:when>
															<c:otherwise>
																<!-- 전체 선택 영역 -->
																<div
																	class="bg-light p-2 mb-2 d-flex align-items-center">
																	<input type="checkbox" id="checkAll" class="mr-2" />
																	<label for="checkAll" class="mb-0">전체선택</label>
																</div>

																<!-- 파일 목록 -->
																<div class="list-group">
																	<c:forEach var="file" items="${fileDetailVOList}">
																		<a href="/bidPblanc/download?fileGroupSn=${file.fileGroupSn}&fileNo=${file.fileNo}"
																			class="list-group-item list-group-item-action d-flex align-items-center"
																			data-file-group-sn="${file.fileGroupSn}"
																			data-file-no="${file.fileNo}"
																			target="_blank">
																			<input type="checkbox"
																				class="fileCheck mr-2"
																				value="${file.fileNo}"
																				onclick="event.stopPropagation();" />
																			<i class="fa fa-file mr-2"></i>
																			<span>${file.fileOrginlNm}</span>
																		</a>
																	</c:forEach>
																</div>
																<!-- 다운로드 버튼 -->
																<div class="mt-2">
																	<button id="downloadAllBtn"
																		class="btn btn-success btn-sm">전체
																		다운로드</button>
																	<button id="downloadSelectedBtn"
																		class="btn btn-warning btn-sm">선택 다운로드</button>
																</div>
															</c:otherwise>
														</c:choose>
													</td>
												</tr>
											</tbody>
										</table>
										<br>
										<c:if test="${hasAlreadyBid}">
											<div class="card card-info">
												<div class="card-header">
													<h3 class="card-title" style="font-weight: bold;">내 입찰 내역</h3>
												</div>
												<div class="card-body">
													<table class="table table-bordered table-info">
														<tr>
															<th class="col-2 text-center">입찰가</th>
															<td><strong>
																	<fmt:formatNumber value="${existingBid.bidAmount}"
																		type="currency" currencySymbol="₩" />
																</strong></td>
															<th class="col-2 text-center">보증금</th>
															<td><strong>
																	<fmt:formatNumber value="${existingBid.bidGtn}"
																		type="currency" currencySymbol="₩" />
																</strong></td>
														</tr>
														<tr>
															<th class="col-2 text-center">입찰 일시</th>
															<td>
																<fmt:formatDate value="${existingBid.bidSportDt}"
																	pattern="yyyy-MM-dd HH:mm:ss" />
															</td>
															<th class="col-2 text-center">입찰 상태</th>
															<td><span class="badge badge-warning"
																	style="font-size: large;">${existingBid.bidAtAsStr}</span>
															</td>
														</tr>
													</table>
												</div>
											</div>
										</c:if>
									</div>
									<!-- /.card-body -->
									<!-- card-footer-->
									<div class="card-footer d-flex justify-content-center">
										<c:choose>
											<c:when test="${bidPblancVO.bidSttus==2}">
												<a class="btn btn-secondary" href="/bidPblanc/getBidPblancList">목록</a>
											</c:when>
											<c:otherwise>
												<c:if test="${!hasAlreadyBid }">
													<a class="btn btn-primary mr-1"
														href="/bdder/postBdder?bidPblancSn=${bidPblancVO.bidPblancSn}">
														<i class="fa fa-check"></i> 입찰하기
													</a>
												</c:if>
												<a class="btn btn-secondary" href="/bidPblanc/getBidPblancList">목록</a>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<!-- card-footer-->
								<!-- /// body /// -->
						</div>

						<footer class="footer">
							<div class="float-right d-none d-sm-block">
								<b>Version</b> 3.2.0
							</div>
							<strong>Copyright © 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.
							</strong> All rights reserved.
						</footer>

					</body>

				</html>