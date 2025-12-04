(function () {document.addEventListener("DOMContentLoaded", function () {
  const searchForm = document.querySelector(".manage-wrapper form");
  if (!searchForm) return;

  const ymInput   = searchForm.querySelector('input[name="ym"]');
  const hshldEl   = searchForm.querySelector('input[name="hshldId"]');
  const searchBtn = searchForm.querySelector("#searchBtn");
  const resultDiv = document.getElementById("rqestResult");
  if (!resultDiv) return;

  const toYYYYMM  = (v) => (v && v.includes("-")) ? v.replace("-", "") : v;
  const toYYYY_MM = (v) => (String(v).includes("-")) ? v : `${String(v).slice(0,4)}-${String(v).slice(4)}`;

  const hasSwal = typeof window.Swal !== "undefined";
  const Toast = hasSwal
    ? Swal.mixin({
      toast: true, 
      position: "top",
      showConfirmButton: false, 
      timer: 1500, 
      timerProgressBar: true,
      didOpen: (toast) => { toast.style.top = 64 + "px"; toast.style.position = "fixed"; }
    }) : null;

  searchForm.addEventListener("submit", (e) => e.preventDefault());

  // 조회 버튼 클릭
  if (searchBtn) {
    searchBtn.addEventListener("click", (e) => {
      e.preventDefault();
      doSearch(ymInput.value); // 선택한 달 기준 조회
    });
	}

  // =========================
  // 페이지 로드 시 자동 조회 (저번달 + 이번달)
  // =========================
  const today = new Date();
  const month = today.getMonth() + 1;
  const year = today.getFullYear();

  const calcYm = (offset) => {
    let y = year, m = month + offset;
    if (m < 1) { m = 12; y -= 1; }
    if (m > 12) { m = 1; y += 1; }
    return { yyyy: y, mm: String(m).padStart(2, "0"), ymStr: `${y}-${String(m).padStart(2,"0")}`, ymParam: `${y}${String(m).padStart(2,"0")}` };
  }

  const prev = calcYm(-1);   // 저번달
  const curr = calcYm(0);    // 이번달

  // input 기본값을 이번 달로 세팅
  ymInput.value = curr.ymStr;

  // 자동 조회
  doSearchMultiple([prev.ymParam, curr.ymParam]);

  // =========================
  // 목록 조회 (특정 달 하나)
  // =========================
  async function doSearch(ymRaw) {
    const ymParam = toYYYYMM(ymRaw);
    const hshldId = hshldEl?.value ?? "";

    // 로딩
    if (hasSwal) {
      Swal.fire({ title: "조회 중...", didOpen: () => Swal.showLoading(), allowOutsideClick: false, showConfirmButton: false });
    } else {
      resultDiv.innerHTML = "<p>조회 중</p>";
    }

    try {
      const res = await fetch(`/rqest/listAjax?ym=${ymParam}&hshldId=${hshldId}`);
      if (!res.ok) throw new Error("조회 실패");
      const list = await res.json();
      if (hasSwal) Swal.close();

      if (!list || list.length === 0) {
        resultDiv.innerHTML = "<p style='text-align: center;'>해당 월의 관리비 내역이 없습니다.</p>";
        if (Toast) Toast.fire({ icon: "info", title: "데이터 없음" });
        return;
      }

      renderList(list, ymParam);
      if (Toast) Toast.fire({ icon: "success", title: "조회 완료" });

    } catch (err) {
      console.error(err);
      if (hasSwal) Swal.fire({ icon: "error", title: "오류", text: "조회 중 오류가 발생했습니다." });
      else resultDiv.innerHTML = "<p>조회 중 오류가 발생했습니다.</p>";
    }
  }

  // =========================
  // 목록 조회 (여러 달, 배열)
  // =========================
  async function doSearchMultiple(ymParams) {
    if (!ymParams || !ymParams.length) return;

    resultDiv.innerHTML = "<p>조회 중...</p>";

    try {
      const fetches = ymParams.map(ym => fetch(`/rqest/listAjax?ym=${ym}&hshldId=${hshldEl.value}`).then(r => r.json()));
      const results = await Promise.all(fetches);
      const combined = results.flat();
      if (!combined.length) {
        resultDiv.innerHTML = "<p>조회할 관리비 내역이 없습니다.</p>";
        return;
      }
      renderList(combined);
    } catch (err) {
      console.error(err);
      resultDiv.innerHTML = "<p>조회 중 오류가 발생했습니다.</p>";
    }
  }

  // =========================
  // 목록 렌더링, 상세보기/납부 이벤트
  // =========================
  function renderList(list, ymParam) {
    let html = `
      <table class="table table-bordered mt-3">
        <thead>
          <tr><th>월</th><th>금액</th><th>상태</th><th>상세/납부</th></tr>
        </thead>
        <tbody>
    `;

    list.forEach((r, idx) => {
      const rqestSn = r.rqestSn ?? idx;
      const isPaid  = r.paySttus === 1 || r.paySttusNm === "납부완료" || r.status === "납부완료";
      const amountN = Number(r.managectTotAmount ?? r.totalAmount ?? r.rqestAmount ?? r.amount ?? 0);
      const amount  = amountN.toLocaleString();
      const ymTxt   = toYYYY_MM(r.rqestYm ?? r.ym ?? r.yearMonth ?? ymParam);

      html += `
        <tr class="rqest-card" id="rq-${rqestSn}">
          <td>${ymTxt}</td>
          <td>${amount}원</td>
          <td class="rqest-info">
            <span class="${isPaid ? "status-paid" : "status-unpaid"}">${isPaid ? "납부완료" : "미납"}</span>
          </td>
          <td>
            <div class="rqest-action">
              ${isPaid
                ? ""
                : `<button type="button" class="btn btn-sm payBtn" data-sn="${rqestSn}" data-amount="${amountN}" data-ym="${ymTxt}">납부</button>`
              }
              <button type="button" class="btn btn-sm showDetailBtn" data-sn="${rqestSn}">상세</button>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4">
            <div id="detail-${rqestSn}" class="detail-wrapper" style="display:none;"></div>
          </td>
        </tr>
      `;
    });

    html += `</tbody></table>`;
    resultDiv.innerHTML = html;
  }
  // =========================
  // 상세보기/납부 이벤트
  // =========================
  document.addEventListener("click", async (e) => {
    const detailBtn = e.target.closest(".showDetailBtn");
    if (detailBtn) {
      e.preventDefault();
      const rqestSn = detailBtn.dataset.sn;
      const target  = document.getElementById(`detail-${rqestSn}`);
      if (!target) return;

      if (target.style.display === "block") { target.style.display = "none"; return; }

      target.innerHTML = `<p style="padding:6px;">상세항목 불러오는 중...</p>`;
      target.style.display = "block";

      try {
        const res = await fetch(`/rqest/detail?rqestSn=${rqestSn}`);
        if (!res.ok) throw new Error("상세 조회 실패");

        const detailList = await res.json();
        if (!detailList || detailList.length === 0) {
          target.innerHTML = `<p>상세항목이 없습니다.</p>`;
          return;
        }

        let t = `<table class="table table-striped">
					<thead>
						<tr>
							<th style="width: 10%; text-align:center;">#</th>
							<th style="width: 65%; text-align:center;">항목명</th>
							<th style="width: 25%;">금액(원)</th>
						</tr>
					</thead>
				<tbody>`;
        detailList.forEach((d, i) => {
          t += `<tr>
		  			<td style="width: 10%; text-align:center;">${i + 1}</td>
		  			<td style="width: 65%;">${d.iemNm}</td>
					<td style="width: 25%;">${(Number(d.rqestAmount) || 0).toLocaleString()}원</td>
				</tr>`;
        });
        t += `</tbody></table>`;
        target.innerHTML = t;

      } catch (err) {
        console.error(err);
        target.innerHTML = `<p>상세항목 조회 중 오류가 발생했습니다.</p>`;
        if (Toast) Toast.fire({ icon: "error", title: "상세조회 실패" });
      }
      return;
    }

    const payBtn = e.target.closest(".payBtn");
    if (payBtn) {
      e.preventDefault();
      const rqestSn = payBtn.dataset.sn;
      const amount  = Number(payBtn.dataset.amount);
      const ym      = payBtn.dataset.ym;
      const mberNm  = searchForm.querySelector('input[name="mberNm"]')?.value || `세대번호 ${rqestSn}`;
      const email   = searchForm.querySelector('input[name="email"]')?.value || "user@example.com";

      try {
        const payment = await PortOne.requestPayment({
          storeId: "store-d68fc086-e239-4a01-9b2c-388081ff1fc4",
          channelKey: "channel-key-9ba8fabc-3d41-41c4-83a2-e61940b47852",
          paymentId: "PAY_" + new Date().getTime(),
          orderName: `관리비 납부 (${toYYYY_MM(ym)})`,
          totalAmount: amount,
          currency: "KRW",
          payMethod: "CARD",
          customer: { fullName: mberNm , email:email , phoneNumber: "010-0000-0000" },
          customData: { rqestSn }
        });

        if (payment.code !== undefined) {
          if (hasSwal) Swal.fire({ icon: "error", title: "결제 실패", text: payment.message || "결제에 실패했습니다." });
          else alert("결제 실패");
          return;
        }

        if (hasSwal) Swal.fire({ title: "검증 중...", didOpen: () => Swal.showLoading(), allowOutsideClick: false, showConfirmButton: false });

        const res = await fetch("/rqest/paymentSuccessPortOne", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ paySn: payment.paymentId, rqestSn, payAmount: amount })
        });

        if (hasSwal) Swal.close();
        if (!res.ok) {
          if (hasSwal) Swal.fire({ icon: "error", title: "오류", text: "서버 검증 중 오류가 발생했습니다." });
          else alert("서버 검증 오류");
          return;
        }

        if (hasSwal) Swal.fire({ icon: "success", title: "결제 완료", text: "결제가 정상 처리되었습니다." });

        const card = document.getElementById(`rq-${rqestSn}`);
        if (card) {
          card.querySelector(".rqest-action .payBtn")?.remove();
          const statusEl = card.querySelector(".rqest-info span");
          if (statusEl) {
            statusEl.classList.remove("status-unpaid");
            statusEl.classList.add("status-paid");
            statusEl.textContent = "납부완료";
          }
        }

      } catch (err) {
        console.error(err);
        if (hasSwal) Swal.fire({ icon: "error", title: "오류", text: "결제창 호출 중 오류가 발생했습니다." });
        else alert("결제창 호출 오류");
      }
    }
  });
});
})();