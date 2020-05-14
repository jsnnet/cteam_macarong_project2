<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp"%>
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<section class="page-header">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="content">
                    <h1 class="page-name">Cart</h1>
                    <ol class="breadcrumb">
                        <li><a href="#">Home</a></li>
                        <li class="active">cart</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</section>



<div class="page-wrapper">
    <div class="cart shopping">
        <div class="container">
            <div class="row">
                <div class="col-md-8 col-md-offset-2">
                    <div class="block">
                        <div class="product-list">
                            <form method="post">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>사진</th>
                                            <th>이름</th>
                                            <th>색상</th>
                                            <th>갯수</th>
                                            <th>가격</th>
                                            <th>총 가격</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <div class="allCheck">
                                            <input type="checkbox" name="allCheck" id="allCheck" onchange="checkSum()"><label
                                                for="allCheck">모두 선택</label>
                                        </div>
                                        <c:set var="sum" value="0" />
                                        <c:if test="${vo.cart == null }">
                                            <tr class="" style="text-align: center;">
                                                <td class="">
                                                    <h3>장바구니가 비었습니다.</h3>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${vo.cart != null }">
                                        <c:forEach var="e" items="${vo.cart }">
                                            <tr class="">
                                                <td class="">
                                                    <div class="chBox">
                                                        <input type="checkbox"  name="chBox" class="chBox"  onchange="checkSum()"
                                                            data-cnum="${e.cnum }" data-cheSum="${e.gagu.gprice*e.chit }" >
                                                    </div>
                                                    <div class="product-info">
                                                        <a href=""><img
                                                            src="${pageContext.request.contextPath }/resources/imgfile/${e.gagu.gpicture }"
                                                            style="width: 100px; border: 0px"></a>
                                                    </div>
                                                </td>
                                                <td>${e.gagu.gname }</td>
                                                <td>${e.gagu.gcolor }</td>
                                                <td><input type="number" id="chit_${e.cnum }"
                                                    name="chit_${e.cnum }" value="${e.chit }"></td>




<!-- 수정 -->
<script>
        function modify_sel_${e.cnum}(cnum) {        
        if(confirm("수정 하시겠습니까?") == true){
            alert(cnum)
            var chit = $('#chit_${e.cnum}').val();
            var chobox = {"cnum" : cnum, "chit" : chit};
            alert(chit)
            
            $.ajax({
                url : "modefy",
                type : "post",
                data : chobox})
                   }
                    location.reload();
            }
</script>
                                                <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${e.gagu.gprice }" /></td>
                                                <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${e.gagu.gprice*e.chit }" /></td>
                                                <td><button type="button" class="btn btn-default"
                                                        onclick="modify_sel_${e.cnum}(${e.cnum})">
                                                        <i class="tf-pencil2" aria-hidden="true"></i>
                                                    </button></td>
                                                <td><button type="button" class="btn btn-default"
                                                        onclick="deleteC(${e.cnum })">
                                                        <i class="tf-ion-close" aria-hidden="true"></i>
                                                    </button></td>
                                            </tr>
                                            <c:set var="sum" value="${sum + (e.gagu.gprice * e.chit)}" />
                                        </c:forEach>
                                      </c:if>
                                    </tbody>
                                </table>
                                <div style=" text-align: right;">
                                            <a style="background-color: white; color: black; font-size: 20px;">총 합계 : <fmt:formatNumber type="number" maxFractionDigits="3" value="${sum}"/>원</a>
                                </div>
                                <div class="checkSum" style=" text-align: right: ;"></div>
                                <div class="delBtnC">
                                    <button type="button" id="purchaseBtn" name="purchaseBtn"
                                        class="btn btn-main pull-right">구매</button>
                                        &nbsp;&nbsp;&nbsp;
                                    <button type="button" id="delBtn" name="delBtn"
                                        class="btn btn-main pull-right">선택 삭제</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 구매로 넘어가기 -->
<script>
    $('#purchaseBtn').click(function () {
        var checkArr = new Array();
          if(confirm("정말 구매 하시겠습니까?") == true) {
              var $form = $('<form></form>');
              $form.attr('action','gorder');
              $form.attr('method','post');
              $form.appendTo('body');
              
              
              $("input[class='chBox']:checked").each(function() {
                    checkArr.push($(this).attr("data-cnum"));
            });
              var chbox = $("<input type='hidden' value='"+checkArr+"' name='chbox[]'>");     
              $form.append(chbox);
             
             if(checkArr.length){ 
              $form.submit();
             }else{
                alert("체크해 주세요"); 
             }
          }  
    })
</script>
<!-- 전체 체크박스 선택 -->
<script>
    $('#allCheck').click(function() {
        var chk = $(this).prop("checked");
        if(chk){
            $('.chBox').prop('checked',true);
        }else{
            $('.chBox').prop('checked',false);
        }
    });
    
    $('.chBox').click(function(){
        $('#allCheck').prop('checked',false);
    });
</script>

<!-- 선택 삭제 -->
<script>

    
    $('#delBtn').click(function() {        
        if(confirm("정말 삭제 하시겠습니까?") == true){
            var checkArr = new Array();
            
            $("input[class='chBox']:checked").each(function() {
                checkArr.push($(this).attr("data-cnum"));
        });
            
            $.ajax({
                url : "deleteCart",
                type : "post",
                data : {chbox : checkArr}
            })
            location.reload();
        }
    })
    
    


</script>
<!-- 체크한 상품 총합계 -->
<script>

    function checkSum(){
        console.log("TEST----------------------------------------")
        var checkSum = new Array();
        var ckecke = "";
        if($("input[class='chBox']").is(":checked") == true){
        $("input[class='chBox']:checked").each(function() {
            ckecke = $(this).attr("data-cheSum");

                checkSum.push(ckecke)
            

        });
        }else{
            checkSum.push(0)
        }
            
        
        $.ajax({
            url : "checkSum",
            type : "get",
            data : {checkS : checkSum},
            //dataType: "json",
            success: function(data) {
                console.log("=========================> : "+data)
                 if(data != null){
                let tag ="";
                tag += "<a style='background-color: white; color: black; font-size: 20px;' >";
                tag += "선택 합계 : "+data+"원</a>";
                $('.checkSum').html(tag);
                
                }else if (data == null){
                let tag ="";
                tag += "<a style='background-color: white; color: black; font-size: 20px;' >";
                tag += "선택 합계 : 0 원</a>";
                $('.checkSum').html(tag);
                }
            },
            error: function (error) {
                
                console.log(error)
            }
        })
        
    
        
    }
</script>

<!-- 삭제 -->
<script>
        
                        
    function deleteC(cnum) {        
            if(confirm("정말 삭제 하시겠습니까?") == true) {
                
               alert(cnum)
           $.ajax({
               url : "deleteCartSel",
                type : "post",
                data : {chbox : cnum}})
          
           }
            location.reload();
    }
    
</script>




<%@ include file="footer.jsp"%>
