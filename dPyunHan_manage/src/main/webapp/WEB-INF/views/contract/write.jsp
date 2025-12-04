<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>CKEditor + Spring 연동</title>
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
        .container { max-width: 900px; margin: 0 auto; }
        .approval-table { width: 500px; border-collapse: collapse; margin-bottom: 30px; table-layout: fixed; }
        .approval-table th, .approval-table td { border: 1px solid #ccc; padding: 10px; text-align: center; height: 50px; }
        .approval-table th { background-color: #f4f4f4; width: 20%; }
        .approver-cell { background-color: #fafafa; }
        .btn { padding: 10px 15px; background: #007bff; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
<div class="container">
    <h1>CKEditor + Spring + "가짜 DB" 연동 시연</h1>
    <c:set var="docTitle" value="[품의] 2026년 워크샵 장소 선정 건" />

    <%-- (가정 1) DB에서 불러온 '결재선' 정보 --%>
    <c:set var="approver1_name" value="이팀장" />
    <c:set var="approver1_status" value="승인" />

    <c:set var="approver2_name" value="김부장" />
    <c:set var="approver2_status" value="대기" />

    <c:set var="approver3_name" value="" /> <%-- 3번 결재자는 비어있음 --%>
    <c:set var="approver3_status" value="" />
    <div class="container">
        <h1>전자결재 문서 조회 (통합 예제)</h1>

        <h2>${docTitle}</h2>

        <h3>결재선</h3>
        <table class="approval-table">
            <tbody>
            <tr>
                <th>성명</th>
                <td class="approver-cell" id="name-1"></td> <td class="approver-cell" id="name-2"></td> <td class="approver-cell" id="name-3"></td> </tr>
            <tr>
                <th>상태</th>
                <td class="approver-cell" id="status-1"></td> <td class="approver-cell" id="status-2"></td> <td class="approver-cell" id="status-3"></td> </tr>
            </tbody>
        </table>
    <form action="/contract/save/${id}" method="post" id="contractForm"
          onsubmit="CKEDITOR.instances.editor1.updateElement();">

        <h3>계약서 내용</h3>

        <textarea name="content" id="editor1">
                <c:out value="${contractContent}" />
            </textarea>

        <br>
        <button type="submit" class="btn">저장</button>
        <button type="button" class="btn btn-pdf" id="pdfBtn" onclick="saveAsPdf()">
            PDF로 저장
        </button>
    </form>


</div>

    <script>
        // 페이지가 모두 로드되면 함수 실행
        window.onload = function() {

            // --- (A) 결재선 불러오기 실행 ---
            loadApprovalLine();

            // --- (B) CKEditor 실행 ---
            // <textarea>에는 이미 //< //c:out//>으로 내용이 채워져 있으므로,
            // CKEditor를 실행(replace)하기만 하면 알아서 그 내용을 읽어갑니다.
            CKEDITOR.replace('editor1', {
                height: '400px',
                allowedContent: true, // HTML 태그 필터링 끄기 (지난번 요청)
                contentsCss: '/css/contract.css'
            });
        };
        // (2) PDF 저장을 위한 AJAX 함수 (결재선 로직 싹 제거됨)
        async function saveAsPdf() {
            const pdfBtn = document.getElementById('pdfBtn');
            pdfBtn.innerText = 'PDF 생성 중...';
            pdfBtn.disabled = true;

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

                // 새 창에서 PDF 다운로드
                alert('PDF 생성이 완료되었습니다.');
                window.open(finalPdfUrl, '_blank');

            } catch (error) {
                console.error('PDF 생성 오류:', error);
                alert('오류가 발생했습니다: ' + error.message);
            } finally {
                pdfBtn.innerText = 'PDF로 저장 (직인 포함)';
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
    </script>
</body>
</html>