<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.19/index.min.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.19/index.global.min.js"></script>

<!DOCTYPE html>
<html>
  <head>
    <%@ include file="../include/header.jsp"%>
<title>D-편한세상 일정</title>

<!-- 캘린더 스타일 지정 -->

<style>

/*날짜 숫자 색상*/

.fc-daygrid-day-number{
    color:gray;
}

/*요일 헤더 색상*/
.fc-col-header-cell-cushion {
     color: black;
}

/*오늘 날짜 배경색*/
 .fc-day-today{
    background-color: beige;
 }

/*이벤트 일정 스타일*/
.fc-event {
  background-color: plum;
  color: blueviolet;
  border-radius: 3px;
}

  /* Week number 색상 */
  .fc .fc-daygrid-week-number {
    color: #888888;
  }
  
   /* 캘린더 범례 */
  .legend-item {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    margin-left: 20px;
    font-size: 14px;
  }

  .legend-item .legend-color {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    display: inline-block;
  }

  .legend-facility { background-color: plum; }
  .legend-community { background-color: lightblue; }
  
</style>


 <script>
 
  document.addEventListener("DOMContentLoaded",function(){
   
  
  
   //캘린더 헤더 옵션
   const headerToolbar = {
         left: 'prevYear,prev,next,nextYear today',
         center: 'title',
         right: 'dayGridMonth,dayGridWeek,timeGridDay'
     }

     // 캘린더 생성 옵션(참공)
     const calendarOption = {
         height: '700px', // calendar 높이 설정
         expandRows: true, // 화면에 맞게 높이 재설정
         slotMinTime: '09:00', // Day 캘린더 시작 시간
         slotMaxTime: '18:00', // Day 캘린더 종료 시간
         // 맨 위 헤더 지정
         headerToolbar: headerToolbar,
         initialView: 'dayGridMonth',  // default: dayGridMonth 'dayGridWeek', 'timeGridDay', 'listWeek'
         locale: 'kr',        // 언어 설정
         selectable: false,    // 영역 선택
         selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
         navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
         weekNumbers: false,   // WeekNumber 출력여부, default false
         editable: false,      // 입주민은 수정 불가 
         /* 시작일 및 기간 수정가능여부
         eventStartEditable: false,
         eventDurationEditable: true,
         */
         dayMaxEventRows: true,  // Row 높이보다 많으면 +숫자 more 링크 보임!
         /*
         views: {
             dayGridMonth: {
                 dayMaxEventRows: 3
             }
         },
         */
         nowIndicator: true,
         events:function(info,successCallback,failureCallback){
          /*
        	 var url = "/fx/listAjax";
           fetch(url).then(resp=>{
             return resp.json();
           }).then(rslt=>{
             console.log("체킁:",rslt);
           })
            */

           const url = "/fx/listAjax";
        	 $.ajax({
                 url:url,
                 contentType : "application/json",
                 type: 'get',
                 dataType: 'json',
                 success: function(param){
                    var events = [];
                    console.log("param : ", param);
                    $.each(param, function (index, data){
                        console.log("data : ", data);
                        
                        //구분(시설,커뮤니티,일정)에 따라 색상 다르게 반영
                      
                        let bgColor = "";
                        let texColor="white";
   
                        switch(data.fxIem){
                        case "시설":
                      	  bgColor="plum";
                      	  texColor= "blueviolet";
                      	  break
                          case "커뮤니티":
                               bgColor="lightblue";
                               texColor="#787878";
                               break;
                        }

                        events.push({
                            id:data.schdulSn,
                            title:data.fxSj,
                            start:data.fxBeginDt,
                            end:data.fxEndDt,
                            allDay:false,
                            backgroundColor:bgColor, //배경색
                            textColor:texColor,    //글자색
                            extendedProps:{  //추가 데이터
                               empId:data.empId,
                               fxIem:data.fxIem,
                               fxCn:data.fxCn,
                               fxPlace:data.fxPlace
                            }	
                        });
                    })
                 
                    successCallback(events);
                }
        	 });  
         }	 
        	        	 
     }
  
   // 캘린더 생성

   const calendarEl = document.querySelector("#calendar");

   const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
    
    
   //일정 클릭 시 상세보기

   calendar.on("eventClick",function(info){  //info:fullcalendar가 event를 클릭했을때 자동으로 전달해주는 객체

     console.log("info.event: ",info.event);

      const period = info.event;

      //이전 모달 내용 가지고오기
       $("#detailempId").val(period.extendedProps.empId);
       $("#detailfxSj").val(period.title);
       $("#detailfxIem").val(period.extendedProps.fxIem);
       $("#detailfxBeginDt").val(period.startStr.substring(0,16));
       $("#detailfxEndDt").val(period.endStr.substring(0,16));
       $("#detailfxCn").val(period.extendedProps.fxCn);
       $("#detailfxPlace").val(period.extendedProps.fxPlace);
  
       //모달 띄우기
       $("#detailModal").modal('show');

   });
   
   // 캘린더 그리기
   calendar.render();
 
   //범례 추가
   const legend = `
      <div class="legend-item">
        <span class="legend-color legend-facility"></span> 시설 점검
        <span class="legend-color legend-community"></span> 커뮤니티 점검      
      </div>
   `;
   
   //내부 헤더에 범례 삽입
   const headerinsert = document.querySelector(".fc-header-toolbar .fc-toolbar-chunk:last-child");
   if(headerinsert){
	   
	// element.                        position, htmlString
	   headerinsert.insertAdjacentHTML("beforeend",legend)  //insertAdjacentHTML은 DOM API 메서드
   } 
   
  
   }); //전체 끝
    
 </script>
 

