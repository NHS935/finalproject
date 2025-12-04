<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<!DOCTYPE html>
<html>

<head>
<title>게시글 목록</title>
<!-- FontAwesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- CKEditor 4 추가 -->
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<!-- Bootstrap JS, board페이지에는 이 cdn이 2개 삽입되어야 함. 이유 찾을 수 없음. -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


<script type="text/javascript">

                            let currentPage = 1;
                            let currentKeyword = "";
                            let bbsGroupSn = 0;
                            let currentBbsDetailNo = 0; // 모달용 추가
                            let modalEditor = null;
                            let currentMode = 'read'; // (read/edit/create)
                            let currentBbsData = null; // (현재 게시글 데이터 저장용)

                            document.addEventListener("DOMContentLoaded", function () {

                                // URL에서 bbsGroupSn 추출
                                const pathParts = window.location.pathname.split('/');
                                bbsGroupSn = pathParts[pathParts.length - 1];

                                console.log("bbsGroupSn:", bbsGroupSn);

                                // 게시판 정보 및 게시글 목록 로드
                                loadBoardData(currentPage, currentKeyword);

                                // 검색 버튼 클릭
                                document.querySelector("#btnSearch").addEventListener("click", function () {
                                    currentKeyword = document.querySelector("#keyword").value;
                                    currentPage = 1;
                                    loadBoardData(currentPage, currentKeyword);
                                });

                                // 엔터키 검색
                                document.querySelector("#keyword").addEventListener("keypress", function (e) {
                                    if (e.key === "Enter") {
                                        e.preventDefault();
                                        document.querySelector("#btnSearch").click();
                                    }
                                });

                                // 전체보기 버튼
                                document.querySelector("#btnShowAll").addEventListener("click", function () {
                                    document.querySelector("#keyword").value = "";
                                    currentKeyword = "";
                                    currentPage = 1;
                                    loadBoardData(currentPage, currentKeyword);
                                });

                                // 모달 내 수정 버튼 클릭
                                document.querySelector("#modalBtnEdit").addEventListener("click", function () {
                                    // 현재 보고 있는 게시글 데이터로 편집 모드 전환
                                    if (currentBbsData) {
                                        switchToEditMode(currentBbsData);
                                    }
                                });

                                // 모달 저장 버튼 (수정/작성 공통)
                                document.querySelector("#modalBtnSave").addEventListener("click", function () {

                                    const sj = document.querySelector("#modalEditSj").value;
                                    const cn = modalEditor ? modalEditor.getData() : "";

                                    // 유효성 검사
                                    if (!sj || sj.trim() === "") {
                        			    Swal.fire({
                        				      icon: 'warning',
                        				      title: '입력 오류',
                        				      text: '제목을 입력해주세요.',
                        				      confirmButtonColor: '#648ca4',
                        				      confirmButtonText: '확인',
                        				    	  customClass: {
                        				    	        container: 'swal-high-zindex' 
                        				    	      }
                        				    })
                                        return;
                                    }

                                    if (!cn || cn.trim() === "") {
                        			    Swal.fire({
                      				      icon: 'warning',
                      				      title: '입력 오류',
                      				      text: '내용을 입력해주세요.',
                      				      confirmButtonColor: '#648ca4',
                      				      confirmButtonText: '확인',
                      				    	  customClass: {
                      				    	        container: 'swal-high-zindex' 
                      				    	      }
                      				    })
                                        return;
                                    }

                                    if (currentMode === 'edit') {
                                        // 수정 모드
                                        saveEditBbs(sj, cn);
                                    } else if (currentMode === 'create') {
                                        // 작성 모드
                                        saveCreateBbs(sj, cn);
                                    }
                                });

                                // 모달 취소 버튼
                                document.querySelector("#modalBtnCancel").addEventListener("click", function () {
                                    if (currentMode === 'edit') {
                                        // 수정 취소 → 읽기 모드로 복귀
                                        if (currentBbsData) {
                                            displayBbsDetail(currentBbsData);
                                            switchToReadMode();
                                        }
                                    } else if (currentMode === 'create') {
                                        // 작성 취소 → 모달 닫기
                                    	Swal.fire({
                                    	    icon: 'question',
                                    	    title: '작성 취소',
                                    	    text: '작성을 취소하시겠습니까?',
                                    	    showCancelButton: true,
                                    	    confirmButtonColor: '#d33',
                                    	    cancelButtonColor: '#6c757d',
                                    	    confirmButtonText: '취소하기',
                                    	    cancelButtonText: '계속 작성',
                                    	    customClass: {
                                    	        container: 'swal-high-zindex'
                                    	    }
                                    	}).then((result) => {
                                    	    if (result.isConfirmed) {
                                    	        const modalElement = document.querySelector('#detailModal');
                                    	        const modal = bootstrap.Modal.getInstance(modalElement);
                                    	        if (modal) modal.hide();
                                    	    }
                                    	});
                                    }
                                });

                             // 모달 내 삭제 버튼 클릭
                                document.querySelector("#modalBtnDelete").addEventListener("click", function () {
                                    const bbsDetailNo = this.getAttribute("data-bbs-detail-no");

                                    if (!bbsDetailNo) {
                                        return;
                                    }

                                    Swal.fire({
                                        icon: 'warning',
                                        title: '게시글 삭제',
                                        text: '게시글을 삭제하시겠습니까? 삭제된 게시글은 복구할 수 없습니다.',
                                        showCancelButton: true,
                                        confirmButtonColor: '#d33',
                                        cancelButtonColor: '#6c757d',
                                        confirmButtonText: '삭제',
                                        cancelButtonText: '취소',
                                        customClass: {
                                            container: 'swal-high-zindex'
                                        }
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            fetch("/bbs/delete/" + bbsDetailNo, {
                                                method: "POST",
                                                headers: { "Content-Type": "application/json;charset=UTF-8" }
                                            })
                                            .then(response => response.json())
                                            .then(result => {
                                                if (result.success) {
                                                    Swal.fire({
                                                        icon: 'success',
                                                        title: '성공!',
                                                        text: '게시글이 삭제되었습니다.',
                                                        confirmButtonColor: '#648ca4',
                                                        confirmButtonText: '확인',
                                                        customClass: {
                                                            container: 'swal-high-zindex'
                                                        }
                                                    });

                                                    const modalElement = document.querySelector('#detailModal');
                                                    const modal = bootstrap.Modal.getInstance(modalElement);
                                                    if (modal) modal.hide();

                                                    loadBoardData(currentPage, currentKeyword);
                                                } else {
                                                    Swal.fire({
                                                        icon: 'error',
                                                        title: '삭제 실패',
                                                        text: result.message || '삭제에 실패했습니다.',
                                                        confirmButtonColor: '#648ca4',
                                                        confirmButtonText: '확인',
                                                        customClass: {
                                                            container: 'swal-high-zindex'
                                                        }
                                                    });
                                                }
                                            })
                                            .catch(error => {
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: '오류',
                                                    text: '삭제 요청 중 오류가 발생했습니다.',
                                                    confirmButtonColor: '#648ca4',
                                                    confirmButtonText: '확인',
                                                    customClass: {
                                                        container: 'swal-high-zindex'
                                                    }
                                                });
                                            });
                                        }
                                    });
                                });

                                // 파일 선택 시 개수 표시
                                const modalFileInput = document.querySelector("#modalMultipartFiles");
                                if (modalFileInput) {
                                    modalFileInput.addEventListener("change", function (e) {
                                        const files = e.target.files;
                                        const fileCount = document.querySelector("#modalFileCount");

                                        if (files.length > 0) {
                                            fileCount.textContent = files.length + "개의 파일이 선택되었습니다.";
                                            fileCount.style.color = "#28a745";
                                        } else {
                                            fileCount.textContent = "";
                                        }
                                    });
                                }

                                // 글쓰기 버튼 클릭
                                const btnWrite = document.querySelector("#btnWrite");
                                if (btnWrite) {
                                    btnWrite.addEventListener("click", function () {
                                        const bbsGroupData = JSON.parse(this.getAttribute("data-bbs-group"));

                                        // 작성 모드로 모달 오픈
                                        openCreateModal(bbsGroupData);
                                    });
                                }

                                // URL 파라미터에서 openDetail 확인
                                const urlParams = new URLSearchParams(window.location.search);
                                const openDetailNo = urlParams.get('openDetail');

                                if (openDetailNo) {
                                    setTimeout(function () {
                                        openDetailModal(parseInt(openDetailNo));
                                        const newUrl = window.location.pathname;
                                        window.history.replaceState({}, '', newUrl);
                                    }, 500);
                                }

                                // 모달이 닫힐 때 처리 (모든 닫기 경로에서 실행됨)
                                document.querySelector('#detailModal').addEventListener('hidden.bs.modal', function () {
                                    // CKEditor 정리
                                    destroyModalEditor();

                                    // 입력 필드 초기화
                                    document.querySelector("#modalEditSj").value = "";

                                    // 파일 입력 초기화
                                    const fileInput = document.querySelector("#modalMultipartFiles");
                                    if (fileInput) {
                                        fileInput.value = "";
                                        document.querySelector("#modalFileCount").textContent = "";
                                    }

                                    // ========== 추가: Backdrop 강제 정리 ========== //

                                    // 남아있는 backdrop 모두 제거
                                    const backdrops = document.querySelectorAll('.modal-backdrop');
                                    backdrops.forEach(backdrop => backdrop.remove());

                                    // body 클래스 정리
                                    document.body.classList.remove('modal-open');
                                    document.body.style.overflow = '';
                                    document.body.style.paddingRight = '';
                                });

                                // 모달 X 버튼
                                document.querySelector("#modalCloseBtn").addEventListener("click", function () {
                                    const modalElement = document.querySelector('#detailModal');
                                    const modal = bootstrap.Modal.getInstance(modalElement);
                                    if (modal) modal.hide();
                                });

                                // 모달 닫기 버튼
                                document.querySelector("#modalBtnClose").addEventListener("click", function () {
                                    const modalElement = document.querySelector('#detailModal');
                                    const modal = bootstrap.Modal.getInstance(modalElement);
                                    if (modal) modal.hide();
                                });
                            });

                            // 게시판 데이터 로드 함수
                            function loadBoardData(page, keyword) {
                                const url = "/bbs/board/" + bbsGroupSn + "/data?currentPage=" + page + "&keyword=" + encodeURIComponent(keyword);

                                fetch(url, {
                                    method: "GET"
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("서버 응답 오류");
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        console.log("게시판 데이터:", data);
                                        displayBoardInfo(data.bbsGroup);
                                        displayBbsList(data.bbsList);
                                        displayPaging(data.articlePage);
                                    })
                                    .catch(error => {
                                        console.error("데이터 로드 오류:", error);
                                        Swal.fire({
                                            icon: 'error',
                                            title: '로드 실패',
                                            text: '게시판 데이터를 불러오는데 실패했습니다.',
                                            confirmButtonColor: '#648ca4',
                                            confirmButtonText: '확인',
                                            customClass: {
                                                container: 'swal-high-zindex'
                                            }
                                        });
                                    });
                            }

                            // 게시판 정보 표시
                            function displayBoardInfo(bbsGroup) {
                                // 게시판 이름 표시
                                const titleElement = document.querySelector("#bbsGroupName");
                                if (titleElement) {
                                    titleElement.innerHTML = `
            <i class="fas fa-clipboard-list"></i> 
            <span>\${bbsGroup.bbsNm}</span>
        `;
                                }

                                // 글쓰기 버튼에 게시판 정보 저장
                                const writeBtn = document.querySelector("#btnWrite");
                                if (writeBtn) {
                                    writeBtn.setAttribute("data-bbs-group", JSON.stringify(bbsGroup));
                                }
                            }

                            // 날짜 포맷팅 함수 (yyyy-MM-dd)
                            function formatDate(dateString) {
                                const date = new Date(dateString);

                                const year = date.getFullYear();
                                const month = String(date.getMonth() + 1).padStart(2, '0');
                                const day = String(date.getDate()).padStart(2, '0');

                                return year + '-' + month + '-' + day;
                            }

                            // 아이디 마스킹 (4번째 글자부터)
                            function maskUserId(userId) {
                                if (!userId || userId.length <= 3) {
                                    return userId;  // 3글자 이하면 그대로
                                }

                                const visible = userId.substring(0, 3);  // 앞 3글자
                                const masked = '*'.repeat(userId.length - 3);  // 나머지 *

                                return visible + masked;
                            }

                            // 게시글 목록 표시
                            function displayBbsList(bbsList) {
                                const tbody = document.querySelector("#bbsListBody");
                                tbody.innerHTML = "";

                                if (!bbsList || bbsList.length === 0) {
                                    const message = currentKeyword ? "검색 결과가 없습니다." : "등록된 게시글이 없습니다.";
                                    tbody.innerHTML = `
            <tr>
                <td colspan="4" style="text-align: center; padding: 2rem; color: #6c757d;">
                    <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                    <div>\${message}</div>
                </td>
            </tr>
        `;
                                    return;
                                }

                                bbsList.forEach(bbs => {
                                    const tr = document.createElement("tr");

                                    // 검색어가 있으면 배지 표시
                                    const searchBadge = currentKeyword ? '<span class="search-badge"><i class="fas fa-search"></i> 검색됨</span>' : '';

                                    tr.innerHTML = `
            <td class="modern-cell-number">\${bbs.rnum}</td>
            <td class="modern-cell-title">
                \${searchBadge}
                <a href="#" onclick="openDetailModal(\${bbs.bbsDetailNo}); return false;" style="color: #495057; text-decoration: none;">
                    \${bbs.sj}
                </a>
            </td>
            <td class="modern-cell-author">\${maskUserId(bbs.mberId)}</td>
            <td class="modern-cell-date">\${formatDate(bbs.writngDt)}</td>
        `;

                                    // 클릭 이벤트 추가
                                    tr.addEventListener("click", function () {
                                        openDetailModal(bbs.bbsDetailNo);
                                    });

                                    tbody.appendChild(tr);
                                });
                            }

                            // 페이징 표시
                            function displayPaging(articlePage) {
                                const pagingArea = document.querySelector("#pagingArea");

                                if (!articlePage || !articlePage.pagingArea) {
                                    pagingArea.innerHTML = "";
                                    return;
                                }

                                // 서버에서 생성된 페이징 HTML을 그대로 사용
                                pagingArea.innerHTML = articlePage.pagingArea;

                                // 페이지 링크에 이벤트 리스너 추가
                                const pageLinks = pagingArea.querySelectorAll("a");
                                pageLinks.forEach(link => {
                                    link.addEventListener("click", function (e) {
                                        e.preventDefault();

                                        // href에서 페이지 번호 추출
                                        const href = this.getAttribute("href");
                                        const pageMatch = href.match(/currentPage=(\d+)/);

                                        if (pageMatch) {
                                            currentPage = parseInt(pageMatch[1]);
                                            loadBoardData(currentPage, currentKeyword);
                                        }
                                    });
                                });
                            }

                            // ==================== 모달 관련 함수 ====================

                            // 게시글 상세 모달 열기
                            function openDetailModal(bbsDetailNo) {
                                console.log("모달 오픈 - bbsDetailNo:", bbsDetailNo);

                                // 상세 데이터 로드
                                loadBbsDetail(bbsDetailNo);

                                // 모달 열기
                                const modalElement = document.querySelector('#detailModal');
                                const modal = new bootstrap.Modal(modalElement);
                                modal.show();
                            }

                            // 게시글 상세 데이터 로드
                            function loadBbsDetail(bbsDetailNo) {
                                currentBbsDetailNo = bbsDetailNo;

                                fetch("/bbs/detail/" + bbsDetailNo + "/data", {
                                    method: "GET"
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("서버 응답 오류");
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        displayBbsDetail(data);
                                    })
                                    .catch(error => {
                                        Swal.fire({
                                            icon: 'error',
                                            title: '로드 실패',
                                            text: '게시글 상세를 불러오는데 실패했습니다.',
                                            confirmButtonColor: '#648ca4',
                                            confirmButtonText: '확인',
                                            customClass: {
                                                container: 'swal-high-zindex'
                                            }
                                        });
                                    });
                            }

                            // 게시글 상세 표시
                            function displayBbsDetail(data) {
                                // 제목, 작성자, 작성일, 내용 표시
                                document.querySelector("#modalBbsSj").textContent = data.bbs.sj;
                                document.querySelector("#modalBbsMberId").textContent = maskUserId(data.bbs.mberId);  // ← 마스킹 적용
                                document.querySelector("#modalBbsWritngDt").textContent = formatDateTime(data.bbs.writngDt);
                                document.querySelector("#modalBbsCn").innerHTML = data.bbs.cn;

                                // 첨부파일 표시
                                displayFiles(data.fileList);

                                // 댓글 표시 (댓글 가능한 게시판인 경우)
                                if (data.bbsGroup.answerAt == 1) {
                                    document.querySelector("#answerSection").style.display = "block";
                                    displayAnswers(data.answerList, data.currentMberId, data.answerCount);
                                } else {
                                    document.querySelector("#answerSection").style.display = "none";
                                }

                                // 수정/삭제 버튼 표시 여부
                                const editBtn = document.querySelector("#modalBtnEdit");
                                const deleteBtn = document.querySelector("#modalBtnDelete");

                                if (data.currentMberId && data.bbs.mberId === data.currentMberId) {
                                    editBtn.style.display = "inline-block";
                                    deleteBtn.style.display = "inline-block";

                                    // 수정/삭제 버튼에 bbsDetailNo 설정
                                    editBtn.setAttribute("data-bbs-detail-no", data.bbs.bbsDetailNo);
                                    deleteBtn.setAttribute("data-bbs-detail-no", data.bbs.bbsDetailNo);
                                } else {
                                    editBtn.style.display = "none";
                                    deleteBtn.style.display = "none";
                                }

                                // 현재 게시글 데이터 저장(수정 모드 전환 시 사용)
                                currentBbsData = data;

                                // 읽기 모드로 전환
                                switchToReadMode();
                            }

                            // 날짜 포맷 (yyyy-MM-dd HH:mm:ss)
                            function formatDateTime(dateString) {
                                const date = new Date(dateString);
                                const year = date.getFullYear();
                                const month = String(date.getMonth() + 1).padStart(2, '0');
                                const day = String(date.getDate()).padStart(2, '0');
                                const hours = String(date.getHours()).padStart(2, '0');
                                const minutes = String(date.getMinutes()).padStart(2, '0');
                                const seconds = String(date.getSeconds()).padStart(2, '0');
                                return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                            }

                            // 첨부파일 표시
                            function displayFiles(fileList) {
                                const fileArea = document.querySelector("#modalFileList");

                                if (!fileList || fileList.length === 0) {
                                    fileArea.style.display = "none";
                                    return;
                                }

                                fileArea.style.display = "block";
                                let html = '';

                                fileList.forEach(file => {
                                    const fileSize = (file.fileMg / 1024).toFixed(2);
                                    html += `
                                            <div style="margin-bottom: 5px;">
                                                <i class="fas fa-paperclip"></i>
                                                <a href="/file/download?fileGroupSn=\${file.fileGroupSn}&fileNo=\${file.fileNo}" 
                                                download="\${file.fileOrginlNm}">
                                                    \${file.fileOrginlNm}
                                                </a
                                                <span style="color: #6c757d; font-size: 0.9em;">(\${fileSize} KB)</span>
                                            </div>
                                        `;
                                });

                                document.querySelector("#modalFiles").innerHTML = html;
                            }

                            // 댓글 표시
                            function displayAnswers(answerList, currentMberId, answerCount) {
                                document.querySelector("#modalAnswerCount").textContent = answerCount;

                                const answerListDiv = document.querySelector("#modalAnswerList");

                                if (!answerList || answerList.length === 0) {
                                    answerListDiv.innerHTML = '<p style="text-align: center; color: #6c757d;">댓글이 없습니다.</p>';
                                    return;
                                }

                                let html = '';

                                answerList.forEach(answer => {
                                    html += `
            <div class="answer-item" style="border-bottom: 1px solid #eee; padding: 15px 0;">
                <div style="color: #6c757d; font-size: 0.85em; margin-bottom: 10px;">
               		<strong>\${maskUserId(answer.mberId)}</strong>	
                    <span> | \${formatDateTime(answer.writngDt)}</span>
                </div>
                <div id="answerContent_\${answer.answerNo}" style="margin-bottom: 10px;">\${answer.cn}</div>
                <textarea id="answerEdit_\${answer.answerNo}" class="form-control" rows="3" style="display: none; margin-bottom: 10px;">\${answer.cn}</textarea>
        `;

                                    html += `<div style="margin-top: 5px;">`;

                                    // 답글 버튼은 모든 사용자에게 표시
                                    html += `<button type="button" class="btn btn-info btn-sm" onclick="toggleReplyForm(\${answer.answerNo})">답글</button> `;

                                    // 수정/삭제는 작성자만
                                    if (currentMberId === answer.mberId) {
                                        html += `
                    <span id="answerBtns_\${answer.answerNo}">
                        <button type="button" class="btn btn-warning btn-sm" onclick="editAnswerInModal(\${answer.answerNo})">수정</button>
                        <button type="button" class="btn btn-danger btn-sm" onclick="deleteAnswerInModal(\${answer.answerNo})">삭제</button>
                    </span>
                    <span id="answerEditBtns_\${answer.answerNo}" style="display: none;">
                        <button type="button" class="btn btn-success btn-sm" onclick="saveAnswerEdit(\${answer.answerNo})">저장</button>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="cancelAnswerEdit(\${answer.answerNo}, '\${answer.cn.replace(/'/g, "\\'")}')">취소</button>
                    </span>
                `;
                                    }

                                    html += `</div>`;

                                    // 답글 작성 폼 추가
                                    html += `
                <div id="replyForm_\${answer.answerNo}" class="reply-form" style="display: none; margin-top: 10px; margin-left: 20px; padding: 10px; background-color: #f8f9fa; border-radius: 5px;">
                    <textarea id="replyContent_\${answer.answerNo}" class="form-control form-control-sm" rows="2" placeholder="답글을 입력하세요"></textarea>
                    <div style="margin-top: 5px;">
                        <button type="button" class="btn btn-primary btn-sm" onclick="addReplyInModal(\${answer.answerNo})">답글 등록</button>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="toggleReplyForm(\${answer.answerNo})">취소</button>
                    </div>
                </div>
            `;

                                    html += '</div>';

                                    html += '</div>';

                                    // 대댓글이 있는 경우
                                    if (answer.replyList && answer.replyList.length > 0) {
                                        answer.replyList.forEach(reply => {
                                            html += `
                    <div class="reply-item" style="margin-left: 40px; padding: 10px; border-left: 3px solid #007bff; background-color: #f8f9fa; margin-bottom: 10px;">
                        <div style="color: #6c757d; font-size: 0.85em; margin-bottom: 10px;">
                            <strong>\${maskUserId(reply.mberId)}</strong>
                            <span> | \${formatDateTime(reply.writngDt)}</span>
                        </div>
                        <div id="answerContent_\${reply.answerNo}">\${reply.cn}</div>
                        <textarea id="answerEdit_\${reply.answerNo}" class="form-control" rows="3" style="display: none; margin-bottom: 10px;">\${reply.cn}</textarea>
                `;

                                            if (currentMberId === reply.mberId) {
                                                html += `
                        <div id="answerBtns_\${reply.answerNo}" style="margin-top: 5px;">
                            <button type="button" class="btn btn-warning btn-sm" onclick="editAnswerInModal(\${reply.answerNo})">수정</button>
                            <button type="button" class="btn btn-danger btn-sm" onclick="deleteAnswerInModal(\${reply.answerNo})">삭제</button>
                        </div>
                        <div id="answerEditBtns_\${reply.answerNo}" style="display: none; margin-top: 5px;">
                            <button type="button" class="btn btn-success btn-sm" onclick="saveAnswerEdit(\${reply.answerNo})">저장</button>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="cancelAnswerEdit(\${reply.answerNo}, '\${reply.cn.replace(/'/g, "\\'")}')">취소</button>
                        </div>
                    `;
                                            }

                                            html += '</div>';
                                        });
                                    }
                                });

                                answerListDiv.innerHTML = html;
                            }

                            // 댓글 작성 (모달 내)
                            function addAnswerInModal() {
                                const content = document.querySelector("#modalAnswerContent").value;

                                if (!content || content.trim() === "") {
                                	Swal.fire({
                                	    icon: 'info',
                                	    title: '입력 오류',
                                	    text: '댓글 내용을 입력하세요.',
                                	    confirmButtonColor: '#648ca4',
                                	    confirmButtonText: '확인',
                                	    customClass: {
                                	        container: 'swal-high-zindex'
                                	    }
                                	});
                                    return;
                                }

                                const data = {
                                    "bbsDetailNo": currentBbsDetailNo,
                                    "bbsGroupSn": bbsGroupSn,
                                    "cn": content
                                };

                                fetch("/bbs/answer/insert", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json;charset=UTF-8" },
                                    body: JSON.stringify(data)
                                })
                                    .then(response => response.json())
                                    .then(result => {
                                        if (result.result > 0) {
                                            document.querySelector("#modalAnswerContent").value = "";
                                            displayAnswers(result.answerList, result.mberId, result.answerCount);
                                        }
                                    })
                                    .catch(error => {
                                        Swal.fire({
                                            icon: 'error',
                                            title: '등록 실패',
                                            text: '댓글 등록에 실패했습니다.',
                                            confirmButtonColor: '#648ca4',
                                            confirmButtonText: '확인',
                                            customClass: {
                                                container: 'swal-high-zindex'
                                            }
                                        });
                                    });
                            }

                            // 댓글 수정 모드로 전환
                            function editAnswerInModal(answerNo) {
                                // 내용 숨기고 textarea 보이기
                                document.querySelector("#answerContent_" + answerNo).style.display = "none";
                                document.querySelector("#answerEdit_" + answerNo).style.display = "block";

                                // 버튼 전환
                                document.querySelector("#answerBtns_" + answerNo).style.display = "none";
                                document.querySelector("#answerEditBtns_" + answerNo).style.display = "block";
                            }

                            // 댓글 수정 취소
                            function cancelAnswerEdit(answerNo, originalContent) {
                                // textarea 내용 원래대로 복구
                                document.querySelector("#answerEdit_" + answerNo).value = originalContent;

                                // textarea 숨기고 내용 보이기
                                document.querySelector("#answerEdit_" + answerNo).style.display = "none";
                                document.querySelector("#answerContent_" + answerNo).style.display = "block";

                                // 버튼 전환
                                document.querySelector("#answerEditBtns_" + answerNo).style.display = "none";
                                document.querySelector("#answerBtns_" + answerNo).style.display = "block";
                            }

                            // 댓글 수정 저장
                            function saveAnswerEdit(answerNo) {
                                const newContent = document.querySelector("#answerEdit_" + answerNo).value;

                                if (!newContent || newContent.trim() === "") {
                                	Swal.fire({
                                	    icon: 'info',
                                	    title: '입력 오류',
                                	    text: '댓글 내용을 입력하세요.',
                                	    confirmButtonColor: '#648ca4',
                                	    confirmButtonText: '확인',
                                	    customClass: {
                                	        container: 'swal-high-zindex'
                                	    }
                                	});
                                    return;
                                }

                                const data = {
                                    "answerNo": answerNo,
                                    "cn": newContent
                                };

                                fetch("/bbs/answer/update", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json;charset=UTF-8" },
                                    body: JSON.stringify(data)
                                })
                                    .then(response => response.json())
                                    .then(result => {
                                        if (result.result > 0) {
                                            // 수정된 내용으로 업데이트
                                            document.querySelector("#answerContent_" + answerNo).textContent = result.answerVO.cn;

                                            // 편집 모드 종료
                                            document.querySelector("#answerEdit_" + answerNo).style.display = "none";
                                            document.querySelector("#answerContent_" + answerNo).style.display = "block";

                                            document.querySelector("#answerEditBtns_" + answerNo).style.display = "none";
                                            document.querySelector("#answerBtns_" + answerNo).style.display = "block";

                                            Swal.fire({
                                                icon: 'success',
                                                title: '수정 완료',
                                                text: '댓글이 수정되었습니다.',
                                                confirmButtonColor: '#648ca4',
                                                confirmButtonText: '확인',
                                                customClass: {
                                                    container: 'swal-high-zindex'
                                                }
                                            });
                                        } else {
                                        	Swal.fire({
                                        	    icon: 'error',
                                        	    title: '수정 실패',
                                        	    text: result.message || '댓글 수정에 실패했습니다.',
                                        	    confirmButtonColor: '#648ca4',
                                        	    confirmButtonText: '확인',
                                        	    customClass: {
                                        	        container: 'swal-high-zindex'
                                        	    }
                                        	});
                                        }
                                    })
                                    .catch(error => {
                                    	Swal.fire({
                                    	    icon: 'error',
                                    	    title: '수정 실패',
                                    	    text: '댓글 수정에 실패했습니다.',
                                    	    confirmButtonColor: '#648ca4',
                                    	    confirmButtonText: '확인',
                                    	    customClass: {
                                    	        container: 'swal-high-zindex'
                                    	    }
                                    	});
                                    });
                            }

                            // 댓글 삭제 (모달 내)
                            function deleteAnswerInModal(answerNo) {
								    Swal.fire({
								        icon: 'warning',
								        title: '댓글 삭제',
								        text: '댓글을 삭제하시겠습니까?',
								        showCancelButton: true,
								        confirmButtonColor: '#d33',
								        cancelButtonColor: '#6c757d',
								        confirmButtonText: '삭제',
								        cancelButtonText: '취소',
								        customClass: {
								            container: 'swal-high-zindex'
								        }
								    }).then((result) => {
								        if (result.isConfirmed) {
								            fetch("/bbs/answer/delete/" + answerNo, {
								                method: "POST",
								                headers: { "Content-Type": "application/json;charset=UTF-8" }
								            })
								                .then(response => response.json())
								                .then(result => {
								                    if (result.result > 0) {
								                        Swal.fire({
								                            icon: 'success',
								                            title: '삭제 완료',
								                            text: '댓글이 삭제되었습니다.',
								                            confirmButtonColor: '#648ca4',
								                            confirmButtonText: '확인',
								                            customClass: {
								                                container: 'swal-high-zindex'
								                            }
								                        });
								                        // 게시글 상세 다시 로드
								                        loadBbsDetail(currentBbsDetailNo);
								                    } else {
								                        Swal.fire({
								                            icon: 'error',
								                            title: '삭제 실패',
								                            text: result.message || '댓글 삭제에 실패했습니다.',
								                            confirmButtonColor: '#648ca4',
								                            confirmButtonText: '확인',
								                            customClass: {
								                                container: 'swal-high-zindex'
								                            }
								                        });
								                    }
								                })
								                .catch(error => {
								                    console.error("댓글 삭제 오류:", error);
								                    Swal.fire({
								                        icon: 'error',
								                        title: '삭제 실패',
								                        text: '댓글 삭제에 실패했습니다.',
								                        confirmButtonColor: '#648ca4',
								                        confirmButtonText: '확인',
								                        customClass: {
								                            container: 'swal-high-zindex'
								                        }
								                    });
								                });
								        }
								    });
								}

                            //CKEditor 초기화
                            function initModalEditor() {
                                // 이미 초기화된 경우 제거
                                if (modalEditor) {
                                    modalEditor.destroy();
                                    modalEditor = null;
                                }

                                // CKEditor 초기화
                                modalEditor = CKEDITOR.replace('modalEditCn', {
                                    height: 400,
                                    versionCheck: false,
                                    toolbarCanCollapse: true,
                                    toolbarStartupExpanded: false
                                });
                            }

                            // CKEditor 제거 (편집 모드 종료 시)
                            function destroyModalEditor() {
                                if (modalEditor) {
                                    modalEditor.destroy();
                                    modalEditor = null;
                                }
                            }

                            //읽기 모드로 전환
                            function switchToReadMode() {
                                currentMode = 'read';

                                // 영역 표시/숨김
                                document.querySelector("#readMode").style.display = "block";
                                document.querySelector("#editMode").style.display = "none";

                                // 버튼 표시/숨김
                                document.querySelector("#readModeButtons").style.display = "block";
                                document.querySelector("#editModeButtons").style.display = "none";

                                // 모달 제목 변경
                                document.querySelector("#modalTitle").textContent = "게시글 상세";

                                // CKEditor 제거
                                destroyModalEditor();
                            }

                            // 편집 모드로 전환 (수정)
                            function switchToEditMode(bbsData) {
                                currentMode = 'edit';
                                currentBbsData = bbsData;

                                // 영역 표시/숨김
                                document.querySelector("#readMode").style.display = "none";
                                document.querySelector("#editMode").style.display = "block";

                                // 버튼 표시/숨김
                                document.querySelector("#readModeButtons").style.display = "none";
                                document.querySelector("#editModeButtons").style.display = "block";

                                // 모달 제목 변경
                                document.querySelector("#modalTitle").textContent = "게시글 수정";

                                // 기존 데이터 채우기
                                document.querySelector("#modalEditSj").value = bbsData.bbs.sj;

                                // CKEditor 초기화 및 내용 설정
                                initModalEditor();

                                // CKEditor가 완전히 로드된 후 데이터 설정
                                setTimeout(function () {
                                    if (modalEditor) {
                                        modalEditor.setData(bbsData.bbs.cn);
                                    }
                                }, 100);

                                // 파일 업로드 영역 표시 여부
                                if (bbsData.bbsGroup.atchFileAt == 1) {
                                    document.querySelector("#modalFileUploadArea").style.display = "block";
                                } else {
                                    document.querySelector("#modalFileUploadArea").style.display = "none";
                                }

                                // 기존 첨부파일 표시
                                if (bbsData.fileList && bbsData.fileList.length > 0) {
                                    displayExistingFiles(bbsData.fileList);
                                }
                            }

                            // 작성 모드로 전환
                            function switchToCreateMode(bbsGroupData) {
                                currentMode = 'create';
                                currentBbsData = { bbsGroup: bbsGroupData };

                                // 영역 표시/숨김
                                document.querySelector("#readMode").style.display = "none";
                                document.querySelector("#editMode").style.display = "block";

                                // 버튼 표시/숨김
                                document.querySelector("#readModeButtons").style.display = "none";
                                document.querySelector("#editModeButtons").style.display = "block";

                                // 모달 제목 변경
                                document.querySelector("#modalTitle").textContent = "게시글 작성";

                                // 입력 필드 초기화
                                document.querySelector("#modalEditSj").value = "";

                                // CKEditor 초기화
                                initModalEditor();

                                setTimeout(function () {
                                    if (modalEditor) {
                                        modalEditor.setData("");
                                    }
                                }, 100);

                                // 파일 업로드 영역 표시 여부
                                if (bbsGroupData.atchFileAt == 1) {
                                    document.querySelector("#modalFileUploadArea").style.display = "block";
                                } else {
                                    document.querySelector("#modalFileUploadArea").style.display = "none";
                                }

                                // 기존 파일 영역 숨김
                                document.querySelector("#modalExistingFiles").style.display = "none";
                            }

                            // 기존 첨부파일 표시 (수정 모드)
                            function displayExistingFiles(fileList) {
                                const existingFilesDiv = document.querySelector("#modalExistingFiles");
                                const fileListDiv = document.querySelector("#modalExistingFileList");

                                let html = '';
                                fileList.forEach(file => {
                                    const fileSize = (file.fileMg / 1024).toFixed(2);
                                    html += `
            <div style="margin-bottom: 5px;">
                <i class="fas fa-paperclip"></i>
                <a href="/file/download?fileGroupSn=\${file.fileGroupSn}&fileNo=\${file.fileNo}">
                    \${file.fileOrginlNm}
                </a>
                <span style="color: #6c757d; font-size: 0.9em;">(\${fileSize} KB)</span>
            </div>
        `;
                                });

                                fileListDiv.innerHTML = html;
                                existingFilesDiv.style.display = "block";
                            }

                            // 게시글 수정 저장
                            function saveEditBbs(sj, cn) {
                                const bbsDetailNo = currentBbsData.bbs.bbsDetailNo;

                                // JSON 대신 FormData 사용
                                const formData = new FormData();
                                formData.append("bbsDetailNo", bbsDetailNo);
                                formData.append("sj", sj);
                                formData.append("cn", cn);

                                // 파일 첨부 (새로 추가된 파일이 있는 경우)
                                const fileInput = document.querySelector("#modalMultipartFiles");
                                if (fileInput && fileInput.files.length > 0) {
                                    for (let i = 0; i < fileInput.files.length; i++) {
                                        formData.append("multipartFiles", fileInput.files[i]);
                                    }
                                }

                                fetch("/bbs/update", {
                                    method: "POST",
                                    body: formData
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("서버 응답 오류");
                                        }
                                        return response.json();
                                    })
                                    .then(result => {
                                        if (result.result > 0) {
                                        	Swal.fire({
                                        	    icon: 'success',
                                        	    title: '수정 완료',
                                        	    text: '게시글이 수정되었습니다.',
                                        	    confirmButtonColor: '#648ca4',
                                        	    confirmButtonText: '확인',
                                        	    customClass: {
                                        	        container: 'swal-high-zindex'
                                        	    }
                                        	});

                                            // 수정된 게시글 다시 로드
                                            loadBbsDetail(bbsDetailNo);
                                        } else {
                                        	Swal.fire({
                                        	    icon: 'error',
                                        	    title: '수정 실패',
                                        	    text: result.message || '수정에 실패했습니다.',
                                        	    confirmButtonColor: '#648ca4',
                                        	    confirmButtonText: '확인',
                                        	    customClass: {
                                        	        container: 'swal-high-zindex'
                                        	    }
                                        	});
                                        }
                                    })
                                    .catch(error => {
                                    	Swal.fire({
                                    	    icon: 'error',
                                    	    title: '오류',
                                    	    text: '수정 요청 중 오류가 발생했습니다.',
                                    	    confirmButtonColor: '#648ca4',
                                    	    confirmButtonText: '확인',
                                    	    customClass: {
                                    	        container: 'swal-high-zindex'
                                    	    }
                                    	});
                                    });
                            }

                            // 게시글 작성 저장
                            function saveCreateBbs(sj, cn) {
                                const formData = new FormData();
                                formData.append("bbsGroupSn", bbsGroupSn);
                                formData.append("sj", sj);
                                formData.append("cn", cn);

                                // 파일 첨부
                                const fileInput = document.querySelector("#modalMultipartFiles");
                                if (fileInput && fileInput.files.length > 0) {
                                    for (let i = 0; i < fileInput.files.length; i++) {
                                        formData.append("multipartFiles", fileInput.files[i]);
                                    }
                                }

                                fetch("/bbs/register", {
                                    method: "POST",
                                    body: formData
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("서버 응답 오류");
                                        }
                                        return response.json();
                                    })
                                    .then(result => {
                                        if (result.result > 0) {
                                        	Swal.fire({
                                        	    icon: 'success',
                                        	    title: '등록 완료',
                                        	    text: '게시글이 등록되었습니다.',
                                        	    confirmButtonColor: '#648ca4',
                                        	    confirmButtonText: '확인',
                                        	    customClass: {
                                        	        container: 'swal-high-zindex'
                                        	    }
                                        	});

                                            // 목록 새로고침
                                            loadBoardData(currentPage, currentKeyword);

                                            // 작성한 게시글 데이터 로드 (모달은 열린 상태 유지)
                                            loadBbsDetail(result.bbsDetailNo);
                                        } else {
                                        	Swal.fire({
                                        	    icon: 'error',
                                        	    title: '등록 실패',
                                        	    text: result.message || '등록에 실패했습니다.',
                                        	    confirmButtonColor: '#648ca4',
                                        	    confirmButtonText: '확인',
                                        	    customClass: {
                                        	        container: 'swal-high-zindex'
                                        	    }
                                        	});
                                        }
                                    })
                                    .catch(error => {
                                        console.error("등록 오류:", error);
                                        Swal.fire({
                                            icon: 'error',
                                            title: '오류',
                                            text: '등록 요청 중 오류가 발생했습니다.',
                                            confirmButtonColor: '#648ca4',
                                            confirmButtonText: '확인',
                                            customClass: {
                                                container: 'swal-high-zindex'
                                            }
                                        });
                                    });
                            }

                            // 게시글 작성 모달 열기
                            function openCreateModal(bbsGroupData) {

                                // 입력 필드 초기화
                                document.querySelector("#modalEditSj").value = "";

                                // 파일 입력 초기화
                                const fileInput = document.querySelector("#modalMultipartFiles");
                                if (fileInput) {
                                    fileInput.value = "";
                                    document.querySelector("#modalFileCount").textContent = "";
                                }

                                // 작성 모드로 전환
                                switchToCreateMode(bbsGroupData);

                                // 모달 열기
                                const modalElement = document.querySelector('#detailModal');
                                const modal = new bootstrap.Modal(modalElement);
                                modal.show();
                            }

                            // 답글 작성 폼 토글
                            function toggleReplyForm(answerNo) {
                                const replyForm = document.querySelector("#replyForm_" + answerNo);

                                if (replyForm.style.display === "none" || replyForm.style.display === "") {
                                    replyForm.style.display = "block";
                                    // 포커스 이동
                                    document.querySelector("#replyContent_" + answerNo).focus();
                                } else {
                                    replyForm.style.display = "none";
                                    // 내용 초기화
                                    document.querySelector("#replyContent_" + answerNo).value = "";
                                }
                            }

                            // 답글(대댓글) 등록
                            function addReplyInModal(upperAnswerNo) {
                                const content = document.querySelector("#replyContent_" + upperAnswerNo).value;

                                if (!content || content.trim() === "") {
                                	Swal.fire({
                                	    icon: 'info',
                                	    title: '입력 오류',
                                	    text: '답글 내용을 입력하세요.',
                                	    confirmButtonColor: '#648ca4',
                                	    confirmButtonText: '확인',
                                	    customClass: {
                                	        container: 'swal-high-zindex'
                                	    }
                                	});
                                    return;
                                }

                                const data = {
                                    "bbsDetailNo": currentBbsDetailNo,
                                    "bbsGroupSn": bbsGroupSn,
                                    "cn": content,
                                    "upperAnswerNo": upperAnswerNo
                                };

                                fetch("/bbs/answer/insert", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json;charset=UTF-8" },
                                    body: JSON.stringify(data)
                                })
                                    .then(response => response.json())
                                    .then(result => {
                                        if (result.result > 0) {
                                            // 답글 폼 닫기 및 초기화
                                            document.querySelector("#replyContent_" + upperAnswerNo).value = "";
                                            toggleReplyForm(upperAnswerNo);

                                            // 댓글 목록 새로고침
                                            displayAnswers(result.answerList, result.mberId, result.answerCount);

                                            Swal.fire({
                                                icon: 'success',
                                                title: '등록 완료',
                                                text: '답글이 등록되었습니다.',
                                                confirmButtonColor: '#648ca4',
                                                confirmButtonText: '확인',
                                                customClass: {
                                                    container: 'swal-high-zindex'
                                                }
                                            });
                                        }
                                    })
                                    .catch(error => {
                                        console.error("답글 등록 오류:", error);
                                        Swal.fire({
                                            icon: 'error',
                                            title: '등록 실패',
                                            text: '답글 등록에 실패했습니다.',
                                            confirmButtonColor: '#648ca4',
                                            confirmButtonText: '확인',
                                            customClass: {
                                                container: 'swal-high-zindex'
                                            }
                                        });
                                    });
                            }

                            function toggleFilter() {
                                const filterAccordion = document.getElementById('filterAccordion');
                                const toggleIcon = document.querySelector('.filter-toggle-icon');
                                const isVisible = filterAccordion.style.display === 'block';

                                filterAccordion.style.display = isVisible ? 'none' : 'block';
                                if (toggleIcon) {
                                    toggleIcon.style.transform = isVisible ? 'rotate(0deg)' : 'rotate(180deg)';
                                }
                            }
                        </script>
