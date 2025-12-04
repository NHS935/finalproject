<%@ include file="../include/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>PDF 미리보기 및 서명</title>
    <style>
        /* 1. 페이지 기본 설정 (여백 제거) */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }

        /* 2. (신규) 전체를 감싸는 컨테이너 */
        /* 이 컨테이너가 버튼의 '기준점'이 됩니다. (position: relative) */
        .viewer-container {
            position: relative; /* 버튼의 기준점 */
            width: 100%;
            height: 80vh; /* 화면 전체 높이 */
        }

        /* 3. PDF 뷰어 (iframe) */
        /* 100vh가 아닌 100%로 변경 -> 부모(.viewer-container)를 꽉 채움 */
        .pdf-viewer {
            width: 100%;
            height: 100%;
            border: none;
        }

        /* 4. (신규) 사인하러가기 버튼 스타일 */
        .sign-button {
            position: absolute; /* .viewer-container를 기준으로 위치 고정 */
            bottom: 30px;       /* 아래에서 30px */
            right: 30px;        /* 오른쪽에서 30px */

            /* 버튼 디자인 */
            padding: 12px 25px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;

            /* 그림자 효과 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);

            /* 다른 요소들보다 위에 보이도록 z-index 설정 */
            z-index: 10;
        }

        .sign-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="viewer-container">

    <iframe src="${pageContext.request.contextPath}/original.pdf" class="pdf-viewer">
        <p>이 브라우저는 PDF 미리보기를 지원하지 않습니다.</p>
    </iframe>

    <button type="button" class="sign-button" onclick="goToSignPage()">
        사인하러가기
    </button>

</div>

<script>
    function goToSignPage() {
        // TODO: '사인하러가기' 페이지의 실제 URL로 변경하세요.
        // 예시: 문서 ID가 필요한 경우 '${id}' 등을 JSTL로 넘길 수 있습니다.
        window.location.href = '/sign/sign-page';
    }
</script>
<%@ include file="../include/footer.jsp" %>