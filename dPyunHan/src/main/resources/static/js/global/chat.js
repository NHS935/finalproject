/* ===========================================
   WebSocket + 채팅 UI 통합 스크립트
   DOM 변경 없이 완전 동작 버전
=========================================== */
function fixedColor(userName) {
    const colors = [
        "#6C7AE0", "#E07A7A", "#50A7C2",
        "#8E44AD", "#27AE60", "#D35400",
        "#34495E", "#E67E22", "#2ECC71",
        "#75d164", "#d164b0", "#8f2540",
        "#4813d9", "#14fd1d", "#d3cf59",
        "#269588", "#66e14c", "#199490",
        "#edbd35", "#0a2875", "#ce5ec6",
        "#9ddefc", "#7f24ba", "#f0b591",
        "#47d06e", "#0a2198", "#ebf03e",
        "#b74c53", "#35dad6", "#e598a0",
        "#d48cf0", "#c1f091", "#9fce48",
        "#6f541d", "#fde633", "#a5e9cb",
        "#cc3b4a", "#dc54b8", "#34f265",
        "#a46538", "#b93587", "#cf5743",
        "#1d1340", "#5bea34", "#bc0324",
        "#1bd21f", "#0d3202", "#bb722e",
        "#69e691", "#cdf790", "#87ee9e",
        "#fcaa69", "#223882", "#7ea90b",
        "#a64295", "#bfa729", "#710fc0",
    ];
    
    let hash = 0;
    for (let i = 0; i < userName.length; i++) {
        hash = userName.charCodeAt(i) + ((hash << 5) - hash);
    }

    const index = Math.abs(hash) % colors.length;
    return colors[index];
}

/* -----------------------------
   로그인 사용자 이름
----------------------------- */
const name = document.body.dataset.name;


/* -----------------------------
   WebSocket 연결
----------------------------- */
const wsProtocol = location.protocol === "https:" ? "wss" : "ws";
const ws = new WebSocket(`${wsProtocol}://${location.hostname}:8272/ws/chat`);

let log = null;
let input = null;
let sendBtn = null;
let typingInput = document.createElement("div");
typingInput.className = "typing-indicator";
typingInput.textContent = "💭 상대방이 입력 중이에요...";
let typingTimeout;


/* -----------------------------
   WebSocket Event - open
----------------------------- */
ws.onopen = () => {
    ws.send(JSON.stringify({ type: "join", name }));
};


/* -----------------------------
   WebSocket Event - message
----------------------------- */
ws.onmessage = (e) => {
    if (!log) return; // DOM 준비 안 되면 무시

    const msg = JSON.parse(e.data);

    if (msg.type === "typing" && msg.name !== name) {
        typingInput.style.display = "block";

        if (!log.contains(typingInput)) {
            log.appendChild(typingInput);
        }

        log.scrollTop = log.scrollHeight;

        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            typingInput.style.display = "none";
        }, 1000);

        return;
    }

    if (msg.type === "notice") {
        const notice = document.createElement("div");
        notice.className = "messagenotice";
        notice.style.textAlign = "center";
        notice.style.color = "gray";
        notice.style.fontSize = "13px";
        notice.textContent = msg.text;
        log.appendChild(notice);
        log.scrollTop = log.scrollHeight;
        return;
    }

    if (msg.type === "chat") {
        addMsg(msg.name, msg.text);

        if (msg.name !== name) {
            if (Notification.permission === "default") {
                Notification.requestPermission();
            }

            if (Notification.permission === "granted") {
                requestAnimationFrame(() => {
                    const notification = new Notification("💬 D-편한세상 채팅", {
                        body: `${msg.name}님으로부터 새 메시지가 도착했습니다.`,
                        icon: "https://cdn-icons-png.flaticon.com/512/893/893292.png"
                    });

                    notification.onclick = () => {
                        window.focus();
                        window.parent?.postMessage({ action: "openChat" }, "*");
                    };
                });
            }
        }
        return;
    }
};


/* -----------------------------
   메시지 전송 함수
----------------------------- */
function send() {
    if (!input) return;

    const text = input.value.trim();
    if (!text) return;

    ws.send(JSON.stringify({ type: "chat", name, text }));
    input.value = "";
}


