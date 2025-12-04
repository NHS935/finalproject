<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>

<script>
document.addEventListener("DOMContentLoaded", () => {
	// 접수 버튼 클릭 시 폼 표시
	$("#cvplRcept").click(function() {
		$("#cvplForm").show();
		$(this).hide();
	});

	// 취소 버튼 클릭 시 다시 숨김
	$("#cancelBtn").click(function(e) {
		e.preventDefault();
		$("#cvplForm").hide();
		$("#cvplRcept").show();
	});

	// CKEditor 초기화
	let cvplEditor; // 전역 변수 선언
	ClassicEditor.create(document.querySelector('#cvplText'))
		.then(newEditor => {
			cvplEditor = newEditor;
			window.cvplEditor = newEditor;
		})
		.catch(error => {
			console.error('Editor error:', error);
		})
	
	// 완료 버튼 클릭 시 AJAX 전송
	$("#successBtn").click(function(e) {
		e.preventDefault();
		
		const cvplSn = "${cvplVO.cvplSn}";
		const content = window.cvplEditor.getData().trim();
		
		if (content === "") {
			Swal.fire({ icon: 'warning', title: '처리 내용을 입력하세요.', timer: 1500, showConfirmButton: false });
			return;
		}
		
		const formData = new FormData();
		formData.append("cvplSn", cvplSn);
		formData.append("rceptCn", content);
		formData.append("empId", "${sessionScope.emp.empId}"); // 로그인 직원 세션 값 바인딩
		
		// 파일 여러 개 첨부 가능
		const files = $("#cvplFile")[0].files;
		for (let i = 0; i < files.length; i++) {
			formData.append("uploadFiles", files[i]);
		}
		
		$.ajax({
			url: "/cvplRcept/cvplRceptPost",
			type: "POST",
			data: formData,
			processData: false,
			contentType: false,
			success: function(result) {
				if (parseInt(result) > 0) {
					Swal.fire({ icon: 'success', title: '민원이 접수되었습니다.', timer: 1500, showConfirmButton: false });
					setTimeout(() => location.href = "/cvplRcept/list", 1500);
				} else {
					Swal.fire({ icon: 'warning', title: '접수 실패', timer: 1500, showConfirmButton: false });
				}
			},
			error: function() {
				Swal.fire({ icon: 'error', title: '서버 오류', timer: 1500, showConfirmButton: false });
			}
		});
	});
    
	// 이미지 미리 보기 영역
	$("#cvplFile").on("change", function() {
		const files = this.files;
		const preview = $("#previewArea");
		preview.empty();

		Array.from(files).forEach(file => {
			const reader = new FileReader();
			reader.onload = e => {
				preview.append(
					$("<img>").attr("src", e.target.result).css({width: "100px",height: "100px","object-fit": "cover",border: "1px solid #ccc","border-radius": "5px"})
				);
			};
			reader.readAsDataURL(file);
		});
	});
});
</script>

<!-- ///// content 시작 ///// -->

<h2>민원 상세보기</h2>

<div>
	<p><strong>민원 번호:</strong> ${cvplVO.cvplSn}</p>
	<p><strong>작성자:</strong> ${cvplVO.mberNm}</p>
	<p><strong>제목:</strong> ${cvplVO.cvplSj}</p>
	<p><strong>내용:</strong> ${cvplVO.cvplCn}</p>
	<p><strong>요청일:</strong>
		<fmt:formatDate value="${cvplVO.reqstDt}" pattern="yyyy-MM-dd HH:mm" /></p>
	<p><strong>부서:</strong>
		<c:choose>
			<c:when test="${cvplVO.deptCode == 1}">행정</c:when>
			<c:when test="${cvplVO.deptCode == 2}">시설관리</c:when>
			<c:when test="${cvplVO.deptCode == 3}">소방안전</c:when>
			<c:when test="${cvplVO.deptCode == 4}">환경</c:when>
			<c:otherwise>미지정</c:otherwise>
		</c:choose>
	</p>
	<c:choose>
        <c:when test="${not empty cvplVO.fileGroupVO.fileDetailVOList}">
            <p><strong>첨부 이미지:</strong></p>
            <div style="display:flex; gap:10px; flex-wrap:wrap;">
	           	<c:forEach var="fileDetailVO" items="${cvplVO.fileGroupVO.fileDetailVOList}">
					<img src="/upload${fileDetailVO.fileStrelc}" style="width:100px;height:100px;object-fit:cover;border:1px solid #ccc;border-radius:5px;">
				</c:forEach>
			</div>
        </c:when>
		<c:otherwise>
			<p class="text-muted">첨부 이미지가 없습니다.</p>
		</c:otherwise>
    </c:choose>
</div><br>
<button type="button" id="cvplRcept">접수</button>

<form id="cvplForm" style="display: none; margin-top: 10px;" enctype="multipart/form-data">
	<input type="hidden" name="empId" value="${empId}">
	<textarea id="cvplText" name="rceptCn" rows="5" cols="50" placeholder="처리 내용을 입력하세요."></textarea><br />
	<input type="file" id="cvplFile" name="uploadFiles" multiple accept="image/*"><br>

	<div id="previewArea" style="margin-top:10px; display:flex; gap:10px; flex-wrap:wrap;"></div><br>

	<button id="cancelBtn">취소</button>
	<button id="successBtn">접수</button>
</form>

<!-- ///// content 끝 ///// -->

<%@ include file="../include/footer.jsp"%>
