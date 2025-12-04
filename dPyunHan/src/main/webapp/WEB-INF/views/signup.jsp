<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="./include/headerContents.jsp"%>


<title>입주민 회원가입</title>

<!-- Bootstrap & jQuery -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
<link rel="stylesheet" href="/css/global/cuteModal.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
.swal2-popup {
        width: 600px !important;
        max-height: 90vh !important;
}
.swal-terms-box {
    height: 150px;
    overflow-y: auto;
    border: 1px solid #dfe0df;
    padding: 12px;
    border-radius: 6px;
    background: #fff;
    margin-bottom: 20px;
    text-align: left;
    color: #000;
}
/* 단계별 폼 */
.form-step {
    display: none;
}

.form-step-active {
    display: block;
}

/* 카드 UI */
.card-step {
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
}

.card-step h3 {
    font-weight: 700;
    margin-bottom: 20px;
}

/* 버튼 정렬 */
.btn-group-step {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
}

/* 파일 리스트 */
#fileList, #carFileList {
    height: 150px;
    border: 2px dashed #dee2e6;
    border-radius: 0.25rem;
    background-color: #f8f9fa;
    overflow-y: auto;
    padding: 10px;
    margin-bottom: 10px;
}

.file-item {
    display: flex;
    align-items: center;
    gap: 10px;
    background-color: white;
    border: 1px solid #dee2e6;
    border-radius: 0.25rem;
    padding: 5px 10px;
    margin-bottom: 5px;
}

