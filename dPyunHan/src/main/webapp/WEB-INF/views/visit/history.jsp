<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../include/headerContents.jsp"%>

<title>방문 차량 예약 내역</title>

<style>
/* 컨테이너 & 카드 */
.modern-wrapper { max-width: 900px; margin: 50px auto; padding: 0 1rem; }
.modern-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 2rem;
}

/* 헤더 */
.modern-card-header {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    padding: 1rem 1.5rem;
    color: white;
    font-size: 1.2rem;
    font-weight: 700;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* 필터 */
.filter-row { display: flex; align-items: center; gap: 0.5rem; padding: 1rem; flex-wrap: wrap; background: #f8f9fa; }
.filter-row label { font-weight: 600; font-size: 0.9rem; }
.filter-row input[type="month"] { padding: 0.4rem 0.6rem; border-radius: 6px; border: 1px solid #ccc; }
.filter-row button { padding: 0.5rem 1rem; border-radius: 6px; border: none; background: #648ca4; color: white; font-weight: 600; cursor: pointer; }

/* 테이블 */
.modern-table-wrapper { overflow-x: auto; }
.modern-table { width: 100%; border-collapse: collapse; }
.modern-table th, .modern-table td { padding: 0.8rem 1rem; text-align: center; border-bottom: 1px solid #eee; }
.modern-table th { background: #f2f2f2; font-weight: 600; color: #495057; }

/* 행 hover */
.modern-table tbody tr:hover { background: #f8f9fa; cursor: pointer; }

/* 상세 모달 */
.modal .modal-dialog { max-width: 700px; }
.modal .modal-content { border-radius: 12px; }
.modal-header { background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%); color: white; }
.modal-title { font-weight: 600; }
.modal-body .field { margin-bottom: 1rem; }
.field-label { font-weight: 600; color: #495057; margin-bottom: 0.3rem; }
.field-value { background: #f8f9fa; padding: 0.5rem 0.8rem; border-radius: 6px; border: 1px solid #e0e0e0; font-size: 0.95rem; }

</style>

<div class="modern-wrapper">
    <div class="modern-card">
        <!-- 카드 헤더 -->
        <div class="modern-card-header">
            방문 차량 예약 내역
        </div>

     <!-- 월 선택 폼 -->
<form method="get" action="${pageContext.request.contextPath}/visit/history" style="text-align:center;  margin-top:20px; margin-bottom:20px;">
    <label for="month">조회할 월:</label>
    <input type="month" id="month" name="month" value="${param.month != null ? param.month : ''}" required
           style="padding:0.5rem 0.8rem; border:1px solid #dee2e6; border-radius:6px; font-size:0.95rem;">
    <button type="submit" style="padding:0.55rem 1.2rem; background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
            color:white; border:none; border-radius:6px; cursor:pointer; font-weight:600; transition:0.3s;">
        조회
    </button>
</form>

        <!-- 테이블 -->
        <div class="modern-table-wrapper">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>차량번호</th>
                        <th>입차시간</th>
                        <th>출차시간</th>
                        <th>예약일시</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="visit" items="${history}">
                        <tr onclick="openDetailModal('${visit.vhcleNo}', '${visit.parkngBeginDt}', '${visit.parkngEndDt}', '${visit.visitReqstDt}')">
                            <td>${visit.vhcleNo}</td>
                            <td><fmt:formatDate value="${visit.parkngBeginDt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td><fmt:formatDate value="${visit.parkngEndDt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td><fmt:formatDate value="${visit.visitReqstDt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty history}">
                        <tr><td colspan="4">등록된 예약 내역이 없습니다.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 상세보기 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">예약 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <div class="field-label">차량번호</div>
                    <div class="field-value" id="modalVhcleNo"></div>
                </div>
                <div class="field">
                    <div class="field-label">입차시간</div>
                    <div class="field-value" id="modalStartDt"></div>
                </div>
                <div class="field">
                    <div class="field-label">출차시간</div>
                    <div class="field-value" id="modalEndDt"></div>
                </div>
                <div class="field">
                    <div class="field-label">예약일시</div>
                    <div class="field-value" id="modalReqDt"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function openDetailModal(vhcleNo, startDt, endDt, reqDt){
    document.getElementById("modalVhcleNo").textContent = vhcleNo;
    document.getElementById("modalStartDt").textContent = startDt;
    document.getElementById("modalEndDt").textContent = endDt;
    document.getElementById("modalReqDt").textContent = reqDt;
    new bootstrap.Modal(document.getElementById('detailModal')).show();
}
</script>

<%@ include file="../include/footerContents.jsp"%>