<style>
/* 전체 컨테이너 */
.modern-board-wrapper {
	margin: 1rem 0;
	padding: 0 0.5rem;
}

/* 게시판 카드 */
.modern-board-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	overflow: hidden;
	margin-bottom: 1rem;
}

/* 게시판 헤더 */
.modern-board-header {
	background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
	padding: 0.8rem 1.5rem;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.modern-board-title {
	color: white;
	font-size: 1.2rem;
	font-weight: 700;
	margin: 0;
}

/* 검색 필터 버튼 */
.filter-toggle-btn {
	background: rgba(255, 255, 255, 0.2);
	border: none;
	color: white;
	padding: 0.4rem 1rem;
	border-radius: 6px;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 0.5rem;
	transition: all 0.3s ease;
	font-size: 0.9rem;
	font-weight: 600;
}

.filter-toggle-btn:hover {
	background: rgba(255, 255, 255, 0.3);
}

/* 필터 아코디언 */
.filter-accordion {
	background: #fafbfc;
	padding: 1.5rem;
	display: none;
	border-top: 2px solid #e9ecef;
}

.filter-search-row {
	display: flex;
	gap: 0.5rem;
	align-items: center;
}

.filter-search-input {
	flex: 2;
	padding: 0.7rem 1rem;
	border: 2px solid #e9ecef;
	border-radius: 8px;
	font-size: 0.95rem;
	transition: all 0.3s ease;
}

.filter-search-input:focus {
	outline: none;
	border-color: #648ca4;
	box-shadow: 0 0 0 3px rgba(100, 140, 164, 0.1);
}

.filter-search-btn {
	padding: 0.7rem 1rem;
	background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
	color: white;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 0.95rem;
	white-space: nowrap;
}

.filter-search-btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(100, 140, 164, 0.3);
}

