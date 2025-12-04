<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="../include/header.jsp"%>

<!-- Daum 주소검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
// ===== 주소검색/상세주소 합치기 =====
let baseAddress = "";

function sample4_execDaumPostcode() {
  new daum.Postcode({
    oncomplete: function (data) {
      baseAddress = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
      const adresInput = document.getElementById("adres");
      adresInput.value = baseAddress;
      combineAddress();
    }
  }).open();
}

function combineAddress() {
  const detail = document.getElementById("adresDetail").value.trim();
  const adresInput = document.getElementById("adres");
  const base = baseAddress || adresInput.value.split(/\s{2,}|$/)[0].trim();
  const merged = detail ? (base + " " + detail).trim() : base;
  adresInput.value = merged;
  // EmpVO에 매핑되지 않도록 hidden으로만 전송
  const hidden = document.getElementById("adresDetailHidden");
  if (hidden) hidden.value = detail;
}

document.addEventListener("DOMContentLoaded", function () {
  const detailInput = document.getElementById("adresDetail");
  if (detailInput) detailInput.addEventListener("input", combineAddress);
});
</script>

<div class="container-fluid">
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <!-- 헤더/타이틀 -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <h2 class="mb-0">직원 정보 수정</h2>
        <a href="/emp/empMyPage/${empId}" class="btn bg-gradient-secondary">
          <i class="fas fa-arrow-left mr-1"></i> 돌아가기
        </a>
      </div>

      <form id="frmSubmit" action="/emp/empEdit" method="post" enctype="multipart/form-data">
        <div class="card shadow-sm">
          <div class="card-header">
            <h3 class="card-title">프로필</h3>
          </div>

          <div class="card-body">
            <!-- 기존 프로필 이미지 썸네일들 -->
            <div class="mb-3">
              <h6 class="text-muted mb-2">현재 사진</h6>
              <ul class="list-unstyled d-flex flex-wrap mb-0" style="gap:10px;">
                <c:choose>
                  <c:when test="${not empty emp2VO.empFileVOs and not empty emp2VO.empFileVOs.fileDetailVOList}">
                    <c:forEach var="myImg" items="${emp2VO.empFileVOs.fileDetailVOList}">
                      <li class="border rounded p-1 ">
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

            <!-- 새 이미지 업로드 (커스텀 버튼형 + 미리보기) -->
            <div class="form-group text-center">
              <!-- 숨겨진 실제 파일 input -->
              <input type="file" id="img" name="uploadFiles" accept="image/*" style="display:none;">
              <!-- 커스텀 버튼 -->
              <button type="button" class="btn btn-outline-primary d-flex flex-wrap" id="btnImgSelect">
                <i class="fas fa-image"></i> 이미지 선택
              </button>
              <span id="fileName" class="text-muted d-flex flex-wrap ml-2 ">선택된 파일 없음</span>
              <!-- 미리보기 -->
              <div id="imgPreview" class="mt-3"></div>
            </div>

            <!-- 서버 보존값/숨김 필드 -->
            <input type="hidden" id="empPassword" name="empPassword" value="${emp2VO.empPassword}" />
            <input type="hidden" id="nm" name="nm" value="${emp2VO.nm}" />
            <input type="hidden" id="clsf" name="clsf" value="${emp2VO.clsf}" />
            <input type="hidden" id="salary" name="salary" value="${emp2VO.salary}" />
            <!-- EmpVO에 없는 상세주소는 hidden으로만 전송 -->
            <input type="hidden" id="adresDetailHidden" name="adresDetailHidden" />

            <!-- 정보 입력 테이블 -->
            <div class="table-responsive">
              <table class="table table-hover text-nowrap mb-0">
                <tbody>
                  <tr>
                    <td style="width:140px;">이름</td>
                    <td class="align-middle">
                      <span class="font-weight-bold">${emp2VO.nm}</span>
                    </td>
                  </tr>

                  <tr>
                    <td>전화번호</td>
                    <td><input id="telno" type="text" name="telno" class="form-control"
                               value="${emp2VO.telno}" placeholder="예) 010-1234-5678"></td>
                  </tr>

                  <tr>
                    <td>생년월일</td>
                    <td><input id="brthdy" type="text" name="brthdy" class="form-control"
                               value="${emp2VO.brthdy}" placeholder="8자리 숫자 (예: 19900101)"></td>
                  </tr>

                  <tr>
                    <td>이메일</td>
                    <td><input id="email" type="text" name="email" class="form-control"
                               value="${emp2VO.email}" placeholder="example@company.com"></td>
                  </tr>

                  <!-- 주소 -->
                  <tr>
                    <td>주소</td>
                    <td>
                      <div class="input-group mb-2">
                        <input type="text" id="adres" name="adres" class="form-control"
                               placeholder="주소를 클릭하여 검색하세요"
                               value="${emp2VO.adres}" readonly>
                        <div class="input-group-append">
                          <button type="button" class="btn btn-info" onclick="sample4_execDaumPostcode()">주소검색</button>
                        </div>
                      </div>
                      <!-- EmpVO 매핑 방지: name 제거 -->
                      <input type="text" id="adresDetail" class="form-control"
                             placeholder="상세주소 (동/호, 건물명 등)">
                    </td>
                  </tr>

                  <!-- 부서 -->
                  <tr>
                    <td>부서</td>
                    <td>
                      <select id="deptCode" name="deptCode" class="custom-select">
                        <option value="1" <c:if test="${emp2VO.deptCode == 1}">selected</c:if>>관리사무실</option>
                        <option value="2" <c:if test="${emp2VO.deptCode == 2}">selected</c:if>>시설</option>
                        <option value="3" <c:if test="${emp2VO.deptCode == 3}">selected</c:if>>경비</option>
                      </select>
                    </td>
                  </tr>

                  <!-- 재직상태 -->
                  <tr>
                    <td>재직상태</td>
                    <td>
                      <div class="icheck-primary d-inline mr-3">
                        <input type="radio" id="enabled1" name="enabled" value="1" <c:if test="${emp2VO.enabled == 1}">checked</c:if>>
                        <label for="enabled1">재직</label>
                      </div>
                      <div class="icheck-primary d-inline mr-3">
                        <input type="radio" id="enabled2" name="enabled" value="2" <c:if test="${emp2VO.enabled == 2}">checked</c:if>>
                        <label for="enabled2">휴직</label>
                      </div>
                      <div class="icheck-primary d-inline">
                        <input type="radio" id="enabled3" name="enabled" value="3" <c:if test="${emp2VO.enabled == 3}">checked</c:if>>
                        <label for="enabled3">퇴사</label>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

          </div><!-- /.card-body -->

          <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-muted small"><!-- 개발용 FILE_GROUP_SN: ${emp2VO.fileGroupSn} --></span>
              <button type="submit" class="btn bg-gradient-success" style="width:150px;">수정하기</button>
            </div>
          </div>
        </div><!-- /.card -->
      </form>

      <!-- 서명 관리 카드 -->
      <div class="card shadow-sm mt-3">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h3 class="card-title mb-0">서명 관리</h3>
          <button type="button" class="btn btn-app bg-secondary" data-toggle="modal" data-target="#signModal">
            <i class="fas fa-stamp"></i> 인감 수정
          </button>
        </div>
        <div class="card-body">
          <c:if test="${not empty signVO and not empty signVO.fileDetailVO}">
            <div class="text-center">
              <img src="/upload${signVO.fileDetailVO.fileStrelc}" alt="${signVO.fileDetailVO.fileOrginlNm}"
                   style="width:120px; height:auto; border-radius:6px; border:1px solid #e1e1e1; padding:4px;">
              <div class="mt-2 text-muted small">현재 인감: ${signVO.fileDetailVO.fileOrginlNm}</div>
            </div>
          </c:if>
          <c:if test="${empty signVO or empty signVO.fileDetailVO}">
            <div class="text-muted">등록된 인감 이미지가 없습니다.</div>
          </c:if>
        </div>
      </div>

      <!-- 서명 수정 모달 -->
      <div class="modal fade" id="signModal" tabindex="-1" role="dialog" aria-labelledby="signModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content" id="signModalContent">
            <div class="modal-header">
              <h4 class="modal-title" id="signModalLabel">인감 수정</h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span>
              </button>
            </div>

            <form id="signForm1" action="/emp/insertSign" method="post" enctype="multipart/form-data">
              <div class="modal-body">
                <c:if test="${not empty signVO and not empty signVO.fileDetailVO}">
                  <div class="text-center mb-3">
                    <img id="currentSignImg" src="/upload${signVO.fileDetailVO.fileStrelc}"
                         alt="${signVO.fileDetailVO.fileOrginlNm}"
                         style="width:120px; height:auto; border-radius:6px; border:1px solid #e1e1e1; padding:4px;">
                  </div>
                </c:if>

                <!-- 숨겨진 실제 파일 input -->
                <input id="SignImg" type="file" name="uploadFiles" accept="image/*" style="display:none;">

                <div class="text-center">
                  <button type="button" class="btn btn-outline-primary" id="btnSignSelect">
                    <i class="fas fa-image"></i> 인감 이미지 선택
                  </button>
                  <span id="signFileName" class="text-muted ml-2">선택된 파일 없음</span>
                </div>

                <div class="text-center">
                  <div class="mt-3">미리보기</div>
                  <div id="SignImgPreview" class="mt-1"></div>
                </div>

                <!-- 필수키값 -->
                <input type="hidden" name="empId" value="${signVO.empId}"/>
                <input type="hidden" name="signId" value="${signVO.signId}"/>
                <input type="hidden" name="fileGroupSn2" value="${emp2VO.fileGroupSn}"/>
              </div>

              <div class="modal-footer justify-content-between">
                <button type="button" class="btn bg-gradient-secondary" data-dismiss="modal">닫기</button>
                <button type="submit" class="btn bg-gradient-success">저장</button>
              </div>
            </form>
          </div>
        </div>
      </div>

    </div><!-- /.col -->
  </div><!-- /.row -->
