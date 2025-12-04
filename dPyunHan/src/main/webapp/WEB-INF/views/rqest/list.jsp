<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/headerContents.jsp" %>

<style>
/* ------------------------------------- */
/* 모던 스타일: 관리비 조회/납부 내역 전용 CSS */
/* ------------------------------------- */

/* 전체 컨테이너 */
.modern-wrapper {
    margin: 1rem auto;
    max-width: 800px;
    padding: 0 0.5rem;
    font-family: 'Noto Sans KR', sans-serif;
    color: #495057;
}

/* 💡 카드 전체: 제목 + 내용 감싸는 컨테이너 */
.modern-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 1rem;
}

/* 💡 카드 헤더 (제목 영역) */
.modern-header {
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    padding: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.modern-title {
    color: white;
    font-size: 1.5rem;
    font-weight: 700;
    margin: 0;
}

/* 조회 폼 */
.modern-query-header {
    background: #f8f9fa;
    padding: 1.5rem;
    border-radius: 8px;
    margin: 1rem 1.5rem 0 1.5rem;
    display: flex;
    align-items: center;
    gap: 15px;
}

.modern-query-header label {
    font-weight: 600;
    white-space: nowrap;
}

.modern-query-header input[type="month"] {
    padding: 0.6rem 0.8rem;
    border: 1px solid #dee2e6;
    border-radius: 6px;
    font-size: 0.95rem;
    flex-grow: 1;
    max-width: 200px;
}

.modern-query-header button {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, #648ca4 0%, #5a7d94 100%);
    color: #fff;
    border: none;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}
.modern-query-header button:hover {
    box-shadow: 0 2px 8px rgba(100, 140, 164, 0.3);
}

/* 카드 리스트 */
.rqest-card-wrapper {
    display: flex;
    flex-direction: column;
    gap: 15px;
    margin: 1rem 1.5rem;
}

/* 개별 관리비 카드 */
.rqest-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    background: white;
    padding: 1.5rem;
    transition: all 0.3s ease;
    position: relative;
}

/* 청구 정보 */
.rqest-info p {
    margin: 4px 0;
    font-size: 0.95rem;
}
.rqest-info strong {
    font-weight: 700;
    color: #343a40;
}

/* 납부 상태 */
.status-paid {
    color: #28a745;
    font-weight: bold;
    padding: 4px 8px;
    border-radius: 4px;
    background: #e6ffed;
}
.status-unpaid {
    color: #dc3545;
    font-weight: bold;
    padding: 4px 8px;
    border-radius: 4px;
    background: #fcebeb;
}

/* 버튼 영역 */
.rqest-action {
    margin-top: 15px;
    padding-top: 10px;
    border-top: 1px solid #f1f3f5;
    display: flex;
    gap: 8px;
}

.payBtn {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: #fff;
    box-shadow: 0 2px 6px rgba(0,123,255,0.3);
}
.payBtn:hover {
    background: #0056b3;
    box-shadow: 0 4px 8px rgba(0,123,255,0.4);
}

.showDetailBtn {
    background: #6c757d;
    color: #fff;
    box-shadow: 0 2px 6px rgba(108,117,125,0.3);
}
.showDetailBtn:hover {
    background: #5a6268;
    box-shadow: 0 4px 8px rgba(108,117,125,0.4);
}

.payBtn, .showDetailBtn {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.2s ease;
}

/* 상세 정보 테이블 */
.detail-wrapper {
    margin-top: 15px;
    padding-top: 15px;
    border-top: 1px dashed #dee2e6;
    display: none;
}

.table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    border-radius: 8px;
    overflow: hidden;
}

.table th, .table td {
    border: none;
    padding: 12px;
    text-align: center;
    font-size: 0.9rem;
}

.table th {
    background-color: #f1f3f5;
    color: #495057;
    font-weight: 600;
}

.table tbody tr:nth-child(even) {
    background-color: #fafbfc;
}
</style>

<script type="text/javascript" src="/js/main/managect.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js" async defer></script>

<div class="modern-wrapper">
    
    <div class="modern-card">
        
        <div class="modern-header">
            <h1 class="modern-title"><i class="fas fa-search-dollar"></i> 관리비 조회</h1>
        </div>
        
        <form action="/rqest/rqest" method="get" class="modern-query-header">
            <label for="ym-input">조회 연월:</label>
            <input type="month" id="ym-input" name="ym" value="${yearMonth}">
            <input type="hidden" name="hshldId" value="${hshldId}" />
            <button type="submit">
                <i class="fas fa-calendar-alt"></i> 조회
            </button>
        </form>

        <div style="padding: 0 1.5rem 1.5rem 1.5rem;">
            <c:if test="${empty rqestList}">
                <div class="rqest-card" style="box-shadow: none; margin-bottom: 0;">
                    <p style="text-align: center; color: #6c757d; margin: 0;">해당 월의 관리비 내역이 없습니다.</p>
                </div>
            </c:if>

            <c:if test="${not empty rqestList}">
                <div class="rqest-card-wrapper">
                    <c:forEach var="rq" items="${rqestList}">
                        <div class="rqest-card" id="rq-${rq.rqestSn}">
                            <div class="rqest-info">
                                <p>청구 연월: <strong>${rq.rqestYm}</strong></p>
                                <p>납부 기한: <strong><fmt:formatDate value="${rq.payTmlmt}" pattern="yyyy-MM-dd"/></strong></p>
                                <p>금액: <strong><fmt:formatNumber value="${rq.managectTotAmount}" pattern="#,###"/>원</strong></p>
                                <p>
                                    납부 상태:
                                    <c:choose>
                                        <c:when test="${rq.paySttus == 0 || rq.paySttus == null}">
                                            <span class="status-unpaid">미납</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-paid">납부완료</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="rqest-action">
                                <c:if test="${rq.paySttus == 0 || rq.paySttus == null}">
                                    <button type="button" class="payBtn" 
                                        data-sn="${rq.rqestSn}"
                                        data-amount="${rq.managectTotAmount}"
                                        data-ym="${rq.rqestYm}">
                                        <i class="fas fa-credit-card"></i> 납부하기
                                    </button>
                                </c:if>
                            </div>
                            <div class="detail-wrapper" id="detail-${rq.rqestSn}" style="display:none;"></div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
        </div>
