<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

</style>


<script>

document.addEventListener("DOMContentLoaded",function(){

$(document).on("click", ".periodBtn", function() {  //일정등록 버튼을 누르면

 const btn=$(this);
 const tr=$(this).closest("tr"); 

 const fcltyManageSn = tr.find(".fcltyManageSn").val();   //시설관리 일련번호
 const empId = tr.find(".empId").val();   //담당자 id
 const nm = tr.find(".nm").val();   //담당자 id
 const fcltySn = tr.find(".fcltySn").val();    //시설/보안 정보
 const cmmntySn = tr.find(".cmmntySn").val();  //커뮤니티 정보
 const fcltymanageBeginDt = tr.find(".fcltymanageBeginDt").val();    //점검 시작일시
 const fcltymanageEndDt = tr.find(".fcltymanageEndDt").val();        //점검 종료일시
 const fcltymanageChcksttus = tr.find(".chckSttus").val();    //점검 상태

 
 let nhs ={    
 "fcltyManageSn":fcltyManageSn,
 "empId":empId,
 "nm":nm,
 "fcltySn":fcltySn,
 "cmmntySn":cmmntySn,
 "fcltymanageBeginDt":fcltymanageBeginDt,
 "fcltymanageEndDt":fcltymanageEndDt,
 "fcltymanageChcksttus":fcltymanageChcksttus
 }

 console.log("nhs(일정등록버튼을 누르면) : ",nhs);

fetch("/fx/schdul",{
  method:"post",
  headers:{'Content-Type':"application/json;charset=utf-8"},
  body: JSON.stringify(nhs)
})
.then(response=>{
   return response.json();
})
.then(data=>{
  if(data.status=="success"){	
   console.log("data",data);
   
   Swal.fire({
		icon:'success', 
		title:'등록 성공',
		text:'일정 등록에 성공했습니다.', 
		confirmButtonText: '확인',
        width: 400,
        allowOutsideClick: false,
        allowEscapeKey: false 			 
	 })
     .then(()=>{
   window.location.href="/fx/list";
   btn.hide();
  });
  }
})
.catch(error=>{
   console.log("error",error);
   
   Swal.fire({
		icon:'error', 
		title:'등록 실패',
		text:'일정등록에 실패했습니다.', 
		confirmButtonText: '확인',
        width: 400,
        allowOutsideClick: false,
        allowEscapeKey: false 			 
	 });
})

}); // 일정등록 버튼 끝
});// 전체 끝


</script>

</head>
<body>



