<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title></title>

					<script type="text/javascript">
						document.addEventListener("DOMContentLoaded", function () {
							document.querySelectorAll(".bidPblancVORow").forEach(row => {
								row.addEventListener("click", function () {
									const bdderSn = this.querySelector("#bdderSn").value;
									window.open(
										"/bdder/getBdder?bdderSn=" + bdderSn,
										'_blank',
										'width=1000, height=1200, scrollbars=yes'
									);
								});
							});

							//PDF 미리보기
							const fileLinks = document.querySelectorAll(".list-group-item");

							fileLinks.forEach(link => {
								link.addEventListener("click", function (e) {
									e.preventDefault();
									const fileGroupSn = this.getAttribute("data-file-group-sn");
									const fileNo = this.getAttribute("data-file-no");
									const fileName = this.querySelector("span").textContent;
									const fileExtension = fileName.split('.').pop().toLowerCase();

									if (fileExtension === 'pdf') {
										// PDF 파일: 미리보기
										const previewUrl = `/bdder/previewFile?fileGroupSn=\${fileGroupSn}&fileNo=\${fileNo}`;
										window.open(previewUrl, 'pdfPreview', 'width=600, height=800');
									} else {
										// 다른 파일: 다운로드
										const downloadUrl = `/bidPblanc/download?fileGroupSn=\${fileGroupSn}&fileNo=\${fileNo}`;
										window.location.href = downloadUrl;
									}
								});
							});
						});
					</script>
				</head>

				<body>
					<%@ include file="../include/header.jsp" %>
						<!-- /// body /// -->
						<div class="card card-default">
							<div class="card-header">
								<h3 class="card-title">
									입찰 공고 상세
									<c:if test="${bidPblancVO.bidSttus==2}">
										<span class="badge badge-danger ml-2"
											style="font-size: 0.9rem">${bidPblancVO.bidSttusAsStr}</span>
									</c:if>
								</h3>
							</div>
							<!-- /.card-header -->
							<div class="card-body">
								<table class="table table-bordered table-sm">
									<tbody>
										<tr>
											<th class="bg-light col-2 text-center">입찰번호</th>
											<td colspan="3">${bidPblancVO.bidPblancSnAsStr}</td>
										</tr>
										<tr>
											<th class="bg-light col-2 text-center">입찰제목</th>
											<td colspan="3"> <c:out value="${bidPblancVO.bidSj}"/>												
											</td>
										</tr>
										<tr>
											<th class="bg-light col-2 text-center">낙찰방법</th>
											<td class="col-4">${bidPblancVO.scsbMthAsStr}</td>
											<th class="bg-light col-2 text-center">보증금률(%)</th>
											<td class="col-4">
												<span>
													${bidPblancVO.bidGtnRt}
												</span>
												<span class="ml-1" style="color:gray; font-size: smaller;">
													(입찰가격의[${bidPblancVO.bidGtnRt}]%이상 제출)</span>
											</td>
											</td>
										</tr>
										<tr>
											<th class="bg-light col-2 text-center">공고 시작일</th>
											<td>
												<fmt:formatDate value="${bidPblancVO.pblancDt}" pattern="yyyy-MM-dd" />
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
														<input class="custom-control-input custom-control-input-primary"
															type="checkbox" id="cdltPresentnAt" <c:if
															test="${bidPblancVO.cdltPresentnAt == 1}">checked</c:if>
														disabled>
														<label for="cdltPresentnAt" class="custom-control-label">
															신용평가등급확인서
														</label>
													</div>
													<div class="custom-control custom-checkbox ml-2">
														<input class="custom-control-input custom-control-input-primary"
															type="checkbox" id="acmsltproofPresentnAt" <c:if
															test="${bidPblancVO.acmsltproofPresentnAt == 1}">checked
														</c:if>
														disabled>
														<label for="acmsltproofPresentnAt" class="custom-control-label">
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
														<div class="bg-light p-2 mb-2 d-flex align-items-center">
															<label for="previewFiles" class="mb-0">미리보기</label>
														</div>
														<!-- 파일 목록 -->
														<div class="list-group">
															<c:forEach var="file" items="${fileDetailVOList}">
																<a class="list-group-item list-group-item-action d-flex align-items-center"
																	data-file-group-sn="${file.fileGroupSn}"
																	data-file-no="${file.fileNo}"
																	style="cursor: pointer;">
																	<i class="fa fa-file mr-2"></i>
																	<span>${file.fileOrginlNm}</span>
																</a>
															</c:forEach>
														</div>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</tbody>
								</table>
								<br>
								<div class="card card-default card-sm">
									<div class="card-header">
										<h3 class="card-title">입찰자 목록</h3>

										<div class="card-tools">
											<div class="input-group input-group-sm" style="width: 150px;">
												<input type="text" name="table_search" class="form-control float-right"
													placeholder="Search">

												<div class="input-group-append">
													<button type="submit" class="btn btn-default">
														<i class="fas fa-search"></i>
													</button>
												</div>
											</div>
										</div>
									</div>
									<div class="card-body">
										<table class="table table-bordered table-sm table-hover text-center">
											<thead>
												<tr class="bg-light">
													<th>순번</th>
													<th>상호</th>
													<th>사업자등록번호</th>
													<th>대표자</th>
													<th>입찰가액(원)</th>
													<th>보증금(원)</th>
												</tr>
											</thead>
											<tbody>
												<c:choose>
													<c:when test="${bidPblancVO.bidSttus==2}">
														<c:forEach var="bdderVO" items="${articlePage.content}">
															<c:if test="${bdderVO.bidAt==1}">
																<tr class="bidPblancVORow table-primary"
																	style="cursor: pointer;">
																	<td>${bdderVO.rnum}
																		<input type="hidden" id="bdderSn"
																			value="${bdderVO.bdderSn}" />
																	</td>
																	<td>
																		<span class="badge badge-danger mr-2"
																			style="font-size: 0.9rem;">${bdderVO.bidAtAsStr}</span>
																		${bdderVO.ccpyManageVO.ccpyCmpnyNm}
																	</td>
																	<td>
																		${bdderVO.ccpyManageVO.ccpyBizrno}
																	</td>
																	<td>
																		${bdderVO.ccpyManageVO.ccpyRprsntvNm}
																	</td>
																	<td>
																		<fmt:formatNumber value="${bdderVO.bidAmount }"
																			pattern="#,### 원">
																		</fmt:formatNumber>
																	</td>
																	<td>
																		<fmt:formatNumber value="${bdderVO.bidGtn }"
																			pattern="#,### 원">
																		</fmt:formatNumber>
																	</td>
																</tr>
															</c:if>
														</c:forEach>
													</c:when>
													<c:otherwise>
														<c:forEach var="bdderVO" items="${articlePage.content}">
															<tr class="bidPblancVORow" style="cursor: pointer;">
																<td>${bdderVO.rnum}
																	<input type="hidden" id="bdderSn"
																		value="${bdderVO.bdderSn}" />
																</td>
																<td>
																	${bdderVO.ccpyManageVO.ccpyCmpnyNm}
																</td>
																<td>
																	${bdderVO.ccpyManageVO.ccpyBizrno}
																</td>
																<td>
																	${bdderVO.ccpyManageVO.ccpyRprsntvNm}
																</td>
																<td>
																	<fmt:formatNumber value="${bdderVO.bidAmount }"
																		pattern="#,###">
																	</fmt:formatNumber>
																</td>
																<td>
																	<fmt:formatNumber value="${bdderVO.bidGtn }"
																		pattern="#,###">
																	</fmt:formatNumber>
																</td>
															</tr>
														</c:forEach>
													</c:otherwise>
												</c:choose>
											</tbody>
										</table>
									</div>
									<!-- 안쪽 div 페이지네이션 -->
									${articlePage.pagingAreaBorderedTable}
									<!-- 안쪽 div 페이지네이션 -->
								</div>
							</div>
							<!-- /.card-body -->
							<!-- card-footer-->
						</div>
						<!-- card-footer-->
						<!-- /// body /// -->
						<%@ include file="../include/footer.jsp" %>
				</body>

				</html>