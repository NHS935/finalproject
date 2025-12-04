<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title>기안하기</title>

					<style>
						.file-drop-zone {
							border: 1px dashed #007bff;
							border-radius: 0.25rem;
							padding: 20px;
							text-align: center;
							background-color: #f8f9fa;
							cursor: pointer;
							transition: all 0.3s ease;
							min-height: 75px;
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
							padding: 5px;
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
							padding: 5px;
							margin-bottom: 5px;
							min-height: auto;
							height: 30px;
						}

						.file-info {
							flex: 1;
							min-width: 0;
							text-align: left;
						}

						.file-name {
							font-size: 0.9rem;
							font-weight: 400;
							white-space: nowrap;
							overflow: hidden;
							text-overflow: ellipsis;
							margin: 0;
						}

						.modal-custom-top {
							margin-top: 120px !important;
						}

						.cke_notification {
							display: none !important;
						}
					</style>

					<!-- 스왈 -->
					<link rel="stylesheet" href="/css/sweetalert2.min.css">
					<script type="text/javascript" src="/js/sweetalert2.min.js"></script>

					<!-- 액시오스 -->
					<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

					<!-- CK에디터 -->
					<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

					<script type="text/javascript">
						let modal;
						let modalBkmkSanctnlnNm;
						let bkmkSanctnlnNm = '';
						document.addEventListener("DOMContentLoaded", function () {
							// 모달
							modal = new bootstrap.Modal(
								document.querySelector('#drftDocFormatModal'),
								{
									backdrop: 'static',
									keyboard: false
								}
							);
							modal.show();

							document.querySelector("#drftDocFormatModal").addEventListener("click", function (e) {
								if (e.target.classList.contains('modal')) {
									Swal.fire({
										icon: 'info',
										title: '기안서 양식 선택',
										text: '사용할 기안서 양식을 선택해주세요.',
										confirmButtonText: '확인',
										width: 400,
										allowOutsideClick: false,
										allowEscapeKey: false
									}).then(() => {
										modal.show();
									});
								}
							});

							//ck에디터
							if (window.CKEDITOR) {
								CKEDITOR.replace('drftCn', {
									height: '400px',
									allowedContent: true,
									contentsCss: '/css/contract.css'
								});
							} else {
								console.warn('CKEditor 로드 안됨');
							}
							//ck에디터

							// 문서양식 선택
							// axios 문서 내용 가져오기
							async function getDrftDocFormat(drftDocId) {
								try {
									const response = await axios.get("/elctrnsanctn/getDrftDocFormat", {
										params: {
											"drftDocId": drftDocId
										}
									});
									document.querySelector("#drftDocTitle").innerHTML = response.data.drftDocVO.elctrnsanctnManageVO.sanctnSecode + '<span class="ml-2 mr-2 fs-4">|</span>' + response.data.drftDocVO.drftDocNm;
									document.querySelector("#drftDocId").value = response.data.drftDocVO.drftDocId;
									document.querySelector("#elctrnsanctnManageId").value = response.data.drftDocVO.elctrnsanctnManageId;
									let htmlContent = response.data.drftDocVO.drftDocFormat;

									if (response.data.empVO) {
										htmlContent = htmlContent
											.replace('id="elctrnsanctnEmpNm">&nbsp;',
												`id="elctrnsanctnEmpNm">\${response.data.empVO.nm}\${response.data.empVO.clsfName}`)
											.replace('id="elctrnsanctnEmpDept">&nbsp;',
												`id="elctrnsanctnEmpDept">\${response.data.empVO.deptVO.deptNm}`);
									}

									const textarea = document.querySelector("#drftCn");

									if (CKEDITOR.instances.drftCn) {
										CKEDITOR.instances.drftCn.setData(htmlContent);
									} else {
										textarea.value = htmlContent;
									}
									modal.hide();
								} catch (error) {
									Swal.fire({
										icon: 'error',
										title: '오류 발생',
										text: error.response?.data?.message || error.message,
										confirmButtonText: '확인'
									});
								}
							}

							document.querySelectorAll(".drftDocVORow").forEach(row => {
								row.addEventListener("click", function () {
									const drftDocId = this.querySelector("#drftDocId").value;
									getDrftDocFormat(drftDocId);
								});
							});

							document.querySelector("#drftDocChange").addEventListener("click", function () {
								modal.show();
							})

							// 문서양식 선택

							//=== 결재선 설정 모달
							document.querySelectorAll('label[for^="dept_"]').forEach(label => {
								label.addEventListener('click', function (e) {
									const checkbox = document.getElementById(this.getAttribute('for'));
									const deptCode = checkbox.getAttribute('data-dept');
									const empDiv = document.getElementById('empList_' + deptCode);

									if (empDiv) {
										empDiv.style.display = empDiv.style.display === 'none' ? 'block' : 'none';
									}
									e.preventDefault();
								});
							});

							// 부서 체크박스 선택 시 직원 전체 선택
							document.querySelectorAll('.dept-check').forEach(deptCheck => {
								deptCheck.addEventListener('change', function () {
									const deptCode = this.getAttribute('data-dept');
									const empDiv = document.getElementById('empList_' + deptCode);
									if (!empDiv) return;

									empDiv.querySelectorAll('.emp-check').forEach(empCheck => {
										empCheck.checked = this.checked;
									});
								});
							});

							// 결재자 추가
							document.getElementById('addSanctnBtn').addEventListener('click', function () {
								addEmpsToWrapper('sanctn', '#sanctnWrapper');
							});

							// 참조자 추가
							document.getElementById('addReferenceBtn').addEventListener('click', function () {
								addEmpsToWrapper('reference', '#referenceWrapper');
							});

							// 통합 함수
							function addEmpsToWrapper(type, wrapperId) {
								const wrapper = document.querySelector(wrapperId);
								const checkedEmps = document.querySelectorAll('.emp-check:checked');
								const checkedDepts = document.querySelectorAll('.dept-check:checked');

								if (checkedEmps.length === 0) {
									Swal.fire({
										icon: 'warning',
										title: '선택 필요',
										text: '직원을 선택해주세요',
										confirmButtonText: '확인',
										allowOutsideClick: false,
										allowEscapeKey: false
									});
									return;
								}

								wrapper.innerHTML = '';

								let orderNum = 1;

								checkedEmps.forEach(empCheck => {
									const empId = empCheck.getAttribute('data-emp');
									const deptInfo = empCheck.getAttribute("data-dept");
									// 라벨 찾기
									const empLabel = document.querySelector(`label[for="emp_\${empId}"]`);
									const empName = empLabel ? empLabel.textContent : empId; // 라벨 못 찾으면 ID 사용

									const div = document.createElement('div');
									div.setAttribute('class', 'badge badge-lg badge-light p-1')
									div.setAttribute('data-emp', empId);
									div.setAttribute('data-dept', deptInfo);
									div.setAttribute('data-type', type);
									div.setAttribute('data-order', type === 'sanctn' ? orderNum : '');

									div.innerHTML = `
														<span class="badge badge-warning badge-sm mr-1 order-badge">\${type==='sanctn' ? orderNum : ''}</span>
														<span style="font-size: 0.9rem">\${empName}</span>
														 <a class="badge badge-danger badge-sm ml-1 sanctnlnDelBtn" style="font-weight: bold; cursor:pointer;">X</a>
													`;

									div.querySelectorAll(".sanctnlnDelBtn").forEach(btn => {
										btn.addEventListener("click", function () {
											div.remove();
											recalculateOrders(type, wrapperId);
										})
									})

									wrapper.appendChild(div);

									if (type === 'sanctn') orderNum++;
								});

								const emptyMsg = wrapper.querySelector('p');
								if (emptyMsg) emptyMsg.remove();

								checkedEmps.forEach(empCheck => {
									empCheck.checked = false;
								});

								checkedDepts.forEach(deptCheck => {
									deptCheck.checked = false;
								});
							}

							function recalculateOrders(type, wrapperId) {
								if (type !== 'sanctn') return;

								const wrapper = document.querySelector(wrapperId);
								const divs = wrapper.querySelectorAll('div[data-type="sanctn"]');

								divs.forEach((div, index) => {
									const orderBadge = div.querySelector('.order-badge');
									if (orderBadge) {
										orderBadge.textContent = index + 1;
										div.setAttribute('data-order', index + 1);
									}
								});
							}

							//결재선 적용 버튼 클릭
							document.querySelector("#modalSanctnlnBtn").addEventListener("click", function () {
								addSanctnlnToTable();
								$('#modal-sanctnln').modal('hide');
							});

							function addSanctnlnToTable() {
								const sanctnDivs = document.querySelectorAll("#sanctnWrapper > div[data-type='sanctn']");
								const tbody = document.querySelector("#sanctnTableBody");

								tbody.innerHTML = '';

								sanctnDivs.forEach((div, index) => {
									const empInfo = parseEmpInfo(div);
									addApproverRow(empInfo, index + 1, tbody);
								});

								const referenceDivs = document.querySelectorAll("#referenceWrapper > div[data-type='reference']");
								const referenceTableFoot = document.querySelector("#referenceTableFoot");

								referenceTableFoot.innerHTML = ''; // 기존 내용 제거

								if (referenceDivs.length === 0) {
									referenceTableFoot.innerHTML = '<p class="text-muted mb-0">참조자 없음</p>';
								} else {
									referenceDivs.forEach((div) => {
										const empInfo = parseEmpInfo(div);
										addReferenceBadge(empInfo, referenceTableFoot);
									});
								}
							}

							// 참조자 Badge 추가 (NEW)
							function addReferenceBadge(empInfo, container) {
								const span = document.createElement('span');
								span.className = 'badge badge-lg badge-light p-2 mr-2 drftRefrnEmp';
								span.setAttribute('data-emp', empInfo.empId);
								span.style.fontSize = "0.9rem";
								span.innerHTML = `
													\${empInfo.empName} \${empInfo.clsfName}
													<a class="badge badge-danger badge-sm ml-1 reference-delete-btn" 
													style="font-weight: bold; cursor: pointer;">X</a>
												`;

								// 참조자 삭제 버튼 이벤트
								span.querySelector('.reference-delete-btn').addEventListener('click', function () {
									span.remove();

									// 참조자 삭제 시 referenceWrapper에서도 제거
									const empId = span.getAttribute('data-emp');
									const referenceWrapper = document.querySelector("#referenceWrapper");
									const targetDiv = referenceWrapper.querySelector(`div[data-emp="\${empId}"][data-type="reference"]`);
									if (targetDiv) {
										targetDiv.remove();
									}

									// 참조자가 모두 제거되면 "선택된 직원이 없습니다" 메시지 표시
									if (referenceWrapper.querySelectorAll('div[data-type="reference"]').length === 0) {
										container.innerHTML = '<p class="text-muted mb-0">참조자 없음</p>';
									}
								});

								container.appendChild(span);
							}

							function parseEmpInfo(div) {
								const empId = div.getAttribute('data-emp');
								const deptInfo = div.getAttribute("data-dept");
								const textContent = div.textContent;

								let cleanText = textContent.replace(/^\d+/, '').replace('X', '').trim();

								const empLabel = document.querySelector(`label[for="emp_\${empId}"]`);
								let empName = '';
								let clsfName = '';
								if (empLabel) {
									const fullText = empLabel.textContent.trim();
									const parts = fullText.split(/\s+/);
									clsfName = parts[1] || '';
									empName = parts[0] || '';
								}

								return { empId, empName, clsfName, deptInfo };
							}

							// 결재자 행 추가
							function addApproverRow(empInfo, order, tbody) {
								const tr = document.createElement('tr');
								tr.className = 'text-center sanctnlnEmp';
								tr.setAttribute('data-emp', empInfo.empId);
								tr.setAttribute('data-order', order);

								tr.appendChild(createTd(order));
								tr.appendChild(createTd(empInfo.clsfName));
								tr.appendChild(createTd(empInfo.empName));
								tr.appendChild(createTd(empInfo.deptInfo));

								tbody.appendChild(tr);
							}

							// td 생성 헬퍼
							function createTd(text) {
								const td = document.createElement('td');
								td.className = 'text-center';
								td.textContent = text;
								return td;
							}
							//=== 결재선 설정 모달	

							//제목 입력
							document.querySelector("#drftSj").addEventListener("input", function () {
								if (CKEDITOR.instances.drftCn) {
									const editorDoc = CKEDITOR.instances.drftCn.document;
									const titleElement = editorDoc.getById('elctrnsanctnDrftSj');

									if (titleElement) {
										titleElement.setHtml(this.value);
									} else {
										console.warn('제목 요소를 찾을 수 없습니다');
									}
								} else {
									console.warn('CKEditor가 초기화되지 않았습니다');
								}
							})

							// 파일 첨부, 드래그앤드롭
							let uploadedFiles = [];
							const fileDropZone = document.querySelector("#fileDropZone");
							const fileList = document.querySelector("#fileList");
							const inputFiles = document.querySelector("#inputFiles");

							// 드롭 존 클릭 시
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
                                <button type="button" class="badge badge-danger badge-xs" onclick="removeFileItem(this)">X</button>
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

							// 임시저장
							document.querySelector("#postTempElctrnsanctn").addEventListener("click", function () {
								Swal.fire({
									icon: 'question',
									title: '임시저장',
									text: '전자결재를 임시저장하시겠습니까?',
									showCancelButton: true,
									confirmButtonText: '저장',
									cancelButtonText: '취소',
									confirmButtonColor: '#3085d6',
									cancelButtonColor: '#d33'
								}).then((result) => {
									if (result.isConfirmed) {
										submitForm("/elctrnsanctn/postTempElctrnsanctn");
									}
								});
							});

							// 상신
							document.querySelector("#postElctrnsanctn").addEventListener("click", function () {
								Swal.fire({
									icon: 'warning',
									title: '전자결재 상신',
									text: `전자결재를 상신하시겠습니까?\n상신 후에는 수정할 수 없습니다.`,
									showCancelButton: true,
									confirmButtonText: '상신',
									cancelButtonText: '취소',
									confirmButtonColor: '#d33',
									cancelButtonColor: '#3085d6'
								}).then((result) => {
									if (result.isConfirmed) {
										Swal.fire({
											icon: 'success',
											title: '상신 완료',
											text: '전자결재가 상신되었습니다.',
											confirmButtonText: '확인'
										}).then(() => {
											if (CKEDITOR.instances.drftCn) {
												const now = new Date();
												const today = now.getFullYear() + '-' +
													String(now.getMonth() + 1).padStart(2, '0') + '-' +
													String(now.getDate()).padStart(2, '0');
												const editorDoc = CKEDITOR.instances.drftCn.document;
												const dateElem = editorDoc.getById('elctrnsanctnDrftDt');

												if (dateElem) {
													dateElem.setHtml(today);
												} else {
													console.warn('날짜 요소를 찾을 수 없습니다');
												}
											} else {
												console.warn('CKEditor가 초기화되지 않았습니다');
											}
											submitForm("/elctrnsanctn/postElctrnsanctn");
										});
									}
								});
							});

							function submitForm(action) {
								if (CKEDITOR.instances.drftCn) {
									CKEDITOR.instances.drftCn.updateElement();
									const textarea = document.querySelector("#drftCn");
								} else {
									console.warn("CKEditor 인스턴스 없음");
								}

								const form = document.querySelector("#drftForm");
								const formData = new FormData(form);

								const drftSj = document.querySelector("#drftSj").value;
								const drftCn = document.querySelector("#drftCn").value;

								if (!drftSj.trim()) {
									alert("제목을 입력해주세요");
									return;
								}

								if (!drftCn.trim()) {
									alert("내용을 입력해주세요");
									return;
								}

								const drftRefrnEmpList = [];
								document.querySelectorAll("#referenceTableFoot span.drftRefrnEmp").forEach(elem => {
									const empId = elem.getAttribute("data-emp");
									const data = {
										"empId": empId
									};
									drftRefrnEmpList.push(data);
								});

								const sanctnlnEmpList = [];
								document.querySelectorAll("#sanctnTableBody tr.sanctnlnEmp").forEach(elem => {
									const empId = elem.getAttribute("data-emp");
									const sanctnOrdr = elem.getAttribute("data-order");

									const data = {
										"empId": empId,
										"sanctnOrdr": parseInt(sanctnOrdr)
									};
									sanctnlnEmpList.push(data);
								});

								formData.append("drftRefrnEmpList", JSON.stringify(drftRefrnEmpList));
								formData.append("sanctnlnEmpList", JSON.stringify(sanctnlnEmpList));

								// 4. 폼 제출
								fetch(action, {
									method: 'POST',
									body: formData
								})
									.then(response => {
										if (response.ok) {
											window.location.href = "/elctrnsanctn/getElctrnsanctnList";
										} else {
											return response.text().then(text => {
												throw new Error("응답 상태: " + response.status);
											});
										}
									})
									.catch(error => {
										console.error("전송 오류:", error);
									});
							}

							// 즐겨찾기 결재선 저장
							modalBkmkSanctnlnNm = new bootstrap.Modal(document.querySelector("#modalBkmkSanctnlnNm"), {
								backdrop: 'static',
								keyboard: false
							});

							document.querySelector("#bkmkSanctnlnNm").addEventListener("input", function () {
								bkmkSanctnlnNm = this.value;
							})

							document.querySelector("#bkmksanctnlnPostBtn").addEventListener("click", function () {
								//데이터 수집
								const sanctnlnDivs = document.querySelectorAll("#sanctnWrapper > div[data-type='sanctn']");
								const drftRefrnDivs = document.querySelectorAll("#referenceWrapper > div[data-type='reference']");

								if (sanctnlnDivs.length === 0) {
									Swal.fire({
										icon: 'warning',
										title: '결재선 선택',
										text: '결재자를 최소 1명 이상 선택해주세요.',
										confirmButtonText: '확인'
									});
									return;
								}

								// 결재자 리스트
								const sanctnlnList = [];

								sanctnlnDivs.forEach((div) => {
									const empId = div.getAttribute('data-emp');
									const order = parseInt(div.getAttribute('data-order'));

									sanctnlnList.push({
										"empId": empId,
										"sanctnOrdr": order
									});
								});

								// 참조자 리스트
								const drftRefrnList = [];

								drftRefrnDivs.forEach((div) => {
									const empId = div.getAttribute('data-emp');
									drftRefrnList.push({
										"empId": empId
									});
								});

								// 즐겨찾기 모달 post
								document.querySelector("#bkmkSanctnlnNm").value = '';
								bkmkSanctnlnNm = '';

								modalBkmkSanctnlnNm.show();

								document.querySelector("#bkmkSanctnlnNmBtn").onclick = async function () {
									if (!bkmkSanctnlnNm.trim()) {
										Swal.fire({
											icon: 'warning',
											title: '입력 필요',
											text: '즐겨찾기 이름을 입력해주세요.',
											confirmButtonText: '확인'
										});
										return;
									}

									// 전체 데이터 구성
									const bkmkSanctnlnData = {
										bkmkSanctnlnNm: bkmkSanctnlnNm,
										sanctnlnList: sanctnlnList,
										drftRefrnList: drftRefrnList
									};

									// 서버 전송
									try {
										const response = await axios.post("/elctrnsanctn/postBkmkSanctnln", bkmkSanctnlnData);
										if (response.data.result == 1) {
											Swal.fire({
												icon: 'success',
												title: '저장 완료',
												text: '즐겨찾기 결재선이 저장되었습니다.',
												confirmButtonText: '확인'
											}).then(() => {
												// 모달 정리
												modalBkmkSanctnlnNm.hide();
												document.querySelector("#bkmkSanctnlnNm").value = '';
												bkmkSanctnlnNm = '';
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
							});

							// 즐겨찾기 결재선 설정
							document.querySelector("#bkmksanctnlnSelect").addEventListener("change", function () {
								const bkmkSanctnlnId = this.value;
								if (!bkmkSanctnlnId) {
									document.querySelector("#sanctnWrapper").innerHTML = '';
									document.querySelector("#referenceWrapper").innerHTML = '';
									return;
								}
								getBkmkSanctnln(bkmkSanctnlnId);
							});

							async function getBkmkSanctnln(bkmkSanctnlnId) {
								try {
									const response = await axios.get("/elctrnsanctn/getBkmkSanctnln", {
										params: {
											bkmkSanctnlnId: bkmkSanctnlnId
										}
									});
									const bkmkSanctnlnVO = response.data.bkmkSanctnlnVO;
									populateBkmkSanctnln(bkmkSanctnlnVO);
								} catch (error) {
									console.error("조회 오류:", error);
									Swal.fire({
										icon: 'error',
										title: '오류 발생',
										text: error.response?.data?.message || error.message
									});
								}
							}

							function populateBkmkSanctnln(bkmkSanctnlnVO) {

								const sanctnWrapper = document.querySelector("#sanctnWrapper");
								sanctnWrapper.innerHTML = '';

								const refWrapper = document.querySelector("#referenceWrapper");
								refWrapper.innerHTML = '';

								if (!bkmkSanctnlnVO.bkmkSanctnlnDetailVOList ||
									bkmkSanctnlnVO.bkmkSanctnlnDetailVOList.length === 0) {
									sanctnWrapper.innerHTML = '<p class="text-muted">선택된 결재자가 없습니다.</p>';
									refWrapper.innerHTML = '<p class="text-muted">선택된 참조자가 없습니다.</p>';
									return;
								}

								const sortedDetails = bkmkSanctnlnVO.bkmkSanctnlnDetailVOList.sort((a, b) => {
									return a.sanctnOrdr - b.sanctnOrdr;
								});

								sortedDetails.forEach((detail, idx) => {
									const empId = detail.empId;
									const deptInfo = detail.empVO.deptVO.deptNm;

									// 라벨에서 직원명 가져오기
									const empLabel = document.querySelector(`label[for="emp_\${empId}"]`);
									const empName = empLabel ? empLabel.textContent : empId;

									const div = document.createElement('div');
									div.setAttribute('class', 'badge badge-lg badge-light p-1');
									div.setAttribute('data-emp', empId);
									div.setAttribute('data-dept', deptInfo);
									div.setAttribute('data-type', detail.drftRefrnAt === 1 ? 'reference' : 'sanctn');
									div.setAttribute('data-order', detail.drftRefrnAt === 1 ? '' : detail.sanctnOrdr);

									div.innerHTML = `
														<span class="badge badge-warning badge-sm mr-1 order-badge">\${detail.drftRefrnAt === 1 ? '' : detail.sanctnOrdr}</span>
														<span style="font-size: 0.9rem">\${empName}</span>
														<a class="badge badge-danger badge-sm ml-1 sanctnlnDelBtn" style="font-weight: bold; cursor:pointer;">X</a>
													`;

									div.querySelectorAll(".sanctnlnDelBtn").forEach(btn => {
										btn.addEventListener("click", function () {
											div.remove();
											recalculateOrders(detail.drftRefrnAt === 1 ? 'reference' : 'sanctn',
												detail.drftRefrnAt === 1 ? '#referenceWrapper' : '#sanctnWrapper');
										});
									});

									if (detail.drftRefrnAt === 1) {
										refWrapper.appendChild(div);
									} else {
										sanctnWrapper.appendChild(div);
									}
								});
							}

							//미리보기
							document.querySelector("#previewBtn").addEventListener("click", function () {

							});
						});
					</script>
				</head>

				<body>
					<%@ include file="../include/header.jsp" %>

						<div class="card">
							<div class="card-header">
								<h3 class="card-title">기안서 작성</h3>
								<div class="card-tools">
									<div class="input-group input-group-sm">
										<button type="button" class="bg-light btn btn-sm mr-2" id="drftDocChange">양식
											변경</button>
										<button type="button" class="bg-warning btn btn-sm mr-2" id="previewBtn">
											미리보기
										</button>
									</div>
								</div>
							</div>

							<form id="drftForm" method="post" enctype="multipart/form-data">
								<div style="display: none;">
									<c:if test="${not empty fileGroupSn}">
									<input type="hidden" id="fileGroupSn" name="fileGroupSn"
										   value="${fileGroupSn}" />
									</c:if>
								</div>
								<div class="card-body">
									<div class="card">
										<div class="card-header">
											<h3 class="card-title" id="drftDocTitle"></h3>
											<input type="hidden" id="drftDocId" name="drftDocId" /> <input type="hidden"
												id="elctrnsanctnManageId" name="elctrnsanctnManageId" />
										</div>

										<div class="card-body">
											<table class="table table-bordered table-sm">
												<tbody>
													<tr>
														<th class="text-center align-middle col-2 bg-light">제목</th>
														<td colspan="3"><input type="text"
																class="form-control form-control-border form-control-sm"
																id="drftSj" name="drftSj"></td>
													</tr>

													<tr>
														<th class="text-center align-middle col-2 bg-light">기안자</th>
														<td class="col-4 align-middle pl-3">${empVO.nm}
															${empVO.clsfName} <input type="hidden" name="empId"
																value="${empVO.empId}" />
														</td>
														<th class="text-center align-middle col-2 bg-light">생성일자</th>
														<td class="col-4"><input type="date"
																value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd' />"
																class="form-control form-control-border form-control-sm"
																name="creatDt" readonly></td>
													</tr>

													<tr>
														<th colspan="4" class="bg-light">
															<div class="d-flex align-items-center">
																<span class="flex-grow-1 text-center">결재선</span>
																<button type="button" class="btn btn-info btn-sm mr-1"
																	data-toggle="modal" data-target="#modal-sanctnln">
																	결재선 설정</button>
															</div>
														</th>
													</tr>

													<tr>
														<td class="p-1" colspan="4" id="sanctnlnTd">
															<table
																class="table table-sm table-bordered sanctnln-table m-0">
																<thead>
																	<tr class="bg-lightblue disabled text-center">
																		<th class="col-2">순번</th>
																		<th class="col-3">직급</th>
																		<th class="col-4">성명</th>
																		<th class="col-3">부서</th>
																	</tr>
																</thead>
																<tbody id="sanctnTableBody">
																	<!-- 결재선 정보 -->
																</tbody>
																<tfoot>
																	<tr>
																		<th class="bg-light text-center">참조</th>
																		<td id="referenceTableFoot" colspan="3">
																			<!-- 참조 정보 -->
																		</td>
																	</tr>
																</tfoot>
															</table>
														</td>
													</tr>
													<tr>
														<th class="text-center align-middle col-2 bg-light">첨부파일</th>
														<td colspan="3" class="p-1">


															<div class="file-drop-zone" id="fileDropZone"
																ondragover="fover(event)" ondragleave="fleave(event)"
																ondrop="fdrop(event)" title="파일을 여기에 드래그하거나 클릭하세요">
																<div class="drop-placeholder" style="<c:if test="${not empty fileDetailVOList}">display: none;</c:if>">
																	<i
																		class="fas fa-cloud-upload-alt text-muted mb-2"></i>
																	<p class="text-muted mb-0"
																		style="font-size: 0.9rem;">파일을
																		드래그하거나 선택하세요</p>
																</div>
																<div class="file-list-inside" id="fileList">
																	<c:forEach var="file" items="${fileDetailVOList}">
																		<div class="file-item d-flex align-items-center p-2 border-bottom"
																			 data-filenosn="${file.fileNo}"
																			 data-groupsn="${file.fileGroupSn}"
																			 data-status="committed">
																			<i class="fas fa-file-alt text-primary me-2"></i>
																			<span class="file-name text-truncate flex-grow-1 text-center" title="${file.fileOrginlNm}">
																			 ${file.fileOrginlNm}

																		 </span>
																		<button type="button" class="btn btn-sm btn-outline-danger ms-2 remove-file-btn"
																					onclick="removeExistingFile(this)">
																				<i class="fas fa-trash-alt"></i>
																			</button>
																		</div>
																	</c:forEach>
																</div>
															</div> <input class="d-none" type="file" id="inputFiles"
																name="inputFiles" multiple>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div>
										<!-- drftCn -->
										<textarea class="form-control cntrPost" name="drftCn" id="drftCn">

										</textarea>
									</div>
								</div>
								<div class="card-footer d-flex">
									<a class="btn btn-warning btn-sm mr-1"
										href="/elctrnsanctn/getElctrnsanctnList">목록</a>
									<div class="ml-auto">
										<button type="button" id="postTempElctrnsanctn"
											class="btn btn-success btn-sm mr-1">임시저장</button>
										<button type="button" id="postElctrnsanctn"
											class="btn btn-primary btn-sm">상신</button>
									</div>
								</div>
							</form>
						</div>

						<%@ include file="../include/footer.jsp" %>

							<!-- 기안서 양식 선택 모달 -->
							<div class="modal fade" id="drftDocFormatModal" style="display: none;" aria-hidden="true">
								<div class="modal-dialog modal-lg">
									<div class="modal-content">
										<div class="modal-header bg-info">
											<h4 class="modal-title">기안서 양식</h4>
										</div>
										<div class="modal-body">
											<div class="card">
												<div class="card-header">
													<h3 class="card-title">양식 목록</h3>
													<div class="card-tools">
														<div class="input-group input-group-sm" style="width: 150px;">
															<input type="text" name="table_search" class="form-control"
																placeholder="검색">
															<div class="input-group-append">
																<button type="submit" class="btn btn-default">
																	<i class="fas fa-search"></i>
																</button>
															</div>
														</div>
													</div>
												</div>

												<div class="card-body">
													<table class="table table-bordered table-hover table-sm text-center"
														style="cursor: pointer;">
														<thead>
															<tr class="bg-light">
																<th class="col-2">순번</th>
																<th class="col-5">양식 명</th>
																<th class="col-2">분류</th>
																<th class="col-3">유효기일</th>
															</tr>
														</thead>
														<tbody>
															<c:forEach var="drftDocVO" items="${drftDocVOList}"
																varStatus="status">
																<tr class="drftDocVORow">
																	<td>${status.count}<input type="hidden"
																			id="drftDocId" name="drftDocId"
																			value="${drftDocVO.drftDocId}">
																	</td>
																	<td>${drftDocVO.drftDocNm}</td>
																	<td>${drftDocVO.elctrnsanctnManageVO.sanctnSecode}
																	</td>
																	<td>
																		<fmt:formatDate value="${drftDocVO.validDudt}"
																			pattern="yyyy-MM-dd" />
																	</td>
																</tr>
															</c:forEach>
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<!-- 결재선 설정 모달 -->
							<div class="modal fade" id="modal-sanctnln" style="display: none;" aria-hidden="true">
								<div class="modal-dialog modal-xl">
									<div class="modal-content">
										<div class="modal-header bg-primary">
											<h4 class="modal-title">결재선 설정</h4>
										</div>

										<div class="modal-body">
											<div class="form-group">
												<label>즐겨찾기 결재선</label> <select class="form-control"
													id="bkmksanctnlnSelect" name="bkmksanctnlnSelect">
													<c:choose>
														<c:when test="${not empty bkmkSanctnlnVOList}">
															<option value="">-- 선택하세요 --</option>
															<c:forEach var="bkmkSanctnlnVO"
																items="${bkmkSanctnlnVOList}">
																<option value="${bkmkSanctnlnVO.bkmkSanctnlnId}">
																	${bkmkSanctnlnVO.bkmkSanctnlnNm}</option>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<option value="" disabled>저장된 즐겨찾기 결재선이 없습니다.</option>
														</c:otherwise>
													</c:choose>
												</select>
											</div>

											<hr>

											<div class="row justify-content-between">
												<!-- 왼쪽: 부서별 직원 선택 -->
												<div class="col-6">
													<label>부서별 직원</label>
													<div class="border p-1">
														<c:forEach var="deptVO" items="${deptVOList}">
															<c:choose>
																<c:when
																	test="${not empty deptVO.empVOList and deptVO.empVOList[0].nm != null}">
																	<div class="mb-1">
																		<!-- 부서 체크박스 -->
																		<input type="checkbox" class="dept-check"
																			id="dept_${deptVO.deptCode}"
																			data-dept="${deptVO.deptCode}" />
																		<label for="dept_${deptVO.deptCode}">
																			<strong>${deptVO.deptNm}</strong>
																		</label>

																		<!-- 직원 목록 -->
																		<div class="empVOList ml-4"
																			id="empList_${deptVO.deptCode}"
																			style="display: none;">
																			<c:forEach var="empVO"
																				items="${deptVO.empVOList}">
																				<div class="mb-1">
																					<input type="checkbox"
																						class="emp-check"
																						id="emp_${empVO.empId}"
																						data-emp="${empVO.empId}"
																						data-dept="${deptVO.deptNm}" />
																					<label for="emp_${empVO.empId}">
																						${empVO.nm}
																						${empVO.clsfName} </label>
																				</div>
																			</c:forEach>
																		</div>
																	</div>
																</c:when>
															</c:choose>
														</c:forEach>
													</div>
												</div>

												<!-- 오른쪽: 선택된 직원 -->
												<div class="col-6">
													<div>
														<label>결재</label>
														<div class="border p-1 form-container" id="sanctnWrapper">
															<p class="text-muted">선택된 직원이 없습니다</p>
														</div>
														<button type="button" class="btn btn-sm btn-info mt-2"
															id="addSanctnBtn">결재자 추가</button>
													</div>
													<div>
														<label>참조</label>
														<div id="referenceWrapper" class="border p-1 form-container">
															<p class="text-muted" style="margin: 0;">선택된 직원이 없습니다</p>
														</div>
														<button type="button" class="btn btn-sm btn-warning mt-2"
															id="addReferenceBtn">참조자 추가</button>
													</div>
												</div>
											</div>
										</div>
										<div class="modal-footer justify-content-between">
											<div>
												<button type="button" class="btn btn-default btn-sm"
													data-dismiss="modal">닫기</button>
											</div>
											<div>
												<button type="button" id="bkmksanctnlnPostBtn"
													class="btn btn-success btn-sm mr-1">즐겨찾기 추가</button>
												<button type="button" id="modalSanctnlnBtn"
													class="btn btn-primary btn-sm">완료</button>
											</div>
										</div>
									</div>
								</div>
							</div>

							<!-- 즐겨찾기 이름 모달 -->
							<div class="modal fade modal-custom-top" id="modalBkmkSanctnlnNm" style="display: none;"
								aria-hidden="true">
								<div class="modal-dialog modal-sm">
									<div class="modal-content">
										<div class="modal-header bg-lightblue">
											<h4 class="modal-title">즐겨찾기 결재선 설정</h4>
										</div>
										<div class="modal-body">
											<label for="bkmkSanctnlnNm">즐겨찾기 결재선 이름 </label> <input type="text"
												class="form-control form-control-border mb-0" id="bkmkSanctnlnNm"
												placeholder="이름을 입력해주세요.">
										</div>
										<div class="modal-footer justify-content-between">
											<button type="button" class="btn btn-default btn-sm"
												data-dismiss="modal">취소</button>
											<button type="button" id="bkmkSanctnlnNmBtn"
												class="btn btn-sm bg-lightblue">확인</button>
										</div>
									</div>
									<!-- /.modal-content -->
								</div>
								<!-- /.modal-dialog -->
							</div>
				</body>

				</html>
