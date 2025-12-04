<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <!DOCTYPE html>
      <html>

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>전자입찰 로그인</title>

        <script type="text/javascript" src="/js/jquery-3.6.0.js"></script>
        <!-- Custom fonts for this template-->
        <link href="/sbadmin2/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link
          href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="/sbadmin2/css/sb-admin-2.min.css" rel="stylesheet">
        <!-- ///// content 시작 ///// -->

        <style>
          /* 전체 화면 중앙 정렬 */
          html,
          body {
            height: 100%;
            margin: 0;
            padding: 0;
          }

          body.bg-gradient {
            display: flex;
            align-items: center;
            /* 세로 중앙 */
            justify-content: center;
            /* 가로 중앙 */
            min-height: 100vh;
          }

          /* Container가 중앙에 위치 */
          .container {
            margin: 0;
          }
        </style>
      </head>

      <body class="bg-gradient">

        <div class="container">

          <!-- Outer Row -->
          <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12 col-md-9">
              <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                  <!-- Nested Row within Card Body -->
                  <div class="row">
                    <div class="col-lg-6 d-none d-lg-block">
                      <img src="/images/ccpyLogin.jpg" alt="로그인 이미지"
                        style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="col-lg-6 d-flex flex-column align-items-center justify-content-center">
                      <div class="p-5">
                        <div class="text-center">
                          <h1 class="h4 text-gray-900 mb-3" style="font-weight: bold;">전자입찰 로그인</h1>
                          <p class="mb-3 small">
                            전자 입찰 서비스 이용을 위해서는 로그인<br>
                            또는 업체 등록 및 승인이 필요함을 안내드립니다.<br>
                            이용에 불편함이 없으시도록 협조 부탁드립니다
                          </p>
                        </div>
                        <form class=user action="/login" method="POST">
                          <div class="form-group">
                            <input type="email" class="form-control form-control-user" id="username"
                              aria-describedby="emailHelp" name="username" placeholder="이메일 주소를 입력해주세요.">
                          </div>
                          <div class="form-group">
                            <input type="password" name="password" class="form-control form-control-user" id="password"
                              placeholder="비밀번호를 입력해주세요.">
                          </div>

                          <button type="submit" href="index.html" class="btn btn-primary btn-user btn-block">
                            로그인
                          </button>
                        </form>
                        <hr>
                        <div class="text-center">
                          <a class="btn btn-link text-sm" href="#">비밀번호 찾기</a>
                        </div>
                        <div class="text-center">
                          <a class="btn btn-link text-sm" href="/ccpyManage/postCcpyManage">가입하기</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

            </div>

          </div>

        </div>

        <!-- Bootstrap core JavaScript-->
        <script src="vendor/jquery/jquery.min.js"></script>
        <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

        <!-- Core plugin JavaScript-->
        <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

        <!-- Custom scripts for all pages-->
        <script src="js/sb-admin-2.min.js"></script>

      </body>

      <!-- ///// content 끝 ///// -->