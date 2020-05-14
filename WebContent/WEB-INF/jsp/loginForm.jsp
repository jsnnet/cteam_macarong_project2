<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header.jsp"%>
<%-- loginform.jsp --%>
<script>
</script>
<br>
<br>
<br>
<br>
<br>
<br>
<div class="content">

	<fieldset style="width: 300px; margin: auto; color: black;">
		<legend>로그인 폼</legend>
		<form method="post" action="loginProcess" autocomplete="off">
			<p>
				<label>아이디</label> <input type="text" name="id" id="id">
			</p>
			<p>
				<label>비밀번호</label> <input type="password" name="pwd" id="pwd">
			</p>
			<p style="text-align: right;">
				<input type="submit" onclick="location.href='loginProcess?id=test'">
				<input type="button" value="왜안되냐 시1발 " onclick="alert('로딩 완료222');">
 			</p>
		</form>
	</fieldset>

</div>
</div>

<%@include file="footer.jsp" %>
