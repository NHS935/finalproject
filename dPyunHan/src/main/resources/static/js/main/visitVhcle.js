// visitVhcle.js 전체 코드

// ------------------------------
// 전역 변수 및 설정
// ------------------------------
// 💡 24시간을 모두 포함하도록 TIME_SLOTS_DATA 변경 (01시부터 23시까지 1시간 간격 시작)
const TIME_SLOTS_DATA = [];
for (let h = 1; h <= 23; h++) {
    const startHour = String(h).padStart(2, '0');
    const endHour = String(h % 24 + 1).padStart(2, '0');
    TIME_SLOTS_DATA.push({
        time: `${startHour}:00`, 
        remain: 24, 
        endTime: `${endHour}:00`
    });
}
const MAX_END_TIME = "24:00"; 

let currentDate = new Date(); 
let selectedDate = null;      
let selectedStartTime = null; 
let selectedEndTime = null;   


// ------------------------------
// 공통: 남은시간/누적시간 갱신 함수 (기존 함수 유지)
// ------------------------------
function updateRemainAccmltTime() {
    fetch(`${prc}/visit/reserveData`)
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                document.getElementById("remainingTime").textContent = data.remainingTime + " 시간";
                document.getElementById("accmltTime").textContent = data.accmltTime + " 시간";
            }
        })
        .catch(err => console.error("시간 갱신 오류:", err));
}

// ------------------------------
// 캘린더 및 시간 슬롯 렌더링 함수
// ------------------------------

