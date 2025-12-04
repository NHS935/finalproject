<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계약서 작성</title>
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function(){
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
            // --- (B) CKEditor 실행 ---
            // <textarea>에는 이미 //< //c:out//>으로 내용이 채워져 있으므로,
            // CKEditor를 실행(replace)하기만 하면 알아서 그 내용을 읽어갑니다.
            const editor =CKEDITOR.replace('editor1', {
                height: '400px',
                allowedContent: true, // HTML 태그 필터링 끄기 (지난번 요청)
                contentsCss: '/css/contract.css',
                // ★★★ 이 한 줄을 추가하세요 ★★★
                security_removeDefaultNotification: true
            });

            document.querySelector("#btnRegister").addEventListener("click", function(){

                const sj = document.querySelector("#sj").value;
                const cn = editor.getData();

                // 유효성 검사
                if(!sj || sj.trim() === "") {
                    alert("제목을 입력하세요.");
                    return;
                }

                if(!cn || cn.trim() === "") {
                    alert("내용을 입력하세요.");
                    return;
                }

                const formData = new FormData();

                document.querySelectorAll(".cntrPost").forEach(elem => {
                    if (elem.id === "editor1") {
                        formData.append(elem.name, editor.getData());
                    } else {
                        formData.append(elem.name, elem.value);
                    }
                });
                // fetch 요청
                fetch("/contract/postContract", {
                    method: "POST",
                    body: formData,
                    headers: {
                        [csrfHeader]: csrfToken
                    }
                })
                    .then(response => {
                        if(!response.ok) {
                            return response.text().then(text => {
                                console.error("서버가 반환한 내용:", text);
                                throw new Error("서버 응답 오류: " + response.status);
                            });
                        }
                        return response.json()
                    })
                    .then(result => {
                        console.log("result:", result);

                        if(result.result > 0) {
                            alert("계약서가 저장되었습니다.");
                            location.href = "/contract/contractlist";
                        } else {
                            alert(result.message || "계약서 저장에 실패했습니다.");
                        }
                    })
                    .catch(error => {
                        console.error("error:", error);
                        alert("Fetch 요청 오류 발생: "+ error.message);
                    });
            });

            // 취소 버튼
            document.querySelector("#btnCancel").addEventListener("click", function(){
                if(confirm("작성을 취소하시겠습니까?")) {
                    history.back();
                }
            });



        });
    </script>
    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
        .container { max-width: 900px; margin: 0 auto; }
        .approval-table { width: 500px; border-collapse: collapse; margin-bottom: 30px; table-layout: fixed; }
        .approval-table th, .approval-table td { border: 1px solid #ccc; padding: 10px; text-align: center; height: 50px; }
        .approval-table th { background-color: #f4f4f4; width: 20%; }
        .approver-cell { background-color: #fafafa; }
        .status-approved { color: blue; font-weight: bold; }
        .status-pending { color: #888; }
        .btn { padding: 10px 15px; background: #007bff; color: white; border: none; cursor: pointer; }
        .cke_notification {
            display: none !important;
        }
    </style>
</head>
<%@ include file="../include/header.jsp" %>
<body>
<c:set var="docTitle" value="계약서 작성" />
<div class="container">
    <div class="card card-primary">
        <div class="card-header">
            <h2>${docTitle}</h2>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <div class="form-group">
                <label for="sj">계약서 제목</label>
                <input type="text" class="form-control cntrPost" id="sj" name="title" placeholder="제목을 입력하세요">
            </div>
            <div class="form-group">
                <label for="editor1">내용</label>
                <textarea class="form-control cntrPost" name="content" id="editor1">
                <c:out value="${mainContentHtml}" />
                </textarea>
            </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer" style="margin-top: 10px;">
            <button type="button" id="btnRegister" class="btn btn-primary">저장</button>
            <button type="button" id="btnCancel" class="btn btn-secondary">취소</button>
        </div>
    </div>
</div>
</body>
<%@ include file="../include/footer.jsp" %>
</html>