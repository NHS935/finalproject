<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title></title>
					<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
					<script src="https://cdn.jsdelivr.net/npm/lottie-web@latest/build/player/lottie.min.js"></script>
					<style>
						#previewContainer {
							min-height: 300px;
							height: auto;
							overflow: visible;
							border: 1px solid #dee2e6;
							border-radius: 0.25rem;
							padding: 10px;
						}

						#previewContainer img {
							max-width: 100%;
							height: auto;
							display: block;
						}

						/* 파일 리스트 컨테이너 */
						.file-drop-zone {
							border: 1px solid #dee2e6;
							border-radius: 0.25rem;
							padding: 10px;
							background-color: #f8f9fa;
							cursor: default;
							min-height: auto;
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

						/* 메일링 모달 */
						#loadingModal.modal {
							position: fixed;
							top: 0;
							left: 0;
							width: 100%;
							height: 100%;
							z-index: 9999;
						}

						#loadingModal .modal-dialog {
							position: absolute;
							top: 50%;
							left: 50%;
							transform: translate(-50%, -50%);
						}

						#loadingModal.modal-backdrop {
							z-index: 9998;
						}
					</style>
				</head>

				<body>
					<%@ include file="../include/header.jsp" %>

						<div class="card card-primary">
							<div class="card-header">
								<h3 class="card-title">업체 상세</h3>
							</div>

							<div class="row card-body">
								<!-- 좌측: 기본 정보 -->
								<div class="col-6">
									<div class="form-group">
										<label for="ccpyCmpnyNm">업체 명</label>
										<input type="text" class="form-control" name="ccpyCmpnyNm" id="ccpyCmpnyNm"
											value="${ccpyManageVO.ccpyCmpnyNm}" readonly>
										<input type="hidden" id="ccpyManageId" value="${ccpyManageVO.ccpyManageId}">
									</div>
									<div class="form-group">
										<label for="ccpyBizrno">사업자 등록 번호</label>
										<input type="text" class="form-control" name="ccpyBizrno" id="ccpyBizrno"
											value="${ccpyManageVO.ccpyBizrno}" readonly>
									</div>
									<div class="form-group">
										<label for="ccpyRprsntvNm">대표자 명</label>
										<input type="text" class="form-control" name="ccpyRprsntvNm" id="ccpyRprsntvNm"
											value="${ccpyManageVO.ccpyRprsntvNm}" readonly>
									</div>
									<div class="form-group">
										<label for="ccpyEmail">이메일주소</label>
										<input type="email" class="form-control" name="ccpyEmail" id="ccpyEmail"
											value="${ccpyManageVO.ccpyEmail}" readonly>
									</div>
									<!-- <div class="form-group">
										<label for="ccpyPassword">비밀번호</label>
										<input type="password" class="form-control" name="ccpyPassword"
											id="ccpyPassword" value="${ccpyManageVO.ccpyPassword}" readonly>
									</div> -->
									<div class="form-group">
										<label for="ccpyTelno">전화번호</label>
										<input type="text" class="form-control" name="ccpyTelno" id="ccpyTelno"
											value="${ccpyManageVO.ccpyTelno}" readonly>
									</div>
									<div class="form-group">
										<label for="ccpyAdres">주소</label>
										<input type="text" class="form-control" name="ccpyAdres" id="ccpyAdres"
											value="${ccpyManageVO.ccpyAdres}" readonly>
									</div>
									<div class="form-group">
										<label for="ccpyOpbizDe">개업연월일</label>
										<input type="date" class="form-control" name="ccpyOpbizDe" id="ccpyOpbizDe"
											value="<fmt:formatDate value='${ccpyManageVO.ccpyOpbizDe}' pattern='yyyy-MM-dd'/>" readonly>
									</div>
									<div class="form-group">
										<label>업태/업종</label>
										<div id="bizcndIndutyContainer">
											<c:forEach var="item" items="${ccpyManageVO.bizcndIndutyVOList}">
												<div class="row mb-2">
													<div class="col-6">
														<input type="text" class="form-control"
															name="${not empty item.bizcndNm ? item.bizcndNm : ''}"
															value="${not empty item.bizcndNm ? item.bizcndNm : ''}"
															readonly>
													</div>
													<div class="col-6">
														<input type="text" class="form-control"
															name="${not empty item.indutyNm ? item.indutyNm : ''}"
															value="${not empty item.indutyNm ? item.indutyNm : ''}"
															readonly>
													</div>
												</div>
											</c:forEach>
										</div>
									</div>
								</div>

								<!-- 우측: 파일 첨부 -->
								<div class="col-6">
									<div class="form-group">
										<label for="fileDetailVOList">신청 일자</label>
										<input type="date" class="form-control" name="ccpyRegistdt"
											id="ccpyRegistdt" value="<fmt:formatDate value='${ccpyManageVO.ccpyRegistdt}' pattern='yyyy-MM-dd'/>" readonly>
									</div>
									<!-- 사업자등록증 미리보기 -->
									<div class="form-group">
										<label for="fileDetailVOList">사업자등록증</label>
										<div id="licenseFileName" style="font-size: 12px; color: #6c757d;">
											${fileDetailVOList[0].fileOrginlNm}
										</div>
										<div class="bg-light d-flex align-items-center justify-content-center"
											id="previewContainer">
											<img src="/upload${fileDetailVOList[0].fileStrelc}" class="img-fluid"
												id="previewImage" style="display: block;">
										</div>
									</div>

									<!-- 추가 서류 첨부 -->
									<div class="form-group">
										<label>지원 서류 (인증서, 자격증, 경력증명 등)</label>
										<div class="file-drop-zone">
											<div class="file-list-inside">
												<c:choose>
													<c:when test="${empty ccpyDtaFileDetailVOList}">
														<p class="text-muted">첨부파일이 없습니다.</p>
													</c:when>
													<c:otherwise>
														<!-- 전체 선택 영역 -->
														<div class="bg-light p-2 mb-2 d-flex align-items-center">
															<input type="checkbox" id="checkAll" class="mr-2" />
															<label for="checkAll" class="mb-0">전체선택</label>
														</div>

														<!-- 파일 목록 -->
														<div class="list-group">
															<c:forEach var="file" items="${ccpyDtaFileDetailVOList}">
																<a href="/ccpyManage/download?fileGroupSn=${file.fileGroupSn}&fileNo=${file.fileNo}"
																	class="list-group-item list-group-item-action d-flex align-items-center"
																	data-file-group-sn="${file.fileGroupSn}"
																	data-file-no="${file.fileNo}" target="_blank">
																	<input type="checkbox" class="fileCheck mr-2"
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
																class="btn btn-warning btn-sm">선택
																다운로드</button>
														</div>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="card-footer d-flex justify-content-center">
								<button type="button" id="sendCcpyApprovalEmail" class="btn btn-primary">승인</button>
								<button type="button" id="sendCcpyRejectionEmail"
									class="btn btn-danger ml-2">반려</button>
								<a href="/ccpyManage/getCcpyManageGuestList" id="backToList"
									class="btn btn-secondary ml-2">목록</a>
							</div>
						</div>

						<%@ include file="../include/footer.jsp" %>
							<div class="modal fade" id="loadingModal" style="display: none;" aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered">
									<div class="modal-content">
										<div class="modal-header border-0">
											<h5 class="modal-title w-100 text-center">이메일 전송 중</h5>
										</div>
										<div class="modal-body text-center">
											<div id="lottie-container" style="height: 200px;"></div>
											<p class="text-muted">잠시만 기다려주세요.</p>
										</div>
									</div>
								</div>
							</div>
				</body>

				<script type="text/javascript">
					document.addEventListener("DOMContentLoaded", function () {
						document.querySelector("#sendCcpyApprovalEmail").addEventListener("click", function () {

							const loadingModal = new bootstrap.Modal(
								document.getElementById('loadingModal'),
								{ backdrop: 'static', keyboard: false }
							);
							loadingModal.show();

							// 로티 애니메이션
							if (window.lottieAnimation) {
								window.lottieAnimation.destroy();
							}

							window.lottieAnimation = lottie.loadAnimation({
								container: document.getElementById('lottie-container'),
								renderer: 'svg',
								loop: true,
								autoplay: true,
								path: '/animations/mailing.json'
							});

							async function sendCcpyApprovalEmail() {
								try {
									const ccpyManageId = document.querySelector("#ccpyManageId").value;
									const data = {
										"ccpyManageId": ccpyManageId
									}
									const response = await axios.post("/ccpyManage/sendCcpyApprovalEmail", data);
									setTimeout(()=>{
										if (response.data.success) {
										loadingModal.hide();
										console.log("check : response.data.message => ", response.data.message);
										document.querySelector("#sendCcpyApprovalEmail").style.display = "none";
										document.querySelector("#sendCcpyRejectionEmail").style.display = "none";
									}
									}, 2500);
								} catch (err) {
									console.log("error => ", err);
								}
							}
							sendCcpyApprovalEmail();
						})

						document.querySelector("#sendCcpyRejectionEmail").addEventListener("click", function () {

							const loadingModal = new bootstrap.Modal(
								document.getElementById('loadingModal'),
								{ backdrop: 'static', keyboard: false }
							);
							loadingModal.show();

							// 로티 애니메이션
							if (window.lottieAnimation) {
								window.lottieAnimation.destroy();
							}

							window.lottieAnimation = lottie.loadAnimation({
								container: document.getElementById('lottie-container'),
								renderer: 'svg',
								loop: true,
								autoplay: true,
								path: '/animations/mailing.json'
							});

							async function sendCcpyRejectionEmail() {
								try {
									const ccpyManageId = document.querySelector("#ccpyManageId").value;
									const data = {
										"ccpyManageId": ccpyManageId
									}
									const response = await axios.post("/ccpyManage/sendCcpyRejectionEmail", data);
									if (response.data.success) {
										loadingModal.hide();
										console.log("check : response.data.message => ", response.data.message);
										document.querySelector("#sendCcpyApprovalEmail").style.display = "none";
										document.querySelector("#sendCcpyRejectionEmail").style.display = "none";
									}
								} catch (err) {
									console.log("error => ", err);
								}
							}
							sendCcpyRejectionEmail();
						})
					});
				</script>

				</html>