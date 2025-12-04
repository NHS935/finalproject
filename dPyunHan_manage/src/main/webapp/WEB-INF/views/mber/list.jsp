<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../include/header.jsp"%>

<html>
<head>
<title>승인 대기 회원 목록</title>
<style>
/* 상단 제목 영역 스타일 */
.page-title-bar {
    background: rgba(193, 179, 180, 0.5);
    padding: 15px 20px;
    border-radius: 6px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.page-title-text {
    font-size: 1.3rem;
    font-weight: 700;
    color: #333;
}

.page-title-option {
    font-size: 0.9rem;
    color: #555;
    cursor: pointer;
}

.page-title-option i {
    margin-left: 5px;
}

.card { margin-top: 20px; }

/* 검색 영역 */
.filter-bar {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    align-items: flex-end;
    justify-content: space-between;
    background: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px 20px;
    margin-bottom: 20px;
}

.filter-group {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    flex: 1;
}

.filter-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 150px;
}

.filter-item label {
    font-weight: 600;
    font-size: 13px;
    color: #333;
}

.filter-item input,
.filter-item select {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 6px 8px;
    width: 100%;
}

.filter-actions {
    display: flex;
    gap: 10px;
    align-items: center;
}

.btn-search {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 5px;
    cursor: pointer;
}

.btn-reset {
    background-color: #6c757d;
    color: white;
    border: none;
    padding: 8px 15px;
    border-radius: 5px;
    cursor: pointer;
}

.btn-search:hover { background-color: #0056b3; }
.btn-reset:hover { background-color: #545b62; }

/* 테이블 */
.table th, .table td {
    text-align: center;
    vertical-align: middle;
    padding: 8px 10px;
}

.table th {
    cursor: pointer;
    background-color: #f1f1f1;
}

.approve-btn {
    color: white;
    background-color: green;
    border: none;
    padding: 5px 10px;
    cursor: pointer;
    border-radius: 5px;
}

.approve-btn:hover { background-color: darkgreen; }

</style>
<script>
// 테이블 컬럼 정렬 (간단 JS)
function sortTable(tableId, colIndex) {
    var table = document.getElementById(tableId);
    var rows = Array.from(table.tBodies[0].rows);
    var asc = table.getAttribute("data-sort-col") != colIndex || table.getAttribute("data-sort-order") == "desc";
    
    rows.sort(function(a, b){
        var cellA = a.cells[colIndex].innerText.toLowerCase();
        var cellB = b.cells[colIndex].innerText.toLowerCase();
        return asc ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
    });
    
    rows.forEach(function(row){ table.tBodies[0].appendChild(row); });
    table.setAttribute("data-sort-col", colIndex);
    table.setAttribute("data-sort-order", asc ? "asc" : "desc");
}
</script>
</head>

<body>
<div class="page-title-bar">
    <div class="page-title-text">승인 대기 회원 목록</div>
</div>

<div class="container">
    <div class="filter-bar">
        <div class="filter-group">
            <div class="filter-item">
                <label>회원 ID</label>
                <input type="text" placeholder="회원 ID 입력">
            </div>
            <div class="filter-item">
                <label>이름</label>
                <input type="text" placeholder="이름 입력">
            </div>
            <div class="filter-item">
                <label>전화번호</label>
                <input type="text" placeholder="전화번호 입력">
            </div>
            <div class="filter-item">
                <label>회원유형</label>
                <select>
                    <option>전체</option>
                    <option>임대</option>
                    <option>자가</option>
                    <option>임차</option>
                </select>
            </div>
            <div class="filter-item">
                <label>세대번호</label>
                <input type="text" placeholder="세대번호 입력">
            </div>
            <div class="filter-item">
                <label>동</label>
                <input type="text" placeholder="동 입력">
            </div>
            <div class="filter-item">
                <label>호</label>
                <input type="text" placeholder="호 입력">
            </div>
            <div class="filter-item">
                <label>입주일자</label>
                <input type="date">
            </div>
        </div>

        <div class="filter-actions">
            <button class="btn-search">검색</button>
            <button class="btn-reset">초기화</button>
        </div>
    </div>

    <!-- 승인 대기 회원 목록 테이블 -->
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered table-hover mb-0" id="pendingTable" data-sort-col="-1" data-sort-order="asc">
                <thead class="thead-light">
                    <tr>
                        <th onclick="sortTable('pendingTable', 0)">번호</th>
                        <th onclick="sortTable('pendingTable', 1)">회원 ID</th>
                        <th onclick="sortTable('pendingTable', 2)">이름</th>
                        <th onclick="sortTable('pendingTable', 3)">전화번호</th>
                        <th onclick="sortTable('pendingTable', 4)">회원유형</th>
                        <th onclick="sortTable('pendingTable', 5)">세대번호</th>
                        <th onclick="sortTable('pendingTable', 6)">동</th>
                        <th onclick="sortTable('pendingTable', 7)">호</th>
                        <th onclick="sortTable('pendingTable', 8)">입주일자</th>
                        <th>승인</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="member" items="${pendingList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td><a href="${pageContext.request.contextPath}/mber/detail?mberId=${member.mberId}">${member.mberId}</a></td>
                            <td>${member.mberNm}</td>
                            <td>${member.telno}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${member.mberTy == 1}">임대</c:when>
                                    <c:when test="${member.mberTy == 2}">자가</c:when>
                                    <c:otherwise>임차</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${member.hshldId}</td>
                            <td>${member.aptcmpl}</td>
                            <td>${member.ho}</td>
                            <td>${member.mvnDe}</td>
                            <td>
                                <button type="button" class="approve-btn"
                                        onclick="location.href='${pageContext.request.contextPath}/mber/detail?mberId=${member.mberId}'">
                                    승인
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty pendingList}">
                        <tr>
                            <td colspan="10">승인 대기 중인 회원이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div id="pagingAreaWrap" class="card-footer clearfix">
	${articlePage.pagingArea}
</div>

<%@ include file="../include/footer.jsp"%>
</body>
</html>