.filter-reset-btn {
	padding: 0.7rem 1rem;
	background: #6c757d;
	color: white;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 0.95rem;
	white-space: nowrap;
}

.filter-reset-btn:hover {
	background: #5a6268;
	transform: translateY(-2px);
}

/* 테이블 */
.modern-table-wrapper {
	overflow-x: auto;
}

/* 테이블 레이아웃 */
.modern-table {
	width: 100%;
	min-width: 380px;
	border-collapse: collapse;
	table-layout: fixed;
}

.modern-table thead {
	background: #f8f9fa;
}

.modern-table th {
	padding: 1rem 1rem;
	text-align: center;
	font-weight: 600;
	color: #495057;
	font-size: 0.9rem;
	border-bottom: 2px solid #e9ecef;
}

/* 칼럼 너비 재조정 */
.modern-table th:nth-child(1), .modern-table td:nth-child(1) {
	width: 5%;
	/* 순번 */
}

.modern-table th:nth-child(2), .modern-table td:nth-child(2) {
	width: 45%;
	/* 제목 - 50%에서 45%로 줄임 */
}

.modern-table th:nth-child(3), .modern-table td:nth-child(3) {
	width: 15%;
	/* 작성자 - 16%에서 15%로 줄임 */
}

.modern-table th:nth-child(4), .modern-table td:nth-child(4) {
	width: 30%;
	/* 작성일 - 22%에서 30%로 늘림 */
}

