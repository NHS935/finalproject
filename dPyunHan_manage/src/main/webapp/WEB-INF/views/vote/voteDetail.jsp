<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>


<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>
<!-- /// header 끝 /// -->
<!-- body시작은 header 에서부터  -->


<!-- 좌측 섹션 -->
<!-- <section class="content"> -->
<div class="row">
	<!-- 좌측 섹션 -->
	<section class="col-md-8 connectedSortable ui-sortable">


	<div class="card">
	<div class="card-header">
		<h3
			style="font-size: 1.2rem; display: flex; gap: .5rem; align-items: center; margin: 0;">
			<span class="badge bg-secondary text-white rounded-pill px-2">순번: ${voteMtrVO.voteMtrSn}</span><span class="text-white-50">|</span> <small
				class="fw-normal"> 작성자: ${nm}<span id="md-empNm"></span>
			</small>
		</h3>
		</div>
		<!-- /.card-header -->


		<div class="card-body">
			<div class="form-group">
				<input type="text" value="${voteMtrVO.mtrSj}" class="form-control"
					readonly>
			</div>
			<div class="form-group">
				<table style="border-collapse: collapse; border: none; width: 100%;">
					<tr>
						<th style="border: none; text-align: left;">투표 기간</th>
						<td style="border: none;"><input type="text"
							value="${fn:substring(voteMtrVO.voteBeginDt, 0, 10)}부터 ~ ${fn:substring(voteMtrVO.voteEndDt, 0, 10)}까지"
							class="form-control" readonly></td>
					</tr>
				</table>
			</div>
			<div class="form-group">
				<textarea id="compose-textarea" class="form-control"
					style="display: none;">                      
						                           </textarea>
				<div class="note-editor note-frame card">
					<div class="note-dropzone">
						<div class="note-dropzone-message"></div>
					</div>

					<div class="note-editing-area">
						<table class="table" style="width: 100%; border: none;">
							<tr>
								<td><textarea class="form-control" rows="6" readonly
										style="resize: none;">${voteMtrVO.mtrCn}</textarea></td>
							</tr>

							<tr>
								<td>
									<!-- 항목추가를 누르면 생기는 자리 id="Iem" -->

									<h2 class="card-title">투표 항목</h2>
									<table id="voteIemTable"  class="table tight-table"
										style="border-collapse: collapse; border: none; width: 100%;">
										<thead>
											<tr>
												<th style="border: none; width:10%;">순번</th>
												<th style="border: none; width:30%; text-align:left;">투표항목</th>
<!-- 												<th style="border: none; text-align: left; width:50%;">내용</th> -->
												<th style="border: none; width:10%;">투표수</th>
											</tr>
										</thead>
										<tbody>
											<c:choose>
												<c:when test="${not empty voteMtrVO.voteIemVOList}">
													<c:forEach var="iem" items="${voteMtrVO.voteIemVOList}">
														<tr>
															<td><c:out value="${iem.voteIemNo}" /></td>
															<td style="text-align: left;"><c:out value="${iem.iemNm}" /></td>
<%-- 															<td><c:out value="${iem.iemCn}" /></td> --%>
															<td><c:out value="${iem.cnt}" /></td>
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
									</table>



								</td>
							</tr>
						</table>


					</div>
				</div>
			</div>
		</div>
		<!-- /.card-body -->
		<div class="card-footer">
			<div class="float-right"></div>
			<button type="reset" class="btn btn-default">
				<i class="fas fa-times"></i><a href="/vote/voteMtr">뒤로가기</a>
			</button>
		</div>
		<!-- /.card-footer -->
	</div>
	<!-- /.card -->
</section>
<!-- /////그래프그리기 우측영역 시작///// -->
<section class="col-md-4 connectedSortable ui-sortable">

	<!-- 카드시작 -->
	<div class="card">
		<div class="card-header">
			<h3 class="card-title">투표결과</h3>
		</div>
	<div class="card-body">
			<div id='myDiv'></div>
	</div>
		<!-- /.card-header -->
	<!-- 카드끝 -->
	</div>
