<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- <%@ include file="../include/header.jsp" %> --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>모바일 서명</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>

    <style>
        body { font-family: sans-serif; text-align: center; padding: 15px; background-color: #f0f2f5; }
        .container { max-width: 450px; margin: 0 auto; background: white; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }

        /* 2. 탭 버튼 스타일 */
        .tabs { display: flex; }
        .tab-button {
            flex: 1; /* 1:1 비율 */
            padding: 12px 15px; border: none; background: #f0f0f0;
            font-size: 1.1em; cursor: pointer;
            border-bottom: 2px solid #ddd;
        }
        .tab-button.active {
            background: #fff;
            border-bottom: 3px solid #007bff; /* 활성 탭 강조 */
            font-weight: bold;
            color: #007bff;
        }

        /* 3. 탭 컨텐츠 (하나는 숨겨짐) */
        .tab-content { padding: 20px; }
        #upload-content { display: none; } /* 업로드 탭은 일단 숨김 */

        /* 4. 서명 패드 스타일 */
        #signature-pad-wrapper {
            border: 2px dashed #ccc; border-radius: 10px;
            width: 95%; margin: 15px auto;
        }
        canvas {
            width: 100%; height: 200px;
            background-color: rgba(0, 0, 0, 0); /* [!!!] 배경 투명 [!!!] */
            border-radius: 10px;
            touch-action: none; /* [!!!] 모바일 터치 이벤트 [!!!] */
        }
        #clearButton { background-color: #777; color: white; width: 100%; }

        /* 5. 이미지 업로더 스타일 */
        #imageUploader { margin-top: 10px; width: 100%; }
        #image-preview { margin-top: 15px; }
        #image-preview img {
            max-width: 90%; height: 100px; border: 1px solid #ddd;
            background: white; /* 투명 PNG 인감을 위해 */
        }

        /* 6. 공통 폼 스타일 */
        .form-footer { padding: 20px; background: #f9f9f9; border-top: 1px solid #eee; }
        .form-group { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .form-group label { font-weight: bold; }
        .form-group input[type="text"] { width: 65%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }

        button { padding: 10px 20px; font-size: 1em; margin: 5px; border-radius: 5px; border: none; cursor: pointer; }
        #signButton { background-color: #007bff; color: white; font-size: 1.2em; width: 100%; }
    </style>
</head>
<body>

<div class="container">

    <form id="signForm" action="<c:url value='/sign/submit' />" method="POST" onsubmit="return handleSubmit()">

        <div class="tabs">
            <button type="button" class="tab-button active" id="tab-draw" onclick="showTab('draw')">직접 서명</button>
            <button type="button" class="tab-button" id="tab-upload" onclick="showTab('upload')">인감/이미지 업로드</button>
        </div>

        <div id="draw-content" class="tab-content">
            <p style="margin: 0 0 10px 0;">아래 영역에 서명하세요</p>
            <div id="signature-pad-wrapper">
                <canvas id="signature-pad"></canvas>
            </div>
            <button type="button" id="clearButton">다시 그리기</button>
        </div>

        <div id="upload-content" class="tab-content">
            <p style="margin: 0 0 10px 0;">인감 도장 등 서명 이미지를 선택하세요.</p>
            <input type="file" id="imageUploader" accept="image/png, image/jpeg">
            <div id="image-preview"></div>
        </div>

        <div class="form-footer">
            <input type="hidden" name="token" value="${signToken}">
            <input type="hidden" id="signatureData" name="signatureData">

            <div class="form-group">
                <label for="signerName">서명자:</label>
                <input type="text" id="signerName" name="signerName" value="<c:out value='${signerName}' />" required>
            </div>

            <button type="submit" id="signButton">서명 완료</button>
        </div>

    </form>
</div>


<script>
    let currentTab = 'draw'; // 현재 활성화된 탭 (draw | upload)
    let uploadedImageBase64 = null; // 업로드된 이미지의 Base64 저장 변수

    // --- 탭 전환 로직 ---
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

    // --- 시그니처 패드 설정 ---
    const canvas = document.getElementById('signature-pad');
    const signaturePad = new SignaturePad(canvas, {
        backgroundColor: 'rgba(0, 0, 0, 0)', // [!!!] 배경 투명 [!!!]
        penColor: 'rgb(0, 0, 0)'
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

    // --- 파일 업로더 로직 ---
    document.getElementById('imageUploader').addEventListener('change', (event) => {
        const file = event.target.files[0];
        const previewEl = document.getElementById('image-preview');
        previewEl.innerHTML = ""; // 미리보기 영역 비우기

        if (!file) {
            uploadedImageBase64 = null;
            return;
        }

        // (파일 크기 제한 - 예: 2MB)
        if (file.size > 2 * 1024 * 1024) {
            alert("파일 크기는 2MB를 초과할 수 없습니다.");
            uploadedImageBase64 = null;
            event.target.value = null; // (파일 선택 취소)
            return;
        }

        const reader = new FileReader();
        reader.onloadend = (e) => {
            if (e.target.readyState === FileReader.DONE) {
                uploadedImageBase64 = e.target.result; // Base64 변수에 저장

                const p = document.createElement('p');
                p.innerHTML = "<strong>미리보기:</strong>";
                const img = document.createElement('img');
                img.src = uploadedImageBase64;
                img.alt = "서명 미리보기";

                previewEl.appendChild(p);
                previewEl.appendChild(img);
            }
        };
        reader.readAsDataURL(file); // Base64로 읽기
    });


    // [!!!] 5. (수정) 폼(Form) 제출 시 실행되는 최종 핸들러 [!!!]
    function handleSubmit() {
        let base64ImageData = null;

        // 1. 활성화된 탭 확인
        if (currentTab === 'draw') {
            if (signaturePad.isEmpty()) {
                alert("서명을 먼저 해주세요.");
                return false; // 폼 제출 중단
            }
            // 캔버스에서 Base64 추출
            base64ImageData = signaturePad.toDataURL("image/png");

        } else { // currentTab === 'upload'
            if (!uploadedImageBase64) {
                alert("이미지를 먼저 선택해주세요.");
                return false; // 폼 제출 중단
            }
            // 업로드된 Base64 사용
            base64ImageData = uploadedImageBase64;
        }

        // 2. 서명자 이름 확인
        const signerName = document.getElementById('signerName').value;
        if (signerName.trim() === "") {
            alert("서명자 이름을 입력해주세요.");
            document.getElementById('signerName').focus();
            return false; // 폼 제출 중단
        }

        // 3. (중요) hidden input에 최종 Base64 데이터를 저장
        document.getElementById('signatureData').value = base64ImageData;

        // 4. 버튼 비활성화 (중복 제출 방지)
        const button = document.getElementById('signButton');
        button.disabled = true;
        button.textContent = "처리 중...";

        // 5. 폼 제출 진행
        return true;
    }
</script>

<%-- <%@ include file="../include/footer.jsp" %> --%>
</body>
</html>