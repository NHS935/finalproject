<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
					<!DOCTYPE html>
					<html>

					<head>
						<title>입찰하기</title>
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
						<!-- 스왈 -->
						<link rel="stylesheet" href="/css/sweetalert2.min.css">

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

							/* 파일 드롭 영역 */
							.file-drop-zone {
								border: 2px dashed lightseagreen;
								border-radius: 0.25rem;
								padding: 20px;
								text-align: center;
								background-color: #f8f9fa;
								cursor: pointer;
								transition: all 0.3s ease;
								min-height: 80px;
								display: flex;
								flex-direction: column;
								align-items: center;
								justify-content: center;
							}

							.file-drop-zone:hover {
								background-color: #e9ecef;
							}

							.file-drop-zone.dragover {
								background-color: #d1ecf1;
								border-color: #17a2b8;
							}

							.file-drop-zone.has-files {
								align-items: stretch;
								justify-content: flex-start;
								min-height: auto;
								padding: 10px;
							}

							.file-drop-zone.has-files .drop-placeholder {
								display: none;
							}

							.file-list-inside {
								width: 100%;
								max-height: 250px;
								overflow-y: auto;
							}

							.file-item {
								display: flex;
								align-items: center;
								justify-content: space-between;
								background-color: white;
								border: 1px solid #dee2e6;
								border-radius: 0.25rem;
								padding: 8px 10px;
								margin-bottom: 6px;
								min-height: auto;
								height: 36px;
							}

							.file-info {
								flex: 1;
								min-width: 0;
								text-align: left;
							}

							.file-name {
								font-size: 13px;
								font-weight: 400;
								white-space: nowrap;
								overflow: hidden;
								text-overflow: ellipsis;
								margin: 0;
							}

							.btn-remove {
								background: none;
								border: none;
								color: #dc3545;
								font-size: 20px;
								cursor: pointer;
								padding: 0 5px;
								flex-shrink: 0;
							}

							.btn-remove:hover {
								color: #c82333;
							}
						</style>

						<!-- 1. jQuery -->
						<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

						<!-- 2. Bootstrap Bundle (Popper 포함) -->
						<script
							src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

						<!-- 3. Moment.js (daterangepicker 의존성) -->
						<script src="/adminlte/plugins/moment/moment.min.js"></script>

						<!-- 4. Daterangepicker -->
						<script src="/adminlte/plugins/daterangepicker/daterangepicker.js"></script>

						<!-- 5. AdminLTE App -->
						<script src="/adminlte/dist/js/adminlte.min.js"></script>

						<!-- SweetAlert2 JS -->
						<script type="text/javascript" src="/js/sweetalert2.min.js"></script>

						<script>
							document.addEventListener("DOMContentLoaded", function () {

								// 입찰금 change 이벤트
								const smallUnits = ["", "십", "백", "천"];
								const bigUnits = ["", "만", "억", "조"];

								function numberToKorean(amount) {
									const numbers = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];

									let result = "";
									const strAmount = amount.toString();
									const len = strAmount.length;

									for (let i = 0; i < len; i++) {
										const num = parseInt(strAmount.charAt(i));
										const position = len - i - 1; // 자리수
										const smallUnitPos = position % 4;
										const bigUnitPos = Math.floor(position / 4);

										if (num !== 0) {
											if (!(num === 1 && smallUnitPos > 0)) {
												result += numbers[num];
											}
											result += smallUnits[smallUnitPos];
										}

										if (smallUnitPos === 0 && bigUnitPos > 0) {
											result += bigUnits[bigUnitPos];
										}
									}

									return "금 " + result + "원";
								}

								//입찰금 한글 표시
								document.querySelector("#bidAmount").addEventListener("input", function () {
									const amount = parseInt(this.value);
									const bidGtnRt = document.querySelector("#bidGtnRt").value
									let displayBidAmountKrw = "";

									if (!isNaN(amount) && amount > 0) {
										displayBidAmountKrw = numberToKorean(amount);
									} else {
										displayBidAmountKrw = "0원"; // 또는 공백 ""
									}
									document.querySelector("#bidAmountKrw").innerText = displayBidAmountKrw;
									document.querySelector("#bidGtn").placeholder = "금 " + amount * bidGtnRt / 100 + "원 이상 입력"
								})

								//보증금 한글 표시
								document.querySelector("#bidGtn").addEventListener("input", function () {
									const amount = parseInt(this.value);
									let displayBidGtnKrw = "";

									if (!isNaN(amount) && amount > 0) {
										displayBidGtnKrw = numberToKorean(amount);
									} else {
										displayBidGtnKrw = "0원"; // 또는 공백 ""
									}
									document.querySelector("#bidGtnKrw").innerText = displayBidGtnKrw;
								})

								//보증금 유효성 검증
								document.querySelector("#bidGtn").addEventListener("change", function () {
									const bidGtn = parseInt(this.value);
									const bidAmount = parseInt(document.querySelector("#bidAmount").value);
									const bidGtnRt = parseInt(document.querySelector("#bidGtnRt").value);

									const minBidGtn = Math.floor(bidAmount * bidGtnRt / 100);

									const bidGtnKrwSpan = document.querySelector("#bidGtnKrw");
									const submitBtn = document.querySelector("#bidSubmitBtn");

									// 유효성 검증
									if (bidGtn < minBidGtn) {
										// 경고 메시지 표시 (기존 한글 표시 덮어씀)
										Swal.fire({
											icon: 'error',
											title: '입찰보증금 부족',
											html: `<strong style="font-size: 16px;">입찰가격의 100분의\${bidGtnRt}이상을<br/>첨부하여야 입찰이 가능합니다</strong><br/><br/>
													<p style="font-size: 14px; color: #666;">
														최소 입찰보증금: <span style="color: red; font-weight: bold;">\${numberToKorean(minBidGtn)}</span>
													</p>`,
											confirmButtonText: '확인',
											confirmButtonColor: '#dc3545'
										});
										submitBtn.disabled = true; // 버튼 비활성화
									} else {
										// 정상 메시지 표시
										let displayBidGtnKrw = numberToKorean(bidGtn);
										bidGtnKrwSpan.innerHTML = displayBidGtnKrw;
										submitBtn.disabled = false; // 버튼 활성화
									}
								})

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

								//파일 업로드
								let uploadedFiles = [];
								const fileDropZone = document.querySelector("#fileDropZone");
								const fileList = document.querySelector("#fileList");
								const inputFiles = document.querySelector("#inputFiles");

								fileDropZone.addEventListener("click", function () {
									inputFiles.click();
								});

								function fover(event) {
									event.preventDefault();
									fileDropZone.classList.add("dragover");
								}

								function fleave(event) {
									event.preventDefault();
									fileDropZone.classList.remove("dragover");
								}

								function fdrop(event) {
									event.preventDefault();
									fileDropZone.classList.remove("dragover");

									const dataFiles = Array.from(event.dataTransfer.files);
									dataFiles.forEach(file => readOneFile(file));
								}

								function readOneFile(pFile) {
									if (uploadedFiles.some(f => f.name === pFile.name && f.size === pFile.size)) {
										alert("이미 추가된 파일입니다");
										return;
									}
									pFile.fileId = Date.now() + Math.random();
									uploadedFiles.push(pFile);
									displayFileItem(pFile);
								}

								function displayFileItem(file) {
									if (fileList.children.length === 0) {
										fileDropZone.classList.add("has-files");
									}

									const fileItem = document.createElement("div");
									fileItem.className = "file-item";
									fileItem.dataset.fileId = file.fileId;
									fileItem.innerHTML = `
                                <div class="file-info">
                                    <div class="file-name" title="\${file.name}">
                                        <i class="fas fa-file"></i> \${file.name}
                                    </div>
                                </div>
                                <button type="button" class="btn-remove" onclick="removeFileItem(this)">×</button>
                            `;
									fileList.appendChild(fileItem);
								}

								window.removeFileItem = function (btn) {
									const fileItem = btn.closest(".file-item");
									const fileId = fileItem.dataset.fileId;

									uploadedFiles = uploadedFiles.filter(f => f.fileId != fileId);
									fileItem.remove();

									if (fileList.children.length === 0) {
										fileDropZone.classList.remove("has-files");
									}
								};

								inputFiles.addEventListener("change", function (e) {
									Array.from(e.target.files).forEach(file => readOneFile(file));
								});

								window.fover = fover;
								window.fleave = fleave;
								window.fdrop = fdrop;
								//파일업로드

								//form Submit
								document.querySelector("#postBdderForm").addEventListener("submit", function (e) {
									e.preventDefault();
									const form = this;
									Swal.fire({
										icon: 'question',
										title: '입찰을 진행하시겠습니까?',
										text: '입찰 후에는 수정하실 수 없습니다.',
										showCancelButton: true,
										confirmButtonText: '입찰하기',
										cancelButtonText: '취소',
										confirmButtonColor: '#28a745',
										cancelButtonColor: '#6c757d',
										width: 400,
										allowOutsideClick: false,
										allowEscapeKey: false
									}).then((result) => {
										if (result.isConfirmed) {
											const formData = new FormData(form);
											form.submit();
										}
									});
								});
							});					
						</script>
					</head>

					<body class="layout-boxed">
						<div class="wrapper">
							<%@ include file="../bidPblanc/include/header.jsp" %>
								<section class="content">
									<div class="container-fluid">
										<div class="card">
											<div class="card-header bg-lightblue disabled">
												<h3 class="card-title">입찰</h3>
											</div>
											<form id="postBdderForm" action="/bdder/postBdder" method="post"
												enctype="multipart/form-data">
												<div class="row card-body">
													<!-- 왼쪽 파트 -->
													<div class="col-6 card-primary">
														<div class="card-header">
															<h3 class="card-title">입찰 상세</h3>
														</div>
														<!-- 여기가 입찰 상세 내용 및 입찰 서 작성 칸 -->
														<table class="table table-bordered table-sm">
															<tbody>
																<tr>
																	<th class="bg-light col-2 text-center">입찰번호</th>
																	<td colspan="3">${bidPblancVO.bidPblancSnAsStr}
																		<input type="hidden"
																			value="${bidPblancVO.bidPblancSn}"
																			name="bidPblancSn" />
																	</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">입찰제목</th>
																	<td colspan="3">${bidPblancVO.bidSj}</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">낙찰방법</th>
																	<td class="col-4">${bidPblancVO.scsbMthAsStr}</td>
																	<th class="bg-light col-2 text-center">입찰보증금</th>
																	<td class="col-4">입찰가격의[<span
																			style="color: red; font-weight: bold;">${bidPblancVO.bidGtnRt}</span>]%이상
																		제출</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">공고 시작일</th>
																	<td>
																		<fmt:formatDate value="${bidPblancVO.pblancDt}"
																			pattern="yyyy-MM-dd" />
																	</td>
																	<th class="bg-light col-2 text-center">입찰 마감일</th>
																	<td>
																		<fmt:formatDate
																			value="${bidPblancVO.bidClosDtAsDate}"
																			pattern="yyyy-MM-dd" />
																	</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">신용평가등급확인서
																	</th>
																	<td>${bidPblancVO.cdltPresentnAtAsStr}</td>
																	<th class="bg-light col-2 text-center">관리실적증명서</th>
																	<td>${bidPblancVO.acmsltproofPresentnAtAsStr}</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">현장설명</th>
																	<td colspan="3">${bidPblancVO.sptdcAtAsStr}</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">현장설명일시</th>
																	<td>
																		<c:if test="${empty bidPblancVO.sptdcDtAsDate}">
																			해당없음
																		</c:if>
																	</td>
																	<th class="bg-light col-2 text-center">현장설명장소</th>
																	<td>
																		<c:if test="${empty bidPblancVO.sptdcPlace}">
																			해당없음
																		</c:if>
																	</td>
																</tr>
																<tr>
																	<th class="bg-light col-2 text-center">내용</th>
																	<td colspan="3">${bidPblancVO.bidCn}</td>
																</tr>

																<tr>
																	<th class="bg-light col-2 text-center align-middle">
																		첨부파일
																	</th>
																	<td colspan="3">
																		<c:choose>
																			<c:when
																				test="${empty bidPblancFileDetailVOList}">
																				<p class="text-muted">첨부파일이 없습니다.</p>
																			</c:when>
																			<c:otherwise>
																				<!-- 전체 선택 영역 -->
																				<div
																					class="bg-light p-2 mb-2 d-flex align-items-center">
																					<label for="previewFiles"
																						class="mb-0">미리보기</label>
																				</div>
																				<!-- 파일 목록 -->
																				<div class="list-group">
																					<c:forEach var="file"
																						items="${bidPblancFileDetailVOList}">
																						<a class="list-group-item list-group-item-action d-flex align-items-center"
																							data-file-group-sn="${file.fileGroupSn}"
																							data-file-no="${file.fileNo}"
																							style="cursor: pointer;">
																							<i
																								class="fa fa-file mr-2"></i>
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
														<!-- 입찰가 적는 부분 -->
														<div class="card card-secondary">
															<!-- /.card-header -->
															<div class="card-header">
																<h3 class="card-title">입찰서</h3>
															</div>
															<!-- /.card-header -->
															<!-- /.card-body -->
															<table class="table table-bordered table-sm">
																<tbody>
																	<tr>
																		<th class="bg-light text-center">입찰번호</th>
																		<td colspan="3">${bidPblancVO.bidPblancSnAsStr}
																		</td>
																	</tr>
																	<tr>
																		<th class="bg-light text-center">입찰 명칭</th>
																		<td colspan="3">${bidPblancVO.bidSj}</td>
																	</tr>
																	<tr>
																		<th rowspan="2"
																			class="bg-light text-center align-middle">
																			입찰가액
																		</th>
																		<td colspan="3">
																			<input type="number"
																				class="form-control form-control-border border-width-2 bdderVO"
																				id="bidAmount" name="bidAmount"
																				placeholder="금액 입력(원)">
																		</td>
																	</tr>
																	<tr>
																		<td colspan="3" style="text-align: right;">
																			<span id="bidAmountKrw"></span>
																		</td>
																	</tr>
																	<tr>
																		<th rowspan="2"
																			class="bg-light text-center align-middle">
																			입찰보증금
																		</th>
																		<td colspan="3">
																			<input type="number"
																				class="form-control form-control-border border-width-2 bdderVO"
																				id="bidGtn" name="bidGtn"
																				placeholder="입찰가격의 100분의 ${bidPblancVO.bidGtnRt}이상">
																		</td>
																	</tr>
																	<tr>
																		<td colspan="3" style="text-align: right;">
																			<span id="bidGtnKrw"></span>
																		</td>
																	</tr>
																	<tr>
																		<td colspan="4" class="text-center">
																			<p class="mb-2">
																				위와 같이 입찰보증금(입찰가격의 100분의
																				<span
																					style="color: red; font-weight: bold;">${bidPblancVO.bidGtnRt}</span>
																				이상)을 첨부하여 입찰합니다.
																			</p>
																			<input type="hidden" id="bidGtnRt"
																				value="${bidPblancVO.bidGtnRt}" />
																			<h4 class="mb-0">
																				<fmt:formatDate value="${now}"
																					pattern="yyyy년 MM월 dd일" />
																			</h4>
																		</td>
																	</tr>
																</tbody>
															</table>
															<div class="card-footer text-center">
																<p>D-편한아파트 관리사무소장 귀중</p>
																<button id="bidSubmitBtn" type="submit"
																	class="btn btn-success">입찰하기</button>
															</div>

														</div>
														<!-- 입찰가 적는 부분 -->
													</div>
													<!-- 왼쪽 파트 -->

													<!-- 오른쪽  파트 -->
													<div class="col-6 card-secondary">
														<!-- 여기서부터는 입찰 협력업체 상세 내용 및 추가 첨부 자료 -->
														<div class="card-header">
															<h3 class="card-title">입찰자</h3>
														</div>
														<!-- /.card-header -->
														<!-- /.card-body -->
														<table class="table table-bordered table-sm">
															<tbody>
																<tr>
																	<th class="col-2 bg-light text-center">상호(명)</th>
																	<td>${ccpyManageVO.ccpyCmpnyNm}
																		<input type="hidden" name="ccpyManageId"
																			value="${ccpyManageVO.ccpyManageId}" />
																	</td>
																</tr>
																<tr>
																	<th class="col-2 bg-light text-center">대표(명)</th>
																	<td>${ccpyManageVO.ccpyRprsntvNm}</td>
																</tr>
																<tr>
																	<th class="col-2 bg-light text-center">사업자 등록 번호
																	</th>
																	<td>${ccpyManageVO.ccpyBizrno}</td>
																</tr>
																<tr>
																	<th class="col-2 bg-light text-center">주소</th>
																	<td>${ccpyManageVO.ccpyAdres}</td>
																</tr>
																<tr>
																	<th class="col-2 bg-light text-center">전화번호</th>
																	<td>${ccpyManageVO.ccpyTelno}</td>
																</tr>
																<tr>
																	<th class="col-2 bg-light text-center">이메일주소</th>
																	<td>${ccpyManageVO.ccpyEmail}</td>
																</tr>
																<tr>
																	<th class="bg-light" colspan="4">사업자 등록증</th>
																</tr>
																<tr>
																	<td colspan="4">
																		<img class="col-12"
																			src="/upload${ccpyFileDetailVOList[0].fileStrelc}" />
																	</td>
																</tr>
															</tbody>
															<tfoot>
																<!-- 여기서부터는 입찰 협력업체 상세 내용 및 추가 첨부 자료 -->
																<tr>
																	<th class="bg-light" colspan="4">
																		필수제출서류 첨부하기
																	</th>
																</tr>
																<tr>
																	<td colspan="4">
																		<div class="form-group mb-0">
																			<div class="file-drop-zone"
																				id="fileDropZone"
																				ondragover="fover(event)"
																				ondragleave="fleave(event)"
																				ondrop="fdrop(event)"
																				title="파일을 여기에 드래그하거나 클릭하세요">
																				<div class="drop-placeholder">
																					<i
																						class="fas fa-cloud-upload-alt fa-2x text-muted mb-2"></i>
																					<p class="text-muted mb-0">파일을
																						드래그하거나 선택하세요</p>
																				</div>
																				<div class="file-list-inside"
																					id="fileList"></div>
																			</div>
																			<input class="d-none" type="file"
																				id="inputFiles" name="inputFiles"
																				multiple>
																		</div>
																	</td>
																</tr>
															</tfoot>
														</table>
														<!-- /.card-body -->
													</div>

												</div>

											</form>
										</div>
										<!-- 오른쪽  파트 -->
									</div>
								</section>
								<!--/// body /// -->
						</div>
						<!-- /// body /// -->
						<footer class="footer">
							<div class="float-right d-none d-sm-block">
								<b>Version</b> 3.2.0
							</div>
							<strong>Copyright © 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.
							</strong> All rights reserved.
						</footer>
					</body>

					</html>