/* -----------------------------
   메시지 렌더링
----------------------------- */
function addMsg(sender, text) {
    if (!log) return;

    const isMe = sender === name;

    const wrap = document.createElement("div");
    wrap.className = "msg " + (isMe ? "me" : "other");

    const now = new Date();
    const timeText = `${now.getHours().toString().padStart(2, "0")}:${now.getMinutes().toString().padStart(2, "0")}`;

    /* =====================================
       상대방 메시지 구조 (사진 + 이름 + 메시지)
    ====================================== */
    if (!isMe) {
        
        let profileElem;
        /* ===== 유저별 프로필 매핑 ===== */
        const profileMap = {
           "고길": "/images/profile/고길동.png",
           "고희": "/images/profile/고희동.png"
        };
        
        if (profileMap[sender]) {
            // 사진이 존재하는 경우
            profileElem = document.createElement("img");
            profileElem.className = "profile";
            profileElem.src = profileMap[sender];
        } else {
            // 사진 없는 경우 → 이름 뒤 2글자 아바타
            const avatar = document.createElement("div");
            avatar.className = "avatar-placeholder";

            // 이름 뒤 2글자
            const nameLen = sender.length;
            const last2 = sender.substring(nameLen - 2, nameLen);
            avatar.textContent = last2;

            // 랜덤 배경색 추가
            avatar.style.backgroundColor = fixedColor(sender);

            profileElem = avatar;
        }
        
        wrap.appendChild(profileElem);

        const body = document.createElement("div");
        body.className = "msg-body";

        const nameBox = document.createElement("div");
        nameBox.className = "name";
        nameBox.textContent = sender;

        const row = document.createElement("div");
        row.className = "msg-row";

        const bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.textContent = text;

        const time = document.createElement("div");
        time.className = "time";
        time.textContent = timeText;

        row.appendChild(bubble);
        row.appendChild(time);

        body.appendChild(nameBox);
        body.appendChild(row);

        wrap.appendChild(body);
    }

    /* =====================================
       내 메시지(오른쪽) 기존 구조 유지
    ====================================== */
    else {
        const bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.textContent = text;

        const time = document.createElement("div");
        time.className = "time";
        time.textContent = timeText;

        wrap.appendChild(time);
        wrap.appendChild(bubble);
    }

    /* ====== 카카오톡식 그룹핑 ====== */
    const msgs = log.querySelectorAll(".msg");
    const lastMsg = msgs[msgs.length - 1];

    if (lastMsg && lastMsg.classList.contains(isMe ? "me" : "other")) {

        const lastTime = lastMsg.querySelector(".time");
        const lastText = lastTime?.textContent || "";
        const currentMinute = timeText.substring(0,5);
        const lastMinute = lastText.substring(0,5);

        // 같은 사람 + 같은 시간대 → 이전 시간 제거
        if (currentMinute === lastMinute) {
            if (lastTime) lastTime.remove();
        }
    }

    log.appendChild(wrap);

    log.scrollTop = log.scrollHeight;
    log.appendChild(typingInput);
}

/* ===========================================
   채팅 UI - domContentLoaded 이후에만 실행
=========================================== */
document.addEventListener("DOMContentLoaded", () => {

    console.log("CHAT USER: ", name);

    if (!name) {
        console.error("data-user 가 비어있습니다. JSP에서 data-user를 확인하세요.");
        return;
    }
        
    // WebSocket 연결도 여기서 만들기
    //const wsProtocol = location.protocol === "https:" ? "wss" : "ws";
    //const ws = new WebSocket(`${wsProtocol}://${location.hostname}:8272/ws/chat`);
        
    /* --------- DOM 요소 가져오기 ----------- */
    const chatBox = document.getElementById("chatBox");
    const messageBtn = document.querySelector(".chatBtn");

    log = document.getElementById("chatLog");
    input = document.getElementById("input");
    sendBtn = document.getElementById("send");

    const header = document.querySelector(".chat-header");
    const chatBody = document.querySelector(".chat-body");
    const inputArea = document.querySelector(".chat-input");

    const isMobile = /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);

    /* ----------- 버튼 없으면 종료 ----------- */
    

    /* ----------- 메시지 입력 이벤트 ----------- */
    sendBtn.onclick = send;
    input.addEventListener("keydown", e => e.key === "Enter" && send());
    input.addEventListener("input", () => {
        ws.send(JSON.stringify({ type: "typing", name }));
    });


    /* ===========================================
       모바일 fullscreen 계산
    ============================================ */
    function applyHeights() {
        if (!chatBox.classList.contains("fullscreen")) return;

        const vv = window.visualViewport;
        const headerH = header.offsetHeight;
        const inputH = inputArea.offsetHeight;
        const vh = vv.height;

        chatBody.style.height = (vh - headerH - inputH) + "px";
        chatBody.style.maxHeight = (vh - headerH - inputH) + "px";

        chatBox.style.transform = `translateY(${vv.offsetTop}px)`;
    }

    function setChatPcPosition(leftPx, topPx) {
        chatBox.style.position = "fixed";
        chatBox.style.left = leftPx + "px";
        chatBox.style.top = topPx + "px";
    }


    /* ===========================================
       열기 버튼
    ============================================ */
    messageBtn.addEventListener("click", () => {
        if (isMobile) {
            chatBox.style.display = "block";
            chatBox.classList.add("fullscreen");
            applyHeights();
        } else {
            chatBox.classList.remove("fullscreen");

            if (chatBox.style.display === "none" || chatBox.style.display === "") {
                chatBox.style.display = "block";

                setChatPcPosition(
                    window.innerWidth - 680,
                    window.innerHeight - 860
                );
            } else {
                chatBox.style.display = "none";
            }
        }
    });


    /* ===========================================
       닫기 버튼
    ============================================ */
    document.getElementById("closeBtn").addEventListener("click", () => {
        chatBox.style.display = "none";
        chatBox.classList.remove("fullscreen");
    });


    /* ===========================================
       모바일 키보드 대응
    ============================================ */
    if (window.visualViewport) {
        window.visualViewport.addEventListener("resize", applyHeights);
        window.visualViewport.addEventListener("scroll", applyHeights);
    }
});
