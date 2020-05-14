<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header2.jsp"%>

<br>
<br>
<br>
<br>
<br>
<br>
<div class="content">

	<style>
#list {
	color: black;
	border: solid 1px;
	text-align: center;
	width: 1000px;
	margin: auto;
}

#store_list th {
	text-align: center;
}
</style>

	<div id="list">

		<fieldset>
			<legend>${sessionScope.uname }님의 장바구니</legend>
			${searchValue }

			<table class="table table-hover" id="basket_complete">
				<thead>

				</thead>
				<tbody>
					<a href="storelistController?page=1">계속 쇼핑하기</a>
					<a>	/	</a>
					<a href="listBasket2">장바구니로 이동</a>
					
				</tbody>

			</table>
		</fieldset>

	</div>
	<br> <br> <br>

	<script>
		// window.onload 적용시 나왔다가 자동으로 사라져서 .ready로 적용해봤음
		//window.onload=function(){  
		$(document).ready(function() {
			alert("로딩 완료");
			$("#nav").children().css('background-color', 'black');
		});
	</script>

</div>
<%@include file="footer.jsp"%>