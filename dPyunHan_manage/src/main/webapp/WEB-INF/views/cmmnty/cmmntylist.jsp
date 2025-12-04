<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link rel="stylesheet" href="/css/filter.css">

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<%@ include file="../include/header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/css/filter.css">
<title></title>

<style>

/* 공통 카드별 상단 영역 시작 */

body { /* 그냥 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}

.card {
	padding: 0.3rem !important;
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

.card-header .card-title {
	font-size: 1.2rem !important; /* 글자 크기 */
	font-weight: 700 !important;
	/* 글자 두께 살짝 굵게  400이 기본, 700이 bord정도 입니다. */
	padding-top: 4px !important; /* 상단패딩*/
	padding-bottom: 4px !important;
}

/* 공통 카드별 상단 영역 끝 */
.card-body {
	padding: 1rem !important;
}

.card-footer {
	padding: 1rem !important;
	background-color:white;
	margin-left:10px;
}


/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 시작 */
.tight-table, .tight-table th, .tight-table td {
	padding: 10px 15px !important; /* 테이블들 행간격 */
	overflow: hidden !important; /* 삐져나가는거 잡아줘요 */
	text-overflow: ellipsis; /* 길어진 글은 ...처리 */
	white-space: nowrap; /* 줄바꿈 X */
	text-align: center;
}
/* 줄무늬 효과(odd는 홀수, even은 짝수) */
.tight-table tbody tr:nth-child(odd) {
	background-color: #ffffff; /* 흰색 */
}

.tight-table tbody tr:nth-child(even) {
	background-color: #f1f4fa; /* 연한 회색(AdminLTE 느낌) */
}


/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 끝 */
/* 호버이벤트 시작 */
/* tight-table호버이벤트시작 */
.table tbody tr {
	transition: background-color 0.25s ease, box-shadow 0.25s ease,
		transform 0.2s ease;
}

.table tbody tr:hover {
	background-color: rgba(100, 140, 164, 0.12) !important; /* 은은한 파스텔 */
	box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15); /* 은은한 그림자 */
	transform: translateY(-1px); /* 살짝 띄우기 */
	cursor: pointer;
}
/* 호버이벤트 끝 */

/* 모달 css영역 시작입니다 */
/* 모달 프레임 자체 */
#schmodal .modal-dialog {
    max-width: 700px;   /* 원하는 크기 */
    width: 700px;
}

.modal .modal-content{
	border: 0 !important;
	border-radius: 14px !important;
	box-shadow: 0 6px 24px rgba(0, 0, 0, .12) !important;
	overflow: hidden !important;
}

/* 헤더 영역 */
.modal .modal-header{
	background: rgba(100, 140, 164, .85) !important;
	color: #fff !important;
	padding: .6rem .9rem !important;
}

/* 제목(좌측) */
.modal .modal-title{
	font-size: 1rem !important;
	display: flex !important;
	gap: .5rem !important;
	align-items: center !important;
	margin: 0 !important;
}

.modal .modal-title small {
	font-size: .85rem !important;
}

/* 닫기 버튼 */
.modal .close, .cute-modal .btn-close, .cute-modal .btn-close-white
	{
	color: #fff !important;
	opacity: .9 !important;
	text-shadow: none !important;
}


.closeBtn{
 background-color: transparent;
 border:0;
 font-size:1.5em;
 color:white;
}

#closeModal{
  font-size:1.5em;
}


.modal .close:hover, .cute-modal .btn-close:hover, .cute-modal .btn-close-white:hover
	{
	opacity: 1 !important;
}

/* 모달 css영역 끝 입니다 */

</style>

<script>

