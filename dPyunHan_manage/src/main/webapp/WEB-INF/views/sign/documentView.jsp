<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ include file="../include/header.jsp" %>--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계약서 미리보기 및 서명</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        /* --- (기존 스타일) --- */
        body, html { margin: 0; padding: 0; height: 100%; overflow: hidden; }
        .viewer-container { position: relative; width: 100%; height: 80vh; }
        .pdf-viewer { width: 100%; height: 100%; border: none; }
        .sign-button {
            position: absolute; bottom: 30px; right: 30px;
            padding: 12px 25px; background-color: #007bff; color: white;
            border: none; border-radius: 5px; font-size: 16px;
            font-weight: bold; cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            z-index: 10;
        }
        .sign-button:hover { background-color: #0056b3; }

        /* (QR 모달 스타일) */
        .qr-modal-overlay {
            display: none; position: fixed; top: 0; left: 0;
            width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6);
            z-index: 99; justify-content: center; align-items: center;
        }
        .qr-modal-content {
            background: white; padding: 30px; border-radius: 10px;
            text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        #qrcode { width: 200px; height: 200px; margin: 20px auto 0; }

        /* [!!!] 1. (FIX) 누락되었던 스타일 추가 [!!!] */
        #status {
            font-size: 1.1em; color: #555;
            margin: 15px; font-weight: bold;
            text-align: center;
        }
        #pdf-div { /* (서명 완료 후 최종 PDF가 표시될 영역) */
            display: none; width: 100%; height: 100vh; margin: 20px auto;
            text-align: center;
        }
        #pdf-frame { width: 100%; height: 80%; border: 1px solid #ccc; }
    </style>
</head>
<body>

<%-- [!!!] 2. (FIX) 누락되었던 'status' div 추가 [!!!] --%>
<div id="status">서버 연결 중...</div>

<div class="viewer-container" id="viewer-container">
    <iframe src="<c:url value='/upload${fileVO.fileStrelc}' />" class="pdf-viewer">
        <p>이 브라우저는 PDF 미리보기를 지원하지 않습니다.</p>
    </iframe>

    <button type="button" class="sign-button" onclick="showQrModal()">
        사인하러가기
    </button>
</div>

<div class="qr-modal-overlay" id="qrModal">
    <div class="qr-modal-content">
        <h4>모바일 기기로 QR 코드를 스캔하세요</h4>
        <p>모바일에서 서명을 완료하면 이 창은 자동으로 닫힙니다.</p>
        <div id="qrcode"></div>
        <button onclick="hideQrModal()" style="margin-top: 20px;">닫기</button>
    </div>
</div>

<%-- [!!!] 3. (FIX) 누락되었던 'pdf-div' (최종본 표시) div 추가 [!!!] --%>
<div id="pdf-div">
    <h2 style="color: blue;">✅ 서명이 완료되었습니다!</h2>
    <iframe id="pdf-frame" src=""></iframe>
</div>


<script>
    // --- (변수 선언부는 그대로) ---
    const signToken = "${signToken}";
    const PC_IP_ADDRESS = "192.168.141.46";
    const SERVER_PORT = "${pageContext.request.serverPort}";
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    const serverUrl = "${pageContext.request.scheme}://${pageContext.request.serverName}:${SERVER_PORT}${CONTEXT_PATH}";
    const mobileAccessUrl = "http://" + PC_IP_ADDRESS + ":" + SERVER_PORT + CONTEXT_PATH;
    const wsUrl = "ws://" + PC_IP_ADDRESS + ":" + SERVER_PORT + CONTEXT_PATH + "/ws/sign/" + signToken;

    let qrcode = null;

    // [!!!] 1. 정상 종료 여부를 체크할 변수 추가 [!!!]
    let isSignatureComplete = false;

    console.log("[WS] 연결 시도...", wsUrl);
    const socket = new WebSocket(wsUrl);

    socket.onopen = (event) => {
        console.log("[WS] 연결 성공.");
        document.getElementById('status').textContent = "서버 연결 성공. QR 생성 대기 중...";
    };

    // [!!!] 2. onclose 수정: 정상 완료가 아닐 때만 메시지 띄우기 [!!!]
    socket.onclose = (event) => {
        console.log("[WS] 연결 종료.");

        // 서명이 완료되어서 끊은 게 아니라면 (진짜 네트워크 문제라면) 메시지 표시
        if (!isSignatureComplete) {
            document.getElementById('status').textContent = "서버와 연결이 끊겼습니다.";
            document.getElementById('status').style.color = "red"; // (선택) 에러니까 빨간색
        } else {
            // 서명 완료로 끊긴 거면 아예 status 박스를 숨겨버림
            document.getElementById('status').style.display = 'none';
        }
    };

    socket.onerror = (error) => {
        console.error("[WS] 웹소켓 오류 발생!", error);
        document.getElementById('status').textContent = "서버 연결에 실패했습니다.";
    };

    socket.onmessage = (event) => {
        console.log("[WS] 메시지 수신:", event.data);
        try {
            const msg = JSON.parse(event.data);

            if (msg.type === 'signatureCompleted' && msg.url) {
                console.log("[WS] 서명 완료 메시지 확인! PDF 로드:", msg.url);

                // [!!!] 3. 정상 완료 플래그를 true로 변경 [!!!]
                isSignatureComplete = true;

                hideQrModal();

                // UI 변경
                document.getElementById('status').textContent = "";
                document.getElementById('viewer-container').style.display = 'none';
                document.getElementById('pdf-div').style.display = 'block';
                document.getElementById('pdf-frame').src = "/upload"+msg.url;

                // [!!!] 4. 소켓 종료 (이제 onclose가 실행되더라도 메시지가 안 뜸)
                socket.close();
            }
        } catch (e) {
            console.error("[WS] 수신 메시지 처리 중 오류:", e);
        }
    };

    // --- (아래 함수들은 그대로) ---
    function showQrModal() {
        const mobileSignUrl = `\${mobileAccessUrl}/sign/mobile?token=${signToken}`;
        console.log("모바일 QR URL:", mobileSignUrl);

        const qrDiv = document.getElementById('qrcode');
        qrDiv.innerHTML = "";
        qrcode = new QRCode(qrDiv, { text: mobileSignUrl, width: 200, height: 200 });

        document.getElementById('status').textContent = "QR 생성 완료. 스캔 대기 중...";
        document.getElementById('qrModal').style.display = 'flex';
    }

    function hideQrModal() {
        document.getElementById('qrModal').style.display = 'none';
    }
</script>

<%-- <%@ include file="../include/footer.jsp" %>--%>
</body>
</html>