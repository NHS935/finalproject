<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
          <meta charset="UTF-8" />
          <title>투표 하기</title>
        </head>

        <body>
          <h1>투표 상세</h1>
          ${voteMtrVO}

          <h2>투표 정보</h2>
          <form id="frm" method="post" action="/vote/haveAVote">
          <table border="1" cellpadding="6" cellspacing="0">
            <tr>
              <th>번호</th>
              <td>${voteMtrVO.voteMtrSn}</td>
            </tr>
            <tr>
              <th>제목</th>
              <td>${voteMtrVO.mtrSj}</td>
            </tr>
            <tr>
              <th>내용</th>
              <td>${voteMtrVO.mtrCn}</td>
            </tr>
            <tr>
              <th>시작일</th>
              <td>${voteMtrVO.voteBeginDt}</td>
            </tr>
            <tr>
              <th>종료일</th>
              <td>${voteMtrVO.voteEndDt}</td>
            </tr>
            <tr>
              <th>작성자</th>
              <td>${voteMtrVO.empId}</td>
            </tr>
          </table>

          <h2 style="margin-top:16px;">투표 항목</h2>
          <table border="1" cellpadding="6" cellspacing="0" width="100%">
            <thead>
              <tr>
                <th style="width:100px;">항목번호</th>
                <th>항목이름</th>
                <th>설명</th>
                <th>투표자수</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty voteMtrVO.voteIemVOList}">
                  <c:forEach var="iem" items="${voteMtrVO.voteIemVOList}">
                    <tr>
                      <td>
                      <input type="hidden" name="voteMtrSn" value="${voteMtrVO.voteMtrSn}">
                        ${iem.voteIemNo}
                      </td>
                      <td>
                        ${iem.iemNm}
                      </td>
                      <td>
                        ${iem.iemCn}
                      </td>
                      <td>
                      	${iem.cnt}
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="3">등록된 항목이 없습니다.</td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
            <tfoot>
<!--             	<td><button type="submit">투표하기(haveAVote())</button></td> -->
            </tfoot>
          </table>
          
          </form>
        </body>
        
        <script>
      
        </script>
        
        </html>