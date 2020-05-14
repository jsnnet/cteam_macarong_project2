<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<%-- loginform.jsp --%>
<%@include file="header.jsp"%>
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script>
var $modalnum;

function aa (){
       $modalnum.on('change',function(){
         console.log('zzzz');
         let num = $modalnum.find('#foodtotal').val();
         let num2 = $modalnum.find('#foodpay').attr('value');
         let num3 = $modalnum.find('#howdeli').val();
         let total_pay = num*num2;
         console.log(num);
         console.log(num2);
         console.log(num3);
         console.log('총 금액 ' + total_pay);
         $modalnum.find('#totalpay2').attr('value',total_pay);
         $modalnum.find('#howdeli').attr('value');
         $modalnum.find('#howdeli2').attr('value',num3)
      });
    };
    
    function cart() { // 장바구니로 값들 가져오기 위해 추가작성
    	$modalnum.on('change',function(){
    		console.log('cart');
    		let num4 = $modalnum.find('#foodtotal').val();
    		console.log(num4);
    		$modalnum.find('#foodtotal').attr('value');
    		$modalnum.find('#foodtotal2').attr('value',num4);
    	});
	};
    function showPopup(){window.open("/intoBasket","a","width=400, height=300, left=100, top=50");}
	
	
	
function modal_btn(ele){
   console.log($(ele).attr('id'));
   let divname = $(ele).attr('id');
   $modalnum = $('#' + divname);
   console.log($modalnum);
   aa();
   cart(); // 장바구니로 값들 가져오기 위해 추가
}

