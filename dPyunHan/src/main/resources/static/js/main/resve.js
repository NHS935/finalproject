const $qs = (sel, root = document) => root.querySelector(sel);
const $qsa = (sel, root = document) => Array.from(root.querySelectorAll(sel));

function showModal(id) {
    const el = document.getElementById(id);
    if (!el) return;
    if (window.bootstrap && bootstrap.Modal) {
        const inst = bootstrap.Modal.getOrCreateInstance(el);
        inst.show();
    } else {
        el.classList.add('show');
        el.style.display = 'block';
        el.removeAttribute('aria-hidden');
        el.setAttribute('aria-modal', 'true');
        document.body.classList.add('modal-open');
        if (!document.querySelector('.modal-backdrop')) {
            const bd = document.createElement('div');
            bd.className = 'modal-backdrop show';
            document.body.appendChild(bd);
        }
    }
}
function hideModal(id) {
    const el = document.getElementById(id);
    if (!el) return;
    if (window.bootstrap && bootstrap.Modal) {
        const inst = bootstrap.Modal.getOrCreateInstance(el);
        inst.hide();
    } else {
        el.classList.remove('show');
        el.style.display = 'none';
        el.setAttribute('aria-hidden', 'true');
        el.removeAttribute('aria-modal');
        document.body.classList.remove('modal-open');
        const bd = document.querySelector('.modal-backdrop');
        if (bd) bd.remove();
    }
}
/* jQuery
$(document).on("change", "#resveDt", function() {
    checkAvailability();
});
*/

document.addEventListener('click', function(e) {
    const card = e.target.closest('.js-resve-card');
    if (!card) return;

    // stretched-link나 내부 링크 클릭 시 페이지 이동 막음
    const a = e.target.closest('a');
    if (a) e.preventDefault();

    const btn = card.querySelector('.open-resve-btn');
    if (btn) btn.click();
});

document.addEventListener("change", function(e) {
    if (e.target && e.target.matches("#resveDt")) {
        checkAvailability();
    }
});

//예약 가능 시간 조회
function checkAvailability() {
    const cmmntySn = currentCmmntySn;
    const dateStr = document.getElementById("resveDt").value;
    const container = document.getElementById("timeContainer");

    if (!dateStr) {
        container.innerHTML = "<p style='color:red;'>날짜를 선택하세요.</p>";
        return;
    }

    fetch(`/resve/resveAvailable?cmmntySn=${cmmntySn}&resveDt=${dateStr}`)
        .then(res => {
            if (!res.ok) throw new Error("서버 응답 오류: " + res.status);
            return res.json();
        })
        .then(data => {
            container.innerHTML = "";
            if (!data || data.length == 0) {
                container.innerHTML = "<p style='color:red;'>예약 가능한 시간이 없습니다.</p>";
                return;
            }
            
            const today = new Date();
            const todayStr = today.toISOString().split("T")[0];
            const nowHour = today.getHours();

            // 시간대별 잔여 인원 표시
            data.forEach(item => {
                const time = Number(item.resveTime ?? 0);
                const remain = Number(item.resveNmpr ?? 0);
                const start = String(time).padStart(2, "0") + ":00";
                const end = String(time + 1).padStart(2, "0") + ":00";

                const div = document.createElement("div");
                div.className = "time-slot";
                div.textContent = `${start} ~ ${end} (잔여: ${remain}명)`;
                
                // 현재 시간 필터링(오늘 날짜일 때)
                if (dateStr === todayStr && time <= nowHour) {
                    div.classList.add("disabled");
                    container.appendChild(div);
                    return;
                }

                if (remain <= 0) {
                    div.classList.add("disabled");
                } else {
                    div.classList.add("active");
                    div.addEventListener("click", () => selectTime(time, div));
                }
                container.appendChild(div);
            });
        })
        .catch(err => {
            console.error("예약 가능 시간 조회 오류:", err);
            container.innerHTML = "<p style='color:red;'>시간 정보를 불러오지 못했습니다.</p>";
        });
}

