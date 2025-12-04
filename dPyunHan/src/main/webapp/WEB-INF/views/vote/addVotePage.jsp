<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
          <title></title>
        </head>

        <body>
          <form id="frm" method="post" action="/vote/addVote">
            <input type="text" name="mtrSj" placeholder="제목">
            <input type="text" name="mtrCn" placeholder="내용">
            <input type="datetime-local" name="voteBeginDt" placeholder="시작일">
            <input type="datetime-local" name="voteEndDt" placeholder="마감일">
            <div id="Iem"></div>
            <button type="button" onclick="addIem()">항목추가</button>

            <button type="submit">등록</button>
          </form>


          <script>
            let i = 0;
            function addIem() {
              const idx = i++;
              console.log("idx:",idx);
              const str = document.createElement('div');
              str.className = 'iem-str';
              str.innerHTML = `
                <!-- 리스트는 voteIemVOList[0].필드 -->
                <input type="hidden" name="voteIemVOList[\${idx}].voteIemNo" value="\${idx + 1}"> 
                <input type="text"   name="voteIemVOList[\${idx}].iemNm"  placeholder="항목명">
                <input type="text"   name="voteIemVOList[\${idx}].iemCn"  placeholder="항목내용">
  `;
              document.querySelector('#Iem').appendChild(str);
            }
          </script>
        </body>

        </html>