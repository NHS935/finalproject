<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

#noticeSj {
  width: 100%; /* 부모 컨테이너에 맞게 너비 확장 */
  box-sizing: border-box; /* padding과 border 포함 너비 계산 */
  border: none; /* 테두리 없앰 */
  outline: none; /* 포커스 시 기본 파란 테두리 제거 */
  padding: 0.375rem 0.75rem; /* Bootstrap 기본 input padding */
  font-size: 1rem;
}

/* 필요하다면 포커스 시 테두리 스타일 추가 */
#noticeSj:focus {
  border: 1px solid #80bdff;
  outline: none;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, .25);
}
</style>

<script>

	document.addEventListener("DOMContentLoaded",function(){
		
		const form = document.querySelector("#noticeForm");
		const editB = document.querySelector("#editBtn");
		const saveB = document.querySelector("#saveBtn");
		
		
		/* ckeditor 사용해봄 */
		 ClassicEditor
		    .create(document.querySelector('#noticeCn'),{
		    	toolbar: [], // 상세 들어갔을때는 툴바 없음
		    })
		    .then(editor =>{
		    	 window.editor = editor;
		    	    editor.enableReadOnlyMode('readOnly'); // CkEditor읽기 전용 활성화
		    })
		    .catch(error => {
		      console.error('Editor error:', error);
		})
		
		// 수정 버튼 클릭하면 툴바 생성을 위한거
		 editB.addEventListener("click", async () => {
			  form.querySelectorAll("input, textarea").forEach(el => el.removeAttribute('readonly'));
			  if(window.editor) {
			    await window.editor.destroy();
			  }
			  ClassicEditor
			    .create(document.querySelector('#noticeCn'))
			    .then(newEditor => {
			      window.editor = newEditor;
			    });
			  editB.style.display = "none";
			  saveB.style.display = "inline";
			});
		
	});
</script>

	<%@ include file="../include/header.jsp"%>

<section class="content" style="margin: 20px">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">

        <!-- 카드 시작 -->
        <div class="card bg-light">
          
          <!-- 카드 헤더 시작 -->
          <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="card-title mb-0">공지사항 상세</h5>
          </div>
          <!-- 카드 헤더 끝 -->

          <!-- 카드 바디 시작 -->
          <div class="card-body">
            <form id="noticeForm" action="/notice/edit" method="post">
              <input type="hidden" name="noticeSn" value="${noticeVO.noticeSn}" />
              
              <!-- ✅ 원래 테이블 구조 유지 -->
              <table class="table table-striped table-bordered">
                <tr>
                  <th style="width: 20%;">공지번호</th>
                  <td>${noticeVO.noticeSn}</td>
                </tr>
                <tr>
                  <th>제목</th>
                  <td>
                    <input type="text" id="noticeSj" name="noticeSj" value="${noticeVO.noticeSj}" readonly />
                  </td>
                </tr>
                <tr>
                  <th>내용</th>
                  <td>
                    <textarea id="noticeCn" name="noticeCn" readonly>${noticeVO.noticeCn}</textarea>
                  </td>
                </tr>
                <tr>
                  <th>작성일</th>
                  <td><fmt:formatDate value="${noticeVO.noticeWritngDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                  <th>직원명</th>
                  <td>${noticeVO.nm}</td>
                </tr>
                <tr>
  <th>파일</th>
  <td>
    <c:if test="${not empty fileDetailVOList}">
      <ul class="list-group">
        <c:forEach var="file" items="${fileDetailVOList}">
          <li class="list-group-item d-flex justify-content-between align-items-center">
            <span>
              <!-- 파일 아이콘 -->
              <c:choose>
                <c:when test="${fn:endsWith(file.fileOrginlNm, '.pdf')}">
                  <i class="fas fa-file-pdf text-danger mr-2"></i>
                </c:when>
                <c:when test="${fn:endsWith(file.fileOrginlNm, '.xlsx') or fn:endsWith(file.fileOrginlNm, '.xls')}">
                  <i class="fas fa-file-excel text-success mr-2"></i>
                </c:when>
                <c:otherwise>
                  <i class="fas fa-file mr-2"></i>
                </c:otherwise>
              </c:choose>
              ${file.fileOrginlNm}
            </span>
            
            <!-- 다운로드 버튼 -->
            <a href="/notice/download?fileGroupSn=${file.fileGroupSn}&fileNo=${file.fileNo}" 
               class="btn btn-sm btn-primary">
              <i class="fas fa-download"></i> 다운로드
            </a>
          </li>
        </c:forEach>
      </ul>
    </c:if>
    
    <c:if test="${empty fileDetailVOList}">
      <p class="text-muted mb-0">첨부된 파일이 없습니다.</p>
    </c:if>
  </td>
</tr>
              </table>

            </form>
          </div>
          <!-- 카드 바디 끝 -->

          <!-- 카드 푸터 시작 -->
          <div class="card-footer d-flex justify-content-end gap-2">
            <button type="button" id="editBtn" class="btn btn-info btn-sm">수정</button>
            <button type="submit" id="saveBtn" form="noticeForm" class="btn btn-success btn-sm" style="display:none;">저장</button>
            <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/notice/list'">닫기</button>
          </div>
          <!-- 카드 푸터 끝 -->

        </div>
        <!-- 카드 끝 -->

      </div>
    </div>
  </div>
</section>


	
	
	<!-- /// body 끝 /// -->

	<%@ include file="../include/footer.jsp"%>
