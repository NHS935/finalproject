<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title>전자결재 목록</title>
				</head>
				<script>
					document.addEventListener("DOMContentLoaded", function () {
						document.querySelectorAll(".elctrnsanctnRow").forEach(row => {
							row.addEventListener("click", function () {
								const elctrnsanctnSn = this.querySelector("#elctrnsanctnSn").value;
								location.href = "/elctrnsanctn/getElctrnsanctn?elctrnsanctnSn=" + elctrnsanctnSn;
							});
						});

						document.querySelectorAll(".elctrnsanctnRcptRow").forEach(row=>{
							row.addEventListener("click", function(){
								const elctrnsanctnSn = this.querySelector("#elctrnsanctnSn").value;
								location.href = "/elctrnsanctn/getElctrnsanctnRcpt?elctrnsanctnSn=" + elctrnsanctnSn; 
							})
						})
					});
				</script>

				<body>
					<%@ include file="../include/header.jsp" %>
						<!--/// body /// -->
						<div class="card card-info">
							<div class="card-header">
								<h3 class="card-title">전자 결재 목록</h3>
							</div>
							<!-- /.card-header -->
							<div class="card-body">
								<div class="card">
									<div class="bg-info disabled card-header">
										<h3 class="card-title">보낸 기안</h3>
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
													<th>진행상태</th>
													<th>기안일자</th>
													<th>생성일자</th>
												</tr>
											</thead>
											<tbody>
												<c:choose>
													<c:when test="${not empty articlePageSent.content}">
														<c:forEach var="elctrnsanctnVO"
															items="${articlePageSent.content}">
															<tr class="elctrnsanctnRow" style="cursor: pointer;">
																<td>${elctrnsanctnVO.rnum }
																	<input type="hidden" id="elctrnsanctnSn"
																		value="${elctrnsanctnVO.elctrnsanctnSn}" />
																</td>
																<td class="text-left">
																	<c:choose>
																		<c:when
																			test="${elctrnsanctnVO.drftTmprstre>0}">
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
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='대기'}">
																			<span
																				class="badge badge-secondary">${elctrnsanctnVO.totSanctnStts}</span>
																		</c:when>
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='반려'}">
																			<span
																				class="badge badge-danger">${elctrnsanctnVO.totSanctnStts}</span>
																		</c:when>
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='결재완료'}">
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
																		<c:when
																			test="${not empty elctrnsanctnVO.drftDt}">
																			<fmt:formatDate
																				value="${elctrnsanctnVO.drftDt}"
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
									${articlePageSent.pagingAreaBorderedTable}
								</div>
								<div class="card">
									<div class="bg-success disabled card-header">
										<h3 class="card-title">받은 기안</h3>
									</div>
									<!-- /.card-header -->
									<div class="card-body">
										<table class="table table-bordered table-hover table-sm text-center"
											style="font-size: 0.9rem;">
											<thead>
												<tr class="bg-light">
													<th>순번</th>
													<th class="col-5">제목</th>
													<th>기안자</th>
													<th>진행상태</th>
													<th>대기결재</th>
													<th>최종결재</th>
													<th>기안일자</th>
												</tr>
											</thead>
											<tbody>
												<c:choose>
													<c:when test="${not empty articlePageRcpt.content}">
														<c:forEach var="elctrnsanctnVO"
															items="${articlePageRcpt.content}">
															<tr class="elctrnsanctnRcptRow" style="cursor: pointer;">
																<td>
																	${elctrnsanctnVO.rnum }
																	<input type="hidden" id="elctrnsanctnSn"
																		value="${elctrnsanctnVO.elctrnsanctnSn}" />
																</td>
																<td class="text-left">
																	<span class="ml-2">
																		${elctrnsanctnVO.drftSj }
																	</span>
																</td>																
																<td>
																	${elctrnsanctnVO.empVO.nm }
																</td>
																<td>
																	<c:choose>
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='대기'}">
																			<span
																				class="badge badge-secondary">${elctrnsanctnVO.totSanctnStts}</span>
																		</c:when>
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='반려'}">
																			<span
																				class="badge badge-danger">${elctrnsanctnVO.totSanctnStts}</span>
																		</c:when>
																		<c:when
																			test="${elctrnsanctnVO.totSanctnStts=='결재완료'}">
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
																	${elctrnsanctnVO.sanctnEmp }
																</td>
																<td>
																	${elctrnsanctnVO.finalSanctnEmpNm}
																</td>
																<td>
																	<fmt:formatDate value="${elctrnsanctnVO.drftDt}"
																		pattern="yyyy-MM-dd" />
																</td>
															</tr>
														</c:forEach>
													</c:when>
													<c:otherwise>
														<tr>
															<td colspan="7">
																<span class="text-muted fs-4">받은 기안함이 비었습니다.</span>
															</td>
														</tr>
													</c:otherwise>
												</c:choose>

											</tbody>
										</table>
									</div>
									<!-- /.card-body -->
									${articlePageRcpt.pagingAreaBorderedTable}
								</div>
							</div>
							<!-- /.card-body -->
						</div>
						<!-- /// body /// -->
						<%@ include file="../include/footer.jsp" %>
				</body>

				</html>