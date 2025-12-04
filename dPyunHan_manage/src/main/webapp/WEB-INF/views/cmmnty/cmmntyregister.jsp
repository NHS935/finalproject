<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script>

 document.addEventListener("DOMContentLoaded", function(){
	 
	 const cmmntyChsttuSelect = document.getElementById("cmmntyChcksttus");
		
	// 커뮤니티 상태 변경 시 
	
    cmmntyChsttuSelect.addEventListener("change",function(){

	    const selectedValue = this.value;
	    
	    console.log("selectedValue:",selectedValue);
	    
	}); //end fcltySttusSelect
		
				
			
	$(document).on("click","#ok",function(){ //저장 버튼을 누르면
		
		
    console.log("저장버튼 확인");		
   
    let updateId = document.querySelector("#cmmntySn");
	
	const cmmntyChcksttus = document.querySelector("#cmmntyChcksttus").value;
	const cmmntyChckDt = document.querySelector("#cmmntyChckDt").value;
	const cmmntySn = document.querySelector("#cmmntySn").value;
	const cmmntyNm = document.querySelector("#cmmntyNm").value;
	
    let nhs ={
      "cmmntyChcksttus":cmmntyChcksttus,
      "cmmntyChckDt":cmmntyChckDt,
      "cmmntySn":cmmntySn,
      "cmmntyNm":cmmntyNm
      
    }
   
    console.log("nhs(커뮤니티): ",nhs); 

    fetch("/cmmnty/cmmntyupdatePost",{
    	method:"post",
        headers:{'Content-Type':"application/json;charset=utf-8"},
        body: JSON.stringify(nhs)
      })
      .then(response=>{
    	  return response.json();
      })
      .then(data=>{
    	  console.log("/cmmnty/cmmntyupdatePost data:",data);
        if(data>0){
    	  parent.location.href="/cmmnty/cmmntylist"
        };
      })
      .catch(error=>{
    	  console.log("error:",error);
      })
  });
 });
 
</script>

</head>
<body>


<!--// body 시작 //-->

<form action="/cmmnty/cmmntyupdatePost" method="post">

		<table>
			
			<tr>
				<th>커뮤니티 이름</th>
				<td>
                   <select id="cmmntyNm" name="cmmntyNm" style="margin-left:30px; width:200px;" disabled > 
                     <option value="">---선택하세요---</option>                  
                     <option value="헬스장">헬스장</option>                  
                     <option value="사우나">사우나</option>                  
                     <option value="골프장">골프장</option>                  
                     <option value="탁구장">탁구장</option>                  
                     <option value="독서실">독서실</option>                                 
                     <option value="수영장">수영장</option>                                 
                     <option value="당구장">당구장</option>                                 
                     <option value="테스니장">테스니장</option>                                 
                     <option value="세미나실">세미나실</option>                                 
                    </select>                
                </td>
			</tr>
			

            <tr>
			  <th>운영 시간</th>
			  <td>
			    <div id="cmmntyclock" name="cmmntyclock" style="background:#f5f5f5; margin-left:30px; border:1px solid #ccc; border-radius:3px; width:200px; color:gray; padding-left:5px; text-align:left;">
			       ${CmmntyVO.cmmntyOpnVwpoint} ~ ${CmmntyVO.cmmntyClosVwpoint} 
			    </div>					   
			  </td>	
			</tr>
			

			<tr>
				<th>점검 상태</th>
				<td>
                   <select id="cmmntyChcksttus" name="cmmntyChcksttus" style="margin-left:30px; width:200px;" >
                     <option value="">---선택하세요---</option>                      
                     <option value="정상">정상</option>                      
		             <option value="점검예정">점검예정</option>                      
		             <option value="점검완료">점검완료</option>                                            
		             <option value="점검중">점검중</option>                                                                            
                    </select>                
                </td>
			</tr>

			<tr>
				<th>최근 점검일자</th> 			
				<td>
				  <input type="date" id="cmmntyChckDt" name="cmmntyChckDt" style="margin-left:30px; width:200px;" value="<fmt:formatDate value='${CmmntyVO.cmmntyChckDt}' pattern='yyyy-MM-dd' />" /> 
				</td>   
			</tr>
		</table>
		<button type="button" id="ok" class="btn btn-secondary" style="margin-top:20px;">저장</button>		
		<button type="reset" id="cancel" class="btn btn-warning" style="margin-top:20px; margin-left:5px;">취소</button>
	</form>
	<hr />

<!--// body 끝 //-->

