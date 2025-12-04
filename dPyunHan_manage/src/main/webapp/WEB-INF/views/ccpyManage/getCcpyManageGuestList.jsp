<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
          <script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
          <script type="text/javascript">
          	document.addEventListener("DOMContentLoaded", function(){
              document.querySelectorAll(".CcpyManageVORow").forEach(row=>{
                row.addEventListener("click", function(){
                  const ccpyManageId = this.querySelector("#ccpyManageId").value;
                  location.href="/ccpyManage/getCcpyManage?ccpyManageId="+ccpyManageId;
                })
              })
            })

          </script>
        </head>

        <body>
          <%@ include file="../include/header.jsp" %>
            <!-- ///// content 시작 ///// -->
          
            <div class="card card-default">
              <div class="card-header">
                <h3 class="card-title">협력업체 목록</h3>
                <div class="card-tools">
                  <div class="input-group input-group-sm" style="width: 150px;">
                    <input type="text" name="table_search" class="form-control float-right" placeholder="Search">
                    <div class="input-group-append">
                      <button type="submit" class="btn btn-default">
                        <i class="fas fa-search"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table class="table table-bordered table-hover text-center">
                  <thead>
                    <tr>
                      <th class="col-1">순번</th>
                      <th>업체명</th>
                      <th class="col-1">대표자</th>
                      <th class="col-4">주소</th>
                      <th>연락처</th>
                      <th>신청일자</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="CcpyManageVO" items="${articlePage.content}">
                      <tr class="CcpyManageVORow" style="cursor: pointer;">
                        <td class="align-middle">
                          ${CcpyManageVO.rnum }
                          <input type="hidden" value="${CcpyManageVO.ccpyManageId}" id="ccpyManageId" name="ccpyManageId"/>
                        </td>
                        <td class="align-middle">
                          ${CcpyManageVO.ccpyCmpnyNm }
                        </td>
                        <td class="align-middle">
                          ${CcpyManageVO.ccpyRprsntvNm }
                        </td>
                        <td class="align-middle">
                          ${CcpyManageVO.ccpyAdres }
                        </td>
                        <td class="align-middle">
                          ${CcpyManageVO.ccpyTelno }
                        </td>
                        <td class="align-middle">
                          <fmt:formatDate value="${CcpyManageVO.ccpyRegistdt}" pattern="yyyy-MM-dd"/>                          
                        <!-- <c:choose>
                        	<c:when test="${CcpyManageVO.ccpySttus==2 }">
                        		<span class="badge badge-danger" style="font-size: 0.9rem">${CcpyManageVO.ccpySttusAsStr }</span>
                        	</c:when>
                        	<c:when test="${CcpyManageVO.ccpySttus==1 }">
                        		<span class="badge badge-warning" style="font-size: 0.9rem">${CcpyManageVO.ccpySttusAsStr }</span>
                        	</c:when>
                        	<c:otherwise>
                        		<span class="badge badge-success" style="font-size: 0.9rem">${CcpyManageVO.ccpySttusAsStr }</span>
                        	</c:otherwise>
                        </c:choose> -->
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
                <div>
                  ${articlePage.pagingAreaBorderedTable}
                </div>
              </div>
              <!-- /.card-body -->
            </div>
            <!-- ///// content 끝 ///// -->
            <%@ include file="../include/footer.jsp" %>
        </body>

        </html>