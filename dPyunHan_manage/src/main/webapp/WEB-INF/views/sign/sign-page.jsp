<%@ include file="../include/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<head>
    <title>PC 서명 페이지</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        body { font-family: sans-serif; text-align: center; }
        #qr-div { border: 2px solid #ddd; padding: 20px; display: inline-block; }
        #pdf-div { display: none; width: 80%; height: 80vh; margin: auto; }
        #pdf-frame { width: 100%; height: 80%; }
        h2 { color: blue; }
    </style>
</head>
<body>

<h1>전자 계약서 서명</h1>

<div id="status">PC와 서버 연결 중...</div>
<div id="qr-div">
    <p>모바일로 QR 코드를 스캔하여 서명을 완료하세요.</p>
    <div id="qrcode"></div>
</div>

<div id="pdf-div">
    <h2>✅ 서명이 완료되었습니다!</h2>
    <iframe id="pdf-frame" src=""></iframe>
</div>


<script>
    // 🚨 (여기를 수정하세요!) 🚨
    // 2번에서 찾은 님의 PC 내부 IP를 여기에 "문자열"로 입력하세요.
    const PC_IP_ADDRESS = "192.168.141.46"; // (예시 IP입니다.)
    const SERVER_PORT = "8020"; // (스프링 포트)
    const BASE_URL = PC_IP_ADDRESS + ":" + SERVER_PORT;

    // 4. 웹소켓 접속
    // (수정) 'location.host' 대신 하드코딩한 IP 주소 사용
    const socket = new WebSocket('ws://' + BASE_URL + '/ws/sign');

    // 5. 서버로부터 메시지를 받았을 때(디버깅 로그 추가!)
    socket.onmessage = (event) => {
        console.log("✅ 1. [WS] 메시지 받음:", event.data); // <-- 로그 1
        const msg = JSON.parse(event.data);

        if (msg.type === 'sessionCreated') {
            document.getElementById('status').textContent = "서버 연결 성공. QR 생성 중...";
            generateQRCode(msg.sessionId);
        }

        // (중요!) 여기서부터 확인하세요
        if (msg.type === 'signatureCompleted') {
            console.log("✅ 2. [JS] 메시지 타입: " + msg.type); // <-- 로그 2

            try {
                console.log("✅ 3. [JS] UI 변경 시도..."); // <-- 로그 3
                document.getElementById('status').textContent = "";
                document.getElementById('qr-div').style.display = 'none';
                document.getElementById('pdf-div').style.display = 'block';

                console.log("✅ 4. [JS] PDF 로드 시도: " + msg.url); // <-- 로그 4
                document.getElementById('pdf-frame').src = msg.url;

                socket.close();
            } catch (e) {
                // (만약 ID 오타 등으로 여기서 에러가 나면 이게 찍힘)
                console.error("❌ 5. [JS] UI 변경 중 심각한 오류 발생!", e);
            }
        }
    };

    socket.onopen = (e) => console.log("웹소켓 연결 성공");
    socket.onclose = (e) => console.log("웹소켓 연결 종료")
    socket.onerror = (e) => console.error("❌ [WS] 웹소켓 오류 발생!", e); // <-- 오류 로그

    // 6. QR 코드 생성 함수
    function generateQRCode(sessionId) {
        const mobileUrl = 'http://' + BASE_URL + '/sign/mobile-sign-page?session=' + sessionId;

        console.log("시연용 모바일 URL:", mobileUrl); // 이 주소가 폰에서 열림

        document.getElementById('qrcode').innerHTML = ""; // 기존 QR 삭제

        new QRCode(document.getElementById("qrcode"), {
            text: mobileUrl,
            width: 200,
            height: 200
        });
        document.getElementById('status').textContent = "QR 생성 완료. 스캔 대기 중...";
    }
</script>
</body>
<%@ include file="../include/footer.jsp" %>