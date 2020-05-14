<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header.jsp"%>
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
<form method="post" action="update" autocomplete="off"	enctype="multipart/form-data">
<fieldset style="width: 500px; height: 500; margin: auto; color: black;">
	<table>
		<tr>
			<th style="width: 100px">음식 이름</th>
			<th style="width: 100px">음식가격</th>
			<th style="width: 100px">이미지</th>
		</tr>
		<input type="hidden" name="foodnum" value="${menu.foodnum}">
		<tr>			
			<td><input type="text" name="foodname" value="${menu.foodname }"></td>
			<td><input type="text" name="foodpay" value="${menu.foodpay }"></td>
			<td><input type="file" name="upimg" id="upimg" value="${menu.foodimg }"></td>
				
			<td><input type="submit" value="등록"></td>
		</tr>
	</table>
</fieldset>
</form>
<%@include file="footer.jsp"%>