</div><!-- /.container-fluid -->

<%@ include file="../include/footer.jsp"%>

<script>
// ===== 프로필 이미지: 커스텀 버튼 + 파일명 표시 + 미리보기 =====
document.addEventListener("DOMContentLoaded", function () {
  // 프로필
  const realInput = document.getElementById("img");
  const btn = document.getElementById("btnImgSelect");
  const fileName = document.getElementById("fileName");
  const preview = document.getElementById("imgPreview");

  if (btn && realInput) {
    btn.addEventListener("click", function () { realInput.click(); });
    realInput.addEventListener("change", function () {
      if (realInput.files.length > 0) {
        fileName.textContent = realInput.files[0].name;
      } else {
        fileName.textContent = "선택된 파일 없음";
      }
      renderPreview(realInput.files, preview, 150);
    });
  }

  // 서명
  const signInput = document.getElementById("SignImg");
  const btnSign = document.getElementById("btnSignSelect");
  const signFileName = document.getElementById("signFileName");
  const signPreview = document.getElementById("SignImgPreview");

  if (btnSign && signInput) {
    btnSign.addEventListener("click", function () { signInput.click(); });
    signInput.addEventListener("change", function () {
      if (signInput.files.length > 0) {
        signFileName.textContent = signInput.files[0].name;
      } else {
        signFileName.textContent = "선택된 파일 없음";
      }
      renderPreview(signInput.files, signPreview, 160);
    });
  }

  function renderPreview(filesLike, targetEl, maxW) {
    if (!targetEl) return;
    targetEl.innerHTML = "";
    if (!filesLike || !filesLike.length) return;

    const file = filesLike[0];
    if (!file.type.match("image.*")) {
      alert("이미지 파일만 업로드 가능합니다.");
      return;
    }

    const reader = new FileReader();
    reader.onload = function (ev) {
      const img = document.createElement("img");
      img.src = ev.target.result;
      img.alt = "미리보기";
      img.style.maxWidth = (maxW || 150) + "px";
      img.style.borderRadius = "8px";
      img.className = "border";
      targetEl.appendChild(img);
    };
    reader.readAsDataURL(file);
  }
});
</script>
</html>
