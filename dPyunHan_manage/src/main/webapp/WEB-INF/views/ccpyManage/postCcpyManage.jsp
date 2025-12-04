<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
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

						/* 파일 드롭 영역 */
						.file-drop-zone {
							border: 2px dashed #007bff;
							border-radius: 0.25rem;
							padding: 20px;
							text-align: center;
							background-color: #f8f9fa;
							cursor: pointer;
							transition: all 0.3s ease;
							min-height: 150px;
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
				</head>

				<body class="layout-boxed">
					<div class="wrapper">
						<section class="content-header bg-primary mb-3">
							<div class="container-fluid">
								<div class="row mb-2">
									<div class="col-sm-6">
										<h1 class="ml-3"><b>D-PyunHan 전자 입찰</b></h1>
									</div>
									<div class="col-sm-6">
										<ol class="breadcrumb float-sm-right">
											<li class="breadcrumb-item"><a style="color: white;" href="/login">Home</a>
											</li>
											<li class="breadcrumb-item"><a style="color: white;"
													href="/bidPblanc/getBidPblancList">List</a></li>
											<li class="breadcrumb-item"><a style="color: white;" href="#">Contact</a>
											</li>
										</ol>
									</div>
								</div>
							</div><!-- /.container-fluid -->
						</section>

						<div class="card card-primary">
							<div class="bg-lightblue card-header">
								<h3 class="card-title">업체 정보</h3>
							</div>

							<form action="/ccpyManage/postCcpyManage" method="post" enctype="multipart/form-data">
								<div class="row card-body">
									<!-- 좌측: 기본 정보 -->
									<div class="col-6">
										<div class="form-group">
											<label for="ccpyCmpnyNm">업체 명</label>
											<input type="text" class="form-control" name="ccpyCmpnyNm" id="ccpyCmpnyNm"
												placeholder="사업자등록증을 첨부하면 자동으로 정보가 입력됩니다." readonly>
										</div>
										<div class="form-group">
											<label for="ccpyBizrno">사업자 등록 번호</label>
											<input type="text" class="form-control" name="ccpyBizrno" id="ccpyBizrno"
												placeholder="사업자등록증을 첨부하면 자동으로 정보가 입력됩니다." readonly>
										</div>
										<div class="form-group">
											<label for="ccpyRprsntvNm">대표자 명</label>
											<input type="text" class="form-control" name="ccpyRprsntvNm"
												id="ccpyRprsntvNm" placeholder="사업자등록증을 첨부하면 자동으로 정보가 입력됩니다." readonly>
										</div>
										<div class="form-group">
											<label for="ccpyEmail">이메일주소</label>
											<input type="email" class="form-control" name="ccpyEmail" id="ccpyEmail"
												placeholder="로그인시 사용할 이메일 주소를 입력해주세요.">
										</div>
										<div class="form-group">
											<label for="ccpyPassword">비밀번호</label>
											<input type="password" class="form-control" name="ccpyPassword"
												id="ccpyPassword" placeholder="비밀번호를 입력해주세요.">
										</div>
										<div class="form-group">
											<label for="ccpyTelno">전화번호</label>
											<input type="text" class="form-control" name="ccpyTelno" id="ccpyTelno"
												placeholder="전화번호를 입력해주세요.">
										</div>
										<div class="form-group">
											<label for="ccpyAdres">주소</label>
											<input type="text" class="form-control" name="ccpyAdres" id="ccpyAdres"
												placeholder="사업자등록증을 첨부하면 자동으로 정보가 입력됩니다." readonly>
										</div>
										<div class="form-group">
											<label for="ccpyOpbizDe">개업연월일</label>
											<input type="date" class="form-control" name="ccpyOpbizDe" id="ccpyOpbizDe"
												placeholder="사업자등록증을 첨부하면 자동으로 정보가 입력됩니다." readonly>
										</div>
										<div class="form-group">
											<label>업태/업종</label>
											<div id="bizcndIndutyContainer"></div>
										</div>
									</div>

									<!-- 파일 첨부 -->
									<div class="col-6">
										<!-- 사업자등록증 이미지 -->
										<div class="form-group">
											<label for="uploadFile">사업자등록증</label>
											<label class="btn btn-sm btn-primary" for="uploadFile">
												<i class="fas fa-upload"></i> 파일 선택
											</label>
											<!-- 사업자등록증 파일 -->
											<input class="d-none" type="file" id="uploadFile" name="uploadFile"
												accept="image/*">
											<div class="mt-2" id="licenseFileName"
												style="font-size: 12px; color: #6c757d;">
											</div>
										</div>

										<!-- 사업자등록증 미리보기 -->
										<div class="form-group">
											<div class="bg-light d-flex align-items-center justify-content-center"
												id="previewContainer">
												<img src="" class="img-fluid" id="previewImage" style="display: none;">
												<div id="previewPlaceholder" class="text-muted text-center p-4">
													<i class="fas fa-image fa-3x mb-2"></i>
													<p>사업자등록증 미리보기</p>
												</div>
											</div>
										</div>

										<!-- 추가 서류 첨부 -->
										<div class="form-group">
											<label for="supportingDocsInput">지원 서류 (인증서, 자격증, 경력증명 등)</label>
											<div class="file-drop-zone" id="fileDropZone" ondragover="fover(event)"
												ondragleave="fleave(event)" ondrop="fdrop(event)"
												title="파일을 여기에 드래그하거나 클릭하세요">
												<div class="drop-placeholder">
													<i class="fas fa-cloud-upload-alt fa-2x text-muted mb-2"></i>
													<p class="text-muted mb-0">파일을 드래그하거나 선택하세요</p>
												</div>
												<div class="file-list-inside" id="fileList"></div>
											</div>
											<input class="d-none" type="file" id="supportingDocsInput"
												name="ccpyDtaList" multiple>
										</div>
									</div>
								</div>

								<div class="card-footer text-right">
									<button type="submit" class="btn btn-primary">가입</button>
									<button type="reset" class="btn btn-secondary">초기화</button>
								</div>
							</form>
						</div>
					</div>

					<footer class="footer">
						<div class="float-right d-none d-sm-block">
							<b>Version</b> 3.2.0
						</div>
						<strong>Copyright © 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.
						</strong> All rights reserved.
					</footer>

					<!-- 로딩 모달 -->
					<div class="modal fade" id="loadingModal" style="display: none;" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
								<div class="modal-header border-0">
									<h5 class="modal-title w-100 text-center">사업자등록증 분석중</h5>
								</div>
								<div class="modal-body text-center">
									<div id="lottie-container" style="height: 200px;"></div>
									<p class="text-muted">잠시만 기다려주세요.</p>
								</div>
							</div>
						</div>
					</div>
				</body>

				<!-- ==================== JavaScript 파일 (순서 중요) ==================== -->

				<!-- 1. jQuery (가장 먼저) -->
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

				<!-- 2. Bootstrap Bundle (Popper 포함) -->
				<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

				<!-- 3. Moment.js (daterangepicker 의존성) -->
				<script src="/adminlte/plugins/moment/moment.min.js"></script>

				<!-- 4. Daterangepicker -->
				<script src="/adminlte/plugins/daterangepicker/daterangepicker.js"></script>

				<!-- 5. AdminLTE App -->
				<script src="/adminlte/dist/js/adminlte.min.js"></script>

				<!-- 6. 외부 라이브러리 -->
				<script src="https://cdn.jsdelivr.net/npm/lottie-web@latest/build/player/lottie.min.js"></script>
				<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

				<script type="text/javascript">
					document.addEventListener("DOMContentLoaded", function () {
						// 사업자등록증 첨부
						document.querySelector("#uploadFile").addEventListener("change", async function () {
							const file = this.files[0];

							// 파일 미리보기
							if (file) {
								document.querySelector("#licenseFileName").innerText = file.name;

								const previewImage = document.querySelector("#previewImage");
								const previewPlaceholder = document.querySelector("#previewPlaceholder");
								const reader = new FileReader();

								reader.onload = function (e) {
									previewImage.src = e.target.result;
									previewImage.style.display = 'block';
									previewPlaceholder.style.display = 'none';
								}
								reader.readAsDataURL(file);
							}

							// 로딩 모달 표시
							const loadingModal = new bootstrap.Modal(
								document.getElementById('loadingModal'),
								{ backdrop: 'static', keyboard: false }
							);
							loadingModal.show();

							// 로티 애니메이션
							if (window.lottieAnimation) {
								window.lottieAnimation.destroy();
							}

							try {
								const response = await fetch('/animations/loading(2).json');
								if (!response.ok) {
									throw new Error('JSON 파일 로드 실패');
								}
								const animationData = await response.json();

								window.lottieAnimation = lottie.loadAnimation({
									container: document.getElementById('lottie-container'),
									renderer: 'svg',
									loop: true,
									autoplay: true,
									animationData: animationData
								});
							} catch (error) {
								console.error('Lottie 로드 실패:', error);
								loadingModal.hide();
								return;
							}

							// 서버로 전송
							const formData = new FormData();
							formData.append('uploadFile', file);

							fetch('/ccpyManage/postBizLicense', {
								method: 'POST',
								body: formData
							})
								.then(response => {
									if (response.ok) {
										console.log("check : postBizLicense => 성공");
									}
									return response.json()
								})
								.then(data => {
									setTimeout(() => {


										loadingModal.hide();
										console.log("check : data.ccpyManageVO =>", data.ccpyManageVO);

										document.getElementById('ccpyCmpnyNm').value = data.ccpyManageVO.ccpyCmpnyNm || '';
										document.getElementById('ccpyBizrno').value = data.ccpyManageVO.ccpyBizrno || '';
										document.getElementById('ccpyRprsntvNm').value = data.ccpyManageVO.ccpyRprsntvNm || '';
										document.getElementById('ccpyAdres').value = data.ccpyManageVO.ccpyAdres || '';
										document.getElementById('ccpyTelno').value = data.ccpyManageVO.ccpyTelno || '';

										// 개업연월일 처리
										if (data.ccpyManageVO.ccpyOpbizDe) {
											const date = new Date(data.ccpyManageVO.ccpyOpbizDe);
											document.getElementById('ccpyOpbizDe').value =
												date.toISOString().split('T')[0];
										}

										// 업태/업종 처리
										if (data.ccpyManageVO.bizcndIndutyVOList &&
											data.ccpyManageVO.bizcndIndutyVOList.length > 0) {
											createBizcndIndutyInputs(data.ccpyManageVO.bizcndIndutyVOList);
										}
									}, 2000)
								})
								.catch(error => {
									console.log("error => ", error);
									loadingModal.hide();
								});
						});

						// 업태/업종 생성
						function createBizcndIndutyInputs(bizcndIndutyList) {
							const container = document.getElementById('bizcndIndutyContainer');
							container.innerHTML = '';

							bizcndIndutyList.forEach((item, index) => {
								const cardDiv = document.createElement('div');
								cardDiv.className = 'form-row mb-3';
								cardDiv.innerHTML = `
                                    <div class="col-6">
                                        <input type="text" 
                                            class="form-control" 
                                            name="bizcndIndutyVOList[\${index}].bizcndNm"
                                            value="\${item.bizcndNm || ''}"
                                            readonly>
                                    </div>
                                    <div class="col-6">
                                        <input type="text" 
                                            class="form-control" 
                                            name="bizcndIndutyVOList[\${index}].indutyNm"
                                            value="\${item.indutyNm || ''}"
                                            readonly>
                                    </div>
                                `;
								container.appendChild(cardDiv);
							});
						}

						// 추가 서류 파일 업로드
						let uploadedFiles = [];
						const fileDropZone = document.querySelector("#fileDropZone");
						const fileList = document.querySelector("#fileList");
						const supportingDocsInput = document.querySelector("#supportingDocsInput");

						// 드롭 존 클릭 시
						fileDropZone.addEventListener("click", function () {
							supportingDocsInput.click();
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

						supportingDocsInput.addEventListener("change", function (e) {
							Array.from(e.target.files).forEach(file => readOneFile(file));
						});

						window.fover = fover;
						window.fleave = fleave;
						window.fdrop = fdrop;
					});
				</script>

				</html>