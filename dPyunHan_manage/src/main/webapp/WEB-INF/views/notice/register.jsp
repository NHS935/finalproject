<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../include/header.jsp"%>
<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
/* 공통 카드별 상단 영역 시작 */
body { /* 그냥 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}

.card {
	padding: 0.3rem !important;
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
	padding: 3px 5px !important; /* 테이블들 행간격 */
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

</style>


<script type="text/javascript">
/* ckeditor 사용해봄 */
 document.addEventListener("DOMContentLoaded",function(){
	
	 ClassicEditor
	    .create(document.querySelector('#noticeCn'))
	    .catch(error => {
	      console.error('Editor error:', error);
	    });
	 <c:if test="${not empty successMessage}">
	    setTimeout(function() {
	      Swal.fire({
	        title: '성공!',
	        text: '${successMessage}',
	        icon: 'success',
	        confirmButtonText: '확인',
	        confirmButtonColor: '#648ca4',
	        allowOutsideClick: false,
	        allowEscapeKey: false,
	        zIndex: 10000  // 다른 알럿보다 앞에 표시
	      }).then((result) => {
	        if (result.isConfirmed) {
	          location.href = '/notice/list';
	        }
	      });
	    }, 100); 
	  </c:if>
 });
 
</script>


<section class="content" style="margin: 20px">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">

        <!-- 카드 시작 -->
        <div class="card bg-light">
          
          <!-- 카드 헤더 시작 -->
          <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="card-title mb-0">공지 등록</h5>
          </div>
          <!-- 카드 헤더 끝 -->

          <!-- 카드 바디 시작 -->
      <form action="/notice/register" method="post" enctype="multipart/form-data" id="noticeForm">
          <div class="card-body">

              <div class="mb-3">
                <label for="noticeSj" class="form-label">공지 제목</label>
                <input id="noticeSj" type="text" name="noticeSj" class="form-control" required />
              </div>

              <div class="mb-3">
                <label class="form-label d-block">공지 대상</label>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="wnmpyNotice" value="1" id="radio1" checked />
                  <label class="form-check-label" for="radio1">사내공지</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="wnmpyNotice" value="0" id="radio0" />
                  <label class="form-check-label" for="radio0">입주민공지</label>
                </div>
              </div>

              <div class="mb-3">
                <label for="noticeCn" class="form-label">공지 내용</label>
                <textarea id="noticeCn" name="noticeCn" class="form-control"></textarea>
              </div>

             <div class="mb-3">
  <label class="form-label d-block mb-2">첨부파일</label>
  <div class="d-flex align-items-center gap-2">
    <!-- 숨겨진 파일 입력 -->
    <input type="file" id="fileInput" name="multipartFiles" multiple style="display: none"/>
    
    <!-- 커스텀 버튼 -->
    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.getElementById('fileInput').click();">
      파일선택
    </button>
    
    <!-- 선택된 파일 이름 표시 -->
    <span id="fileName" class="text-muted" style="font-size: 0.9rem;">선택된 파일 없음</span>
  </div>
</div>

          </div>
          <!-- 카드 바디 끝 -->

          <!-- 카드 푸터 시작 -->
          <div class="card-footer d-flex justify-content-end">
            <button type="submit" class="btn btn-info btn-sm mr-2">등록</button>
            <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/notice/list';">취소</button>
          </div>
          <!-- 카드 푸터 끝 -->

		</form>
        </div>
        <!-- 카드 끝 -->
      </div>
    </div>
  </div>
</section>

<script>
document.getElementById('fileInput').addEventListener('change', function(e) {
  const fileNames = Array.from(this.files).map(f => f.name).join(', ');
  document.getElementById('fileName').textContent = fileNames || '선택된 파일 없음';
});
</script>

<%@ include file="../include/footer.jsp"%>