</head>
<body>


<!--// body 시작 //-->

  
<!-- 실제 화면을 담을 영역 -->

  <div id="Wrapper">
      <div id='calendar'></div>
  </div>
    
    
<!--상세보기 모달 시작-->   

<input type="hidden" id="detailschdulSn" name="detailschdulSn" value="${fxVO.schdulSn}" />

<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <!-- 헤더 -->
      <div class="modal-header">
        <h5 class="modal-title" id="detailModalLabel">상세 보기</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <!-- 바디 -->
      <div class="modal-body">
      <div class="modal-scroll-area">
        <form id="detailscheduleForm">
          <div class="form-group row" style="display:none;">
            <label class="col-sm-2 col-form-label">담당자</label>
            <div class="col-sm-10">
              <input type="hidden" id="detailempId" name="detailempId" class="form-control">
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">제목</label>
            <div class="col-sm-10">
              <input type="text" id="detailfxSj" name="detailfxSj" class="form-control" readonly >
            </div>
          </div>

          <div class="form-group row" style="display:none;">
            <label class="col-sm-2 col-form-label">구분</label>
            <div class="col-sm-10">
              <select id="detailfxIem" name="detailfxIem" class="form-control">
                <option value="">선택</option>
                <option value="시설">시설</option>
                <option value="커뮤니티">커뮤니티</option>
                <option value="개인일정">개인일정</option>
              </select>
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">시작일시</label>
            <div class="col-sm-4">
              <input type="datetime-local" id="detailfxBeginDt" name="detailfxBeginDt" class="form-control" readonly>
            </div>
            <label class="col-sm-2 col-form-label text-right">종료일시</label>
            <div class="col-sm-4">
              <input type="datetime-local" id="detailfxEndDt" name="detailfxEndDt" class="form-control" readonly>
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">내용</label>
            <div class="col-sm-10">
              <textarea id="detailfxCn" name="detailfxCn" class="form-control" rows="3" readonly ></textarea>
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">장소</label>
            <div class="col-sm-10">
              <input type="text" id="detailfxPlace" name="detailfxPlace" class="form-control" readonly>
            </div>
          </div>
        </form>
      </div>

      <!-- 푸터 -->
      <div class="modal-footer">
      </div>
      </div>
    </div>
  </div>
</div>

<!--상세보기 모달 끝-->    

<!--// body 끝 //-->

 <%@ include file="../include/footer.jsp"%>
 

 
 
</body>
</html>