<div class="card card">  <!-- 색상 지정 -->
              <div class="card-header">  
                <h3 class="card-title">시설/커뮤니티 점검 이력</h3>
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
	                <input type="checkbox" name="searchField" value="serfcltyNm" />
	                <span>시설/보안 정보</span>
	              </label>
	              <label class="filter-checkbox">
	                <input type="checkbox" name="searchField" value="sercmmntyNm" />
	                <span>커뮤니티 정보</span>
	              </label>
	              <label class="filter-checkbox">
	                <input type="checkbox" name="searchField" value="serempId"/>
	                <span>담당자</span>
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
		         <div class="filter-cell-label">점검 기간</div>
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
 
 <div style="display:flex; justify-content:flex-end; align-items:center; margin-bottom:10px; gap:20px;">

    <!-- 회색 상태 설명 -->
    <div style="display:flex; align-items:center;">
        <div style="
            width:15px;
            height:15px;
            background-color:#dcdcdc;
            border:1px solid #bfbfbf;
            margin-right:6px;">
        </div>
        <span style="font-size:14px; color:#555;">회색 행은 일정등록 및 점검 완료된 항목입니다.</span>
    </div>

    <!-- 엑셀 다운로드 버튼 -->
    <button type="button"
        style="background-color:mediumseagreen;color:white;border-radius: 4px;border: 0;height: 26px; padding:0 10px;">
        Excel 다운로드
    </button>

 </div>
 
 
 <!-- body 시작 -->
                <table class="table tight-table" style="border-top: 2px solid #e6e6e6;">   <!-- 기능 지정 -->
                  <thead>
                    <tr>  <!-- 색상 지정 -->
                     <!--  <th></th> -->
                      <th class="col-1">순번</th>
                      <th class="col-1">시설/보안 정보</th>
                      <th class="col-1">커뮤니티 정보</th>
                      <th class="col-1">점검 상태</th>                      
                      <th class="col-1">담당자</th>
                      <th class="col-2">점검 시작 일시</th>
                      <th class="col-2">점검 종료 일시</th>
                      <th class="col-1">총 예정 기간</th>
                      <th class="col-1">비 고</th>
                    </tr>
                  </thead>
                  
                  <tbody id="rowlist">
                   <c:forEach items="${fcllist}" var="ohoh" varStatus="status">
                   
                    <c:choose>
                       <c:when test="${ohoh.fcltymanageChcksttus eq '점검예정' or ohoh.fcltymanageChcksttus eq '점검중'}">
                         <tr>
                       </c:when>
                       <c:otherwise>
                          <tr style="background-color:lightgray; pointer-events:none;">
                       </c:otherwise>
                     </c:choose> 
                                      
                                      
                 <%--   <c:choose>
						<c:when test="${ohoh.fcltymanageChcksttus eq '점검예정' or ohoh.fcltymanageChcksttus eq '점검중'}">
						 <td style="vertical-align: middle;">
						     <input type="checkbox" style="margin-left:5px;" />
						 </td>
						</c:when>
						<c:otherwise>
						 <td style="vertical-align: middle;">
						     <input type="checkbox" style="margin-left:5px; display:none;" />
						 </td>
						</c:otherwise>
					</c:choose>   --%>           
                                 
                                                                                                                  
                       <td style="display:none;">              <!-- 화면에 칸 노출 안시키고 일정에 상태값을 전달하기 위한 방법 -->
	                      <input type="hidden" class="fcltyManageSn" value="${ohoh.fcltyManageSn}" >	                     
	                    </td> 
                                       
                      <td>${(articlePage.currentPage - 1)*10 + status.index + 1}</td>  <!-- (articlePage.currentPage - 1)*10 : 이전 페이지에 있던 글의 수 -->
                      
                      
                        
                       <c:choose>
                         <c:when test="${not empty ohoh.fcltyVO.fcltySn}">     <!-- 시설/보안정보 -->
                        <td><input type="hidden" class="fcltySn" value="${ohoh.fcltySn}" />${ohoh.fcltyVO.fcltyNm} ${ohoh.fcltyVO.fcltyLc}</td>
                         </c:when>
                         <c:otherwise>
                        <td><input type="hidden" value="${ohoh.fcltySn}" /> - </td>
                         </c:otherwise>
                       </c:choose>
                        
                        <c:choose>
                         <c:when test="${not empty ohoh.cmmntyVO.cmmntySn}">   <!-- 커뮤니티 정보 -->
                        <td><input type="hidden" class="cmmntySn" value="${ohoh.cmmntySn}" />${ohoh.cmmntyVO.cmmntyNm}</td>
                         </c:when>
                         <c:otherwise>
                         <td><input type="hidden" value="${ohoh.cmmntySn}" /> - </td>
                         </c:otherwise>
                        </c:choose>
                        
                        
                      <c:choose>
                         <c:when test="${not empty ohoh.fcltyVO.fcltySn}">  <!-- 점검 상태 -->
                            <td><input type="hidden" class="fcltySttus" value="${ohoh.fcltySn}" />${ohoh.fcltyVO.fcltySttus}</td>
                         </c:when>
                         <c:otherwise>
                            <td><input type="hidden" class="cmmntyChcksttus" value="${ohoh.cmmntySn}" />${ohoh.cmmntyVO.cmmntyChcksttus}</td>
                         </c:otherwise>                    
                      </c:choose>  
                        
                       
                       <td>
                        <input type="hidden" class="empId" value="${ohoh.empId}" />  <!-- 담당자 -->
                        <input type="hidden" class="nm" value="${ohoh.empVO.nm}" />${ohoh.empVO.nm}  
                       </td>  
                                              
                        <td>
                         <input type="hidden" class="fcltymanageBeginDt" value="${ohoh.fcltymanageBeginDt}" />   <!-- 점검 시작일시 -->
                         <fmt:formatDate value="${ohoh.fcltymanageBeginDt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td> 
                        <td>
                         <input type="hidden" class="fcltymanageEndDt" value="${ohoh.fcltymanageEndDt}" />   <!-- 점검 종료일시 -->
                         <fmt:formatDate value="${ohoh.fcltymanageEndDt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>    
                        <td><fmt:formatNumber value="${ohoh.fcltymanagePrearngePd}" pattern="#"/>일</td>   <!-- 총 예정 기간 -->
                       
                     
	                     <td style="display:none;">              <!-- 화면에 칸 노출 안시키고 일정에 상태값을 전달하기 위한 방법 -->
	                      <input type="hidden" class="chckSttus" value="${ohoh.fcltymanageChcksttus}" >	                     
	                     </td>  
	                                          
                      <td>
                                           
                         <c:choose>
                           <c:when test="${(ohoh.fcltymanageChcksttus eq '점검예정') or (ohoh.fcltymanageChcksttus eq '점검중')}">
                             <c:if test="${ohoh.schduleyesno == true}">
                                 <button type="button" class="btn btn-sm btn-primary openScheduleModal periodBtn" style="display: none;">일정등록</button>
                             </c:if>
                              <c:if test="${ohoh.schduleyesno == false}">
                               <button type="button" class="btn btn-sm btn-primary openScheduleModal periodBtn" style="display: inline-block;">일정등록</button>
                           	  </c:if>
                           </c:when>
                           <c:otherwise>
                             <button type="button" class="btn btn-sm btn-primary openScheduleModal periodBtn" style="display: none;">일정등록</button>
                           </c:otherwise>
                         </c:choose>                                                                          
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
	        <a class="page-link" href="/fcltyManage/list?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}">«</a>
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
		        <a class="page-link" href="/fcltyManage/list?currentPage=${pNo}&keyword=${param.keyword}">
		          ${pNo}
		        </a>
		      </li>
		    </c:forEach>
		
		    <!-- 다음 버튼 -->
		    <c:if test="${articlePage.endPage != articlePage.totalPages}">
		      <li class="page-item">
		        <a class="page-link" href="/fclty/list?currentPage=${articlePage.startPage+5}&keyword=${param.keyword}">»</a>
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
                    
