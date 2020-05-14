<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%-- loginform.jsp --%>
<%@include file="header.jsp"%>
<script>
	window.onload = function() {
		$("#nav").children().css('background-color', 'black');
		if ($("#footer_c").css("display") == "block") {
			$("#footer_c").css("display", "none");
			$('#footer').css("display", "block");
		} else {
			$("#footer").css("display", "none");
			$('#footer_c').css("display", "block");
		}
	}
</script>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인</title>

<!-- Bootstrap -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- font awesome -->
<link href="css/font-awesome.min.css" rel="stylesheet">
<!-- Custom Style -->
<link href="css/style.css" rel="stylesheet">

</head>
<body>
	<fieldset style="width: 300px; margin: auto; color: black;">
		<div class="container">
			<div class="row">
				<div class="page-header"></div>
				<div class="col-md-3">
					<div class="login-box well">
						<form method="post" action="loginProcess_user" autocomplete="off">
							<legend>로그인</legend>
							<p>
								<label> 아이디</label> <input type="text" name="id" id="id"
									placeholder=" Username" />
							</p>
							<p>
								<label for="password">비밀번호</label> <input type="password"
									name="pwd" id="pwd" placeholder="Password" />
							</p>
							<div class="form-group">
								<input type="submit"
									class="btn btn-default btn-login-submit btn-block m-t-md"
									value="Login" />
							</div>
							<span class='text-center'><a href="" class="text-sm">비밀번호
									찾기</a></span>
							<hr />
							<div class="form-group">
								<a href="member" class="btn btn-default btn-block m-t-md">
									회원가입</a>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</fieldset>


	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>
</div>
<%@include file="footer.jsp"%>