</div>


<script>
document.addEventListener("DOMContentLoaded", function() {
  
  // 관리비 납부 (PayBtn) 로직
  document.querySelectorAll(".payBtn").forEach(btn => {
    btn.addEventListener("click", async () => {
      const rqestSn = btn.dataset.sn;
      const amount = Number(btn.dataset.amount);
      const ym = btn.dataset.ym;

      try {
        const payment = await PortOne.requestPayment({
          storeId: "store-d68fc086-e239-4a01-9b2c-388081ff1fc4",
          channelKey: "channel-key-9ba8fabc-3d41-41c4-83a2-e61940b47852",
          paymentId: "PAY_" + new Date().getTime(),
          orderName: "관리비 납부 (" + ym + ")",
          totalAmount: amount,
          currency: "KRW",
          payMethod: "CARD",
          customer: { fullName: "세대번호 " + rqestSn, email: "user@example.com", phoneNumber: "01000000000" },
          customData: { rqestSn: rqestSn }
        });

        if (payment.code !== undefined) {
          alert("결제 실패: " + payment.message);
          return;
        }

        const res = await fetch("/rqest/paymentSuccessPortOne", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ paySn: payment.paymentId, rqestSn, payAmount: amount })
        });

        if (res.ok) {
          alert("결제가 완료되었습니다!");
          // 버튼 숨기기
          btn.style.display = 'none'; 
          // 상태 업데이트
          const statusEl = btn.closest(".rqest-card").querySelector(".rqest-info span");
          statusEl.classList.remove("status-unpaid");
          statusEl.classList.add("status-paid");
          statusEl.textContent = "납부완료";
          
        } else {
          alert("서버 검증 중 오류가 발생했습니다.");
        }

      } catch (err) {
        console.error(err);
        alert("결제창 호출 중 오류가 발생했습니다.");
      }
    });
  });

  // 상세보기 (showDetailBtn) 로직은 현재 HTML에서 주석 처리되어 실행되지 않음
  document.querySelectorAll(".showDetailBtn").forEach(btn => {
    btn.addEventListener("click", async function(e) {
      
      e.preventDefault(); 
      e.stopPropagation();

      const rawRqestSn = this.dataset.sn; 
      const rqestSn = Number(rawRqestSn); 

      if (isNaN(rqestSn) || rqestSn === 0) {
          console.error(`[CRITICAL ERROR] 유효하지 않은 RQEST_SN 값 감지: ${rawRqestSn}`);
          alert("청구 번호가 유효하지 않아 상세보기가 불가능합니다.");
          return; 
      }
      
      console.log(`[JS 내부 확인] 읽어온 rqestSn: ${rqestSn}`);
      const detailWrapper = document.getElementById("detail-" + rqestSn);
      const detailUrl = `/rqest/detail?rqestSn=${rqestSn}`;
      
      console.log(`[상세보기 요청] RQEST_SN: ${rqestSn}, URL: ${detailUrl}`); 

      if (detailWrapper.style.display === "block" || detailWrapper.style.display === "BLOCK") {
          detailWrapper.style.display = "none";
          return;
      }
      
      try {
        const res = await fetch(detailUrl);

        if (!res.ok) { 
             console.error(`[AJAX 실패] HTTP 상태 코드: ${res.status}`);
             alert(`상세항목 조회 실패: 서버 오류(${res.status})`);
             return;
        }

        const detailList = await res.json();
        console.log("[AJAX 성공] 수신 데이터:", detailList);

        if (!detailList || detailList.length === 0) {
          detailWrapper.innerHTML = "<p style='text-align: center; color: #6c757d; margin: 0;'>상세항목이 없거나 조회되지 않았습니다.</p>";
          detailWrapper.style.display = "block";
          return;
        }

        let table = '<table class="table">';
        table += '<thead><tr><th>#</th><th>항목명</th><th>금액</th></tr></thead><tbody>';
        detailList.forEach((d, idx) => {
          table += `<tr><td>${idx + 1}</td><td>${d.iemNm}</td><td>${d.rqestAmount}원</td></tr>`;
        });
        table += '</tbody></table>';

        detailWrapper.innerHTML = table;
        detailWrapper.style.display = "block";

      } catch (err) {
        console.error("[최종 에러]", err);
        alert("상세항목 조회 중 JavaScript 오류가 발생했습니다. 콘솔 확인 요망.");
      }
    });
  });
});
</script>

<%@ include file="../include/footerContents.jsp" %>