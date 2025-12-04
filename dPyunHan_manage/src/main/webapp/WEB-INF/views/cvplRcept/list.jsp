<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<script src="/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/41.2.0/classic/ckeditor.js"></script>

<script>
document.addEventListener("DOMContentLoaded", () => {

    const tableBody = document.getElementById("cvplTableBody");
    const pagingArea = document.getElementById("pagingAreaWrap");
    const form = document.getElementById("searchForm");
    const currentPageInput = document.getElementById("currentPage");
    const sizeSelect = document.getElementById("sizeSelect");
    const mainListWrap = document.getElementById("mainListWrap");
    const detailWrap = document.getElementById("detailWrap");
    const detailLeft = document.getElementById("detailLeft");
    const detailRight = document.getElementById("detailRight");

    if (form && tableBody) {
        setTimeout(() => loadList(), 300);
    }

    if (sizeSelect) {
        sizeSelect.addEventListener("change", () => {
            currentPageInput.value = 1;
            loadList();
        });
    }

    if (form) {
        form.addEventListener("submit", e => {
            e.preventDefault();
            currentPageInput.value = 1;
            loadList();
        });
    }

    const resetBtn = document.getElementById("resetBtn");
    if (resetBtn) {
        resetBtn.addEventListener("click", () => {
            form.reset();
            currentPageInput.value = 1;
            loadList();
        });
    }

    function loadList() {
        const params = new URLSearchParams(new FormData(form)).toString();

        tableBody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center text-muted py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </td>
            </tr>
        `;

        fetch("/cvplRcept/listAjax?" + params)
            .then(res => res.json())
            .then(data => {
                renderTable(data.cvplVOList, data.articlePage);
                renderPagination(data.articlePage);
            })
            .catch(err => console.error("민원 리스트 요청 오류:", err));
    }

    function renderTable(list, articlePage) {

        if (!list || list.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center text-muted py-4">
                        해당 조건에 맞는 민원이 없습니다.
                    </td>
                </tr>`;
            return;
        }

        const fragment = document.createDocumentFragment();

        list.forEach((vo, index) => {

            const row = document.createElement("tr");

            row.addEventListener("click", () => {
                sessionStorage.setItem("cvplSn", vo.cvplSn);
                sessionStorage.setItem("rceptSttus", vo.rceptSttus);
                sessionStorage.setItem("cvplRceptId", vo.cvplRceptId || "");

                window.location.href = "/cvplRcept/list";
            });

            const statusText =
                vo.rceptSttus == 0 ? `<span style="color:orange;">대기 중</span>` :
                vo.rceptSttus == 1 ? `<span style="color:gray;">처리 중</span>` :
                `<span style="color:green;">완료</span>`;

            let remainHtml = "-";

            if (vo.rceptSttus === 2) {
                remainHtml = "-";
            } else if (vo.reqstDt) {
                const requestDate = new Date(vo.reqstDt.substring(0, 10));
                const deadline = new Date(requestDate);
                deadline.setDate(deadline.getDate() + 14);

                const today = new Date();
                const diff = deadline.getTime() - today.getTime();
                const remainDays = Math.floor(diff / (1000 * 60 * 60 * 24));

                if (remainDays <= 0) {
                    remainHtml = `<span>기한 만료</span>`;
                } else {
                    remainHtml = `<span>D-\${remainDays}</span>`;
                }
            }

            let actionBtns = "";

            if (vo.rceptSttus == 0) {
                actionBtns += `
                    <button type="button"
                        class="btn btn-warning btn-sm ms-1 rceptBtn"
                        style="font-size:8px; padding:0.1rem 0.1rem;"
                        data-cvplsn="\${vo.cvplSn}">
                        접수
                    </button>
                `;
            } else if (vo.rceptSttus == 1) {
                actionBtns += `
                    <button type="button"
                    	class="btn btn-success btn-sm ms-1 endBtn"
                        style="font-size:8px; padding:0.1rem 0.1rem;"
                        data-cvplrceptid="\${vo.cvplRceptId}"
                        data-cvplsn="\${vo.cvplSn}">
                        완료
                    </button>
                `;
            } else if (vo.rceptSttus == 2) {
                actionBtns += `
                    <button type="button"
                        class="btn btn-secondary btn-sm ms-1 detailBtn"
                        style="font-size:8px; padding:0.1rem 0.1rem;"
                        data-cvplsn="\${vo.cvplSn}">
                        상세
                    </button>
                `;
            }

            const startIndex = (articlePage.currentPage - 1) * articlePage.size;
            const rowNumber = startIndex + index + 1;

            row.innerHTML = `
                <td>\${rowNumber}</td>
                <td>\${vo.cvplSj}</td>
                <td>\${vo.mberNm || vo.mberId}</td>
                <td class="small text-muted mt-1">\${vo.reqstDt ? vo.reqstDt.substring(2,10) : '-'}</td>
                <td class="small text-muted mt-1">\${vo.rceptDt ? vo.rceptDt.substring(2,10) : '-'}</td>
                <td>\${statusText}</td>
                <td style="text-align:center">\${remainHtml}</td>
                <td style="text-align:center">\${actionBtns}</td>
            `;

            fragment.appendChild(row);
        });

        tableBody.replaceChildren(fragment);

        tableBody.querySelectorAll(".rceptBtn").forEach(btn => {
            btn.addEventListener("click", e => {
                e.stopPropagation();
                showDetail(btn.dataset.cvplsn, false);
            });
        });

        tableBody.querySelectorAll(".endBtn").forEach(btn => {
            btn.addEventListener("click", e => {
                e.stopPropagation();
                showDetail(btn.dataset.cvplsn, "end");
            });
        });

        tableBody.querySelectorAll(".detailBtn").forEach(btn => {
            btn.addEventListener("click", e => {
                e.stopPropagation();
                showDetail(btn.dataset.cvplsn, true);
            });
        });
    }

    function showDetail(cvplSn, mode) {
        if (mainListWrap) {
            mainListWrap.style.display = "none";
        } else {
            const cvplListTable = document.querySelector("#cvplTableBody").closest("table");
            cvplListTable.style.display = "none";
        }
        detailWrap.style.display = "flex";
        loadDetailAndForm(cvplSn, mode);
    }

    function loadDetailAndForm(cvplSn, readOnly) {
        fetch("/cvplRcept/cvplDetailAjax?cvplSn=" + cvplSn)
            .then(res => res.json())
            .then(data => {

                const cvplVO = data.cvplVO;
                const cvplRceptVO = data.cvplRceptVO;

                let fileHtml = "";

                if (
                    cvplVO.fileGroupVO &&
                    cvplVO.fileGroupVO.fileDetailVOList &&
                    cvplVO.fileGroupVO.fileDetailVOList.length > 0
                ) {
                    fileHtml = `
                        <p><strong>첨부 이미지:</strong></p>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">
                    `;

                    cvplVO.fileGroupVO.fileDetailVOList.forEach(file => {
                        const url = "/upload" + file.fileStrelc;

                        if (["jpg","jpeg","png","gif","webp"].includes(file.fileExtsn.toLowerCase())) {
                            fileHtml += `
                                <img src="\${url}"
                                    alt="\${file.fileOrginlNm}"
                                    style="width:100px;height:100px;object-fit:cover;border:1px solid #ccc;border-radius:5px;">
                            `;
                        }
                    });

                    fileHtml += `</div>`;
                } else {
                    fileHtml = `<p class="text-muted">첨부 이미지가 없습니다.</p>`;
                }

                detailLeft.innerHTML = `
                    <h5 class="fw-bold mb-3">\${cvplVO.cvplSj}</h5>
                    <p><strong>작성자:</strong> \${cvplVO.mberNm || cvplVO.mberId}</p>
                    <p><strong>요청일시:</strong> \${cvplVO.reqstDt ? cvplVO.reqstDt.substring(2,10) : '-'}</p>
                    <p><strong>내용:</strong></p>
                    <div class="border rounded p-3 bg-light mb-3">\${cvplVO.cvplCn}</div>
                    <p><strong>접수일시:</strong> \${cvplVO.rceptDt ? cvplVO.rceptDt.substring(2,10) : '-'}</p>
                    <hr>
                    <p>\${fileHtml}</p>
                `;

                if (readOnly) {
                    let rceptFileHtml = "";

                    if (
                        cvplRceptVO &&
                        cvplRceptVO.fileGroupVO &&
                        cvplRceptVO.fileGroupVO.fileDetailVOList.length > 0
                    ) {
                        rceptFileHtml = cvplRceptVO.fileGroupVO.fileDetailVOList
                            .map(f => `
                                <img src="/upload\${f.fileStrelc}"
                                    style="width:100px;height:100px;object-fit:cover;
                                    border:1px solid #ccc;border-radius:5px;">
                            `)
                            .join("");
                    } else {
                        rceptFileHtml = `<p class="text-muted">첨부 없음</p>`;
                    }

                    let endButtonHtml = "";

                    if (readOnly === "end") {
                        endButtonHtml = `
                            <button type="button"
                                class="btn btn-success"
                                id="endBtn"
                                data-cvplrceptid="\${cvplRceptVO.cvplRceptId}"
                                data-cvplsn="\${cvplVO.cvplSn}">
                                완료
                            </button>`;
                    }

                    detailRight.innerHTML = `
                        <h5 class="fw-bold mb-3">접수 내용</h5>
                        <div class="border rounded p-3 bg-light mb-3">\${cvplRceptVO.rceptCn}</div>
                        <p><strong>접수자:</strong> \${cvplRceptVO.empNm || cvplRceptVO.empId}</p>
                        <p><strong>접수일:</strong> \${cvplRceptVO.rceptDt ? cvplRceptVO.rceptDt.substring(2,10) : '-'}</p>
                        <hr>
                        <p><strong>처리 첨부파일:</strong></p>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">\${rceptFileHtml}</div>
                        <div class="text-end mt-4">
                            <button type="button" class="btn btn-secondary" id="cancelBtn">닫기</button>
                            \${endButtonHtml}
                        </div>
                    `;

                    document.getElementById("cancelBtn").addEventListener("click", closeDetail);

                    const endBtn = document.getElementById("endBtn");

                    if (endBtn) {
                        endBtn.addEventListener("click", () => {

                            const cvplRceptId = endBtn.dataset.cvplrceptid;
                            const cvplSn = endBtn.dataset.cvplsn;

                            Swal.fire({
                                title: "민원을 처리하시겠습니까?",
                                icon: "warning",
                                showCancelButton: true,
                                confirmButtonText: "예",
                                cancelButtonText: "아니오"
                            }).then(result => {
                                if (result.isConfirmed) {

                                    fetch("/cvplRcept/cvplEnPost", {
                                        method: "POST",
                                        headers: {
                                            "Content-Type": "application/x-www-form-urlencoded"
                                        },
                                        body: `cvplRceptId=\${cvplRceptId}&cvplSn=\${cvplSn}`
                                    })
                                        .then(res => res.text())
                                        .then(result => {

                                            if (parseInt(result) > 0) {
                                                Swal.fire({
                                                    icon: "success",
                                                    title: "민원이 처리되었습니다.",
                                                    timer: 1500,
                                                    showConfirmButton: false
                                                });

                                                setTimeout(() => {
                                                    closeDetail();
                                                    loadList();
                                                }, 1500);
                                            } else {
                                                Swal.fire({
                                                    icon: "warning",
                                                    title: "실패",
                                                    timer: 1500,
                                                    showConfirmButton: false
                                                });
                                            }
                                        })
                                        .catch(() => {
                                            Swal.fire({
                                                icon: "error",
                                                title: "서버 오류",
                                                timer: 1500,
                                                showConfirmButton: false
                                            });
                                        });
                                }
                            });
                        });
                    }

                    return;
                }

                detailRight.innerHTML = `
                    <h5 class="fw-bold mb-3">민원 접수</h5>
                    <form id="cvplForm" enctype="multipart/form-data">
                        <input type="hidden" name="cvplSn" value="\${cvplVO.cvplSn}">
                        <textarea id="cvplText" name="rceptCn" rows="5" cols="50"
                            placeholder="처리 내용을 입력하세요."></textarea><br>
                        <input type="file" id="cvplFile" name="uploadFiles" multiple accept="image/*"><br>
                        <div id="previewArea"
                            style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;"></div><br>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary me-2" id="cancelBtn">취소</button>
                            <button type="button" class="btn btn-primary" id="successBtn">접수</button>
                        </div>
                    </form>
                `;

                document.getElementById("cancelBtn").addEventListener("click", closeDetail);

                ClassicEditor.create(document.querySelector("#cvplText"))
                    .then(newEditor => window.cvplEditor = newEditor)
                    .catch(console.error);

                const fileInput = document.getElementById("cvplFile");
                const previewArea = document.getElementById("previewArea");

                fileInput.addEventListener("change", () => {
                    previewArea.innerHTML = "";
                    Array.from(fileInput.files).forEach(file => {
                        const reader = new FileReader();
                        reader.onload = e => {
                            const img = document.createElement("img");
                            img.src = e.target.result;
                            img.style.width = "100px";
                            img.style.height = "100px";
                            img.style.objectFit = "cover";
                            img.style.border = "1px solid #ccc";
                            img.style.borderRadius = "5px";
                            previewArea.appendChild(img);
                        };
                        reader.readAsDataURL(file);
                    });
                });

                const successBtn = document.getElementById("successBtn");
                successBtn.addEventListener("click", e => {

                    const content = window.cvplEditor.getData().trim();

                    if (!content) {
                        Swal.fire({
                            icon: "warning",
                            title: "처리 내용을 입력하세요.",
                            timer: 1500,
                            showConfirmButton: false
                        });
                        return;
                    }

                    const formData = new FormData();
                    formData.append("cvplSn", cvplVO.cvplSn);
                    formData.append("rceptCn", content);
                    formData.append("empId", "${sessionScope.emp.empId}");

                    Array.from(fileInput.files).forEach(file => {
                        formData.append("uploadFiles", file);
                    });

                    fetch("/cvplRcept/cvplRceptPost", {
                        method: "POST",
                        body: formData
                    })
                        .then(res => res.text())
                        .then(result => {
                            if (parseInt(result) > 0) {
                                Swal.fire({
                                    icon: "success",
                                    title: "민원이 접수되었습니다.",
                                    timer: 1500,
                                    showConfirmButton: false
                                });

                                setTimeout(() => {
                                    closeDetail();
                                    loadList();
                                }, 1500);

                            } else {
                                Swal.fire({
                                    icon: "warning",
                                    title: "접수 실패",
                                    timer: 1500,
                                    showConfirmButton: false
                                });
                            }
                        })
                        .catch(() => {
                            Swal.fire({
                                icon: "error",
                                title: "서버 오류",
                                timer: 1500,
                                showConfirmButton: false
                            });
                        });
                });
            });
    }

    function closeDetail() {
        detailWrap.style.display = "none";

        if (mainListWrap) {
            mainListWrap.style.display = "block";
        } else {
            const cvplListTable = document.querySelector("#cvplTableBody").closest("table");
            cvplListTable.style.display = "table";
        }
    }

    function renderPagination(articlePage) {

        if (!pagingArea) return;

        if (!articlePage || !articlePage.pagingArea) {
            pagingArea.innerHTML = "";
            return;
        }

        pagingArea.innerHTML = articlePage.pagingArea;

        pagingArea.onclick = (e) => {
            const target = e.target.closest("a");
            if (!target) return;
            e.preventDefault();
            const href = target.getAttribute("href");
            const match = href.match(/currentPage=(\d+)/);
            if (match) goPage(match[1]);
        };
    }

    function goPage(pageNo) {

        currentPageInput.value = pageNo;

        const params = new URLSearchParams(new FormData(form)).toString();

        fetch("/cvplRcept/listAjax?" + params)
            .then(res => res.json())
            .then(data => {
                renderTable(data.cvplVOList, data.articlePage);
                renderPagination(data.articlePage);
            })
            .catch(err => console.error("페이지 이동 오류:", err));
    }

});

