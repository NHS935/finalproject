<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>D-편한세상 채팅</title>
<style> 


/* 채티창 내부 디자인 */
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: "Segoe UI", "Apple SD Gothic Neo", sans-serif;
  background-color: #ece5dd;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

html, body { background: transparent !important; }

.chat-wrapper {
  width: 400px;
  height: 650px;
  background: #fff;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
  border: 1px solid #ccc;
}

header {
  background-color:#e97a47;
  color: #fff;
  padding: 16px;
  font-size: 18px;
  font-weight: bold;
  display: flex;
  align-items: center;
  z-index: 10; 
  position: relative;
}

.chat-area {
  position:relative;
  flex: 1;
  background-color: #ece5dd;
  padding: 12px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.msg {
  display: flex;
  align-items: flex-end;
}
.msg .bubble {
  max-width: 70%;
  padding: 10px 14px;
  border-radius: 14px;
  font-size: 15px;
  line-height: 1.4;
  position: relative;
}
.msg.me { justify-content: flex-end; }
.msg.me .bubble {
  background: #fbe1cf;
  border-bottom-right-radius: 0;
}
.msg.other .bubble {
  background: #fff;
  border-bottom-left-radius: 0;
  border: 1px solid #ddd;
}
.time {
  font-size: 11px;
  color: gray;
  margin: 0 6px;
  align-self: flex-end;
}
.input-area {
  display: flex;
  padding: 10px;
  background: #f0f0f0;
  border-top: 1px solid #ddd;
  gap: 8px;
}
.input-area input {
  flex: 1;
  border: none;
  padding: 10px 14px;
  border-radius: 20px;
  outline: none;
  font-size: 14px;
}
.input-area button {
  background: #ee8554;
  color: #fff;
  border: none;
  padding: 0 18px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: bold;
  transition: 0.2s;
}
.input-area button:hover { background: #d37141; }
.input-area button:active { background: #c55e2f; }

.typing-indicator {
  position:sticky;
  bottom:0;
  left:0;
  right:0;
  text-align: center;
  font-size: 12px;
  color: gray;
  padding: 6px 10px;
  background-color: #ece5dd;
  display: none;
}

/* 버튼 그룹 영역 */
.chatcontrols {
  display: flex;
  gap: 6px;
  margin-left:180px;
}

/* 각 버튼 스타일 */
.chatcontrols button {
  background: transparent;
  border: none;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  cursor: pointer;
  transition: background 0.2s ease;
}

/* 마우스 올렸을 때 */
.chatcontrols button:hover {
  background: rgba(255, 255, 255, 0.2);
}

/* 닫기 버튼은 hover 시 색상 조금 다르게 */
#closeBtn:hover {
  background: rgba(255, 0, 0, 0.4);
}

#chatBox.minimized {
  height: 50px;
  width: 300px;
  overflow: hidden;
}

/* 
.chat-wrapper.minimized .chat-area,
.chat-wrapper.minimized .input-area,
.chat-wrapper.minimized .chatcontrols {
  display: none !important;
}

.chat-wrapper.minimized {
  background: transparent !important;
  box-shadow: none !important;
  border: none !important;
  border-radius: 0 !important;
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: auto !important;
  height: auto !important;
  overflow: visible !important;
  display: inline-block !important;
  z-index: 9999;
}

.chat-wrapper.minimized header {
  background-color: #e97a47; 
  color: #fff;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  font-size: 15px;
  border-radius: 10px;
  display: flex;
} 
*/

</style>

<script>

function hs1(){   // - 버튼, 함수선언
    console.log("체크해보자 parent : ",parent);
	parent.handleClick();  //함수 호출
}

document.addEventListener("DOMContentLoaded",function(){
 
  const miniBtn = document.querySelector("#miniBtn");
  const wrapper = document.querySelector(".chat-wrapper");

  const closeBtn = document.querySelector("#closeBtn"); 
  
  closeBtn.addEventListener("click",function(){  //x 버튼을 누르면
     parent.postMessage({action:"closeChat"},"*");  //main.jsp에 상태값 던지기
  });

});

</script> 

</head>
<body>
<div class="chat-wrapper">

  <header id="chatHeader"> 
  <span>💬 D-편한세상</span>
   <div class="chatcontrols">
     <button id="miniBtn" onClick="hs1()">-</button>   <!-- 작동 안해요 디자인상 있는거입니다. -->
     <button id="closeBtn">x</button>
   </div> 
  </header>

  <div class="chat-area" id="chatLog"></div>
  <div class="input-area">
    <input id="input" placeholder="메시지를 입력하세요..." autocomplete="off" />
    <button id="send">전송</button>
  </div>
</div>

<script>


  // (나중에 로그인 세션이 붙을 경우 이 부분만 교체)
   const name = "${userName}";  

  // 현재 시연용 버전 (localStorage로 이름 저장) 이후 최종때 이 부분 비활성화하기
  /* let name = localStorage.getItem("chatUser");
  if (!name) {
    name = prompt("이름을 입력하세요", "직원" + Math.floor(Math.random()*100));
    localStorage.setItem("chatUser", name);
  } */

  //  WebSocket 서버 (현재는 테스트용 8021 포트)
  // 알림 서버에 합칠 땐 8020으로만 바꾸면 끝!
  
  const ws = new WebSocket("ws://192.168.141.46:8020/ws/chat");

  const log = document.getElementById("chatLog");  
  const input = document.getElementById("input");   //메세지를 입력하세요 칸
  const sendBtn = document.getElementById("send");   //전송버튼
  const typingInput = document.createElement("div"); //div 추가

  typingInput.className="typing-indicator";
  typingInput.textContent="💭 상대방이 입력 중이에요...";
  

  let typingTimeout;
  
  ws.onopen=()=>{  // websocket 연결 이벤트는 open이 아니라 onopen
	console.log("체크(오픈)",ws);
    ws.send(JSON.stringify({type:"join", name}));  //접속 시 서버에 "입장"알림 전송
  };


  ws.onmessage = (e) => {   
    const msg = JSON.parse(e.data);
    
    console.log("수신 메세지 체크 : ",msg);
    
    //상대방이 입력 중이에요 표시부분
    if(msg.type=="typing" && msg.name != name){
    	
      typingInput.style.display = "block";
      
      if (!log.contains(typingInput)) {
    	    log.appendChild(typingInput);
    	}
      
      log.scrollTop = log.scrollHeight;
      
      clearTimeout(typingTimeout);
      
      typingTimeout=setTimeout(()=>{
        typingInput.style.display="none";
      },1000);
      
      return;
    }

  if(msg.type=="notice"){   //입장/퇴장 화면 표시 부분
      const notice = document.createElement("div");
      notice.className="messagenotice";
      notice.textContent = msg.text;
      notice.style.textAlign = "center";
      notice.style.color = "gray";
      notice.style.fontSize = "13px";
      log.appendChild(notice);
      log.scrollTop = log.scrollHeight;
      return;
  }

  if(msg.type=="chat"){
    addMsg(msg.name, msg.text);  //메세지 출력	  
    
   //상대방이 채팅을 보내면 하단에 알림표시

   if(msg.name != name){  //내가 아닌 상대방이 보낸경우
     //팝업 알림 권한이 없으면 요청하기(브라우저 내 api)
     if(Notification.permission =="default"){
       Notification.requestPermission();
     }

    //팝업 알림을 허용하면
    if(Notification.permission=="granted"){
    	requestAnimationFrame(()=>{	
      const notification = new Notification("💬 D-편한세상 채팅", {
        body: `${msg.name}님으로부터 새 메시지가 도착했습니다.`,
        icon: "https://cdn-icons-png.flaticon.com/512/893/893292.png"
      });    

    //알림 클릭 시 채팅창 나오게 하기
    notification.onclick=()=>{
       window.focus();
       window.parent.postMessage({action:"openChat"},"*");     
    };
        }); 
      } 
    } 
    return;
  }
  };

  sendBtn.onclick = send;  //전송버튼 클릭 시 send 함수 생성
  input.addEventListener("keydown", e => (e.key === "Enter") && send()); //누른 키가 엔터이면 전송
  input.addEventListener("input",()=>{     //내 이름과 함께 상대방에게 '상대방이 입력중입니다' 뜨게함
     ws.send(JSON.stringify({type: "typing",name}))
  });

  function send() {  //전송버튼을 누르면
    const text = input.value.trim();
    if (!text) return;  //만약 입력칸에 텍스트가 비워있으면 아무것도 하지않고 종료
    const msg = {type: "chat", name, text};
    ws.send(JSON.stringify(msg));
    input.value = "";   //전송 후엔 입력칸 초기화
  }

  function addMsg(sender, text) {
    const wrap = document.createElement("div");
    wrap.className = "msg " + (sender === name ? "me" : "other");  //클래스 이름 구분 보내는 사람이 나이면 msgme, 남이면 msgother
    const bubble = document.createElement("div");  //말풍선 부분
    bubble.className = "bubble";
    bubble.textContent = text;
    const time = document.createElement("div");
    const now = new Date();
    time.textContent = `${now.getHours().toString().padStart(2,"0")}:${now.getMinutes().toString().padStart(2,"0")}`;  //메신저 내용 옆 시간 표시
    time.className = "time";
    wrap.appendChild(bubble);
    wrap.appendChild(time);
    log.appendChild(wrap);
    log.scrollTop = log.scrollHeight;  //스크롤이 내려가서 항상 새메시지가 보이게 함
    log.appendChild(typingInput);
  }
  

</script>
</body>
</html>