<!--body 끝 -->


   
<%-- <!-- 점검 상태 수정 모달 시작 -->

   <div id="updateModal" class="modal" style="display:none;">
  
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
       <h5 class="modal-title">점검 상태 변경</h5>
       <button type="button" class="close" id="closeModal">닫기</button>     
      </div>
      <div class="modal-body">
       <form action="/fcltyManage/updatePost" method="post">     
        <input type="hidden" id= "fcltyManageSn" name="fcltyManageSn" value="${FcltyManageVO.fcltyManageSn}" />
        
        <table>
          <tr>
            <th>점검 상태</th>
             <td>
            <select id="fclmanageSttus" name="fclmanageSttus" >
                <option value="">---선택하세요---</option>                      
                <option value="정상">정상</option>                      
                <option value="점검예정">점검예정</option>                      
                <option value="점검중">점검중</option>                      
                <option value="점검완료">점검완료</option>                                         
                <option value="고장">고장(시설)</option>                      
                <option value="폐기">폐기(시설)</option>                                      
                <option value="운전중지">운전중지(시설)</option>                      
                <option value="운영중지">미운영(커뮤니티)</option>                      
               </select>  
             </td>
          </tr>
        </table>           
      <div class="modal-footer justify-content-between">   
        <button type="button" id="ok">등록</button>
		<button type="reset" id="cancel">취소</button>	
	  </div>	
	 </form> 
     </div>
    </div>
    </div>
  </div>
<!-- 점검 상태 수정 모달 끝 -->
      --%>
    
<!--// body 끝 //-->

 <%@ include file="../include/footer.jsp"%>
</body>
</html>