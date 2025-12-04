<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<script>
// 페이지 로드 시 날짜 변경 이벤트 등록
document.addEventListener("DOMContentLoaded", () => {
	const dateInput = document.getElementById("resveDate");
	dateInput.addEventListener("change", checkAvailability);
});

//===== 예약 가능 시간 조회 =====
function checkAvailability() {
	const cmmntySn = "${cmmntyVO.cmmntySn}";
	const dateStr = document.getElementById("resveDate").value;
	const container = document.getElementById("timeContainer");

	if (!dateStr) {
		container.innerHTML = "<p style='color:red;'>날짜를 선택하세요.</p>";
		return;
	}

	fetch(`/resve/resveAvailable?cmmntySn=\${cmmntySn}&resveDt=\${dateStr}`)
		.then(res => {
			if (!res.ok) throw new Error("서버 응답 오류: " + res.status);
			return res.json();
		})
		.then(data => {
			container.innerHTML = "";
			if (!data || data.length === 0) {
				container.innerHTML = "<p style='color:red;'>예약 가능한 시간이 없습니다.</p>";
				return;
			}

			// 시간대별 잔여 인원 표시
			data.forEach(item => {
				const time = Number(item.resveTime ?? 0);
				const remain = Number(item.resveNmpr ?? 0);
				const start = String(time).padStart(2, "0") + ":00";
				const end = String(time + 1).padStart(2, "0") + ":00";

				const div = document.createElement("div");
				div.className = "time-slot";
				div.textContent = `\${start} ~ \${end} (잔여: \${remain}명)`;

				if (remain <= 0) {
					div.style.color = "gray";
					div.style.pointerEvents = "none";
				} else {
					div.style.cursor = "pointer";
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

//===== 시간대 클릭 시 선택 표시 =====
function selectTime(time, element) {
	document.getElementById("selectedTime").value = time;
	const maxNmpr = ${cmmntyVO.resveMxmmNmpr};
	const maxTime = ${cmmntyVO.resveMxmmTime};
	const closTimeStr = "${cmmntyVO.cmmntyClosVwpoint}";
	let closHour = parseInt(closTimeStr.split(":")[0]);
	if (closHour === 0) closHour = 24;

	// 기존 선택 해제
	document.querySelectorAll(".time-slot").forEach(slot => slot.style.backgroundColor = "");
	element.style.backgroundColor = "#d6f5d6"; // 선택 표시

	const optionContainer = document.getElementById("optionContainer");
	optionContainer.innerHTML = "";

	// DOM에서 잔여 인원 데이터 추출
	const remainData = {};
	document.querySelectorAll(".time-slot").forEach(slot => {
		const timeMatch = slot.textContent.match(/^(\d{2}):/);
		const remainMatch = slot.textContent.match(/\(잔여: (\d+)명\)/);
		if (timeMatch) remainData[parseInt(timeMatch[1])] = remainMatch ? parseInt(remainMatch[1]) : 0;
	});

	//updateTimeLengthButtons함수를 부르기 때문에
	// (1) 인원 선택 먼저 생성
	const nmprLabel = document.createElement("div");
	nmprLabel.textContent = "예약 인원 선택:";
	optionContainer.appendChild(nmprLabel);

	const nmprWrap = document.createElement("div");
	optionContainer.appendChild(nmprWrap);
	
	// (2) 시간 선택 아래쪽에 추가
	const timeLabelDiv = document.createElement("div");
	timeLabelDiv.textContent = "예약 시간 선택:";
	optionContainer.appendChild(timeLabelDiv);

	const lengthWrap = document.createElement("div");
	lengthWrap.id = "lengthWrap";
	optionContainer.appendChild(lengthWrap);
	
	//인원 선택 버튼
	for (let i = 1; i <= maxNmpr; i++) {
		const btn = document.createElement("span");
		btn.textContent = `\${i}명`;
		btn.className = "nmpr-btn";
		btn.dataset.value = i;
		btn.addEventListener("click", () => {
			document.getElementById("resveNmprInput").value = i;
			document.querySelectorAll(".nmpr-btn").forEach(b => b.style.backgroundColor = "");
			btn.style.backgroundColor = "#d6f5d6";
			updateTimeLengthButtons(time, i, remainData, maxTime, closHour);					//여기서 시간 선택 함수를 불러와야 하므로 먼저 생성함.
		});
		nmprWrap.appendChild(btn);
	}
}

//인원 선택 시 시간 버튼 변화
function updateTimeLengthButtons(startTime, nmpr, remainData, maxTime, closHour){
	const wrap = document.getElementById("lengthWrap");
	wrap.innerHTML = "";
	
	let availableHours = 0;
	
	for (let i = 1; i <= maxTime; i++) {
		const endTime = startTime + i;
		if (endTime > closHour) break; // 영업시간 초과 금지

		let valid = true;
		for (let h = startTime; h < endTime; h++) {
			const remain = remainData[h] ?? 0;
			if (remain < nmpr) { 
				valid = false;
				break;
			}
		}

		if (valid) {
			const btn = document.createElement("span");
			btn.textContent = `\${i}시간`;
			btn.className = "length-btn";
			btn.dataset.value = i;
			btn.addEventListener("click", () => {
				document.querySelectorAll(".length-btn").forEach(b => b.style.backgroundColor = "");
				btn.style.backgroundColor = "#d6f5d6";
				document.getElementById("resveTimeLengthInput").value = i;
			});
			wrap.appendChild(btn);
			availableHours++;
		} else {
			break; // 이후 시간은 불가
		}
	}

	// 가능한 시간이 하나도 없을 경우
	if (availableHours === 0) {
		wrap.innerHTML = "<p style='color:red;'>선택된 인원의 예약은 마감되었습니다.</p>";
	}

}

//===== 예약하기 버튼 =====
function submitReservation() {
	const date = document.getElementById("resveDate").value;
	const time = document.getElementById("selectedTime").value;
	const nmpr = document.getElementById("resveNmprInput").value;
	const len = document.getElementById("resveTimeLengthInput").value;

	if (!date) return alert("날짜를 선택하세요.");
	if (!time) return alert("예약할 시각을 선택하세요.");
	if (!nmpr) return alert("예약 인원을 선택하세요.");
	if (!len) return alert("예약 시간을 선택하세요.");

	document.getElementById("resveForm").submit();
}
</script>


<!-- ///// content 시작 ///// -->
<h1>예약 페이지</h1>
<h5 class="card-title">${cmmntyVO.cmmntyNm}</h5>
<p class="card-text">
	<strong>총 수용 인원:</strong> ${cmmntyVO.totAceptncNmpr}<br>
	<strong>운영 시간:</strong> ${cmmntyVO.cmmntyOpnVwpoint} ~ ${cmmntyVO.cmmntyClosVwpoint}<br>
	<label>예약 날짜 선택:</label>
	<input type="date" id="resveDate" name="resveDate" required />
	<br><br>
</p>

<form id="resveForm" action="/resve/resve" method="post">
	<input type="hidden" id="cmmntySn" name="cmmntySn" value="${cmmntyVO}">
	<input type="hidden" id="resveTimeLengthInput" name="resveTimeLength">
	<input type="hidden" id="selectedTime" name="selectedTime" />
	<input type="hidden" id="resveNmprInput" name="resveNmpr">
	
	<div id="timeContainer" style="margin-top:10px;"></div>
	<div id="optionContainer" style="margin-top:10px;"></div>

	<br />
	<button type="button" onclick="submitReservation()">예약하기</button>
</form>

<!-- 예약 모달 -->
<div class="modal fade" id="resveModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">예약</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"aria-label="Close"></button>
			</div>
			<div class="modal-body" id="modalContent">
				<p class="text-center text-muted">불러오는 중...</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-bs-dismiss="modal">취소</button>
				<button type="button" id="modalDeleteConfirm" class="btn btn-primary">예약</button>
			</div>
		</div>
	</div>
</div>
<!-- ///// content 끝 ///// -->

<%@ include file="../include/footer.jsp"%>
