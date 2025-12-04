<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../include/header.jsp" %>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
/* 카드 공통 */
.card-body {
    padding: 0.5rem !important;
    font-size: 0.85rem !important;
}

.card {
    border-radius: 1.2rem !important;
    overflow: hidden !important;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

/* 업로드 박스 */
.upload-box {
    background-color: #f9f9f9;
    border: 1px solid #eee;
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 6px;
}

.upload-box input[type="file"] {
    padding: 6px;
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 4px;
}

/* 버튼 */
.btn-upload {
    background-color: #007bff;
    color: white;
    padding: 6px 12px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
}
.btn-upload:hover {
    background-color: #0056b3;
}

.btn-back {
    background-color: #6c757d;
    color: white;
    padding: 6px 12px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
}
.btn-back:hover {
    background-color: #5a6268;
}

#excelPreviewArea {
    max-height: 400px;
    overflow: auto;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 0;
    margin-top: 10px;
}

#excelPreviewArea table {
    border-collapse: collapse;
    width: 100%;
    font-size: 12px;
}
#excelPreviewArea th, #excelPreviewArea td {
    border: 1px solid #ddd;
    padding: 5px 8px;
    text-align: center;
}
#excelPreviewArea th {
    background-color: #f2f2f2;
}
</style>

<section class="content">
    <div class="container-fluid">
        <div class="row">

            <div class="col-12 connectedSortable ui-sortable">
                <div class="card">

                    <!-- 제목 -->
                    <div class="card-header">
                        <h3 class="card-title mb-0" style="font-size:1rem;">
                            <i class="fas fa-file-import"></i> 관리비 엑셀 업로드
                        </h3>
                    </div>

                    <!-- 내용 -->
                    <div class="card-body">

                        <!-- 업로드 폼 박스 -->
                        <div class="upload-box">
                            <form action="/managect/upload" method="post" enctype="multipart/form-data">
                                <label>첨부 파일</label>
                                <input type="file" name="file" id="excelFile" accept=".xlsx,.xls" required />

                                <button type="submit" class="btn-upload">
                                    <i class="fas fa-file-import"></i> 업로드
                                </button>

                                <button type="button" class="btn-back" onclick="back()">
                                    <i class="fas fa-receipt"></i> 관리비 내역 조회
                                </button>
                            </form>

                            <c:if test="${not empty message}">
                                <p style="color:blue; margin-top:10px;">${message}</p>
                            </c:if>
                        </div>

                        <!-- 미리보기 -->
                        <h5 style="font-size:0.9rem; margin-top:15px;">📄 엑셀 미리보기</h5>

                        <div id="excelPreviewArea">
                            <p style="padding:10px; color:#888;">
                                파일을 선택하면 여기에 미리보기가 표시됩니다.
                            </p>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- FOOTER -->
<%@ include file="../include/footer.jsp" %>
<script>
// 페이지가 모두 로드된 뒤 실행
document.addEventListener("DOMContentLoaded", function () {

    // 파일 입력 요소 가져오기
    var fileInput = document.getElementById("excelFile");
    var previewArea = document.getElementById("excelPreviewArea");

    // 파일 선택되면 동작하는 change 이벤트 등록
    fileInput.addEventListener("change", function (e) {

        // 사용자가 선택한 파일 객체
        var file = e.target.files[0];

        // 파일 선택이 취소됐을 경우
        if (!file) {
            previewArea.innerHTML = "<p style='padding:10px; color:#888;'>파일 선택이 취소되었습니다.</p>";
            return;
        }

        // 브라우저 파일 읽기용 객체 생성
        var reader = new FileReader();

        // 파일을 읽었을 때 실행되는 이벤트
        reader.onload = function (event) {
            try {
                var data = new Uint8Array(event.target.result);

                // SheetJS로 엑셀 파일을 메모리 상에서 읽기
                var workbook = XLSX.read(data, { type: 'array' });

                // 첫 번째 시트 이름 추출
                var firstSheetName = workbook.SheetNames[0];

                // 해당 시트 가져오기
                var worksheet = workbook.Sheets[firstSheetName];

                // 시트를 HTML 테이블 형태로 자동 변환
                var htmlPreview = XLSX.utils.sheet_to_html(worksheet, { editable: false });

                // 변환된 테이블을 미리보기 영역에 삽입
                previewArea.innerHTML = htmlPreview;


                // th(헤더)에서 6번째 이후 모든 열 숨기기
                previewArea.querySelectorAll("table th:nth-child(n+6)")
                    .forEach(th => th.style.display = 'none');

                // td(데이터)도 동일하게 6번째 이후 숨기기
                previewArea.querySelectorAll("table td:nth-child(n+6)")
                    .forEach(td => td.style.display = 'none');

            } catch (error) {
                // 파싱 중 오류 발생 시 사용자에게 메시지 표시
                previewArea.innerHTML =
                    "<p style='color:red;'>엑셀 파일 미리보기에 실패했습니다.</p>";
            }
        };

        //파일 읽기 시작
        reader.readAsArrayBuffer(file);
    });
});

// 관리비 내역 페이지로 이동 버튼
function back() {
    window.location.href = "/managect/managectView";
}
</script>