//시간대 클릭 시 선택 표시
function selectTime(time, element) {
    document.getElementById("resveTime").value = time;
    document.getElementById("beginVwpoint").value = time;
    const maxNmpr = window.maxNmpr;
    const maxTime = window.maxTime;
    const closTimeStr = window.closTimeStr;
    
    let closHour = 0;
    if (closTimeStr && closTimeStr.includes(":")) {
        closHour = parseInt(closTimeStr.split(":")[0]);

        // 자정 처리
        if (closHour === 0) closHour = 24;
    } else {
        console.error("closTimeStr 값이 없습니다 =>", closTimeStr);
        return;
    }

    // 기존 선택 해제
    document.querySelectorAll(".time-slot").forEach(slot => slot.classList.remove("selected"));
    element.classList.add("selected"); // 선택 표시

    // 가운데/오른쪽 컨테이너 초기화
    document.getElementById("nmprContainer").innerHTML = "";
    document.getElementById("lengthContainer").innerHTML = "";
    
    // DOM에서 잔여 인원 데이터 추출
    const remainData = {};
    document.querySelectorAll(".time-slot").forEach(slot => {
        const txt = slot.textContent.replace(/\s+/g, " ").trim();

        const timeMatch = txt.match(/^(\d{2}):/);
        const remainMatch = txt.match(/(\d+)명/);

        if (timeMatch) {
            const t = parseInt(timeMatch[1]);
            const r = remainMatch ? parseInt(remainMatch[1]) : 0;
            remainData[t] = r;
        }
    });

    //인원 선택 버튼
    for (let i = 1; i <= maxNmpr; i++) {
        const btn = document.createElement("div");
        btn.textContent = `${i}명`;
        btn.className = "nmpr-btn";
        btn.dataset.value = i;

        btn.addEventListener("click", () => {
            document.getElementById("resveNmpr").value = i;
            document.querySelectorAll(".nmpr-btn").forEach(b => b.classList.remove("selected"));
            btn.classList.add("selected");

            updateTimeLengthButtons(time, i, remainData, maxTime, closHour);
        });

        document.getElementById("nmprContainer").appendChild(btn);
    }
}

//인원 선택 시 시간 버튼 변화
function updateTimeLengthButtons(startTime, nmpr, remainData, maxTime, closHour) {
    const wrap = document.getElementById("lengthContainer");
    wrap.innerHTML = "";

    const today = new Date();
    const todayStr = today.toISOString().split("T")[0];
    const nowHour = today.getHours();
    const selectedDate = document.getElementById("resveDt").value;
                
    let availableHours = 0;

    for (let i = 1; i <= maxTime; i++) {
        const endTime = startTime + i;
        if (endTime > closHour) break; // 영업시간 초과

        let valid = true;
        for (let h = startTime; h < endTime; h++) {
            
            // 시간대 연속 체크 + 현재 시간 체크
            if (selectedDate === todayStr && h <= nowHour) {
                valid = false;
                break;
            }
                        
            const remain = remainData[h] ?? 0;
            if (remain < nmpr) {
                valid = false;
                break;
            }
        }

        if (valid) {
            const btn = document.createElement("span");
            btn.textContent = `${i}시간`;
            btn.className = "length-btn";
            btn.dataset.value = i;
            btn.addEventListener("click", () => {
                document.querySelectorAll(".length-btn").forEach(b => b.classList.remove("selected"));
                btn.classList.add("selected");
                document.getElementById("resveTime").value = i;
            });
            wrap.appendChild(btn);
            availableHours++;
        } else {
            break; // 이후 시간은 불가
        }
    }

    // 가능한 시간이 하나도 없을 경우
    if (availableHours == 0) {
        wrap.innerHTML = "<p style='color:red;'>선택된 인원의 예약은 마감되었습니다.</p>";
    }

}

//예약하기 버튼
window.currentCmmntySn = ""; // 전역 등록

