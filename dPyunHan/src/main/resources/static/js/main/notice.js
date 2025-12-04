let noticeList = [];
let currentIndex = -1;

document.addEventListener("DOMContentLoaded", function(){

    // ✅ 1번: 공지사항 리스트 받기
    fetch("/notice/listJson")
        .then(resp => resp.json())
        .then(data => {
            noticeList = data.noticeList;
            console.log("공지사항 리스트 로드 완료:", noticeList.length, "개");
        })
        .catch(error => console.log("리스트 로드 에러:", error));
        
    document.querySelectorAll(".notice-row, .notice-main-row").forEach(row => {
        row.addEventListener("click", function(e){
            e.preventDefault();
            const noticeSn = this.getAttribute("data-notice-sn");
            noticeDetail(noticeSn);
        });
    });
});

// ✅ 2번: noticeDetail 함수 수정
noticeDetail = function(noticeSn){
    let data = { "noticeSn" : noticeSn }

    fetch("/notice/detail", {
        method: "post",
        headers: { "Content-type":"application/json;charset=UTF-8" },
        body: JSON.stringify(data)
    })
    .then(resp => resp.json())
    .then(data => {
        const notice = data.noticeVO;
        const fileDetailVOList = data.fileDetailVOList;

        console.log("data : ",data);
        console.log("fileDetailVOList : ", fileDetailVOList);

        // ✅ 3번: 현재 인덱스 찾기 (새로 추가)
        currentIndex = noticeList.findIndex(n => n.noticeSn === notice.noticeSn);

        document.querySelector("#noticeSn").textContent = notice.noticeSn;
        document.querySelector("#noticeSj").textContent = notice.noticeSj;
        document.querySelector("#noticeCn").innerHTML = notice.noticeCn;
        document.querySelector("#noticeWritngDt").textContent = new Date(notice.noticeWritngDt).toLocaleString();
        document.querySelector("#empId").textContent = notice.nm;

        let filesHtml = '';
        if (fileDetailVOList && fileDetailVOList.length > 0) {
            filesHtml = fileDetailVOList.map(fileDetailVO => `<img src="/upload${fileDetailVO.fileStrelc}" style="height: 100px; margin: 5px;">`).join('');
        } else {
            filesHtml = '<p>첨부된 파일이 없습니다.</p>';
        }
        document.querySelector("#fileDetailVOList").innerHTML = filesHtml;

        // ✅ 4번: 이전글/다음글 텍스트 업데이트 (새로 추가)
        updateNavText();

        new bootstrap.Modal(document.querySelector('#detailModal')).show();
    })
    .catch(error => console.log("에러:",error));
}

// ✅ 5번: 이전글 클릭 (새로 추가)
function clickPrev() {
    if (currentIndex > 0) {
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
        document.body.classList.remove('modal-open');
        
        noticeDetail(noticeList[currentIndex - 1].noticeSn);
    }
}

// ✅ 6번: 다음글 클릭 (새로 추가)
function clickNext() {
    if (currentIndex < noticeList.length - 1) {
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
        document.body.classList.remove('modal-open');
        
        noticeDetail(noticeList[currentIndex + 1].noticeSn);
    }
}

// ✅ 7번: 이전글/다음글 텍스트 업데이트 (새로 추가)
function updateNavText() {
    const prevSection = document.querySelector("#prevSection");
    const nextSection = document.querySelector("#nextSection");
    
    if (!prevSection || !nextSection) return;
    
    // 이전글
    if (currentIndex > 0) {
        const prevNotice = noticeList[currentIndex - 1];
        document.querySelector("#prevTitle").textContent = prevNotice.noticeSj;
        prevSection.style.opacity = "1";
        prevSection.style.pointerEvents = "auto";
    } else {
        document.querySelector("#prevTitle").textContent = "이전글 없음";
        prevSection.style.opacity = "0.5";
        prevSection.style.pointerEvents = "none";
    }
    
    // 다음글
    if (currentIndex < noticeList.length - 1) {
        const nextNotice = noticeList[currentIndex + 1];
        document.querySelector("#nextTitle").textContent = nextNotice.noticeSj;
        nextSection.style.opacity = "1";
        nextSection.style.pointerEvents = "auto";
    } else {
        document.querySelector("#nextTitle").textContent = "다음글 없음";
        nextSection.style.opacity = "0.5";
        nextSection.style.pointerEvents = "none";
    }
}

//======================================== 슬라이드 섹션 =================================================
document.addEventListener("DOMContentLoaded", () => {

    new Swiper('.notice-line-swiper', {
        loop: true,
        direction: 'vertical',
        effect: 'flip',
        flipEffect: {
            slideShadows: true,
            limitRotation: true
        },
        slidesPerView: 1,
        speed: 1500,
        autoplay: {
            delay: 2000,
            disableOnInteraction: false
        },
        allowTouchMove: true
    });

    // ✅ + 버튼 클릭 이벤트 (추가)
    const expandBtn = document.getElementById("noticeExpandBtn");
    const fullList = document.getElementById("noticeFullList");
    
    if (expandBtn && fullList) {
        expandBtn.addEventListener("click", function(e) {
            e.stopPropagation(); // 이벤트 전파 막기
            
            // active 클래스 토글
            expandBtn.classList.toggle("active");
            fullList.classList.toggle("active");
        });
    }

    // ✅ 전체 목록 아이템 클릭 이벤트 (추가)
    document.querySelectorAll(".notice-full-item").forEach(item => {
        item.addEventListener("click", function(e) {
            e.preventDefault();
            const noticeSn = this.getAttribute("data-notice-sn");
            noticeDetail(noticeSn);
            
			window.location.href = `/notice/list`;
		    localStorage.setItem("openNoticeSn", noticeSn);
        });
    });

    // 공지 클릭 시 notice/list 로 이동
    document.addEventListener("click", function(e) {
        const el = e.target.closest(".notice-line-item");
        if (!el) return;

        const sn = el.dataset.noticeSn;
        if (!sn) return;

        // 페이지 이동
        window.location.href = `/notice/list`;
        localStorage.setItem("openNoticeSn", sn);
    });

});
