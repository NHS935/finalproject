<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<title></title>

<script>

 document.addEventListener("DOMContentLoaded", function(){
	 
	 const fcltySttusSelect = document.getElementById("fcltySttus");
		
	// 시설상태 변경 시 
	
    fcltySttusSelect.addEventListener("change",function(){

	    const selectedValue = this.value;
	    
	    console.log("selectedValue:",selectedValue);
	    
	}); //end fcltySttusSelect
		
				
	const okButton = document.querySelector("#ok");

	okButton.addEventListener("click",function(){  //저장 버튼을 누르면
 	  
   
    let updateId = document.querySelector("#fcltySn");
	
	const fcltySttus = document.querySelector("#fcltySttus").value;
	const fcltyChckDt = document.querySelector("#fcltyChckDt").value;
	const fcltySn = document.querySelector("#fcltySn").value;
	
	//FCLTY_MANAGE_SN, FCLTYMANAGE_CHCKSTTUS 필요
    //result += fcltyManagemapper.updatefclmanageChcksttus(fcltyManageVO);
	
    let nhs ={
      "fcltySn":fcltySn,
      "fcltySttus":fcltySttus,
      "fcltyChckDt":fcltyChckDt
    }
   
  
    console.log("nhs : ",nhs); 

    fetch("/fclty/updatePost",{
    	method:"post",
        headers:{'Content-Type':"application/json;charset=utf-8"},
        body: JSON.stringify(nhs)
      })
      .then(response=>{
    	  return response.json();
      })
      .then(data=>{
    	  console.log("data:",data);
        if(data){
        	 Swal.fire({
      			icon:'success', 
      			title:'수정 성공',
      			text:'수정을 완료했습니다.', 
      			confirmButtonText: '확인',
                  width: 400,
                  allowOutsideClick: false,
                  allowEscapeKey: false 			 
      		 }).then(()=>{
        		
         const modal = document.querySelector("#statusModal");
         
         if(modal){
        	
           $(modal).hide();
         }
        	
    	  window.parent.location.reload();  //새로고침

        });
        } 	 
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

<form action="/fclty/updatePost" method="post">

		<table>
			<tr>
				<th>시설분류</th>
				<td>
                   <select id="fcltyCl" name="fcltyCl" style="margin-left:30px; width:200px;" disabled>
                     <option value="">---선택하세요---</option>
                     <option value="승강설비">승강설비</option>
                     <option value="소방설비">소방설비</option>
                     <option value="전기설비">전기설비</option>
                     <option value="급수,배수설비">급수,배수설비</option>
                     <option value="난방,냉방설비">난방,냉방설비</option>
                     <option value="통신설비">통신설비</option>
                    </select>                
                </td>
			</tr>
			<tr>
				<th>시설이름</th>
				<td>
                   <select id="fcltyNm" name="fcltyNm" style="margin-left:30px; width:200px;" disabled >
                     <option value="">---선택하세요---</option>                  
                     <option value="승강기">승강기</option>                  
                     <option value="스프링쿨러">스프링쿨러</option>                  
                     <option value="화재경보기">화재경보기</option>                  
                     <option value="발전기">발전기</option>                  
                     <option value="급수펌프">급수펌프</option>                  
                     <option value="냉각탑">냉각탑</option>                  
                     <option value="CCTV">CCTV</option>                  
                     <option value="비상방송시스템">비상방송시스템</option>                  
                    </select>                
                </td>
			</tr>
			<tr>
				<th>시설위치</th>
				<td>
                   <select id="fcltyLc" name="fcltyLc" style="margin-left:30px; width:200px;" disabled>
                     <option value="">---선택하세요---</option>
                     <option value="101동">101동</option>
                     <option value="102동">102동</option>
                     <option value="103동">103동</option>
                     <option value="104동">104동</option>
                     <option value="105동">105동</option>
                                           
                    </select>                
                </td>
			</tr>
			<tr>
				<th>시설상태</th>
				<td>
                   <select id="fcltySttus" name="fcltySttus" style="margin-left:30px; width:200px;" >
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
				  <input type="date" id="fcltyChckDt" name="fcltyChckDt" style="margin-left:30px; width:200px;" value="<fmt:formatDate value='${fcltyVO.fcltyChckDt}' pattern='yyyy-MM-dd' />" /> 
				</td>   
			</tr>
		</table>
		<button type="button" id="ok" class="btn btn-secondary" style="margin-top:20px;">저장</button>
		<button type="reset" id="cancel" class="btn btn-warning" style="margin-top:20px; margin-left:5px;">취소</button>
	</form>
	<hr />

<!--// body 끝 //-->


</body>
</html>