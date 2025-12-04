//상세띄우기
document.body.addEventListener("click", (e) => {
    const card = e.target.closest(".card.open-vote");
    if (!card) return;
	/*console.log("카드클릭되어씀", card, card.dataset.sn);*/ /* 체크완료 */
    e.preventDefault();

    const voteMtrSn = card.dataset.sn;
    if (!voteMtrSn) return;

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
    const beginDt = (iem.voteBeginDt).toString().substring(0, 10);
    const endDt = (iem.voteEndDt).toString().substring(0, 10);


   /* document.getElementById("md-voteMtrSn").textContent = iem.voteMtrSn; */
   /* document.getElementById("md-empNm").textContent = iem.empNm; */
    document.getElementById("md-mtrSj").value = iem.mtrSj;
    document.getElementById("md-voteTime").value = `${beginDt}부터 ~ ${endDt}까지`;
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
		            내 투표: &nbsp;${iem.myVoteIemNo}번
		        </span>`;
		} else {
		    myVoteBadge.innerHTML = "";
		}
	  /* 2025-11-17kbh추가 마감 날짜보다 지금 날짜가 크면 비활성화 + 마감된 투표입니다.끝  */
	}  	
    //data배열에 넣기
	const list = Array.isArray(iem.voteIemVOList) ? iem.voteIemVOList : [];
	const myVoteIemNo = iem.myVoteIemNo;  
	const badge = document.getElementById("myVoteBadge");

	if (myVoteIemNo) {
	    document.getElementById("myVoteBadge").innerHTML =
	        '<span class="badge bg-secondary ms-2">내 투표 : ' + myVoteIemNo + '번</span>';
	} else {
	    badge.innerHTML = ""; 
	}
    const rows = list.map(i => `
    <tr>
	<tr ${myVoteIemNo === i.voteIemNo ? 'style="background-color:#e8f5e9 !important;"': ''}>
      <td>${i.voteIemNo}</td>
      <td style="text-align:left;">${i.iemNm}</td>
      
	  <td>
	       <input type="radio" name="voteIemNo" value="${i.voteIemNo}"
	        ${myVoteIemNo === i.voteIemNo ? "checked" : ""}>
	    </td>
	    <td>${i.cnt}</td>
	  </tr>
	    `).join("");
    setIemTbody(rows);
}

function setIemTbody(html) {
    document.getElementById("md-iem-tbody").innerHTML = html;
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
                timer: 1500,
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

                // 로딩 메시지
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