.file-name {
    font-size: 14px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.btn-remove {
    padding: 0;
    color: red;
    cursor: pointer;
    border: none;
    background: none;
    font-size: 18px;
}

.btn-remove:hover {
    color: darkred;
    font-weight: bolder;
}
.modal_article h2 {
    text-align: center;   /* 가로 중앙 정렬 */
    margin-top: 40px;     /* 위쪽 여백으로 한 줄 띄우기 */
    margin-bottom: 20px;  /* 아래쪽 여백 */
}

</style>
</head>

<body>
    <div class="container mt-4">
        <h2 class="text-center mb-4">입주민 회원가입</h2>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger">${errorMsg}</div>
        </c:if>

        <form id="residentJoinForm"
            action="/user" method="post" enctype="multipart/form-data">

            <!-- Step 1: 기본 정보 -->
            <div class="form-step form-step-active card-step">
                <h3>기본 정보 입력</h3>

                <div class="mb-3">
                    <label for="mberId" class="form-label">ID</label> <input
                        type="text" name="mberId" id="mberId" class="form-control"
                        required />
                </div>
                <div class="mb-3">
                    <label for="mberNm" class="form-label">이름</label> <input
                        type="text" name="mberNm" id="mberNm" class="form-control"
                        required />
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">비밀번호</label> <input
                        type="password" name="password" id="password" class="form-control"
                        required placeholder="영문, 숫자, 특수문자 포함 8~20자" />
                    <small id="pwFeedback" class="form-text" style="display:none; font-size: 13px;"></small>
                </div>
                <div class="mb-3">
                    <label for="passwordConfirm" class="form-label">비밀번호 확인</label>
                    <input type="password" id="passwordConfirm" class="form-control" placeholder="비밀번호를 다시 입력해주세요" />
                    <small id="pwConfirmFeedback" class="form-text" style="display:none; font-size: 13px;"></small>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">이메일</label> <input
                        type="email" name="email" id="email" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="telno" class="form-label">전화번호</label> <input
                        type="text" name="telno" id="telno" class="form-control" />
                </div>

                <div class="mb-3">
                    <label for="brthdy" class="form-label">생년월일</label> <input
                        type="date" name="brthdy" id="brthdy" class="form-control"
                        required />
                </div>

                <div class="mb-3">
                    <label for="profileFile" class="form-label">프로필 사진</label>
                    
                        <div style="text-align:center; margin-bottom:10px;">
        <img id="previewImg" 
             src="" 
             style="max-width:150px; max-height:150px; display:none; border-radius: 8px;" />
    </div>
                    <div id="fileList" title="파일을 여기에 드래그하세요"></div>
                    <input type="file" class="form-control" id="profileFile"
                        name="profileFile" accept="image/*" />
                </div>

                <div class="btn-group-step">
                    <div></div>
                    <button type="button" class="btn btn-primary next-btn">다음</button>
                </div>
            </div>

            <!-- Step 2: 주거/차량 정보 -->
            <div class="form-step card-step">
                <h3>주거 및 차량 정보</h3>

                <div class="mb-3">
                    <label for="mberTy" class="form-label">주거타입</label> <select
                        name="mberTy" id="mberTy" class="form-control">
                        <option value="1">임대</option>
                        <option value="2">자가</option>
                        <option value="3">임차</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="aptcmpl" class="form-label">동</label> <select
                        name="aptcmpl" id="aptcmpl" class="form-control" required>
                        <option value="">동 선택</option>
                        <option value="101">101동</option>
                        <option value="102">102동</option>
                        <option value="103">103동</option>
                        <option value="104">104동</option>
                        <option value="105">105동</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="ho" class="form-label">호수</label> <select name="ho"
                        id="ho" class="form-control" required>
                        <option value="">호수 선택</option>
                        <% for(int floor=1; floor<=20; floor++){
                        for(int unit=1; unit<=2; unit++){
                            String ho = String.format("%d%02d", floor, unit); %>
                        <option value="<%=ho%>"><%=ho%>호
                        </option>
                        <% } } %>
                    </select>
                </div>

                <div class="mb-3">
                    <label><input type="checkbox" id="hasVehicle"
                        name="hasVehicle"> 차량이 있습니다</label>
                </div>

                <div id="vehicleInfo" style="display: none;">
                    <div class="mb-3">
                        <label for="vhcleNo" class="form-label">차량 번호</label> <input
                            type="text" name="vhcleNo" id="vhcleNo" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="carRegFile" class="form-label">자동차등록증</label>
                        <div id="carFileList"></div>
                        <input type="file" name="carRegFile" id="carRegFile"
                            class="form-control" accept="image/*,application/pdf">
                    </div>
                </div>

                <div class="btn-group-step">
                    <button type="button" class="btn btn-secondary prev-btn">이전</button>
                    <button type="submit" class="btn btn-primary submit-btn">회원가입</button> 
                </div>
            </div>

        </form>
    </div>

    <!--  약관 동의 모달 -->
    <div class="modal fade" id="termModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-3">

                <article class="modal_article login term p_lr_space pb24">
                    <a href="${pageContext.request.contextPath}/main"
                        class="btn-close position-absolute top-0 end-0 m-3"
                        aria-label="Close"></a>
                    <h2>약관동의</h2>

                    <input type="hidden" id="type_code" name="type_code" value="">

                    <!-- 전체 동의 -->
                    <div class="input-block all-check">
                        <div class="check">
                            <div class="checkbox checkbox-styled">
                                <label class="form-label"> <input type="checkbox"
                                    name="rdo" class="_check_all ie"
                                    onclick="$('._join_agree').prop('checked',$(this).prop('checked'));">
                                    <span class="agree_tit">이용약관, 개인정보 수집 및 이용에 모두 동의합니다.</span>
                                </label>
                            </div>
                        </div>
                    </div> 

                    <!-- 이용약관 -->
                    <div class="input-block term-block">
                        <div class="check">
                            <div class="checkbox checkbox-styled">
                                <label class="form-label"> <input type="checkbox"
                                    name="policy_agree" value="ok" id="policy_agree"
                                    class="_join_agree _policy_agree ie require_agreement">
                                    <span class="agree_tit">이용약관 동의<em class="alert">(필수)</em></span>
                                </label>
                            </div>
                        </div>

                        <div class="input-block">
                            <div class="form-group privacy">
                                <div tabindex="0"
                                    style="height: 100px; border: 1px solid #dfe0df; border-radius: 4px; padding: 12px 14px; overflow-y: auto; background: #fff; color: #000;">
                                    <strong>제1조 목적</strong><br>
                                    본 이용약관은 “D-편한세상”(이하 "사이트")의 서비스의 이용조건과 운영에 관한 제반 사항 규정을 목적으로 합니다.<br><br>
                                    <strong>제2조 용어의 정의</strong><br>
                                    본 약관에서 사용되는 주요한 용어의 정의는 다음과 같습니다.
                                    <br> ① 회원: 사이트의 약관에 동의하고 개인정보를 제공하여 회원등록을 한 자로서, 사이트와의 이용계약을 체결하고 사이트를 이용하는 이용자를 말합니다.
                                    <br> ② 이용계약: 사이트 이용과 관련하여 사이트와 회원간에 체결 하는 계약을 말합니다.
                                    <br> ③ 회원 아이디(이하 "ID"): 회원의 식별과 회원의 서비스 이용을 위하여 회원별로 부여하는 고유한 문자와 숫자의 조합을 말합니다.
                                    <br> ④ 비밀번호: 회원이 부여받은 ID와 일치된 회원임을 확인하고 회원의 권익 보호를 위하여 회원이 선정한 문자와
                                    숫자의 조합을 말합니다.
                                    <br> ⑤ 운영자: 서비스에 홈페이지를 개설하여 운영하는 운영자를 말합니다.
                                    <br> ⑥ 해지: 회원이 이용계약을 해약하는 것을 말합니다.<br><br>
                                    <strong>제3조 약관 외 준칙</strong><br>
                                    운영자는 필요한 경우 별도로 운영정책을 공지 안내할 수 있으며, 본 약관과 운영정책이 중첩될 경우 운영정책이 우선 적용됩니다.<br><br>
                                    <strong>제4조 이용계약 체결</strong>
                                    <br> ① 이용계약은 회원으로 등록하여 사이트를 이용하려는 자의 본 약관 내용에 대한 동의와 가입신청에 대하여 운영자의 이용승낙으로 성립합니다.
                                    <br> ② 회원으로 등록하여 서비스를 이용하려는 자는 사이트 가입신청 시 본 약관을 읽고 아래에 있는 "동의합니다"를 선택하는 것으로 본 약관에 대한 동의 의사 표시를 합니다.<br>
                                    <strong>제5조 서비스 이용 신청</strong>
                                    <br> ① 회원으로 등록하여 사이트를 이용하려는 이용자는 사이트에서 요청하는 제반정보(이용자ID,비밀번호, 닉네임 등)를 제공해야 합니다.
                                    <br> ② 타인의 정보를 도용하거나 허위의 정보를 등록하는 등 본인의 진정한 정보를 등록하지 않은 회원은 사이트 이용과 관련하여 아무런 권리를 주장할 수 없으며, 관계 법령에 따라 처벌받을 수 있습니다.<br><br>
                                    <strong>제6조 개인정보처리방침</strong><br>
                                    사이트 및 운영자는 회원가입 시 제공한 개인정보 중 비밀번호를 가지고 있지 않으며 이와 관련된 부분은 사이트의 개인정보처리방침을 따릅니다.<br>
                                    운영자는 관계 법령이 정하는 바에 따라 회원등록정보를 포함한 회원의 개인정보를 보호하기 위하여 노력합니다. 회원의 개인정보보호에 관하여 관계법령 및 사이트가 정하는 개인정보처리방침에 정한 바에 따릅니다.단, 회원의 귀책 사유로 인해노출된 정보에 대해 운영자는 일체의 책임을 지지 않습니다.운영자는 회원이 미풍양속에 저해되거나 국가안보에 위배되는 게시물 등 위법한 게시물을 등록 · 배포할 경우 관련 기관의 요청이 있을 시 회원의 자료를 열람 및 해당 자료를 관련 기관에 제출할 수 있습니다.<br><br>
                                    <strong>제7조 운영자의 의무</strong>
                                    <br> ① 운영자는 이용회원으로부터 제기되는 의견이나 불만이 정당하다고 인정할 경우에는 가급적 빨리 처리하여야 합니다. 다만, 개인적인 사정으로 신속한 처리가 곤란한 경우에는 사후에 공지 또는 이용회원에게 쪽지, 전자우편 등을 보내는 등 최선을 다합니다.
                                    <br> ② 운영자는 계속적이고 안정적인 사이트 제공을 위하여 설비에 장애가 생기거나 유실된 때에는 이를 지체 없이 수리 또는 복구할 수 있도록 사이트에 요구할 수 있습니다. 다만, 천재지변 또는 사이트나 운영자에 부득이한 사유가 있는 경우, 사이트 운영을 일시 정지할 수 있습니다.<br><br>
                                    <strong>제8조 회원의 의무</strong>
                                    <br> ① 회원은 본 약관에서 규정하는 사항과 운영자가 정한 제반 규정, 공지사항 및 운영정책 등 사이트가 공지하는 사항 및 관계 법령을 준수하여야 하며, 기타 사이트의 업무에 방해가 되는 행위, 사이트의 명예를 손상하는 행위를 해서는 안 됩니다.
                                    <br> ② 회원은 사이트의 명시적 동의가 없는 한 서비스의 이용 권한, 기타 이용계약상 지위를 타인에게 양도, 증여할 수 없으며, 이를 담보로 제공할 수 없습니다.
                                    <br> ③ 이용고객은 아이디 및 비밀번호 관리에 상당한 주의를 기울여야 하며, 운영자나 사이트의 동의 없이 제3자에게 아이디를 제공하여 이용하게 할 수 없습니다.
                                    <br> ④ 회원은 운영자와 사이트 및 제3자의 지적 재산권을 침해해서는 안 됩니다.<br><br>
                                    <strong>제9조 서비스 이용 시간</strong>
                                    <br> ① 서비스 이용 시간은 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴 1일 24시간을 원칙으로 합니다. 단, 사이트는 시스템 정기점검, 증설 및 교체를 위해 사이트가 정한 날이나 시간에 서비스를 일시중단 할 수 있으며 예정된 작업으로 인한 서비스 일시 중단은 사이트의 홈페이지에 사전에 공지하오니 수시로 참고하시길 바랍니다.
                                    <br> ② 단, 사이트는 다음 경우에 대하여 사전 공지나 예고 없이 서비스를 일시적 혹은 영구적으로 중단할 수 있습니다.
                                    <br>   - 긴급한 시스템 점검, 증설, 교체, 고장 혹은 오동작을 일으키는 경우
                                    <br>   - 국가비상사태, 정전, 천재지변 등의 불가항력적인 사유가 있는 경우
                                    <br>   - 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지한 경우
                                    <br>   - 서비스 이용의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
                                    <br> ③ 전항에 의한 서비스 중단의 경우 사이트는 사전에 공지사항 등을 통하여 회원에게 통지합니다. 단, 사이트가 통제할 수 없는 사유로 발생한 서비스의 중단에 대하여 사전공지가 불가능한 경우에는 사후공지로 대신합니다.<br><br>
                                    <strong>제10조 서비스 이용 해지</strong>
                                    <br> ① 회원이 사이트와의 이용계약을 해지하고자 하는 경우에는 회원 본인이 온라인을 통하여 등록해지 신청을 하여야 합니다. 한편, 사이트 이용 해지와 별개로 사이트에 대한 이용계약 해지는 별도로 하셔야 합니다.
                                    <br> ② 해지 신청과 동시에 사이트가 제공하는 사이트 관련 프로그램이 회원 관리 화면에서 자동적으로 삭제됨으로 운영자는 더 이상 해지신청자의 정보를 볼 수 없습니다.<br><br>
                                    <strong>제11조 서비스 이용 제한</strong> <br>
                                    회원은 다음 각호에 해당하는 행위를 하여서는 아니 되며 해당 행위를 한 경우에 사이트는 회원의 서비스 이용 제한 및 적법한 조치를 할 수 있으며 이용계약을 해지하거나 기간을 정하여 서비스를 중지할 수 있습니다.
                                    <br> ① 회원 가입시 혹은 가입 후 정보 변경 시 허위 내용을 등록하는 행위
                                    <br> ② 타인의 사이트 이용을 방해하거나 정보를 도용하는 행위
                                    <br> ③ 사이트의 운영진, 직원 또는 관계자를 사칭하는 행위
                                    <br> ④ 사이트, 기타 제3자의 인격권 또는 지적재산권을 침해하거나 업무를 방해하는 행위
                                    <br> ⑤ 다른 회원의 ID를 부정하게 사용하는 행위
                                    <br> ⑥ 다른 회원에 대한 개인정보를 그 동의 없이 수집, 저장, 공개하는 행위
                                    <br> ⑦ 범죄와 결부된다고 객관적으로 판단되는 행위
                                    <br> ⑧ 기타 관련 법령에 위배되는 행위<br><br>
                                    <strong>제12조 게시물의 관리</strong>
                                    <br> ① 사이트의 게시물과 자료의 관리 및 운영의 책임은 운영자에게 있습니다. 운영자는 항상 불량 게시물 및 자료에 대하여 모니터링을 하여야 하며, 불량 게시물 및 자료를 발견하거나 신고를 받으면 해당 게시물 및 자료를 삭제하고 이를 등록한 회원에게 주의를 주어야 합니다. 한편, 이용회원이 올린 게시물에 대해서는 게시자 본인에게 책임이 있으니 회원 스스로 본 이용약관에서 위배되는 게시물은 게재해서는 안 됩니다.
                                    <br> ② 정보통신윤리위원회 등 공공기관의 시정요구가 있는 경우 운영자는 회원의 사전동의 없이 게시물을 삭제하거나 이동 할 수 있습니다.
                                    <br> ③ 불량게시물의 판단기준은 다음과 같습니다.
                                    <br>   - 다른 회원 또는 제3자에게 심한 모욕을 주거나 명예를 손상하는 내용인 경우
                                    <br>   - 공공질서 및 미풍양속에 위반되는 내용을 유포하거나 링크 시키는 경우
                                    <br>   - 불법 복제 또는 해킹을 조장하는 내용인 경우
                                    <br>   - 영리를 목적으로 하는 광고일 경우
                                    <br>   - 범죄와 결부된다고 객관적으로 인정되는 내용일 경우
                                    <br>   - 다른 이용자 또는 제3자와 저작권 등 기타 권리를 침해하는 경우
                                    <br>   - 기타 관계 법령에 위배된다고 판단되는 경우
                                    <br> ④ 사이트 및 운영자는 게시물 등에 대하여 제3자로부터 명예훼손, 지적재산권 등의 권리 침해를 이유로 게시중단 요청을 받은 경우 이를 임시로 게시 중단(전송중단)할 수 있으며, 게시중단 요청자와 게시물 등록자 간에 소송, 합의 기타 이에 준하는 관련 기관의 결정 등이 이루어져 사이트에 접수된 경우 이에 따릅니다.<br><br>
                                    <strong>제13조 게시물의 보관</strong><br>
                                    사이트 운영자가 불가피한 사정으로 본 사이트를 중단하게 될 경우, 회원에게 사전 공지를 하고 게시물의 이전이 쉽도록 모든 조치를 하기 위해 노력합니다.<br><br>
                                    <strong>제14조 게시물에 대한 저작권</strong>
                                    <br> ① 회원이 사이트 내에 게시한 게시물의 저작권은 게시한 회원에게 귀속됩니다. 또한 사이트는 게시자의 동의 없이 게시물을 상업적으로 이용할 수 없습니다. 다만 비영리 목적인 경우는 그러하지 아니하며, 또한 서비스 내의 게재권을 갖습니다.
                                    <br> ② 회원은 서비스를 이용하여 취득한 정보를 임의 가공, 판매하는 행위 등 서비스에 게재된 자료를 상업적으로 사용할 수 없습니다.
                                    <br> ③ 운영자는 회원이 게시하거나 등록하는 사이트 내의 내용물, 게시 내용에 대해 제12조 각호에 해당한다고 판단되는 경우 사전통지 없이 삭제하거나 이동 또는 등록 거부할 수 있습니다.<br><br>
                                    <strong>제15조 손해배상</strong>
                                    <br> ① 본 사이트의 발생한 모든 민, 형법상 책임은 회원 본인에게 1차적으로 있습니다.
                                    <br> ② 본 사이트로부터 회원이 받은 손해가 천재지변 등 불가항력적이거나 회원의 고의 또는 과실로 인하여 발생한 때에는 손해배상을 하지 않습니다.<br><br>
                                    <strong>제16조 면책</strong>
                                    <br> ① 운영자는 회원이 사이트의 서비스 제공으로부터 기대되는 이익을 얻지 못하였거나 서비스 자료에 대한 취사선택 또는 이용으로 발생하는 손해 등에 대해서는 책임이 면제됩니다.
                                    <br> ② 운영자는 본 사이트의 서비스 기반 및 타 통신업자가 제공하는 전기통신 서비스의 장애로 인한 경우에는 책임이 면제되며 본 사이트의 서비스 기반과 관련되어 발생한 손해에 대해서는 사이트의 이용약관에 준합니다.
                                    <br> ③ 운영자는 회원이 저장, 게시 또는 전송한 자료와 관련하여 일체의 책임을 지지 않습니다.
                                    <br> ④ 운영자는 회원의 귀책 사유로 인하여 서비스 이용의 장애가 발생한 경우에는 책임지지 아니합니다.
                                    <br> ⑤ 운영자는 회원 상호 간 또는 회원과 제3자 상호 간, 기타 회원의 본 서비스 내외를 불문한 일체의 활동(데이터 전송, 기타 커뮤니티 활동 포함)에 대하여 책임을 지지 않습니다.
                                    <br> ⑥ 운영자는 회원이 게시 또는 전송한 자료 및 본 사이트로 회원이 제공받을 수 있는 모든 자료들의 진위, 신뢰도, 정확성 등 그 내용에 대해서는 책임지지 아니합니다.
                                    <br> ⑦ 운영자는 회원 상호 간 또는 회원과 제3자 상호 간에 서비스를 매개로 하여 물품거래 등을 한 경우에 그로부터 발생하는 일체의 손해에 대하여 책임지지 아니합니다.
                                    <br> ⑧ 운영자는 운영자의 귀책 사유 없이 회원간 또는 회원과 제3자간에 발생한 일체의 분쟁에 대하여 책임지지 아니합니다.
                                    <br> ⑨ 운영자는 서버 등 설비의 관리, 점검, 보수, 교체 과정 또는 소프트웨어의 운용 과정에서 고의 또는 고의에 준하는 중대한 과실 없이 발생할 수 있는 시스템의 장애, 제3자의 공격으로 인한 시스템의 장애, 국내외의 저명한 연구기관이나 보안 관련 업체에 의해 대응 방법이 개발되지 아니한 컴퓨터 바이러스 등의 유포나 기타 운영자가 통제할 수 없는 불가항력적 사유로 인한 회원의 손해에 대하여 책임지지 않습니다.<br><br>
                                    <strong>부칙</strong><br>
                                    이 약관은 &lt;2025-12-04&gt;부터 시행합니다.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 개인정보 수집 -->
                    <div class="input-block">
                        <div class="check">
                            <div class="checkbox checkbox-styled">
                                <label class="form-label"> <input type="checkbox"
                                    name="privacy_agree" value="ok" id="privacy_agree"
                                    class="_join_agree _privacy_agree ie require_agreement">
                                    <span class="agree_tit">개인정보 수집 및 이용 동의<em class="alert">(필수)</em></span>
                                </label>
                            </div>
                        </div>

                        <div class="input-block">
                            <div class="form-group privacy">
                                <div tabindex="0"
                                    style="height: 100px; border: 1px solid #dfe0df; border-radius: 4px; padding: 12px 14px; overflow-y: auto; background: #fff; color: #000;">
                                    <strong>제1조 개인정보의 수집 항목 및 방법 </strong><br>
                                    회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.<br>필수 정보에는 세대 인증을 위한 입주민 정보, 이름, 아이디, 비밀번호, 연락처, 세대 정보, 아파트 동·호수, 서비스 이용 기록 등이 포함됩니다. 선택 정보에는 프로필 이미지, 알림 수신 설정 등 이용 편의 향상을 위해 필요한 항목이 포함될 수 있습니다. 회사는 회원가입 시 이용자가 직접 입력한 정보, 서비스 이용 과정에서 자동 생성되는 정보, 민원·예약 처리 과정에서 이용자가 제공하는 정보 등을 통해 개인정보를 수집합니다.<br><br>
                                    <strong>제2조 개인정보의 수집 및 이용 목적</strong><br>
                                    회사는 수집한 개인정보를 다음 목적을 위해 이용합니다.<br>① 회원가입 및 본인·세대 인증을 위하여 개인정보를 이용합니다.
                                    <br> ② 민원 접수·처리, 커뮤니티 시설 예약, 전자결재, 알림 제공 등 서비스 본연의 기능을 수행하기 위해 개인정보를 이용합니다.
                                    <br> ③ 서비스 운영, 장애 대응, 이용 패턴 분석 등 서비스 품질 개선을 위해 개인정보를 활용합니다.
                                    <br> ④ 불법·부정 이용 방지 및 시스템 보안 강화를 위해 개인정보를 이용합니다
                                    <br> ⑤ 법령 준수 및 민원 처리 등 행정적·법적 의무 이행을 위한 목적으로 개인정보를 이용합니다.<br><br>
                                    <strong>제3조 개인정보의 보유 및 이용 기간</strong><br>
                                    회사는 개인정보의 수집·이용 목적이 달성된 후에는 관련 법령에 따라 필요한 기간 동안만 개인정보를 보유합니다.<br>회원 탈퇴 시에는 원칙적으로 즉시 개인정보를 파기합니다. 단, 「전자상거래 등에서의 소비자 보호에 관한 법률」, 「통신비밀보호법」 등 관련 법령에 따라 계약 또는 청약철회 기록, 결제 및 사용 내역, 접속로그 등은 일정 기간 보관할 수 있습니다. 또한 서비스 운영상 민원 처리 이력, 시설 예약 내역 등은 공동체 운영 필요에 따라 일정 기간 보관할 수 있습니다.<br><br>
                                    <strong>제4조 개인정보의 제3자 제공</strong><br>
                                    회사는 이용자의 개인정보를 원칙적으로 제3자에게 제공하지 않습니다.<br>다만, 이용자의 동의가 있는 경우, 법령에 의해 제공이 요구되는 경우, 범죄 예방·수사 등 공공 목적을 위한 요청이 있을 경우 제공할 수 있습니다.<br><br>
                                    <strong>제5조 개인정보 처리의 위탁</strong><br>
                                    회사는 서비스 제공의 효율성을 위해 일부 업무를 외부 전문 업체에 위탁할 수 있습니다.<br>위탁 시 개인정보 보호 관련 법령에 따라 위탁 업체를 관리·감독하며, 위탁 업무의 내용과 수탁 업체를 이용자에게 공개합니다.<br><br>
                                    <strong>제6조 이용자의 권리 및 행사 방법</strong><br>
                                    이용자는 언제든지 자신의 개인정보 열람, 정정, 삭제, 처리정지 요구를 할 수 있습니다.<br>이러한 요구는 서비스 내 설정 화면 또는 고객센터를 통해 신청할 수 있으며, 회사는 법령에 따라 지체 없이 필요한 조치를 취합니다. 단, 다른 법령에 따라 보관이 필요한 정보는 삭제가 제한될 수 있습니다.<br><br>
                                    <strong>제7조 개인정보의 파기 절차 및 방법</strong><br>
                                    회사는 개인정보 보유 기간이 경과하거나 처리 목적이 달성된 경우 지체 없이 해당 정보를 파기합니다.<br>파기는 복구할 수 없는 방식으로 수행되며, 전자적 파일 형태는 복구 불가능한 기술적 방법으로 삭제하고, 종이 문서는 분쇄 또는 소각을 통해 파기합니다. 일부 정보는 법령에 따라 일정 기간 보관 후 파기할 수 있습니다.<br><br>
                                    <strong>제8조 개인정보 자동 수집 장치의 설치·운영 및 거부</strong><br>
                                    회사는 서비스 품질 향상과 사용 편의 제공을 위해 쿠키 등 자동 수집 기술을 사용할 수 있습니다.<br>이용자는 브라우저 설정을 통해 쿠키 저장을 거부할 수 있으나, 이 경우 일부 서비스 이용에 제한이 발생할 수 있습니다.<br><br>
                                    <strong>제9조 개인정보의 안전성 확보조치</strong><br>
                                    회사는 개인정보 보호를 위해 다음과 같은 기술적·관리적·물리적 조치를 시행합니다.<br>개인정보에 대한 접근권한 통제, 비밀번호 암호화, 데이터 암호화, 침입 차단 시스템 운영, 접근 기록 관리, 정기적 보안 점검, 개인정보 접근 인원의 최소화, 물리적 보관시설의 출입 통제 등 법령에서 요구하는 수준 이상의 보안 체계를 유지합니다.<br><br>
                                    <strong>제10조 개인정보 보호책임자 및 담당부서</strong><br>
                                    회사는 개인정보 보호 책임자를 지정하여 이용자의 개인정보 보호 및 관련 민원을 처리합니다.<br>개인정보 보호책임자 및 담당부서의 연락처는 서비스 화면 또는 홈페이지에 고지합니다.<br><br>
                                    <strong>제11조 개인정보 처리방침의 변경</strong><br>
                                    회사는 개인정보처리방침을 변경할 수 있으며, 변경 시 적용일자와 변경 내용을 사전 공지합니다.<br>법령, 서비스 구조, 보안정책 변경 등 합리적인 사유가 있는 경우 개정될 수 있습니다. 변경된 내용은 공지한 적용일자부터 효력이 발생합니다.<br><br>
                                    <strong>제12조 권익침해 구제 방법</strong><br>
                                    이용자는 개인정보 침해와 관련하여 한국인터넷진흥원(KISA) 침해신고센터, 개인정보분쟁조정위원회 등 관련 기관에 도움을 요청할 수 있으며, 회사는 법령에 따라 필요한 협조를 제공합니다.<br>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 나이 확인 -->
                    <div class="input-block mb-3">
                        <div class="check">
                            <div class="checkbox checkbox-styled">
                                <label class="form-label"> <input type="checkbox"
                                    id="limit_join_agree" name="limit_join_agree" value="ok"
                                    class="_join_agree"> <span>만 14세 이상입니다. <em
                                        class="alert">(필수)</em></span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- 버튼 영역 -->
                    <div class="btn-block d-flex justify-content-between mt-3">
                        <a href="${pageContext.request.contextPath}/main"
                            class="btn btn-secondary">취소</a> <a href="javascript:;"
                            class="btn btn-primary _join_btn">가입하기</a>
                    </div>

<script>
document.addEventListener("DOMContentLoaded", function() {

    // 약관 HTML 템플릿 구성
    const termsHtml = `
	    <h3 style="margin-bottom:15px;">약관 동의</h3>
	
	    <label>
	        <input type="checkbox" id="swal_agree_all"> 
	        <strong>전체 동의하기</strong>
	    </label>
	    <hr>
	
	    <label>
	        <input type="checkbox" id="swal_policy_agree">
	        <span>이용약관 동의 (필수)</span>
	    </label>
	    <div class="swal-terms-box">
	        \${document.querySelector('.term-block .privacy').innerHTML}
	    </div>
	
	    <label>
	        <input type="checkbox" id="swal_privacy_agree">
	        <span>개인정보 수집 및 이용 동의 (필수)</span>
	    </label>
	    <div class="swal-terms-box">
	        \${document.querySelectorAll('.privacy')[1].innerHTML}
	    </div>
	
	    <label style="margin-top:10px;">
	        <input type="checkbox" id="swal_limit_join_agree">
	        만 14세 이상입니다. (필수)
	    </label>
	    <br><br>
	`;

	document.getElementById("profileFile").addEventListener("change", function (e) {
    const file = e.target.files[0];
    const preview = document.getElementById("previewImg");

    if (file) {
        const reader = new FileReader();
        reader.onload = function (event) {
            preview.src = event.target.result;
            preview.style.display = "block"; // 이미지 표시
        };
        reader.readAsDataURL(file);
    } else {
        preview.src = "";
        preview.style.display = "none"; // 파일 없을 때 숨기기
    }
});
    // SweetAlert로 약관 모달 표시
    Swal.fire({
        html: termsHtml,
        showCancelButton: false,
        showConfirmButton: true,
        confirmButtonText: "동의합니다",
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        backdrop: true,
        customClass: { popup: 'cute-modal' },
        // 팝업 열릴 때 스크롤 막기
        didOpen: () => {
        	document.documentElement.style.overflow = 'hidden'; // html 스크롤 잠금
            document.body.style.overflow = 'hidden'; // body 스크롤 잠금
        },

        // 팝업 닫힐 때 스크롤 복구
        willClose: () => {
        	document.documentElement.style.overflow = '';
            document.body.style.overflow = '';
        }
        
    }).then((result) => {
        if (!result.isConfirmed) return;

        // 체크 확인
        const a = document.getElementById("policy_agree").checked;
        const b = document.getElementById("privacy_agree").checked;
        const c = document.getElementById("limit_join_agree").checked;

        if (!a || !b || !c) {
            Swal.fire({
                icon: "error",
                text: "필수 항목에 모두 동의해주세요.",
            }).then(() => location.reload());
        }
    });

    // 전체 동의 기능
    document.addEventListener("change", (e) => {
        
    	if (e.target.id === "swal_agree_all") {
            const checked = e.target.checked;

            document.getElementById("swal_policy_agree").checked = checked;
            document.getElementById("swal_privacy_agree").checked = checked;
            document.getElementById("swal_limit_join_agree").checked = checked;

            document.querySelector("._policy_agree").checked = checked;
            document.querySelector("._privacy_agree").checked = checked;
            document.querySelector("#limit_join_agree").checked = checked;
        }
    	
    	if (["swal_policy_agree", "swal_privacy_agree", "swal_limit_join_agree"].includes(e.target.id)) {
    	    const a = document.getElementById("swal_policy_agree").checked;
    	    const b = document.getElementById("swal_privacy_agree").checked;
    	    const c = document.getElementById("swal_limit_join_agree").checked;

    	    document.getElementById("swal_agree_all").checked = (a && b && c);

    	    document.querySelector("._policy_agree").checked = a;
    	    document.querySelector("._privacy_agree").checked = b;
    	    document.querySelector("#limit_join_agree").checked = c;
    	}
    });
    function validatePassword(pw) {
        // 정규식 설명:
        // (?=.*[a-zA-Z]) : 영문자가 적어도 1개 이상
        // (?=.*[0-9])    : 숫자가 적어도 1개 이상
        // (?=.*[!@#$%^&*?_]) : 특수문자가 적어도 1개 이상 (허용할 특수문자 나열)
        // .{8,20}        : 총 길이가 8자에서 20자 사이
        const regex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,20}$/;
        return regex.test(pw);
    }

    // [추가] 비밀번호 입력 시 실시간 피드백 (keyup 이벤트)
    const pwInput = document.getElementById('password');
    const pwFeedback = document.getElementById('pwFeedback');

    const pwConfirmInput = document.getElementById('passwordConfirm');
    const pwConfirmFeedback = document.getElementById('pwConfirmFeedback');

    // [추가] 비밀번호 일치 확인 함수
    function checkPasswordMatch() {
        const pw = pwInput.value;
        const pwConfirm = pwConfirmInput.value;

        // 확인칸이 비어있으면 초기화
        if(pwConfirm === "") {
            pwConfirmFeedback.style.display = 'none';
            pwConfirmInput.classList.remove('is-valid', 'is-invalid');
            return;
        }

        pwConfirmFeedback.style.display = 'block';

        if(pw === pwConfirm) {
            pwConfirmFeedback.textContent = "비밀번호가 일치합니다.";
            pwConfirmFeedback.style.color = "green";
            pwConfirmInput.classList.remove('is-invalid');
            pwConfirmInput.classList.add('is-valid');
        } else {
            pwConfirmFeedback.textContent = "비밀번호가 일치하지 않습니다.";
            pwConfirmFeedback.style.color = "red";
            pwConfirmInput.classList.remove('is-valid');
            pwConfirmInput.classList.add('is-invalid');
        }
    }

    pwInput.addEventListener('keyup', function() {
        const pw = this.value;
        pwFeedback.style.display = 'block'; // 메시지 보이게 설정

        if(pw.length === 0) {
            pwFeedback.textContent = "";
            return;
        }

        if(validatePassword(pw)) {
            pwFeedback.textContent = "사용 가능한 비밀번호입니다.";
            pwFeedback.style.color = "green";
            pwInput.classList.remove('is-invalid');
            pwInput.classList.add('is-valid'); // 부트스트랩 성공 스타일
        } else {
            pwFeedback.textContent = "비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자여야 합니다.";
            pwFeedback.style.color = "red";
            pwInput.classList.remove('is-valid');
            pwInput.classList.add('is-invalid'); // 부트스트랩 에러 스타일
        }
        checkPasswordMatch();
    });
    pwConfirmInput.addEventListener('keyup', checkPasswordMatch);

    // ============================
    // STEP 이동 — alert → Swal 교체
    // ============================

    const steps = document.querySelectorAll('.form-step');
    let currentStep = 0;

    function showStep(step){
        steps.forEach(s => s.classList.remove('form-step-active'));
        steps[step].classList.add('form-step-active');
    }

    document.querySelectorAll('.next-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            if(currentStep === 0){
                const id = document.getElementById('mberId').value.trim();
                const pw = document.getElementById('password').value.trim();
                const pwConfirm = document.getElementById('passwordConfirm').value.trim();
                const email = document.getElementById('email').value.trim();
                const birth = document.getElementById('brthdy').value.trim();

                if(!id || !pw || !email || !birth){
                    Swal.fire({ icon:"warning", text:"모든 항목을 입력해주세요." });
                    return;
                }

                if(!validatePassword(pw)) {
                    Swal.fire({
                        icon: "error",
                        title: "비밀번호 오류",
                        text: "비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자여야 합니다."
                    });
                    // 포커스를 비밀번호 입력창으로 이동
                    document.getElementById('password').focus();
                    return;
                }
                // 2. [추가] 일치 여부 검사 실패 시
                if(pw !== pwConfirm) {
                    Swal.fire({
                        icon: "error",
                        title: "비밀번호 불일치",
                        text: "비밀번호가 서로 일치하지 않습니다."
                    });
                    document.getElementById('passwordConfirm').focus();
                    return;
                }
            }
            currentStep++;
            showStep(currentStep);
        });
    });

    document.querySelectorAll('.prev-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            currentStep--;
            showStep(currentStep);
        });
    });

    // 차량 체크
    document.getElementById('hasVehicle').addEventListener('change', function(){
        const vehicleInfo = document.getElementById('vehicleInfo');
        vehicleInfo.style.display = this.checked ? "block" : "none";
        if (!this.checked) {
            document.getElementById('vhcleNo').value = '';
            document.getElementById('carRegFile').value = '';
        }
    });

    // 파일 업로드 처리
    function readOneFile(file, arr, container){
        if(arr.some(f => f.name === file.name && f.size === file.size)){
            Swal.fire({ icon:"warning", text:"이미 추가된 파일입니다." });
            return;
        }

        file.fileId = Date.now() + Math.random();
        arr.push(file);

        const fileItem = document.createElement("div");
        fileItem.className = "file-item";
        fileItem.dataset.fileId = file.fileId;
        fileItem.innerHTML =
            `<div class="file-name" title="\${file.name}">\${file.name}</div>
             <button type="button" class="btn-remove">×</button>`;

        container.appendChild(fileItem);

        fileItem.querySelector('.btn-remove').addEventListener('click', () => {
            container.removeChild(fileItem);
            const idx = arr.findIndex(f => f.fileId === file.fileId);
            if(idx > -1) arr.splice(idx, 1);
        });
    }

    const uploadedFiles = [];
    const profileFile = document.getElementById("profileFile");
    const fileList = document.getElementById("fileList");

    profileFile.addEventListener("change", e => {
        Array.from(e.target.files).forEach(file => {
            readOneFile(file, uploadedFiles, fileList);
        });
    });

    const carFiles = [];
    const carFileList = document.getElementById("carFileList");
    const carFileUpload = document.getElementById("carRegFile");

    carFileUpload.addEventListener("change", e => {
    	const file = e.target.files[0]; // 단일 파일
        if(file) {
            carFiles[0] = file; // 배열에 저장 (기존 readOneFile 호환)
        }
    });

