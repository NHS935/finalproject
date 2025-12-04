<%@ include file="../include/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<head>
    <title>모바일 서명</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>

    <style>
        body { font-family: sans-serif; text-align: center; padding-top: 20px; }

        /* 2. (NEW) 탭 버튼 스타일 */
        .tabs { border-bottom: 2px solid #ddd; margin-bottom: 20px; }
        .tab-button {
            padding: 10px 15px; border: none; background: #f0f0f0;
            font-size: 1.1em; cursor: pointer;
        }
        .tab-button.active { background: #fff; border: 2px solid #ddd; border-bottom: 2px solid #fff; font-weight: bold; }

        /* 3. (NEW) 탭 컨텐츠 (하나는 숨겨짐) */
        .tab-content { padding: 10px; }
        #upload-content { display: none; } /* 업로드 탭은 일단 숨김 */

        /* 4. 서명 패드 스타일 (동일) */
        #signature-pad-wrapper {
            border: 2px dashed #ccc; border-radius: 10px;
            width: 90%; margin: 20px auto;
        }
        canvas {
            width: 100%; height: 200px;
            background-color: rgba(0, 0, 0, 0); /* (수정!) 투명 배경 */
            border-radius: 10px;
        }

        /* 5. (NEW) 이미지 업로더 스타일 */
        #imageUploader { margin-top: 20px; }
        #image-preview { margin-top: 15px; }
        #image-preview img {
            max-width: 90%; height: 100px; border: 1px solid #ddd;
            background: white; /* 투명 PNG 인감을 위해 */
        }

        /* 6. 공통 버튼 스타일 */
        button {
            padding: 10px 20px; font-size: 1em; margin: 5px;
            border-radius: 5px; border: none; cursor: pointer;
        }
        #clearButton { background-color: #777; color: white; }
        #signButton { background-color: #007bff; color: white; font-size: 1.2em; }
    </style>
</head>
<body>

<h1>서명 방식 선택</h1>

<div class="tabs">
    <button class="tab-button active" id="tab-draw" onclick="showTab('draw')">직접 서명</button>
    <button class="tab-button" id="tab-upload" onclick="showTab('upload')">인감/이미지 업로드</button>
</div>

<div id="draw-content" class="tab-content">
    <p>여기에 서명하세요</p>
    <div id="signature-pad-wrapper">
        <canvas id="signature-pad"></canvas>
    </div>
    <button id="clearButton">다시 그리기</button>
</div>

<div id="upload-content" class="tab-content">
    <p>인감 도장 등 서명 이미지를 선택하세요.</p>
    <input type="file" id="imageUploader" accept="image/png, image/jpeg">
    <div id="image-preview"></div>
</div>

<hr style="margin-top: 20px;">
<button id="signButton">서명 완료</button>

<input type="hidden" id="sessionId" value="${sessionId}">
<div id="message"></div>

