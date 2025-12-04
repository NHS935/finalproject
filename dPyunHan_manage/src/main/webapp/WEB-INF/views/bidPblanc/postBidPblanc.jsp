<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title>공고 올리기</title>
				</head>

				<style>
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

					.cke_notification {
						display: none !important;
					}
				</style>

				<!-- CK에디터 -->
				<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

				<script>
					document.addEventListener("DOMContentLoaded", function () {
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

						//CKEDITOR
						let editorInstance = null;
						if (window.CKEDITOR) {
							CKEDITOR.replace('bidCn', {
								height: '200px',
								allowedContent: true,
								contentsCss: '/css/contract.css',
								toolbar: [
									{ name: 'basicstyles', items: ['Bold', 'Italic', 'Underline'] },
									{ name: 'paragraph', items: ['BulletedList', 'NumberedList'] }
								],
								on: {
									instanceReady: function (evt) {
										editorInstance = evt.editor;
									}
								}
							});
						} else {
							console.warn('CKEditor 로드 안됨');
						}
						//CKEDITOR

						//현장 설명 일시 display
						document.querySelector("#sptdcAt1").addEventListener("change", function () {
							if (this.checked) {
								document.querySelector("#sptdcAtDisplay").style.display = "table-row";
							}
						});

						document.querySelector("#sptdcAt0").addEventListener("change", function () {
							if (this.checked) {
								document.querySelector("#sptdcAtDisplay").style.display = "none";
							}
						});
						//현장 설명 일시 display

						// 폼 submit
						document.querySelector("#postBidPblancVOForm").addEventListener("submit", function (e) {
							e.preventDefault();

							const formData = new FormData();

							document.querySelectorAll(".bidPblancVO").forEach(elem => {
								let name = elem.getAttribute("name");

								if (elem.offsetParent === null) {
									return;
								}

								if (elem.type === "radio") {
									if (elem.checked) {
										formData.append(name, elem.value);
									}
								} else if (elem.type === "checkbox") {
									formData.append(name, elem.checked ? 1 : 0);
								} else {
									formData.append(name, elem.value);
								}
							});

							if (editorInstance) {
								const editorData = editorInstance.getData();
								formData.append("bidCn", editorData);
							} else {
								console.warn("CKEditor 인스턴스 없음");
							}

							if (uploadedFiles.length > 0) {
								uploadedFiles.forEach(file => {
									formData.append("uploadFiles", file);
								});
							}

							console.log("=== FormData 최종 확인 ===");
							for (let pair of formData.entries()) {
								console.log(pair[0], ":", pair[1]);
							}

							fetch("/bidPblanc/postBidPblanc", {
								method: "POST",
								body: formData
							})
								.then(response => {
									if (response.ok) {
										window.location.href = "/bidPblanc/getBidPblancListAsEmp";
									} else {
										console.error("서버 오류:", response.status);
										alert("저장 실패: " + response.statusText);
									}
								})
								.catch(error => {
									console.error("요청 오류:", error);
									alert("요청 중 오류 발생: " + error.message);
								});
						});
						// 폼 submit
					});
				</script>

				<body>
					<%@ include file="../include/header.jsp" %>
						<div class="card">
							<div class="card-header">
								<h3 class="card-title">
									입찰 공고 등록
								</h3>
							</div>
							<!-- /.card-header -->
							<form id="postBidPblancVOForm">
								<div class="card-body">
									<table class="table table-bordered">
										<tbody>
											<tr>
												<th class="bg-light col-2 text-center align-middle">입찰제목</th>
												<td colspan="3">
													<div class="form-group mb-0">
														<input type="text"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="bidSj" name="bidSj" />
													</div>
												</td>
											</tr>
											<tr>
												<th class="bg-light col-2 text-center align-middle">
													낙찰방법
												</th>
												<td class="col-4 align-middle">
													<div class="form-group mb-0">
														<div class="d-flex justify-content">
															<div class="custom-control custom-radio mr-2 mb-0">
																<input class="custom-control-input bidPblancVO"
																	type="radio" id="scsbMth2" name="scsbMth" value="2">
																<label for="scsbMth2"
																	class="custom-control-label">최고낙찰</label>
															</div>
															<div class="custom-control custom-radio mr-2 mb-0">
																<input class="custom-control-input bidPblancVO"
																	type="radio" id="scsbMth1" name="scsbMth" value="1">
																<label for="scsbMth1"
																	class="custom-control-label">최저낙찰</label>
															</div>
															<div class="custom-control custom-radio mb-0">
																<input class="custom-control-input bidPblancVO"
																	type="radio" id="scsbMth0" name="scsbMth" value="0"
																	checked>
																<label for="scsbMth0"
																	class="custom-control-label">적격심사</label>
															</div>
														</div>
													</div>
												</td>
												<th class="bg-light col-2 text-center align-middle">보증금률(%)</th>
												<td class="col-4">
													<div class="form-group mb-1">
														<input type="number"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="bidGtnRt" name="bidGtnRt" value="5" min="5" max="10">
													</div>
													<span class="d-none" style="font-size: smaller; color: gray;">
														입찰가격의 --여기에 작성한 금액 나오게하기-- 이상 제출 필요
													</span>
												</td>
											</tr>
											<tr>
												<th class="bg-light col-2 text-center align-middle">공고 시작일자</th>
												<td>
													<div class="form-group mb-0">
														<input type="date"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="pblancDt" name="pblancDt"
															value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>"
															readonly>
													</div>
												</td>
												<th class="bg-light col-2 text-center align-middle">입찰 마감일시</th>
												<td>
													<div class="form-group mb-0">
														<input type="datetime-local"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="bidClosDt" name="bidClosDt">
													</div>
												</td>
											</tr>
											<tr>
												<th class="bg-light col-2 text-center align-middle">필수 제출 서류</th>
												<td colspan="3" class="align-middle">
													<div class="d-flex justify-content">
														<div class="custom-control custom-checkbox">
															<input
																class="custom-control-input custom-control-input-primary mb-0 bidPblancVO"
																type="checkbox" id="cdltPresentnAt"
																name="cdltPresentnAt">
															<label for="cdltPresentnAt" class="custom-control-label">
																신용평가등급확인서
															</label>
														</div>
														<div class="custom-control custom-checkbox ml-2">
															<input
																class="custom-control-input custom-control-input-primary mb-0 bidPblancVO"
																type="checkbox" id="acmsltproofPresentnAt"
																name="acmsltproofPresentnAt">
															<label for="acmsltproofPresentnAt"
																class="custom-control-label">
																관리실적증명서
															</label>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<th class="bg-light col-2 text-center align-middle">현장설명</th>
												<td colspan="3">
													<div class="form-group mb-0">
														<div class="d-flex justify-content">
															<div class="custom-control custom-radio mb-0 mr-2">
																<input class="custom-control-input bidPblancVO"
																	type="radio" id="sptdcAt1" name="sptdcAt" value="1">
																<label for="sptdcAt1"
																	class="custom-control-label">필수</label>
															</div>
															<div class="custom-control custom-radio mb-0">
																<input class="custom-control-input bidPblancVO"
																	type="radio" id="sptdcAt0" name="sptdcAt" value="0"
																	checked="">
																<label for="sptdcAt0"
																	class="custom-control-label">없음</label>
															</div>
														</div>
													</div>
												</td>
											</tr>
											<tr id="sptdcAtDisplay" style="display: none;">
												<th class="bg-light col-2 text-center align-middle">현장설명일시</th>
												<td>
													<div class="form-group mb-0">
														<input type="datetime-local"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="sptdcDt" name="sptdcDt">
													</div>
												</td>
												<th class="bg-light col-2 text-center align-middle">현장설명장소</th>
												<td>
													<div class="form-group mb-0">
														<input type="text"
															class="form-control form-control-border mb-0 bidPblancVO"
															id="sptdcPlace" name="sptdcPlace">
													</div>
												</td>
											</tr>
											<tr>
												<th class="bg-light col-2 text-center align-middle">내용</th>
												<td colspan="3">
													<textarea id="bidCn" name="bidCn">

													</textarea>
												</td>
											</tr>

											<tr>
												<th class="bg-light col-2 text-center align-middle">첨부파일</th>
												<td colspan="3">
													<div class="form-group mb-0">
														<div class="file-drop-zone" id="fileDropZone"
															ondragover="fover(event)" ondragleave="fleave(event)"
															ondrop="fdrop(event)" title="파일을 여기에 드래그하거나 클릭하세요">
															<div class="drop-placeholder">
																<i
																	class="fas fa-cloud-upload-alt fa-2x text-muted mb-2"></i>
																<p class="text-muted mb-0">파일을 드래그하거나 선택하세요</p>
															</div>
															<div class="file-list-inside" id="fileList"></div>
														</div>
														<input class="d-none" type="file" id="inputFiles"
															name="inputFiles" multiple>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<!-- /.card-body -->
								<!-- card-footer-->
								<div class="card-footer text-right">
									<a class="btn btn-warning mr-2" href="/bidPblanc/getBidPblancList">목록</a>
									<button type="submit" class="btn btn-primary mr-2">등록</button>
								</div>
							</form>
						</div>
						<%@ include file="../include/footer.jsp" %>
				</body>

				</html>