.modern-table th.text-center {
	text-align: center;
}

.modern-table tbody tr {
	border-bottom: 1px solid #f1f3f5;
	transition: all 0.2s ease;
	cursor: pointer;
}

.modern-table tbody tr:hover {
	background: #f8f9fa;
}

.modern-table td {
	padding: 1rem 1.5rem;
	font-size: 0.95rem;
	color: #495057;
}

.modern-cell-number {
	padding: 1rem 0.1rem !important;
	font-weight: 600;
	color: #648ca4;
	text-align: center;
}

.modern-cell-title {
	padding: 0.6rem 0.3rem 0.6rem 0.8rem !important;
	font-weight: 500;
}

.modern-cell-author {
	padding: 0.5rem 0.2rem 0.5rem 0.4rem !important;
	color: #6c757d;
	font-size: 0.9rem;
	text-align: center;
}

.modern-cell-date {
	padding: 0.5rem 0.4rem 0.5rem 0.2rem !important;
	color: #6c757d;
	font-size: 0.9rem;
	text-align: center;
}

/* 검색 배지 */
.search-badge {
	display: inline-block;
	background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
	color: white;
	padding: 0.25rem 0.6rem;
	border-radius: 4px;
	font-size: 0.75rem;
	font-weight: 600;
	margin-right: 0.5rem;
}

