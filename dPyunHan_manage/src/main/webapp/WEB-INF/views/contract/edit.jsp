<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계약서 내용</title>
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
        .container { max-width: 900px; margin: 0 auto; }
        .approval-table { width: 500px; border-collapse: collapse; margin-bottom: 30px; table-layout: fixed; }
        .approval-table th, .approval-table td { border: 1px solid #ccc; padding: 10px; text-align: center; height: 50px; }
        .approval-table th { background-color: #f4f4f4; width: 20%; }
        .approver-cell { background-color: #fafafa; }
        .btn { padding: 10px 15px; background: #007bff; color: white; border: none; cursor: pointer; }
        /* CKEditor의 모든 알림창을 강제로 숨김 */
        .cke_notification {
            display: none !important;
        }
    </style>
</head>
<%@ include file="../include/header.jsp" %>
<body>

    <c:set var="docTitle" value="계약서 작성" />

        <form action="/contract/save/${id}" method="post" id="contractForm"
              onsubmit="CKEDITOR.instances.editor1.updateElement();">

            <div class="container">
                <div class="card card-primary">
                    <div class="card-header">
                        <h2>${docTitle}</h2>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="sj">계약서 제목</label>
                            <input type="text" class="form-control cntrPost" id="sj" name="title"
                                   placeholder="제목을 입력하세요" value="${title}">
                        </div>
                        <div class="form-group">
                            <label for="editor1">내용</label>
                            <textarea class="form-control cntrPost" name="content" id="editor1">
                        <c:out value="${contractContent}" />
                    </textarea>
                        </div>
                    </div>
                    <div class="card-footer" style="margin-top: 10px;">
                        <button type="submit" id="btnRegister" class="btn btn-primary">저장</button>
                        <button type="button" class="btn btn-info" id="sanctnBtn" onclick="sendPdfToSanctn()">전자결재 상신</button>
                        <button type="button" id="btnCancel" class="btn btn-secondary" onclick="back()">목록</button>
                    </div>
                </div>
            </div>
        </form>




    <script>
        // 페이지가 모두 로드되면 함수 실행
        window.onload = function() {


            // --- (B) CKEditor 실행 ---
            // <textarea>에는 이미 //< //c:out//>으로 내용이 채워져 있으므로,
            // CKEditor를 실행(replace)하기만 하면 알아서 그 내용을 읽어갑니다.
            CKEDITOR.replace('editor1', {
                height: '400px',
                allowedContent: true, // HTML 태그 필터링 끄기 (지난번 요청)
                contentsCss: '/css/contract.css',
                // ★★★ 이 한 줄을 추가하세요 ★★★
                security_removeDefaultNotification: true
            });
        };

        function sendPdfToSanctn() {
            const form = document.getElementById('contractForm');

            // 1. (필수) CKEditor의 현재 내용을 <textarea name="content">에 반영
            // (form의 onsubmit에도 있지만, 여기서 한 번 더 호출하는 것이 안전합니다)
            CKEDITOR.instances.editor1.updateElement();

            // 2. 폼의 전송(action) URL을 "Handoff 컨트롤러"로 변경
            // (주의: /contract/save/${id} (임시저장) URL이 아님)
            form.action = '/contract/sendToSanctn';

            // 3. 폼 전송 방식을 'POST'로 설정
            form.method = 'POST';

            // 4. (선택) 버튼 비활성화 (중복 전송 방지)
            const sanctnBtn = document.getElementById('sanctnBtn');
            if (sanctnBtn) {
                sanctnBtn.innerText = '전자결재로 전송 중...';
                sanctnBtn.disabled = true;
            }

            // 5. 폼 전송 (AJAX가 아닌, 일반 페이지 이동 방식)
            //    이 폼은 'content'와 'title' 값을 Handoff 컨트롤러로 넘깁니다.
            form.submit();
        }
        // (2) PDF 저장을 위한 AJAX 함수 (결재선 로직 싹 제거됨)
        async function saveAsPdf() {
            const pdfBtn = document.getElementById('pdfBtn');
            pdfBtn.innerText = 'PDF 저장 중...';
            pdfBtn.disabled = true;

            // <input name="title"> 태그를 찾아서 현재 값을 가져옵니다.
            const titleInput = document.querySelector('input[name="title"]');
            const titleValue = titleInput.value;

            // 만약 제목이 비어있다면 '계약서'라는 기본값을 사용합니다.
            const filename = (titleValue ? titleValue : '계약서') + '.pdf';

            // CKEditor의 현재 HTML 데이터를 가져옴
            const htmlContent = CKEDITOR.instances.editor1.getData();

            const formData = new FormData();
            formData.append('content', htmlContent);

            try {
                // 컨트롤러('/contract/generate-pdf')로 HTML 전송
                const response = await fetch('/contract/generate-pdf', {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) {
                    throw new Error('PDF 생성에 실패했습니다.');
                }

                // 컨트롤러가 반환한 최종 PDF URL을 받음
                const finalPdfUrl = await response.text();

                if (finalPdfUrl.startsWith("ERROR:")) {
                    throw new Error(finalPdfUrl);
                }
                // --- ⬇️ 여기가 바뀝니다 ⬇️ ---
                // window.open(finalPdfUrl, '_blank'); // (새 창에서 열기 X)

                // (1) 보이지 않는 <a>(링크) 태그를 만듭니다.
                const link = document.createElement('a');
                link.href = finalPdfUrl; // (예: /output/temp_123.pdf)

                // (2) 'download' 속성을 주면, 브라우저가 열지 않고 다운로드합니다.
                // (파일명도 여기서 지정할 수 있습니다.)
                link.setAttribute('download', filename);

                // (3) 이 링크를 클릭한 것처럼 위장합니다.
                document.body.appendChild(link);
                link.click();

                // (4) 사용한 링크는 제거합니다.
                document.body.removeChild(link);

                // alert('PDF 다운로드를 시작합니다.');
                // --- ⬆️ 여기까지 바뀝니다 ⬆️ ---
                // 새 창에서 PDF 다운로드
                // alert('PDF 생성이 완료되었습니다.');
                // window.open(finalPdfUrl, '_blank');

            } catch (error) {
                console.error('PDF 생성 오류:', error);
                alert('오류가 발생했습니다: ' + error.message);
            } finally {
                pdfBtn.innerText = 'PDF로 저장';
                pdfBtn.disabled = false;
            }
        }
        /**
         * JSTL 변수(서버 데이터)를 읽어와 결재선 테이블을 채우는 함수
         */
        function loadApprovalLine() {
            // 1. JSTL 변수(서버 데이터)를 JavaScript 변수로 가져오기
            // (JSP는 서버에서, JS는 브라우저에서 돌기 때문에 이런 변환이 필요)
            const data = {
                approver1: { name: '<c:out value="${approver1_name}" />', status: '<c:out value="${approver1_status}" />' },
                approver2: { name: '<c:out value="${approver2_name}" />', status: '<c:out value="${approver2_status}" />' },
                approver3: { name: '<c:out value="${approver3_name}" />', status: '<c:out value="${approver3_status}" />' }
            };

            // 2. ID를 찾아가 innerText로 내용 채우기
            fillCell('name-1', data.approver1.name);
            fillCell('status-1', data.approver1.status);

            fillCell('name-2', data.approver2.name);
            fillCell('status-2', data.approver2.status);

            fillCell('name-3', data.approver3.name);
            fillCell('status-3', data.approver3.status);
        }

        /**
         * (보조 함수) ID로 칸을 찾아, 텍스트를 채우고, 상태에 따라 CSS 클래스 적용
         */
        function fillCell(cellId, text) {
            const cell = document.getElementById(cellId);
            if (cell) {
                cell.innerText = text; // 내용 채우기

                // 상태(status) 칸인 경우, CSS 꾸미기
                if (cellId.startsWith('status-')) {
                    if (text === '승인') {
                        cell.className = 'approver-cell status-approved';
                    } else if (text === '대기') {
                        cell.className = 'approver-cell status-pending';
                    } else {
                        cell.className = 'approver-cell';
                    }
                }
            }
        }
        function back() {
            window.location.href = '/contract/contractlist';
        }
    </script>
</body>
<%@ include file="../include/footer.jsp" %>
</html>