<script>
    let currentTab = 'draw';
    let uploadedImageBase64 = null; // (NEW) 업로드된 이미지의 Base64 저장 변수

    // --- (NEW) 탭 전환 로직 ---
    function showTab(tabName) {
        currentTab = tabName;
        if (tabName === 'draw') {
            document.getElementById('draw-content').style.display = 'block';
            document.getElementById('upload-content').style.display = 'none';
            document.getElementById('tab-draw').classList.add('active');
            document.getElementById('tab-upload').classList.remove('active');
        } else {
            document.getElementById('draw-content').style.display = 'none';
            document.getElementById('upload-content').style.display = 'block';
            document.getElementById('tab-draw').classList.remove('active');
            document.getElementById('tab-upload').classList.add('active');
        }
    }

    // --- (동일) 시그니처 패드 설정 ---
    const canvas = document.getElementById('signature-pad');
    const signaturePad = new SignaturePad(canvas, {
        backgroundColor: 'rgba(0, 0, 0, 0)' // 투명 배경
    });
    function resizeCanvas() {
        const ratio =  Math.max(window.devicePixelRatio || 1, 1);
        canvas.width = canvas.offsetWidth * ratio;
        canvas.height = canvas.offsetHeight * ratio;
        canvas.getContext("2d").scale(ratio, ratio);
        signaturePad.clear();
    }
    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();
    document.getElementById('clearButton').addEventListener('click', () => {
        signaturePad.clear();
    });

    // --- (NEW) 파일 업로더 로직 ---
    document.getElementById('imageUploader').addEventListener('change', (event) => {
        const file = event.target.files[0];
        const previewEl = document.getElementById('image-preview');

        // (수정) 1. 미리보기 영역을 먼저 비웁니다.
        previewEl.innerHTML = "";

        if (!file) {
            uploadedImageBase64 = null;
            return;
        }

        const reader = new FileReader();

        // (수정) 2. 'onload' 대신 'onloadend'를 사용합니다. (더 안정적)
        reader.onloadend = (e) => {
            if (e.target.readyState === FileReader.DONE) {
                // (수정) 3. Base64 데이터를 변수에 저장
                uploadedImageBase64 = e.target.result;

                // (수정) 4. 'innerHTML' 대신 'DOM'을 직접 조작합니다.
                // <p> 태그 생성
                const p = document.createElement('p');
                p.innerHTML = "<strong>미리보기:</strong>";

                // <img> 태그 생성
                const img = document.createElement('img');
                img.src = uploadedImageBase64; // <--- 여기에 Base64를 직접 대입!
                img.alt = "서명 미리보기";

                // (참고) CSS 스타일은 mobile-sign-page.jsp의 <style> 태그가
                // '#image-preview img' 에 자동으로 적용해 줍니다.

                // 미리보기 영역에 <p>와 <img>를 추가
                previewEl.appendChild(p);
                previewEl.appendChild(img);
            } else {
                alert("파일을 읽는 데 실패했습니다.");
                uploadedImageBase64 = null;
            }
        };

        // 파일을 Base64로 읽으라고 명령 (동일)
        reader.readAsDataURL(file);
    });


    // --- (수정됨) 서명 완료 버튼 로직 ---
    document.getElementById('signButton').addEventListener('click', async () => {
        let base64ImageData = null; // 서버로 보낼 최종 Base64

        // (NEW) 1. 어떤 탭이 활성화됐는지 확인
        if (currentTab === 'draw') {
            if (signaturePad.isEmpty()) {
                return alert("서명을 먼저 해주세요.");
            }
            // 캔버스에서 Base64 추출
            base64ImageData = signaturePad.toDataURL("image/png");
        } else { // currentTab === 'upload'
            if (!uploadedImageBase64) {
                return alert("이미지를 먼저 선택해주세요.");
            }
            // (NEW) 파일 리더가 저장해둔 Base64 사용
            base64ImageData = uploadedImageBase64;
        }

        // --- (이하 서버 전송 로직은 100% 동일!) ---

        const sessionId = document.getElementById('sessionId').value;
        const button = document.getElementById('signButton');
        const messageEl = document.getElementById('message');

        button.disabled = true;
        button.textContent = "처리 중...";

        try {
            const response = await fetch('/api/complete-signature', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    sessionId: sessionId,
                    imageData: base64ImageData // (중요!) 선택된 Base64를 전송
                })
            });

            const resultText = await response.text();
            if (response.ok) {
                messageEl.style.color = "green";
                messageEl.textContent = resultText;
                document.getElementById('signButton').style.display = 'none';
                // (탭과 버튼들 숨기기 - 선택적)
            } else { throw new Error(resultText); }

        } catch (err) {
            messageEl.style.color = "red";
            messageEl.textContent = "오류: " + err.message;
            button.disabled = false;
            button.textContent = "서명 완료";
        }
    });
</script>
</body>

<%@ include file="../include/footer.jsp" %>