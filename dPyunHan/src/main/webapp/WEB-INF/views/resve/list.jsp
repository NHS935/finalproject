<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<script src="/js/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
//예약 모달 내용
// 페이지 로드 시 날짜 변경 이벤트 등록	//jQuery 이벤트 위임(모달 내부 input이 동적으로 생성되어도 항상 동작함.)
$(document).on("change", "#resveDt", function() {
	checkAvailability();
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

	fetch(`/resve/resveAvailable?cmmntySn=\${cmmntySn}&resveDt=\${dateStr}`)
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

//시간대 클릭 시 선택 표시
function selectTime(time, element) {
	document.getElementById("resveTime").value = time;
	document.getElementById("beginVwpoint").value = time;
	const maxNmpr = window.maxNmpr;
    const maxTime = window.maxTime;
    const closTimeStr = window.closTimeStr;
	let closHour = parseInt(closTimeStr.split(":")[0]);
	if (closHour == 0) closHour = 24;

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
			document.getElementById("resveNmpr").value = i;
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

function submitReservation() {
	const date = document.getElementById("resveDt").value;
	const time = document.getElementById("resveTime").value;
	const nmpr = document.getElementById("resveNmpr").value;
	const len = document.getElementById("resveTime").value;

	document.getElementById("resveForm").submit();
}

//예약 버튼 클릭 시 모달 열기
$(document).on("click", ".open-resve-btn", function() {
	const cmmntySn = $(this).data("cmmntysn");
	$("#modalResveContent").html("<p class='text-center text-muted'>불러오는 중...</p>");
	$("#resveModal").modal("show");
	
	fetch(`/resve/detail?cmmntySn=\${cmmntySn}`)
		.then(res => res.json())
		.then(data => {
			const vo = data.cmmntyVO;
	        const times = data.timeList;
	        window.currentCmmntySn = vo.cmmntySn;
	        
			const html = `	
				<h5 class="card-title">\${vo.cmmntyNm}</h5>
				<p class="card-text">
					<strong>총 수용 인원:</strong> \${vo.totAceptncNmpr}<br>
					<strong>운영 시간:</strong> \${vo.cmmntyOpnVwpoint} ~ \${vo.cmmntyClosVwpoint}<br>
					<label>예약 날짜 선택:</label>
					<input type="date" id="resveDt" name="resveDt" required>
				</p>
				<form id="resveForm" action="/resve/resve" method="post">
					<input type="hidden" id="cmmntySn" name="cmmntySn" value="\${vo.cmmntySn}">
					<input type="hidden" id="resveTime" name="resveTime">
					<input type="hidden" id="beginVwpoint" name="beginVwpoint">
					<input type="hidden" id="resveNmpr" name="resveNmpr">
					<div id="timeContainer" style="margin-top:10px;"></div>
					<div id="optionContainer" style="margin-top:10px;"></div>
				</form>
			`;
		$("#modalResveContent").html(html);
		
		//여기서 JS 변수로 설정해둬야 밑의 checkAvailability 등에서 사용 가능
        window.maxNmpr = vo.resveMxmmNmpr;
        window.maxTime = vo.resveMxmmTime;
        window.closTimeStr = vo.cmmntyClosVwpoint;
	})
	.catch(err => {
		console.error("불러오기 실패:", err);
		$("#modalResveContent").html("<p class='text-danger text-center'>해당 시설 정보를 불러오지 못했습니다.</p>");
	});
});

function submitReservation() {
	const data = {
		cmmntySn: window.currentCmmntySn || $("#cmmntySn").val(),
		resveTime: $("#resveTime").val(),
		beginVwpoint: $("#beginVwpoint").val(),
		resveNmpr: $("#resveNmpr").val(),
		resveDt: $("#resveDt").val()
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
		$("#resveModal").modal("hide");
	})
	.catch(err => {
		console.error(err);
		Swal.fire("오류", "예약 처리 중 문제가 발생했습니다.", "error");
	});
}

//내 예약현황 보기 버튼 클릭 시 모달 열기
let resveData = []; // 전체 데이터 캐싱

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

//탭 클릭 시 전환
$(document).on("click", "#resveTabs .nav-link", function() {
	const tab = $(this).data("tab");
	
	// 탭 버튼 상태 변경
	$("#resveTabs .nav-link").removeClass("active");
	$(this).addClass("active");
	
	// 탭 내용 표시
	renderTab(tab);
});

//탭 렌더링 함수
function renderTab(tabType){
	const cmmntySn = {1: "헬스장", 2: "사우나", 3: "골프장", 4: "탁구장", 5: "독서실"};
	const resveSttus = {1: "방문 예정", 2: "취소"};
	const tbody = $("#resveTabBody");
	tbody.empty();

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
		tbody.append(`<tr><td colspan="6" class="text-muted py-3">\${msg}</td></tr>`);
		return;
	}

	filtered.forEach(resveVO => {
		const cmmntyNm = cmmntySn[resveVO.cmmntySn];
		const date = (resveVO.resveDt || "").substring(0, 10);
		const nmpr = `\${resveVO.resveNmpr}명`;
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
		tbody.append(`
			<tr>
				<td>\${resveVO.resveSn}</td>
				<td>\${cmmntyNm}</td>
				<td>\${date}</td>
				<td>\${timeStart} ~ \${timeEnd}</td>
				<td>\${nmpr}</td>
				<td>\${sttus}</td>
			</tr>
		`);
	});

}

//예약 상세 모달 열기
//예약 리스트 클릭 시
$(document).on("click", "#resveTabBody tr", function() {
	const resveSn = $(this).find("td:first").text();

	//첫 번째 모달 닫기
	$("#resveMberModal").modal("hide");

	//상세 정보 로드 후 예약상세모달 열기
	fetch(`/resve/resveMberDetail?resveSn=\${resveSn}`)
		.then(res => res.json())
		.then(data => {
			const resveVO = data;
			const date = (resveVO.resveDt || "").substring(0, 10);
			const nmpr = `\${resveVO.resveNmpr}명`;
			
			const startHour = Number(resveVO.beginVwpoint);
			const endHour = startHour + 1;
			const timeStart = String(startHour).padStart(2, "0") + ":00";
			const timeEnd = String(endHour).padStart(2, "0") + ":00";

			// 날짜 비교용(예약 취소 버튼 관련)
			const today = new Date();
			today.setHours(0, 0, 0, 0);
			const resveDate = new Date(resveVO.resveDt);
			resveDate.setHours(0, 0, 0, 0);

			const html = `
				<h5>\${resveVO.cmmntySn == 1 ? "헬스장" : resveVO.cmmntySn == 2 ? "사우나" : resveVO.cmmntySn == 3 ? "골프장" : resveVO.cmmntySn == 4 ? "탁구장" : "독서실"}</h5>
				<p>
					예약일: \${date}<br>
					시간: \${timeStart} ~ \${timeEnd}<br>
					인원: \${nmpr}<br>
					상태: \${resveVO.resveSttus == 2 ? "취소" : resveDate < today ? "방문 완료" : "방문 예정"}
				</p>
      		`;
		$("#modalMberDetailContent").html(html);

		// 버튼 조건부 렌더링
		const footer = $("#resveMberDetailModal .modal-footer");
		footer.empty(); // 기존 버튼 제거

		// 닫기 버튼은 항상 표시
		footer.append(`<button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>`);

		// (1) 방문 예정이고 (2) 오늘 이후일 때만 취소 버튼 표시
		if (resveVO.resveSttus === 1 && resveDate >= today) {
			footer.append(`<button type="button" class="btn btn-warning" onclick="resveCancel(\${resveVO.resveSn})">예약 취소</button>`);
		}

		$("#resveMberDetailModal").modal("show")
	})
	.catch(err => {
		console.error("상세정보 불러오기 실패:", err);
		Swal.fire("오류", "예약 상세 정보를 불러오지 못했습니다.", "error");
	});
});

function resveCancel(resveSn) {
	Swal.fire({
		title: "정말 예약을 취소하시겠습니까?",
		icon: "warning",
		showCancelButton: true,
		confirmButtonText: "네, 취소합니다",
		cancelButtonText: "아니오"
	}).then(result => {
		if(!result.isConfirmed) return;

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
			if (result === 1){
				Swal.fire({
					icon: "success",
					title: "예약이 취소되었습니다.",
					showConfirmButton: false,
					timer: 1500
				});
				$("#resveMberDetailModal").modal("hide");
			} else{
				Swal.fire("실패", "예약 취소에 실패했습니다.", "error");
			}
		})
		.catch(err => {
			console.error(err);
			Swal.fire("오류", "예약 취소 처리 중 문제가 발생했습니다.", "error");
		});
	})
}
	</script>
	
