<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>마ㅏ아아카라옹</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">

<!-- Favicons -->
<link href="resources/img/favicon.png" rel="icon">
<link href="resources/img/apple-touch-icon.png" rel="apple-touch-icon">

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,300,700&subset=latin,cyrillic-ext"
	rel="stylesheet">

<!-- Bootstrap CSS File -->
<link href="resources/lib/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Libraries CSS Files -->
<link href="resources/lib/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<link href="resources/lib/ionicons/css/ionicons.min.css"
	rel="stylesheet">
<link href="resources/lib/photostack/photostack.css" rel="stylesheet">
<link href="resources/lib/fullpage-menu/fullpage-menu.css"
	rel="stylesheet">
<link href="resources/lib/cubeportfolio/cubeportfolio.css"
	rel="stylesheet">
<link href="resources/lib/superslides/superslides.css" rel="stylesheet">

<!-- Main Stylesheet File -->
<link href="resources/css/style.css?v=<%=System.currentTimeMillis()%>"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- =======================================================
    Template Name: Polaroyd
    Template URL: https://templatemag.com/polaroyd-bootstrap-agency-template/
    Author: TemplateMag.com
    License: https://templatemag.com/license/
  ======================================================= -->
</head>
<script>
	function home() {
		var res = confirm("메인 화면으로 가쉴?");
		if (res == false)
			return;
		location.href = "main";
	}
	function memberJoin() {
		location.href = "member";
	}
</script>

<body>

	<!-- Custom navbar -->
	<div class="custom-navbar">
		<a class="fm-button" href="#">Menu</a>
	</div>
	<div class="sidemenu">
		<ul class="fm-first-level">
			<li><a href="#menu1">회원 페이지</a></li>
			<li><a href="#menu2">관리자 페이지 </a></li>
			<li><a href="#" onClick="memberJoin()">회원 가입</a></li>
			<li><a href="#" onClick="home()">Home</a></li>
		</ul>
		<nav id="menu1" class="active">
			<a href="logout"><span class="subtitle">로그아웃 기능 </span>${sessionScope.uname }님
						로그아웃</a>
			<a href="index2.html"> <span class="subtitle"> </span> 마이 페이지
					</a>
			<a href="storelistController?page=1"> <span class="subtitle"></span> 마카로옹 가게 검색
					</a>
			<a href="listBasket2?memnum=${sessionScope.unum }"> <span class="subtitle"></span>장바구니
					</a>
			<a href="services.html"> <span class="subtitle"></span> 예약
					</a>
			<a href="contact.html"> <span class="subtitle"></span> 커뮤니티
					</a>
		</nav>
		<nav id="menu2">
			<c:choose>
				<c:when test="${sessionScope.adminid == null }">
					<a href="loginForm_admin"><span class="subtitle">관리자 로그인 기능이여
					</span> 관리자 로그인</a>
				</c:when>
				<c:otherwise>
					<a href="logout_admin"><span class="subtitle"> 관리자 로그아웃 기능인디 </span>${sessionScope.adminid }님
						로그아웃</a>
						a href="index2.html"> <span class="subtitle"> </span> 마이 페이지

					<a href="works.html"> <span class="subtitle"></span>주문 확인
					</a>
					<a href="services.html"> <span class="subtitle"></span> 매출 확인
					</a>
					<a href="upform"> <span class="subtitle"></span> 메뉴 등록
					</a>
					<!-- <li><a href="upform" class="page-scroll smoothie">메뉴 등록</a></li> -->
					<a href="mypage"> <span class="subtitle"></span> 리스트
					</a>
				</c:otherwise>
			</c:choose>
			<
		</nav>
		<nav id="menu3">
			<a href="blog.html"> <span class="subtitle">Main blog
					layout list.</span> Blog List
			</a> <a href="blog-post.html"> <span class="subtitle">First
					variation of blog posts.</span> Blog Post
			</a> <a href="blog-posts-2.html"> <span class="subtitle">Second
					variation of blog posts.</span> Blog Posts 2
			</a>
		</nav>
		<!-- 		<nav id="menu4">
		</nav> -->
	</div>
	<!-- /END CUSTOM NAVBAR -->