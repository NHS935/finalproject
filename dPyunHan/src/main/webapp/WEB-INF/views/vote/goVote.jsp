<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>

<!-- /// 타이틀 시작 /// -->
<!-- /// 타이틀 끝 /// -->
<!--           <h1>투표 상세</h1> -->
<!-- /// body 시작 /// -->
	<div class="col-md-9">
		<div class="card card-primary card-outline">
			<div class="card-header">
				<h3 class="card-title">No.${voteMtrVO.voteMtrSn}</h3>
				<hr />
				<h3 class="card-title">작성자ID:${voteMtrVO.empId}</h3>
			</div>
			<!-- /.card-header -->


			<div class="card-body">
				<div class="form-group">
					<input type="text" value="${voteMtrVO.mtrSj}" class="form-control"
						readonly>
				</div>
				<div class="form-group">
					<table
						style="border-collapse: collapse; border: none; width: 100%;">
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
						style="height: 300px; display: none;">                      
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
										<form id="frm" method="post" action="/vote/haveAVote">
											<input type="hidden" name="voteMtrSn" value="${voteMtrVO.voteMtrSn}">
											<table
												style="border-collapse: collapse; border: none; width: 100%;">
												<thead>
													<tr>
														<th style="border: none; text-align: left; width: 10%;">No</th>
														<th style="border: none; text-align: left; width: 30%;">투표항목</th>
														<th style="border: none; text-align: left; width: 40%;">내용</th>
														<th style="border: none; text-align: left; width: 10%;">투표</th>
														<th style="border: none; text-align: left; width: 10%;">투표수</th>
													</tr>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${not empty voteMtrVO.voteIemVOList}">
															<c:forEach var="iem" items="${voteMtrVO.voteIemVOList}">
																<tr>
																	<td><c:out value="${iem.voteIemNo}" /></td>
																	<td><c:out value="${iem.iemNm}" /></td>
																	<td><c:out value="${iem.iemCn}" /></td>
																	<td><input type="radio" name="voteIemNo"
																		id="iem_${iem.voteIemNo}" value="${iem.voteIemNo}"
																		required></td>
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
											<button type="submit" class="btn btn-info btn-sm">
												<i class="far fa-envelope">투표하기</i>
											</button>
										</form>

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
				  <i class="fas fa-times"></i><a href="/vote/voteMtr">더많은 투표보기</a>
				</button>
			</div>
			<!-- /.card-footer -->
		</div>
		<!-- /.card -->
	</div>

	
<!-- /// footer 시작 /// -->
</div>
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->