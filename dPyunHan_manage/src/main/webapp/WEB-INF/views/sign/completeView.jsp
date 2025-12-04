<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서명 완료</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f0f2f5; margin: 0; padding: 2em 0; }
        .container { text-align: center; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); max-width: 800px; width: 90%; }
        h1 { color: #007bff; margin-top: 0; }
        p { font-size: 1.1em; color: #333; }
        .close-btn { margin-top: 20px; padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 5px; cursor: pointer; }

        /* [!!!] 1. PDF 뷰어 스타일 추가 [!!!] */
        .pdf-viewer {
            width: 100%;
            height: 70vh; /* 화면 높이의 70% */
            border: 1px solid #ccc;
            margin-top: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>✔</h1>
    <h1>서명 완료</h1>

    <c:choose>
        <c:when test="${not empty signedFileVO}">
            <p>최종 서명된 문서는 다음과 같습니다.</p>

            <iframe src="<c:url value='/upload${signedFileVO.fileStrelc}' />" class="pdf-viewer" title="최종 서명된 PDF">
                <p>PDF 뷰어를 지원하지 않는 브라우저입니다.</p>
            </iframe>
        </c:when>

        <c:otherwise>
            <p>서명이 성공적으로 처리되었습니다. 감사합니다.</p>
            <p style="font-size: 0.9em; color: #777;">이 창은 닫으셔도 좋습니다.</p>
        </c:otherwise>
    </c:choose>

    <button class="close-btn" onclick="window.close();">창 닫기</button>
</div>
</body>
</html>