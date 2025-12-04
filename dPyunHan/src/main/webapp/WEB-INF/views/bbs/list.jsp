<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<title>게시판 관리</title>
<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* ========== 전체 래퍼 ========== */
.admin-board-wrapper {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
}

/* ========== 헤더 카드 ========== */
.admin-header-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    margin-bottom: 2rem;
}

/* 헤더 상단 (그라데이션) */
.admin-header-top {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    padding: 1.5rem 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.admin-title {
    color: white;
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.admin-title i {
    font-size: 1.8rem;
}

/* 게시판 생성 버튼 */
.btn-create-board {
    background: rgba(255, 255, 255, 0.95);
    color: #648ca4;
    border: none;
    padding: 0.6rem 1.3rem;
    border-radius: 8px;
    font-weight: 600;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-create-board:hover {
    background: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn-create-board i {
    font-size: 1rem;
}

/* ========== 게시판 그리드 영역 ========== */
.board-grid-section {
    padding: 1rem 0.5rem;
}

#boardCardGrid {
    text-align: center;
}

/* ========== 로딩 상태 ========== */
.loading-message, .empty-state {
    text-align: center;
    padding: 3rem;
    color: #6c757d;
}

.loading-message i, .empty-state i {
    font-size: 3rem;
    margin-bottom: 1rem;
    opacity: 0.3;
}

.loading-message p, .empty-state p {
    font-size: 1.1rem;
    margin: 0;
}

/* ========== 게시판 카드 호버 효과 ========== */
.board-card:hover {
    transform: translateY(-5px) !important;
    box-shadow: 0 8px 20px rgba(100, 140, 164, 0.25) !important;
    border-color: #648ca4 !important;
}

/* ========== 반응형 ========== */
@media (max-width: 768px) {
    .filter-row {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    .modern-notice-header {
        padding: 0.7rem 1rem;
    }
    
    .modern-notice-title {
        font-size: 1rem;
    }
    
    .modern-table th,
    .modern-table td {
        padding: 0.8rem;
        font-size: 0.85rem;
    }

    /* ========== 게시판 생성 모달 ========== */
    .form-control:focus {
        border-color: #648ca4 !important;
        box-shadow: 0 0 0 0.2rem rgba(100, 140, 164, 0.25) !important;
    }

    .form-check-input:checked {
        background-color: #648ca4 !important;
        border-color: #648ca4 !important;
    }

    .form-check-input:focus {
        box-shadow: 0 0 0 0.2rem rgba(100, 140, 164, 0.25) !important;
    }
    
    /* SweetAlert2가 모달 위에 표시되도록 */
	.swal-high-zindex {
	z-index: 99999 !important;
}

}
</style>
</head>
<body>

<%@ include file="../include/headerContents.jsp"%>

<!-- 게시판 관리 래퍼 -->
<div class="admin-board-wrapper">
    <!-- 헤더 카드 -->
    <div class="admin-header-card">
        <!-- 헤더 상단-->
        <div class="admin-header-top">
            <h1 class="admin-title">
                <i class="fas fa-clipboard-list"></i>
                게시판 관리
            </h1>
            
            <!-- 입주민 대표만 보이는 버튼 (개발 중 주석처리) -->
            <sec:authorize access="hasRole('ROLE_MBER_HEAD')">
                <button type="button" class="btn-create-board" id="btnOpenCreateModal">
                    <i class="fas fa-plus"></i>
                    새 게시판 생성
                </button>
            </sec:authorize>
        </div>
        
        <!-- 게시판 그리드 영역 -->
        <div class="board-grid-section">
            <div id="boardCardGrid">
                <!-- 로딩 중 표시 -->
                <div class="loading-message">
                    <i class="fas fa-spinner fa-spin"></i>
                    <p>게시판 목록을 불러오는 중...</p>
                </div>
            </div>
        </div>
    </div>
    
</div>

<!-- 게시판 생성 모달 -->
<div class="modal fade" id="createBbsModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 12px; overflow: hidden; border: none;">
            <!-- 모달 헤더 -->
            <div class="modal-header" style="background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%); border: none; padding: 1.5rem;">
                <h5 class="modal-title" style="color: white; font-weight: 700; font-size: 1.2rem;">
                    <i class="fas fa-plus-circle"></i> 새 게시판 생성
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            
            <!-- 모달 바디 -->
            <div class="modal-body" style="padding: 2rem;">
                <!-- 게시판 이름 -->
                <div class="mb-4">
                    <label for="bbsNm" class="form-label" style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
                        <i class="fas fa-tag" style="color: #648ca4; margin-right: 0.5rem;"></i>게시판 이름
                    </label>
                    <input type="text" id="bbsNm" class="form-control" placeholder="게시판 이름을 입력하세요" 
                           style="border: 2px solid #e9ecef; padding: 0.75rem; font-size: 1rem; border-radius: 8px;">
                </div>
                
                <!-- 댓글 작성 여부 -->
                <div class="mb-4">
                    <label class="form-label" style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
                        <i class="fas fa-comment" style="color: #648ca4; margin-right: 0.5rem;"></i>댓글 작성 여부
                    </label>
                    <div class="d-flex gap-3">
                        <div class="form-check" style="flex: 1;">
                            <input class="form-check-input" type="radio" name="answerAt" id="answerAtOk" value="1" 
                                   style="width: 1.2rem; height: 1.2rem; cursor: pointer;">
                            <label class="form-check-label" for="answerAtOk" style="cursor: pointer; margin-left: 0.5rem; font-size: 0.95rem;">
                                가능
                            </label>
                        </div>
                        <div class="form-check" style="flex: 1;">
                            <input class="form-check-input" type="radio" name="answerAt" id="answerAtNo" value="2" 
                                   style="width: 1.2rem; height: 1.2rem; cursor: pointer;">
                            <label class="form-check-label" for="answerAtNo" style="cursor: pointer; margin-left: 0.5rem; font-size: 0.95rem;">
                                불가
                            </label>
                        </div>
                    </div>
                </div>
                
                <!-- 파일 첨부 여부 -->
                <div class="mb-4">
                    <label class="form-label" style="font-weight: 600; color: #495057; font-size: 1rem; margin-bottom: 0.75rem;">
                        <i class="fas fa-paperclip" style="color: #648ca4; margin-right: 0.5rem;"></i>파일 첨부 여부
                    </label>
                    <div class="d-flex gap-3">
                        <div class="form-check" style="flex: 1;">
                            <input class="form-check-input" type="radio" name="atchFileAt" id="atchFileAtOk" value="1" 
                                   style="width: 1.2rem; height: 1.2rem; cursor: pointer;">
                            <label class="form-check-label" for="atchFileAtOk" style="cursor: pointer; margin-left: 0.5rem; font-size: 0.95rem;">
                                가능
                            </label>
                        </div>
                        <div class="form-check" style="flex: 1;">
                            <input class="form-check-input" type="radio" name="atchFileAt" id="atchFileAtNo" value="2" 
                                   style="width: 1.2rem; height: 1.2rem; cursor: pointer;">
                            <label class="form-check-label" for="atchFileAtNo" style="cursor: pointer; margin-left: 0.5rem; font-size: 0.95rem;">
                                불가
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 모달 푸터 -->
            <div class="modal-footer" style="background: #f8f9fa; border: none; padding: 1rem 2rem;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" 
                        style="padding: 0.6rem 1.5rem; border-radius: 8px; font-weight: 600;">
                    취소
                </button>
                <button type="button" id="btnCreateBbs" class="btn" 
                        style="background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%); color: white; padding: 0.6rem 1.5rem; border-radius: 8px; font-weight: 600; border: none;">
                    생성
                </button>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function(){
    console.log("페이지 로드됨");
    
    // 게시판 목록 로드
    loadBbsGroupList();
    
    // 게시판 생성 버튼
    const btnCreate = document.querySelector("#btnOpenCreateModal");
    if(btnCreate) {
        btnCreate.addEventListener("click", function(){
            // 모달 열기
            const modal = new bootstrap.Modal(document.querySelector('#createBbsModal'));
            modal.show();
        });
    }

    // 게시판 생성 실행 버튼
    document.querySelector("#btnCreateBbs").addEventListener("click", function(){
        createBbsGroup();
    });

    // 모달이 닫힐 때 폼 초기화
    document.querySelector('#createBbsModal').addEventListener('hidden.bs.modal', function(){
        document.querySelector("#bbsNm").value = "";
        document.querySelectorAll("input[name='answerAt']").forEach(radio => radio.checked = false);
        document.querySelectorAll("input[name='atchFileAt']").forEach(radio => radio.checked = false);
    });
});

// 게시판 생성 함수
function createBbsGroup(){
    const bbsNm = document.querySelector("#bbsNm").value;
    const answerAt = document.querySelector("input[name='answerAt']:checked");
    const atchFileAt = document.querySelector("input[name='atchFileAt']:checked");
    
    // 전송 데이터
    const data = {
        "bbsNm": bbsNm,
        "answerAt": answerAt.value,
        "atchFileAt": atchFileAt.value
    };
    
    console.log("전송 데이터:", data);
    
    // fetch
    fetch("/bbs/postBbsGroup", {
        method: "POST",
        headers: {"Content-Type": "application/json;charset=UTF-8"},
        body: JSON.stringify(data)
    })
    .then(response => {
        if(!response.ok){
            throw new Error("서버 응답 오류");
        }
        return response.json();
    })
    .then(result => {
        console.log("생성 결과:", result);
        Swal.fire({
            icon: 'success',
            title: '생성 완료',
            text: '게시판이 생성되었습니다!',
            confirmButtonColor: '#648ca4',
            confirmButtonText: '확인',
            customClass: {
                container: 'swal-high-zindex'
            }
        });
        
        // 모달 닫기
        const modal = bootstrap.Modal.getInstance(document.querySelector('#createBbsModal'));
        modal.hide();
        
        // 목록 새로고침
        loadBbsGroupList();
    })
    .catch(error => {
        console.error("생성 오류:", error);
  	   // 변경 코드
        Swal.fire({
            icon: 'error',
            title: '생성 실패',
            text: '게시판 생성 중 오류가 발생했습니다.',
            confirmButtonColor: '#648ca4',
            confirmButtonText: '확인'
        });
    });
}

// 게시판 목록 로드 함수
function loadBbsGroupList(){
    fetch("/bbs/bbsGroupList/data", {
        method: "GET"
    })
    .then(response => {
        if(!response.ok){
            throw new Error("서버 응답 오류");
        }
        return response.json();
    })
    .then(data => {
        displayBbsGroupCards(data);
    })
    .catch(error => {
        console.error("목록 로드 오류:", error);
    });
}

// 게시판 카드 표시 함수
function displayBbsGroupCards(bbsGroupList){
    const gridContainer = document.querySelector("#boardCardGrid");
    
    // inline-block 간격 제거
    gridContainer.style.fontSize = "0";
    
    // 게시판이 없는 경우
    if(!bbsGroupList || bbsGroupList.length === 0){
        gridContainer.innerHTML = 
            '<div style="width: 100%; text-align: center; padding: 2rem; color: #6c757d; font-size: 1rem;">' +
                '<i class="fas fa-inbox" style="font-size: 2.5rem; margin-bottom: 1rem; opacity: 0.3;"></i>' +
                '<p style="font-size: 1rem; margin: 0;">등록된 게시판이 없습니다.<br>새 게시판을 생성해주세요.</p>' +
            '</div>';
        return;
    }
    
    // 카드 생성
    let html = '';
    
    bbsGroupList.forEach(function(bbsGroup, index){
        const icons = ['fa-clipboard-list', 'fa-comments', 'fa-bullhorn', 'fa-newspaper', 'fa-pen-to-square'];
        const icon = icons[index % icons.length];

        // Oracle hashMap은 대문자 키 반환
        const bbsNm = bbsGroup.BBS_NM || bbsGroup.bbsNm;
        const answerAt = bbsGroup.ANSWER_AT || bbsGroup.answerAt;
        const atchFileAt = bbsGroup.ATCH_FILE_AT || bbsGroup.atchFileAt;
        const bbsGroupSn = bbsGroup.BBS_GROUP_SN || bbsGroup.bbsGroupSn;
        const postCount = bbsGroup.POST_COUNT || bbsGroup.postCount || 0;
        const commentCount = bbsGroup.COMMENT_COUNT || bbsGroup.commentCount || 0;

        html +=
            '<div class="board-card" style="' +
                'display: inline-block; ' +
                'width: 46%; ' +
                'min-width: 100px; ' +
                'max-width: 300px; ' +
                'margin: 1%; ' +
                'vertical-align: top; ' +
                'background: white; ' +
                'border-radius: 8px; ' +
                'box-shadow: 0 1px 4px rgba(0,0,0,0.1); ' +
                'cursor: pointer; ' +
                'overflow: hidden; ' +
                'border: 1px solid #e9ecef; ' +
                'transition: all 0.3s ease; ' +
                'font-size: 1rem;' +
            '">' +
                // 헤더
                '<div style="background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%); padding: 0.8rem; color: white; text-align: center;">' +
                    '<h3 style="font-size: 0.95rem; font-weight: 700; margin: 0; line-height: 1.3; color: white;">' + bbsNm + '</h3>' +
                '</div>' +
                // 본문
                '<div style="padding: 0.6rem;">' +
                    // 댓글/파일 (가능/불가)
                    '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; padding-bottom: 0.5rem; border-bottom: 1px solid #e9ecef;">' +
                        '<div style="display: flex; align-items: center; gap: 0.3rem; font-size: 0.75rem;">' +
                            '<i class="fas fa-comment" style="color: #648ca4; font-size: 0.8rem;"></i>' +
                            '<span style="color: #6c757d; font-weight: 500;">댓글:</span>' +
                            '<span style="color: ' + (answerAt == 1 ? '#28a745' : '#dc3545') + '; font-weight: 600;">' +
                                (answerAt == 1 ? '가능' : '불가') +
                            '</span>' +
                        '</div>' +
                        '<div style="display: flex; align-items: center; gap: 0.3rem; font-size: 0.75rem;">' +
                            '<i class="fas fa-paperclip" style="color: #648ca4; font-size: 0.8rem;"></i>' +
                            '<span style="color: #6c757d; font-weight: 500;">파일:</span>' +
                            '<span style="color: ' + (atchFileAt == 1 ? '#28a745' : '#dc3545') + '; font-weight: 600;">' +
                                (atchFileAt == 1 ? '가능' : '불가') +
                            '</span>' +
                        '</div>' +
                    '</div>' +
                    // 통계
                    '<div style="display: flex; justify-content: space-around; padding-top: 0.3rem;">' +
                        '<div style="text-align: center;">' +
                            '<span style="display: block; font-size: 1rem; font-weight: 700; color: #648ca4; margin-bottom: 0.1rem;">' + postCount + '</span>' +
                            '<span style="display: block; font-size: 0.65rem; color: #6c757d;">글</span>' +
                        '</div>' +
                        '<div style="text-align: center;">' +
                            '<span style="display: block; font-size: 1rem; font-weight: 700; color: #648ca4; margin-bottom: 0.1rem;">' + commentCount + '</span>' +
                            '<span style="display: block; font-size: 0.65rem; color: #6c757d;">댓글</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                // 푸터
                '<div style="padding: 0.5rem 0.6rem; background: #f8f9fa; display: flex; justify-content: space-between; align-items: center;">' +
                    '<span style="font-size: 0.7rem; color: #6c757d;">#' + bbsGroupSn + '</span>' +
                    '<div style="display: flex; gap: 0.3rem;">' +
                        // 수정 버튼
                        '<button onclick="event.stopPropagation(); openEditModal(' + bbsGroupSn + ')" style="' +
                            'background: #ffc107; ' +
                            'color: white; ' +
                            'border: none; ' +
                            'padding: 0.25rem 0.5rem; ' +
                            'border-radius: 4px; ' +
                            'font-weight: 600; ' +
                            'font-size: 0.7rem; ' +
                            'cursor: pointer;' +
                        '" title="수정"><i class="fas fa-edit"> 수정</i></button>' +
                        // 삭제 버튼
                        '<button onclick="event.stopPropagation(); deleteBbsGroup(' + bbsGroupSn + ')" style="' +
                            'background: #dc3545; ' +
                            'color: white; ' +
                            'border: none; ' +
                            'padding: 0.25rem 0.5rem; ' +
                            'border-radius: 4px; ' +
                            'font-weight: 600; ' +
                            'font-size: 0.7rem; ' +
                            'cursor: pointer;' +
                        '" title="삭제"><i class="fas fa-trash"> 삭제</i></button>' +
                        // 보기 버튼
                        '<button onclick="event.stopPropagation(); goToBoardPage(' + bbsGroupSn + ')" style="' +
                            'background: #648ca4; ' +
                            'color: white; ' +
                            'border: none; ' +
                            'padding: 0.25rem 0.5rem; ' +
                            'border-radius: 4px; ' +
                            'font-weight: 600; ' +
                            'font-size: 0.7rem; ' +
                            'cursor: pointer;' +
                        '" title="보기"><i class="fas fa-arrow-right"> 보기</i></button>' +
                    '</div>' +
                '</div>' +
            '</div>';
    });
    gridContainer.innerHTML = html;
}

// 보기 버튼 클릭 시 게시판 페이지로 이동
function goToBoardPage(bbsGroupSn){
    window.location.href = "/bbs/board/" + bbsGroupSn;
}

// 삭제 버튼 클릭 시 게시판 삭제
function deleteBbsGroup(bbsGroupSn){
    Swal.fire({
        icon: 'warning',
        title: '게시판 삭제',
        html: '정말 이 게시판을 삭제하시겠습니까? <br>삭제된 게시판의 모든 게시글도 함께 삭제됩니다.',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log("게시판 삭제:", bbsGroupSn);

            fetch("/bbs/deleteBbsGroup/" + bbsGroupSn, {
                method: "POST",
                headers: {"Content-Type": "application/json;charset=UTF-8"}
            })
            .then(response => {
                if(!response.ok){
                    throw new Error("서버 응답 오류");
                }
                return response.json();
            })
            .then(result => {
                console.log("삭제 결과:", result);

                if(result.success){
                    Swal.fire({
                        icon: 'success',
                        title: '삭제 완료',
                        text: '게시판이 삭제되었습니다.',
                        confirmButtonColor: '#648ca4',
                        confirmButtonText: '확인'
                    });
                    // 목록 새로고침
                    loadBbsGroupList();
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '삭제 실패',
                        text: result.message || '삭제에 실패했습니다.',
                        confirmButtonColor: '#648ca4',
                        confirmButtonText: '확인'
                    });
                }
            })
            .catch(error => {
                console.error("삭제 오류:", error);
                Swal.fire({
                    icon: 'error',
                    title: '오류',
                    text: '게시판 삭제 중 오류가 발생했습니다.',
                    confirmButtonColor: '#648ca4',
                    confirmButtonText: '확인'
                });
            });
        }
    });
}

</script>

<%@ include file="../include/footerContents.jsp"%>
</body>
</html>