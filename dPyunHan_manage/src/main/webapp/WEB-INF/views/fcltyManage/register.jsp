<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<%@ include file="../include/header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/css/filter.css">
<title></title>

<style>


  /* 공통 입력칸 폭 설정 */
  .form-control {
    width: 80% !important;
  }

  /* 시설관리 일정 전용 — 같은 줄 안에서 균형 맞추기 */
  .d-flex {
    display: flex;
    align-items: center;
    gap: 10px; /* 사이 간격 */
    width: 80%; /* 전체 폭 위 칸들과 동일하게 */
  }

  .d-flex input {
    flex: 1; /* 두 날짜칸을 균등 분배 */
  }

  .d-flex span {
    flex: 0 0 auto;
  }
  
 .card-footer{
   padding-left: 30px;
   background-color:white;
   
  }
  
.card-header {
  display: flex !important;            /* 꼭 필요 */
  justify-content: center !important;  /* 가운데 정렬 */
  align-items: center;                 /* 세로 방향 정렬도 맞춤 */
} 


</style>

<script>

document.addEventListener("DOMContentLoaded",function(){

     const fcltySelect = document.querySelector("#fcltySnId")    //시설/보안 정보 select
     const cmmitySelect = document.querySelector("#cmmitySnId")   //커뮤니티 정보 select
     const fcltyPeriod = document.querySelector("#period")      //총 소요 예정기간 input text
	 const hidenPeriod = document.querySelector("#hiddenper")    //총 소요 예정기간 input hidden
	 const strDate = document.querySelector("#startDate")       //시설 관리 일정(시작일)
     const enDate = document.querySelector("#endDate")         //시설 관리 일정(종료일)


     fcltySelect.addEventListener("change",function(){  //시설선택
		if(fcltySelect.value != ""){
			cmmitySelect.value = "";
			cmmitySelect.disabled=true;
		}else{
			cmmitySelect.disabled=false;
		}
	 });

	 cmmitySelect.addEventListener("change",function(){  //커뮤니티 선택
		if(cmmitySelect.value != ""){
			fcltySelect.value = "";
			fcltySelect.disabled=true;
		}else{
			fcltySelect.disabled=false;
		}
	 });
	 
    
	 let newstrDate = "";   //총 소요 예정시간 계산
	 let newenDate = "";
	 
	strDate.addEventListener("change",function(){
		
		  newstrDate  = new Date(strDate.value);
		  
		
		  if(strDate.value && enDate.value){  // 시작일(strDate)과 종료일(enDate)이 모두 입력되어 있을 경우 실행
			  			 
		      const start = new Date(strDate.value);
		      const end = new Date(enDate.value);
			  
			  //날짜 기준으로 비교(시간 제거) 
			  const startDay = new Date(start.getFullYear(), start.getMonth(), start.getDate());
			  const endDay = new Date(end.getFullYear(), end.getMonth(), end.getDate());
			  
			  let days = (endDay - startDay) / (1000 * 60 * 60 * 24) +1;
	          if (days<1) days = 1;
	          			  
			  // 계산된 기간 값을 숨은 입력 필드에 저장
			  hidenPeriod.value = days;
			  // 시설 이용 기간 필드에 '일' 단위로 반올림된 값 표시
			  fcltyPeriod.value = Math.floor(days) + "일"; //floor : 소수점 내림 함수
		 }
	});
		
	enDate.addEventListener("change",function(){ 
		
		 newenDate = new Date(enDate.value);
		 
		 if(strDate.value && enDate.value){
			 
			 const start = new Date(strDate.value);
		     const end = new Date(enDate.value);
			 			 
			//날짜 기준으로 비교(시간 제거) 
			  const startDay = new Date(start.getFullYear(), start.getMonth(), start.getDate());
			  const endDay = new Date(end.getFullYear(), end.getMonth(), end.getDate());
			   
			  let days = (endDay - startDay) / (1000 * 60 * 60 * 24) +1;
              if (days<1) days = 1;
			 
			  hidenPeriod.value = days;
			  fcltyPeriod.value = Math.floor(days) + "일";
		 }
	});
		

	const ok = document.querySelector("#okBtn");   //등록 버튼

	ok.addEventListener("click",function(){  //등록 버튼을 누르면

		const empId = document.querySelector("#empId").value;
        const fcltySn = document.querySelector("#fcltySnId").value;
        const cmmntySn = document.querySelector("#cmmitySnId").value;
        const fcltymanageCn = document.querySelector("#message").value;
        const fcltymanageBeginDt = document.querySelector("#startDate").value;
        const fcltymanageEndDt = document.querySelector("#endDate").value;
        
        //fcltymanagePrearngePd: "0.5006944444444444" => 당일  , "1.5006944444444446" => 2일
		const fcltymanagePrearngePd = document.querySelector("#hiddenper").value;
        const chckSttus = document.querySelector("#chckSttus").value;

        if(fcltymanageBeginDt>fcltymanageEndDt){
        	  Swal.fire({
 				  icon:'error',
 				  title: '기간 설정 오류',
 				  text: '종료일은 시작일보다 작을 수 없습니다.',
 				  confirmButtonText: '확인',
                  width: 400,
                  allowOutsideClick: false,
                  allowEscapeKey: false
 			  });
			return;
		}

		//컨트롤러에 보내는 기본 데이터
		let nhs ={
			"empId":empId,
			"fcltySn":fcltySn,
			"cmmntySn":cmmntySn,
			"fcltymanageCn":fcltymanageCn,
			"fcltymanageBeginDt":fcltymanageBeginDt,
			"fcltymanageEndDt":fcltymanageEndDt,
			"fcltymanagePrearngePd":fcltymanagePrearngePd	
		}
		
       if(fcltySn != null && fcltySn != ""){   //점검 상태 조건
		  nhs.fcltymanageChcksttus = chckSttus;  //시설 점검상태 직접 저장
		  nhs.fcltySttus = chckSttus;       //시설 테이블도 갱신
	   }else if(cmmntySn != null && cmmntySn != ""){
		  nhs.fcltymanageChcksttus = chckSttus;
		  nhs.cmmntyChcksttus = chckSttus;
	   }

		console.log("nhs :",nhs);

         fetch("/fcltyManage/registerPost",{
           method:"post",
		   headers:{'Content-Type':"application/json;charset=utf-8"},
		   body: JSON.stringify(nhs)
		})
		.then(response=>{
           return response.json();
		})
		.then(data=>{
           console.log("data",data);
           if(data.result>0){
        	   Swal.fire({
        			icon:'success', 
        			title:'등록 성공',
        			text:'등록을 완료했습니다.', 
        			confirmButtonText: '확인',
                    width: 400,
                    allowOutsideClick: false,
                    allowEscapeKey: false 			 
        		 })
        		 .then(()=>{	            	
        	        location.href="/fcltyManage/list";   //등록 후 이동할 곳
        		});
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
		.catch(erroer=>{
           console.log("erroer",erroer);
		})
	}); 
});


</script>

</head>
<body>

	<!--// body 시작 //-->
<%-- <c:forEach var="fMVO" items="${fcltyManageVoList}">
	${fMVO.empVO.nm}
</c:forEach>  우현님 예시 fMVO.EMPVO.NM 이렇게 가져올수있다--%>


  <div class="card card-warning" style="width:70%; margin-left: 15%;">
    <div class="card-header">
        <h3 class="card-title">점검 일정 등록</h3>
    </div>

    <form action="/fcltyManage/registerPost" method="post">
        <div class="card-body" style="padding-left:200px;">
            <div class="form-group">
                <label>담당자</label>
                <select id="empId" name="empId" class="form-control">
                    <option value="">---선택하세요---</option>
                    <c:forEach var="emp" items="${empList}">
                        <option value="${emp.empId}">${emp.nm}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>시설/보안 정보</label>
                <select id="fcltySnId" name="fcltySnId" class="form-control">
                    <option value="">---선택하세요---</option>
                    <c:forEach var="fclty" items="${fcltyVOList}">
                        <option value="${fclty.fcltySn}">${fclty.fcltyNm} (${fclty.fcltyLc})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>커뮤니티 정보</label>
                <select id="cmmitySnId" name="cmmitySnId" class="form-control">
                    <option value="">---선택하세요---</option>
                    <c:forEach var="cmmnty" items="${cmmntyVOList}">
                        <option value="${cmmnty.cmmntySn}">${cmmnty.cmmntyNm}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>시설관리 내용</label>
                <textarea id="message" name="message" class="form-control" rows="4" placeholder="내용을 입력하세요"></textarea>
            </div>

            <div class="form-group">
                <label>점검 상태</label>
                <select id="chckSttus" name="chckSttus" class="form-control">
                    <option value="">---선택하세요---</option>
                    <option value="점검예정">점검예정</option>
                    <option value="점검중">점검중</option>
                </select>
            </div>

            <div class="form-group">
                <label>시설관리 일시</label>
                <div class="d-flex">
                    <input type="datetime-local" id="startDate" name="startDate" class="form-control me-2">
                    <span class="mx-2">~</span>
                    <input type="datetime-local" id="endDate" name="endDate" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label>총 소요 예정기간</label>
                <input type="hidden" id="hiddenper" name="hiddenper" value="${FcltyManageVO.fcltymanagePrearngePd}">
                <input type="text" id="period" name="period" class="form-control" readonly>
            </div>
        </div>
		     		     
		       <div class="card-footer" style="margin-left:1px; margin-right:1px; border-radius:0;">
                  <button type="button" class="btn btn-primary" id="okBtn">등록</button>
                  <button type="reset" class="btn btn-warning" id="cancelBtn" style="margin-left:10px;">취소</button>
                </div>
		     		     
	</form>
         </div>

	<!--// body 끝 //-->

 <%@ include file="../include/footer.jsp"%>
</body>
</html>
