<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@include file="header.jsp"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script
src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js">
</script>

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

<section id="cart-view">
<div class="container">
<div class="row">
<div class="col-md-12">
<div class="cart-view-area">
<div class="cart-view-table">

<div class="table-responsive">
<!-- 	<div id="list"> -->
<!-- 		<fieldset> -->
<%-- 			<legend>${sessionScope.uname }님의 장바구니</legend> --%>
			<table class="table" id="basket_list">
			<h1 style="text-align: right;">${sessionScope.uname }님의 장바구니</h1>
				<thead>
				<tr>
				<th style="text-align: center;"><input type="button" value="전체선택" onclick="checkboxSelectQue(1,'chk[]')"/>
				</th>
				</thead>
				<tbody>
				<form role="form" method="post">
					<c:forEach var="dto" items="${dtolist }">
						<tr>
							<td style="text-align: center"><input type="checkbox" name="chk[]"></td>
<%-- 							<td><img src="/resources/imgfile/${dto.showimg }"></a></td> <!-- 상품 이미지 자리 --> --%>
							<td><a href="storeDetail?stnum=${dto.stnum}#menudiv">${dto.foodname}</td>
							<td> 상품 가격 :${dto.foodpay }</td>
							<td>수량 : 
							<input type="hidden" name="foodpay"  value="${dto.foodpay }">
							<input class="nn aa-cart-quantity" type="number" value="${dto.foodtotal }" min="1" max="5" style="width: 35px;">
							<input type="hidden" name="foodnum"  value="${dto.foodnum }">
							</td>
							<td>주문 가격 : <span>${dto.basketpay }</span></td>
<!-- 							<td><button class="aa-cart-view-btn" type="submit">주문하기</button></td> -->
							<td><a href="deleteselected?basketnum=${dto.basketnum }">삭제</a></td>
<!-- 							<td class="delete"> -->
<%-- 							<button type="button" class="delBtn" data-basketnum="${dto.basketnum }">삭제</button> --%>
						</tr>
					</c:forEach>
					</form>
				</tbody>
				<tfoot>
				<tr>
<%-- 				<td>총 결제 금액 : <span>${tp.totalprice }</span>	원</td> --%>
				</tr>
				<tr>
				<th style="text-align: center;"><input type="button" value="선택취소" onclick="checkboxSelectQue(2,'chk[]')"/></th>
				</tr>
				</tfoot>
			</table>
			</div>
			<div class="cart-view-total" style="text-align: center;">
			<h4>총 결제 금액 : <fmt:formatNumber value="${tp.totalprice }" pattern="###,###,###"/>	원</h4>
			
			<a href="#" class="aa-cart-view-btn">결제하기</a><a>	/	</a><a href="storelistController?page=1">상품 더 담으러 가기</a>
			</div>
			</div>
			</div>
			</div>
			</div>
			</div>
			</section>
<!-- 		</fieldset> -->
	
	<br> <br> <br>
	
	<script>
	$(function(){
		 $(".nn").click(function(){
			 var $qty = $(this).val();
			 var $foodnum = $(this).next().val();
			 var $foodpay =  $(this).prev().val();
			 //var $totalprice = $(this).parent().parent().parent().parent().parent().next().children().children().val();
			 var param = "qty="+$qty+"&foodnum="+$foodnum+"&foodpay="+$foodpay//+"&totalprice="+$totalprice
			 var target =  $(this).parent().next().css("background","");
			 
			 //$(this).parent().next().children().children().css("color:red");
			 
			//alert(param)
	     	 $.ajax({
				 url:"cart/cartJson?"+param,
				 success:function(data){
					 var res = data.split(":");
					 console.log(res[1]);
					 var htmls = "주문 가격 : <span>"+res[1]+"</span>";
					 target.html(htmls);
				 }
			 }); 
		      });
	})
	
	
	function checkboxSelectQue(n,obj){
		var i;
		var chk = document.getElementsByName(obj);
		var select = chk.length;
		for (i = 0; i<select; i++){
			if(n == 1) chk[i].checked = true; // 전체선택
			if(n == 2) chk[i].checked = false; // 전체해제
			if(n == 3) chk[i].checked = !chk[i].checked; // 선택반전?
		}
	}
	
	function checkboxSelectCount(obj){
		var i, sum=0, tag=[], str="";
		var chk = document.getElementsByName(obj);
		var select = chk.length;
		for (i=0; i<select; i++){
			if (chk[i].checked == true){
				tag[sum] = chk[i].value;
				sum++;
			}
		}
		str +="선택 갯수 : "+sum;
		if (tag.length > 0) str +="\n값 : "+tag.join(",");
		alert(str);
	}
	</script>

 <script> 
 // window.onload 적용시 나왔다가 자동으로 사라져서 .ready로 적용해봤음
 //window.onload=function(){  
/*  $(document).ready(function() {
	 console.log("Test------------------")
      alert("로딩 완료");
      $("#nav").children().css('background-color', 'black');
      
      $(".nn").click(function(){
    	console.log($(this).val()+"=====================================")
      });
      }
   }); */
</script>

</div>
<%@include file="footer.jsp"%>