</script>



<div id="mainListWrap">
<!-- 검색 영역 -->
	<!-- 검색 영역 -->
	<div class="card mb-3 search-card">
		<div class="card-header d-flex justify-content-between align-items-center">
			<h5 class="mb-0">
				<i class="fas fa-search me-1"></i> 민원 검색
			<small class="text-muted">조건을 선택해서 민원 목록을 필터링할 수 있습니다.</small>
			</h5>
		</div>

		<div class="card-body">
			<form id="searchForm" action="/cvplRcept/list" method="get"
				  class="row gy-3 gx-3 align-items-end">

				<input type="hidden" name="currentPage" id="currentPage"
					   value="${param.currentPage != null ? param.currentPage : 1}">

				<!-- 1줄 : 제목 / 작성자 / 처리상태 / 남은기간 -->
				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">제목</label>
					<input type="text" name="cvplSj" class="form-control"
						   placeholder="민원 제목 입력">
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">작성자</label>
					<input type="text" name="mberNm" class="form-control"
						   placeholder="작성자 이름 입력">
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">처리 상태</label>
					<select name="rceptSttus" class="form-select">
						<option value="-1">전체</option>
						<option value="0">대기 중</option>
						<option value="1">처리 중</option>
						<option value="2">완료</option>
					</select>
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">남은 기간</label>
					<select name="remainDaysRange" class="form-select">
						<option value="">전체</option>
						<option value="3">3일 이하</option>
						<option value="7">7일 이하</option>
						<option value="14">14일 이하</option>
					</select>
				</div>

				<!-- 2줄 : 기간 / 정렬 / 보기개수 + 버튼 -->
				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">요청 시작일</label>
					<input type="date" name="startDate" class="form-control">
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label">요청 종료일</label>
					<input type="date" name="endDate" class="form-control">
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label d-block mb-1">정렬 기준</label>
					<div class="d-flex flex-wrap align-items-center" style="gap: 0.5rem 1rem;">
						<div class="form-check">
							<input class="form-check-input" type="radio" name="sortType"
								   id="sortLatest" value="latest" checked>
							<label class="form-check-label" for="sortLatest">최신순</label>
						</div>
						<div class="form-check">
							<input class="form-check-input" type="radio" name="sortType"
								   id="sortRemain" value="remain">
							<label class="form-check-label" for="sortRemain">남은 기간순</label>
						</div>
					</div>
				</div>

				<div class="col-xl-3 col-lg-3 col-md-6">
					<label class="form-label fw-bold search-label d-flex justify-content-between">
						<span>보기 개수</span>
					</label>
					<div class="d-flex" style="gap: 8px;">
						<select name="size" id="sizeSelect" class="form-select">
							<option value="5">5개</option>
							<option value="10" selected>10개</option>
							<option value="20">20개</option>
							<option value="50">50개</option>
							<option value="100">100개</option>
						</select>
					</div>
					<div class="d-flex mt-2" style="gap: 8px;">
						<button type="submit" class="btn btn-primary flex-fill">검색</button>
						<button type="button" id="resetBtn"
								class="btn btn-outline-secondary flex-fill">초기화</button>
					</div>
				</div>

			</form>
		</div>
	</div>