document.addEventListener("DOMContentLoaded",function(){
	
$(".openmodal").on("click",function(e){  //점검 상태를 누르면
	  e.preventDefault();

	console.log("모달 클릭");
	
    //클릭한 시설 상태의 데이터 값 가져오기
    const sn = $(this).data("sn");
    const cnm = $(this).data("cnm");
    const ccl = $(this).data("ccl");
    const ccs = $(this).data("ccs");
    const ccd = $(this).data("ccd");
    
    $("#statusModal").show();  //시설 상태 수정 모달 열기

    //register.jsp의 값 가져오기
   $("#cmmntySn").val(sn); 
   $("#cmmntyNm").val(cnm);
   $("#cmmntyclock").text(ccl);
   $("#cmmntyChcksttus").val(ccs);
   $("#cmmntyChckDt").val(ccd);

  
   //모달 닫기
   $("#closeModal").on("click",function(){
       $("#statusModal").hide();
   })
     
   
  });  //openmodal 끝
  
	const deleteBtn =  document.querySelector("#remove");
	
	deleteBtn.addEventListener("click",function(){ //삭제버튼을 누르면
	       
		 Swal.fire({
			icon:'warning', 
			title:'삭제 확인 요청',
			text:'정말 삭제하시겠습니까?', 
			confirmButtonText: '확인',
            width: 400,
            allowOutsideClick: false,
            allowEscapeKey: false 			 
		 });
	});
	
	document.addEventListener("keydown",function(e){  //esc 눌러도 모달 꺼지게
		 if(e.key=="Escape"){
			 $("#statusModal").hide();
			 $("#schmodal").hide();
		 }
	});
	
  
//===============점검 일정 등록 모달===============================================
	
   const inBtn = document.querySelector("#insertBtn");

   inBtn.addEventListener("click",function(e){  //점검 일정 등록 버튼을 누르면

	 e.preventDefault();

     $("#schmodal").show();
     
	 console.log("점검일정등록 버튼 클릭");

	  
      const fcltySelect = document.querySelector("#fcltySnId");    //시설/보안 정보 select
      const cmmitySelect = document.querySelector("#cmmitySnId");  //커뮤니티 정보 select
      const fcltyPeriod = document.querySelector("#period");      //총 소요 예정기간 input text
 	  const hidenPeriod = document.querySelector("#hiddenper");    //총 소요 예정기간 input hidden
 	  const strDate = document.querySelector("#startDate");       //시설 관리 일정(시작일)
      const enDate = document.querySelector("#endDate");         //시설 관리 일정(종료일)


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
	 			  fcltyPeriod.value = Math.floor(days) + "일";     //floor : 소수점 내림 함수
	 		 } //if 끝
	 	}); //strDate 끝
	 		
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
	 	}); //enDate 끝
	 		

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
	 	}); //ok 버튼 끝
	 });  //inBtn 끝

     const closchBtn = document.querySelector("#closeschModal");
    
     closchBtn.addEventListener("click",function(){
    	 $("#schmodal").hide();
    	 
     });

  });//전체 끝

</script>

</head>
<body>

<!--// body 시작 //-->

