<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="/css/main/vote.css">

<!-- /// header 시작  -->
<%@ include file="../include/headerContents.jsp"%>


<!-- /// body 시작 /// -->
<div class="card"
	style="margin: 8px; padding: 5px; border: 3px solid rgba(100, 140, 164, 0.75); border-radius: 14px;">

	<!-- 목록 -->
	<div class="mobile-list" style="margin: 5px;">
		<c:forEach var="p" items="${articlePage.content}" varStatus="stat">

			<c:set var="badgeClass" value="bg-light text-muted" />
			<c:if test="${p.stat eq '진행중'}">
				<c:set var="badgeClass" value="bg-success" />
			</c:if>
			<c:if test="${p.stat eq '예정'}">
				<c:set var="badgeClass" value="bg-secondary" />
			</c:if>
			<c:if test="${p.stat eq '마감'}">
				<c:set var="badgeClass" value="bg-warning text-dark" />
			</c:if>

			<div class="card mb-2 shadow-sm border-0 open-vote"
			     data-sn="${p.voteMtrSn}"
			     data-no="${(articlePage.currentPage-1) * 10 + stat.count}"
			     style="cursor:pointer;">
				<div class="card-body py-3 px-3">
					<!-- 제목/상태 -->
					<div class="d-flex justify-content-between align-items-start gap-2">
						<div class="fw-semibold text-truncate" style="max-width: 100%;">
							<!-- 글번호 -->
							<span class="badge bg-secondary text-white rounded-pill px-2">${(articlePage.currentPage-1) * 10 + stat.count}</span>
							${p.mtrSj}
						</div>
						<span class="badge ${badgeClass}">${p.stat}</span>
					</div>


					<!-- 기간 -->
					<div class="small text-muted mt-1">
						<i class="bi bi-calendar-check"></i> ${fn:substring(p.voteBeginDt, 0, 10)}
						~ ${fn:substring(p.voteEndDt, 0, 10)}
					</div>

					<!-- 인원/참여여부 -->
					<div class="d-flex justify-content-between align-items-center mt-2">
						<div class="small">
							투표인원: <span class="fw-semibold"><c:out
									value="${p.votedNum}" /></span>
						</div>
						<div>
							<c:choose>
								<c:when test='${p.isVoted eq "참여"}'>
									<span class="badge bg-info">참여완료</span>
								</c:when>
								<c:otherwise>
									<span class="badge bg-light text-danger">미참여</span>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>

		</c:forEach>

		<!-- 페이지네이션 -->
		<div class="d-flex justify-content-center">
			${articlePage.pagingArea}</div>
	</div>

	<!-- 하단 검색 필터 영역 -->
	<div
		style="border-top: 1px solid rgba(0, 0, 0, .06); padding: 12px 10px; background: #fff; border-bottom-left-radius: 14px; border-bottom-right-radius: 14px;">
		<form id="frm" name="frm" action="/vote/memVoteList" method="get"
			style="display: flex; flex-wrap: wrap; gap: 8px; align-items: center; justify-content: center; margin: 0;">
			<input type="hidden" name="currentPage" value="1" />

			<!-- 기간 -->
			<label style="margin: 0;"> <input type="date"
				name="periodFrom" value="${param.periodFrom}"
				class="form-control form-control-sm" />
			</label> <span style="margin: 0 .25rem;">~</span> <label style="margin: 0;">
				<input type="date" name="periodTo" value="${param.periodTo}"
				class="form-control form-control-sm" />
			</label>
			<!-- 상태 -->
			<label style="margin: 0;"> <select name="stat"
				class="form-control form-control-sm">
					<option value="" ${empty param.stat ? 'selected' : ''}>전체</option>
					<option value="진행중" ${param.stat eq '진행중' ? 'selected' : ''}>진행중</option>
					<option value="예정" ${param.stat eq '예정'   ? 'selected' : ''}>예정</option>
					<option value="마감" ${param.stat eq '마감'   ? 'selected' : ''}>마감</option>
			</select>
			</label>
			<!-- 키워드 -->
			<label style="margin: 0;"> <input type="search"
				name="keyword" placeholder="검색어(제목/내용)" aria-controls="example1"
				value="${fn:escapeXml(param.keyword)}"
				class="form-control form-control-sm" style="min-width: 180px;" />
			</label>



			<!-- 버튼들 -->
			<button type="submit" class="btn btn-info btn-sm"
				style="padding: .25rem .6rem;">검색</button>
			<a href="/vote/memVoteList" class="btn btn-default btn-sm"
				style="padding: .25rem .6rem;">초기화</a>
		</form>
	</div>
	<!-- 검색끝 -->

