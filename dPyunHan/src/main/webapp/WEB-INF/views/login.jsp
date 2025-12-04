<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ include file="./include/headerContents.jsp"%>

<!-- JS/CSS 불러오기 -->
<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
/* SweetAlert 팝업 크기 */
.swal2-popup {
	width: 600px !important;
	max-height: 90vh !important;
}

/* 로그인 배경/카드 스타일 */
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
	overflow: hidden;
}

header, .topbar, .navbar {
	position: fixed !important;
	top: 0;
	left: 0;
	width: 100%;
	z-index: 1;
}

section {
	position: absolute;
	top: 60px;
	bottom: 0;
	left: 0;
	right: 0;
	display: flex;
	justify-content: center;
	align-items: center;
	overflow: hidden;
}

.card {
	border-radius: 1rem;
	background-color: #fff;
	max-width: 400px;
	width: 90%;
}
</style>
<c:if test="${not empty errorMsg}">
	<script>
		const errorMessage = "${fn:escapeXml(errorMsg)}";

		if (errorMessage === 'APPROVAL_PENDING') {
			Swal.fire({
				icon : 'info',
				title : '로그인 불가',
				text : '관리사무소 승인 대기 중입니다.',
				confirmButtonText : '확인',
				allowOutsideClick : false
			});
		} else if (errorMessage === 'INVALID_CREDENTIALS') {
			Swal.fire({
				icon : 'error',
				title : '로그인 실패',
				text : '아이디 또는 비밀번호를 다시 확인해주세요.',
				confirmButtonText : '확인'
			});
		}
	</script>
</c:if>

<section>
	<div class="card shadow-lg border-0">
		<div class="card-body p-5 text-center">
			<h2 class="fw-bold text-primary mb-3">로그인</h2>
			<p class="text-muted mb-4">서비스를 이용하시려면 로그인해주세요</p>

			<form action="/login" method="POST">
				<div class="mb-3 text-start">
					<label class="form-label text-black fw-semibold">아이디</label> <input
						type="text" class="form-control" name="username"
						placeholder="아이디를 입력하세요" required />
				</div>

				<div class="mb-3 text-start">
					<label class="form-label text-black fw-semibold">비밀번호</label> <input
						type="password" class="form-control" name="password"
						placeholder="비밀번호를 입력하세요" required />
				</div>

				<button type="submit" class="btn btn-primary w-100 py-2">
					로그인 <i class="bi bi-box-arrow-in-right"></i>
				</button>
			</form>

			<button type="button"
				class="btn btn-outline-secondary w-100 mt-3 py-2"
				onclick="location.href='/signup'">회원가입</button>
		</div>
	</div>
</section>

<script>
	document.addEventListener("DOMContentLoaded", function() {
		sessionStorage.setItem('initialNtcnShown', 'false');
		sessionStorage.removeItem('lastLoggedInUser');
	});
</script>
