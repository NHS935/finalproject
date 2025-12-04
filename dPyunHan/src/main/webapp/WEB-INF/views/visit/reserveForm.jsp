<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../include/headerContents.jsp" %>

<title>방문 차량 예약</title>
<style>
    body { background: #f5f5f5; font-family: Arial, sans-serif; }
    .container { max-width: 800px; margin: 50px auto; padding: 20px; }

    /* 카드 전체 */
    .card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        overflow: hidden; /* 내부 헤더까지 자연스럽게 둥글게 */
        text-align: center;
        padding: 0; /* 헤더와 내용 패딩 개별 조정 */
    }

    /* 카드 헤더 */
    .card-header {
        background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
        color: white;
        font-size: 1.3rem;
        font-weight: 600;
        padding: 20px;
    }

    /* 카드 내용 */
    .card-body {
        padding: 25px 30px;
    }

    .card-body p { margin: 8px 0; line-height: 1.6; font-size: 1em; }
    .card-body span { color: #007bff; font-weight: bold; }

    .btn-primary {
        padding: 10px 25px;
        font-size: 1em;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        background: #007bff;
        color: #fff;
        cursor: pointer;
        transition: 0.3s;
        z-index: 10;
    }
    .btn-primary:hover { background: #0056b3; }

    .button-group { display: flex; justify-content: center; gap: 10px; margin-top: 20px; flex-wrap: wrap; }
    .button-group button { flex: 1; min-width: 140px; }

    /* 모달 */
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); overflow-y: auto; }
    .modal-content { background: #fff; width: 500px; max-width: 90%; margin: 80px auto; padding: 25px 30px; border-radius: 12px; position: relative; }
    .close { position: absolute; right: 15px; top: 10px; font-size: 22px; cursor: pointer; }

    input[type="text"], input[type="datetime-local"] { width: 100%; padding: 8px; margin: 6px 0; border: 1px solid #ccc; border-radius: 5px; }

    .table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    .table th { background-color: #f2f2f2; }
    #historyModal .modal-content { width: 700px; max-width: 95%; }
</style>

<body>
<div class="container">
    <div class="card">
        <!-- 카드 헤더 -->
        <div class="card-header">방문 차량 예약</div>

        <!-- 카드 내용 -->
        <div class="card-body">
            <p>세대별 월 예약 가능 시간은 <span>120시간</span> 입니다.</p>
            <p>매월 1일 사용시간이 초기화 됩니다.</p>
            <hr>
            <p>이번달 방문 예약 가능 주차시간은 <span id="remainingTime">${rmnTime}</span> 시간 남았습니다.</p>
            <p>누적 사용시간 : <span id="accmltTime">${accmltTime}</span>시간</p>

            <div class="button-group">
                <button id="openReserveModalBtn" class="btn-primary">방문 차량 예약하기</button>
                <!-- <button id="openHistoryModalBtn" class="btn-primary">예약 내역 보기</button> -->
            </div>
        </div>
    </div>
</div>

<!-- 예약 모달 -->
<div id="reserveModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h4 style="text-align:center; margin-bottom:10px;">방문 차량 예약</h4>
        <form id="reserveForm" action="${pageContext.request.contextPath}/visit/reserve" method="post">
            <label>차량 번호</label>
            <input type="text" name="vhcleNo" placeholder="예: 12가3456" required>
            <label>입차 시간</label>
            <input type="datetime-local" name="startDt" required>
            <label>출차 시간</label>
            <input type="datetime-local" name="endDt" required>
            <button type="submit" class="btn-primary" style="margin-top:10px;">예약 완료</button>
        </form>
    </div>
</div>

<!-- 예약 내역 모달 -->
<div id="historyModal" class="modal">
    <div class="modal-content">
        <span class="close" id="closeHistoryModal">&times;</span>
        <h4 style="text-align:center; margin-bottom:10px;">방문 차량 예약 내역</h4>
        <div class="card-body p-0">
            <table class="table">
                <thead>
                    <tr>
                        <th>차량번호</th>
                        <th>입차시간</th>
                        <th>출차시간</th>
                        <th>예약일시</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const reserveModal = document.getElementById("reserveModal");
    const historyModal = document.getElementById("historyModal");

    const openReserveBtn = document.getElementById("openReserveModalBtn");
    const openHistoryBtn = document.getElementById("openHistoryModalBtn");

    const closeReserveBtn = reserveModal.querySelector(".close");
    const closeHistoryBtn = document.getElementById("closeHistoryModal");

    const remainingTimeSpan = document.getElementById("remainingTime");
    const accmltTimeSpan = document.getElementById("accmltTime");

    openReserveBtn.onclick = () => reserveModal.style.display = "block";
    closeReserveBtn.onclick = () => reserveModal.style.display = "none";
    openHistoryBtn.onclick = () => historyModal.style.display = "block";
    closeHistoryBtn.onclick = () => historyModal.style.display = "none";

    window.onclick = (e) => {
        if (e.target === reserveModal) reserveModal.style.display = "none";
        if (e.target === historyModal) historyModal.style.display = "none";
    };

    const reserveForm = document.getElementById("reserveForm");
    if (reserveForm) {
        reserveForm.onsubmit = function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            fetch(this.action, { method: 'POST', body: formData })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (remainingTimeSpan) remainingTimeSpan.textContent = data.remainingTime + " 시간";
                    if (accmltTimeSpan) accmltTimeSpan.textContent = data.accmltTime + " 시간";
                    alert("예약이 완료되었습니다!");
                    reserveModal.style.display = "none";
                } else {
                    alert(data.message || "예약에 실패했습니다. 다시 시도해주세요.");
                }
            })
            .catch(err => {
                console.error(err);
                alert("예약 처리 중 오류가 발생했습니다.");
            });
        };
    }
});
</script>

<%@ include file="../include/footerContents.jsp" %>
