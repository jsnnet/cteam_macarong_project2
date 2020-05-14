<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header.jsp"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
	window.onload = function() {
		$("#nav").children().css('background-color', 'black');
		if ($("#footer").css("display") == "block") {
			$("#footer").css("display", "block");
			$('#footer_c').css("display", "none");
		}
	}
</script>
<br>
<br>
<br>
<br>
<br>
<br>

<fieldset style="width: 500px; margin: auto; color: black;">
	<table>
		<tr >
			<th style="width: 100px;">가게 이름</th>
			<th style="width: 100px;">아이디</th>
			<th style="width: 100px">음식 번호</th>
			<th style="width: 100px">음식 이름</th>
			<th style="width: 100px">음식가격</th>
			<th style="width: 100px">이미지</th>
		</tr>

		<c:forEach var="e" items="${list}">
			<tr>
				<td>${e.stname}</td>
				<td>${e.stid}</td>
				<c:forEach var="e" items="${e.menu}">
					<td>${e.foodnum }</td>
					<td>${e.foodname }</td>
					<td>${e.foodpay }</td>

					<td><img
						src="${pageContext.request.contextPath}/resources/imgfile/${e.foodimg }"
						width="100px" height="100px"></td>
					<td>
						<input type="button" value="수정" onclick="location='alter?foodnum=${e.foodnum}'">
					</td>
					<td><input type="button" value="삭제"
						onclick="location='delete?foodnum=${e.foodnum}&'"></td>
				</c:forEach>
			</tr>
		</c:forEach>
		<tr>
			<td><input type="button" value="등록"
				onclick="location='upform?stnum=${stnum}'"></td>
		</tr>
	</table>
</fieldset>
<%@include file="footer.jsp"%>