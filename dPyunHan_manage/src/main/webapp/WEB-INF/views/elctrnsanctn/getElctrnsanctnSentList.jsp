<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title>전자결재 목록</title>
				</head>

				<style>
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

				<script>
					document.addEventListener("DOMContentLoaded", function () {
						document.querySelectorAll(".elctrnsanctnRow").forEach(row => {
							row.addEventListener("click", function () {
								const elctrnsanctnSn = this.querySelector("#elctrnsanctnSn").value;
								location.href = "/elctrnsanctn/getElctrnsanctn?elctrnsanctnSn=" + elctrnsanctnSn;
							});
						});

						document.querySelectorAll(".elctrnsanctnRcptRow").forEach(row => {
							row.addEventListener("click", function () {
								const elctrnsanctnSn = this.querySelector("#elctrnsanctnSn").value;
								location.href = "/elctrnsanctn/getElctrnsanctnRcpt?elctrnsanctnSn=" + elctrnsanctnSn;
							})
						})

						//검색 폼
						//애니메이션
						const expandableTable = document.querySelector("[data-widget='expandable-table']");
						const expandIcon = expandableTable.querySelector("i");

						expandableTable.addEventListener("click", function () {
							expandIcon.classList.toggle("fa-rotate-180");
						});

						// daterangepicker
						$(function () {
							$('#daterange-btn').daterangepicker({
								ranges: {
									'최근 7일': [moment().subtract(6, 'days'), moment()],
									'최근 30일': [moment().subtract(29, 'days'), moment()],
									'최근 90일': [moment().subtract(89, 'days'), moment()]
								},
								startDate: moment().subtract(29, 'days'),
								endDate: moment(),
								locale: {
									format: 'YYYY-MM-DD',
									applyLabel: '적용',
									cancelLabel: '취소',
									customRangeLabel: '기간 직접 선택'

								}
							}, function (start, end, label) {
								$('#daterange-btn').html(
									'<i class="far fa-calendar-alt"></i> ' + start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD') +
									' <i class="fas fa-caret-down"></i>'
								);

								$('#startDate').val(start.format('YYYY-MM-DD'));
								$('#endDate').val(end.format('YYYY-MM-DD'));
							});
						});
						//검색 폼

					});
				</script>

				<body>
					<%@ include file="../include/header.jsp" %>
						<!--/// body /// -->

						<!-- 필터 폼 시작 -->
						<div class="card p-0 mb-2">
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

													<hr class="my-2">

													<!-- 분류 -->
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">분류</span>
														<div class="d-flex flex-wrap">
															<div class="custom-control custom-radio mr-2">
																<input class="custom-control-input" type="radio"
																	id="category1" name="category" value="new" checked>
																<label for="category1"
																	class="custom-control-label small">상신완료</label>
															</div>
															<div class="custom-control custom-radio mr-2">
																<input class="custom-control-input" type="radio"
																	id="category2" name="category" value="re">
																<label for="category2"
																	class="custom-control-label small">임시저장</label>
															</div>
														</div>
													</div>
												</div>

												<!-- 결재자 + 결재상태 -->
												<div class="col-4 m-0">
													<!-- 결재자 -->
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">결재자</span>
														<input type="text" class="form-control"
															placeholder="이름 입력">
													</div>

													<hr class="my-2">

													<!-- 결재상태 -->
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">결재상태</span>
														<div class="d-flex flex-wrap">
															<div class="custom-control custom-radio mr-2">
																<input class="custom-control-input" type="radio"
																	id="method1" name="method" value="qualified"
																	checked>
																<label for="method1"
																	class="custom-control-label small">진행중</label>
															</div>
															<div class="custom-control custom-radio mr-2">
																<input class="custom-control-input" type="radio"
																	id="method2" name="method" value="highest">
																<label for="method2"
																	class="custom-control-label small">대기</label>
															</div>
															<div class="custom-control custom-radio mr-2">
																<input class="custom-control-input" type="radio"
																	id="method3" name="method" value="lowest">
																<label for="method3"
																	class="custom-control-label small">승인완료</label>
															</div>
															<div class="custom-control custom-radio">
																<input class="custom-control-input" type="radio"
																	id="method3" name="method" value="lowest">
																<label for="method3"
																	class="custom-control-label small">반려</label>
															</div>
														</div>
													</div>
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
													<hr class="my-2">
													<div class="d-flex align-items-center m-2">
														<span class="filter-label">검색일자</span>
														<div class="custom-control custom-checkbox mr-2">
															<input class="custom-control-input" type="checkbox"
																id="customCheckbox1" value="option1">
															<label for="customCheckbox1"
																class="custom-control-label small">기안일자</label>
														</div>
														<div class="custom-control custom-checkbox">
															<input class="custom-control-input" type="checkbox"
																id="customCheckbox2" value="option2">
															<label for="customCheckbox2"
																class="custom-control-label small">생성일자</label>
														</div>
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
						</div>
						<!--필터 검색 폼 끝-->


						<div class="card">
							<div class="bg-default disabled card-header">
								<h3 class="card-title">보낸 기안함</h3>
								<div class="card-tools">
									<div class="input-group input-group-sm">
										<a type="button" class="btn btn-light btn-sm"
											href="/elctrnsanctn/postElctrnsanctn">
											<i class="fas fa-edit"></i>신규
										</a>
									</div>
								</div>
							</div>
							<div class="card-body">
								<table class="table table-bordered table-hover table-sm text-center"
									style="font-size: 0.9rem;">
									<thead>
										<tr class="bg-light">
											<th>순번</th>
											<th class="col-5">제목</th>
											<th>결재자</th>
											<th>결재상태</th>
											<th>기안일자</th>
											<th>생성일자</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${not empty articlePage.content}">
												<c:forEach var="elctrnsanctnVO" items="${articlePage.content}">
													<tr class="elctrnsanctnRow" style="cursor: pointer;">
														<td>${elctrnsanctnVO.rnum }
															<input type="hidden" id="elctrnsanctnSn"
																value="${elctrnsanctnVO.elctrnsanctnSn}" />
														</td>
														<td class="text-left">
															<c:choose>
																<c:when test="${elctrnsanctnVO.drftTmprstre>0}">
																	<span
																		class="badge badge-warning m1-2">${elctrnsanctnVO.drftTmprstreStts}</span>
																</c:when>
																<c:otherwise>
																	<span
																		class="badge badge-success m1-2">${elctrnsanctnVO.drftTmprstreStts}</span>
																</c:otherwise>
															</c:choose>
															<span class="ml-2">
																${elctrnsanctnVO.drftSj }
															</span>
														</td>
														<td>
															${elctrnsanctnVO.sanctnEmp}
														</td>
														<td>
															<c:choose>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='대기'}">
																	<span
																		class="badge badge-secondary">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='반려'}">
																	<span
																		class="badge badge-danger">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='결재완료'}">
																	<span
																		class="badge badge-success">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:otherwise>
																	<span
																		class="badge badge-info">${elctrnsanctnVO.totSanctnStts}</span>
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<c:choose>
																<c:when test="${not empty elctrnsanctnVO.drftDt}">
																	<fmt:formatDate value="${elctrnsanctnVO.drftDt}"
																		pattern="yyyy-MM-dd" />
																</c:when>
																<c:otherwise>
																	<span class="text-muted">---</span>
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<fmt:formatDate value="${elctrnsanctnVO.creatDt}"
																pattern="yyyy-MM-dd" />
														</td>
													</tr>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<tr>
													<td colspan="7">
														<span class="text-muted fs-4">보낸 기안함이 비었습니다.</span>
													</td>
												</tr>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</div>
							${articlePage.pagingAreaBorderedTable}
						</div>
						<%@ include file="../include/footer.jsp" %>
				</body>

				</html>