<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title>전자결재 상세</title>
				</head>
				
				<style>
					.cke_notification {
			            display: none !important;
			        }
				</style>
				
				<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
				<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

				<script>
					let modal;
					let returnPrvonsh='';
					let elctrnsanctnSn;
					let dcrbmanAt;
					document.addEventListener("DOMContentLoaded", function () {
						modal = new bootstrap.Modal(
							document.querySelector('#modalReturnPrvonsh'));

						let drftCnElement = document.querySelector("#drftCn");
						let drftCn = drftCnElement.value;
						//CKEDITOR
						let drftDt = document.querySelector("#drftDt").value;
						drftCn = drftCn.replace(
							'id="elctrnsanctnDrftDt">',
							'id="elctrnsanctnDrftDt">' + drftDt
						);
						drftCnElement.value = drftCn;

						if (window.CKEDITOR) {
							CKEDITOR.replace('drftCn', {
								height: '400px',
								allowedContent: true,
								contentsCss: '/css/contract.css',
								readOnly: true
							}, function (editor) {
								editor.setData(drftCn);
							});
						} else {
							console.warn('CKEditor 로드 안됨');
						}
						//CKEDITOR

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
									window.open(previewUrl, 'pdfPreview', 'width=1000,height=800');
								} else {
									// 다른 파일: 다운로드
									const downloadUrl = `/bidPblanc/download?fileGroupSn=\${fileGroupSn}&fileNo=\${fileNo}`;
									window.location.href = downloadUrl;
								}
							});
						});
						// ======= 승인 =======
						document.querySelector("#consentBtn").addEventListener("click", function () {
							elctrnsanctnSn = document.querySelector("#elctrnsanctnSn").value;
							dcrbmanAt = document.querySelector("#dcrbmanAt").value;

							Swal.fire({
								icon: 'question',
								title: '기안 승인',
								text: '기안을 승인하시겠습니까?.',
								confirmButtonText: '확인',
								cancelButtonText: '취소',
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33'
							}).then(() => {
								const data = {
									"elctrnsanctnSn": elctrnsanctnSn,
									"dcrbmanAt": dcrbmanAt
								}
								consentElctrnsanctn(data);
							});
						});

						async function consentElctrnsanctn(data) {
							try {
								const response = await axios.post("/elctrnsanctn/consentElctrnsanctn", data);
								if (response.data.result == 1) {
									Swal.fire({
										icon: 'success',
										title: '승인 완료',
										text: '기안을 승인하였습니다.',
										confirmButtonText: '확인'
									}).then(() => {
										window.location.href = "/elctrnsanctn/getElctrnsanctnList"
									})
								} else {
									Swal.fire({
										icon: 'error',
										title: '승인 실패',
										text: '오류가 발생하였습니다.',
										confirmButtonText: '확인'
									});
								}
							} catch (error) {
								Swal.fire({
									icon: 'error',
									title: '오류 발생',
									text: error.response?.data?.message || error.message,
									confirmButtonText: '확인'
								});
							}
						}
						// ======= 승인 =======

						// ======= 반려 =======
						document.querySelector("#rejectBtn").addEventListener("click", function () {
							elctrnsanctnSn = document.querySelector("#elctrnsanctnSn").value;
							returnPrvonsh = ''; 
            				document.querySelector("#returnPrvonsh").value = '';  

							Swal.fire({
								icon: 'question',
								title: '기안 반려',
								text: '기안을 반려하시겠습니싸?.',
								confirmButtonText: '확인',
								cancelButtonText: '취소',
								confirmButtonColor: '#3085d6',
								cancelButtonColor: '#d33'
							}).then((result) => {
								if (result.isConfirmed) {
									modal.show();
								}
							});
						});

						document.querySelector("#returnPrvonsh").addEventListener("input", function () {
							returnPrvonsh = this.value;
						})

						document.querySelector("#returnPrvonshBtn").addEventListener("click", function () {
							const data = {
								"elctrnsanctnSn": elctrnsanctnSn,
								"returnPrvonsh": returnPrvonsh
							}
							rejectElctrnsanctn(data);
						})

						async function rejectElctrnsanctn(data) {
							try {
								const response = await axios.post("/elctrnsanctn/rejectElctrnsanctn", data);
								if (response.data.result == 1) {
									Swal.fire({
										icon: 'success',
										title: '반려 완료',
										text: '기안을 반려하였습니다.',
										confirmButtonText: '확인'
									}).then(() => {
										modal.hide();
										window.location.href = "/elctrnsanctn/getElctrnsanctnList"
									})
								} else {
									Swal.fire({
										icon: 'error',
										title: '반려 실패',
										text: '오류가 발생하였습니다.',
										confirmButtonText: '확인'
									});
								}
							} catch (error) {
								Swal.fire({
									icon: 'error',
									title: '오류 발생',
									text: error.response?.data?.message || error.message,
									confirmButtonText: '확인'
								});
							}
						}
						// ======= 반려 =======
					});
				</script>

				<body>
					<%@ include file="../include/header.jsp" %>
						<!--/// body /// -->
						<div class="card card-default">
							<div class="card-header">
								<h3 class="card-title">기안서 상세</h3>
								<div class="card-tools">
									<div class="input-group input-group-sm">

										<button type="button" class="bg-warning btn btn-sm" id="previewBtn">
											미리보기
										</button>
									</div>
								</div>
							</div>

							<div class="card-body">
								<div class="card card-default">
									<div class="card-header">
										<h3 class="card-title" id="drftDocTitle">
											${elctrnsanctnVO.drftDocVO.elctrnsanctnManageVO.sanctnSecode} |
											${elctrnsanctnVO.drftDocVO.drftDocNm}
										</h3>
										<div class="card-tools">
											<c:if test="${elctrnsanctnVO.totSanctnStts!='반려' and elctrnsanctnVO.totSanctnStts!='결재완료'}">
												<c:if  test="${elctrnsanctnVO.currentWaitingSanctnEmpId==empVO.empId}">
													<button type="button" class="btn btn-light btn-sm mr-2" id="consentBtn">
														승인
													</button>
													<button type="button" class="btn btn-warning btn-sm" id="rejectBtn">
														반려
													</button>
												</c:if>
											</c:if>
										</div>
									</div>

									<div class="card-body">
										<table class="table table-bordered table-sm">
											<tbody>
												<tr>
													<th class="text-center align-middle col-2 bg-light">제목</th>
													<td colspan="3">
														<span class="ml-2">
															${elctrnsanctnVO.drftSj}
															<input type="hidden"
																value="${elctrnsanctnVO.elctrnsanctnSn}"
																name="elctrnsanctnSn" id="elctrnsanctnSn" />
														</span>
													</td>
												</tr>

												<tr>
													<th class="text-center align-middle col-2 bg-light">기안자</th>
													<td class="col-4 align-middle">
														<span class="ml-2">
															${elctrnsanctnVO.empVO.nm}
															${elctrnsanctnVO.empVO.clsfName}
														</span>
														<input type="hidden" name="empId" value="${empVO.empId}" />
													</td>
													<th class="text-center align-middle col-2 bg-light">생성일자</th>
													<td class="col-4">
														<span class="ml-2">
															<fmt:formatDate value='${elctrnsanctnVO.creatDt}'
																pattern='yyyy-MM-dd' />
														</span>
														<c:if test="${not empty elctrnsanctnVO.drftDt}">
															<input type="hidden" id="drftDt"
																value="<fmt:formatDate value='${elctrnsanctnVO.drftDt}' pattern='yyyy-MM-dd'/>" />
														</c:if>
													</td>
												</tr>

												<tr>
													<th colspan="4" class="bg-light">
														<div class="d-flex align-items-center">
															<span class="flex-grow-1 text-center">결재선</span>
														</div>
													</th>
												</tr>

												<tr>
													<td class="p-1" colspan="4" id="sanctnlnTd">
														<table class="table table-sm table-bordered sanctnln-table m-0">
															<thead>
																<tr class="bg-lightblue disabled text-center">
																	<th class="col-1">순번</th>
																		<th class="col-2">직급</th>
																		<th class="col-3">성명</th>
																		<th class="col-2">부서</th>
																		<th class="col-2">결재상태</th>
																		<th class=>서명</th>
																</tr>
															</thead>
															<tbody id="sanctnTableBody">
																<c:forEach var="sanctnlnVO"
																	items="${elctrnsanctnVO.sanctnlnVOList}">
																	<c:if test="${sanctnlnVO.empId == empVO.empId}">
																		<input type="hidden" id="dcrbmanAt" value="${sanctnlnVO.dcrbmanAt}" />
																	</c:if>
																	<tr class="text-center">
																		<td class="align-middle">
																			${sanctnlnVO.sanctnOrdr}</td>
																		<td class="align-middle">
																			${sanctnlnVO.empVO.clsfName}</td>
																		<td class="align-middle">
																			${sanctnlnVO.empVO.nm}</td>
																		<td class="align-middle">
																			${sanctnlnVO.empVO.deptVO.deptNm}</td>
																		<td class="align-middle">
																			<c:choose>
																				<c:when
																					test="${sanctnlnVO.sanctnSttus==1}">
																					<span
																						style="color: blue;">${sanctnlnVO.sanctnSttusAsSTr}</span>
																				</c:when>
																				<c:when
																					test="${sanctnlnVO.sanctnSttus==2}">
																					<span
																						style="color: red;">${sanctnlnVO.sanctnSttusAsSTr}</span>
																				</c:when>
																				<c:otherwise>
																					<span>${sanctnlnVO.sanctnSttusAsSTr}</span>
																				</c:otherwise>
																			</c:choose>
																		</td>
																		<td class="align-middle">
																			<c:if test="${sanctnlnVO.sanctnSttus==1}">
																				<img class="img-fluid w-75"
																					src="/upload${sanctnlnVO.empVO.signVO.fileDetailVO.fileStrelc}">
																			</c:if>
																		</td>
																	</tr>
																</c:forEach>
															</tbody>
															<tfoot>
																<tr>
																	<th class="bg-light text-center">참조</th>
																	<td id="referenceTableFoot" colspan="5">
																		<c:forEach var="drftRefrnVO"
																			items="${elctrnsanctnVO.drftRefrnVOList}">
																			<span class="badge badge-lg bg-light ml-2"
																				style="font-size: 0.9rem;">${drftRefrnVO.empVO.nm}
																				${drftRefrnVO.empVO.clsfName}</span>
																		</c:forEach>
																	</td>
																</tr>
																<c:if test="${elctrnsanctnVO.totSanctnStts=='반려'}">
																	<c:forEach var="sanctnlnVO"
																	items="${elctrnsanctnVO.sanctnlnVOList}">
																		<c:if test="${sanctnlnVO.sanctnSttus==2}">
																			<tr>
																				<th colspan="2"
																					class="bg-danger disabled align-middle text-center">
																					반려사유
																				</th>
																				<td colspan="4">
																					<textarea
																						class="form-control form-control-border mb-0"
																						style="resize: vertical;"
																						rows="2" disabled>${sanctnlnVO.returnPrvonsh}</textarea>
																				</td>
																			</tr>
																		</c:if>
																	</c:forEach>
																</c:if>
															</tfoot>
														</table>
													</td>
												</tr>
												<tr>
													<th class="text-center align-middle col-2 bg-light">첨부파일</th>
													<td colspan="3" class="p-1 align-middle">
														<c:choose>
															<c:when test="${empty fileDetailVOList}">
																<div
																	class="d-flex justify-content-center align-items-center">
																	<p class="text-muted mb-0">첨부파일이 없습니다.</p>
																</div>
															</c:when>
															<c:otherwise>																
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
									</div>
									
								</div>
								<div>
									<!-- drftCn -->
									<textarea class="form-control cntrPost" name="drftCn" id="drftCn">
											${elctrnsanctnVO.drftCn}
										</textarea>
								</div>
							</div>
							<div class="card-footer d-flex">
								<a class="btn btn-warning btn-sm mr-1" href="/elctrnsanctn/getElctrnsanctnRcpttList">목록</a>
							</div>
						</div>
						<!-- /// body /// -->
						<%@ include file="../include/footer.jsp" %>
							<!-- 반려 사유 모달 -->
							<div class="modal fade modal-custom-top" id="modalReturnPrvonsh" style="display: none;"
								aria-hidden="true">
								<div class="modal-dialog modal-default">
									<div class="modal-content">
										<div class="modal-header bg-lightblue">
											<h4 class="modal-title">반려 사유</h4>
										</div>
										<div class="modal-body">
											<textarea class="form-control form-control-border mb-0" rows="4"
												placeholder="사유를 입력해주세요." id="returnPrvonsh"></textarea>
										</div>
										<div class="modal-footer justify-content-between">
											<button type="button" class="btn btn-default btn-sm"
												data-dismiss="modal">취소</button>
											<button type="button" id="returnPrvonshBtn"
												class="btn btn-sm bg-lightblue">확인</button>
										</div>
									</div>
									<!-- /.modal-content -->
								</div>
								<!-- /.modal-dialog -->
							</div>

				</body>

				</html>