// 1. 날짜 버튼 생성 및 주 이동 (유지)
function renderDateButtons(startDate) {
    const dateButtonsContainer = document.getElementById("dateButtons");
    const monthYearDisplay = document.getElementById("currentMonthYear");
    
    if (!dateButtonsContainer || !monthYearDisplay) return;

    dateButtonsContainer.innerHTML = '';
    
    const startOfWeek = new Date(startDate);
    startOfWeek.setDate(startDate.getDate() - startDate.getDay()); 

    monthYearDisplay.textContent = `${startOfWeek.getFullYear()}년 ${startOfWeek.getMonth() + 1}월`;

    for (let i = 0; i < 7; i++) {
        const date = new Date(startOfWeek);
        date.setDate(startOfWeek.getDate() + i);
        
        const dayOfMonth = date.getDate();
        const dateString = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(dayOfMonth).padStart(2, '0')}`;
        
        const isToday = date.toDateString() === new Date().toDateString();

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = `btn btn-outline-secondary date-btn w-100 ${isToday ? 'current-day' : ''}`;
        btn.textContent = dayOfMonth;
        btn.setAttribute('data-date', dateString);
        
        if (selectedDate === null && isToday) {
            selectedDate = dateString;
            btn.classList.add('active');
            renderTimeSlots();
        }
        
        btn.addEventListener('click', function() {
            dateButtonsContainer.querySelectorAll('.date-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            selectedDate = dateString;
            renderTimeSlots(); 
        });
        
        dateButtonsContainer.appendChild(btn);
    }
    
    if (selectedDate === null && dateButtonsContainer.firstElementChild) {
         dateButtonsContainer.firstElementChild.click();
    }
}

// 2. 시작 시간 버튼 생성 및 이벤트 설정 (💡 텍스트 표시 방식 변경)
function renderTimeSlots() {
    const timeSlotsContainer = document.getElementById("timeSlots");
    if (!timeSlotsContainer) return;
    
    timeSlotsContainer.innerHTML = '';
    selectedStartTime = null; 
    
    let isTimeSelected = false;

    TIME_SLOTS_DATA.forEach(slot => {
        const btn = document.createElement('button');
        btn.type = 'button';
        // 💡 text-center 클래스를 추가하여 중앙 정렬 (필요하다면)
        btn.className = 'list-group-item list-group-item-action text-center time-slot-btn'; 
        
        // 💡 텍스트를 시작 시간 (slot.time)만 표시하도록 변경
        btn.innerHTML = slot.time;
        
        btn.setAttribute('data-time', slot.time);

        // 첫 번째 슬롯을 기본 선택
        if (selectedStartTime === null && !isTimeSelected) {
            selectedStartTime = slot.time;
            btn.classList.add('active');
            isTimeSelected = true;
        }

        btn.addEventListener('click', function() {
            timeSlotsContainer.querySelectorAll('.time-slot-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            selectedStartTime = slot.time;
            renderEndTimeSlots(selectedStartTime); 
        });

        timeSlotsContainer.appendChild(btn);
    });
    
    if (selectedStartTime) {
        renderEndTimeSlots(selectedStartTime);
    }
}

// 3. 끝나는 시간 버튼 생성 및 이벤트 설정 (유지)
function renderEndTimeSlots(startTime) {
    const endTimeSlotsContainer = document.getElementById("endTimeSlots");
    if (!endTimeSlotsContainer) return;
    
    endTimeSlotsContainer.innerHTML = '';
    selectedEndTime = null; 

    let isEndTimeSelected = false;
    
    const startHour = parseInt(startTime.split(':')[0]);
    
    for (let h = startHour + 1; h <= 24; h++) {
        const endTime = (h === 24) ? '24:00' : String(h).padStart(2, '0') + ':00';
        
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'list-group-item list-group-item-action';
        btn.textContent = endTime;
        btn.setAttribute('data-endtime', endTime);

        if (selectedEndTime === null && !isEndTimeSelected) {
            selectedEndTime = endTime;
            btn.classList.add('active');
            isEndTimeSelected = true;
        }

        btn.addEventListener('click', function() {
            endTimeSlotsContainer.querySelectorAll('button').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            selectedEndTime = endTime;
        });

        endTimeSlotsContainer.appendChild(btn);
    }
}


// ------------------------------
// DOMContentLoaded
// ------------------------------
document.addEventListener("DOMContentLoaded", function() {

    const reserveForm = document.getElementById("reserveForm");
    const reserveModalEl = document.getElementById("reserveModal");
    const reserveModal = reserveModalEl ? bootstrap.Modal.getOrCreateInstance(reserveModalEl) : null;
    const prevWeekBtn = document.getElementById('prevWeekBtn');
    const nextWeekBtn = document.getElementById('nextWeekBtn');
    
    // ------------------------------
    // 초기화 및 데이터 로드
    // ------------------------------
    updateRemainAccmltTime();
    renderDateButtons(currentDate); 
    
    // ------------------------------
    // 이벤트 리스너: 날짜 이동 버튼 (유지)
    // ------------------------------
    if (prevWeekBtn) {
        prevWeekBtn.addEventListener('click', () => {
            currentDate.setDate(currentDate.getDate() - 7);
            renderDateButtons(currentDate);
        });
    }

    if (nextWeekBtn) {
        nextWeekBtn.addEventListener('click', () => {
            currentDate.setDate(currentDate.getDate() + 7);
            renderDateButtons(currentDate);
        });
    }

    // ------------------------------
    // 🔥 예약 폼 제출 (유지)
    // ------------------------------
    if (reserveForm) {
        reserveForm.onsubmit = function(e) {
            e.preventDefault();

            if (!selectedDate || !selectedStartTime || !selectedEndTime) {
                Swal.fire("경고", "예약 날짜, 시작 시간, 끝나는 시간을 모두 선택해주세요.", "warning");
                return;
            }

            document.getElementById('selectedDateInput').value = selectedDate; 
            document.getElementById('selectedStartTimeInput').value = selectedStartTime;
            document.getElementById('selectedEndTimeInput').value = selectedEndTime; 

            const formData = new FormData(this);
            
            for (let pair of formData.entries()) {
                console.log(pair[0] + ': ' + pair[1]);
            }

            fetch(`${prc}/visit/reserve`, {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {

                    Swal.fire({
                        icon: "success",
                        title: "예약이 완료되었습니다!",
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        updateRemainAccmltTime();

                        if (reserveModal) {
                            reserveModal.hide();
                        }
                        reserveForm.reset();
                        
                        selectedDate = null;
                        selectedStartTime = null;
                        selectedEndTime = null;
                        
                        currentDate = new Date(); 
                        renderDateButtons(currentDate); 
                    });

                } else {
                    Swal.fire({
                        icon: "error",
                        title: "예약 실패",
                        text: data.message || "예약 처리 중 오류가 발생했습니다."
                    });
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire({
                    icon: "error",
                    title: "서버 오류",
                    text: "잠시 후 다시 시도해주세요."
                });
            });
        };
    }
    // ------------------------------
    // URL 파라미터로 모달 자동오픈 (유지)
    // ------------------------------
    const params = new URLSearchParams(window.location.search);
    const open = params.get("open");

    if (open === "visitVhcle") {
        if (reserveModal) {
            reserveModal.show();
        }

        const url = new URL(window.location.href);
        url.searchParams.delete("open");
        window.history.replaceState({}, "", url.toString());
    }
});