/* 페이징 */
.modern-pagination {
	padding: 0.5rem 1.5rem;
	display: flex;
	justify-content: center;
}

/* 하단 버튼 영역 */
.modern-action-bar {
	padding: 0.5rem 1.5rem;
	background: #f8f9fa;
	border-top: 1px solid #e9ecef;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.modern-btn-write {
	padding: 0.7rem 1.8rem;
	background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
	color: white;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 0.95rem;
}

.modern-btn-write:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(100, 140, 164, 0.3);
}

.modern-btn-list {
	padding: 0.7rem 1.5rem;
	background: #6c757d;
	color: white;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 0.95rem;
	text-decoration: none;
	display: inline-block;
}

.modern-btn-list:hover {
	background: #5a6268;
	transform: translateY(-2px);
	color: white;
	text-decoration: none;
}

/* 반응형 */
@media ( max-width : 768px) {
	.modern-board-header {
		padding: 0.7rem 1rem;
	}
	.modern-board-title {
		font-size: 1rem;
	}
	.modern-table th, .modern-table td {
		padding: 0.5rem;
	}
	.filter-search-row {
		flex-direction: row;
		flex-wrap: nowrap;
	}
	.modern-action-bar {
		flex-direction: column;
		gap: 0.5rem;
	}
}

/* 모달 z-index 최상위로 설정 */
.modal {
	z-index: 9999 !important;
}

