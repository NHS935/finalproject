<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
          <title></title>

          <script type="text/javascript">
            document.addEventListener("DOMContentLoaded", function(){
              document.querySelectorAll(".VORow").forEach(row =>{
                row.addEventListener("click", function(){
                  const id = this.querySelector(".id").value;
                  location.href = "/contract/edit/"+id;
                })
              })
            })
          </script>
        </head>
        <link rel="stylesheet" href="/css/filter.css">
        <body>
          <%@ include file="../include/header.jsp" %>
                <!-- /// body /// -->
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
                                          <span>계약서 제목</span>
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


                          <!-- 날짜 범위 셀 -->
                          <div class="filter-cell">
                              <div class="filter-cell-label">날짜 범위</div>
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
          <div class="card">
              <div class="card-header">
                <h3 class="card-title">계약서 작성 목록</h3>
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table class="table table-bordered table-hover" style="font-size: 0.9rem;">
                  <thead>
                     <tr>
                          <th>순번</th>
                          <th>계약서 제목</th>
                          <th>생성일</th>
                          <th>수정일</th>
                        </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="VO" items="${articlePage.content}">
                        <tr class="VORow" style="cursor: pointer;">
                          <td>${VO.rnum}
                            <input type="hidden" class="id" value="${VO.id}"/>
                          </td>

                          <td>${VO.title}</td>
                          <td>
                            <fmt:formatDate value="${VO.createdAt}" pattern="yyyy-MM-dd"/>
                          </td>
                          <td>
                          	<fmt:formatDate value="${VO.updatedAt}" pattern="yyyy-MM-dd"/>
                          </td>
                        </tr>
                        </c:forEach>
                  </tbody>
                </table>
              </div>
              <div style="margin-left: 20px;">
<%--              <sec:authorize access="isAuthenticated()">--%>
                  <a href="/contract/postContract" id="btnWrite" class="btn btn-primary">작성</a>
<%--              </sec:authorize>--%>
              </div>
              <!-- /.card-body -->
              ${articlePage.pagingAreaBorderedTable}
<%--              <button type="button" id="stampButton" data-file-group-sn="20251030005">--%>
<%--                  계약서 직인 생성 테스트 (그룹 SN: 20251030005)--%>
<%--              </button>--%>
            </div>
            <!-- /// body /// -->
            <%@ include file="../include/footer.jsp" %>
        </body>

        <script>
            // 버튼 DOM 요소를 찾습니다.
            <%--const stampButton = document.getElementById('stampButton');--%>

            <%--// 버튼 클릭 이벤트 리스너를 추가합니다.--%>
            <%--stampButton.addEventListener('click', function() {--%>

            <%--    // 버튼의 data- attribute에서 하드코딩된 fileGroupSn 값을 가져옵니다.--%>
            <%--    const hardcodedFileGroupSn = this.dataset.fileGroupSn;--%>

            <%--    // 요청을 보낼 API 엔드포인트--%>
            <%--    const apiUrl = `/api/stamp/\${hardcodedFileGroupSn}`;--%>

            <%--    console.log(`[요청 전송]... API: \${apiUrl}, Method: POST`);--%>

            <%--    // Fetch API를 사용하여 서버에 POST 요청을 보냅니다.--%>
            <%--    fetch(apiUrl, {--%>
            <%--        method: 'POST',--%>
            <%--        headers: {--%>
            <%--            // CSRF 토큰이 활성화된 경우, 헤더에 추가해야 합니다.--%>
            <%--            // 'X-CSRF-TOKEN': '실제 토큰 값'--%>
            <%--        }--%>
            <%--    })--%>
            <%--        .then(response => {--%>
            <%--            // 서버 응답이 'OK' (200-299)인지 확인합니다.--%>
            <%--            if (!response.ok) {--%>
            <%--                // 404 (파일 없음), 500 (서버 오류) 등이 여기서 처리됩니다.--%>
            <%--                console.error(`[오류 발생] Status: ${response.status}`);--%>
            <%--                // 서버가 보낸 오류 메시지를 텍스트로 읽어옵니다.--%>
            <%--                return response.text().then(text => { throw new Error(text || '서버 응답 오류') });--%>
            <%--            }--%>

            <%--            // 201 Created 응답을 기대합니다.--%>
            <%--            console.log(`[응답 수신] Status: ${response.status}`);--%>
            <%--            // 성공 시, 컨트롤러가 반환한 JSON(새 FileDetailVO)을 파싱합니다.--%>
            <%--            return response.json();--%>
            <%--        })--%>
            <%--        .then(stampedFileVO => {--%>
            <%--            // 3. 성공 처리--%>
            <%--            // 개발자 콘솔에 새로 생성된 파일의 VO를 출력합니다.--%>
            <%--            console.log('[직인 생성 성공]', stampedFileVO);--%>
            <%--            alert(`직인 생성이 완료되었습니다.\n새 파일 저장명: ${stampedFileVO.fileStreNm}`);--%>
            <%--        })--%>
            <%--        .catch(error => {--%>
            <%--            // 4. 실패 처리--%>
            <%--            // 네트워크 오류 또는 위에서 throw한 오류가 여기서 처리됩니다.--%>
            <%--            console.error('[직인 생성 실패]', error.message);--%>
            <%--            alert(`직인 생성 실패:\n${error.message}`);--%>
            <%--        });--%>

            <%--});--%>
        </script>

        </html>