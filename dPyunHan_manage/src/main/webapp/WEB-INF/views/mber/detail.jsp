<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../include/header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세보기</title>

<style>
.container-flex {
	display: flex;
	justify-content: center;
	align-items: flex-start;
	gap: 40px;
	margin: 50px auto;
	width: 95%;
}

/* 카드 크기 비율: 오른쪽이 좀 더 넓게 */
.left-panel, .right-panel {
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 25px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.left-panel {
	flex: 1;
	max-width: 550px;
}

.right-panel {
	flex: 1.5;
	max-width: 850px;
}

h2 {
	text-align: center;
	margin-bottom: 25px;
}

.detail-group {
	margin-bottom: 12px;
}

.detail-group label {
	display: inline-block;
	width: 160px;
	font-weight: bold;
}

.status {
	text-align: center;
	margin-bottom: 15px;
	font-weight: bold;
}

.status.wait {
	color: orange;
}

.status.approved {
	color: green;
}

.btn-group {
	text-align: center;
	margin-top: 25px;
}

.btn {
	display: inline-block;
	margin: 0 10px;
	padding: 10px 25px;
	border: none;
	border-radius: 5px;
	color: white;
	cursor: pointer;
	font-size: 15px;
}

.btn-approve {
	background-color: #4CAF50;
}

.btn-back {
	background-color: #777;
}

.btn:hover {
	opacity: 0.9;
}

.modal-footer {
	justify-content: center !important;
}
</style>
</head>

<body>

	<div class="container-flex">

		<!--  왼쪽: 입주민 상세정보 -->
		<div class="left-panel">
			<h2>입주민 상세정보</h2>

			<div class="status ${member.enabled eq '1' ? 'approved' : 'wait'}">
				상태 :
				<c:choose>
					<c:when test="${member.enabled eq '1'}">승인됨</c:when>
					<c:otherwise>승인 대기중</c:otherwise>
				</c:choose>
			</div>

			<!-- 회원 기본정보 -->
			<div class="detail-group">
				<label>회원 ID:</label>
				<c:out value="${member.mberId}" />
			</div>
			<div class="detail-group">
				<label>이름:</label>
				<c:out value="${member.mberNm}" />
			</div>
			<div class="detail-group">
				<label>전화번호:</label>
				<c:out value="${member.telno}" />
			</div>
			<div class="detail-group">
				<label>이메일:</label>
				<c:out value="${member.email}" />
			</div>
			<div class="detail-group">
				<label>회원유형:</label>
				<c:choose>
					<c:when test="${member.mberTy == 3}">임차</c:when>
					<c:when test="${member.mberTy == 2}">자가</c:when>
					<c:otherwise>임대</c:otherwise>
				</c:choose>
			</div>
			<div class="detail-group">
				<label>생년월일:</label>
				<c:out value="${member.brthdy}" />
			</div>

			<hr>

			<!-- 세대정보 -->
			<div class="detail-group">
				<label>세대번호:</label>
				<c:out value="${member.hshldId}" />
			</div>
			<div class="detail-group">
				<label>기본주소:</label>
				<c:out value="${member.adres}" />
			</div>
			<div class="detail-group">
				<label>동:</label>
				<c:out value="${member.aptcmpl}" />
			</div>
			<div class="detail-group">
				<label>호:</label>
				<c:out value="${member.ho}" />
			</div>
			<div class="detail-group">
				<label>커뮤니티 사용여부:</label>
				<c:choose>
					<c:when test="${member.cmmntyUseAt == 1}">사용</c:when>
					<c:otherwise>미사용</c:otherwise>
				</c:choose>
			</div>
			<div class="detail-group">
			    <label>거주상태:</label>
			    입주중
			</div>
			<div class="detail-group">
				<label>입주일자:</label>
				<c:out value="${member.mvnDe}" />
			</div>

			<div class="btn-group">
				<c:if test="${member.enabled ne '1'}">
					<!--  승인 버튼 클릭 시 모달 표시 -->
					<button type="button" class="btn btn-approve" data-toggle="modal"
						data-target="#approveModal">승인하기</button>
				</c:if>
				<button type="button" class="btn btn-back"
					onclick="location.href='${pageContext.request.contextPath}/mber/list'">목록으로</button>
			</div>
		</div>

		<!--  오른쪽: 추가 정보 탭 -->
		<div class="right-panel">
			<h2>추가 정보</h2>
			<div class="card card-primary card-outline card-tabs">
				<div class="card-header p-0 pt-1 border-bottom-0">
					<ul class="nav nav-tabs" id="custom-tabs-three-tab" role="tablist">
						<li class="nav-item"><a class="nav-link active"
							data-toggle="pill" href="#car" role="tab">차량정보</a></li>
						<li class="nav-item"><a class="nav-link" data-toggle="pill"
							href="#etc" role="tab">기타</a></li>
					</ul>
				</div>
				<div class="card-body">
					<div class="tab-content">
	                    <div class="tab-pane fade show active" id="car" role="tabpanel">
	                       	<strong>차량번호:</strong>
	                        <c:out value="${member.carNo}" default="등록된 차량 없음" /><br>
	                    </div>
					    <strong>첨부파일:</strong><br>
					        <img src="/upload${member.filePath}" 
					             alt="${member.fileNm}"
					             style="max-width:100%; max-height:100%; border:1px solid #ccc; margin-top:5px;">
				</div>
			</div>
		</div>
	</div>
	<!--  승인 확인용 작은 모달 -->
	<div class="modal fade" id="approveModal" tabindex="-1" role="dialog"
		aria-labelledby="approveModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-sm" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="approveModalLabel">승인 확인</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="닫기">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body text-center">
					<strong>${member.mberNm}</strong> 님을 승인하시겠습니까?
				</div>
				<div class="modal-footer">
					<form action="${pageContext.request.contextPath}/mber/approve"
						method="post">
						<input type="hidden" name="mberId" value="${member.mberId}" />
						<button type="submit" class="btn btn-success">확인</button>
					</form>
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>

	
	<%@ include file="../include/footer.jsp"%>
</body>
</html>
