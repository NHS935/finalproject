<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<section class="content-header bg-primary mb-2">
		<div class="container-fluid">
			<div class="row mb-2">
				<div class="col-sm-6">
					<h1 class="ml-3">
						<b>D-PyunHan 전자 입찰</b>
					</h1>
				</div>
				<div class="col-sm-6">
					<ol class="breadcrumb float-sm-right">
						<li class="breadcrumb-item"><a style="color: white;"
							href="/login">Home</a></li>
						<li class="breadcrumb-item"><a style="color: white;"
							href="/bidPblanc/getBidPblancList">공고목록</a></li>
						<sec:authorize access="hasRole('CCPY')">
							<li class="breadcrumb-item"><a style="color: white;"
							href="/bdder/getMyBdderList">입찰내역</a></li>
						</sec:authorize>
						<li class="breadcrumb-item"><a style="color: white;" href="#">Contact</a></li>
					</ol>
				</div>
			</div>
		</div>
		<!-- /.container-fluid -->
	</section>
</body>
</html>