<h1>예약 페이지</h1>
<div>
	<button type="button" class="btn btn-success open-resvember-btn">내 예약 현황 보기</button>
</div><br>
<div class="row">
	<c:forEach var="cmmntyVO" items="${cmmntyVOList}">
		<div class="col-md-6 mb-3">
			<div class="card h-100 shadow-sm">
				<div class="card-body">
					<h5 class="card-title">${cmmntyVO.cmmntyNm}</h5>
					<p class="card-text">
						<strong>총 수용 인원:</strong> ${cmmntyVO.totAceptncNmpr}<br>
						<strong>운영 시간:</strong> ${cmmntyVO.cmmntyOpnVwpoint} ~ ${cmmntyVO.cmmntyClosVwpoint}<br>
					</p>

					<button type="button" class="btn btn-primary open-resve-btn" data-cmmntysn="${cmmntyVO.cmmntySn}">예약</button>
				</div>
			</div>
		</div>
	</c:forEach>
</div>

<!-- 예약 모달 -->
<div class="modal fade" id="resveModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">예약</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"aria-label="Close">X</button>
			</div>
			<div class="modal-body" id="modalResveContent">
				<p class="text-center text-muted">불러오는 중...</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-bs-dismiss="modal">취소</button>
				<button type="button" class="btn btn-primary" onclick="submitReservation()">예약</button>
			</div>
		</div>
	</div>
