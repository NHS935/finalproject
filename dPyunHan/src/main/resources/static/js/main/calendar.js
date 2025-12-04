/*document.addEventListener("DOMContentLoaded", function() {
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
        locale: 'ko',        // 언어 설정
        selectable: false,    // 영역 선택
        selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
        navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
        weekNumbers: true,   // WeekNumber 출력여부, default false
        editable: false,      // 입주민은 수정 불가 
        // 시작일 및 기간 수정가능여부
        // eventStartEditable: false,
        // eventDurationEditable: true,
       
        dayMaxEventRows: true,  // Row 높이보다 많으면 +숫자 more 링크 보임!
        nowIndicator: true,
        events: function(info, successCallback, failureCallback) {
            const url = "/fx/listAjax";
            $.ajax({
                url: url,
                contentType: "application/json",
                type: 'get',
                dataType: 'json',
                success: function(param) {
                    var events = [];
                    console.log("param : ", param);
                    $.each(param, function(index, data) {
                        console.log("data : ", data);
                        //구분(시설,커뮤니티,일정)에 따라 색상 다르게 반영
                        let bgColor = "";
                        let texColor = "white";

                        switch (data.fxIem) {
                            case "커뮤니티":
                                bgColor = "lightblue";
                                break;
                            case "개인일정":
                                bgColor = "lightgreen";
                                texColor = "black";
                                break;
                        }
                        events.push({
                            id: data.schdulSn,
                            title: data.fxSj,
                            start: data.fxBeginDt,
                            end: data.fxEndDt,
                            allDay: false,
                            backgroundColor: bgColor, //배경색
                            textColor: texColor,    //글자색
                            extendedProps: {  //추가 데이터
                                empId: data.empId,
                                fxIem: data.fxIem,
                                fxCn: data.fxCn,
                                fxPlace: data.fxPlace
                            }
                        });
                    })
                    successCallback(events);
                }
            });
        }
    }
	
	const calendarEl = document.querySelector("#calendar");
	
    // 캘린더 생성
    const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
    // 모달 인스턴스
    const modalEl = document.getElementById("calendarModal");
    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
    //일정 클릭 시 상세보기
    calendar.on("eventClick", function(info) {  //info:fullcalendar가 event를 클릭했을때 자동으로 전달해주는 객체
        console.log("info.event: ", info.event);
        const period = info.event;
		
		console.log("period.extendedProps : ", period.extendedProps);
		
        document.getElementById("calendarempId").value = period.extendedProps.empId;
        document.getElementById("calendarSj").value = period.title;
        document.getElementById("calendarIem").value = period.extendedProps.fxIem;
        document.getElementById("calendarBeginDt").value = period.startStr.substring(0, 16);
        document.getElementById("calendarEndDt").value = period.endStr.substring(0, 16);
        document.getElementById("calendarCn").value = period.extendedProps.fxCn;
        document.getElementById("calendarPlace").value = period.extendedProps.fxPlace;
	    modal.show();

    });
    // 캘린더 그리기
    calendar.render();
}); //전체 끝*/