<section class="content" style="margin: 20px">
	<div class="container-fluid">
		<!-- 섹션/컨테이너 영역 -->
		<div class="row">
			<div class="col-md-12">
			
			
				<!-- 카드 시작 -->
				<div class="card card bg-light">
					<!-- 카드헤더 시작 -->
					<div class="card-header d-flex justify-content-between align-items-center">
					<!-- 좌 제목 -->
						<h5 class="card-title mb-0">민원처리 페이지</h5>
					
				</div>
<!-- 리스트 영역 -->
<table class="table table-striped align-middle text-center tight-table">
	<thead class="table-darkr">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>요청일자</th>
			<th>접수일자</th>
			<th>처리상태</th>
			<th>남은 기간</th>
			<th>관리</th>
		</tr>
	</thead>
	<tbody id="cvplTableBody">
		<tr>
			<td colspan="8" class="text-center text-muted py-4">해당 조건에 맞는 민원이 없습니다.</td>
		</tr>
	</tbody>
</table>

<!-- 페이지네이션 -->
<div id="pagingAreaWrap" class="card-footer clearfix">
	${articlePage.pagingArea}
</div>
</div>
				</div>
			</div>
		</div>
	</div>
</section>



<!-- 상세/접수 통합 영역 -->
<section id="detailWrap" class="content" style="margin: 20px; display:none;">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">

				<!-- 카드 시작 -->
				<div class="card bg-light">
					<!-- 카드 헤더 -->
					<div class="card-header d-flex justify-content-between align-items-center">
						<h5 class="card-title mb-0">
							<i class="fas fa-comments me-1"></i> 민원 상세 & 접수 처리
						</h5>
					</div>

					<!-- 카드 바디 -->
					<div class="card-body">
						<div class="row g-3 align-items-start detail-row">

							<!-- 왼쪽: 민원 상세 -->
							<div class="col-lg-6 col-md-12 border-end" id="detailLeft"
								 style="min-height: 320px; padding-right: 20px;">
								<!-- JS에서 내용 채워짐 -->
							</div>

							<!-- 오른쪽: 접수/종결 -->
							<div class="col-lg-6 col-md-12" id="detailRight"
								 style="min-height: 320px; padding-left: 20px;">
								<!-- JS에서 내용 채워짐 -->
							</div>

						</div>
					</div>
					<!-- // 카드 바디 끝 -->

				</div>
				<!-- // 카드 끝 -->

			</div>
		</div>
	</div>