<!-- /////그래프그리기 우측영역 끝///// -->







</section>
</div>

<!-- /// footer 시작  -->
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->

<!-- 그래프 그리는거입니다 시작 -->
<script src='https://cdn.plot.ly/plotly-3.2.0.min.js'></script>
<script>
//스크립트 시작
document.addEventListener("DOMContentLoaded", function () {

  //  투표 항목 테이블에서 데이터 읽어오기
  const rows   = document.querySelectorAll("#voteIemTable tbody tr");
  const labels = []; // 투표 항목명 (iemCn)
  const values = []; // 투표수 (cnt)

  rows.forEach(function (row) {
    const cells = row.querySelectorAll("td");

    // 없는 행 건너뛰기
    if (cells.length < 3) return;

    // 0: 순번, 1: 투표항목, 2: 내용, 3: 투표수
    const label = cells[1].textContent.trim();          // 투표항목
    const valueText = cells[2].textContent.trim();      // 투표수 문자열
    const value = parseInt(valueText.replace(/,/g, ""), 10) || 0;

    labels.push(label);
    values.push(value);
  });

  // 데이터가 없으면 안내 문구만 출력
  if (labels.length === 0) {
    const div = document.getElementById("myDiv");
    if (div) {
      div.innerHTML = "<p style='text-align:center; margin-top:1rem;'>투표 항목 데이터가 없습니다.</p>";
    }
    return;
  }

  // 그래프용 데이터 구성
  const data = [{
    values: values,
    labels: labels,
    type: "pie",
    textinfo: "none",
    hoverinfo: "label+value+percent",
    hole: 0.3,              // 도넛 형태
    // marker: { colors: [...] } // 색상지정가능
  }];
  // 레이아웃 설정
  const layout = {
    title: "투표 결과",
    height: 400,
    width: 500,
    legend: {
      orientation: "h",
      x: 0.5,
      xanchor: "center",
      y: -0.15
    },
    margin: { t: 40, l: 10, r: 10, b: 40 }
  };
  // 그래프 그리기
  Plotly.newPlot("myDiv", data, layout, {
	displayModeBar: false,  // 모드바 전체 제거
	displaylogo: false,      // Plotly 로고 제거
  });
});
</script>
<!-- 그래프 그리는거입니다 끝 -->



<style>
/* 공통 카드별 상단 영역 시작 */
body { /* 그냥 폰트 */
	font-family: 'Noto Sans KR', 'Source Sans Pro', sans-serif;
}
.card {
	border-radius: 1.5rem !important;
	overflow: hidden !important;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15) !important;
	/*transform: scale(0.95);*/
}
.card-header{
	background-color: rgba(193, 179, 180, 0.5);
}

.card-header .card-title {
	font-size: 1rem !important; /* 글자 크기 */
	font-weight: 700 !important;
	/* 글자 두께 살짝 굵게  400이 기본, 700이 bord정도 입니다. */
	padding-top: 4px !important; /* 상단패딩*/
	padding-bottom: 4px !important;
}
/* 공통 카드별 상단 영역 끝 */
.card-body {
	padding: 1rem !important;
}
.card-footer {
	padding: 1rem !important;
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 시작 */
.tight-table, .tight-table th, .tight-table td {
	padding: 3px 5px !important; /* 테이블들 행간격 */
	overflow: hidden !important; /* 삐져나가는거 잡아줘요 */
	text-overflow: ellipsis; /* 길어진 글은 ...처리 */
	white-space: nowrap; /* 줄바꿈 X */
	text-align: center;
}
/* 줄무늬 효과(odd는 홀수, even은 짝수) */
.tight-table tbody tr:nth-child(odd) {
	background-color: #ffffff; /* 흰색 */
}

.tight-table tbody tr:nth-child(even) {
	background-color: #f1f4fa; /* 연한 회색(AdminLTE 느낌) */
}
/* 공통 테이블 간격을 줄 간격 맞추기. table 생성시 꼭 사용하세요 끝 */
/* 호버이벤트 시작 */
/* tight-table호버이벤트시작 */
.table tbody tr {
	transition: background-color 0.25s ease, box-shadow 0.25s ease,
		transform 0.2s ease;
}
.table tbody tr:hover {
	background-color: rgba(100, 140, 164, 0.12) !important; /* 은은한 파스텔 */
	box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15); /* 은은한 그림자 */
	transform: translateY(-1px); /* 살짝 띄우기 */
	cursor: pointer;
}
/* 호버이벤트 끝 */

