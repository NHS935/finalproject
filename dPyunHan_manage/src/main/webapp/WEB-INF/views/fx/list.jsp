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
    
<title></title>

<!-- 캘린더 스타일 지정 -->

<style>
 
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
/* .fc-event {
  background-color: plum;
  color: blueviolet;
  border-radius: 3px;
}  */

  /* Week number 색상 */
  .fc .fc-daygrid-week-number {
    color: #888888;
  }

.calendar-legend {
    display: flex;
    gap: 20px;
    margin: 10px 0;
    font-size: 14px;
    font-weight: 500;
  }

  .legend-item {
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .legend-color {
    width: 14px;
    height: 14px;
    border-radius: 50%;
    display: inline-block;
  }

  .legend-facility { background-color: plum; }
  .legend-community { background-color: lightblue; }
  .legend-personal { background-color: lightgreen; }

</style>


 <script>
 
  document.addEventListener("DOMContentLoaded",function(){
   
   //캘린더 
  
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
         selectable: true,    // 영역 선택
         selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
         navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
         weekNumbers: false,   // WeekNumber 출력여부, default false
         editable: true,      // event(일정) 
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
                    	
                        console.log("listAjax=>data : ", data);
                        
                      //document.querySelector("#empId").value=data.empId;
                        
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
                           
                        case "개인일정":
                             bgColor="lightgreen";
                             texColor="black";
                             break;
                      }

                        events.push({
                            id:data.schdulSn,
                            title:data.fxSj,
                            start:data.fxBeginDt,
                            end:data.fxEndDt,
                            allDay:false,
                            color:bgColor, //배경색
                            textColor:texColor,    //글자색 
                            display:'block',
                            extendedProps:{  //추가 데이터
                               empId:data.empId,
                               nm:data.nm,
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
     // 캘린더 그리기
     calendar.render();

     // 캘린더 이벤트 등록
     calendar.on("eventAdd", info => console.log("Add:", info));
     calendar.on("eventChange", info => console.log("Change:", info));
     calendar.on("eventRemove", info => console.log("Remove:", info));
     calendar.on("eventClick", info => {
         console.log("eClick:", info);
         console.log('Event: ', info.event.extendedProps);
         console.log('Coordinates: ', info.jsEvent);
         console.log('View: ', info.view);
         
     });

     calendar.on("eventMouseEnter", info => console.log("eEnter:", info));
     calendar.on("eventMouseLeave", info => console.log("eLeave:", info));
     calendar.on("dateClick", info => console.log("dateClick:", info));
     calendar.on("select", info => {
         console.log("체크:", info);

     document.querySelector("#fxBeginDt").value = info.startStr;
     document.querySelector("#fxEndDt").value = info.endStr;

    fxBeginDt.value = info.startStr;   //달력화면에서 날짜 클릭 or 드래크해서 일정 영역을 선택했을때 실행
    fxEndDt.value = info.endStr;

         $("#scheduleModal").modal('show');
   });



    //데이터값
    const modalBtn =  document.querySelector("#registerBtn");

    modalBtn.addEventListener("click",function(e){   //일정 추가 버튼을 누르면

          e.preventDefault();

        $("#scheduleModal").modal('show');
    });


    const saveBtnn = document.querySelector("#saveBtn");
    
    saveBtnn.addEventListener("click",function(){  //등록 버튼을 누르면
      
      console.log("아무거나");	
    	
       const schdulSn = document.querySelector("#schdulSn").value;
       const empId  = document.querySelector("#empId").value;
       const fxSj = document.querySelector("#fxSj").value;
       const fxIem = document.querySelector("#fxIem").value;
       const fxBeginDt = document.querySelector("#fxBeginDt").value;
       const fxEndDt = document.querySelector("#fxEndDt").value;
       const fxCn = document.querySelector("#fxCn").value;
       const fxPlace = document.querySelector("#fxPlace").value;

       let nhs={
         "schdulSn":schdulSn,
         "empId":empId,
         "fxSj":fxSj,
         "fxIem":fxIem,
         "fxBeginDt":fxBeginDt,
         "fxEndDt":fxEndDt,
         "fxCn":fxCn,
         "fxPlace":fxPlace
       }

       console.log("nhs(이름값 확인)",nhs);
       
       //일정 등록 요청
       
      fetch("/fx/insert",{
        method:"post",
        headers:{'Content-Type':"application/json;charset=utf-8"},
        body:JSON.stringify(nhs)
      })
      .then(response=>{
        return response.text();
      })
      .then(result=>{
        console.log("result :",result);

        if(result=="success"){
        	
        	Swal.fire({
     			icon:'success', 
     			title:'등록 성공',
     			text:'등록을 완료했습니다.', 
     			confirmButtonText: '확인',
                 width: 400,
                 allowOutsideClick: false,
                 allowEscapeKey: false 			 
     		 });
     		 
          $("#scheduleModal").modal('hide');  //모달 닫기
          $("#scheduleForm")[0].reset();
          calendar.refetchEvents();
        }else{
        	Swal.fire({
     			icon:'error', 
     			title:'등록 실패',
     			text:'등록을 실패했습니다.', 
     			confirmButtonText: '확인',
                 width: 400,
                 allowOutsideClick: false,
                 allowEscapeKey: false 			 
     		 });
        }
      })
      .catch(error=>{
        console.log("error : ",error);
      })
      
    })
    

   //일정 클릭 시 상세보기

   calendar.on("eventClick",function(info){  //info:fullcalendar가 event를 클릭했을때 자동으로 전달해주는 객체

     console.log("info.event: ",info.event);

      const period = info.event;

     //수정모달 일련번호 넣기
     $("#detailschdulSn").val(period.id);
      
      //이전 모달 내용 가지고오기
       $("#detailempId").val(period.extendedProps.empId);
       $("#detailnm").val(period.extendedProps.nm);
       $("#detailfxSj").val(period.title);
       $("#detailfxIem").val(period.extendedProps.fxIem);
       $("#detailfxBeginDt").val(period.startStr.substring(0,16));
       $("#detailfxEndDt").val(period.endStr.substring(0,16));
       $("#detailfxCn").val(period.extendedProps.fxCn);
       $("#detailfxPlace").val(period.extendedProps.fxPlace);
  
       //모달 띄우기
       $("#detailModal").modal('show');

   });
   
  
    const modifyBtn =  document.querySelector("#detailsaveBtn");

    modifyBtn.addEventListener("click",function(){  //수정 버튼을 누르면
  
       const schdulSn = document.querySelector("#detailschdulSn").value;
       const empId  = document.querySelector("#detailempId").value;
       const fxSj = document.querySelector("#detailfxSj").value;
       const fxIem = document.querySelector("#detailfxIem").value;
       const fxBeginDt = document.querySelector("#detailfxBeginDt").value;
       const fxEndDt = document.querySelector("#detailfxEndDt").value;
       const fxCn = document.querySelector("#detailfxCn").value;
       const fxPlace = document.querySelector("#detailfxPlace").value;

       let nhs={
         "schdulSn":schdulSn,
         "empId":empId,
         "fxSj":fxSj,
         "fxIem":fxIem,
         "fxBeginDt":fxBeginDt,
         "fxEndDt":fxEndDt,
         "fxCn":fxCn,
         "fxPlace":fxPlace
       }

        //일정 수정 요청
       
      fetch("/fx/modify",{
        method:"post",
        headers:{'Content-Type':"application/json;charset=utf-8"},
        body:JSON.stringify(nhs)
      })
      .then(response=>{
        return response.text();
      })
      .then(result=>{
        console.log("result :",result);

        if(result=="success"){
        	Swal.fire({
      			icon:'success', 
      			title:'수정 성공',
      			text:'수정을 완료했습니다.', 
      			confirmButtonText: '확인',
                  width: 400,
                  allowOutsideClick: false,
                  allowEscapeKey: false 			 
      		 });
        	
          $("#detailModal").modal('hide');  //모달 닫기
          calendar.refetchEvents();
        }else{
        	Swal.fire({
      			icon:'error', 
      			title:'수정 실패',
      			text:'수정에 실패했습니다.', 
      			confirmButtonText: '확인',
                  width: 400,
                  allowOutsideClick: false,
                  allowEscapeKey: false 			 
      		 });
        }
      })
      .catch(error=>{
        console.log("error : ",error);
      })
      
    })

    });
    
 </script>
 

<!--// body 시작 //-->

  
 <!-- 범례 표시 -->  
 
 <div class="calendar-legend">
 
  
    <div class="legend-item">
        <span class="legend-color legend-facility"></span> 시설 점검
    </div>
    <div class="legend-item">
        <span class="legend-color legend-community"></span> 커뮤니티 점검
    </div>
    <div class="legend-item">
        <span class="legend-color legend-personal"></span> 개인일정
    </div>
    
  <button type="button" id="registerBtn" style="background-color:mediumseagreen; color:white; border-radius: 4px; border: 0; height: 26px; margin-bottom:10px; margin-left:1430px">일정 등록</button>  
</div> 
  
<!-- 실제 화면을 담을 영역 -->
  <div class="card card bg-light">
  <div id="Wrapper">
      <div id='calendar' class="myCalendar"></div>	<!-- myCalendar 클래스 병호가 추가함. 추 후 버튼색상 등 class명 이용할 예정 -->
  </div>
  </div>
    
<!-- 일정 등록 모달 시작 -->

<input type="hidden" id="schdulSn" name="schdulSn" value="${fxVO.schdulSn}" />

<div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <!-- 헤더 -->
      <div class="modal-header bg-warning disabled">
        <h5 class="modal-title" id="scheduleModalLabel">일정 등록</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <!-- 바디 -->
      <div class="modal-body">
        <form id="scheduleForm">
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">담당자</label>
            <div class="col-sm-10">
            <select id="empId" name="empId" class="form-control">
              <option>---선택하세요---</option>
               <c:forEach var="fxemp" items="${empList}">
                 <option value="${fxemp.empId}">${fxemp.nm}</option>
               </c:forEach>
            </select>
               </div>         
            </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">제목</label>
            <div class="col-sm-10">
              <input type="text" id="fxSj" name="fxSj" class="form-control" placeholder="제목 입력">
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">구분</label>
            <div class="col-sm-10">
              <select id="fxIem" name="fxIem" class="form-control">
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
              <input type="datetime-local" id="fxBeginDt" name="fxBeginDt" class="form-control">
            </div>
            <label class="col-sm-2 col-form-label text-right">종료일시</label>
            <div class="col-sm-4">
              <input type="datetime-local" id="fxEndDt" name="fxEndDt" class="form-control">
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">내용</label>
            <div class="col-sm-10">
              <textarea id="fxCn" name="fxCn" class="form-control" rows="3" placeholder="내용 입력"></textarea>
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">장소</label>
            <div class="col-sm-10">
              <input type="text" id="fxPlace" name="fxPlace" class="form-control" placeholder="장소 입력">
            </div>
          </div>
        </form>
      </div>

      <!-- 푸터 -->
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="saveBtn">등록</button>
        <button type="button" class="btn btn-warning" data-dismiss="modal">취소</button>
      </div>

    </div>
  </div>
</div>

<!-- 일정 등록 모달 끝 -->       
    


<!--상세보기 모달 시작-->   

<input type="hidden" id="detailschdulSn" name="detailschdulSn" value="${fxVO.schdulSn}" />

<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <!-- 헤더 -->
      <div class="modal-header bg-warning disabled">
        <h5 class="modal-title" id="detailModalLabel">상세 보기</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <!-- 바디 -->
      <div class="modal-body">
        <form id="detailscheduleForm">
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">담당자</label>
            <div class="col-sm-10">
            <select id="detailempId" name="detailempId" class="form-control">
              <option>---선택하세요---</option>
               <c:forEach var="fxemp" items="${empList}">
                 <option value="${fxemp.empId}">${fxemp.nm}</option>
               </c:forEach>
            </select>
               </div>         
            </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">제목</label>
            <div class="col-sm-10">
              <input type="text" id="detailfxSj" name="detailfxSj" class="form-control" >
            </div>
          </div>

          <div class="form-group row">
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
              <input type="datetime-local" id="detailfxBeginDt" name="detailfxBeginDt" class="form-control">
            </div>
            <label class="col-sm-2 col-form-label text-right">종료일시</label>
            <div class="col-sm-4">
              <input type="datetime-local" id="detailfxEndDt" name="detailfxEndDt" class="form-control">
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">내용</label>
            <div class="col-sm-10">
              <textarea id="detailfxCn" name="detailfxCn" class="form-control" rows="3" ></textarea>
            </div>
          </div>

          <div class="form-group row">
            <label class="col-sm-2 col-form-label">장소</label>
            <div class="col-sm-10">
              <input type="text" id="detailfxPlace" name="detailfxPlace" class="form-control">
            </div>
          </div>
        </form>
      </div>

      <!-- 푸터 -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" id="detailsaveBtn">수정</button>
        <button type="button" class="btn btn-warning" data-dismiss="modal">취소</button>
      </div>

    </div>
  </div>
</div>



<!--상세보기 모달 끝-->    
    
    
<!--// body 끝 //-->

 <%@ include file="../include/footer.jsp"%>
 

</body>
</html>