<div class="card card bg-light">  <!-- 색상 지정 -->
              <div class="card-header">  
                <h3 class="card-title">커뮤니티 목록</h3>
              </div>
              <!-- /.card-header  -->
              <div class="card-body" style="overflow-x:hidden;">
              
      <!-- 검색필터 시작 -->
	 <form action="/" method="get" class="filter-form">
		 <div class="filter-card">
		   <div class="filter-card-header">
		     <h3 class="filter-card-title">검색 필터</h3>
		     <button type="button" class="filter-btn-toggle" onclick="toggleFilter()">
		       <span class="filter-toggle-text">설정</span>
		       <i class="fas fa-chevron-down"></i>
		     </button>
		   </div>
		   
		   <div class="filter-card-body collapsed" id="filterBody">
		     <!-- Row 1 -->
		     <div class="filter-row">
		       
		       <!-- 검색 필드 셀 -->
		       <div class="filter-cell">
		         <div class="filter-cell-label">검색 필드</div>
		         <div class="filter-cell-content">
		           <div class="filter-control-inline">
		             <label class="filter-checkbox">
		               <input type="checkbox" name="searchField" value="sercmmntyNm"/>
		               <span>커뮤니티 이름</span>
		             </label>
		           </div>
		         </div>
		       </div>
		       
		       <!-- 정렬 셀 -->
		       <div class="filter-cell">
		         <div class="filter-cell-label">정렬</div>
		         <div class="filter-cell-content">
		           <div class="filter-control-inline">
		             <label class="filter-radio">
		               <input type="radio" name="sortOrder" value="desc" checked/>
		               <span>최신순</span>
		             </label>
		             <label class="filter-radio">
		               <input type="radio" name="sortOrder" value="asc" />
		               <span>오래된순</span>
		             </label>
		           </div>
		         </div>
		       </div>
		       
		       <!-- 상태 셀 -->
		       <div class="filter-cell">
		         <div class="filter-cell-label">점검 상태</div>
		         <div class="filter-cell-content">
		           <select name="status" class="filter-control">
		             <option value="">전체</option>
		             <option value="정상">정상</option>
		             <option value="점검예정">점검예정</option>
		             <option value="점검완료">점검완료</option>
		             <option value="점검중">점검중</option>
		           </select>
		         </div>
		       </div>
		
		       <!-- 날짜 범위 셀 -->
		       <div class="filter-cell">
		         <div class="filter-cell-label">최근 점검 일자</div>
		         <div class="filter-cell-content">
		           <div class="filter-input-group">
		             <input type="date" name="startDate" class="filter-control" 
		                    value="${param.startDate}" />
		             <span class="filter-input-group-text">~</span>
		             <input type="date" name="endDate" class="filter-control" 
		                    value="${param.endDate}" />
		           </div>
		         </div>
		       </div>
		       
		     </div>
		   </div>
		
		   <div class="filter-search-footer">
		     <div class="filter-search-wrapper">
		       <input type="text" name="keyword" class="filter-input" 
		              placeholder="검색어..." 
		              value="${keyword}" />
		      </div>
		      <button type="submit" class="filter-btn filter-btn-primary">검색</button>
		      <a href="/" class="filter-btn filter-btn-secondary">초기화</a>		           
		    </div>
		  </div>
	</form>

		<script>
		function toggleFilter() {
		  const filterBody = document.getElementById('filterBody');
		  const toggleBtn = document.querySelector('.filter-btn-toggle i');
		  
		  filterBody.classList.toggle('collapsed');
		  toggleBtn.classList.toggle('rotated');
		}
		</script>

 <!-- 검색필터 끝 -->
 
 <!-- body 시작 -->
 <div>
 <button type="button" style="background-color:mediumseagreen;color:white;border-radius: 4px;border: 0;height: 26px; margin-left:1450px; margin-bottom:15px;">커뮤니티 등록 </button>    <!-- 작동안해요 보여주기식 --> 
 <button type="button" id="insertBtn" style="background-color:mediumseagreen;color:white;border-radius: 4px;border: 0;height: 26px; margin-bottom:10px;">점검일정 등록</button>    <!-- 작동안해요 보여주기식 --> 
 <button type="button" id="remove" style="background-color:mediumseagreen;color:white;border-radius: 4px;border: 0;height: 26px; margin-bottom:10px;">선택 삭제</button>    <!-- 작동안해요 보여주기식 --> 
 <button type="button" style="background-color:mediumseagreen;color:white;border-radius: 4px;border: 0;height: 26px; margin-bottom:10px;">Excel 다운로드</button>    <!-- 작동안해요 보여주기식 --> 
 </div>  
             
                <table class="table tight-table" style="border-top: 2px solid #e6e6e6;">   <!-- 기능 지정 -->
                  <thead>
                    <tr>  <!-- 색상 지정 -->
                      <th></th>
                      <th class="col-1">순번</th>
                      <th class="col-3">커뮤니티 이름</th>
                      <th class="col-3">운영 시간</th>
                      <th class="col-3">최근 점검 일자</th>
                      <th class="col-2">점검 상태</th>
                    </tr>
                  </thead>
                  <tbody id="rowlist">
                  <c:forEach items="${cmmntyVOList}" var="CmmntyVO" varStatus="status">
                    <tr>
                      <td style="vertical-align: middle;"><input type="checkbox" style="margin-left:20px;"/> </td>
                      <td>${status.index + 1}</td>
                      <td>${CmmntyVO.cmmntyNm}</td>
                      <td>
                        <img src="https://ssl.nexon.com/s2/game/maplestory/renewal/common/sub_date_new.png" alt="시계 아이콘">
                       ${CmmntyVO.cmmntyOpnVwpoint} ~ ${CmmntyVO.cmmntyClosVwpoint}
                       </td>
                      <td><fmt:formatDate value="${CmmntyVO.cmmntyChckDt}" pattern="yyyy-MM-dd" /></td>
                      <td>
                          <a href="#" class="openmodal" 
                            data-sn="${CmmntyVO.cmmntySn}"                          
                            data-cnm="${CmmntyVO.cmmntyNm}"                          
                            data-ccl="${CmmntyVO.cmmntyOpnVwpoint}~${CmmntyVO.cmmntyClosVwpoint}"                          
                            data-ccs="${CmmntyVO.cmmntyChcksttus}"
                            data-ccd="<fmt:formatDate value='${CmmntyVO.cmmntyChckDt}' pattern='yyyy-MM-dd'/>">                         
                            ${CmmntyVO.cmmntyChcksttus}
                          </a>
                        </td>     
                    </tr>
                     </c:forEach>
                     </tbody>
                    </table> 
                                      

              
       <!-- 페이징 처리부분 -->
	      <div class="card-footer clearfix">
	  <ul class="pagination pagination-sm m-0 float-right">
	    
	    <!-- 이전 버튼 -->
	    <c:if test="${articlePage.startPage >= 6}">
	      <li class="page-item">
	        <a class="page-link" href="/cmmnty/cmmntylist?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}">«</a>
	      </li>
	    </c:if>
	    <c:if test="${articlePage.startPage < 6}">
	      <li class="page-item disabled">
	        <a class="page-link" href="#">«</a>
	      </li>
	    </c:if>
	
	    <!-- 페이지 번호 -->
		    <c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}">
		      <li class="page-item <c:if test='${pNo == articlePage.currentPage}'>active</c:if>">
		        <a class="page-link" href="/cmmnty/cmmntylist?currentPage=${pNo}&keyword=${param.keyword}">
		          ${pNo}
		        </a>
		      </li>
		    </c:forEach>
		
		    <!-- 다음 버튼 -->
		    <c:if test="${articlePage.endPage != articlePage.totalPages}">
		      <li class="page-item">
		        <a class="page-link" href="/cmmnty/cmmntylist?currentPage=${articlePage.startPage+5}&keyword=${param.keyword}">»</a>
		      </li>
		    </c:if>
		    <c:if test="${articlePage.endPage == articlePage.totalPages}">
		      <li class="page-item disabled">
		        <a class="page-link" href="#">»</a>
		      </li>
		    </c:if>
		  </ul>
		</div>
	<!-- 페이징 처리 끝-->             
            </div>
          </div>          

 <!-- body 끝 -->

