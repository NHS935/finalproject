<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>

<head>
<title>입찰하기</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>입찰하기</title>

<!-- CSS -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
<link rel="stylesheet"
	href="/adminlte/plugins/fontawesome-free/css/all.min.css">
<link rel="stylesheet" href="/adminlte/dist/css/adminlte.min.css">
<link rel="stylesheet"
	href="/adminlte/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script
	src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.12.2/lottie.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<style>
/* 드래그앤드랍 스타일 */
#fileList {
	height: 250px;
	border: 2px dashed #dee2e6;
	border-radius: 0.25rem;
	background-color: #f8f9fa;
	overflow-y: auto;
	padding: 15px;
	margin-bottom: 15px;
}

.file-item {
	display: flex;
	align-items: center;
	gap: 10px;
	background-color: white;
	border: 1px solid #dee2e6;
	border-radius: 0.25rem;
	padding: 10px;
	margin-bottom: 10px;
}

.file-info {
	flex: 1;
	min-width: 0;
}

.file-name {
	font-size: 14px;
	font-weight: 500;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.btn-remove {
	padding: 15;
	color: red;
	cursor: pointer;
	border: none;
	background: none;
	font-size: 20px;
}

.btn-remove:hover {
	color: red;
	font-weight: bolder;
}
</style>

<script>
							document.addEventListener("DOMContentLoaded", function () {
								const checkAll = document.getElementById("checkAll");
								if (checkAll) { 
								    const fileChecks = document.querySelectorAll(".fileCheck");
								    checkAll.addEventListener("change", function () {
								      fileChecks.forEach(chk => chk.checked = checkAll.checked);
								    });
								}
								

								const downloadSelectedBtn = document.getElementById("downloadSelectedBtn");
								if (downloadSelectedBtn) {  // ← null 체크!
									 downloadSelectedBtn.addEventListener("click", function () {
									      const selectedFiles = Array.from(document.querySelectorAll(".fileCheck:checked"));

									if (selectedFiles.length === 0) {
										alert("다운로드할 파일을 선택해주세요.");
										return;
									}

									const form = document.createElement("form");
									form.method = "POST";
									form.action = "/bidPblanc/downloadSelected";

									selectedFiles.forEach(checkbox => {
										const listItem = checkbox.closest("a");
										const fileGroupSn = listItem.getAttribute("data-file-group-sn");
										const fileNo = listItem.getAttribute("data-file-no");

										const groupInput = document.createElement("input");
										groupInput.type = "hidden";
										groupInput.name = "fileGroupSnList";
										groupInput.value = fileGroupSn;
										form.appendChild(groupInput);

										const noInput = document.createElement("input");
										noInput.type = "hidden";
										noInput.name = "fileNoList";
										noInput.value = fileNo;
										form.appendChild(noInput);
									});

									document.body.appendChild(form);
									form.submit();
								});
								}
								// 전체 다운로드
								  const downloadAllBtn = document.getElementById("downloadAllBtn");
  if (downloadAllBtn) {  // ← null 체크!
    downloadAllBtn.addEventListener("click", function () {
      const firstFile = document.querySelector("a[data-file-group-sn]");
      if (firstFile) {
        const fileGroupSn = firstFile.getAttribute("data-file-group-sn");
        window.location.href = "/bidPblanc/downloadAll?fileGroupSn=" + fileGroupSn;
      }
    });
  }


								// 입찰금 change
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

								// 입찰금 한글 표시 메서드
								const bidAmounttoKRW = function () {
									const bidAmountElement = document.querySelector("#bidAmount");
									const bidAmountValue = bidAmountElement.getAttribute("data-bidAmount");

									if (bidAmountValue && bidAmountValue !== "") {
										const krwAmount = numberToKorean(parseInt(bidAmountValue));
										document.querySelector("#bidAmountKrw").innerText = krwAmount;
									}
								};

								// 보증금 한글 표시 메서드
								const bidGtntoKRW = function () {
									const bidGtnElement = document.querySelector("#bidGtn");
									const bidGtnValue = bidGtnElement.getAttribute("data-bidGtn");

									if (bidGtnValue && bidGtnValue !== "") {
										const krwGtn = numberToKorean(parseInt(bidGtnValue));
										document.querySelector("#bidGtnKrw").innerText = krwGtn;
									}
								};

								bidAmounttoKRW();
								bidGtntoKRW();

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

								const submitBtn = document.querySelector("#submitBtn");
								if (submitBtn) {
									submitBtn.addEventListener("click", function () {
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

										async function putBdder() {
											try {
												const formData = new FormData();
												document.querySelectorAll(".putBdderVO").forEach(elem => {
													const name = elem.getAttribute("name");
													if (name) {
														formData.append(name, elem.value);
													}
												});

												const response = await axios.post("/bdder/putBdder", formData);
												setTimeout(() => {
													if (response.data.success) {
														loadingModal.hide();
														Swal.fire({
															icon: 'success',
															title: '낙찰 선정 완료',
															text: response.data.message || '선정이 완료되었습니다.',
															confirmButtonText: '확인'
														}).then(() => {
															window.close();
														});
													}
												}, 2500);
											} catch (err) {
												console.log("error => ", err);
												Swal.fire({
													icon: 'error',
													title: '오류 발생',
													text: err.response?.data?.message || err.message,
													confirmButtonText: '확인'
												});
											}
										}
										putBdder();
									});
								}

								 const closeWindow = document.querySelector("#closeWindow");
								  if (closeWindow) {  // ← null 체크!
								    closeWindow.addEventListener("click", function () {
								      window.close();
								    });
								  }
							});				
						</script>
</head>

<body>
	<section class="content">
		<div class="container-fluid">
			<div class="card card-info">
				<div class="card-header">
					<h3 class="card-title">
						입찰
						<c:if test="${bdderVO.bidAt==1}">
							<span class="badge badge-danger ml-2" style="font-size: 0.9rem;">선정
								완료</span>
						</c:if>
					</h3>
				</div>
				<!--/// body /// -->
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
									<td colspan="3">${bdderVO.bidPblancVO.bidPblancSnAsStr}<input
										type="hidden" class="putBdderVO"
										value="${bdderVO.bidPblancVO.bidPblancSn}" name="bidPblancSn" />
									</td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">입찰제목</th>
									<td colspan="3">${bdderVO.bidPblancVO.bidSj}</td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">낙찰방법</th>
									<td class="col-4">${bdderVO.bidPblancVO.scsbMthAsStr}</td>
									<th class="bg-light col-2 text-center">입찰보증금</th>
									<td class="col-4">입찰가격의[<span
										style="color: red; font-weight: bold;">${bdderVO.bidPblancVO.bidGtnRt}</span>]%이상
										제출
									</td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">공고 시작일</th>
									<td><fmt:formatDate
											value="${bdderVO.bidPblancVO.pblancDt}" pattern="yyyy-MM-dd" />
									</td>
									<th class="bg-light col-2 text-center">입찰 마감일</th>
									<td><fmt:formatDate
											value="${bdderVO.bidPblancVO.bidClosDtAsDate}"
											pattern="yyyy-MM-dd" /></td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">신용평가등급확인서</th>
									<td>${bdderVO.bidPblancVO.cdltPresentnAtAsStr}</td>
									<th class="bg-light col-2 text-center">관리실적증명서</th>
									<td>${bdderVO.bidPblancVO.acmsltproofPresentnAtAsStr}</td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">현장설명</th>
									<td colspan="3">${bdderVO.bidPblancVO.sptdcAtAsStr}</td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">현장설명일시</th>
									<td><c:if
											test="${empty bdderVO.bidPblancVO.sptdcDtAsDate}">
																해당없음
															</c:if></td>
									<th class="bg-light col-2 text-center">현장설명장소</th>
									<td><c:if test="${empty bdderVO.bidPblancVO.sptdcPlace}">
																해당없음
															</c:if></td>
								</tr>
								<tr>
									<th class="bg-light col-2 text-center">내용</th>
									<td colspan="3">${bdderVO.bidPblancVO.bidCn}</td>
								</tr>

								<tr>
									<th class="bg-light col-2 text-center align-middle">첨부파일</th>
									<td colspan="3"><c:choose>
											<c:when test="${empty bidPblancFileDetailVOList}">
												<p class="text-muted">첨부파일이 없습니다.</p>
											</c:when>
											<c:otherwise>
												<!-- 전체 선택 영역 -->
												<div class="bg-light p-2 mb-2 d-flex align-items-center">
													<label for="previewFiles" class="mb-0">미리보기</label>
												</div>
												<!-- 파일 목록 -->
												<div class="list-group">
													<c:forEach var="file" items="${bidPblancFileDetailVOList}">
														<a
															class="list-group-item list-group-item-action d-flex align-items-center"
															data-file-group-sn="${file.fileGroupSn}"
															data-file-no="${file.fileNo}" style="cursor: pointer;">
															<i class="fa fa-file mr-2"></i> <span>${file.fileOrginlNm}</span>
														</a>
													</c:forEach>
												</div>
											</c:otherwise>
										</c:choose></td>
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
										<td colspan="3">${bdderVO.bidPblancVO.bidPblancSnAsStr}</td>
									</tr>
									<tr>
										<th class="bg-light text-center">입찰 명칭</th>
										<td colspan="3">${bdderVO.bidPblancVO.bidSj}</td>
									</tr>
									<tr>
										<th rowspan="2" class="bg-light text-center align-middle">
											입찰가액 <input type="hidden" class="putBdderVO" name="bdderSn"
											value="${bdderVO.bdderSn}">
										</th>
										<td colspan="3" class="table-warning"><span
											id="bidAmount" data-bidAmount="${bdderVO.bidAmount }">
												<fmt:formatNumber value="${bdderVO.bidAmount }"
													pattern="#,### 원">
												</fmt:formatNumber>
										</span></td>
									</tr>
									<tr>
										<td colspan="3"
											style="font-size: 0.8rem; color: lightslategray;"><span
											id="bidAmountKrw"></span></td>
									</tr>
									<tr>
										<th rowspan="2" class="bg-light text-center align-middle">
											입찰보증금</th>
										<td colspan="3" class="table-warning"><span id="bidGtn"
											data-bidGtn="${bdderVO.bidGtn }"> <fmt:formatNumber
													value="${bdderVO.bidGtn }" pattern="#,### 원">
												</fmt:formatNumber>
										</span></td>
									</tr>
									<tr>
										<td colspan="3"
											style="font-size: 0.8rem; color: lightslategray;"><span
											id="bidGtnKrw"></span></td>
									</tr>
									<tr>
										<td colspan="4" class="text-center">										
											<p class="mb-2">
												위와 같이 입찰보증금(입찰가격의 100분의 <span
													style="color: red; font-weight: bold;">${bdderVO.bidPblancVO.bidGtnRt}</span>
												이상)을 첨부하여 입찰합니다.
											</p>
											<h5 class="mb-0">
												<fmt:formatDate value="${bdderVO.bidSportDt}" pattern="yyyy년 MM월 dd일" />
											</h5>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="card-footer text-center">
								<p>D-편한아파트 관리사무소장 귀중</p>
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
									<td>${bdderVO.ccpyManageVO.ccpyCmpnyNm}<input
										type="hidden" class="putBdderVO" name="ccpyManageId"
										value="${bdderVO.ccpyManageVO.ccpyManageId}" />
									</td>
								</tr>
								<tr>
									<th class="col-2 bg-light text-center">대표(명)</th>
									<td>${bdderVO.ccpyManageVO.ccpyRprsntvNm}</td>
								</tr>
								<tr>
									<th class="col-2 bg-light text-center">사업자 등록 번호</th>
									<td>${bdderVO.ccpyManageVO.ccpyBizrno}</td>
								</tr>
								<tr>
									<th class="col-2 bg-light text-center">주소</th>
									<td>${bdderVO.ccpyManageVO.ccpyAdres}</td>
								</tr>
								<tr>
									<th class="col-2 bg-light text-center">전화번호</th>
									<td>${bdderVO.ccpyManageVO.ccpyTelno}</td>
								</tr>
								<tr>
									<th class="col-2 bg-light text-center">이메일주소</th>
									<td>${bdderVO.ccpyManageVO.ccpyEmail}</td>
								</tr>
								<tr>
									<th class="bg-light" colspan="4">사업자 등록증</th>
								</tr>
								<tr>
									<td colspan="4"><img class="col-12"
										src="/upload${ccpyFileDetailVOList[0].fileStrelc}" /></td>
								</tr>
							</tbody>
							<tfoot>
								<!-- 여기서부터는 입찰 협력업체 상세 내용 및 추가 첨부 자료 -->
								<tr>
									<th class="bg-light" colspan="4">필수제출서류</th>
								</tr>
								<tr>
									<td colspan="4"><c:choose>
											<c:when test="${empty bdderFileDetailVOList}">
												<p class="text-muted">첨부파일이 없습니다.</p>
											</c:when>
											<c:otherwise>
												<!-- 전체 선택 영역 -->
												<div class="bg-light p-2 mb-2 d-flex align-items-center">
													<input type="checkbox" id="checkAll" class="mr-2" /> <label
														for="checkAll" class="mb-0">전체선택</label>
												</div>

												<!-- 파일 목록 -->
												<div class="list-group">
													<c:forEach var="file" items="${bdderFileDetailVOList}">
														<a
															href="/bidPblanc/download?fileGroupSn=${file.fileGroupSn}&fileNo=${file.fileNo}"
															class="list-group-item list-group-item-action d-flex align-items-center"
															data-file-group-sn="${file.fileGroupSn}"
															data-file-no="${file.fileNo}" target="_blank"> <input
															type="checkbox" class="fileCheck mr-2"
															value="${file.fileNo}" onclick="event.stopPropagation();" />
															<i class="fa fa-file mr-2"></i> <span>${file.fileOrginlNm}</span>
														</a>
													</c:forEach>
												</div>
												<!-- 다운로드 버튼 -->
												<div class="mt-2">
													<button id="downloadAllBtn" class="btn btn-success btn-sm">전체
														다운로드</button>
													<button id="downloadSelectedBtn"
														class="btn btn-warning btn-sm">선택 다운로드</button>
												</div>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</tfoot>
						</table>
						<!-- /.card-body -->

					</div>
					<!-- 여기서부터는 입찰 협력업체 상세 내용 및 추가 첨부 자료 -->
				</div>
				<div class="card-footer text-center">
					<c:if test="${bdderVO.bidAt != 1}">
						<button class="btn btn-success" id="submitBtn" type="button">선정</button>
					</c:if>
					<button class="btn btn-secondary" type="button" id="closeWindow">닫기</button>
				</div>
			</div>
			<!-- 오른쪽  파트 -->
		</div>
	</section>
	<!--/// body /// -->
</body>

<div class="modal fade" id="loadingModal" style="display: none;"
	aria-hidden="true">
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

</html>