/*     // 최종 제출 — alert → Swal 교체
    document.querySelector('.submit-btn').addEventListener('click', function(e){
        const type = document.getElementById('residesttus').value;
        const apt = document.getElementById('aptcmpl').value;
        const ho = document.getElementById('ho').value;

        const hasVehicle = document.getElementById('hasVehicle').checked;
        const vhcleNo = document.getElementById('vhcleNo').value.trim();
        const carReg = (carFiles.length > 0);

        if(!type || !apt || !ho){
            Swal.fire({ icon:"warning", text:"주거 타입, 동, 호수를 선택해주세요." });
            e.preventDefault();
            return false;
        }

        if(hasVehicle && (!vhcleNo || !carReg)){
            Swal.fire({ icon:"warning", text:"차량 정보를 모두 입력해주세요." });
            e.preventDefault();
            return false;
        }

        document.getElementById('residentJoinForm').submit();
    });

    showStep(currentStep);
}); */
	document.querySelector('.submit-btn').addEventListener('click', function(e){
	    e.preventDefault(); 
	
	    const type = document.getElementById('mberTy').value;
	    const apt = document.getElementById('aptcmpl').value;
	    const ho = document.getElementById('ho').value;
	
	    const hasVehicle = document.getElementById('hasVehicle').checked;
	    const vhcleNo = document.getElementById('vhcleNo').value.trim();
	    const carReg = (carFiles.length > 0);
	
	    if(!type || !apt || !ho){
	        Swal.fire({ icon:"warning", text:"주거 타입, 동, 호수를 선택해주세요." });
	        return false;
	    }
	
	    if(hasVehicle && (!vhcleNo || !carReg)){
	        Swal.fire({ icon:"warning", text:"차량 정보를 모두 입력해주세요." });
	        return false;
	    }
	
	    // 폼 데이터 준비 (파일 데이터 포함)
	    const form = document.getElementById('residentJoinForm');
	    const formData = new FormData(form);
	
	    // 만약 멀티 파트 업로드를 커스텀했다면 아래 코드가 필요할 수 있음
	    
	    uploadedFiles.forEach(file => {
	        formData.append('profileFile', file); // 'profileFile'은 서버에서 받는 이름
	    });
	    if(carFiles[0]) {
	        formData.append('carRegFile', carFiles[0]);
	    }
	    
	    Swal.fire({
	        icon: "success",
	        title: "회원가입 완료",
	        text: "D-편한세상 입주민으로 회원가입이 완료되었습니다!",
	        confirmButtonText: "확인"
	    }).then(() => {
	        form.submit(); 
	    });
	});

showStep(currentStep);
});
</script>