</section>



<%@ include file="../include/footer.jsp"%>
<style>
.ck.ck-editor {
    max-width: 300px;
}
.ck-editor__editable {
    min-height: 100px;
}
 
 
<style>
/* 공통 카드별 상단 영역 시작 */
body { /* 그냥 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}

.card {
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

.card-header .card-title {
	font-size: 1.2rem !important; /* 글자 크기 */
	font-weight: 700 !important;
	/* 글자 두께 살짝 굵게  400이 기본, 700이 bord정도 입니다. */
	padding-top: 4px !important; /* 상단패딩*/
	padding-bottom: 4px !important;
}
/* 공통 카드별 상단 영역 끝 */
.card-body {
	padding: 1rem !important;
}

.card-footer {
	padding: 1rem !important;
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 시작 */
.tight-table, .tight-table th, .tight-table td {
	padding: 5px 5px !important; /* 테이블들 행간격 */
	overflow: hidden !important; /* 삐져나가는거 잡아줘요 */
	text-overflow: ellipsis; /* 길어진 글은 ...처리 */
	white-space: nowrap; /* 줄바꿈 X */
	text-align: center;
}
/* 줄무늬 효과(odd는 홀수, even은 짝수) */
.tight-table tbody tr:nth-child(odd) {
	background-color: #ffffff; /* 흰색 */
}

.tight-table tbody tr:nth-child(even) {
	background-color: #f1f4fa; /* 연한 회색(AdminLTE 느낌) */
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 끝 */
/* 호버이벤트 시작 */
/* tight-table호버이벤트시작 */
.table tbody tr {
	transition: background-color 0.25s ease, box-shadow 0.25s ease,
		transform 0.2s ease;
}

.table tbody tr:hover {
	background-color: rgba(100, 140, 164, 0.12) !important; /* 은은한 파스텔 */
	box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15); /* 은은한 그림자 */
	transform: translateY(-1px); /* 살짝 띄우기 */
	cursor: pointer;
}
/* 호버이벤트 끝 */

/* 검색 카드 전용 튜닝 */
.search-card {
	transform:scale(0.97);
	margin: 0 0 1rem 0;
	border-radius: 1.2rem !important;
	border: 1px solid rgba(0, 0, 0, 0.05);
	background: rgba(255, 255, 255, 0.9);
}

.search-card .card-header {
	border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}
.search-label {
	font-size: 0.85rem;
	color: #6b7b86;
}

</style>