.modal-backdrop {
	z-index: 9998 !important;
}

.modal-dialog {
	z-index: 10000 !important;
}

/* 게시글 내용 영역의 이미지가 잘리지 않도록 */
#modalBbsCn img {
	max-width: 100% !important;
	height: auto !important;
	width: auto !important;
	display: block;
	margin: 10px 0;
}

/* SweetAlert2가 모달 위에 표시되도록 */
.swal-high-zindex {
	z-index: 99999 !important;
}
</style>
</head>

<%@include file="../include/headerContents.jsp"%>
<body>


	<!-- 게시판 목록 (모던 스타일) -->
	<div class="modern-board-wrapper">
		<div class="modern-board-card">

			<!-- 1. 헤더 -->
			<div class="modern-board-header">
				<h4 class="modern-board-title" id="bbsGroupName">로딩중...</h4>
				<button type="button" onclick="toggleFilter()"
					class="filter-toggle-btn">
					<span>검색</span> <i class="fas fa-chevron-down filter-toggle-icon"
						style="transition: transform 0.3s ease;"></i>
				</button>
			</div>

			<!-- 2. 검색 필터 아코디언 -->
			<div id="filterAccordion" class="filter-accordion">
				<div class="filter-search-row">
					<input type="text" id="keyword" class="filter-search-input"
						placeholder="제목, 내용, 작성자 검색" />
					<button type="button" id="btnSearch" class="filter-search-btn">
						<i class="fas fa-search"></i>
					</button>
					<button type="button" id="btnShowAll" class="filter-reset-btn">
						<i class="fas fa-redo"></i>
					</button>
				</div>
			</div>

			<!-- 3. 테이블 -->
			<div class="modern-table-wrapper">
				<table class="modern-table">
					<thead>
						<tr>
							<th class="text-center" style="width: 40px;">순번</th>
							<th>제목</th>
							<th class="text-center" style="width: 55px;">작성자</th>
							<th class="text-center" style="width: 60px;">작성일</th>
						</tr>
					</thead>
					<tbody id="bbsListBody">
						<!-- 게시글 목록이 동적으로 로드됩니다 -->
						<tr>
							<td colspan="4"
								style="text-align: center; padding: 2rem; color: #6c757d;">
								<i class="fas fa-spinner fa-spin"
								style="font-size: 1.5rem; margin-bottom: 0.5rem;"></i>
								<div>로딩중...</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- 4. 페이징 영역 -->
			<div class="modern-pagination">
				<div id="pagingArea">
					<!-- 페이징이 동적으로 로드됩니다 -->
				</div>
			</div>

			<!-- 5. 하단 액션 바 -->
			<div class="modern-action-bar">
				<div>
					<!-- 로그인한 사용자만 글쓰기 버튼 표시 -->
					<sec:authorize access="isAuthenticated()">
						<button type="button" id="btnWrite" class="modern-btn-write">
							<i class="fas fa-pen"></i> 글쓰기
						</button>
					</sec:authorize>
				</div>
			</div>
		</div>
	</div>

	<!-- 게시글 상세/수정/작성 모달 -->
	<div class="modal fade cute-modal" id="detailModal" tabindex="-1"
		role="dialog">
		<div class="modal-dialog modal-xl modal-dialog-centered"
			role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modalTitle">게시글 상세</h5>
					<button type="button" class="btn-close" id="modalCloseBtn"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
				<div class="modal-scroll-area">
					<!-- ========== 읽기 모드 영역 ========== -->
					<div id="readMode">
						<!-- 게시글 정보 -->
						<div
							style="border-bottom: 2px solid #dee2e6; padding-bottom: 15px; margin-bottom: 20px;">
							<h4 id="modalBbsSj" style="margin-bottom: 10px;"></h4>
							<div style="color: #6c757d; font-size: 0.9em;">
								<span><i class="fas fa-user"></i> <strong>작성자:</strong> <span
									id="modalBbsMberId"></span></span> <span style="margin-left: 20px;"><i
									class="fas fa-clock"></i> <strong>작성일:</strong> <span
									id="modalBbsWritngDt"></span></span>
							</div>
						</div>

						<!-- 게시글 내용 -->
						<div
							style="min-height: 200px; padding: 20px; background-color: #f8f9fa; border-radius: 5px; margin-bottom: 20px;">
							<div id="modalBbsCn"></div>
						</div>

						<!-- 첨부파일 -->
						<div id="modalFileList"
							style="display: none; margin-bottom: 20px;">
							<hr>
							<h6>
								<i class="fas fa-paperclip"></i> 첨부파일
							</h6>
							<div id="modalFiles"></div>
						</div>

						<!-- 댓글 영역 -->
						<div id="answerSection" style="display: none;">
							<hr>
							<h6>
								댓글 (<span id="modalAnswerCount">0</span>)
							</h6>
							<div id="modalAnswerList">
								<!-- 댓글 목록이 여기 표시됩니다 -->
							</div>

							<!-- 댓글 작성 폼 -->
							<sec:authorize access="isAuthenticated()">
								<div style="margin-top: 20px;">
									<textarea class="form-control" id="modalAnswerContent" rows="3"
										placeholder="댓글을 입력하세요"></textarea>
									<button type="button" class="btn btn-primary mt-2"
										onclick="addAnswerInModal()">댓글 작성</button>
								</div>
							</sec:authorize>
						</div>
					</div>

					<!-- ========== 편집 모드 영역 ========== -->
					<div id="editMode" style="display: none;">
						<!-- 제목 입력 -->
						<div class="form-group mb-4">
							<label for="modalEditSj" class="form-label"
								style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
								<i class="fas fa-heading"
								style="color: #648ca4; margin-right: 0.5rem;"></i>제목
							</label> <input type="text" class="form-control" id="modalEditSj"
								placeholder="제목을 입력하세요"
								style="border: 2px solid #e9ecef; padding: 0.75rem; font-size: 1rem; border-radius: 8px; transition: all 0.3s;">
						</div>

						<!-- 내용 입력 (CKEditor) -->
						<div class="form-group mb-4">
							<label for="modalEditCn" class="form-label"
								style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
								<i class="fas fa-align-left"
								style="color: #648ca4; margin-right: 0.5rem;"></i>내용
							</label>
							<textarea class="form-control" id="modalEditCn"
								placeholder="내용을 입력하세요"></textarea>
						</div>

						<!-- 파일 첨부 (조건부 표시) -->
						<div id="modalFileUploadArea" style="display: none;">
							<div class="form-group mb-4">
								<label for="modalMultipartFiles" class="form-label"
									style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
									<i class="fas fa-paperclip"
									style="color: #648ca4; margin-right: 0.5rem;"></i>파일 첨부
								</label> <input type="file" class="form-control"
									id="modalMultipartFiles" name="modalMultipartFiles" multiple
									style="border: 2px solid #e9ecef; padding: 0.75rem; border-radius: 8px;" />
								<small id="modalFileCount" class="form-text text-success"
									style="font-weight: 500; display: block; margin-top: 0.5rem;"></small>
							</div>
						</div>

						<!-- 기존 첨부파일 (수정 모드일 때만) -->
						<div id="modalExistingFiles"
							style="display: none; margin-bottom: 20px;">
							<label class="form-label"
								style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
								<i class="fas fa-folder-open"
								style="color: #648ca4; margin-right: 0.5rem;"></i>기존 첨부파일
							</label>
							<div id="modalExistingFileList"
								style="padding: 1rem; background-color: #f8f9fa; border-radius: 8px; border: 1px solid #e9ecef;"></div>
						</div>
					</div>
					<div class="modal-footer">
						<!-- 읽기 모드 버튼 -->
						<div id="readModeButtons">
							<button type="button" id="modalBtnEdit" class="btn btn-warning"
								style="display: none;">수정</button>
							<button type="button" id="modalBtnDelete" class="btn btn-danger"
								style="display: none;">삭제</button>
							<button type="button" class="btn btn-secondary"
								id="modalBtnClose">닫기</button>
						</div>

						<!-- 편집 모드 버튼 -->
						<div id="editModeButtons" style="display: none;">
							<button type="button" id="modalBtnSave" class="btn btn-primary">저장</button>
							<button type="button" id="modalBtnCancel"
								class="btn btn-secondary">취소</button>
						</div>
					</div>
				</div>
				</div>
			</div>
		</div>
	</div>

	<!-- /// body 끝 /// -->

	<!-- Bootstrap JS, board페이지에는 이 cdn이 2개 삽입되어야 함. 이유 찾을 수 없음. -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

<%@ include file="../include/footerContents.jsp"%>

</html>