/* 모달 css영역 시작입니다 */
/* 모달 프레임 자체 */
.cute-modal .modal-content {
	border: 0 !important;
	border-radius: 14px !important;
	box-shadow: 0 6px 24px rgba(0, 0, 0, .12) !important;
	overflow: hidden !important;
}
/* 헤더 영역 */
.cute-modal .modal-header {
	background: rgba(100, 140, 164, .85) !important;
	color: #fff !important;
	padding: .6rem .9rem !important;
}
/* 제목(좌측) */
.cute-modal .modal-title {
	font-size: 1rem !important;
	display: flex !important;
	gap: .5rem !important;
	align-items: center !important;
	margin: 0 !important;
}
.cute-modal .modal-title small {
	font-size: .85rem !important;
}
/* 닫기 버튼 */
.cute-modal .close, .cute-modal .btn-close, .cute-modal .btn-close-white
	{
	color: #fff !important;
	opacity: .9 !important;
	text-shadow: none !important;
}
.cute-modal .close:hover, .cute-modal .btn-close:hover, .cute-modal .btn-close-white:hover
	{
	opacity: 1 !important;
}
/* 본문 기본 패딩 */
.cute-modal .modal-body {
	padding: .9rem !important;
}
/* 필드 라벨 (제목, 기간, 내용 등) */
.cute-modal .field-label {
	color: #6b7b86 !important;
	font-size: .875rem !important;
	margin-bottom: .25rem !important;
}
/* 상단 메타 정보(기간 + 내용) 박스 */
.cute-modal .cute-meta-box {
	display: grid !important;
	grid-template-columns: 92px 1fr !important;
	row-gap: .35rem !important;
	column-gap: .75rem !important;
	padding: .8rem !important;
	border: 1px solid rgba(0, 0, 0, .06) !important;
	border-radius: 10px !important;
	background: rgba(100, 140, 164, .12) !important; 
	margin-bottom: .75rem !important;
}
.cute-modal .cute-meta-label {
	color: #6b7b86 !important;
	font-size: .875rem !important;
	align-self: center !important;
}
.cute-modal .cute-meta-label.top {
	align-self: flex-start !important;
}
.cute-modal .cute-meta-value {
	font-weight: 600 !important;
	font-size: .95rem !important;
}
/* 내용 textarea */
.cute-modal textarea.form-control {
	resize: none !important;
}
/* 섹션 제목 (ex. 투표 항목, 첨부파일 등) */
.cute-modal .cute-section-title {
	margin: 0 0 .5rem 0 !important;
}
/* 테이블 – Dewi/BS5/BS4 모두 공통 느낌 */
.cute-modal .cute-table {
	margin-top: .25rem !important;
}
.cute-modal .cute-table thead th {
	background: #f6f8fa !important;
	border-bottom: 1px solid rgba(0, 0, 0, .06) !important;
}
/* 버튼 줄 */
.cute-modal .cute-btn-row {
	margin-top: .5rem !important;
}
/* 버튼 */
.cute-modal .btn-round-sm {
	padding: .35rem .7rem !important;
	border-radius: 10px !important;
}
/* 모달 css영역 끝 입니다 */
</style>
