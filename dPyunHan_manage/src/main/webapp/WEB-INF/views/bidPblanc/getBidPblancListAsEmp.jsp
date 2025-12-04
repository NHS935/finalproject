<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>
          <title></title>

          <style>
            /* 필터 레이블 스타일 */
            .filter-label {
              min-width: 90px;
              /* 레이블 최소 너비 */
              display: inline-block;
              font-weight: 500;
              color: #495057;
              margin-right: 10px;
              flex-shrink: 0;
              /* 레이블이 줄어들지 않도록 */
            }

            hr.my-2 {
              margin: 0.5rem 0;
              border-top: 1px solid rgba(0, 0, 0, 0.1);
            }

            .sort-label {
              min-width: 50px;
              /* 레이블 최소 너비 */
              display: inline-block;
              font-weight: 500;
              color: #495057;
              margin-right: 5px;
              flex-shrink: 0;
              /* 레이블이 줄어들지 않도록 */
            }


          </style>
          <script type="text/javascript">
            document.addEventListener("DOMContentLoaded", function () {
              document.querySelectorAll(".bidPblancVORow").forEach(row => {
                row.addEventListener("click", function () {
                  const bidPblancSn = this.querySelector(".bidPblancSn").value;
                  location.href = "/bidPblanc/getBidPblancAsEmp?bidPblancSn=" + bidPblancSn;
                });
              });

              document.querySelector("#postBidpblancBtn").addEventListener("click", function () {
                location.href = "/bidPblanc/postBidPblanc"
              });

              //검색 폼 애니메이션
              const expandableTable = document.querySelector("[data-widget='expandable-table']");
              const expandIcon = expandableTable.querySelector("i");

              expandableTable.addEventListener("click", function () {
                expandIcon.classList.toggle("fa-rotate-180");
              });

              // daterangepicker
              $(function () {
                $('#daterange-btn').daterangepicker({
                  ranges: {
                    '최근 7일': [moment().subtract(6, 'days'), moment()],
                    '최근 30일': [moment().subtract(29, 'days'), moment()],
                    '최근 90일': [moment().subtract(89, 'days'), moment()]
                  },
                  startDate: moment().subtract(29, 'days'),
                  endDate: moment(),
                  locale: {
                    format: 'YYYY-MM-DD',
                    applyLabel: '적용',
                    cancelLabel: '취소',
                    customRangeLabel: '기간 직접 선택'

                  }
                }, function (start, end, label) {
                  $('#daterange-btn').html(
                    '<i class="far fa-calendar-alt"></i> ' + start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD') +
                    ' <i class="fas fa-caret-down"></i>'
                  );

                  $('#startDate').val(start.format('YYYY-MM-DD'));
                  $('#endDate').val(end.format('YYYY-MM-DD'));
                });
              });

              //정렬버튼 토글
              $('#sortDirectionBtn').on('click', function () {
                const currentDirection = $(this).data('direction');

                if (currentDirection === 'asc') {
                  // 내림차순으로 변경
                  $(this).data('direction', 'desc');
                  $(this).find('i').removeClass('fa-sort-amount-down-alt').addClass('fa-sort-amount-up');
                  $(this).find('.sort-text').text('내림차순');
                } else {
                  // 오름차순으로 변경
                  $(this).data('direction', 'asc');
                  $(this).find('i').removeClass('fa-sort-amount-up').addClass('fa-sort-amount-down-alt');
                  $(this).find('.sort-text').text('오름차순');
                }
              });

            })
          </script>
        </head>

        <body>
          <%@ include file="../include/header.jsp" %>
            <!-- /// body /// -->


            <!-- 필터 폼 시작 -->
            <div class="card p-0 mb-2">
              <!-- ./card-header -->
              <table class="table table-bordered table-hover m-0">
                <tbody>
                  <tr class="bg-lightblue disabled" data-widget="expandable-table" aria-expanded="false">
                    <td class="d-flex justify-content-between">
                      <div class="ml-2">
                        <b>
                          검색 필터
                        </b>
                      </div>
                      <div>
                        <span class="mr-2">설정</span><i class="fas fa-chevron-up"></i>
                      </div>
                    </td>
                  </tr>
                  <tr class="expandable-body d-none p-0">
                    <td class="p-3">
                      <div class="d-flex justify-content p-1 pl-3 pr-3">
                        <!-- 제목 + 분류 -->
                        <div class="col-4 m-0">
                          <!-- 분류 -->
                          <div class="d-flex align-items-center m-2">
                            <span class="filter-label">분류</span>
                            <div class="d-flex flex-wrap">
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="category1" name="category"
                                  value="new" checked>
                                <label for="category1" class="custom-control-label small">신규공고</label>
                              </div>
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="category2" name="category"
                                  value="re">
                                <label for="category2" class="custom-control-label small">재공고</label>
                              </div>
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="category2" name="category"
                                  value="re">
                                <label for="category2" class="custom-control-label small">선정완료</label>
                              </div>
                            </div>
                          </div>

                          <hr class="my-2">

                          <!-- 제목 -->
                          <div class="d-flex align-items-center m-2">
                            <span class="filter-label">제목</span>
                            <input type="text" class="form-control" placeholder="제목 입력">
                          </div>

                        </div>

                        <!-- 낙찰방법 + 검색일자 -->
                        <div class="col-4 m-0">
                          <!-- 낙찰방법 -->
                          <div class="d-flex align-items-center m-2">
                            <span class="filter-label">낙찰방법</span>
                            <div class="d-flex flex-wrap">
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="method1" name="method"
                                  value="qualified" checked>
                                <label for="method1" class="custom-control-label small">적격심사</label>
                              </div>
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="method2" name="method"
                                  value="highest">
                                <label for="method2" class="custom-control-label small">최고낙찰</label>
                              </div>
                              <div class="custom-control custom-radio mr-2">
                                <input class="custom-control-input" type="radio" id="method3" name="method"
                                  value="lowest">
                                <label for="method3" class="custom-control-label small">최저낙찰</label>
                              </div>
                            </div>
                          </div>

                          <hr class="my-2">

                        </div>

                        <!-- 입찰 수 정렬 + 조회기간 -->
                        <div class="col-4 m-0">

                          <div class="d-flex align-items-center m-2">
                            <span class="filter-label">검색일자</span>
                            <div class="custom-control custom-checkbox mr-2">
                              <input class="custom-control-input" type="checkbox" id="customCheckbox1" value="option1">
                              <label for="customCheckbox1" class="custom-control-label small">공고시작일</label>
                            </div>
                            <div class="custom-control custom-checkbox">
                              <input class="custom-control-input" type="checkbox" id="customCheckbox2" value="option2">
                              <label for="customCheckbox2" class="custom-control-label small">입찰마감일</label>
                            </div>
                          </div>

                          <hr class="my-2">

                          <div class="d-flex align-items-center m-2">
                            <span class="filter-label">조회기간</span>
                            <button type="button" class="btn btn-default flex-fill" id="daterange-btn">
                              <i class="far fa-calendar-alt"></i> 기간선택
                              <i class="fas fa-caret-down"></i>
                            </button>
                          </div>


                        </div>

                      </div>
                      <hr class="my-2 m-1">
                      <div class="d-flex justify-content-end align-items-center m-1 p-1">
                        <button class="btn btn-default">검색</button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <!-- /.card-body -->
            </div>
            <!--필터 검색 폼 끝-->


            <div class="card card-default">
              <div class="card-header">
                <h3 class="card-title">입찰 공고 목록</h3>
                <!-- 정렬 + 공고등록 -->
                <div class="card-tools">
                  <div class="input-group input-group-sm">
                    
                    <!-- 정렬 -->
                    <div class="d-flex align-items-center sort-box">
                      <span class="sort-label">정렬</span>
                      <div class="custom-control custom-checkbox mr-2">
                        <input class="custom-control-input" type="checkbox" id="sort1" value="option1">
                        <label for="sort1" class="custom-control-label small">입찰수</label>
                      </div>
                      <div class="custom-control custom-checkbox mr-2">
                        <input class="custom-control-input" type="checkbox" id="sort2" value="option2">
                        <label for="sort2" class="custom-control-label small">공고시작일</label>
                      </div>
                      <div class="custom-control custom-checkbox mr-2">
                        <input class="custom-control-input" type="checkbox" id="sort3" value="option2">
                        <label for="sort3" class="custom-control-label small">입찰마감일</label>
                      </div>
                      <button type="button" class="btn btn-sm btn-light p-1" id="sortDirectionBtn"
                        data-direction="asc">
                        <i class="fas fa-sort-amount-down-alt"></i>
                        <span class="sort-text">오름차순</span>
                      </button>
                    </div>
                    <!-- 공고등록 -->
                    <span class="mr-4 ml-4" style="color: white;">|</span>
                    <button type="button" class="btn btn-success btn-sm" id="postBidpblancBtn">공고등록</button>
                  </div>
                </div>
                <!-- 정렬+공고등록 끝 -->
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <table class="table table-bordered table-hover text-center" style="font-size: 0.9rem;">
                  <thead>
                    <tr class="bg-light">
                      <th>순번</th>
                      <th>입찰제목</th>
                      <th>낙찰방법</th>
                      <th>공고시작일</th>
                      <th>입찰마감일</th>
                      <th>입찰수</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="bidPblancVO" items="${articlePage.content}">
                      <tr class="bidPblancVORow" style="cursor: pointer;">
                        <td>${bidPblancVO.rnum}
                          <input type="hidden" class="bidPblancSn" value="${bidPblancVO.bidPblancSn}" />
                        </td>
                        <td class="text-left">
                          <c:choose>
                            <c:when test="${bidPblancVO.bidSttus==2}">
                              <span class="badge badge-danger">${bidPblancVO.bidSttusAsStr}</span>
                            </c:when>
                            <c:when test="${bidPblancVO.hasAlreadyBid}">
                              <span class="badge badge-warning">입찰완료</span>
                            </c:when>
                            <c:otherwise>
                              <c:if test="${bidPblancVO.bidSttus==1}">
                                <span class="badge badge-secondary">${bidPblancVO.bidSttusAsStr}</span>
                              </c:if>
                              <c:if test="${bidPblancVO.bidSttus!=1}">
                                <span class="badge badge-info">${bidPblancVO.bidSttusAsStr}</span>
                              </c:if>
                            </c:otherwise>
                          </c:choose>
                          <span class="ml-2">${bidPblancVO.bidSj}</span>
                        </td>
                        <td>${bidPblancVO.scsbMthAsStr}</td>
                        <td>
                          <fmt:formatDate value="${bidPblancVO.pblancDt}" pattern="yyyy-MM-dd" />
                        </td>
                        <td>
                          <fmt:formatDate value="${bidPblancVO.bidClosDtAsDate}" pattern="yyyy-MM-dd" />
                        </td>
                        <td>${bidPblancVO.cntBdderVO}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
              <!-- /.card-body -->
              ${articlePage.pagingAreaBorderedTable}
            </div>
            <!-- /// body /// -->
            <%@ include file="../include/footer.jsp" %>
        </body>

        </html>