//예약 버튼 클릭 시 모달 열기
/* jQuery
$(document).on("click", ".open-resve-btn", function() {
    const cmmntySn = $(this).data("cmmntysn");
    $("#modalResveContent").html("<p class='text-center text-muted'>불러오는 중...</p>");
    $("#resveModal").modal("show");
    
    fetch(`/resve/detail?cmmntySn=${cmmntySn}`)
        .then(res => res.json())
        .then(data => {
            const vo = data.cmmntyVO;
            const times = data.timeList;
            window.currentCmmntySn = vo.cmmntySn;
            
            const html = ` ... `;
        $("#modalResveContent").html(html);
        window.maxNmpr = vo.resveMxmmNmpr;
        window.maxTime = vo.resveMxmmTime;
        window.closTimeStr = vo.cmmntyClosVwpoint;
    })
});
*/
document.addEventListener("click", function(e) {
    const btn = e.target.closest(".open-resve-btn");
    if (!btn) return;

    const cmmntySn = btn.dataset.cmmntysn;
    const container = document.getElementById("modalResveContent");
    if (container) container.innerHTML = "<p class='text-center text-muted'>불러오는 중...</p>";
    showModal("resveModal");

    fetch(`/resve/detail?cmmntySn=${cmmntySn}`)
        .then(res => res.json())
        .then(data => {
            const vo = data.cmmntyVO;
            const times = data.timeList;
            window.currentCmmntySn = vo.cmmntySn;

            const html = `
        <h5 class="card-title text-center">${vo.cmmntyNm}</h5>
        <div class="info-row">
            <div><strong>총 수용 인원:</strong> ${vo.totAceptncNmpr} & </div>
            <div><strong>&nbsp운영 시간:</strong> ${vo.cmmntyOpnVwpoint} ~ ${vo.cmmntyClosVwpoint}</div>
        </div>
        <div id="weekCalendar">
            <div class="week-header">
                <div class="week-nav">
                    <button id="prevWeekBtn" class="week-arrow">❮</button>
                    <span class="week-label">지난 주</span>
                </div>
    
                <span id="weekMonthTitle" class="week-title"></span>
    
                <div class="week-nav">
                    <span class="week-label">다음 주</span>
                    <button id="nextWeekBtn" class="week-arrow">❯</button>
                </div>
            </div>

            <div id="weekDates" class="week-dates"></div><br>

            <input type="hidden" id="resveDt" name="resveDt">
        </div>
        <div class="resve-grid">
            <div class="grid-left">
                <h6>시간대 선택</h6>
                <div id="timeContainer"></div>
            </div>

            <div class="grid-center">
                <h6>예약 인원</h6>
                <div id="nmprContainer"></div>
            </div>

            <div class="grid-right">
                <h6>예약 시간</h6>
                <div id="lengthContainer"></div>
            </div>
        </div>
        <form id="resveForm" action="/resve/resve" method="post">
            <input type="hidden" id="cmmntySn" name="cmmntySn" value="${vo.cmmntySn}">
            <input type="hidden" id="resveTime" name="resveTime">
            <input type="hidden" id="beginVwpoint" name="beginVwpoint">
            <input type="hidden" id="resveNmpr" name="resveNmpr">
        </form>
    `;
            if (container) container.innerHTML = html;

            // 전역 파라미터 설정
            window.maxNmpr = vo.resveMxmmNmpr;
            window.maxTime = vo.resveMxmmTime;
            window.closTimeStr = vo.cmmntyClosVwpoint;
            
            // 주자 요일
            initWeekCalendar();
        })
        .catch(err => {
            console.error("불러오기 실패:", err);
            if (container) container.innerHTML = "<p class='text-danger text-center'>해당 시설 정보를 불러오지 못했습니다.</p>";
        });
});