<!-- 시설 상태 수정 모달 -->
  <div id="statusModal" class="modal" style="display:none;">
  
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">   <!-- 색상 지정 -->
       <h5 class="modal-title">커뮤니티 상태 변경</h5>
       <button type="button" class="close" id="closeModal">X</button>     
      </div>
      <div class="modal-body">
        <input type="hidden" id= "cmmntySn" name="cmmntySn" value="${CmmntyVO.cmmntySn}" />
          <%@ include file="/WEB-INF/views/cmmnty/cmmntyregister.jsp" %>
     </div>
    </div>
    </div>
  </div>
  
  
<!-- 점검일정 등록 모달 -->  
 <div id="schmodal" class="modal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
          <h5 class="modal-title">점검 일정 등록</h5>
          <button type="button" class="closeBtn" id="closeschModal">X</button>
      </div>
      <div class="modal-body">
          
        <form id="cmmntyform">
        <div class="card-body" style="padding-left:200px;">
        
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
                <label>시설/보안 정보</label>
                <select id="fcltySnId" name="fcltySnId" class="form-control" disabled> 
                    <option value="">---선택하세요---</option>
                    <c:forEach var="fclty" items="${fcltyVOList}">
                        <option value="${fclty.fcltySn}">${fclty.fcltyNm} (${fclty.fcltyLc})</option>
                    </c:forEach>
                </select>
            </div>


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
		     		     
	</form>  
    
      </div>  <!-- body -->    
		       <div class="card-footer">
                  <button type="button" class="btn btn-primary" id="okBtn">등록</button>
                  <button type="reset" class="btn btn-warning" id="cancelBtn" style="margin-left:10px;">취소</button>
                </div>
		     		     
    </div> <!-- content -->
  </div>
 </div>


<!--// body 끝 //-->

 <%@ include file="../include/footer.jsp"%>
</body>
</html>