<%@ page language="java" contentType="text/html; charset=UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
				<!DOCTYPE html>
				<html>

				<head>
					<title></title>
					<!-- ========== 필수 CSS (순서 중요) ========== -->

					<!-- 1. Google Fonts -->
					<link rel="stylesheet"
						href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap">

					<!-- 2. Font Awesome (아이콘) -->
					<link rel="stylesheet" href="/adminlte/plugins/fontawesome-free/css/all.min.css">

					<!-- 3. iCheck Bootstrap (라디오 버튼) -->
					<link rel="stylesheet" href="/adminlte/plugins/icheck-bootstrap/icheck-bootstrap.min.css">

					<!-- 4. Daterangepicker CSS -->
					<link rel="stylesheet" href="/adminlte/plugins/daterangepicker/daterangepicker.css">

					<!-- 5. AdminLTE CSS (마지막) -->
					<link rel="stylesheet" href="/adminlte/dist/css/adminlte.min.css">

					<style>
						/* HTML, Body 설정 */
						html,
						body {
							height: 100%;
							margin: 0;
							padding: 0;
						}

						/* Wrapper는 내용에 맞게, 최소 100vh */
						.wrapper {
							min-height: calc(100vh - 50px);
							display: flex;
							flex-direction: column;
						}

						/* Content 영역 */
						.content-area {
							flex: 1;
							padding: 20px;
						}

						/* Footer 항상 맨 아래 */
						.footer {
							height: 50px;
							background: #f8f9fa;
							border-top: 1px solid #dee2e6;
							display: flex;
							align-items: center;
							justify-content: space-between;
							padding: 0 15px;
							flex-shrink: 0;
							box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.05);
						}

						/* Footer 텍스트 스타일 */
						.footer strong,
						.footer div {
							white-space: nowrap;
							font-size: 0.875rem;
							margin: 0;
						}

						.footer .float-right {
							margin-left: auto;
						}

						/* 필터 레이블 스타일 */
						.filter-label {
							min-width: 90px;
							display: inline-block;
							font-weight: 500;
							color: #495057;
							margin-right: 10px;
							flex-shrink: 0;
						}

						hr.my-2 {
							margin: 0.5rem 0;
							border-top: 1px solid rgba(0, 0, 0, 0.1);
						}

						/* ==================== 헤더 전문 디자인 (심플 버전) ==================== */

						.content-header.bg-primary {
							background-color: #2c3e50 !important;
							padding: 20px 0;
							box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
							margin-bottom: 20px;
							border-bottom: 3px solid #3498db;
						}

						.content-header .container-fluid {
							padding: 0 20px;
						}

						/* 로고 + 타이틀 영역 */
						.content-header h1 {
							color: white;
							font-size: 1.5rem;
							font-weight: 600;
							margin: 0;
							display: flex;
							align-items: center;
							gap: 15px;
						}

						.content-header h1::before {
							content: '';
							display: inline-block;
							width: 45px;
							height: 45px;
							background: url('/images/logo2.png') center/contain no-repeat;
							background-color: white;
							border-radius: 8px;
							padding: 5px;
						}

						/* Breadcrumb 개선 */
						.breadcrumb {
							background-color: transparent;
							padding: 0;
							margin: 0;
						}

						.breadcrumb-item {
							font-size: 0.875rem;
						}

						.breadcrumb-item a {
							color: rgba(255, 255, 255, 0.85) !important;
							text-decoration: none;
							transition: all 0.2s ease;
							padding: 4px 8px;
							border-radius: 4px;
							font-weight: 500;
						}

						.breadcrumb-item a:hover {
							color: white !important;
							background: rgba(255, 255, 255, 0.1);
						}

						.breadcrumb-item+.breadcrumb-item::before {
							color: rgba(255, 255, 255, 0.5) !important;
							content: "›";
							font-size: 1.1rem;
							padding: 0 6px;
						}

						.breadcrumb-item.active {
							color: white;
							font-weight: 500;
						}

						/* 반응형 */
						@media (max-width: 768px) {
							.content-header h1 {
								font-size: 1.25rem;
							}

							.content-header h1::before {
								width: 35px;
								height: 35px;
							}
						}
					</style>

					<!-- 1. jQuery (가장 먼저) -->
					<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

					<!-- 2. Bootstrap Bundle (Popper 포함) -->
					<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

					<!-- 3. Moment.js (daterangepicker 의존성) -->
					<script src="/adminlte/plugins/moment/moment.min.js"></script>

					<!-- 4. Daterangepicker -->
					<script src="/adminlte/plugins/daterangepicker/daterangepicker.js"></script>

					<!-- 5. AdminLTE App -->
					<script src="/adminlte/dist/js/adminlte.min.js"></script>

					<!-- 6. 외부 라이브러리 -->
					<script src="https://cdn.jsdelivr.net/npm/lottie-web@latest/build/player/lottie.min.js"></script>
					<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>


				</head>


				<body class="layout-boxed">
					<div class="wrapper">

						<section class="content-header bg-primary">
							<div class="container-fluid">
								<div class="row mb-2">
									<div class="col-sm-6">
										<h1 class="ml-3"><b>D-PyunHan 전자 입찰</b></h1>
									</div>
									<div class="col-sm-6">
										<ol class="breadcrumb float-sm-right">
											<li class="breadcrumb-item"><a style="color: white;" href="/login">Home</a>
											</li>
											<li class="breadcrumb-item"><a style="color: white;" href="#">Contact</a>
											</li>
										</ol>
									</div>
								</div>
							</div><!-- /.container-fluid -->
						</section>

						<!-- /// body /// -->
						<div style="display: flex; justify-content: center; align-items: center; min-height: 70vh;">
							<div class="card card-primary card-outline" style="min-width: 400px;">
								<div class="card-body box-profile">
									<div class="text-center mb-3">
										<img class="profile-user-img img-fluid img-circle" src="/images/check.png">
									</div>

									<h3 class="profile-username text-center mb-3">가입 신청이 완료되었습니다.</h3>
									<p class="mb-3 text-center">
										${ccpyManageVO.ccpyCmpnyNm}의 가입정보를 검토 후,<br> <strong>승인완료 메일</strong>을 보내드리겠습니다.
									</p>

									<ul class="list-group list-group-unbordered mt-4 mb-3">
										<li class="list-group-item mb-2">
											<b>회사명</b> <a class="float-right">${ccpyManageVO.maskCcpyCmpnyNm}</a>
										</li>
										<li class="list-group-item mb-2">
											<b>대표자</b> <a class="float-right">${ccpyManageVO.maskCcpyRprsntvNm}</a>
										</li>
										<li class="list-group-item mb-2">
											<b>이메일주소</b> <a class="float-right">${ccpyManageVO.maskCcpyEmail}</a>
										</li>
									</ul>

									<a href="/login" class="btn btn-primary btn-block"><b>메인으로 이동</b></a>
								</div>
								<!-- /.card-body -->
							</div>
						</div>
						<!-- /// body /// -->
					</div>

					<footer class="footer">
						<div class="float-right d-none d-sm-block">
							<b>Version</b> 3.2.0
						</div>
						<strong>Copyright © 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.
						</strong> All rights reserved.
					</footer>
				</body>

				</html>