function menu_list() {
      if($("#menudiv").children().length == 0){
         console.log()
         $.ajax({
      url:"./store/menu?stnum=${storevo.stnum }",
      dataType : 'json',
      cache : false,
      success:function(data){
         //list -> 반복문 처리
         let tag ="";
         let path = '${pageContext.request.contextPath }';
         // $. jquery 의 상위 객체
         
         
         //반복문 처리 => 향샹된 forans => $.each(data,function(idx[배열 번호], key[값]){ 
         $.each(data,function(idx, key){//key = storevo      
            $.each(key.menu,function(idx, key){ 
            tag += '<div class="col-xs-6" id='+key.stnum+'-'+key.foodnum+'>';
            tag += '<div class="product-image" style="border-style: solid; border-color: lightgray; border-width: 1px;">';
            tag += '<a href="#">';
            tag += "<img src="+path+"/resources/imgfile/"+key.foodimg+" width='100px' height='100px'>";
            tag += '<h3 style="text-align: center;">';
            tag += '<strong>'+key.foodname+'</strong>';
            tag += '</h3>';
            tag += '<p style="text-align: center;">'+key.foodpay+' 원'+'</p>';
            
             tag += "<button id='menu_modal"+key.foodnum+"'";
             tag += "class='btn btn-default' data-target='#layerpop"+key.foodnum+"'";
             tag += "data-toggle='modal'";
             tag += "onclick='modal_btn(layerpop"+key.foodnum+")'>주문</button>"; 
            tag += '</div></div>';
            
            /* ----------------------------------------------------------------------------------------------------------- */      
            tag += '<div class="modal fade" id="layerpop'+key.foodnum+'">';
            tag += '<div class="modal-dialog">';
            tag += '<div class="modal-content">';
            tag += '<div class="modal-header">';
            tag += '<button type="button" class="close" data-dismiss="modal">×</button>';
            tag += '<h4 class="modal-title">Header</h4></div>';
            tag += '<div class="modal-body">주문 결제<hr>';
            tag += '<form method="post" action="pay" autocomplete="off" enctype="multipart/form-data">';
            tag += '<input type="hidden" id="foodname" name="foodname" value="'+key.foodname+'">';
            tag += '<p><label>음식 이름 : '+key.foodname+'</label></p>';
            tag += '<input type="hidden" id="foodpay" name="foodpay" value="'+key.foodpay+'">';
            tag += '<p><label>음식 가격 : <a id="foodpay" value="'+key.foodpay+'">'+key.foodpay+'</a></label></p>';
            /* style="text-align: left;" */
            /* tag += '<p style="text-align: left;"><label>음식 수량</label>'; */
            /* tag += '<input type="number" name="foodtotal" id="foodtotal'+key.foodnum+'" min="1" value="1" ></p>'; */
            tag += '<label>* 1회 주문 시 최대 수량은 5개 입니다. *</label>';
            tag += '<p><label>음식 수량 :</label><select name="foodtotal" id="foodtotal">'
               /* 1회 주문 시 최대 수량은 5개 입니다. */
            tag += '<option value="">선택</option>'
            tag += '<option value=1>1</option>'
            tag += '<option value=2>2</option>'
            tag += '<option value=3>3</option>'
            tag += '<option value=4>4</option>'
            tag += '<option value=5>5</option>'
            tag += '</select>'            
            tag += '<label>  수령 방식 :</label><select name="howdeli" id="dok">'
            tag += '<option value="">선택</option>'
            tag += '<option value=0>1.테이크 아웃</option>'
            tag += '<option value=1>2.배달 </option>'
            tag += '</select></p>'
            tag += '<p><label>총 가격 </label><input type="text" readonly="readonly" id="totalpay2" name="pay_total" value="'+key.foodpay+'">';
            tag += '</p>';
            tag += '<hr>';
            tag += '<input type="hidden" name="stnum" value="${storevo.stnum}">';
            tag += '<input type="submit" class="btn btn-default" value="결제">';
            /* 회원 정보 -> 회원 번호 / : memnum -> 세션값에서 받아 오면 됨
            	메뉴 정보 -> 이름 / 가격 / 수량 / 총 가격 / 가게번호 : stnum */ //sysout("adaasa"+a+"adadas")
            //tag += '<input type="button" class="btn btn-default" value="장바구니" onclick=location="basket?foodname='+key.foodname+'&foodpay='+key.foodpay+'">';
            tag += '</form>';
            
            /*---------------------------------------------------------------------------------------------------------------------*/
            
            tag += '<form method="post" action="intoBasket" autocomplete="off" enctype="multipart/form-data">';
            /* 장바구니로 가져갈 값들 */
            
            // memnum,stnum,foodnum,basketpay,foodtotal 가져가야 함
            // 0. memnum 회원번호는 session(sesstion)으로부터 (o)
            
            // 0. 상품번호 ; foodnum (o)
			tag +='<input type="hidden" id="foodnum" name="foodnum" value="'+key.foodnum+'">';        
            //tag += '<p><label> 0번 상품번호 : '+key.foodnum+'</label></p>'; // 숨길 것 1
            // 1. 상품이름 ; foodname (o)
            tag += '<input type="hidden" id="foodname" name="foodname" value="'+key.foodname+'">';
            //tag += '<p><label> 1번 음식 이름 : '+key.foodname+'</label></p>'; // 숨길 것 2
            // 2. 상품 1개의 가격 (o)
            tag += '<input type="hidden" id="foodpay" name="foodpay" value="'+key.foodpay+'">';
            //tag += '<p><label> 2번 음식 가격 : <a id="foodpay" value="'+key.foodpay+'">'+key.foodpay+'</a></label></p>'; // 숨길 것 3
            // 3.수령방식 가져오는 방법을 모르겠음 (o) - 결제 테이블에서 
            //tag += '<p><label>수령방식:<a name="howdeli" id="dok"></a></label></p>';
            //tag += '<p><label> 3번 수령방식 가져오는 방법 아직 모르겠음 : <input type="text" readonly="readonly" id="howdeli2" name="howdeli"></label></p>';
            // 4.메뉴 수량에 따른 총액 계산 결과 ; basketpay (o)
            tag += '<input type="hidden" id="totalpay2" name="basketpay" value="'+key.foodpay+'">'; // 확인 완료 그리고 값 가져가기
            //tag += '<p><label> 4번 총액 : </label> <input type="text" readonly="readonly" id="totalpay2" name="basketpay" value="'+key.foodpay+'"></p>'; // 숨길 것 4
            // 5.가게번호 ; stnum (o)
            tag += '<input type="hidden" name="stnum" value="${storevo.stnum}">'; // 들어오는 것 확인 완료 그리고 값 가져가기
            //tag += '<p><label> 5번 상점번호 : <a name="stnum" value="${storevo.stnum}">${storevo.stnum}</a></label></p>'; // 숨길 것 5
            // 6.갯수 ; foodtotal (o)
            tag += '<input type="hidden" id="foodtotal2" name="foodtotal" value="'+key.foodtotal+'">';
            //tag += '<p><label> 6번 수량 : </label><input type="text" readonly="readonly" id="foodtotal2" name="foodtotal" value="'+key.foodtotal+'"></p>'; // 숨길 것 6
            /*-------------------*/
            tag += '<hr>';
            tag += '<input type="submit" class="btn btn-default" value="장바구니 추가">';
            tag += '</form>';
            
            /*--------------------------------------------------------------------------------------------------------------------*/
            
            tag += '</div>';
            tag += '</div></div></div></div>';   
            
//             tag += '<div id="dialog" title = "Message">'
//             tag += '해당부분은 레이어 팝업의 내용이다. br태그없이 알아서 자동으로 줄바꿈 처리함'
//             tag += '</div>'
            
//             	$(function(){
//             		$("#popupBtn").button();
//             	})
            	
//             	$('#dialog').dialog({
//             		autoOpen:false,
//             		width: 400,
//             		modal: true,
//             		buttons:[
//             			{text:"예",
//             				click:function(){
//             					$(this).dialog("close");
//             				}
            			
//             		}
//             			{
//             				text: "아니오",
//             				click:function(){
//             					$(this).dialog("close");
//             				}
            				
//             			}
//             	]
            	
//             	});
            	
//             	$("#popupBtn").click(function(){
//             		$("#dialog").dialog("open");
//             	});
                        
            $('#menubtn').attr("value"," 메뉴 닫기");
               });
            });
            $("#menudiv").html(tag);
            console.log($("#menudiv").children().attr('id'));
            console.log($("#menudiv").children().attr('id'));
         }
      });
      }else if($("#menudiv").children().length > 0){
         console.log($("#menudiv").children().length);
         console.log($('#menudiv').attr("style"));
         if($('#menudiv').attr("style") == 'display: none;'){
            $('#menudiv').css("display", "block");  
            $('#menubtn').attr("value"," 메뉴 닫기");
         }else{
            $('#menudiv').css("display", "none");
            $('#menubtn').attr("value"," 메뉴 리스트");
         }
      }
          
   }   

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
   width: 800px;