</div>

<!-- 예약현황 모달 -->
<div class="modal fade" id="resveMberModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">내 예약 현황</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"aria-label="Close">X</button>
			</div>
			<div class="modal-body" id="modalMberContent">
				<!-- 탭 버튼 -->	
				<ul class="nav nav-pills" id="resveTabs">
					<li class="nav-item"><button class="nav-link active" data-tab="all">전체</button></li>
					<li class="nav-item"><button class="nav-link" data-tab="plan">방문 예정</button></li>
					<li class="nav-item"><button class="nav-link" data-tab="success">방문 완료</button></li>
					<li class="nav-item"><button class="nav-link" data-tab="cancel">취소</button></li>
				</ul>

				<!-- 단일 테이블 (헤더 고정) -->
				<table class="table table-striped align-middle text-center mt-3">
					<thead class="table-dark">
						<tr>
							<th>번호</th>
							<th>커뮤니티시설</th>
							<th>예약 날짜</th>
							<th>예약 시간</th>
							<th>인원 수</th>
							<th>예약 상태</th>
						</tr>
					</thead>
					<tbody id="resveTabBody">
						<tr><td colspan="6" class="text-muted py-3">예약 내역이 없습니다.</td></tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<!-- 예약상세 모달 -->
<div class="modal fade" id="resveMberDetailModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">내 예약 상세</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"aria-label="Close">X</button>
			</div>
			<div class="modal-body" id="modalMberDetailContent">
				<p class="text-center text-muted">불러오는 중...</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
				<button type="button" class="btn btn-warning" onclick="resveCancel()">예약 취소</button>
			</div>
		</div>
	</div>
</div>

<style>
/* 전체 탭 컨테이너 여백 조정 */
#resveTabs {
  gap: 10px;
}

/* 타원형 버튼 스타일 */
#resveTabs .nav-link {
  border-radius: 50px; /* 완전한 타원 */
  padding: 8px 20px;
  background-color: #f1f1f1;
  color: #333;
  font-weight: 500;
  transition: all 0.3s ease;
  border: 1px solid transparent;
}

/* 호버 효과 */
#resveTabs .nav-link:hover {
  background-color: #e8f5e9;
  border-color: #66bb6a;
  color: #2e7d32;
}

/* 활성 탭 (active 상태) */
#resveTabs .nav-link.active {
  background-color: #4caf50;
  color: white;
  border-color: #388e3c;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}
</style>
<%@ include file="../include/footer.jsp"%>
