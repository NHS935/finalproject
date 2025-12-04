<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>
				<head>
					<title>전자결재 상세</title>
					<style>
						.cke_notification {
							display: none !important;
						}
					</style>
					<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
					<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
					<script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js"></script>
					<script>
						let selectCcpyModal;
						let selectedCcpyEmail = '';
						let selectedCcpyName = '';
						document.addEventListener("DOMContentLoaded", function () {
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

							selectCcpyModal = new bootstrap.Modal(
									document.querySelector('#selectCcpyModal')
							);
							// === 계약서 전송 버튼 클릭 이벤트 ===
							const sendContractBtn = document.querySelector("#sendContractBtn");
							if (sendContractBtn) {
								sendContractBtn.addEventListener("click", function () {
									// 1. 모달 표시
									selectCcpyModal.show();
									// 2. 협력사 목록 로드 (AJAX)
									loadPartnerCompanies();
								});
							}

							// === 협력사 목록 로드 AJAX 함수 ===
							async function loadPartnerCompanies() {
								const tbody = document.querySelector("#ccpyTableBody");
								tbody.innerHTML = '<tr><td colspan="4"><i class="fas fa-spinner fa-spin"></i> 목록 로드 중...</td></tr>';

								try {
									// ⚠️ [가정] /elctrnsanctn/getPartnerCompanies 라는 AJAX URL이 협력사 리스트를 반환한다고 가정
									const response = await axios.get("/ccpyManage/getPartnerCompanies");
									const ccpyList = response.data; // 반환 데이터 구조 가정

									tbody.innerHTML = '';

									if (ccpyList && ccpyList.length > 0) {
										ccpyList.forEach(ccpy => {
											const row = document.createElement('tr');
											row.className = 'ccpyRow';
											row.setAttribute('data-ccpy-id', ccpy.ccpyManageId);
											row.setAttribute('data-ccpy-email', ccpy.ccpyEmail);
											row.setAttribute('data-ccpy-name', ccpy.ccpyCmpnyNm);

											row.innerHTML = `
												<td><input type="radio" name="ccpySelect" value="\${ccpy.ccpyManageId}"></td>
												<td>\${ccpy.ccpyCmpnyNm}</td>
												<td>\${ccpy.ccpyRprsntvNm}</td>
												<td>\${ccpy.ccpyEmail}</td>
											`;
											tbody.appendChild(row);
										});

										// 3. 라디오 버튼 클릭 이벤트 설정
										attachCcpySelectEvents();
									} else {
										tbody.innerHTML = '<tr><td colspan="4">등록된 협력사가 없습니다.</td></tr>';
									}

								} catch (error) {
									console.error("협력사 로드 오류:", error);
									tbody.innerHTML = '<tr><td colspan="4" class="text-danger">목록 로드 중 오류 발생</td></tr>';
								}
							}

							// === 협력사 선택 이벤트 핸들러 ===
							function attachCcpySelectEvents() {
								const confirmSendBtn = document.querySelector("#confirmSendBtn");

								document.querySelectorAll(".ccpyRow").forEach(row => {
									row.addEventListener("click", function () {
										const radio = this.querySelector('input[type="radio"]');
										radio.checked = true; // 라디오 버튼 선택

										// 선택된 데이터 임시 저장
										selectedCcpyEmail = this.getAttribute('data-ccpy-email');
										selectedCcpyName = this.getAttribute('data-ccpy-name');
										confirmSendBtn.disabled = false; // 전송 버튼 활성화
									});
								});
							}

							// === 서명 요청 최종 확인 버튼 클릭 이벤트 ===
							document.querySelector("#confirmSendBtn").addEventListener("click", function () {

								// 1. 🚨 [수정된 부분] 🚨 파일 목록 전체를 순회하며 "_stamped" 문자열을 가진 요소를 찾습니다.
								const stampedFileElement = Array.from(document.querySelectorAll(".list-group-item")).find(link => {
									// 파일명이 들어있는 <span> 태그의 텍스트 내용을 확인
									const fileNameSpan = link.querySelector("span");
									return fileNameSpan && fileNameSpan.textContent.includes('_stamped');
								});

								if (!stampedFileElement) {
									// 직인본(Stamped File)이 없는 경우 사용자에게 경고
									Swal.fire({
										icon: 'error',
										title: '파일 누락',
										text: '서명을 요청할 직인본 파일(\"_stamped\"가 포함된 파일)을 찾을 수 없습니다.',
										confirmButtonText: '확인'
									});
									return;
								}

								// 2. 찾아낸 요소에서 fileGroupSn과 fileNo를 가져옵니다.
								const fileGroupSn = stampedFileElement.getAttribute("data-file-group-sn");
								const fileNo = stampedFileElement.getAttribute("data-file-no");

								// 🚨 이메일 발송을 포함한 최종 서버 요청 🚨
								sendSigningRequest(fileGroupSn, fileNo, selectedCcpyEmail, selectedCcpyName);
							});

							// === 서명 요청 AJAX 함수 (컨트롤러로 데이터 전송) ===
							async function sendSigningRequest(fileGroupSn, fileNo, toEmail, ccpyCmpnyNm) {

								Swal.fire({
									title: '서명 요청 발송 중...',
									text: '잠시만 기다려주십시오.',
									allowOutsideClick: false,
									// SweetAlert2가 열린 직후 (DOM에 컨테이너가 추가된 후) 이 함수가 실행됩니다.
									didOpen: () => {
										// 1. Swal.showLoading() 대신 애니메이션 컨테이너를 추가합니다.
										//    SweetAlert2의 기본 HTML 구조를 이용하거나,
										//    직접 컨테이너 요소를 추가해야 합니다.
										//    가장 쉬운 방법은 'html' 속성을 사용하는 것입니다.

										// 이 예시에서는 'html' 속성에 컨테이너를 직접 삽입합니다.
										// (Swal.update() 또는 Swal.getHtmlContainer()를 사용해야 할 수도 있습니다.)

										// **가장 간단한 방법으로 'html' 속성을 사용해 컨테이너를 먼저 만듭니다.**
										const content = Swal.getHtmlContainer();
										if (content) {
											content.innerHTML = '<div id="lottie-container" style="width: 200px; height: 200px; margin: auto;"></div>';
										}

										// 2. Lottie 애니메이션을 로드합니다.
										window.lottieAnimation = lottie.loadAnimation({
											container: document.getElementById('lottie-container'),
											renderer: 'svg',
											loop: true,
											autoplay: true,
											path: '/animations/mailing.json' // 실제 경로로 변경하세요.
										});

										// SweetAlert2의 기본 로딩 스피너를 숨기고 싶다면,
										// title과 text만 사용하고 Swal.showLoading()은 호출하지 않습니다.
										// 또는, html 속성을 사용하여 전체 내용을 제어할 수 있습니다.
									},
									// 애니메이션 로딩 후에는 Swal.showLoading()을 사용하지 않아도 됩니다.
									showConfirmButton: false // 확인 버튼을 숨겨서 깔끔하게 만듭니다.
								});

								try {
									const response = await axios.post("/elctrnsanctn/sendContractForSigning", null, {
										params: {
											fileGroupSn: fileGroupSn,
											fileNo: fileNo,
											toEmail: toEmail,
											ccpyCmpnyNm: ccpyCmpnyNm
										}
									});

									// 응답 처리 (성공 HTML 메시지를 받음)
									Swal.fire({
										icon: 'success',
										title: '발송 완료',
										html: response.data, // 컨트롤러에서 받은 HTML 메시지 출력
										confirmButtonText: '확인'
									}).then(() => {
										selectCcpyModal.hide();
										// 필요시 페이지 새로고침 또는 목록으로 이동
										// window.location.reload();
									});

								} catch (error) {
									Swal.fire({
										icon: 'error',
										title: '발송 실패',
										text: error.response?.data?.message || '요청 처리 중 오류가 발생했습니다.',
										confirmButtonText: '확인'
									});
								}
							}
							//재상신버튼
							document.querySelector("#postReElctrnsanctn").addEventListener("click", function () {
								const elctrnsanctnSn = document.querySelector("#elctrnsanctnSn").value;
								location.href = "/elctrnsanctn/postReElctrnsanctn?elctrnsanctnSn=" + elctrnsanctnSn;
							});



						});
					</script>
				</head>

				<body>
					<%@ include file="../include/header.jsp" %>
						<!--/// body /// -->
						<div class="card card-default">
							<div class="card-header">
								<h3 class="card-title">기안서 상세</h3>
								<div class="card-tools">
									<div class="input-group input-group-sm">
										<c:if test="${elctrnsanctnVO.totSanctnStts == '결재완료' and elctrnsanctnVO.empId == empVO.empId}">
											<button type="button" class="bg-success btn btn-sm mr-2" id="sendContractBtn">
												계약서 전송하기
											</button>
										</c:if>
										<button type="button" class="bg-warning btn btn-sm" id="previewBtn">
											미리보기
										</button>
									</div>
								</div>
							</div>

							<form id="drftForm" method="post" enctype="multipart/form-data">
								<div class="card-body">
									<div class="card card-default">
										<div class="card-header">
											<h3 class="card-title" id="drftDocTitle">
												${elctrnsanctnVO.drftDocVO.elctrnsanctnManageVO.sanctnSecode}
												<span class="ml-2 mr-2 fs-4">|</span>
												${elctrnsanctnVO.drftDocVO.drftDocNm}
											</h3>
											<div class="card-tools">
												<c:choose>
													<c:when test="${elctrnsanctnVO.drftTmprstre==0}">
														<div>
															<c:choose>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='대기'}">
																	<span class="badge badge-lg badge-secondary p-1"
																		style="font-size: 1rem;">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='반려'}">
																	<span class="badge badge-lg badge-danger p-1"
																		style="font-size: 1rem;">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:when test="${elctrnsanctnVO.totSanctnStts=='결재완료'}">
																	<span class="badge badge-lg badge-success p-1"
																		style="font-size: 1rem;">${elctrnsanctnVO.totSanctnStts}</span>
																</c:when>
																<c:otherwise>
																	<span class="badge badge-lg badge-light p-1"
																		style="font-size: 1rem;">${elctrnsanctnVO.totSanctnStts}</span>
																</c:otherwise>
															</c:choose>
															<span class="mr-2 ml-2 fs-4">|</span>
															<span class="badge badge-lg bg-light p-1"
																style="font-size: 0.9rem;">
																${elctrnsanctnVO.drftTmprstreStts}</span>
														</div>
													</c:when>
													<c:otherwise>
														<span class="badge badge-lg bg-warning p-1 mr-2"
															style="font-size: 0.9rem;">
															${elctrnsanctnVO.drftTmprstreStts}
														</span>
													</c:otherwise>
												</c:choose>
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
															</span>
															<input type="hidden"
																value="${elctrnsanctnVO.elctrnsanctnSn}"
																id="elctrnsanctnSn" />
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
															<table
																class="table table-sm table-bordered sanctnln-table m-0">
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
																						<span style="color: blue;
																							font-weight: bold;">${sanctnlnVO.sanctnSttusAsSTr}</span>
																					</c:when>
																					<c:when
																						test="${sanctnlnVO.sanctnSttus==2}">
																						<span style="color: red;
																							font-weight: bold;">${sanctnlnVO.sanctnSttusAsSTr}</span>
																					</c:when>
																					<c:otherwise>
																						<span>${sanctnlnVO.sanctnSttusAsSTr}</span>
																					</c:otherwise>
																				</c:choose>
																			</td>
																			<td class="align-middle">
																				<c:if
																					test="${sanctnlnVO.sanctnSttus==1}">
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
																				<span
																					class="badge badge-lg bg-light ml-2"
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
																							rows="2"
																							disabled>${sanctnlnVO.returnPrvonsh}</textarea>
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
																	<!-- 파일 목록 -->
																	<div class="list-group">
																		<c:forEach var="file"
																			items="${fileDetailVOList}">
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
									<a class="btn btn-warning btn-sm mr-1"
										href="/elctrnsanctn/getElctrnsanctnSentList">목록</a>
									<c:if test="${elctrnsanctnVO.drftTmprstre>0}">
										<div class="ml-auto">
											<button type="button" id="putElctrnsanctnFromTemp"
												class="btn btn-success btn-sm mr-1">수정</button>
											<button type="button" id="postElctrnsanctnFromTemp"
												class="btn btn-primary btn-sm">상신</button>
										</div>
									</c:if>
									<c:if test="${elctrnsanctnVO.totSanctnStts=='반려'}">
										<div class="ml-auto">
											<button type="button" id="postReElctrnsanctn"
												class="btn btn-info btn-sm">재상신</button>
										</div>
									</c:if>
								</div>
							</form>
						</div>
						<!-- /// body /// -->
						<%@ include file="../include/footer.jsp" %>

							<!-- pdv 다운로드 방식 필요 테이블 모양 -->
							<!-- <tr>
							<th rowspan="4">결재</th>
							<th>기안자</th>
							<c:forEach var="sanctnlnVO" items="${elctrnsanctnVO.sanctnlnVOList}">
								<td>결재자</td>
							</c:forEach>
						</tr>
						<tr>
							<td>
								${empVO.deptVO.deptNm}
							</td>						
							<c:forEach var="sanctnlnVO" items="${elctrnsanctnVO.sanctnlnVOList}">
								<td>${sanctnlnVO.empVO.deptVO.deptNm}</td>
							</c:forEach>
						</tr>
						<tr>
							<td>
								${empVO.nm} ${empVO.clsfName}
							</td>						
							<c:forEach var="sanctnlnVO" items="${elctrnsanctnVO.sanctnlnVOList}">
								<td>${sanctnlnVO.empVO.nm} ${sanctnlnVO.empVO.clsfName}</td>
							</c:forEach>
						</tr>						
						<tr>
							<td>
								상신								
							</td>
							<c:forEach var="sanctnlnVO" items="${elctrnsanctnVO.sanctnlnVOList}">
								<c:if test="${sanctnlnVO.sanctnSttusAsSTr=='반려'}">
									<td>
										<span style="color: red;">${sanctnlnVO.sanctnSttusAsSTr}</span>
									</td>
								</c:if>
								<c:if test="${sanctnlnVO.sanctnSttusAsSTr=='승인'}">
									<td>
										<img class="img-fluid w-75"
											src="/upload${sanctnlnVO.empVO.signVO.fileDetailVO.fileStrelc}">
									</td>
								</c:if>
							</c:forEach>
						</tr> -->
					<div class="modal fade" id="selectCcpyModal" style="display: none;" aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<div class="modal-header bg-primary">
									<h4 class="modal-title">🤝 계약서 전송 대상 협력사 선택</h4>
								</div>
								<div class="modal-body">
									<div class="card-body">
										<table class="table table-bordered table-hover table-sm text-center" id="ccpySelectTable" style="cursor: pointer;">
											<thead>
											<tr class="bg-light">
												<th class="col-1">선택</th>
												<th class="col-4">회사명</th>
												<th class="col-3">대표자</th>
												<th class="col-4">이메일</th>
											</tr>
											</thead>
											<tbody id="ccpyTableBody">
											<tr><td colspan="4">협력사 목록을 불러오는 중...</td></tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="modal-footer justify-content-between">
									<button type="button" class="btn btn-default btn-sm" data-dismiss="modal">닫기</button>
									<button type="button" id="confirmSendBtn" class="btn btn-sm btn-primary" disabled>
										<i class="fas fa-paper-plane mr-1"></i> 서명 요청
									</button>
								</div>
							</div>
						</div>
					</div>

					<input type="hidden" id="selectedCcpyEmail" />
					<input type="hidden" id="selectedCcpyName" />
				</body>

				</html>