/*    margin-left: 350px; */
   margin: auto;
}

#store_list {
/*    border: 10px solid transparent; */
    text-align: center;
    table-layout: fixed;
   /* border: 1px solid; */ 
}
#td_menu {
    vertical-align: bottom;
  }
  
</style>
   <div id="list">
   
      <fieldset style="border: 1px solid rgba(255, 255, 255, .5);" id="container">
         <legend>${storevo.stsbname} 의 상세정보</legend>
         
         <table class="table table-hover" id="store_list">
            <thead>
               <p id="time">2019-11-22</p>
            </thead>
            <tbody>
               <tr>
                   <td>
                      가게 번호 
                   </td>
                   <td>
                      ${storevo.stnum }
                   </td>
               </tr>
               <tr>
                  <td>
                     가게 이름 
                  </td>
                  <td>
                     ${storevo.stsbname }
                  </td>
               </tr>
               <tr>
                  <td>
                     사장님 이름  
                  </td>
                  <td>
                     ${storevo.stname }
                  </td>
               </tr>
               <tr>
                  <td>
                     가게 전화 번호
                  </td>
                  <td>
                     ${storevo.stphone }
                  </td>
               </tr>
               <tr>
                  <td>
                     가게 사진
                  </td>
                  <td>
                  <img   src="${pageContext.request.contextPath }/resources/imgfile/${storevo.stimg }.jpg"
                        style="width: 100px; border: 0px">
                  </td>
               </tr>
               <tr>
                  <td>
                     가게 주소
                  </td>
                  <td>
                     ${storevo.staddress }
                  </td>
               </tr>
               <tr>
                  <td id="td_menu"><a href="#menudiv">
                     <input class="btn btn-outline-dark" id="menubtn" type="button" value="메뉴 리스트" onclick="menu_list()"> </a>
                  </td>
                  <td style="text-align: center;">
                     <div id="map" style="width:320px; height:250px; display:inline-block;"></div>
                  </td>   
               </tr>
            </tbody>
            <tfoot>
            </tfoot>
         </table>
      </fieldset>
      <div class="row" id="menudiv">
      </div>
   </div>
   

   
   
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e90cdeec53794118950db07f3e598779&libraries=services"></script>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

// 주소로 좌표를 검색합니다
geocoder.addressSearch('${storevo.staddress }', function(result, status) {

    // 정상적으로 검색이 완료됐으면 
     if (status === kakao.maps.services.Status.OK) {

        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        // 결과값으로 받은 위치를 마커로 표시합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        // 인포윈도우로 장소에 대한 설명을 표시합니다
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="width:150px;text-align:center;padding:6px 0;">${storevo.stsbname }</div>'
        });
        infowindow.open(map, marker);

        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        map.setCenter(coords);
    } 
});    
</script>
   <br>
<br>
<br>
</div>
<%@include file="footer.jsp"%>