</div>



<!-- modal시작 : 투표 상세 -->
<div class="modal fade" id="goVoteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">

      <!-- 상단 헤더 -->
      <div class="modal-header">
        <div class="d-flex align-items-center gap-2">
          <span class="task-chip">
            <span class="me-1">투표</span>
          <!-- 순번 표시 -->
            <span class="text-muted">#<span id="md-articleNo">-</span></span>
          </span>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <!-- 본문 -->
      <div class="modal-body">
		<div class="modal-scroll-area">
        <div class="task-panel">

          <!-- 제목 영역 -->
          <div class="mb-2">
            <span class="task-meta-label">제목</span>
            <input type="text"
                   id="md-mtrSj"
                   class="form-control form-control-sm border-0 bg-transparent px-0"
                   style="font-size:.95rem; font-weight:600;"
                   readonly>
          </div>

          <!-- 작성자 / 기간 / 상태 -->
          <div class="task-meta-grid">
            <div>
              <span class="task-meta-label">작성자</span>
              <div style="font-size:0.8rem; font-weight:500;">
                <span id="md-empNm">-</span>
              </div>
            </div>
            <div>
              <span class="task-meta-label">투표 기간</span>
              <input type="text" id="md-voteTime"
                     class="form-control form-control-sm" readonly>
            </div>
          </div>

          <!-- 내용 / 그래프  -->
          <div class="task-split">
            <!-- 내용 -->
            <div class="task-section">
              <div class="task-section-title">투표 내용</div>
              <textarea id="md-mtrCn"
                        class="form-control form-control-sm task-description"
                        rows="5"
                        style="resize:none;"
                        readonly></textarea>
            </div>

            <!-- 그래프 -->
            <div class="task-section">
              <div class="task-section-title">투표 결과</div>
              <div id="voteGraph"></div>
            </div>
          </div>

          <!-- 투표 항목 -->
          <div class="task-table-wrap">
            <div class="task-table-header d-flex align-items-center" style="gap:10px;">
			  <h6 class="mb-0 d-flex align-items-center" style="gap:8px;">투표 항목 <div id="myVoteBadge"></div></h6>
			  <small class="ml-2 text-muted">항목을 선택 후 투표 버튼을 눌러주세요.</small>
			</div>

            <div class="px-2 pt-1 pb-2">
              <form id="frmVote" method="post" action="/vote/haveAVote">
                <input type="hidden" name="voteMtrSn" id="md-voteMtrSn-hidden">

                <div class="table-responsive">
                  <table id="voteIemTable"
                         class="table table-sm table-hover align-middle">
                    <thead>
                      <tr>
                        <th style="width:10%;">순번</th>
                        <th style="width:25%;">투표 항목</th>
<!--                         <th style="width:45%;">내용</th> -->
                        <th style="width:10%;">투표</th>
                        <th style="width:10%;">투표수</th>
                      </tr>
                    </thead>
                    <tbody id="md-iem-tbody"></tbody>
                  </table>
                </div>

                <!-- 버튼 영역 -->
                <div class="d-flex justify-content-end gap-2 mt-2">
                  <button type="button"
                          class="btn btn-light btn-sm"
                          data-bs-dismiss="modal"
                          style="padding:.35rem .7rem; border-radius:10px;">
                    닫기
                  </button>
                  <button type="submit"
                          class="btn btn-info btn-sm"
                          style="padding:.35rem .7rem; border-radius:10px;">
                    <i class="far fa-envelope"></i> 투표하기
                  </button>
                </div>
              </form>
            </div>
          </div>

        </div>
      </div>

      <!-- 푸터  -->
      <div class="modal-footer"></div>
      </div>
    </div>
  </div>
</div>





<!-- /// footer 시작 /// -->
<%@ include file="../include/footerContents.jsp"%>
<!-- /// footer 끝 /// -->










