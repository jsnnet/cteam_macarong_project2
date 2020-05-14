<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header.jsp"%>
<%-- loginform.jsp --%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script>
	// 숫자가 아닌 정규식
	var replaceNotInt = /[^0-9]/gi;

	$(document).ready(function() {

		$("#foodpay").on("focusout", function() {
			var x = $(this).val();
			if (x.length > 0) {
				if (x.match(replaceNotInt)) {
					x = x.replace(replaceNotInt, "");
				}
				$(this).val(x);
			}
		}).on("keyup", function() {
			$(this).val($(this).val().replace(replaceNotInt, ""));
		});

	});
</script>

<br>
<br>
<br>
<br>
<br>
<br>
<div class="content">

	<fieldset style="width: 300px; margin: auto; color: black;">
		<button class="btn btn-default" data-target="#layerpop" data-toggle="modal">모달출력버튼</button><br/>
	</fieldset>

	
<div class="modal fade" id="layerpop" >
  <div class="modal-dialog">
    <div class="modal-content">
      <!-- header -->
      <div class="modal-header">
        <!-- 닫기(x) 버튼 -->
        <button type="button" class="close" data-dismiss="modal">×</button>
        <!-- header title -->
        <h4 class="modal-title">Header</h4>
      </div>
      <!-- body -->
      <div class="modal-body">
      		<label>점주 아이디 : ${sessionScope.adminid }</label><br>
      		<label>가게번호 : ${sessionScope.stnum}</label>
            <legend>메뉴 등록 폼</legend>
		<form method="post" action="upsave" autocomplete="off"
			enctype="multipart/form-data">
			<input type="hidden" name="stnum" id="stnum" value="${sessionScope.stnum}">
			<p>
				<label>음식이름</label> <input type="text" name="foodname" id="foodname">
			</p>
			<p>
				<label>음식 가격</label> <input type="text" name="foodpay" id="foodpay">
			</p>
			<p>
				<label>음식 사진</label> <input type="file" name="upimg" id="upimg">
			</p>
			<p style="text-align: right;">
				<input type="submit" value="등록">
				 <input type="button" value="리스트" onclick="location='mypage'">
			</p>
		</form>
      </div>
      <!-- Footer -->
      <div class="modal-footer">
        Footer
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
</div>
</div>

<%@include file="footer.jsp"%>