function submitReservation() {
    const data = {
        cmmntySn: window.currentCmmntySn || (document.getElementById("cmmntySn")?.value ?? ""),
        resveTime: document.getElementById("resveTime")?.value ?? "",
        beginVwpoint: document.getElementById("beginVwpoint")?.value ?? "",
        resveNmpr: document.getElementById("resveNmpr")?.value ?? "",
        resveDt: document.getElementById("resveDt")?.value ?? ""
    };

    if (!data.resveDt || !data.beginVwpoint || !data.resveNmpr || !data.resveTime) {
        Swal.fire("입력 오류", "모든 예약 정보를 선택해주세요.", "warning");
        return;
    }

    fetch("/resve/resve", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
        .then(res => {
            if (!res.ok) throw new Error("예약 실패");
            return res.text();
        })
        .then(() => {
            Swal.fire({
                icon: "success",
                title: "예약이 완료되었습니다!",
                showConfirmButton: false,
                timer: 1500
            });
            hideModal("resveModal");
        })
        .catch(err => {
            console.error(err);
            Swal.fire("오류", "예약 처리 중 문제가 발생했습니다.", "error");
        });
}

// --------- 주차 달력 로직 ---------

let currentWeekStart = getWeekStart(new Date()); // 이번 주 시작 날짜

function getWeekStart(date) {
    const d = new Date(date);
    const day = d.getDay(); // 0=일요일
    d.setDate(d.getDate() - day);
    return d;
}

function renderWeekHeader() {
    const monthCount = {};

    for (let i = 0; i < 7; i++) {
        const d = new Date(currentWeekStart);
        d.setDate(currentWeekStart.getDate() + i);

        const year = d.getFullYear();
        const month = d.getMonth() + 1;
        const key = `${year}-${month}`;

        monthCount[key] = (monthCount[key] || 0) + 1;
    }

    let best = null;
    let bestCount = 0;

    for (const key in monthCount) {
        if (monthCount[key] > bestCount) {
            best = key;
            bestCount = monthCount[key];
        }
    }

    const [year, month] = best.split("-");
    document.getElementById("weekMonthTitle").innerText = `${year}년 ${month}월`;
}

function renderWeekDates() {
    const wrap = document.getElementById("weekDates");
    wrap.innerHTML = "";
    
    const days = ["일", "월", "화", "수", "목", "금", "토"];
    
    const today = new Date();
    today.setHours(0,0,0,0);

    for (let i = 0; i < 7; i++) {
        const d = new Date(currentWeekStart);
        d.setDate(currentWeekStart.getDate() + i);

        // 하나의 박스
        const box = document.createElement("div");
        box.className = "day-box";

        // 요일
        const dayDiv = document.createElement("div");
        dayDiv.className = "day-label";
        dayDiv.textContent = days[i];

        // 날짜
        const dateBtn = document.createElement("button");
        dateBtn.className = "week-date-btn";
        dateBtn.textContent = d.getDate();
        dateBtn.dataset.value = d.toISOString().split("T")[0];

        // 과거일 비활성화
        if (d < today) {
            dateBtn.disabled = true;
            dateBtn.style.opacity = "0.4";
        }

        dateBtn.addEventListener("click", () => {
            document.querySelectorAll(".week-date-btn").forEach(b => b.classList.remove("selected"));
            dateBtn.classList.add("selected");
            document.getElementById("resveDt").value = dateBtn.dataset.value;
            checkAvailability();
        });

        box.appendChild(dayDiv);
        box.appendChild(dateBtn);
        wrap.appendChild(box);
    }
}

// 주자 달력 화살표
document.addEventListener("click", function (e) {
    if (e.target.id === "prevWeekBtn") {
        currentWeekStart.setDate(currentWeekStart.getDate() - 7);
        renderWeekHeader();
        renderWeekDates();
    }
    if (e.target.id === "nextWeekBtn") {
        currentWeekStart.setDate(currentWeekStart.getDate() + 7);
        renderWeekHeader();
        renderWeekDates();
    }
});

// --------- 주차 달력 로직 ---------

// 모달이 열릴 때 자동 렌더링
function initWeekCalendar() {
    currentWeekStart = getWeekStart(new Date());
    renderWeekHeader();
    renderWeekDates();
}


//내 예약현황 보기 버튼 클릭 시 모달 열기
let resveData = [];
/* jQuery
$(document).on("click", ".open-resvember-btn", function() {
    $("#resveMberModal").modal("show");
 
    fetch(`/resve/resveMber`)
        .then(res => res.json())
        .then(data => {
            resveData = data.resveVOList;
            renderTab("all");
        })
        .catch(err => {
            console.log("예약 내역 불러오기 실패: ", err);
            $("resveTabBody").html("<tr><td colspan='6' class='text-danger'>내 예약 내역 불러오는 데 실패했습니다.</td></tr>");
        });
});
*/
document.addEventListener("click", function(e) {
    const btn = e.target.closest(".open-resvember-btn");
    if (!btn) return;

    showModal("resveMberModal");

    fetch(`/resve/resveMber`)
        .then(res => res.json())
        .then(data => {
            resveData = data.resveVOList;
            renderTab("all");
        })
        .catch(err => {
            console.log("예약 내역 불러오기 실패: ", err);
            const tbody = document.getElementById("resveTabBody");
            if (tbody) tbody.innerHTML = "<tr><td colspan='6' class='text-danger'>내 예약 내역 불러오는 데 실패했습니다.</td></tr>";
        });
});
/* jQuery
$(document).on("click", "#resveTabs .nav-link", function() {
    const tab = $(this).data("tab");
    $("#resveTabs .nav-link").removeClass("active");
    $(this).addClass("active");
    renderTab(tab);
});
*/
document.addEventListener("click", function(e) {
    const a = e.target.closest("#resveTabs .nav-link");
    if (!a) return;
    const tab = a.dataset.tab;
    $qsa("#resveTabs .nav-link").forEach(x => x.classList.remove("active"));
    a.classList.add("active");
    renderTab(tab);
});

//탭 렌더링 함수
function renderTab(tabType) {
    const cmmntySn = { 1: "헬스장", 2: "사우나", 3: "골프장", 4: "탁구장", 5: "독서실", 6:"수영장", 7:"당구장", 8:"테니스장", 9:"세미나실" };
    const resveSttus = { 1: "방문 예정", 2: "취소" };
    const tbody = document.getElementById("resveTabBody");
    if (!tbody) return;
    tbody.innerHTML = "";

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const filtered = resveData.filter(resveVO => {
        const voDate = new Date(resveVO.resveDt);
        voDate.setHours(0, 0, 0, 0);

        if (tabType == "all") return true;
        if (tabType == "plan") return resveVO.resveSttus == 1 && voDate >= today;
        if (tabType == "cancel") return resveVO.resveSttus == 2;
        if (tabType == "success") return resveVO.resveSttus == 1 && voDate < today;
        return false;
    });

    if (filtered.length == 0) {
        const msg = tabType == "plan" ? "방문 예정 내역이 없습니다." : tabType == "cancel" ? "취소 내역이 없습니다." :
            tabType == "success" ? "방문 완료 내역이 없습니다." : "예약 내역이 없습니다.";
        tbody.innerHTML = `<tr><td colspan="6" class="text-muted py-3">${msg}</td></tr>`;
        return;
    }

    filtered.forEach(resveVO => {
        const cmmntyNm = cmmntySn[resveVO.cmmntySn];
        const date = (resveVO.resveDt || "").substring(0, 10);
        const nmpr = `${resveVO.resveNmpr}명`;
        const voDate = new Date(resveVO.resveDt);
        voDate.setHours(0, 0, 0, 0);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        let sttus = "";
        if (resveVO.resveSttus == 2) {
            sttus = "취소";
        } else if (resveVO.resveSttus == 1 && voDate < today) {
            sttus = "방문 완료";
        } else {
            sttus = "방문 예정";
        }

        const startHour = Number(resveVO.beginVwpoint);
        const endHour = startHour + 1;
        const timeStart = String(startHour).padStart(2, "0") + ":00";
        const timeEnd = String(endHour).padStart(2, "0") + ":00";
        tbody.insertAdjacentHTML("beforeend", `
    <tr>
        <td>${resveVO.resveSn}</td>
        <td>${cmmntyNm}</td>
        <td>${date}</td>
        <td>${timeStart} ~ ${timeEnd}</td>
        <td>${nmpr}</td>
        <td>${sttus}</td>
    </tr>
`);
    });

}

//예약 상세 모달 열기
/* jQuery
$(document).on("click", "#resveTabBody tr", function() {
    const resveSn = $(this).find("td:first").text();
    $("#resveMberModal").modal("hide");
    fetch(`/resve/resveMberDetail?resveSn=${resveSn}`)
        .then(res => res.json())
        .then(data => { ... $("#resveMberDetailModal").modal("show") })
});
*/
document.addEventListener("click", function(e) {
    const tr = e.target.closest("#resveTabBody tr");
    if (!tr) return;

    const firstTd = tr.querySelector("td:first-child");
    const resveSn = firstTd ? firstTd.textContent.trim() : "";
    hideModal("resveMberModal");

    fetch(`/resve/resveMberDetail?resveSn=${resveSn}`)
        .then(res => res.json())
        .then(resveVO => {
            const date = (resveVO.resveDt || "").substring(0, 10);
            const nmpr = `${resveVO.resveNmpr}명`;

            const startHour = Number(resveVO.beginVwpoint);
            const endHour = startHour + 1;
            const timeStart = String(startHour).padStart(2, "0") + ":00";
            const timeEnd = String(endHour).padStart(2, "0") + ":00";

            // 날짜 비교용(예약 취소 버튼 관련)
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const resveDate = new Date(resveVO.resveDt);
            resveDate.setHours(0, 0, 0, 0);

            const cmmntySn = {1: "헬스장", 2: "사우나", 3: "골프장", 4: "탁구장", 5: "독서실", 6: "수영장", 7: "당구장", 8: "테니스장", 9: "세미나실"};
            const html = `
        <h5>${cmmntySn[resveVO.cmmntySn] ?? "알수없음"}</h5>
        <p>
            예약일: ${date}<br>
            시간: ${timeStart} ~ ${timeEnd}<br>
            인원: ${nmpr}<br>
            상태: ${resveVO.resveSttus == 2 ? "취소" : resveDate < today ? "방문 완료" : "방문 예정"}
        </p>
    `;
            const body = document.getElementById("modalMberDetailContent");
            if (body) body.innerHTML = html;

            // 버튼 조건부 렌더링
            const footer = document.querySelector("#resveMberDetailModal .modal-footer");
            if (footer) {
                footer.innerHTML = "";
                // 닫기 버튼
                footer.insertAdjacentHTML("beforeend", `<button type="button" class="btn-cancel" data-bs-dismiss="modal">닫기</button>`);
                // 방문 예정이고  오늘 이후일 때만 취소 버튼 표시
                const t0 = new Date(); t0.setHours(0, 0, 0, 0);
                const r0 = new Date(resveVO.resveDt); r0.setHours(0, 0, 0, 0);
                if (resveVO.resveSttus === 1 && r0 >= t0) {
                    footer.insertAdjacentHTML("beforeend", `<button type="button" class="btn-reserve" data-resvesn="${resveVO.resveSn}" id="btn-resve-cancel">예약 취소</button>`);
                }
            }
            showModal("resveMberDetailModal");
        })
        .catch(err => {
            console.error("상세정보 불러오기 실패:", err);
            Swal.fire("오류", "예약 상세 정보를 불러오지 못했습니다.", "error");
        });
});

// 취소 버튼 클릭
document.addEventListener("click", function(e) {
    const btn = e.target.closest("#btn-resve-cancel");
    if (!btn) return;
    const sn = btn.getAttribute("data-resvesn");
    resveCancel(sn);
});

function resveCancel(resveSn) {
    Swal.fire({
        title: "정말 예약을 취소하시겠습니까?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "네, 취소합니다",
        cancelButtonText: "아니오"
    }).then(result => {
        if (!result.isConfirmed) return;

        fetch("/resve/resveCancel", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ resveSn: resveSn })
        })
            .then(res => {
                if (!res.ok) throw new Error("취소 실패");
                return res.json();
            })
            .then(result => {
                if (result === 1) {
                    Swal.fire({
                        icon: "success",
                        title: "예약이 취소되었습니다.",
                        showConfirmButton: false,
                        timer: 1500
                    });
                    hideModal("resveMberDetailModal");
                } else {
                    Swal.fire("실패", "예약 취소에 실패했습니다.", "error");
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire("오류", "예약 취소 처리 중 문제가 발생했습니다.", "error");
            });
    })
}

document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const open = params.get("open");

    if (open === "resveMber") {

        showModal("resveMberModal");

        // 예약내역 로딩
        fetch(`/resve/resveMber`)
            .then(res => res.json())
            .then(data => {
                resveData = data.resveVOList;
                renderTab("all");
            });

        // 모달 띄운 뒤 URL에서 ?open=resveMber 제거
        const url = new URL(window.location.href);
        url.searchParams.delete("open");
        window.history.replaceState({}, "", url.toString());
    }

});