<script>
//상세띄우기
document.body.addEventListener("click", (e) => {
    const card = e.target.closest(".card.open-vote");
    if (!card) return;
	/*console.log("카드클릭되어씀", card, card.dataset.sn);*/ /* 체크완료 */
    e.preventDefault();

    const voteMtrSn = card.dataset.sn;
    const articleNo = card.dataset.no;//목록순번
    if (!voteMtrSn) return;
	
    //모달헤더 순번
    document.getElementById("md-articleNo").textContent = articleNo;
    // 모달 먼저 열고 로딩 표시
    const modalEl = document.getElementById('goVoteModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
    setIemTbody(`<tr><td colspan="5" class="text-center text-muted py-3">
        <div class="spinner-border text-primary" role="status"><span >Loading...</span></div>
      </td></tr>`);
	  
	  fetch("/vote/memVoteList", {
	    method: "POST",
	    headers: { "Content-Type": "application/json" },
	    body: JSON.stringify({ voteMtrSn: voteMtrSn })
	  })
	  .then(res => res.json())
	  .then(data => {
	    const vo = data?.voteMtrVO;
	    if (!vo) {
	      setIemTbody(`데이터가 없습니다.`);
	      return;
	    }
	    renderModal(vo);
	  })
	  .catch(() => {
	    setIemTbody(`불러오기에 실패했습니다.`);
	  });
	});


 // 상세 불러오기
function renderModal(iem) {

		  console.log("iem 전체 = ", iem);
		  console.log("myVoteIemNo = ", iem.myVoteIemNo, " / type = ", typeof iem.myVoteIemNo);
	 
  const beginDt = (iem.voteBeginDt).toString().substring(0,10);
  const endDt   = (iem.voteEndDt).toString().substring(0,10);

  
  document.getElementById("md-empNm").textContent = iem.nm;
  document.getElementById("md-mtrSj").value = iem.mtrSj;
  document.getElementById("md-voteTime").value = `\${beginDt}부터 ~ \${endDt}까지`;
  document.getElementById("md-mtrCn").value = iem.mtrCn;
  document.getElementById("md-voteMtrSn-hidden").value = iem.voteMtrSn;
  
  /* 2025-11-17kbh추가 마감 날짜보다 지금 날짜가 크면 투표버튼 비활성화 시작 */
  const voteForm = document.getElementById("frmVote");
  const voteBtn  = voteForm.querySelector("button[type='submit']");
  // 종료일 기준으로 계산
  const now = new Date();	// 지금시간
  const endDate = new Date(iem.voteEndDt);  // 마감 시간
  const isClosed = now > endDate; // true면 마감
  voteForm.dataset.closed = isClosed ? "Y" : "N";
  
  const radios = voteForm.querySelectorAll("input[name='voteIemNo']");
  if (isClosed) {
	// 마감된 경우 비활성 + 안내 문구
	voteBtn.disabled = true;
	voteBtn.classList.remove("btn-info");
	voteBtn.classList.add("btn-secondary");
	voteBtn.innerHTML = '<i class="far fa-envelope"></i> 마감된 투표입니다';
	
	radios.forEach(r => r.disabled = true);
  }else {
		// 마감된 경우 비활성 + 안내 문구
    voteBtn.disabled = false;
    voteBtn.classList.remove("btn-secondary");
    voteBtn.classList.add("btn-info");
    voteBtn.innerHTML = '<i class="far fa-envelope"></i>투표';
    
    radios.forEach(r => r.disabled = false);
    
    /* 내가 어디에 투표했는지 표시*/
    const myVoteBadge = document.getElementById("myVoteBadge");
    if (iem.myVoteIemNo) {
        myVoteBadge.innerHTML = `
            <span class="badge bg-secondary" style="font-size:.75rem;">
                내 투표: &nbsp;\${iem.myVoteIemNo}번
            </span>`;
    } else {
        myVoteBadge.innerHTML = "";
    }
  /* 2025-11-17kbh추가 마감 날짜보다 지금 날짜가 크면 비활성화 + 마감된 투표입니다.끝  */
}  
  
  
//data배열에 넣기
  const list = Array.isArray(iem.voteIemVOList) ? iem.voteIemVOList : [];
  const myVoteIemNo = iem.myVoteIemNo;  

  const rows = list.map(i => `

  <tr \${myVoteIemNo == i.voteIemNo ? 'class="bh"':''}>
  <td>\${i.voteIemNo}</td>
  <td>\${i.iemNm}</td>
  <!--<td>\${i.iemCn}</td>-->
  <td>
     <input type="radio" name="voteIemNo" value="\${i.voteIemNo}"
      \${myVoteIemNo === i.voteIemNo ? "checked" : ""}>
  </td>
  <td>\${i.cnt}</td>
</tr>
  `).join("");

  setIemTbody(rows);
  
  setTimeout(()=>{
      // 시간 차 공격... 변칙!
      const bhTrs = Array.from(document.querySelectorAll(".bh"));
      bhTrs.forEach((bh)=>{
      	bh.style.backgroundColor="pink"; 
      })
  },500)
  
}

function setIemTbody(html){ document.getElementById("md-iem-tbody").innerHTML = html; 
}


document.addEventListener("DOMContentLoaded", function() {
// 모달 안의 투표 버튼
var voteForm = document.getElementById("frmVote");

// form이 바로 submit되지 않게 막기
voteForm.addEventListener("submit", function(e) {
  e.preventDefault(); // 기본 제출 막기

  /* 마감된 투표인지 체크해서 return시키기 */
  if (voteForm.dataset.closed === "Y") {
	    Swal.fire({
	      icon: "info",
	      title: "마감된 투표입니다.",
	      text: "마감된 투표에는 더 이상 참여할 수 없습니다.",
	      timer: 500,
	      showConfirmButton: false
	    });
	    return;
	  }
  // 선택된 항목이 있는지 확인
  var checked = voteForm.querySelector("input[name='voteIemNo']:checked");
  if (!checked) {
    Swal.fire({
      icon: "warning",
      title: "투표 항목을 선택해주세요.",
      timer: 500,
      showConfirmButton: false
    });
    return;
  }

  // SweetAlert확인창 띄우기
  Swal.fire({
    title: "이 항목에 투표하시겠습니까?",
    icon: "question",
    showCancelButton: true,
    confirmButtonText: "예",
    cancelButtonText: "아니오"
  }).then(function(result) {
    if (result.isConfirmed) {
      // 확인 눌렀을 때 실제 폼 제출
      voteForm.submit();

      // 선택 사항: 잠깐 로딩 메시지
      Swal.fire({
        title: "투표 중입니다...",
        icon: "info",
        showConfirmButton: false,
        timer: 1200
      });
    }
  });
});
});
</script>

<!-- 그래프 그리는거입니다 시작 -->
<script src='https://cdn.plot.ly/plotly-3.2.0.min.js'></script>
<script>
	//스크립트 시작
	document
			.addEventListener(
					"DOMContentLoaded",
					function() {
						function drawVoteGraph() {
							//  투표 항목 테이블에서 데이터 읽어오기
							const rows = document
									.querySelectorAll("#voteIemTable tbody tr");
							const labels = []; // 투표 항목명 (iemNm)
							const values = []; // 투표수 (cnt)

							rows.forEach(function(row) {
								const cells = row.querySelectorAll("td");

								// 없는 행 건너뛰기
								if (cells.length < 4)
									return;

								// 순번, 투표항목, 내용, 투표수
								const label = cells[1].textContent.trim(); // 투표항목
								const valueText = cells[3].textContent.trim(); // 투표수 문자열
								const value = parseInt(valueText.replace(/,/g,
										""), 10) || 0;

								labels.push(label);
								values.push(value);
							});

							// 데이터
							const data = [ {
								values : values,
								labels : labels,
								type : "pie",
								textinfo : "none",	//상단 중복정보 안보이게
								hoverinfo : "label+value+percent",
								hole : 0.1, // 도넛 형태, 구멍크기
								marker:{ line: {width: 0} }
							// marker: { colors: [...] } // 색상지정가능
							} ];
							// 레이아웃 설정
							const layout = {
								title : "투표 결과",
								height : 200,
								width : 260,
								legend : {
									orientation : "h",
									x : 0.5,
									xanchor : "center",
									y : -0.15
								},
								margin : {
									t : 40,
									l : 10,
									r : 10,
									b : 40
								}
							};
							// 그래프 그리기
							Plotly.newPlot("voteGraph", data, layout, {
								displayModeBar: false,  // 모드바 전체 제거
								displaylogo: false,      // Plotly 로고 제거
							});
						}
						const voteModalEl = document
								.getElementById("goVoteModal");
						if (voteModalEl) {
							voteModalEl.addEventListener("shown.bs.modal",
									function() {
										drawVoteGraph();
									});
						}
					});
</script>
<!-- 그래프 그리는거입니다 끝 -->