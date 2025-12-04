<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="../include/header.jsp"%>

<div class="container-fluid">
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <!-- 상단  -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <h2 class="mb-0">
          <span class="mr-2">${emp2VO.nm}</span>님 안녕하세요
        </h2>
        <a href="/emp/editEmpMyPage/${empId}" class="btn bg-gradient-primary">
          <i class="fas fa-edit mr-1"></i> 수정하러 가기
        </a>
      </div>

      <!-- 프로필 카드 -->
      <div class="card shadow-sm">
        <div class="card-header">
          <h3 class="card-title">프로필</h3>
        </div>
        <div class="card-body">

          <!-- 프로필 사진들 -->
          <div class="mb-3">
            <h6 class="text-muted mb-2">직원 사진</h6>
            <ul class="list-unstyled d-flex flex-wrap mb-0" style="gap:10px;">
              <c:choose>
                <c:when test="${not empty emp2VO.empFileVOs and not empty emp2VO.empFileVOs.fileDetailVOList}">
                  <c:forEach var="myImg" items="${emp2VO.empFileVOs.fileDetailVOList}">
                    <li class="border rounded p-1">
                      <img src="/upload${myImg.fileStrelc}" alt="${myImg.fileOrginlNm}"
                           style="width:120px; height:auto; border-radius:6px;">
                    </li>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <li class="text-muted">등록된 사진이 없습니다.</li>
                </c:otherwise>
              </c:choose>
            </ul>
          </div>

          <!-- 기본 정보 테이블 -->
          <div class="table-responsive">
            <table class="table table-hover text-nowrap mb-0">
              <tbody>
                <tr>
                  <td style="width:140px;">이름</td>
                  <td>${emp2VO.nm}</td>
                </tr>
                <tr>
                  <td>전화번호</td>
                  <td>${emp2VO.telno}</td>
                </tr>
                <tr>
                  <td>생년월일</td>
                  <td>${emp2VO.brthdy}</td>
                </tr>
                <tr>
                  <td>이메일</td>
                  <td>${emp2VO.email}</td>
                </tr>
                <tr>
                  <td>주소</td>
                  <td>${emp2VO.adres}</td>
                </tr>
                <tr>
                  <td>부서</td>
                  <td>
                    <c:choose>
                      <c:when test="${emp2VO.deptCode == 1}">
                        <span class="badge badge-primary">관리사무실</span>
                      </c:when>
                      <c:when test="${emp2VO.deptCode == 2}">
                        <span class="badge badge-info">시설</span>
                      </c:when>
                      <c:when test="${emp2VO.deptCode == 3}">
                        <span class="badge badge-secondary">경비</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge badge-light text-muted">미정</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                <tr>
                  <td>재직상태</td>
                  <td>
                    <c:choose>
                      <c:when test="${emp2VO.enabled == 1}">
                        <span class="badge badge-success">재직</span>
                      </c:when>
                      <c:when test="${emp2VO.enabled == 2}">
                        <span class="badge badge-warning">휴직</span>
                      </c:when>
                      <c:when test="${emp2VO.enabled == 3}">
                        <span class="badge badge-danger">퇴사</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge badge-light text-muted">미정</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

        </div><!-- /.card-body -->

        <div class="card-footer d-flex justify-content-between align-items-center">
          <span class="text-muted small">
<%--             개발용 FILE_GROUP_SN: ${emp2VO.fileGroupSn} --%>
          </span>
          <!-- 인감 보기 버튼 -->
          <button type="button" class="btn btn-app bg-secondary" data-toggle="modal" data-target="#signModal">
            <i class="fas fa-stamp"></i> 인감보기
          </button>
        </div>
      </div><!-- /.card -->

    </div><!-- /.col -->
  </div><!-- /.row -->
</div><!-- /.container-fluid -->

<!-- 인감 보기 모달 (보기 전용) -->
<div class="modal fade" id="signModal" tabindex="-1" role="dialog" aria-labelledby="signModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" id="signModalContent">
      <div class="modal-header">
        <h4 class="modal-title" id="signModalLabel">등록된 인감</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>

      <div class="modal-body text-center">
        <c:choose>
          <c:when test="${not empty signVO and not empty signVO.fileDetailVO}">
            <img id="currentSignImg"
                 src="/upload${signVO.fileDetailVO.fileStrelc}"
                 alt="${signVO.fileDetailVO.fileOrginlNm}"
                 style="width:160px; height:auto; border-radius:8px; border:1px solid #e1e1e1; padding:4px;">
            <div class="mt-2 text-muted small">
<%--               파일명: ${signVO.fileDetailVO.fileOrginlNm} --%>
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-muted">등록된 인감 이미지가 없습니다.</div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn bg-gradient-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<%@ include file="../include/footer.jsp"%>
</html>
