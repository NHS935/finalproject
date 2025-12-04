<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../include/header.jsp" %>
<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<style>
/* 카드 공통 */
.card-body {
    padding: 0.5rem !important;
    font-size: 0.8rem !important;
}

.card {
    border-radius: 1.2rem !important;
    overflow: hidden !important;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
}

/* 검색 영역 */
.search-form {
    background-color: #f9f9f9;
    border: 1px solid #eee;
    padding: 10px 12px;
    margin-bottom: 10px;
    border-radius: 5px;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 8px;
    justify-content: space-between;
}

.search-form-left {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 8px;
    font-size: 0.85rem;
}

.search-form-right {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 6px;
}

.search-form input[type="month"] {
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 0.8rem;
}

.search-form button,
.search-form .btn {
    padding: 6px 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.8rem;
}

/* 기본 조회 버튼 */
.search-form .btn-search {
    background-color: #007bff;
    color: #fff;
}
.search-form .btn-search:hover {
    background-color: #0056b3;
}

.search-form .btn-upload:hover {
    background-color: #5a32a0;
}

/* 검침량 조회 */
.search-form .btn-mtinsp {
    background-color: #20c997;
    color: #fff;
}
.search-form .btn-mtinsp:hover {
    background-color: #17a589;
}

/* 관리비 테이블 */
.managect-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 0;
}

.managect-table th,
.managect-table td {
    border: 1px solid #ddd;
    padding: 4px 8px;
    text-align: center;
    font-size: 13px;
    font-weight: 500;
}

.managect-table th {
    background-color: #f2f2f2;
}

.managect-table tbody tr {
    transition: background-color 0.25s ease, box-shadow 0.25s ease,
                transform 0.2s ease !important;
}
.managect-table tbody tr:hover {
    background-color: rgba(100, 140, 164, 0.12) !important;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15) !important;
    transform: translateY(-2px) !important;
    cursor: pointer;
}
/* 관리비 업로드 버튼 */
.search-form button {
    padding: 6px 10px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.8rem;
}
.search-form button:hover { background-color: #0056b3; }
.search-form button.reset { background-color: #6c757d; }
.search-form button.reset:hover { background-color: #5a6268; }
/* 관리비 업로드 버튼 */
</style>

<section class="content">
    <div class="container-fluid">
        <div class="row">

            <div class="col-12 connectedSortable ui-sortable">
                <div class="card">
                    <!-- 카드 헤더 -->
                    <div class="card-header">
                        <h3 class="card-title mb-0" style="font-size:1rem;">
                            <i class="fas fa-receipt"></i> 월별 관리비 사용 내역 조회
                            <c:if test="${not empty searchMonth}">
                                <small class="text-muted" style="font-size:0.8rem;">
                                    (조회 월: ${searchMonth})
                                </small>
                            </c:if>
                        </h3>
                    </div>

                    <!-- 카드 바디 -->
                    <div class="card-body">
                        <!-- 검색 폼 -->
                        <div class="search-form">
                            <div class="search-form-left">
                                <label for="searchMonth" style="margin:0;">조회 월:</label>
                                <form id="managectSearchForm"
                                      action="${pageContext.request.contextPath}/managect/managectView"
                                      method="get"
                                      style="display:flex; align-items:center; gap:8px; margin:0;">
                                    <input type="month"
                                           id="searchMonth"
                                           name="searchMonth"
                                           value="${searchMonth}"
                                           required />
                                    <button type="submit" class="btn-search">조회</button>
                                </form>
                            </div>

                            <div class="search-form-right">
                                <button type="button"
                                        class="btn reset"
                                        onclick="upload()">
                                    관리비 업로드
                                </button>
                                <button type="button"
                                        class="btn btn-search"
                                        onclick="mtinsp()">
                                    검침량 조회
                                </button>
                            </div>
                        </div>

                        <!-- 결과 테이블 -->
                        <c:if test="${not empty feeList}">
                            <h5 style="font-size:0.9rem; margin-bottom:8px;">
                                📄 '${searchMonth}' 관리비 사용 내역
                                <span class="text-muted">(${feeList.size()} 건)</span>
                            </h5>

                            <table class="managect-table">
                                <thead>
                                <tr>
                                    <th style="width:10%;">항목 ID</th>
                                    <th style="width:35%;">항목명</th>
                                    <th style="width:20%;">금액</th>
                                    <th style="width:15%;">기준 코드</th>
                                    <th style="width:20%;">사용 년월</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${feeList}">
                                    <tr>
                                        <td>${item.managectIemId}</td>
                                        <td style="text-align:left; padding-left:10px;">
                                            ${item.iemNm}
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.managectAmount}"
                                                              pattern="#,##0" /> 원
                                        </td>
                                        <td>${item.managectIemStdrCode}</td>
                                        <td>${item.managectUseDe}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:if>

                        <c:if test="${empty feeList && not empty searchMonth}">
                            <p style="margin-top:10px; font-size:0.85rem;">
                                '${searchMonth}'에 해당하는 데이터가 없습니다.
                            </p>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<script type="text/javascript">
    function upload() {
        window.location.href = '${pageContext.request.contextPath}/managect/upload';
    }
    function mtinsp() {
        window.location.href = '${pageContext.request.contextPath}/mtinsp/mtinspView?searchMonth=${searchMonth}';
    }
</script>

<%@ include file="../include/footer.jsp" %>
