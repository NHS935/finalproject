<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- /// header 시작  -->
<%@ include file="./include/headerContents.jsp"%>
<link href="/dewi/assets/css/main.css" rel="stylesheet">
<style>
/* 스크롤바 전체 */
.terms-scroll::-webkit-scrollbar {
    width: 8px; 
}

/* 스크롤 트랙(배경) */
.terms-scroll::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 8px;
}

/* 스크롤 thumb(움직이는 부분) */
.terms-scroll::-webkit-scrollbar-thumb {
    background: #F66214;     /* 스크롤 색 */
    border-radius: 8px;
}

/* hover 시 색 진하게 */
.terms-scroll::-webkit-scrollbar-thumb:hover {
    background: #e06626;
}

/* 마이페이지 공통 */
.mypage-section {
    margin-top: 20px;
    padding: 16px 12px;
    border-radius: 10px;
    background: #f8fafc;
    border: 1px solid #e4e7ec;
}

.mypage-title {
    font-size: 17px;
    font-weight: 700;
    margin-bottom: 10px;
    color: #333;
}

.mypage-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #e6e6e6;
}

.mypage-item:last-child {
    border-bottom: none;
}

.mypage-label {
    font-size: 14px;
    font-weight: 600;
    color: #444;
}

.mypage-value input {
    width: 160px;
    padding: 8px 10px;
    border: 1px solid #cfd4da;
    border-radius: 6px;
    background: #fff;
    font-size: 14px;
    color: #333;
}

.mypage-value input:focus {
    border: 1px solid #4a8fff;
    outline: none;
    box-shadow: 0 0 2px rgba(70, 130, 255, 0.5);
}

.readonly-value {
    font-size: 14px;
    color: #333;
    text-align: right;
}

/* 정보 수정 버튼 (네가 쓰던 버튼 스타일 유지) */
.mypage-btn {
    width: 100%;
    margin-top: 16px;
    padding: 10px;
    border: none;
    border-radius: 8px;
    background: #F66214;
    color: #fff;
    font-size: 15px;
    font-weight: 600;
}

.mypage-btn:active {
    opacity: 0.9;
}


</style>
<!-- /// body 시작 /// -->
<div class="card" style="margin:10px; padding:10px; border:3px solid rgba(100, 140, 164, 0.75); border-radius:14px;">
    <div class="card-title" style="text-align:center; font-size:20px; font-weight:bold; margin-bottom:6px;">
    <img src="/images/logo/logologo.png" alt="로고" style="height:24px; width:24px; margin-bottom:6px;"> D-편한세상
    </div>
	<!-- 목록 -->
	<div class="mobile-list">
	   <div class="input-block" >
			<div class="form-group privacy">
			    <div class="terms-scroll" tabindex="0" style="height: calc(100vh - 204px);  border: 0px solid #dfe0df; border-radius: 4px; padding: 12px 14px; overflow-y: auto; background: #fff; color: #000;">
	                <strong style="display:block; text-align:center; font-size:18px; font-weight:bold;">내 정보</strong><br>
        <form action="/mypage/update" method="post">
            <div class="mypage-section">
                <div class="mypage-item">
                    <span class="mypage-label">이름</span>
                    <span class="mypage-value">
                        <input type="text" name="mberNm" value="<c:out value='${mberVO.mberNm}'/>" required>
                    </span>
                </div>
                
                <div class="mypage-item">
                    <span class="mypage-label">전화번호</span>
                    <span class="mypage-value">
                        <input type="text" name="telno" value="<c:out value='${mberVO.telno}'/>" required>
                    </span>
                </div>
                
                <div class="mypage-item">
                    <span class="mypage-label">이메일</span>
                    <span class="mypage-value">
                        <input type="email" name="email" value="<c:out value='${mberVO.email}'/>" required>
                    </span>
                </div>
                
                <div class="mypage-item">
                    <span class="mypage-label">비밀번호</span>
                    <span class="mypage-value">
                        <input type="password" name="password" placeholder="변경하려면 입력">
                    </span>
                </div>
                
                <button type="submit" class="mypage-btn">정보 수정</button>
            </div>
        </form>

        <!-- 우리집 정보 읽기 전용 -->
        <div class="mypage-section">
            <div class="mypage-title">우리집 정보</div>
            
            <div class="mypage-item">
                <span class="mypage-label">동/호</span>
                <span class="readonly-value">
                    <c:out value="${mberVO.aptcmpl}"/>동 <c:out value="${mberVO.ho}"/>호
                </span>
            </div>
            
            <div class="mypage-item">
                <span class="mypage-label">입주민 인증</span>
                <span class="readonly-value">
                    <c:choose>
                        <c:when test="${mberVO.enabled eq '0'}">
                            미인증
                        </c:when>
                        <c:otherwise>
                            인증 완료
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
	            </div>
	        </div>
	    </div>
	</div>
</div>


<c:if test="${param.updateSuccess == 'true'}">
<script>
document.addEventListener("DOMContentLoaded", function () {
    const hasSwal = typeof window.Swal !== "undefined";

    const Toast = hasSwal
        ? Swal.mixin({
            toast: true,
            position: "top",
            showConfirmButton: false,
            timer: 1500,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.style.top = 64 + "px";
                toast.style.position = "fixed";
            }
        })
        : null;

    if (Toast) {
        Toast.fire({
            icon: "success",
            title: "정보가 정상적으로 수정되었습니다."
        });
    } else {
        alert("오류로 인해 정보가 수정되지 않았습니다.");
    }
});
</script>
</c:if>


<!-- /// footer 시작 /// -->
<%@ include file="./include/footerContents.jsp"%>
<!-- /// footer 끝 /// -->