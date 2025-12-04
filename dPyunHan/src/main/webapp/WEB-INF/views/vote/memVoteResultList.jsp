<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<title></title>
</head>
<body>

<!-- /// 타이틀 시작 /// -->
 <!-- /// 타이틀 끝 /// -->
 
 <!-- /// body 시작 /// -->
 
 <table >
     <tr>
         <th>번호</th>
         <th>제목</th>
         <th>내용</th>
         <th>시작일</th>
         <th>종료일</th>
         <th>작성자</th>
         <th>투표몇명?</th>
     </tr>
     <c:forEach var="vote" items="${voteMtrVOList}">
         <tr>
            <td>
            <a href="/vote/goVotedResult?voteMtrSn=${vote.voteMtrSn}">${vote.voteMtrSn}</a>
            </td>
             <td>${vote.mtrSj}</td>
             <td>${vote.mtrCn}</td>
             <td>${vote.voteBeginDt}</td>
             <td>${vote.voteEndDt}</td>
             <td>${vote.empId}</td>
             <td>${vote.votedNum}</td>
             
         </tr>
     </c:forEach>
<button><a href="#">아직기능없는버튼</a></button>
<!-- /// body 끝 /// -->
</table>
</body>
</html>