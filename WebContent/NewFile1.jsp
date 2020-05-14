<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=0.5, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<meta name="keywords" content="">
<meta name="description" content="">

<title>Guide | T MAP API</title>

<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico">
<link rel="stylesheet" type="text/css" href="/resources/css/subv2.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/jquery.mCustomScrollbar.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/jquery.treeview.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/highlight/default.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/jquery-ui.css">
<!-- 	<link rel="stylesheet" type="text/css" href="/resources/css/guide.css"> -->
<!-- 	<link rel="stylesheet" type="text/css" href="/resources/css/sample.css"> -->
<link rel="stylesheet" type="text/css" href="/resources/css/custom.css">

<script type="text/javascript" src="/resources/js/lib/jquery.fn.js"></script>
<script type="text/javascript"
	src="/resources/js/lib/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/jquery-ui.js"></script>
<script type="text/javascript"
	src="/resources/js/lib/jquery.easing.min.js"></script>
<script type="text/javascript"
	src="resources/js/lib/jquery.ui.touch-punch.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/placeholder.js"></script>
<script type="text/javascript"
	src="/resources/js/lib/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript"
	src="/resources/js/lib/jquery.treeview.js"></script>
<script type="text/javascript" src="/resources/js/lib/highlight.pack.js"></script>
<script type="text/javascript"
	src="/resources/js/lib/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/highlight.pack.js"></script>

<script type="text/javascript" src="/resources/js/ui/common.js"></script>
<script type="text/javascript" src="/resources/js/lib/w3.js"></script>
<script type="text/javascript"
	src="/syntaxhighlighter_3.0.83/scripts/shCore.js"></script>
<script type="text/javascript"
	src="/syntaxhighlighter_3.0.83/scripts/shBrushJScript.js"></script>
<script type="text/javascript"
	src="/syntaxhighlighter_3.0.83/scripts/shBrushXml.js"></script>
<link type="text/css" rel="stylesheet"
	href="/syntaxhighlighter_3.0.83/styles/shCoreDefault.css" />

<!-- CodeMirror -->
<script src="/resources/js/codemirror/codemirror.js"></script>
<link rel="stylesheet" href="/resources/css/codemirror/codemirror.css">
<link rel="stylesheet" href="/resources/css/codemirror/xq-light.css">
<link rel="stylesheet" href="/resources/css/codemirror/panda-syntax.css">
<script src="/resources/js/codemirror/mode/javascript.js"></script>

<style type="text/css">
.syntaxhighlighter {
	height: 600px;
	width: 840px !important;
	overflow-y: auto !important;
	overflow-x: auto !important;
}

/* 검색결과 디자인 관련 - START */
#search_result a {
	color: #cccccc
}

#search_result span {
	color: #ffffff
}
/* 검색결과 디자인 관련 - END */
</style>

<script type="text/javascript">
	var mLastUrlString = ''; // 가장 최근에 불러온 메인 화면 URL 저장
	var mIsNeedRefresh = false; // 새로고침 필요여부(검색페이지 로드 시 Anchor 가 변하지 않아 강제 새로고침 필요)

	$(document).ready(function() {
		loadMainContents($.urlAnchor()); // 메인 화면 불러오기
		$(window).on('hashchange', function(evt) {
			// URL #(앵커) 변경시 호출됨
			loadMainContents($.urlAnchor()); // 메인 화면 불러오기
		});
		$(document).on('click', 'a', function(evt) {
			// a Link 클릭시 호출됨
			var strHref = $(this).attr('href');
			if ('#' + $.urlAnchor() == strHref) {
				// URL 이 같으면 a 링크 클릭해도 hashchange 이벤트가 발생하지 않기 때문에 임의로 함수호출
				loadMainContents($.urlAnchor()); // 메인 화면 불러오기
			}
		});
		SyntaxHighlighter.all(); // 소스코드에 색상 테마 적용

		// 검색어 창 이벤트 설정
		$('#search_keyword').keyup(function() {
			searchMenuTitle($(this).val());
		});
		$('#search_keyword').keydown(function(evt) {
			if (evt.keyCode == 13) {
				$('#search_button').trigger('click');
			}
		});

		// 검색 버튼 이벤트 설정
		$('#search_button').click(function() {
			loadSearchIndex($('#search_keyword').val());
		});
	});

	// 검색어 자동완성
	function searchMenuTitle(searchKeyword) {
		var searchCategory = ''; // 검색범위(Web, WebV2 Android, iOS, WebService)

		if (searchKeyword && searchKeyword != '') {
			searchCategory = $('#side_search .dropdown_wrapper a').html()
					.trim(); // 검색범위(Web, WebV2, Android, iOS, WebService)

			// 검색창에 검색 범위목록 복제
			$('#search_result dl').html(
					$('#tit_' + searchCategory.replace(" ", "_"))
							.siblings('ul').clone().addClass('filetree')
							.wrapAll("<div/>").parent().html());
			$('#search_result ul, #search_result li').css('display', 'none');

			// 검색어가 존재하는 항목만 표시
			$('#search_result a').each(
					function() {
						var aTagText = $(this).text();
						if (aTagText.toLowerCase().indexOf(
								searchKeyword.toLowerCase()) != -1) {
							$(this).parents('ul, li').css('display', 'block');
						}
					});
			$('#search_result').show();
		} else {
			// 자동 검색창 숨기기
			$('#search_result').hide();
			$('#search_result dl').html("");
		}
	}

	// Index 검색결과 페이지 메인에 로드
	function loadSearchIndex(searchKeyword) {
		var searchCategory = '';

		var resultHtml = '';

		if (searchKeyword && searchKeyword != '') {
			searchCategory = $('#side_search .dropdown_wrapper a').html()
					.trim(); // 검색범위(Web, WebV2 Android, iOS, WebService)

			setSelectedMenuCSS('search_result');
			$('#contents')
					.load(
							'/search_result.html',
							function(response, status, xhr) {
								var resultLinkGuide = '';
								var resultLinkSample = '';
								var resultLinkDocs = '';
								var resultLinkUsecase = '';

								var resultCnt = 0;
								var eachCnt = 0;
								if (status == "success") {
									// 메인 페이지 로드 성공 시 작업

									// 검색 페이지 로드시 Anchor 가 변하지 않아 임의로 페이지 새로고침 필요
									mIsNeedRefresh = true;

									// 카테고리 표시
									$('#divIndexCategory').html(searchCategory);
									$('#divIndexCategory').addClass(
											searchCategory.replace(/\s/gi, ""));

									// 각 메뉴 복제하여 로드
									$('#indexResultGuide')
											.html(
													$(
															'#tit_'
																	+ searchCategory
																			.replace(
																					" ",
																					"_"))
															.siblings('ul')
															.find(
																	'li > span:contains("Guide")')
															.siblings('ul')
															.clone().addClass(
																	'filetree')
															.wrapAll("<div/>")
															.parent().html());
									$('#indexResultSample')
											.html(
													$(
															'#tit_'
																	+ searchCategory
																			.replace(
																					" ",
																					"_"))
															.siblings('ul')
															.find(
																	'li > span:contains("Sample")')
															.siblings('ul')
															.clone().addClass(
																	'filetree')
															.wrapAll("<div/>")
															.parent().html());
									$('#indexResultDocs')
											.html(
													$(
															'#tit_'
																	+ searchCategory
																			.replace(
																					" ",
																					"_"))
															.siblings('ul')
															.find(
																	'li > span:contains("Docs")')
															.siblings('ul')
															.clone().addClass(
																	'filetree')
															.wrapAll("<div/>")
															.parent().html());
									$('#indexResultUsecase')
											.html(
													$(
															'#tit_'
																	+ searchCategory
																			.replace(
																					" ",
																					"_"))
															.siblings('ul')
															.find(
																	'li > span:contains("Use case")')
															.siblings('ul')
															.clone().addClass(
																	'filetree')
															.wrapAll("<div/>")
															.parent().html());
									$('#tbodyResult ul, #tbodyResult li').css(
											'display', 'none');

									// Guide 검색 결과 생성
									eachCnt = 0;
									$('#indexResultGuide a')
											.each(
													function() {
														var aTagText = $(this)
																.text();
														if (aTagText
																.toLowerCase()
																.indexOf(
																		searchKeyword
																				.toLowerCase()) != -1) {
															//resultHtml += '<dd>' + $(this).parent().html() + '</dd>';
															$(this)
																	.parents(
																			'ul, li')
																	.css(
																			'display',
																			'block');
															resultCnt++;
															eachCnt++;
														}
													});
									if (eachCnt == 0) {
										$('#search_guide').css('display',
												'none');
										$('#search_guide_list').css('display',
												'none');
									}

									// Sample 검색 결과 생성
									eachCnt = 0;
									$('#indexResultSample a')
											.each(
													function() {
														var aTagText = $(this)
																.text();
														if (aTagText
																.toLowerCase()
																.indexOf(
																		searchKeyword
																				.toLowerCase()) != -1) {
															//resultHtml += '<dd>' + $(this).parent().html() + '</dd>';
															$(this)
																	.parents(
																			'ul, li')
																	.css(
																			'display',
																			'block');
															resultCnt++;
															eachCnt++;
														}
													});
									if (eachCnt == 0) {
										$('#search_sample').css('display',
												'none');
										$('#search_sample_list').css('display',
												'none');
									}

									// Docs 검색 결과 생성
									eachCnt = 0;
									$('#indexResultDocs a')
											.each(
													function() {
														var aTagText = $(this)
																.text();
														if (aTagText
																.toLowerCase()
																.indexOf(
																		searchKeyword
																				.toLowerCase()) != -1) {
															//resultHtml += '<dd>' + $(this).parent().html() + '</dd>';
															$(this)
																	.parents(
																			'ul, li')
																	.css(
																			'display',
																			'block');
															resultCnt++;
															eachCnt++;
														}
													});
									if (eachCnt == 0) {
										$('#search_docs')
												.css('display', 'none');
										$('#search_docs_list').css('display',
												'none');
									}

									// Use case 검색 결과 생성
									if (searchCategory == "Web"
											|| searchCategory == "WebV2") {
										eachCnt = 0;
										$('#indexResultUsecase a')
												.each(
														function() {
															var aTagText = $(
																	this)
																	.text();
															if (aTagText
																	.toLowerCase()
																	.indexOf(
																			searchKeyword
																					.toLowerCase()) != -1) {
																//resultHtml += '<dd>' + $(this).parent().html() + '</dd>';
																$(this)
																		.parents(
																				'ul, li')
																		.css(
																				'display',
																				'block');
																resultCnt++;
																eachCnt++;
															}
														});
										if (eachCnt == 0) {
											$('#search_usecase').css('display',
													'none');
											$('#search_usecase_list').css(
													'display', 'none');
										}
									}

									if (resultCnt > 0) {
										// 검색결과가 존재할 경우
										// Index 결과검색 테마 적용
										$('#tbodyResult a').addClass(
												'h_underline');
										$('#tbodyResult a')
												.each(
														function() {
															$(this)
																	.html(
																			'· <span>'
																					+ $(
																							this)
																							.html()
																					+ '</span>');
														});
									} else {
										$('#tbodyResult')
												.html(
														'<td style="padding:100px 20px">검색 결과가 없습니다.</td>');
									}

									// 스크롤 맨 위로 이동
									$('main').animate({
										scrollTop : 0
									}, 100);
								}
							});
		}
	}

	// 메인페이지 로드 함수
	function loadMainContents(urlAnchorString) {
		var urlString = null; // (URL?Prameter) : .html 없음
		var urlWithHtml = null; // 메인 페이지에 띄울 실제 요청 주소
		var anchorIndex = -1; // 앵커 인덱스
		var anchorString = null; // 앵커 스트링

		// 자동 검색창 초기화 - START
		$('#search_keyword').val('');
		$('#search_result').hide();
		$('#search_result dl').html("");
		// 자동 검색창 초기화 - END

		if (urlAnchorString) {
			// URL 과 책갈피 정보 파싱 - START
			anchorIndex = urlAnchorString.indexOf('.'); // 페이지 URL 과 책갈피 정보는 "." 으로  구분됨
			if (anchorIndex != -1) {
				// 책갈피 정보가 있는 경우
				urlString = urlAnchorString.substring(0, anchorIndex);
				anchorString = urlAnchorString.substring(anchorIndex + 1,
						urlAnchorString.length);
			} else {
				// 책갈피 정보가 없는 경우
				urlString = urlAnchorString;
			}
			// URL 과 책갈피 정보 파싱 - END

			if (mIsNeedRefresh || mLastUrlString != urlString) {
				// 새로고침이 필요하거나 새로운 URL 일 경우 작업

				// 새로고침 필요여부 초기화
				mIsNeedRefresh = false;

				// 실제 요청 주소 만들기
				if (urlString.indexOf('?') != -1) {
					// 파라미터가 있을 경우
					urlWithHtml = "/"
							+ urlString.substring(0, urlString.indexOf('?'))
							+ ".html"
							+ urlString.substring(urlString.indexOf('?'),
									urlString.length); // ?(파라미터 구분자) 앞에 .html 끼워 넣음
				} else {
					// 파라미터가 없을 경우
					urlWithHtml = "/" + urlString + ".html";
				}

				$('#contents')
						.load(
								urlWithHtml,
								function(response, status, xhr) {
									if (status == "success") {
										// 메인 페이지 로드 성공 시 작업

										// 최근 페이지 URL 저장( 중복 로드 방지 )
										mLastUrlString = urlString;

										// 선택된 메뉴 표시
										setSelectedMenuCSS(urlString,
												anchorString);

										// 책갈피 위치로 이동
										if (anchorString) {
											$.moveScrollById(anchorString);
										} else {
											$('#contents.main').animate({
												scrollTop : 0
											}, 500, 'swing', function() {
												$('#top_btn').fadeOut();
											});
										}
									} else {
										// 기본 페이지 로드
										location.href = "/main.html#web/sample/TotalSample";
										// 			            setSelectedMenuCSS('web/sample/TotalSample');
										// 			            $('#contents').load('/web/sample/TotalSample.html');
									}
								});
			} else {
				// 기존 URL 일 경우 작업

				// 선택된 메뉴 표시
				setSelectedMenuCSS(urlString, anchorString);

				// 책갈피 위치로 이동
				if (anchorString) {
					$.moveScrollById(anchorString);
				}
			}
		}
	}

	// 좌측 메뉴 선택된 항목 설정
	function setSelectedMenuCSS(urlString, anchorString) {
		var htmlIndex = -1;
		var menuId = '';

		if (urlString) {

			// 메뉴 아이디 구하기
			if (urlString.indexOf("?") != -1) {
				// 파라미터가 있을 경우
				menuId = urlString.substring(0, urlString.indexOf("?"))
						.replace(/\//gi, "_"); // 슬레시를 언더바로 치환
			} else {
				// 파라미터가 없을 경우
				menuId = urlString.replace(/\//gi, "_"); // 슬레시를 언더바로 치환
			}

			// 앵커가 존재한다면 메뉴 아이디 뒤에 붙임
			if (anchorString) {
				menuId = menuId + "_" + anchorString; // anchor 에서 # 제거하고 메뉴 아이디 뒤에 붙이기
			}

			$('#' + menuId).closest('li').parents('li').removeClass(
					'expandable');
			$('#' + menuId).closest('li').parents('li').addClass('collapsable');

			$('#' + menuId).parents('ul').css('display', 'block');
			$('#' + menuId).parents('ul').each(function(index, element) {
				$(element).siblings('div').removeClass('expandable-hitarea');
				$(element).siblings('div').addClass('collapsable-hitarea');
			});

			$('#tree_wrap a').removeClass("on");
			$('#' + menuId).addClass("on");

			//메뉴 스크롤 이동 (스크롤이 펼쳐지는 시간이 클라이언트마다 다르기에 1초 후 작동)
			setTimeout(function() {
				$("#tree_wrap").mCustomScrollbar("scrollTo", '#' + menuId);
			}, 1000);

		}
	}

	// Html id 로 위치를 찾아서 스크롤
	$.moveScrollById = function(id) {
		setTimeout(function() {
			var position = $('#' + id).offset(); // 위치값

			if (position) {
				$('main').animate({
					scrollTop : (position.top + $('main').scrollTop())
				}, 100); // 이동
			}
		}, 300);//처음 로딩시 offset의 위치값이 달라지므로 0.3초 딜레이
	}

	// URL 에서 앵커 추출
	$.urlAnchor = function() {
		var sharpIndex = window.location.href.indexOf('#');
		var result = null;
		if (sharpIndex != -1) {
			result = window.location.href.substring(sharpIndex + 1,
					window.location.href.length);
		}
		if (result == null) {
			return null;
		} else {
			return result || '';
		}
	}
</script>
</head>
<body>
	<!-- wrapper -->
	<div id="wrapper">
		<!-- left -->
		<div id="side_wrap">
			<div class="relative_wrap">
				<!-- header -->
				<header>
					<div class="header">
						<h1>
							<a href="/index.html"><img
								src="/resources/images/sub/logo_01.png" alt="T map API"></a>
						</h1>
					</div>
				</header>
				<!-- //header -->

				<div id="side_search">
					<div class="input_wrap">
						<input id="search_keyword" type="text" placeholder="index search">
						<div class="dropdown_wrapper">
							<a href="#" class="select_re web">Web</a>
							<div class="dropdown_select">
								<ul>
									<li class="web"><a href="#">WebV2</a></li>
									<li class="web"><a href="#">Web</a></li>
									<li class="android"><a href="#">Android</a></li>
									<li class="ios"><a href="#">iOS</a></li>
									<li class="webService"><a href="#">Web service</a></li>
								</ul>
							</div>
						</div>
						<a id="search_button" href="#" class="btn_search"><img
							src="/resources/images/sub/btn_search_01.png" alt="btn_search"></a>
					</div>
				</div>
				<div id="search_result">
					<div class="in_wrap mCustomScrollbar">
						<dl>
							<dt>검색 결과가 없습니다.</dt>
						</dl>
					</div>
				</div>

				<div id="tree_wrap" class="mCustomScrollbar">
					<ul id="browser" class="filetree">
						<li style="background: none"><span id="tit_Guide"
							class="tit tit_ico_guide">Guide</span>
							<ul>
								<li><a id="webv2_guide_apiGuide_guide1"
									href="#webv2/guide/apiGuide.guide1">T map Open API란?</a></li>
								<li><a id="webv2_guide_apiGuide_guide2"
									href="#webv2/guide/apiGuide.guide2">키 발급하기</a></li>
								<li><a id="webv2_guide_apiGuide_guide3"
									href="#webv2/guide/apiGuide.guide3">T map 기본 사항</a></li>
							</ul></li>

						<li style="background: none"><span id="tit_WebV2"
							class="tit tit_ico_web">Web V2</span>
							<ul>
								<li><span>Guide</span>
									<ul style="display: none">
										<!-- <li><a id="webv2_guide_webGuide_sample1" href="#webv2/guide/webGuide.sample1">키 발급하기</a></li>
										<li><a id="webv2_guide_webGuide_sample2" href="#webv2/guide/webGuide.sample2">T map 기본 사항</a></li> -->
										<li><a id="webv2_guide_webGuide_sample1"
											href="#webv2/guide/webGuide.sample1">T map V2 설명</a></li>
										<li><a id="webv2_guide_webGuide_sample2"
											href="#webv2/guide/webGuide.sample2">T map V2 시작하기</a></li>
										<li><a id="webv2_guide_webGuide_sample3"
											href="#webv2/guide/webGuide.sample3">T map V2 활용사례</a></li>
									</ul></li>

								<li><span class=""><a style="margin-left: 0px;"
										id="webv2_sample_TotalSampleV2"
										href="#webv2/sample/TotalSampleV2">Sample</a></span>
									<ul style="display: none">
										<li><span class="">기본기능</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample01"
													href="#webv2/sample/webSample01">지도 생성하기</a></li>
												<li><a id="webv2_sample_webSample02"
													href="#webv2/sample/webSample02">지도 영역 확인하기</a></li>
												<li><a id="webv2_sample_webSample63"
													href="#webv2/sample/webSample63">지도 마우스로 이동하기</a></li>
												<li><a id="webv2_sample_webSample03"
													href="#webv2/sample/webSample03">클릭 이벤트 등록하기</a></li>
												<li><a id="webv2_sample_webSample04"
													href="#webv2/sample/webSample04">두 지점간의 거리 확인하기</a></li>
												<li><a id="webv2_sample_webSample05"
													href="#webv2/sample/webSample05">선의 거리 계산하기</a></li>
												<li><a id="webv2_sample_webSample06"
													href="#webv2/sample/webSample06">좌표변환하기</a></li>
												<li><a id="webv2_sample_webSample07"
													href="#webv2/sample/webSample07">지도 키보드로 이동하기</a></li>
												<li><a id="webv2_sample_webSample64"
													href="#webv2/sample/webSample64">지도 레벨 변경하기</a></li>
												<li><a id="webv2_sample_webSample08"
													href="#webv2/sample/webSample08">지도 이동 막기</a></li>
												<li><a id="webv2_sample_webSample09"
													href="#webv2/sample/webSample09">지도 확대축소 제어하기</a></li>
												<li><a id="webv2_sample_webSample10"
													href="#webv2/sample/webSample10">지도 확대축소 버튼
														추가/제거하기(이미지는 줌버튼이 없는 이미지)</a></li>
												<li><a id="webv2_sample_webSample11"
													href="#webv2/sample/webSample11">지도 정보 얻어오기</a></li>
												<!-- <li><a id="webv2_sample_webSample66"
													href="#webv2/sample/webSample66">지도상 마우스 좌표값 표시하기</a></li> -->
												<!-- <li><a id="webv2_sample_webSample12"
													href="#webv2/sample/webSample12">지도 캐시 초기화</a></li> -->
												<li><a id="webv2_sample_webSample13"
													href="#webv2/sample/webSample13">팝업 생성하기</a></li>
												<!-- <li><a id="webv2_sample_webSample14"
													href="#webv2/sample/webSample14">커스텀 오버레이 사용하기</a></li> -->
											</ul></li>

										<li><span class="">마커</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample15"
													href="#webv2/sample/webSample15">마커 생성하기</a></li>
												<li><a id="webv2_sample_webSample15_1"
													href="#webv2/sample/webSample15_1">애니메이션 마커 추가하기_튕기기</a></li>
												<li><a id="webv2_sample_webSample15_2"
													href="#webv2/sample/webSample15_2">애니메이션 마커 추가하기_나타나기</a></li>
												<li><a id="webv2_sample_webSample15_3"
													href="#webv2/sample/webSample15_3">애니메이션 마커 추가하기_떨어지기</a></li>
												<li><a id="webv2_sample_webSample15_4"
													href="#webv2/sample/webSample15_4">애니메이션 마커 추가하기_Fade
														in</a></li>
												<li><a id="webv2_sample_webSample15_5"
													href="#webv2/sample/webSample15_5">애니메이션 마커 추가하기_깜박이기</a></li>
												<li><a id="webv2_sample_webSample15_6"
													href="#webv2/sample/webSample15_6">애니메이션 마커 추가하기_커지기</a></li>
												<li><a id="webv2_sample_webSample15_7"
													href="#webv2/sample/webSample15_7">마커 한번에 100개 추가하기</a></li>
												<li><a id="webv2_sample_webSample74"
													href="#webv2/sample/webSample74">마커 표출여부 확인하기</a></li>
												<li><a id="webv2_sample_webSample75"
													href="#webv2/sample/webSample75">클릭한 위치에 마커 표시하기</a></li>
												<li><a id="webv2_sample_webSample76"
													href="#webv2/sample/webSample76">GeoLocation으로 마커 표시하기</a></li>
												<li><a id="webv2_sample_webSample17"
													href="#webv2/sample/webSample17">드래그 가능한 마커 생성하기</a></li>
												<li><a id="webv2_sample_webSample77"
													href="#webv2/sample/webSample77">다중 마커 생성하기</a></li>
												<li><a id="webv2_sample_webSample78"
													href="#webv2/sample/webSample78">다중 마커 라벨 생성하기</a></li>
												<li><a id="webv2_sample_webSample18"
													href="#webv2/sample/webSample18">다른 이미지로 마커 생성하기</a></li>
												<li><a id="webv2_sample_webSample19"
													href="#webv2/sample/webSample19">마커에 마우스 이벤트 등록하기</a></li>
												<li><a id="webv2_sample_webSample80"
													href="#webv2/sample/webSample80">마커 클러스터러 사용하기</a></li>
											</ul></li>

										<!-- <li><span class="">이벤트</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample21"
													href="#webv2/sample/webSample21">지도에 이벤트 등록하기</a></li>
												<li><a id="webv2_sample_webSample22"
													href="#webv2/sample/webSample22">마커에 마우스 이벤트 등록하기</a></li>
												<li><a id="webv2_sample_webSample23"
													href="#webv2/sample/webSample23">다중 마커에 이벤트 등록</a></li>
											</ul></li> -->

										<li><span class="">그리기</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample24"
													href="#webv2/sample/webSample24">원,선,사각형,다각형 그리기</a></li>
												<li><a id="webv2_sample_webSample81"
													href="#webv2/sample/webSample81">원 그리기</a></li>
												<li><a id="webv2_sample_webSample82"
													href="#webv2/sample/webSample82">사각형 그리기</a></li>
												<li><a id="webv2_sample_webSample83"
													href="#webv2/sample/webSample83">라인 그리기</a></li>
												<li><a id="webv2_sample_webSample84"
													href="#webv2/sample/webSample84">폴리곤 그리기</a></li>
												<!-- <li><a id="webv2_sample_webSample25"
													href="#webv2/sample/webSample25">레이어 제어하기</a></li> -->
												<li><a id="webv2_sample_webSample26"
													href="#webv2/sample/webSample26">다각형의 면적 계산하기</a></li>
												<!-- <li><a id="webv2_sample_webSample15_8"
													href="#webv2/sample/webSample15_8">오버레이 추가하기</a></li> -->
												<!-- <li><a id="webv2_sample_webSample27"
													href="#webv2/sample/webSample27">Polygon 면적 계산하기</a></li> -->
												<!-- <li><a id="webv2_sample_webSample28"
													href="#webv2/sample/webSample28">Circle 면적 계산하기</a></li> -->
											</ul></li>

										<li><span class="">TData</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample85"
													href="#webv2/sample/webSample85">지오코딩</a></li>
												<li><a id="webv2_sample_webSample86"
													href="#webv2/sample/webSample86">리버스 지오코딩</a></li>
												<li><a id="webv2_sample_webSample87"
													href="#webv2/sample/webSample87">경로요청</a></li>
												<!-- <li><a id="webv2_sample_webSample88"
													href="#webv2/sample/webSample88">자동완성</a></li> -->
											</ul></li>
										<li><span class="">Tmap Invoke</span>
											<ul style="display: none">
												<li><a id="webv2_sample_webSample59"
													href="#webv2/sample/webSample59">TmapApp 실행하기</a></li>
												<li><a id="webv2_sample_webSample60"
													href="#webv2/sample/webSample60">지도보기</a></li>
												<li><a id="webv2_sample_webSample61"
													href="#webv2/sample/webSample61">길안내</a></li>
												<li><a id="webv2_sample_webSample62"
													href="#webv2/sample/webSample62">POI 통합검색</a></li>
											</ul></li>
										<!-- li>
											<span class="">SDK V1에 있던 나머지 샘플</span>
											<ul style="display:none">
												<li><a id="webv1_sample_webSample39" href="#webv2/sample_v1/webSample39">다각형에 이벤트 등록하기</a></li>
												<li><a id="webv1_sample_webSample26" href="#webv2/sample_v1/webSample26">마커에 클릭 이벤트 등록하기</a></li>
												<li><a id="webv1_sample_webSample03" href="#webv2/sample_v1/webSample03">지도 마우스로 이동하기</a></li>
												<li><a id="webv1_sample_webSample05" href="#webv2/sample_v1/webSample05">지도 크기 비교하기</a></li>
												<li><a id="webv1_sample_webSample07" href="#webv2/sample_v1/webSample07">지도 레벨 변경하기</a></li>
												<li><a id="webv1_sample_webSample11" href="#webv2/sample_v1/webSample11">좌표계 코드 확인</a></li>
												<li><a id="webv1_sample_webSample12" href="#webv2/sample_v1/webSample12">지도상 마우스 좌표값 표시하기</a></li>
												<li><a id="webv1_sample_webSample13" href="#webv2/sample_v1/webSample13">지도 미니맵 보기</a></li>
												<li><a id="webv1_sample_webSample25" href="#webv2/sample_v1/webSample25">팝업 사이즈 확인하기</a></li>
												<li><a id="webv1_sample_webSample55" href="#webv2/sample_v1/webSample55">Label 팝업 스타일 적용하기</a></li>
												<li><a id="webv1_sample_webSample56" href="#webv2/sample_v1/webSample56">팝업 스타일 적용하기</a></li>
												<li><a id="webv1_sample_webSample42" href="#webv2/sample_v1/webSample42">지리정보 객체 가져오기</a></li>
												<li><a id="webv1_sample_webSample43" href="#webv2/sample_v1/webSample43">Collection 객체 사용하기</a></li>
												<li><a id="webv1_sample_webSample50" href="#webv2/sample_v1/webSample50">페이징 처리 사용하기</a></li>
												<li><a id="webv1_sample_webSample54" href="#webv2/sample_v1/webSample54">Toolbox 사용하기</a></li>		
												<li><a id="webv1_sample_webSample15" href="#webv2/sample_v1/webSample15">클릭한 위치에 마커 생성하기</a></li>
												<li><a id="webv1_sample_webSample28" href="#webv2/sample_v1/webSample28">GeoLocation으로 마커 표시하기</a></li>
												<li><a id="webv1_sample_webSample29" href="#webv2/sample_v1/webSample29">다중 마커 생성하기</a></li>
												<li><a id="webv1_sample_webSample57" href="#webv2/sample_v1/webSample57">다중 마커 라벨 생성하기</a></li>
												<li><a id="webv1_sample_webSample30" href="#webv2/sample_v1/webSample30">다중 마커 제어하기</a></li>
												<li><a id="webv1_sample_webSample32" href="#webv2/sample_v1/webSample32">다양한 마커 이미지 표시하기</a></li>	
											</ul>
										</li-->
									</ul></li>

								<li><span class="">Docs</span>
									<ul style="display: none">
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Tmap" href="#webv2/docs/WebDocs.Tmap">Tmapv2.Tmap</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Tmap_fitBounds"
													class="Tmap_fitBounds"
													href="#webv2/docs/WebDocs.Tmap_fitBounds">fitBounds</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_getBounds"
													class="Tmap_getBounds"
													href="#webv2/docs/WebDocs.Tmap_getBounds">getBounds</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_getBoundsEPSG3857"
													class="Tmap_getBoundsEPSG3857"
													href="#webv2/docs/WebDocs.Tmap_getBoundsEPSG3857">getBoundsEPSG3857</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_getCenter"
													class="Tmap_getCenter"
													href="#webv2/docs/WebDocs.Tmap_getCenter">getCenter</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_getDiv"
													class="Tmap_getDiv" href="#webv2/docs/WebDocs.Tmap_getDiv">getDiv</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_getZoom"
													class="Tmap_getZoom"
													href="#webv2/docs/WebDocs.Tmap_getZoom">getZoom</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_getScale"
													class="Tmap_getScale"
													href="#webv2/docs/WebDocs.Tmap_getScale">getScale</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_panBy"
													class="Tmap_panBy" href="#webv2/docs/WebDocs.Tmap_panBy">panBy</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_panTo"
													class="Tmap_panTo" href="#webv2/docs/WebDocs.Tmap_panTo">panTo</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_panToBounds"
													class="Tmap_panToBounds"
													href="#webv2/docs/WebDocs.Tmap_panToBounds">panToBounds</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_screenSize"
													class="Tmap_screenSize"
													href="#webv2/docs/WebDocs.Tmap_screenSize">screenSize</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_setCenter"
													class="Tmap_setCenter"
													href="#webv2/docs/WebDocs.Tmap_setCenter">setCenter</a></li>
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Tmap_setOptions" class="Tmap_setOptions" href="#webv2/docs/WebDocs.Tmap_setOptions">setOptions</a> -->
												<!-- 												</li> -->

												<li><a id="webv2_docs_WebDocs_Tmap_setZoom"
													class="Tmap_setZoom"
													href="#webv2/docs/WebDocs.Tmap_setZoom">setZoom</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_zoomIn"
													class="Tmap_zoomIn" href="#webv2/docs/WebDocs.Tmap_zoomIn">zoomIn</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_zoomOut"
													class="Tmap_zoomOut"
													href="#webv2/docs/WebDocs.Tmap_zoomOut">zoomOut</a></li>
												<li><a id="webv2_docs_WebDocs_Tmap_zoomToMaxExtent"
													class="Tmap_zoomToMaxExtent"
													href="#webv2/docs/WebDocs.Tmap_zoomToMaxExtent">zoomToMaxExtent</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_calcCurrentPixel"
													class="Tmap_calcCurrentPixel"
													href="#webv2/docs/WebDocs.Tmap_calcCurrentPixel">calcCurrentPixel</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_screenToReal"
													class="Tmap_screenToReal"
													href="#webv2/docs/WebDocs.Tmap_screenToReal">screenToReal</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_realToScreen"
													class="Tmap_realToScreen"
													href="#webv2/docs/WebDocs.Tmap_realToScreen">realToScreen</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Tmap_resize"
													class="Tmap_resize" href="#webv2/docs/WebDocs.Tmap_resize">resize</a>
												</li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_LatLng"
												href="#webv2/docs/WebDocs.LatLng">Tmapv2.LatLng</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_LatLng_clone"
													class="LatLng_clone"
													href="#webv2/docs/WebDocs.LatLng_clone">clone</a></li>
												<li><a id="webv2_docs_WebDocs_LatLng_toString"
													class="LatLng_toString"
													href="#webv2/docs/WebDocs.LatLng_toString">toString</a></li>
												<li><a id="webv2_docs_WebDocs_LatLng_lat"
													class="LatLng_lat" href="#webv2/docs/WebDocs.LatLng_lat">lat</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_lng"
													class="LatLng_lng" href="#webv2/docs/WebDocs.LatLng_lng">lng</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_latitude"
													class="LatLng_latitude"
													href="#webv2/docs/WebDocs.LatLng_latitude">latitude</a></li>
												<li><a id="webv2_docs_WebDocs_LatLng_longitude"
													class="LatLng_longitude"
													href="#webv2/docs/WebDocs.LatLng_longitude">longitude</a></li>
												<li><a id="webv2_docs_WebDocs_LatLng_setLatitude"
													class="LatLng_setLatitude"
													href="#webv2/docs/WebDocs.LatLng_setLatitude">setLatitude</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_setLongitude"
													class="LatLng_setLongitude"
													href="#webv2/docs/WebDocs.LatLng_setLongitude">setLongitude</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_distanceTo"
													class="LatLng_distanceTo"
													href="#webv2/docs/WebDocs.LatLng_distanceTo">distanceTo</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_equals"
													class="LatLng_equals"
													href="#webv2/docs/WebDocs.LatLng_equals">equals</a></li>
												<li><a id="webv2_docs_WebDocs_LatLng_toBesselTm"
													class="LatLng_toBesselTm"
													href="#webv2/docs/WebDocs.LatLng_toBesselTm">toBesselTm</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLng_toEPSG3857"
													class="LatLng_toEPSG3857"
													href="#webv2/docs/WebDocs.LatLng_toEPSG3857">toEPSG3857</a>
												</li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Bounds"
												href="#webv2/docs/WebDocs.Bounds">Tmapv2.Bounds</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Bounds_clone"
													class="Bounds_clone"
													href="#webv2/docs/WebDocs.Bounds_clone">clone</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_toString"
													class="Bounds_toString"
													href="#webv2/docs/WebDocs.Bounds_toString">toString</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_getLeft"
													class="Bounds_getLeft"
													href="#webv2/docs/WebDocs.Bounds_getLeft">getLeft</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_getTop"
													class="Bounds_getTop"
													href="#webv2/docs/WebDocs.Bounds_getTop">getTop</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_getWidth"
													class="Bounds_getWidth"
													href="#webv2/docs/WebDocs.Bounds_getWidth">getWidth</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_getHeight"
													class="Bounds_getHeight"
													href="#webv2/docs/WebDocs.Bounds_getHeight">getHeight</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_setLeft"
													class="Bounds_setLeft"
													href="#webv2/docs/WebDocs.Bounds_setLeft">setLeft</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_setTop"
													class="Bounds_setTop"
													href="#webv2/docs/WebDocs.Bounds_setTop">setTop</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_setWidth"
													class="Bounds_setWidth"
													href="#webv2/docs/WebDocs.Bounds_setWidth">setWidth</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_setHeight"
													class="Bounds_setHeight"
													href="#webv2/docs/WebDocs.Bounds_setHeight">setHeight</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_getPosition"
													class="Bounds_getPosition"
													href="#webv2/docs/WebDocs.Bounds_getPosition">getPosition</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Bounds_getSizei"
													class="Bounds_getSizei"
													href="#webv2/docs/WebDocs.Bounds_getSizei">getSizei</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_contains"
													class="Bounds_contains"
													href="#webv2/docs/WebDocs.Bounds_contains">contains</a></li>
												<li><a id="webv2_docs_WebDocs_Bounds_intersects"
													class="Bounds_intersects"
													href="#webv2/docs/WebDocs.Bounds_intersects">intersects</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Bounds_union"
													class="Bounds_union"
													href="#webv2/docs/WebDocs.Bounds_union">union</a></li>
												<!-- <li><a id="webv2_docs_WebDocs_Bounds_padding"
													class="Bounds_padding"
													href="#webv2/docs/WebDocs.Bounds_padding">padding</a></li> -->


											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_LatLngBounds"
												href="#webv2/docs/WebDocs.LatLngBounds">Tmapv2.LatLngBounds</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_LatLngBounds_toString"
													class="LatLngBounds_toString"
													href="#webv2/docs/WebDocs.LatLngBounds_toString">toString</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_contains"
													class="LatLngBounds_contains"
													href="#webv2/docs/WebDocs.LatLngBounds_contains">contains</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_equals"
													class="LatLngBounds_equals"
													href="#webv2/docs/WebDocs.LatLngBounds_equals">equals</a></li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_extend"
													class="LatLngBounds_extend"
													href="#webv2/docs/WebDocs.LatLngBounds_extend">extend</a></li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_getCenter"
													class="LatLngBounds_getCenter"
													href="#webv2/docs/WebDocs.LatLngBounds_getCenter">getCenter</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_LatLngBounds_getNorthEast"
													class="LatLngBounds_getNorthEast"
													href="#webv2/docs/WebDocs.LatLngBounds_getNorthEast">getNorthEast</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_LatLngBounds_getNorthWest"
													class="LatLngBounds_getNorthWest"
													href="#webv2/docs/WebDocs.LatLngBounds_getNorthWest">getNorthWest</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_LatLngBounds_getSouthWest"
													class="LatLngBounds_getSouthWest"
													href="#webv2/docs/WebDocs.LatLngBounds_getSouthWest">getSouthWest</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_LatLngBounds_getSouthEast"
													class="LatLngBounds_getSouthEast"
													href="#webv2/docs/WebDocs.LatLngBounds_getSouthEast">getSouthEast</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_intersects"
													class="LatLngBounds_intersects"
													href="#webv2/docs/WebDocs.LatLngBounds_intersects">intersects</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_isEmpty"
													class="LatLngBounds_isEmpty"
													href="#webv2/docs/WebDocs.LatLngBounds_isEmpty">isEmpty</a>
												</li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_union"
													class="LatLngBounds_union"
													href="#webv2/docs/WebDocs.LatLngBounds_union">union</a></li>
												<li><a id="webv2_docs_WebDocs_LatLngBounds_getWidth"
													class="LatLngBounds_getWidth"
													href="#webv2/docs/WebDocs.LatLngBounds_getWidth">getWidth</a>
												</li>
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_LatLngBounds_getHeightclone" class="LatLngBounds_getHeightclone" href="#webv2/docs/WebDocs.LatLngBounds_getHeightclone">getHeightclone</a> -->
												<!-- 												</li> -->
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Point"
												href="#webv2/docs/WebDocs.Point">Tmapv2.Point</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Point_clone"
													class="Point_clone" href="#webv2/docs/WebDocs.Point_clone">clone</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_distanceTo"
													class="Point_distanceTo"
													href="#webv2/docs/WebDocs.Point_distanceTo">distanceTo</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_toString"
													class="Point_toString"
													href="#webv2/docs/WebDocs.Point_toString">toString</a></li>
												<li><a id="webv2_docs_WebDocs_Point_getX"
													class="Point_getX" href="#webv2/docs/WebDocs.Point_getX">getX</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_getY"
													class="Point_getY" href="#webv2/docs/WebDocs.Point_getY">getY</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_setValue"
													class="Point_setValue"
													href="#webv2/docs/WebDocs.Point_setValue">setValue</a></li>
												<li><a id="webv2_docs_WebDocs_Point_setX"
													class="Point_setX" href="#webv2/docs/WebDocs.Point_setX">setX</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_setY"
													class="Point_setY" href="#webv2/docs/WebDocs.Point_setY">setY</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Point_offset"
													class="Point_offset"
													href="#webv2/docs/WebDocs.Point_offset">offset</a></li>
												<li><a id="webv2_docs_WebDocs_Point_equals"
													class="Point_equals"
													href="#webv2/docs/WebDocs.Point_equals">equals</a></li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Size" href="#webv2/docs/WebDocs.Size">Tmapv2.Size</a></span>
											<ul style="display: none">
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Size_width" class="Size_width" href="#webv2/docs/WebDocs.Size_width">width</a> -->
												<!-- 												</li> -->
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Size_height" class="Size_height" href="#webv2/docs/WebDocs.Size_height">height</a> -->
												<!-- 												</li> -->
												<li><a id="webv2_docs_WebDocs_Size_getWidth"
													class="Size_getWidth"
													href="#webv2/docs/WebDocs.Size_getWidth">getWidth</a></li>
												<li><a id="webv2_docs_WebDocs_Size_getHeight"
													class="Size_getHeight"
													href="#webv2/docs/WebDocs.Size_getHeight">getHeight</a></li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Marker"
												href="#webv2/docs/WebDocs.Marker">Tmapv2.Marker</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Marker_isLoaded"
													class="Marker_isLoaded"
													href="#webv2/docs/WebDocs.Marker_isLoaded">isLoaded</a></li>
												<li><a id="webv2_docs_WebDocs_Marker_create"
													class="Marker_create"
													href="#webv2/docs/WebDocs.Marker_create">create</a></li>
												<li><a
													id="webv2_docs_WebDocs_Marker_setElementPosition"
													class="Marker_setElementPosition"
													href="#webv2/docs/WebDocs.Marker_setElementPosition">setElementPosition</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_getOtherElements"
													class="Marker_getOtherElements"
													href="#webv2/docs/WebDocs.Marker_getOtherElements">getOtherElements</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_getIcon"
													class="Marker_getIcon"
													href="#webv2/docs/WebDocs.Marker_getIcon">getIcon</a></li>
												<li><a id="webv2_docs_WebDocs_Marker_getIconSize"
													class="Marker_getIconSize"
													href="#webv2/docs/WebDocs.Marker_getIconSize">getIconSize</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_getOffset"
													class="Marker_getOffset"
													href="#webv2/docs/WebDocs.Marker_getOffset">getOffset</a></li>
												<li><a id="webv2_docs_WebDocs_Marker_getDrawOffset"
													class="Marker_getDrawOffset"
													href="#webv2/docs/WebDocs.Marker_getDrawOffset">getDrawOffset</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_getPosition"
													class="Marker_getPosition"
													href="#webv2/docs/WebDocs.Marker_getPosition">getPosition</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_setPosition"
													class="Marker_setPosition"
													href="#webv2/docs/WebDocs.Marker_setPosition">setPosition</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_Marker_getPositionEPSG3857"
													class="Marker_getPositionEPSG3857"
													href="#webv2/docs/WebDocs.Marker_getPositionEPSG3857">getPositionEPSG3857</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Marker_setMap"
													class="Marker_setMap"
													href="#webv2/docs/WebDocs.Marker_setMap">setMap</a></li>
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Marker_setOptions" class="Marker_setOptions" href="#webv2/docs/WebDocs.Marker_setOptions">setOptions</a> -->
												<!-- 												</li> -->
												<li><a id="webv2_docs_WebDocs_Marker_setParent"
													class="Marker_setParent"
													href="#webv2/docs/WebDocs.Marker_setParent">setParent</a></li>
												<li><a id="webv2_docs_WebDocs_Marker_setVisible"
													class="Marker_setVisible"
													href="#webv2/docs/WebDocs.Marker_setVisible">setVisible</a>
												</li>
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Marker_showTitle" class="Marker_showTitle" href="#webv2/docs/WebDocs.Marker_showTitle">showTitle</a> -->
												<!-- 												</li> -->
												<!-- 												<li> -->
												<!-- 													<a id="webv2_docs_WebDocs_Marker_hideTitle" class="Marker_hideTitle" href="#webv2/docs/WebDocs.Marker_hideTitle">hideTitle</a> -->
												<!-- 												</li> -->
												<li><a id="webv2_docs_WebDocs_Marker_animate"
													class="Marker_animate"
													href="#webv2/docs/WebDocs.Marker_animate">animate</a></li>
												<li><a id="webv2_docs_WebDocs_Marker_stopAnimation"
													class="Marker_stopAnimation"
													href="#webv2/docs/WebDocs.Marker_stopAnimation">stopAnimation</a>
												</li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_MarkerOptions"
												href="#webv2/docs/WebDocs.MarkerOptions">Tmapv2.MarkerOptions</a></span>
											<ul style="display: none">

												<li><a id="webv2_docs_WebDocs_MarkerOptions_getMap"
													class="MarkerOptions_getMap"
													href="#webv2/docs/WebDocs.MarkerOptions_getMap">getMap</a></li>

												<li><a id="webv2_docs_WebDocs_MarkerOptions_setMap"
													class="MarkerOptions_setMap"
													href="#webv2/docs/WebDocs.MarkerOptions_setMap">setMap</a></li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Label"
												href="#webv2/docs/WebDocs.Label">Tmapv2.Label</a></span>
											<ul style="display: none">

												<li><a id="webv2_docs_WebDocs_Label_draw"
													class="Label_draw" href="#webv2/docs/WebDocs.Label_draw">draw</a></li>

												<li><a id="webv2_docs_WebDocs_Label_setMap"
													class="Label_setMap"
													href="#webv2/docs/WebDocs.Label_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_Label_getOffset"
													class="Label_getOffset"
													href="#webv2/docs/WebDocs.Label_getOffset">getOffset</a></li>

												<li><a id="webv2_docs_WebDocs_Label_getDrawOffset"
													class="Label_getDrawOffset"
													href="#webv2/docs/WebDocs.Label_getDrawOffset">getDrawOffset</a></li>
												<li><a id="webv2_docs_WebDocs_Label_getPosition"
													class="Label_getPosition"
													href="#webv2/docs/WebDocs.Label_getPosition">getPosition</a></li>

												<li><a
													id="webv2_docs_WebDocs_Label_getPositionEPSG3857"
													class="Label_getPositionEPSG3857"
													href="#webv2/docs/WebDocs.Label_getPositionEPSG3857">getPositionEPSG3857</a></li>
												<li><a id="webv2_docs_WebDocs_Label_setParent"
													class="Label_setParent"
													href="#webv2/docs/WebDocs.Label_setParent">setParent</a></li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_LabelOptions"
												href="#webv2/docs/WebDocs.LabelOptions">Tmapv2.LabelOptions</a></span>
										</li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_InfoWindow"
												href="#webv2/docs/WebDocs.InfoWindow">Tmapv2.InfoWindow</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_InfoWindow_draw"
													class="InfoWindow_draw"
													href="#webv2/docs/WebDocs.InfoWindow_draw">draw</a></li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_setMap"
													class="InfoWindow_setMap"
													href="#webv2/docs/WebDocs.InfoWindow_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_getOffset"
													class="InfoWindow_getOffset"
													href="#webv2/docs/WebDocs.InfoWindow_getOffset">getOffset</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_setOffset"
													class="InfoWindow_setOffset"
													href="#webv2/docs/WebDocs.InfoWindow_setOffset">setOffset</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_setContent"
													class="InfoWindow_setContent"
													href="#webv2/docs/WebDocs.InfoWindow_setContent">setContent</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_getDrawOffset"
													class="InfoWindow_getDrawOffset"
													href="#webv2/docs/WebDocs.InfoWindow_getDrawOffset">getDrawOffset</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_getPosition"
													class="InfoWindow_getPosition"
													href="#webv2/docs/WebDocs.InfoWindow_getPosition">getPosition</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_InfoWindow_getPositionEPSG3857"
													class="InfoWindow_getPositionEPSG3857"
													href="#webv2/docs/WebDocs.InfoWindow_getPositionEPSG3857">getPositionEPSG3857</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_setPosition"
													class="InfoWindow_setPosition"
													href="#webv2/docs/WebDocs.InfoWindow_setPosition">setPosition</a>
												</li>
												<li><a id="webv2_docs_WebDocs_InfoWindow_setParent"
													class="InfoWindow_setParent"
													href="#webv2/docs/WebDocs.InfoWindow_setParent">setParent</a>
												</li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Circle"
												href="#webv2/docs/WebDocs.Circle">Tmapv2.Circle</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Circle_create"
													class="Circle_create"
													href="#webv2/docs/WebDocs.Circle_create">create</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_draw"
													class="Circle_draw" href="#webv2/docs/WebDocs.Circle_draw">draw</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Circle_setMap"
													class="Circle_setMap"
													href="#webv2/docs/WebDocs.Circle_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_setParent"
													class="Circle_setParent"
													href="#webv2/docs/WebDocs.Circle_setParent">setParent</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_setRadius"
													class="Circle_setRadius"
													href="#webv2/docs/WebDocs.Circle_setRadius">setRadius</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_startEdit"
													class="Circle_startEdit"
													href="#webv2/docs/WebDocs.Circle_startEdit">startEdit</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_endEdit"
													class="Circle_endEdit"
													href="#webv2/docs/WebDocs.Circle_endEdit">endEdit</a></li>
												<li><a id="webv2_docs_WebDocs_Circle_isEditing"
													class="Circle_isEditing"
													href="#webv2/docs/WebDocs.Circle_isEditing">isEditing</a></li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Polyline"
												href="#webv2/docs/WebDocs.Polyline">Tmapv2.Polyline</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Polyline_create"
													class="Polyline_create"
													href="#webv2/docs/WebDocs.Polyline_create">create</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_draw"
													class="Polyline_draw"
													href="#webv2/docs/WebDocs.Polyline_draw">draw</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_setMap"
													class="Polyline_setMap"
													href="#webv2/docs/WebDocs.Polyline_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_setParent"
													class="Polyline_setParent"
													href="#webv2/docs/WebDocs.Polyline_setParent">setParent</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_setPath"
													class="Polyline_setPath"
													href="#webv2/docs/WebDocs.Polyline_setPath">setPath</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_startEdit"
													class="Polyline_startEdit"
													href="#webv2/docs/WebDocs.Polyline_startEdit">startEdit</a></li>
												<li><a id="webv2_docs_WebDocs_Polyline_endEdit"
													class="Polyline_endEdit"
													href="#webv2/docs/WebDocs.Polyline_endEdit">endEdit</a></li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_GroundOverlay"
												href="#webv2/docs/WebDocs.GroundOverlay">Tmapv2.GroundOverlay</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_GroundOverlay_create"
													class="GroundOverlay_create"
													href="#webv2/docs/WebDocs.GroundOverlay_create">create</a>
												</li>
												<li><a id="webv2_docs_WebDocs_GroundOverlay_draw"
													class="GroundOverlay_draw"
													href="#webv2/docs/WebDocs.GroundOverlay_draw">draw</a></li>
												<li><a id="webv2_docs_WebDocs_GroundOverlay_setMap"
													class="GroundOverlay_setMap"
													href="#webv2/docs/WebDocs.GroundOverlay_setMap">setMap</a>
												</li>
												<li><a id="webv2_docs_WebDocs_GroundOverlay_setParent"
													class="GroundOverlay_setParent"
													href="#webv2/docs/WebDocs.GroundOverlay_setParent">setParent</a>
												</li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Polygon"
												href="#webv2/docs/WebDocs.Polygon">Tmapv2.Polygon</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Polygon_create"
													class="Polygon_create"
													href="#webv2/docs/WebDocs.Polygon_create">create</a></li>
												<li><a id="webv2_docs_WebDocs_Polygon_draw"
													class="Polygon_draw"
													href="#webv2/docs/WebDocs.Polygon_draw">draw</a></li>
												<li><a id="webv2_docs_WebDocs_Polygon_setMap"
													class="Polygon_setMap"
													href="#webv2/docs/WebDocs.Polygon_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_Polygon_setParent"
													class="Polygon_setParent"
													href="#webv2/docs/WebDocs.Polygon_setParent">setParent</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Polygon_setPath"
													class="Polygon_setPath"
													href="#webv2/docs/WebDocs.Polygon_setPath">setPath</a></li>
												<li><a id="webv2_docs_WebDocs_Polygon_startEdit"
													class="Polygon_startEdit"
													href="#webv2/docs/WebDocs.Polygon_startEdit">startEdit</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Polygon_endEdit"
													class="Polygon_endEdit"
													href="#webv2/docs/WebDocs.Polygon_endEdit">endEdit</a></li>
												<li><a id="webv2_docs_WebDocs_Polygon_isEditing"
													class="Polygon_isEditing"
													href="#webv2/docs/WebDocs.Polygon_isEditing">isEditing</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Polygon_contains"
													class="Polygon_contains"
													href="#webv2/docs/WebDocs.Polygon_contains">contains</a></li>
											</ul></li>
										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Rectangle"
												href="#webv2/docs/WebDocs.Rectangle">Tmapv2.Rectangle</a></span>
											<ul style="display: none">
												<li><a id="webv2_docs_WebDocs_Rectangle_create"
													class="Rectangle_create"
													href="#webv2/docs/WebDocs.Rectangle_create">create</a></li>
												<li><a id="webv2_docs_WebDocs_Rectangle_draw"
													class="Rectangle_draw"
													href="#webv2/docs/WebDocs.Rectangle_draw">draw</a></li>
												<li><a id="webv2_docs_WebDocs_Rectangle_getBounds"
													class="Rectangle_getBounds"
													href="#webv2/docs/WebDocs.Rectangle_getBounds">getBounds</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Rectangle_setMap"
													class="Rectangle_setMap"
													href="#webv2/docs/WebDocs.Rectangle_setMap">setMap</a></li>
												<li><a id="webv2_docs_WebDocs_Rectangle_setParent"
													class="Rectangle_setParent"
													href="#webv2/docs/WebDocs.Rectangle_setParent">setParent</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Rectangle_startEdit"
													class="Rectangle_startEdit"
													href="#webv2/docs/WebDocs.Rectangle_startEdit">startEdit</a>
												</li>
												<li><a id="webv2_docs_WebDocs_Rectangle_endEdit"
													class="Rectangle_endEdit"
													href="#webv2/docs/WebDocs.Rectangle_endEdit">endEdit</a></li>
												<li><a id="webv2_docs_WebDocs_Rectangle_isEditing"
													class="Rectangle_isEditing"
													href="#webv2/docs/WebDocs.Rectangle_isEditing">isEditing</a>
												</li>
											</ul></li>

										<li><span class="Map"><a style="margin-left: 0px;"
												id="webv2_docs_WebDocs_Projection"
												href="#webv2/docs/WebDocs.Projection">Tmapv2.Projection</a></span>
											<ul style="display: none">
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertBesselTMToWGS84GEO"
													class="Projection_convertBesselTMToWGS84GEO"
													href="#webv2/docs/WebDocs.Projection_convertBesselTMToWGS84GEO">convertBesselTMToWGS84GEO</a>
												</li> -->
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertWGS84GEOToBesselTM"
													class="Projection_convertWGS84GEOToBesselTM"
													href="#webv2/docs/WebDocs.Projection_convertWGS84GEOToBesselTM">convertWGS84GEOToBesselTM</a>
												</li> -->
												<li><a
													id="webv2_docs_WebDocs_Projection_convertWGS84GEOToKatec"
													class="Projection_dconvertWGS84GEOToKatec"
													href="#webv2/docs/WebDocs.Projection_convertWGS84GEOToKatec">convertWGS84GEOToKatec</a>
												</li>
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertBesselGEOToWGS84GEO"
													class="Projection_convertBesselGEOToWGS84GEO"
													href="#webv2/docs/WebDocs.Projection_convertBesselGEOToWGS84GEO">convertBesselGEOToWGS84GEO</a>
												</li> -->
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertWGS84GEOToBesselGEO"
													class="Projection_convertWGS84GEOToBesselGEO"
													href="#webv2/docs/WebDocs.Projection_convertWGS84GEOToBesselGEO">convertWGS84GEOToBesselGEO</a>
												</li> -->
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertBesselTMToBesselGEO"
													class="Projection_convertBesselTMToBesselGEO"
													href="#webv2/docs/WebDocs.Projection_convertBesselTMToBesselGEO">convertBesselTMToBesselGEO</a>
												</li> -->
												<!-- <li><a
													id="webv2_docs_WebDocs_Projection_convertBesselGEOToBesselTM"
													class="Projection_convertBesselGEOToBesselTM"
													href="#webv2/docs/WebDocs.Projection_convertBesselGEOToBesselTM">convertBesselGEOToBesselTM</a>
												</li> -->
												<li><a
													id="webv2_docs_WebDocs_Projection_convertWGS84GEOToEPSG3857"
													class="Projection_convertWGS84GEOToEPSG3857"
													href="#webv2/docs/WebDocs.Projection_convertWGS84GEOToEPSG3857">convertWGS84GEOToEPSG3857</a>
												</li>
												<li><a
													id="webv2_docs_WebDocs_Projection_convertEPSG3857ToWGS84GEO"
													class="Projection_convertEPSG3857ToWGS84GEO"
													href="#webv2/docs/WebDocs.Projection_convertEPSG3857ToWGS84GEO">convertEPSG3857ToWGS84GEO</a>
												</li>

											</ul></li>

									</ul></li>

								<li id="usecase"><span class="">Use case</span>
									<ul style="display: none">
										<!-- style="display:none" -->
										<li><a id="webv2_usecase_UseCasePathSearch"
											href="#webv2/usecase/UseCasePathSearch">경로탐색 만들어 보기</a></li>
										<li><a id="webv2_usecase_UseCaseOptimization"
											href="#webv2/usecase/UseCaseOptimization">경유지 최적화 만들어 보기</a>
										</li>
										<li><a id="webv2_usecase_UseCasePositionControl"
											href="#webv2/usecase/UseCasePositionControl">위치관제 만들어 보기</a>
										</li>
									</ul></li>

							</ul></li>

						<li style="background: none"><span id="tit_Web"
							class="tit tit_ico_web">Web</span>
							<ul>
								<li><span>Guide</span>
									<ul style="display: none">
										<li><a id="web_guide_webGuide_sample3"
											href="#web/guide/webGuide.sample3">T map 시작하기</a></li>
										<li><a id="web_guide_webGuide_sample4"
											href="#web/guide/webGuide.sample4">T map 활용사례</a></li>
									</ul></li>



								<li><span class=""><a style="margin-left: 0px;"
										id="web_sample_TotalSample" href="#web/sample/TotalSample">Sample</a></span>
									<ul style="display: none">
										<li><span class="">기본기능</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample01"
													href="#web/sample/webSample01">지도 생성하기</a></li>
												<li><a id="web_sample_webSample02"
													href="#web/sample/webSample02">지도 영역 확인하기</a></li>
												<li><a id="web_sample_webSample02_2"
													href="#web/sample/webSample02_2">지도 설정하기</a></li>
												<li><a id="web_sample_webSample03"
													href="#web/sample/webSample03">지도 마우스로 이동하기</a></li>
												<li><a id="web_sample_webSample04"
													href="#web/sample/webSample04">지도 키보드로 이동하기</a></li>
												<li><a id="web_sample_webSample05"
													href="#web/sample/webSample05">지도 크기 비교하기</a></li>
												<li><a id="web_sample_webSample06"
													href="#web/sample/webSample06">지도 이동 막기</a></li>
												<li><a id="web_sample_webSample07"
													href="#web/sample/webSample07">지도 레벨 변경하기</a></li>
												<li><a id="web_sample_webSample08"
													href="#web/sample/webSample08">지도 확대축소 제어하기</a></li>
												<li><a id="web_sample_webSample09"
													href="#web/sample/webSample09">지도 확대축소 버튼 추가/제거하기(이미지는
														줌버튼이 없는 이미지)</a></li>
												<li><a id="web_sample_webSample10"
													href="#web/sample/webSample10">지도 정보 얻어오기</a></li>
												<li><a id="web_sample_webSample11"
													href="#web/sample/webSample11">좌표계 코드 확인</a></li>
												<li><a id="web_sample_webSample12"
													href="#web/sample/webSample12">지도상 마우스 좌표값 표시하기</a></li>
												<li><a id="web_sample_webSample13"
													href="#web/sample/webSample13">지도 미니맵 보기</a></li>
												<li><a id="web_sample_webSample14"
													href="#web/sample/webSample14">클릭한 위치의 좌표값 확인하기</a></li>
												<li><a id="web_sample_webSample16"
													href="#web/sample/webSample16">지도 캐시 초기화</a></li>
												<!-- <li><a id="web_sample_webSample18" href="#web/sample/webSample18">지도에 교통정보 표시하기</a></li> -->
												<li><a id="web_sample_webSample19"
													href="#web/sample/webSample19">지도상 두 지점간의 거리 계산하기</a></li>
												<li><a id="web_sample_webSample24"
													href="#web/sample/webSample24">팝업 생성하기</a></li>
												<li><a id="web_sample_webSample25"
													href="#web/sample/webSample25">팝업 사이즈 확인하기</a></li>
												<li><a id="web_sample_webSample33"
													href="#web/sample/webSample33">원,선,사각형,다각형 그리기</a></li>
												<li><a id="web_sample_webSample34"
													href="#web/sample/webSample34">선의 거리 계산하기</a></li>
												<li><a id="web_sample_webSample35"
													href="#web/sample/webSample35">레이어 제어하기</a></li>
												<li><a id="web_sample_webSample36"
													href="#web/sample/webSample36">Polygon 면적 계산하기</a></li>
												<li><a id="web_sample_webSample37"
													href="#web/sample/webSample37">Circle 면적 계산하기</a></li>
												<li><a id="web_sample_webSample38"
													href="#web/sample/webSample38">다각형의 면적 계산하기</a></li>
												<li><a id="web_sample_webSample40"
													href="#web/sample/webSample40">커스텀 오버레이 사용하기</a></li>
												<li><a id="web_sample_webSample55"
													href="#web/sample/webSample55">Label 팝업 스타일 적용하기</a></li>
												<li><a id="web_sample_webSample56"
													href="#web/sample/webSample56">팝업 스타일 적용하기</a></li>
												<li><a id="web_sample_webSample41"
													href="#web/sample/webSample41">좌표변환하기</a></li>
												<li><a id="web_sample_webSample42"
													href="#web/sample/webSample42">지리정보 객체 가져오기</a></li>
												<li><a id="web_sample_webSample43"
													href="#web/sample/webSample43">Collection 객체 사용하기</a></li>
												<li><a id="web_sample_webSample50"
													href="#web/sample/webSample50">페이징 처리 사용하기</a></li>
												<li><a id="web_sample_webSample54"
													href="#web/sample/webSample54">Toolbox 사용하기</a></li>
											</ul></li>

										<li><span class="">마커</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample20"
													href="#web/sample/webSample20">마커 생성하기</a></li>
												<li><a id="web_sample_webSample21"
													href="#web/sample/webSample21">마커 표출여부 확인하기</a></li>
												<li><a id="web_sample_webSample22"
													href="#web/sample/webSample22">마커 이동하기</a></li>
												<li><a id="web_sample_webSample23"
													href="#web/sample/webSample23">마커 이미지 변경하기</a></li>
												<li><a id="web_sample_webSample15"
													href="#web/sample/webSample15">클릭한 위치에 마커 생성하기</a></li>
												<li><a id="web_sample_webSample28"
													href="#web/sample/webSample28">GeoLocation으로 마커 표시하기</a></li>
												<li><a id="web_sample_webSample29"
													href="#web/sample/webSample29">다중 마커 생성하기</a></li>
												<li><a id="web_sample_webSample57"
													href="#web/sample/webSample57">다중 마커 라벨 생성하기</a></li>
												<li><a id="web_sample_webSample30"
													href="#web/sample/webSample30">다중 마커 제어하기</a></li>
												<li><a id="web_sample_webSample32"
													href="#web/sample/webSample32">다양한 마커 이미지 표시하기</a></li>
												<li><a id="web_sample_webSample49"
													href="#web/sample/webSample49">마커 클러스터러 사용하기</a></li>
											</ul></li>

										<li><span class="">이벤트</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample17"
													href="#web/sample/webSample17">지도에 이벤트 등록하기</a></li>
												<li><a id="web_sample_webSample39"
													href="#web/sample/webSample39">다각형에 이벤트 등록하기</a></li>
												<li><a id="web_sample_webSample27"
													href="#web/sample/webSample27">마커에 마우스 이벤트 등록하기</a></li>
												<li><a id="web_sample_webSample26"
													href="#web/sample/webSample26">마커에 클릭 이벤트 등록하기</a></li>
												<li><a id="web_sample_webSample31"
													href="#web/sample/webSample31">다중 마커에 이벤트 등록</a></li>
											</ul></li>

										<li><span class="">TData</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample51"
													href="#web/sample/webSample51">마커 생성하기</a></li>
												<li><a id="web_sample_webSample52"
													href="#web/sample/webSample52">경로탐색 사용하기</a></li>
												<li><a id="web_sample_webSample58"
													href="#web/sample/webSample58">경로탐색(교통정보 포함) 사용하기</a></li>
												<li><a id="web_sample_webSample53"
													href="#web/sample/webSample53">명칭을 좌표로 변환하기</a></li>
												<li><a id="web_sample_webSample44"
													href="#web/sample/webSample44">키워드로 장소검색하기</a></li>
												<li><a id="web_sample_webSample46"
													href="#web/sample/webSample46">카테고리로 장소 검색하기</a></li>
											</ul></li>

										<li><span class="">Open API</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample48"
													href="#web/sample/webSample48">데이터를 지도에 사용하기</a></li>
												<li><a id="web_sample_webSample45"
													href="#web/sample/webSample45">키워드로 장소검색후 목록으로 표출하기</a></li>
												<li><a id="web_sample_webSample47"
													href="#web/sample/webSample47">카테고리별 장소 검색하기</a></li>
											</ul></li>

										<li><span class="">Tmap Invoke</span>
											<ul style="display: none">
												<li><a id="web_sample_webSample59"
													href="#web/sample/webSample59">TmapApp 실행하기</a></li>
												<li><a id="web_sample_webSample60"
													href="#web/sample/webSample60">지도보기</a></li>
												<li><a id="web_sample_webSample61"
													href="#web/sample/webSample61">길안내</a></li>
												<li><a id="web_sample_webSample62"
													href="#web/sample/webSample62">POI 통합검색</a></li>
											</ul></li>
									</ul></li>

								<li><span class="">Docs</span>
									<ul style="display: none">
										<li><span class="Map"><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Map"
												href="#web/docs/WebDocs.Tmap_Map">Tmap.Map</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Map_destroy"
													class="Map_destroy" href="#web/docs/WebDocs.Map_destroy">destroy</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_addLayer"
													class="Map_addLayer" class="mLink"
													href="#web/docs/WebDocs.Map_addLayer">addLayer</a></li>
												<li><a id="web_docs_WebDocs_Map_addLayers"
													class="Map_addLayers"
													href="#web/docs/WebDocs.Map_addLayers">addLayers</a></li>
												<li><a id="web_docs_WebDocs_Map_removeLayer"
													class="Map_removeLayer"
													href="#web/docs/WebDocs.Map_removeLayer">removeLayer</a></li>
												<li><a id="web_docs_WebDocs_Map_getSize"
													class="Map_getSize" href="#web/docs/WebDocs.Map_getSize">getSize</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getCenter"
													class="Map_getCenter"
													href="#web/docs/WebDocs.Map_getCenter">getCenter</a></li>
												<li><a id="web_docs_WebDocs_Map_getZoom"
													class="Map_getZoom" href="#web/docs/WebDocs.Map_getZoom">getZoom</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_setCenter"
													class="Map_setCenter"
													href="#web/docs/WebDocs.Map_setCenter">setCenter</a></li>
												<li><a id="web_docs_WebDocs_Map_getMaxExtent"
													class="Map_getMaxExtent"
													href="#web/docs/WebDocs.Map_getMaxExtent">getMaxExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getNumZoomLevels"
													class="Map_getNumZoomLevels"
													href="#web/docs/WebDocs.Map_getNumZoomLevels">getNumZoomLevels</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getExtent"
													class="Map_getExtent"
													href="#web/docs/WebDocs.Map_getExtent">getExtent</a></li>
												<li><a id="web_docs_WebDocs_Map_zoomTo"
													class="Map_zoomTo" href="#web/docs/WebDocs.Map_zoomTo">zoomTo</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_zoomIn"
													class="Map_zoomIn" href="#web/docs/WebDocs.Map_zoomIn">zoomIn</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_zoomOut"
													class="Map_zoomOut" href="#web/docs/WebDocs.Map_zoomOut">zoomOut</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_zoomToExtent"
													class="Map_zoomToExtent"
													href="#web/docs/WebDocs.Map_zoomToExtent">zoomToExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_zoomToMaxExtent"
													class="Map_zoomToMaxExtent"
													href="#web/docs/WebDocs.Map_zoomToMaxExtent">zoomToMaxExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_addControl"
													class="Map_addControl"
													href="#web/docs/WebDocs.Map_addControl">addControl</a></li>
												<li><a id="web_docs_WebDocs_Map_addControls"
													class="Map_addControls"
													href="#web/docs/WebDocs.Map_addControls">addControls</a></li>
												<li><a id="web_docs_WebDocs_Map_removeControl"
													class="Map_removeControl"
													href="#web/docs/WebDocs.Map_removeControl">removeControl</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_addPopup"
													class="Map_addPopup" href="#web/docs/WebDocs.Map_addPopup">addPopup</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_removePopup"
													class="Map_removePopup"
													href="#web/docs/WebDocs.Map_removePopup">removePopup</a></li>
												<li><a id="web_docs_WebDocs_Map_removeAllPopup"
													class="Map_removeAllPopup"
													href="#web/docs/WebDocs.Map_removeAllPopup">removeAllPopup</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_pan" class="Map_pan"
													href="#web/docs/WebDocs.Map_pan">pan</a></li>
												<li><a id="web_docs_WebDocs_Map_panTo"
													class="Map_panTo" href="#web/docs/WebDocs.Map_panTo">panTo</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getNumLayers"
													class="Map_getNumLayers"
													href="#web/docs/WebDocs.Map_getNumLayers">getNumLayers</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getLayerIndex"
													class="Map_getLayerIndex"
													href="#web/docs/WebDocs.Map_getLayerIndex">getLayerIndex</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_setLayerIndex"
													class="Map_setLayerIndex"
													href="#web/docs/WebDocs.Map_setLayerIndex">setLayerIndex</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getScale"
													class="Map_getScale" href="#web/docs/WebDocs.Map_getScale">getScale</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getResolution"
													class="Map_getResolution"
													href="#web/docs/WebDocs.Map_getResolution">getResolution</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_disableZoomWheel"
													class="Map_disableZoomWheel"
													href="#web/docs/WebDocs.Map_disableZoomWheel">disableZoomWheel</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_enableZoomWheel"
													class="Map_enableZoomWheel"
													href="#web/docs/WebDocs.Map_enableZoomWheel">enableZoomWheel</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_zoomToScale"
													class="Map_zoomToScale"
													href="#web/docs/WebDocs.Map_zoomToScale">zoomToScale</a></li>
												<li><a id="web_docs_WebDocs_Map_getPixelFromLonLat"
													class="Map_getPixelFromLonLat"
													href="#web/docs/WebDocs.Map_getPixelFromLonLat">getPixelFromLonLat</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_getLonLatFromPixel"
													class="Map_getLonLatFromPixel"
													href="#web/docs/WebDocs.Map_getLonLatFromPixel">getLonLatFromPixel</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_updateSize"
													class="Map_updateSize"
													href="#web/docs/WebDocs.Map_updateSize">updateSize</a></li>
												<li><a id="web_docs_WebDocs_Map_addZoomControl"
													class="Map_addZoomControl"
													href="#web/docs/WebDocs.Map_addZoomControl">addZoomControl</a>
												</li>
												<li><a id="web_docs_WebDocs_Map_removeZoomControl"
													class="Map_removeZoomControl"
													href="#web/docs/WebDocs.Map_removeZoomControl">removeZoomControl</a>
												</li>
												<!-- 
												<li>
													<a id="web_docs_WebDocs_Map_setLanguage" class="Map_setLanguage" href="#web/docs/WebDocs.Map_setLanguage">setLanguage</a>
												</li>
												<li>
													<a id="web_docs_WebDocs_Map_setContrast" class="Map_setContrast" href="#web/docs/WebDocs.Map_setContrast">setContrast</a>
												</li>
												 -->
											</ul></li>
										<li><span class="Bounds"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Bounds"
												href="#web/docs/WebDocs.Tmap_Bounds">Tmap.Bounds</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Bounds_toString"
													class="Bounds_toString"
													href="#web/docs/WebDocs.Bounds_toString">toString</a></li>
												<li><a id="web_docs_WebDocs_Bounds_getWidth"
													class="Bounds_getWidth"
													href="#web/docs/WebDocs.Bounds_getWidth">getWidth</a></li>
												<li><a id="web_docs_WebDocs_Bounds_getHeight"
													class="Bounds_getHeight"
													href="#web/docs/WebDocs.Bounds_getHeight">getHeight</a></li>
												<li><a id="web_docs_WebDocs_Bounds_getSize"
													class="Bounds_getSize"
													href="#web/docs/WebDocs.Bounds_getSize">getSize</a></li>
												<li><a id="web_docs_WebDocs_Bounds_getCenterPixel"
													class="Bounds_getCenterPixel"
													href="#web/docs/WebDocs.Bounds_getCenterPixel">getCenterPixel</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_getCenterLonLat"
													class="Bounds_getCenterLonLat"
													href="#web/docs/WebDocs.Bounds_getCenterLonLat">getCenterLonLat</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_extend"
													class="Bounds_extend"
													href="#web/docs/WebDocs.Bounds_extend">extend</a></li>
												<li><a id="web_docs_WebDocs_Bounds_isEmpty"
													class="Bounds_isEmpty"
													href="#web/docs/WebDocs.Bounds_isEmpty">isEmpty</a></li>
												<li><a id="web_docs_WebDocs_Bounds_containsLonLat"
													class="Bounds_containsLonLat"
													href="#web/docs/WebDocs.Bounds_containsLonLat">containsLonLat</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_containsPixel"
													class="Bounds_containsPixel"
													href="#web/docs/WebDocs.Bounds_containsPixel">containsPixel</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_intersectsBounds"
													class="Bounds_intersectsBounds"
													href="#web/docs/WebDocs.Bounds_intersectsBounds">intersectsbounds</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_containsBounds"
													class="Bounds_containsBounds"
													href="#web/docs/WebDocs.Bounds_containsBounds">containsbounds</a>
												</li>
												<li><a id="web_docs_WebDocs_Bounds_contains"
													class="Bounds_contains"
													href="#web/docs/WebDocs.Bounds_contains">contains</a></li>
											</ul></li>
										<li><span class="LonLat"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_LonLat"
												href="#web/docs/WebDocs.Tmap_LonLat">Tmap.LonLat</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_LonLat_toString"
													class="LonLat_toString"
													href="#web/docs/WebDocs.LonLat_toString">toString</a></li>
												<li><a id="web_docs_WebDocs_LonLat_equals"
													class="LonLat_equals"
													href="#web/docs/WebDocs.LonLat_equals">equals</a></li>
												<li><a id="web_docs_WebDocs_LonLat_transform"
													class="LonLat_transform"
													href="#web/docs/WebDocs.LonLat_transform">transform</a></li>
												<li><a id="web_docs_WebDocs_LonLat_toShortString"
													class="LonLat_toShortString"
													href="#web/docs/WebDocs.LonLat_toShortString">toShortString</a>
												</li>
												<li><a id="web_docs_WebDocs_LonLat_clone"
													class="LonLat_clone" href="#web/docs/WebDocs.LonLat_clone">clone</a>
												</li>
												<li><a id="web_docs_WebDocs_LonLat_add"
													class="LonLat_add" href="#web/docs/WebDocs.LonLat_add">add</a>
												</li>
											</ul></li>
										<li><span class="Pixel"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Pixel"
												href="#web/docs/WebDocs.Tmap_Pixel">Tmap.Pixel</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Pixel_equals"
													class="Pixel_equals" href="#web/docs/WebDocs.Pixel_equals">equals</a>
												</li>
												<li><a id="web_docs_WebDocs_Pixel_distanceTo"
													class="Pixel_distanceTo"
													href="#web/docs/WebDocs.Pixel_distanceTo">distanceTo</a></li>
												<li><a id="web_docs_WebDocs_Pixel_toString"
													class="Pixel_toString"
													href="#web/docs/WebDocs.Pixel_toString">toString</a></li>
												<li><a id="web_docs_WebDocs_Pixel_clone"
													class="Pixel_clone" href="#web/docs/WebDocs.Pixel_clone">clone</a>
												</li>
												<li><a id="web_docs_WebDocs_Pixel_add"
													class="Pixel_add" href="#web/docs/WebDocs.Pixel_add">add</a>
												</li>
												<li><a id="web_docs_WebDocs_Pixel_offset"
													class="Pixel_offset" href="#web/docs/WebDocs.Pixel_offset">offset</a>
												</li>
											</ul></li>
										<li><span class="Size"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Size"
												href="#web/docs/WebDocs.Tmap_Size">Tmap.Size</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Size_equals"
													class="Size_equals" href="#web/docs/WebDocs.Size_equals">equals</a>
												</li>
												<li><a id="web_docs_WebDocs_Size_clone"
													class="Size_clone" href="#web/docs/WebDocs.Size_clone">clone</a>
												</li>
											</ul></li>
										<li><span class="Events"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Events"
												href="#web/docs/WebDocs.Tmap_Events">Tmap.Events</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Events_destroy"
													class="Events_destroy"
													href="#web/docs/WebDocs.Events_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Events_addEventType"
													class="Events_addEventType"
													href="#web/docs/WebDocs.Events_addEventType">addEventType</a>
												</li>
												<li><a id="web_docs_WebDocs_Events_register"
													class="Events_register"
													href="#web/docs/WebDocs.Events_register">register</a></li>
												<li><a id="web_docs_WebDocs_Events_unregister"
													class="Events_unregister"
													href="#web/docs/WebDocs.Events_unregister">unregister</a></li>
												<li><a id="web_docs_WebDocs_Events_triggerEvent"
													class="Events_triggerEvent"
													href="#web/docs/WebDocs.Events_triggerEvent">triggerEvent</a>
												</li>
												<li><a id="web_docs_WebDocs_Events_clearMouseCache"
													class="Events_clearMouseCache"
													href="#web/docs/WebDocs.Events_clearMouseCache">clearMouseCache</a>
												</li>
											</ul></li>
										<li><span class="Projection"><a
												style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Projection"
												href="#web/docs/WebDocs.Tmap_Projection">Tmap.Projection</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Projection_getCode"
													class="Projection_getCode"
													href="#web/docs/WebDocs.Projection_getCode">getCode</a></li>
												<li><a id="web_docs_WebDocs_Projection_transform"
													class="Projection_transform"
													href="#web/docs/WebDocs.Projection_transform">transform</a>
												</li>
												<li><a
													id="web_docs_WebDocs_Projection_convertBesselToWgs84"
													class="Projection_convertBesselToWgs84"
													href="#web/docs/WebDocs.Projection_convertBesselToWgs84">convertBesselToWgs84</a>
												</li>
											</ul></li>
										<li><span class="Marker"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Marker"
												href="#web/docs/WebDocs.Tmap_Marker">Tmap.Marker</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Marker_destroy"
													class="Marker_destroy"
													href="#web/docs/WebDocs.Marker_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Marker_isDrawn"
													class="Marker_isDrawn"
													href="#web/docs/WebDocs.Marker_isDrawn">isDrawn</a></li>
											</ul></li>
										<li><span class="Markers"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Markers"
												href="#web/docs/WebDocs.Tmap_Markers">Tmap.Markers</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Markers_destroy"
													class="Markers_destroy"
													href="#web/docs/WebDocs.Markers_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Markers_isDrawn"
													class="Markers_isDrawn"
													href="#web/docs/WebDocs.Markers_isDrawn">isDrawn</a></li>
											</ul></li>
										<li><span class="Popup"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Popup"
												href="#web/docs/WebDocs.Tmap_Popup">Tmap.Popup</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Popup_updateSize"
													class="Popup_updateSize"
													href="#web/docs/WebDocs.Popup_updateSize">updateSize</a></li>
												<li><a id="web_docs_WebDocs_Popup_getSafeContentSize"
													class="Popup_getSafeContentSize"
													href="#web/docs/WebDocs.Popup_getSafeContentSize">getSafeContentSize</a>
												</li>
											</ul></li>
										<li><span class="Icon"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Icon"
												href="#web/docs/WebDocs.Tmap_Icon">Tmap.Icon</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Icon_isDrawn"
													class="Icon_isDrawn" href="#web/docs/WebDocs.Icon_isDrawn">isDrawn</a>
												</li>
											</ul></li>
										<li><span class="IconHtml"><a
												style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_IconHtml"
												href="#web/docs/WebDocs.Tmap_IconHtml">Tmap.IconHtml</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_IconHtml_isDrawn"
													class="IconHtml_isDrawn"
													href="#web/docs/WebDocs.IconHtml_isDrawn">isDrawn</a></li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Label"
											class="Tmap_Label" href="#web/docs/WebDocs.Tmap_Label">
												Tmap.Label </a></li>
										<li><span class="Cluster"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Cluster"
												href="#web/docs/WebDocs.Tmap_Cluster">Tmap.Cluster</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Cluster_Marker"
													class="Cluster_Marker"
													href="#web/docs/WebDocs.Cluster_Marker">Tmap.Cluster.Marker</a>
												</li>
												<li><a id="web_docs_WebDocs_Cluster_Layer"
													class="Cluster_Layer"
													href="#web/docs/WebDocs.Cluster_Layer">Tmap.Cluster.Layer</a>
												</li>
												<li><a id="web_docs_WebDocs_Cluster_Icon"
													class="Cluster_Icon" href="#web/docs/WebDocs.Cluster_Icon">Tmap.Cluster.Icon</a>
												</li>
												<li><a id="web_docs_WebDocs_Cluster_Clear"
													class="Cluster_Clear"
													href="#web/docs/WebDocs.Cluster_Clear">clear</a></li>
											</ul></li>
										<li><span class="Control"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Control"
												href="#web/docs/WebDocs.Tmap_Control">Tmap.Control</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Control_activate"
													class="Control_activate"
													href="#web/docs/WebDocs.Control_activate">activate</a></li>
												<li><a id="web_docs_WebDocs_Control_deactivate"
													class="Control_deactivate"
													href="#web/docs/WebDocs.Control_deactivate">deactivate</a>
												</li>
												<li><a id="web_docs_WebDocs_Control_displayProjection"
													class="Control_displayProjection"
													href="#web/docs/WebDocs.Control_displayProjection">displayProjection</a>
												</li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Control_EditingToolbar"
											class="Tmap_Control_EditingToolbar"
											href="#web/docs/WebDocs.Tmap_Control_EditingToolbar">
												Tmap.Control.EditingToolbar </a></li>
										<li><a
											id="web_docs_WebDocs_Tmap_Control_KeyboardDefaults"
											class="Tmap_Control_KeyboardDefaults"
											href="#web/docs/WebDocs.Tmap_Control_KeyboardDefaults">
												Tmap.Control.KeyboardDefaults </a></li>
										<li><span class="OverviewMap"><a
												style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_OverviewMap"
												href="#web/docs/WebDocs.Tmap_OverviewMap">Tmap.Control.OverviewMap</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_OverviewMap_destroy"
													class="OverviewMap_destroy"
													href="#web/docs/WebDocs.OverviewMap_destroy">destroy</a></li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Control_ZoomBox"
											class="Tmap.Control.ZoomBox"
											href="#web/docs/WebDocs.Tmap_Control_ZoomBox">
												Tmap.Control.ZoomBox </a></li>
										<!-- 								<li> -->
										<!-- 									<span class="Space">Tmap.Control.Space</span> -->
										<!-- 									<ul style="display:none"> -->
										<!-- 										<li> -->
										<!-- 											<a id="web_docs_WebDocs_" class="Space_activate" href="#web/docs/WebDocs.Space_activate">activate</a> -->
										<!-- 										</li> -->
										<!-- 										<li> -->
										<!-- 											<a id="web_docs_WebDocs_" class="Space_deactivate" href="#web/docs/WebDocs.Space_deactivate">deactivate</a> -->
										<!-- 										</li> -->
										<!-- 									</ul> -->
										<!-- 								</li> -->
										<!-- 								<li> -->
										<!-- 									<a  href="#web/docs/WebDocs.Tmap_Control_ReverseLabel"> -->
										<!-- 										<span class="ReverseLabel">Tmap.Control.ReverseLabel</span> -->
										<!-- 									</a> -->
										<!-- 								</li> -->
										<li><a id="web_docs_WebDocs_Tmap_Feature_Vector"
											class="Tmap_Feature_Vector"
											href="#web/docs/WebDocs.Tmap_Feature_Vector">
												Tmap.Feature.Vector </a></li>
										<li><span class="Layer"><a
												style="margin-left: 0px;" id="web_docs_WebDocs_Tmap_Layer"
												href="#web/docs/WebDocs.Tmap_Layer">Tmap.Layer</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Layer_setName"
													class="Layer_setName"
													href="#web/docs/WebDocs.Layer_setName">setName</a></li>
												<li><a id="web_docs_WebDocs_Layer_addoptions"
													class="Layer_addoptions"
													href="#web/docs/WebDocs.Layer_addoptions">addoptions</a></li>
												<li><a id="web_docs_WebDocs_Layer_onMapResize"
													class="Layer_onMapResize"
													href="#web/docs/WebDocs.Layer_onMapResize">onMapResize</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_redraw"
													class="Layer_redraw" href="#web/docs/WebDocs.Layer_redraw">redraw</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_getVisibility"
													class="Layer_getVisibility"
													href="#web/docs/WebDocs.Layer_getVisibility">getVisibility</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_setVisibility"
													class="Layer_setVisibility"
													href="#web/docs/WebDocs.Layer_setVisibility">setVisibility</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_getResolution"
													class="Layer_getResolution"
													href="#web/docs/WebDocs.Layer_getResolution">getResolution</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_getExtent"
													class="Layer_getExtent"
													href="#web/docs/WebDocs.Layer_getExtent">getExtent</a></li>
												<li><a id="web_docs_WebDocs_Layer_getZoomForExtent"
													class="Layer_getZoomForExtent"
													href="#web/docs/WebDocs.Layer_getZoomForExtent">getZoomForExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_setOpacity"
													class="Layer_setOpacity"
													href="#web/docs/WebDocs.Layer_setOpacity">setOpacity</a></li>
												<li><a id="web_docs_WebDocs_Layer_getResolutionForZoom"
													class="Layer_getResolutionForZoom"
													href="#web/docs/WebDocs.Layer_getResolutionForZoom">getResolutionForZoom</a>
												</li>
												<li><a id="web_docs_WebDocs_Layer_getZoomForResolution"
													class="Layer_getZoomForResolution"
													href="#web/docs/WebDocs.Layer_getZoomForResolution">getZoomForResolution</a>
												</li>
											</ul></li>
										<li><span class="Tmap_Layer_Vector"><a
												style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Layer_Vector"
												href="#web/docs/WebDocs.Tmap_Layer_Vector">Tmap.Layer.Vector</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Vector_destroy"
													class="Vector_destroy"
													href="#web/docs/WebDocs.Vector_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Vector_display"
													class="Vector_display"
													href="#web/docs/WebDocs.Vector_display">display</a></li>
												<li><a id="web_docs_WebDocs_Vector_addFeatures"
													class="Vector_addFeatures"
													href="#web/docs/WebDocs.Vector_addFeatures">addFeatures</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_removeFeatures"
													class="Vector_removeFeatures"
													href="#web/docs/WebDocs.Vector_removeFeatures">removeFeatures</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_removeAllFeatures"
													class="Vector_removeAllFeatures"
													href="#web/docs/WebDocs.Vector_removeAllFeatures">removeAllFeatures</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_destroyFeatures"
													class="Vector_destroyFeatures"
													href="#web/docs/WebDocs.Vector_destroyFeatures">destroyFeatures</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_drawFeature"
													class="Vector_drawFeature"
													href="#web/docs/WebDocs.Vector_drawFeature">drawFeature</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_getDataExtent"
													class="Vector_getDataExtent"
													href="#web/docs/WebDocs.Vector_getDataExtent">getDataExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_getFeatureBy"
													class="Vector_getFeatureBy"
													href="#web/docs/WebDocs.Vector_getFeatureBy">getFeatureBy</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_getFeatureById"
													class="Vector_getFeatureById"
													href="#web/docs/WebDocs.Vector_getFeatureById">getFeatureById</a>
												</li>
												<li><a
													id="web_docs_WebDocs_Vector_getFeaturesByAttribute"
													class="Vector_getFeaturesByAttribute"
													href="#web/docs/WebDocs.Vector_getFeaturesByAttribute">getFeaturesByAttribute</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_onFeatureInsert"
													class="Vector_onFeatureInsert"
													href="#web/docs/WebDocs.Vector_onFeatureInsert">onFeatureInsert</a>
												</li>
												<li><a id="web_docs_WebDocs_Vector_preFeatureInsert"
													class="Vector_preFeatureInsert"
													href="#web/docs/WebDocs.Vector_preFeatureInsert">preFeatureInsert</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Layer_Markers"
												href="#web/docs/WebDocs.Tmap_Layer_Markers">Tmap.Layer.Markers</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Markers_destroy2"
													class="Markers_destroy2"
													href="#web/docs/WebDocs.Markers_destroy2">destroy</a></li>
												<li><a id="web_docs_WebDocs_Markers_addMarker"
													class="Markers_addMarker"
													href="#web/docs/WebDocs.Markers_addMarker">addMarker</a></li>
												<li><a id="web_docs_WebDocs_Markers_removeMarker"
													class="Markers_removeMarker"
													href="#web/docs/WebDocs.Markers_removeMarker">removeMarker</a>
												</li>
												<li><a id="web_docs_WebDocs_Markers_getDataExtent"
													class="Markers_getDataExtent"
													href="#web/docs/WebDocs.Markers_getDataExtent">getDataExtent</a>
												</li>
												<li><a id="web_docs_WebDocs_Markers_clearMarkers"
													class="Markers_clearMarkers"
													href="#web/docs/WebDocs.Markers_clearMarkers">clearMarkers</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry"
												href="#web/docs/WebDocs.Tmap_Geometry">Tmap.Geometry</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Geometry_getBounds"
													class="Geometry_getBounds"
													href="#web/docs/WebDocs.Geometry_getBounds">getBounds</a></li>
												<li><a id="web_docs_WebDocs_Geometry_calculateBounds"
													class="Geometry_calculateBounds"
													href="#web/docs/WebDocs.Geometry_calculateBounds">calculateBounds</a>
												</li>
												<li><a id="web_docs_WebDocs_Geometry_getVertices"
													class="Geometry_getVertices"
													href="#web/docs/WebDocs.Geometry_getVertices">getVertices</a>
												</li>
												<li><a id="web_docs_WebDocs_Geometry_getCentroid"
													class="Geometry_getCentroid"
													href="#web/docs/WebDocs.Geometry_getCentroid">getCentroid</a>
												</li>
												<li><a id="web_docs_WebDocs_Geometry_clone"
													class="Geometry_clone"
													href="#web/docs/WebDocs.Geometry_clone">clone</a></li>
												<li><a id="web_docs_WebDocs_Geometry_distanceTo"
													class="Geometry_distanceTo"
													href="#web/docs/WebDocs.Geometry_distanceTo">distanceTo</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_Point"
												href="#web/docs/WebDocs.Tmap_Geometry_Point">Tmap.Geometry.Point</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Point_equals"
													class="Point_equals" href="#web/docs/WebDocs.Point_equals">equals</a>
												</li>
												<li><a id="web_docs_WebDocs_Point_move"
													class="Point_move" href="#web/docs/WebDocs.Point_move">move</a>
												</li>
												<li><a id="web_docs_WebDocs_Point_rotate"
													class="Point_rotate" href="#web/docs/WebDocs.Point_rotate">rotate</a>
												</li>
												<li><a id="web_docs_WebDocs_Point_getVertices"
													class="Point_getVertices"
													href="#web/docs/WebDocs.Point_getVertices">getVertices</a>
												</li>
												<li><a id="web_docs_WebDocs_Point_clone"
													class="Point_clone" href="#web/docs/WebDocs.Point_clone">clone</a>
												</li>
												<li><a id="web_docs_WebDocs_Point_distanceTo"
													class="Point_distanceTo"
													href="#web/docs/WebDocs.Point_distanceTo">distanceTo</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_LineString"
												href="#web/docs/WebDocs.Tmap_Geometry_LineString">Tmap.Geometry.LineString</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_LineString_removeComponent"
													class="LineString_removeComponent"
													href="#web/docs/WebDocs.LineString_removeComponent">removeComponent</a>
												</li>
												<li><a id="web_docs_WebDocs_LineString_getVertices"
													class="LineString_getVertices"
													href="#web/docs/WebDocs.LineString_getVertices">getVertices</a>
												</li>
												<li><a id="web_docs_WebDocs_LineString_simplify"
													class="LineString_simplify"
													href="#web/docs/WebDocs.LineString_simplify">simplify</a></li>
												<li><a id="web_docs_WebDocs_LineString_distanceTo"
													class="LineString_distanceTo"
													href="#web/docs/WebDocs.LineString_distanceTo">distanceTo</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_LinearRing"
												href="#web/docs/WebDocs.Tmap_Geometry_LinearRing">Tmap.Geometry.LinearRing</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_LinearRing_addComponent"
													class="LinearRing_addComponent"
													href="#web/docs/WebDocs.LinearRing_addComponent">addComponent</a>
												</li>
												<li><a id="web_docs_WebDocs_LinearRing_removeComponent"
													class="LinearRing_removeComponent"
													href="#web/docs/WebDocs.LinearRing_removeComponent">removeComponent</a>
												</li>
												<li><a id="web_docs_WebDocs_LinearRing_move"
													class="LinearRing_move"
													href="#web/docs/WebDocs.LinearRing_move">move</a></li>
												<li><a id="web_docs_WebDocs_LinearRing_getArea"
													class="LinearRing_getArea"
													href="#web/docs/WebDocs.LinearRing_getArea">getArea</a></li>
												<li><a id="web_docs_WebDocs_LinearRing_getVertices"
													class="LinearRing_getVertices"
													href="#web/docs/WebDocs.LinearRing_getVertices">getVertices</a>
												</li>
												<li><a id="web_docs_WebDocs_LinearRing_rotate"
													class="LinearRing_rotate"
													href="#web/docs/WebDocs.LinearRing_rotate">rotate</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_Polygon"
												href="#web/docs/WebDocs.Tmap_Geometry_Polygon">Tmap.Geometry.Polygon</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Polygon_getArea"
													class="Polygon_getArea"
													href="#web/docs/WebDocs.Polygon_getArea">getArea</a></li>
												<li><a
													id="web_docs_WebDocs_Polygon_createRegularPolygon"
													class="Polygon_createRegularPolygon"
													href="#web/docs/WebDocs.Polygon_createRegularPolygon">createRegularPolygon</a>
												</li>
												<li><a id="web_docs_WebDocs_Polygon_distanceTo"
													class="Polygon_distanceTo"
													href="#web/docs/WebDocs.Polygon_distanceTo">distanceTo</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_Circle"
												href="#web/docs/WebDocs.Tmap_Geometry_Circle">Tmap.Geometry.Circle</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Circle_getArea"
													class="Circle_getArea"
													href="#web/docs/WebDocs.Circle_getArea">getArea</a></li>
												<li><a id="web_docs_WebDocs_Circle_distanceTo"
													class="Circle_distanceTo"
													href="#web/docs/WebDocs.Circle_distanceTo">distanceTo</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Control_MousePosition"
												href="#web/docs/WebDocs.Tmap_Control_MousePosition">Tmap.Control.MousePosition</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_MousePosition_activate"
													class="MousePosition_activate"
													href="#web/docs/WebDocs.MousePosition_activate">activate</a>
												</li>
												<li><a id="web_docs_WebDocs_MousePosition_deactivate"
													class="MousePosition_deactivate"
													href="#web/docs/WebDocs.MousePosition_deactivate">deactivate</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Control_SelectFeature"
												href="#web/docs/WebDocs.Tmap_Control_SelectFeature">Tmap.Control.SelectFeature</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_SelectFeature_setLayer"
													class="SelectFeature_setLayer"
													href="#web/docs/WebDocs.SelectFeature_setLayer">setLayer</a>
												</li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Control_Button"
											class="Tmap_Control_Button"
											href="#web/docs/WebDocs.Tmap_Control_Button">
												Tmap.Control.Button </a></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Control_Panel"
												href="#web/docs/WebDocs.Tmap_Control_Panel">Tmap.Control.Panel</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Panel_destroy"
													class="Panel_destroy"
													href="#web/docs/WebDocs.Panel_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Panel_activate"
													class="Panel_activate"
													href="#web/docs/WebDocs.Panel_activate">activate</a></li>
												<li><a id="web_docs_WebDocs_Panel_deactivate"
													class="Panel_deactivate"
													href="#web/docs/WebDocs.Panel_deactivate">deactivate</a></li>
												<li><a id="web_docs_WebDocs_Panel_activateControl"
													class="Panel_activateControl"
													href="#web/docs/WebDocs.Panel_activateControl">activateControl</a>
												</li>
												<li><a id="web_docs_WebDocs_Panel_addControls"
													class="Panel_addControls"
													href="#web/docs/WebDocs.Panel_addControls">addControls</a>
												</li>
												<li><a id="web_docs_WebDocs_Panel_createControlMarkup"
													class="Panel_createControlMarkup"
													href="#web/docs/WebDocs.Panel_createControlMarkup">createControlMarkup</a>
												</li>
												<li><a id="web_docs_WebDocs_Panel_getControlsBy"
													class="Panel_getControlsBy"
													href="#web/docs/WebDocs.Panel_getControlsBy">getControlsBy</a>
												</li>
												<li><a id="web_docs_WebDocs_Panel_getControlsByName"
													class="Panel_getControlsByName"
													href="#web/docs/WebDocs.Panel_getControlsByName">getControlsByName</a>
												</li>
												<li><a id="web_docs_WebDocs_Panel_getControlsByClass"
													class="Panel_getControlsByClass"
													href="#web/docs/WebDocs.Panel_getControlsByClass">getControlsByClass</a>
												</li>
											</ul></li>
										<li><a
											id="web_docs_WebDocs_Tmap_Geometry_MultiLineString"
											class="Tmap_Geometry_MultiLineString"
											href="#web/docs/WebDocs.Tmap_Geometry_MultiLineString">
												Tmap.Geometry.MultiLineString </a></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_MultiPoint"
												href="#web/docs/WebDocs.Tmap_Geometry_MultiPoint">Tmap.Geometry.MultiPoint</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_MultiPoint_addPoint"
													class="MultiPoint_addPoint"
													href="#web/docs/WebDocs.MultiPoint_addPoint">addPoint</a></li>
												<li><a id="web_docs_WebDocs_MultiPoint_removePoint"
													class="Muclass=Point_removePoint"
													href="#web/docs/WebDocs.MultiPoint_removePoint">removePoint</a>
												</li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Geometry_MultiPolygon"
											class="Tmap_Geometry_MultiPolygon"
											href="#web/docs/WebDocs.Tmap_Geometry_MultiPolygon">
												Tmap.Geometry.MultiPolygon </a></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Geometry_Collection"
												href="#web/docs/WebDocs.Tmap_Geometry_Collection">Tmap.Geometry.Collection</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Collection_destroy"
													class="Collection_destroy"
													href="#web/docs/WebDocs.Collection_destroy">destroy</a></li>
												<li><a id="web_docs_WebDocs_Collection_clone"
													class="Collection_clone"
													href="#web/docs/WebDocs.Collection_clone">clone</a></li>
												<li><a id="web_docs_WebDocs_Collection_addComponents"
													class="Collection_addComponents"
													href="#web/docs/WebDocs.Collection_addComponents">addComponents</a>
												</li>
												<li><a
													id="web_docs_WebDocs_Collection_removeComponents"
													class="Collection_removeComponents"
													href="#web/docs/WebDocs.Collection_removeComponents">removeComponents</a>
												</li>
												<li><a id="web_docs_WebDocs_Collection_move"
													class="Collection_move"
													href="#web/docs/WebDocs.Collection_move">move</a></li>
												<li><a id="web_docs_WebDocs_Collection_rotate"
													class="Collection_rotate"
													href="#web/docs/WebDocs.Collection_rotate">rotate</a></li>
												<li><a id="web_docs_WebDocs_Collection_distanceTo"
													class="Collection_distanceTo"
													href="#web/docs/WebDocs.Collection_distanceTo">distanceTo</a>
												</li>
												<li><a id="web_docs_WebDocs_Collection_equals"
													class="Collection_equals"
													href="#web/docs/WebDocs.Collection_equals">equals</a></li>
												<li><a id="web_docs_WebDocs_Collection_transform"
													class="Collection_transform"
													href="#web/docs/WebDocs.Collection_transform">transform</a>
												</li>
												<li><a id="web_docs_WebDocs_Collection_intersects"
													class="Collection_intersects"
													href="#web/docs/WebDocs.Collection_intersects">intersects</a>
												</li>
												<li><a id="web_docs_WebDocs_Collection_getVertices"
													class="Collection_getVertices"
													href="#web/docs/WebDocs.Collection_getVertices">getVertices</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Format_GeoJSON"
												href="#web/docs/WebDocs.Tmap_Format_GeoJSON">Tmap.Format.GeoJSON</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_GeoJSON_read"
													class="GeoJSON_read" href="#web/docs/WebDocs.GeoJSON_read">read</a>
												</li>
												<li><a id="web_docs_WebDocs_GeoJSON_write"
													class="GeoJSON_write"
													href="#web/docs/WebDocs.GeoJSON_write">write</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Format_KML"
												href="#web/docs/WebDocs.Tmap_Format_KML">Tmap.Format.KML</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_KML_read" class="KML_read"
													href="#web/docs/WebDocs.KML_read">read</a></li>
												<li><a id="web_docs_WebDocs_KML_write"
													class="KML_write" href="#web/docs/WebDocs.KML_write">write</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Protocol_HTTP"
												href="#web/docs/WebDocs.Tmap_Protocol_HTTP">Tmap.Protocol.HTTP</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_HTTP_destroy"
													class="HTTP_destroy" href="#web/docs/WebDocs.HTTP_destroy">destroy</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_read"
													class="HTTP_read" href="#web/docs/WebDocs.HTTP_read">read</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_create"
													class="HTTP_create" href="#web/docs/WebDocs.HTTP_create">create</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_update"
													class="HTTP_update" href="#web/docs/WebDocs.HTTP_update">update</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_delete"
													class="HTTP_delete" href="#web/docs/WebDocs.HTTP_delete">delete</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_commit"
													class="HTTP_commit" href="#web/docs/WebDocs.HTTP_commit">commit</a>
												</li>
												<li><a id="web_docs_WebDocs_HTTP_abort"
													class="HTTP_abort" href="#web/docs/WebDocs.HTTP_abort">abort</a>
												</li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Strategy_BBOX"
											class="Tmap_Strategy_BBOX"
											href="#web/docs/WebDocs.Tmap_Strategy_BBOX">
												Tmap.Strategy.BBOX </a></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Strategy_Cluster"
												href="#web/docs/WebDocs.Tmap_Strategy_Cluster">Tmap.Strategy.Cluster</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Cluster_activate"
													class="Cluster_activate"
													href="#web/docs/WebDocs.Cluster_activate">activate</a></li>
												<li><a id="web_docs_WebDocs_Cluster_deactivate"
													class="Cluster_deactivate"
													href="#web/docs/WebDocs.Cluster_deactivate">deactivate</a>
												</li>
											</ul></li>
										<li><a id="web_docs_WebDocs_Tmap_Strategy_Fixed"
											class="Tmap_Strategy_Fixed"
											href="#web/docs/WebDocs.Tmap_Strategy_Fixed">
												Tmap.Strategy.Fixed </a></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Strategy_Paging"
												href="#web/docs/WebDocs.Tmap_Strategy_Paging">Tmap.Strategy.Paging</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Paging_activate"
													class="Paging_activate"
													href="#web/docs/WebDocs.Paging_activate">activate</a></li>
												<li><a id="web_docs_WebDocs_Paging_deactivate"
													class="Paging_deactivate"
													href="#web/docs/WebDocs.Paging_deactivate">deactivate</a></li>
												<li><a id="web_docs_WebDocs_Paging_PageCount"
													class="Paging_PageCount"
													href="#web/docs/WebDocs.Paging_PageCount">PageCount</a></li>
												<li><a id="web_docs_WebDocs_Paging_PageNum"
													class="Paging_PageNum"
													href="#web/docs/WebDocs.Paging_PageNum">PageNum</a></li>
												<li><a id="web_docs_WebDocs_Paging_pageLength"
													class="Paging_pageLength"
													href="#web/docs/WebDocs.Paging_pageLength">pageLength</a></li>
												<li><a id="web_docs_WebDocs_Paging_pageNext"
													class="Paging_pageNext"
													href="#web/docs/WebDocs.Paging_pageNext">pageNext</a></li>
												<li><a id="web_docs_WebDocs_Paging_pagePrevious"
													class="Paging_pagePrevious"
													href="#web/docs/WebDocs.Paging_pagePrevious">pagePrevious</a>
												</li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Legend"
												href="#web/docs/WebDocs.Tmap_Legend">Tmap.Legend</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Legend_activate"
													class="Legend_activate"
													href="#web/docs/WebDocs.Legend_activate">activate</a></li>
												<li><a id="web_docs_WebDocs_Legend_close"
													class="Legend_close" href="#web/docs/WebDocs.Legend_close">close</a>
												</li>
												<li><a id="web_docs_WebDocs_Legend_min"
													class="Legend_min" href="#web/docs/WebDocs.Legend_min">min</a>
												</li>
												<li><a id="web_docs_WebDocs_Legend_plus"
													class="Legend_plus" href="#web/docs/WebDocs.Legend_plus">plus</a>
												</li>
												<li><a id="web_docs_WebDocs_Legend_reactivate"
													class="Legend_reactivate"
													href="#web/docs/WebDocs.Legend_reactivate">reactivate</a></li>
												<li><a id="web_docs_WebDocs_Legend_deactivate"
													class="Legend_deactivate"
													href="#web/docs/WebDocs.Legend_deactivate">deactivate</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="web_docs_WebDocs_Tmap_Tdata"
												href="#web/docs/WebDocs.Tmap_Tdata">Tmap.TData</a></span>
											<ul style="display: none">
												<li><a id="web_docs_WebDocs_Tdata_getRoutePlan"
													class="Tdata_getRoutePlan"
													href="#web/docs/WebDocs.Tdata_getRoutePlan">getRoutePlan</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_getRealTimeTraffic"
													class="Tdata_getRealTimeTraffic"
													href="#web/docs/WebDocs.Tdata_getRealTimeTraffic">getRealTimeTraffic</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_getPOIDataFromSearch"
													class="Tdata_getPOIDataFromSearch"
													href="#web/docs/WebDocs.Tdata_getPOIDataFromSearch">getPOIDataFromSearch</a>
												</li>
												<!-- 												<li> -->
												<!-- 													<a id="web_docs_WebDocs_Tdata_getPOICategory" class="Tdata_getPOICategory" href="#web/docs/WebDocs.Tdata_getPOICategory">getPOICategory</a> -->
												<!-- 												</li> -->
												<!-- 												<li> -->
												<!-- 													<a id="web_docs_WebDocs_Tdata_getPOILocalCode" class="Tdata_getPOILocalCode" href="#web/docs/WebDocs.Tdata_getPOILocalCode">getPOILocalCode</a> -->
												<!-- 												</li> -->
												<li><a id="web_docs_WebDocs_Tdata_getPOIDataFromLonLat"
													class="Tdata_getPOIDataFromLonLat"
													href="#web/docs/WebDocs.Tdata_getPOIDataFromLonLat">getPOIDataFromLonLat</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_getPOIDataFromId"
													class="Tdata_getPOIDataFromId"
													href="#web/docs/WebDocs.Tdata_getPOIDataFromId">getPOIDataFromId</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_getGeoFromAddress"
													class="Tdata_getGeoFromAddress"
													href="#web/docs/WebDocs.Tdata_getGeoFromAddress">getGeoFromAddress</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_getAddressFromLonLat"
													class="Tdata_getAddressFromLonLat"
													href="#web/docs/WebDocs.Tdata_getAddressFromLonLat">getAddressFromLonLat</a>
												</li>
												<li><a id="web_docs_WebDocs_Tdata_transform"
													class="Tdata_transform"
													href="#web/docs/WebDocs.Tdata_transform">transform</a></li>
												<li><a
													id="web_docs_WebDocs_Tdata_getAutoCompleteSearch"
													class="Tdata_getAutoCompleteSearch"
													href="#web/docs/WebDocs.Tdata_getAutoCompleteSearch">getAutoCompleteSearch</a>
												</li>
											</ul></li>
									</ul></li>

								<li id="usecase"><span class="">Use case</span>
									<ul style="display: none">
										<!-- style="display:none" -->
										<li><a id="web_usecase_UseCasePathSearch"
											href="#web/usecase/UseCasePathSearch">경로탐색 만들어 보기</a></li>
										<li><a id="web_usecase_UseCaseOptimization"
											href="#web/usecase/UseCaseOptimization">경유지 최적화 만들어 보기</a></li>
										<li><a id="web_usecase_UseCasePositionControl"
											href="#web/usecase/UseCasePositionControl">위치관제 만들어 보기</a></li>
									</ul></li>

							</ul></li>


						<li style="background: none"><span id="tit_Android"
							class="tit tit_ico_android">Android</span>
							<ul>

								<li><span class="">Guide</span>
									<ul style="display: none">
										<li><a id="android_guide_androidGuide_sample1"
											href="#android/guide/androidGuide.sample1">T map SDK 소개</a></li>
										<li><a id="android_guide_androidGuide_sample2"
											href="#android/guide/androidGuide.sample2">T map SDK
												package 구조</a></li>
										<li><a id="android_guide_androidGuide_sample3"
											href="#android/guide/androidGuide.sample3">Android SDK
												개발준비</a></li>
										<li><a id="android_guide_androidGuide_sample4"
											href="#android/guide/androidGuide.sample4">Android SDK 설정</a></li>
										<li><a id="android_guide_androidGuide_sample5"
											href="#android/guide/androidGuide.sample5">API Key 발급</a></li>
										<li><a id="android_guide_androidGuide_sample6"
											href="#android/guide/androidGuide.sample6">API Key 설정</a></li>
										<li><a id="android_guide_androidGuide_sample7"
											href="#android/guide/androidGuide.sample7">좌표계</a></li>
									</ul></li>

								<li><span class="">Sample</span>
									<ul style="display: none">
										<li><a id="android_sample_androidSample_sdk_download"
											href="#android/sample/androidSample.sdk_download">SDK
												다운로드</a></li>
										<li><a id="android_sample_androidSample_sample1"
											href="#android/sample/androidSample.sample1">지도 생성하기</a></li>
										<li><a id="android_sample_androidSample_sample2"
											href="#android/sample/androidSample.sample2">지도 이벤트 설정하기</a></li>
										<li><a id="android_sample_androidSample_sample3"
											href="#android/sample/androidSample.sample3">지도 중심점 및 레벨
												변경하기</a></li>
										<li><a id="android_sample_androidSample_sample4"
											href="#android/sample/androidSample.sample4">마커 생성하기</a></li>
										<li><a id="android_sample_androidSample_sample5"
											href="#android/sample/androidSample.sample5">선 그리기</a></li>
										<li><a id="android_sample_androidSample_sample6"
											href="#android/sample/androidSample.sample6">Polygon 그리기</a></li>
										<li><a id="android_sample_androidSample_sample7"
											href="#android/sample/androidSample.sample7">Circle 그리기</a></li>
										<li><a id="android_sample_androidSample_sample8"
											href="#android/sample/androidSample.sample8">자동차 경로안내</a></li>
										<li><a id="android_sample_androidSample_sample9"
											href="#android/sample/androidSample.sample9">리버스 지오코딩</a></li>
										<li><a id="android_sample_androidSample_sample10"
											href="#android/sample/androidSample.sample10">명칭(POI) 통합
												검색</a></li>
										<li><a id="android_sample_androidSample_sample11"
											href="#android/sample/androidSample.sample11">TMapApp 실행</a></li>
										<li><a id="android_sample_androidSample_sample12"
											href="#android/sample/androidSample.sample12">TMapApp 길안내</a></li>
										<li><a id="android_sample_androidSample_sample18"
											href="#android/sample/androidSample.sample18">TMapApp
												길안내(옵션설정)</a></li>
										<li><a id="android_sample_androidSample_sample19"
											href="#android/sample/androidSample.sample19">TMapApp
												길안내(바로실행)</a></li>
										<li><a id="android_sample_androidSample_sample13"
											href="#android/sample/androidSample.sample13">TMapApp
												지도이동</a></li>
										<li><a id="android_sample_androidSample_sample14"
											href="#android/sample/androidSample.sample14">TMapApp
												안전운전도우미</a></li>
										<li><a id="android_sample_androidSample_sample15"
											href="#android/sample/androidSample.sample15">TMapApp
												통합검색</a></li>
										<li><a id="android_sample_androidSample_sample16"
											href="#android/sample/androidSample.sample16">TMapApp 집으로</a></li>
										<li><a id="android_sample_androidSample_sample17"
											href="#android/sample/androidSample.sample17">TMapApp 회사로</a></li>

									</ul></li>

								<li><span class="">Docs</span>
									<ul style="display: none">
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapView"
												href="#android/docs/androidDoc.TMapView">TMapView</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapView_setSKTMapApiKey"
													href="#android/docs/androidDoc.TMapView_setSKTMapApiKey">void
														setSKTMapApiKey(String apiKey)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setHttpsMode"
													href="#android/docs/androidDoc.TMapView_setHttpsMode">void
														setHttpsMode(boolean isActive)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setLanguage"
													href="#android/docs/androidDoc.TMapView_setLanguage">void
														setLanguage(int language)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setCenterPoint"
													href="#android/docs/androidDoc.TMapView_setCenterPoint">void
														setCenterPoint(double LocationLongitude, double
														LocationLatitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setLocationPoint"
													href="#android/docs/androidDoc.TMapView_setLocationPoint">void
														setLocationPoint(double LocationLongitude, double
														LocationLatitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getLocationPoint"
													href="#android/docs/androidDoc.TMapView_getLocationPoint">TmapPoint
														getLocationPoint()</a></li>
												<li><a id="android_docs_androidDoc_TMapView_setIcon"
													href="#android/docs/androidDoc.TMapView_setIcon">Void
														setIcon(Bitmap icon)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setIconVisibility"
													href="#android/docs/androidDoc.TMapView_setIconVisibility">Void
														setIconVisibility(Boolean visibility)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setZoomLevel"
													href="#android/docs/androidDoc.TMapView_setZoomLevel">Void
														setZoomLevel(int level)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getZoomLevel"
													href="#android/docs/androidDoc.TMapView_getZoomLevel">Int
														getZoomLevel()</a></li>
												<li><a id="android_docs_androidDoc_TMapView_MapZoomIn"
													href="#android/docs/androidDoc.TMapView_MapZoomIn">boolean
														MapZoomIn()</a></li>
												<li><a id="android_docs_androidDoc_TMapView_MapZoomOut"
													href="#android/docs/androidDoc.TMapView_MapZoomOut">boolean
														MapZoomOut()</a></li>
												<li><a id="android_docs_androidDoc_TMapView_ZoomEnable"
													href="#android/docs/androidDoc.TMapView_ZoomEnable">boolean
														ZoomEnable()</a></li>
												<li><a id="android_docs_androidDoc_TMapView_setMapType"
													href="#android/docs/androidDoc.TMapView_setMapType">void
														setMapType(int type)</a></li>
												<li><a id="android_docs_androidDoc_TMapView_getMapType"
													href="#android/docs/androidDoc.TMapView_getMapType">Int
														getMapType()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setCompassMode"
													href="#android/docs/androidDoc.TMapView_setCompassMode">void
														setCompassMode(Boolean Mode)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getIsCompass"
													href="#android/docs/androidDoc.TMapView_getIsCompass">boolean
														getIsCompass()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setSightVisible"
													href="#android/docs/androidDoc.TMapView_setSightVisible">void
														setSightVisible(boolean sight)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setTrackingMode"
													href="#android/docs/androidDoc.TMapView_setTrackingMode">void
														setTrackingMode(boolean Mode)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getIsTracking"
													href="#android/docs/androidDoc.TMapView_getIsTracking">boolean
														getIsTracking()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_OnLongClickListenerCallback"
													href="#android/docs/androidDoc.TMapView_OnLongClickListenerCallback">Interface
														OnLongClickListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_onLongPressEvent"
													href="#android/docs/androidDoc.TMapView_onLongPressEvent">void
														onLongPressEvent (ArrayList<TMapMarker>
														markerlist, ArrayList<TMapPOIItem> poilist,
														TMapPoint point) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapCircle"
													href="#android/docs/androidDoc.TMapView_addTMapCircle">void
														addTMapCircle(String id, TMapCircle tmapcircle)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapCircle"
													href="#android/docs/androidDoc.TMapView_removeTMapCircle">void
														removeTMapCircle(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeAllTMapCircle"
													href="#android/docs/androidDoc.TMapView_removeAllTMapCircle">void
														removeAllTMapCircle()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapPolygon"
													href="#android/docs/androidDoc.TMapView_addTMapPolygon">void
														addTMapPolygon(String id, TMapPolygon tmappolygon)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapPolygon"
													href="#android/docs/androidDoc.TMapView_removeTMapPolygon">void
														removeTMapPolygon(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeAllTMapPolygon"
													href="#android/docs/androidDoc.TMapView_removeAllTMapPolygon">void
														removeAllTMapPolygon()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapPolyLine"
													href="#android/docs/androidDoc.TMapView_addTMapPolyLine">void
														addTMapPolyLine(String id, TMapPolyLine tmappolyline)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapPolyLine"
													href="#android/docs/androidDoc.TMapView_removeTMapPolyLine">void
														removeTMapPolyLine(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeAllTMapPolyLine"
													href="#android/docs/androidDoc.TMapView_removeAllTMapPolyLine">void
														removeAllTMapPolyLine()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addMarkerItem"
													href="#android/docs/androidDoc.TMapView_addMarkerItem">void
														addMarkerItem(String id, TMapMarkerItem markeritem)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeMarkerItem"
													href="#android/docs/androidDoc.TMapView_removeMarkerItem">void
														removeMarkerItem(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeAllMarkerItem"
													href="#android/docs/androidDoc.TMapView_removeAllMarkerItem">void
														removeAllMarkerItem()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapPOIItem"
													href="#android/docs/androidDoc.TMapView_addTMapPOIItem">void
														addTMapPOIItem(ArrayList<TMapPOIItem>
														poiitem) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapPOIItem"
													href="#android/docs/androidDoc.TMapView_removeTMapPOIItem">void
														removeTMapPOIItem(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeAllTMapPOIItem"
													href="#android/docs/androidDoc.TMapView_removeAllTMapPOIItem">void
														removeAllTMapPOIItem()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapPath"
													href="#android/docs/androidDoc.TMapView_addTMapPath">void
														addTMapPath(TMapPolyLine polyline)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapPath"
													href="#android/docs/androidDoc.TMapView_removeTMapPath">void
														removeTMapPath()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setTMapPathIcon"
													href="#android/docs/androidDoc.TMapView_setTMapPathIcon">void
														setTMapPathIcon(Bitmap start, Bitmap end)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setLongClick"
													href="#android/docs/androidDoc.TMapView_setLongClick">boolean
														setLongClick()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setPOIRotate"
													href="#android/docs/androidDoc.TMapView_setPOIRotate">void
														setPOIRotate(boolean rotate)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setMarkerRotate"
													href="#android/docs/androidDoc.TMapView_setMarkerRotate">void
														setMarkerRotate(boolean rotate)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setPathRotate"
													href="#android/docs/androidDoc.TMapView_setPathRotate">void
														setPathRotate(boolean rotate)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setMapPosition"
													href="#android/docs/androidDoc.TMapView_setMapPosition">void
														setMapPosition(int type)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_OnClickListenerCallback"
													href="#android/docs/androidDoc.TMapView_OnClickListenerCallback">Interface
														OnClickListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_onPressEvent"
													href="#android/docs/androidDoc.TMapView_onPressEvent">boolean
														onPressEvent(ArrayList<TMapMarker>
														markerlist, ArrayList<TMapPOIItem> poilist,
														TMapPoint point, PointF pointf) 
												</a></li>
												<li><a id="android_docs_androidDoc_TMapView_setClick"
													href="#android/docs/androidDoc.TMapView_setClick">boolean
														setClick()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getMarkerItemFromID"
													href="#android/docs/androidDoc.TMapView_getMarkerItemFromID">TMapMarkerItem
														getMarkerItemFromID(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getPolyLineFromID"
													href="#android/docs/androidDoc.TMapView_getPolyLineFromID">TMapPolyLine
														getPolyLineFromID(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getPolygonFromID"
													href="#android/docs/androidDoc.TMapView_getPolygonFromID">TMapPolygon
														getPolygonFromID(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getCircleFromID"
													href="#android/docs/androidDoc.TMapView_getCircleFromID">TMapCircle
														getCircleFromID(String id)f</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_convertPointToGps"
													href="#android/docs/androidDoc.TMapView_convertPointToGps">TMapPoint
														convertPointToGps(float x, float y)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getCenterPoint"
													href="#android/docs/androidDoc.TMapView_getCenterPoint">TMapPoint
														getCenterPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setTileType"
													href="#android/docs/androidDoc.TMapView_setTileType">void
														setTileType(int type)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getTileType"
													href="#android/docs/androidDoc.TMapView_getTileType">getTileType()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getTMapPointFromScreenPoint"
													href="#android/docs/androidDoc.TMapView_getTMapPointFromScreenPoint">TMapPoint
														getTMapPointFromScreenPoint(float x, float y)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getMapXForPoint"
													href="#android/docs/androidDoc.TMapView_getMapXForPoint">int
														getMapXForPoint(double longitude, double latitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getMapYForPoint"
													href="#android/docs/androidDoc.TMapView_getMapYForPoint">int
														getMapYForPoint(double longitude, double latitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnClickListenerCallBack"
													href="#android/docs/androidDoc.TMapView_setOnClickListenerCallBack">void
														setOnClickListenerCallBack(OnClickListenerCallback
														listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnLongClickListenerCallback"
													href="#android/docs/androidDoc.TMapView_setOnLongClickListenerCallback">void
														setOnLongClickListenerCallback(OnLongClistenerCallback
														listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_bringMarkerToFront"
													href="#android/docs/androidDoc.TMapView_bringMarkerToFront">void
														bringMarkerToFront(TMapMarkerItem item)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_sendMarkerToBack"
													href="#android/docs/androidDoc.TMapView_sendMarkerToBack">void
														sendMarkerToBack(TMapMarkerItem item)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getDisplayTMapInfo"
													href="#android/docs/androidDoc.TMapView_getDisplayTMapInfo">TMapInfo
														getDisplayTMapInfo(ArrayList<TMapPoint> point)









														
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_OnCalloutRightButtonClickCallback"
													href="#android/docs/androidDoc.TMapView_OnCalloutRightButtonClickCallback">interface
														OnCalloutRightButtonClickCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnCalloutRightButtonClickListener"
													href="#android/docs/androidDoc.TMapView_setOnCalloutRightButtonClickListener">void
														setOnCalloutRightButtonClickListener(onCalloutRightButton
														ClickCallout listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setEnableClustering"
													href="#android/docs/androidDoc.TMapView_setEnableClustering">void
														setEnableClustering(boolean bEnable)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getEnableClustering"
													href="#android/docs/androidDoc.TMapView_getEnableClustering">boolean
														getEnableClustering()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setClusteringIcon"
													href="#android/docs/androidDoc.TMapView_setClusteringIcon">void
														setClusteringIcon(Bitmap bitmap)</a></li>
												<!-- <li><a
													id="android_docs_androidDoc_TMapView_getClusteringIcon"
													href="#android/docs/androidDoc.TMapView_getClusteringIcon">Bitmap
														getClusteringIcon()</a></li> -->
												<!-- getClusteringIcon() 함수 현재 getClusteringeIcon()로 잘못 표기되어있어서 가이드에 적용X. -->

												<li><a
													id="android_docs_androidDoc_TMapView_getCaptureImage"
													href="#android/docs/androidDoc.TMapView_getCaptureImage">Bitmap
														getCaptureImage()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setUserScrollZoomEnable"
													href="#android/docs/androidDoc.TMapView_setUserScrollZoomEnable">void
														setUserScrollZoomEnable(boolean enable)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_isValidTMapPoint"
													href="#android/docs/androidDoc.TMapView_isValidTMapPoint">boolean
														isValidTMapPoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getCaptureImage_2"
													href="#android/docs/androidDoc.TMapView_getCaptureImage_2">void
														getCaptureImage(int nTimeOut, final
														MapCaptureImageListenerCallback MapCaptureListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_MapCaptureImageListenerCallback"
													href="#android/docs/androidDoc.TMapView_MapCaptureImageListenerCallback">interface
														MapCaptureImageListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addMarkerItem2"
													class="TMapView_addMarkerItem2"
													href="#android/docs/androidDoc.TMapView_addMarkerItem2">void
														addMarkerItem2(String id, TMapMarkerItem2 markeritem)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeMarkerItem2"
													class="TMapView_removeMarkerItem2"
													href="#android/docs/androidDoc.TMapView_removeMarkerItem2">void
														removeMarkerItem2(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getLeftTopPoint"
													href="#android/docs/androidDoc.TMapView_getLeftTopPoint">TMapPoint
														getLeftTopPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getRightBottomPoint"
													href="#android/docs/androidDoc.TMapView_getRightBottomPoint">TMapPoint
														getRightBottomPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnEnableScrollWithZoomLevelListener"
													href="#android/docs/androidDoc.TMapView_setOnEnableScrollWithZoomLevelListener">void
														setOnEnableScrollWithZoomLevelListener(OnEnableScrollWith
														ZoomLevelCallback listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnDisableScrollWithZoomLevelListener"
													href="#android/docs/androidDoc.TMapView_setOnDisableScrollWithZoomLevelListener">void
														setOnDisableScrollWithZoomLevelListener(OnDisableScrollWit
														hZoomLevelCallback listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getMetersToPixel"
													href="#android/docs/androidDoc.TMapView_getMetersToPixel">int
														getMetersToPixel(double meters)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setCenterPoint_2"
													href="#android/docs/androidDoc.TMapView_setCenterPoint_2">void
														setCenterPoint(double longitude, double latitude, boolean
														animate)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_addTMapOverlayID"
													href="#android/docs/androidDoc.TMapView_addTMapOverlayID">void
														addTMapOverlayID(int overlayID, TMapOverlayItem
														overlayItem)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_removeTMapOverlayID"
													href="#android/docs/androidDoc.TMapView_removeTMapOverlayID">void
														removeTMapOverlayID(int overlayID)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getAllMarkerItem2"
													class="TMapView_getAllMarkerItem2"
													href="#android/docs/androidDoc.TMapView_getAllMarkerItem2">ArrayList<TMapMarkerItem2>
														getAllMarkerItem2()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_getMarkerItem2FromID"
													class="TMapView_getMarkerItem2FromID"
													href="#android/docs/androidDoc.TMapView_getMarkerItem2FromID">TMapMarkerItem2
														getMarkerItem2FromID(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setTMapLogoPosition"
													href="#android/docs/androidDoc.TMapView_setTMapLogoPosition">void
														setTMapLogoPosition(TMapLogoPosition place)</a></li>
												<li><a id="android_docs_androidDoc_TMapView_zoomToSpan"
													href="#android/docs/androidDoc.TMapView_zoomToSpan">void
														zoomToSpan(double latSpan, double lonSpan)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_zoomToTMapPoint"
													href="#android/docs/androidDoc.TMapView_zoomToTMapPoint">void
														zoomToTMapPoint(TMapPoint leftTop, TMapPoint rightBottom)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_OnApiKeyListenerCallback"
													href="#android/docs/androidDoc.TMapView_OnApiKeyListenerCallback">Interface
														OnApiKeyListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnApiKeyListener"
													href="#android/docs/androidDoc.TMapView_setOnApiKeyListener">void
														setOnApiKeyListener(OnApiKeyListenerCallback listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_SKTMapApikeySucceed"
													href="#android/docs/androidDoc.TMapView_SKTMapApikeySucceed">void
														SKTMapApikeySucceed()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_SKTMapApikeyFailed"
													href="#android/docs/androidDoc.TMapView_SKTMapApikeyFailed">void
														SKTMapApikeyFailed(String errorMsg)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setOnClickReverseLabelListener"
													href="#android/docs/androidDoc.TMapView_setOnClickReverseLabelListener">void
														setOnClickReverseLabelListener(OnClickReverseLabelListenerCallback
														listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapView_setTMapPathIcon_2"
													href="#android/docs/androidDoc.TMapView_setTMapPathIcon_2">void
														setTMapPathIcon(Bitmap start, Bitmap end, Bitmap pass)</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapPoint"
												href="#android/docs/androidDoc.TMapPoint">TMapPoint</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapPoint_setLatitude"
													href="#android/docs/androidDoc.TMapPoint_setLatitude">void
														setLatitude(double latitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPoint_getLatitude"
													href="#android/docs/androidDoc.TMapPoint_getLatitude">double
														getLatitude()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPoint_getKatechLat"
													href="#android/docs/androidDoc.TMapPoint_getKatechLat">double
														getKatechLat()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPoint_setLongtitude"
													href="#android/docs/androidDoc.TMapPoint_setLongtitude">void
														setLongtitude(double longitude)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPoint_getLongitude"
													href="#android/docs/androidDoc.TMapPoint_getLongitude">double
														getLongitude()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPoint_getKatechLon"
													href="#android/docs/androidDoc.TMapPoint_getKatechLon">double
														getKatechLon()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapMarkerItem"
												href="#android/docs/androidDoc.TMapMarkerItem">TMapMarkerItem</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setTMapPoint"
													href="#android/docs/androidDoc.TMapMarkerItem_setTMapPoint">void
														setTMapPoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getTMapPoint"
													href="#android/docs/androidDoc.TMapMarkerItem_getTMapPoint">TMapPoint
														getTMapPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setName"
													href="#android/docs/androidDoc.TMapMarkerItem_setName">void
														setName(String name)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getName"
													href="#android/docs/androidDoc.TMapMarkerItem_getName">String
														getName()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setVisible"
													href="#android/docs/androidDoc.TMapMarkerItem_setVisible">void
														setVisible(int visible)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getVisible"
													href="#android/docs/androidDoc.TMapMarkerItem_getVisible">int
														getVisible()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setIcon"
													href="#android/docs/androidDoc.TMapMarkerItem_setIcon">void
														setIcon(Bitmap bitmap)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getID"
													href="#android/docs/androidDoc.TMapMarkerItem_getID">String
														getID()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setPosition"
													href="#android/docs/androidDoc.TMapMarkerItem_setPosition">void
														setPosition(float dx, float dy)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getPositionX"
													href="#android/docs/androidDoc.TMapMarkerItem_getPositionX">float
														getPositionX()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getPositionY"
													href="#android/docs/androidDoc.TMapMarkerItem_getPositionY">float
														getPositionY()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setCanShowCallout"
													href="#android/docs/androidDoc.TMapMarkerItem_setCanShowCallout">void
														setCanShowCallout(boolean bShow)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getCanShowCallout"
													href="#android/docs/androidDoc.TMapMarkerItem_getCanShowCallout">boolean
														getCanShowCallout()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setCalloutTitle"
													href="#android/docs/androidDoc.TMapMarkerItem_setCalloutTitle">void
														setCalloutTitle(String title)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getCalloutTitle"
													href="#android/docs/androidDoc.TMapMarkerItem_getCalloutTitle">String
														getCalloutTitle()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setCalloutSubTitle"
													href="#android/docs/androidDoc.TMapMarkerItem_setCalloutSubTitle">void
														setCalloutSubTitle(String subTitle)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_getCalloutSubTitile"
													href="#android/docs/androidDoc.TMapMarkerItem_getCalloutSubTitile">String
														getCalloutSubTitile()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setCalloutLeftImage"
													href="#android/docs/androidDoc.TMapMarkerItem_setCalloutLeftImage">void
														setCalloutLeftImage(Bitmap bitmap)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setCalloutRightButtonImage"
													href="#android/docs/androidDoc.TMapMarkerItem_setCalloutRightButtonImage">void
														setCalloutRightButtonImage(Bitmap bitmap)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_isCalloutAnimation"
													href="#android/docs/androidDoc.TMapMarkerItem_isCalloutAnimation">void
														isCalloutAnimation(boolean banimated)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setEnableClustering"
													href="#android/docs/androidDoc.TMapMarkerItem_setEnableClustering">void
														setEnableClustering(boolean bEnable)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem_setAutoCalloutVisible"
													href="#android/docs/androidDoc.TMapMarkerItem_setAutoCalloutVisible">void
														setAutoCalloutVisible(boolean visible)</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapPolyLine"
												href="#android/docs/androidDoc.TMapPolyLine">TMapPolyLine</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_setLineColor"
													href="#android/docs/androidDoc.TMapPolyLine_setLineColor">void
														setLineColor(int Color)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_getLineColor"
													href="#android/docs/androidDoc.TMapPolyLine_getLineColor">int
														getLineColor()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_setLineWidth"
													href="#android/docs/androidDoc.TMapPolyLine_setLineWidth">void
														setLineWidth(float width)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_getLineWidth"
													href="#android/docs/androidDoc.TMapPolyLine_getLineWidth">float
														getLineWidth()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_addLinePoint"
													href="#android/docs/androidDoc.TMapPolyLine_addLinePoint">void
														addLinePoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_getLinePoint"
													href="#android/docs/androidDoc.TMapPolyLine_getLinePoint">ArrayList<TMapPoint>
														getLinePoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_getDistance"
													href="#android/docs/androidDoc.TMapPolyLine_getDistance">double
														getDistance()</a></li>
												<li><a id="android_docs_androidDoc_TMapPolyLine_getID"
													href="#android/docs/androidDoc.TMapPolyLine_getID">String
														getID()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_setPathEffect"
													href="#android/docs/androidDoc.TMapPolyLine_setPathEffect">void
														setPathEffect(DashPathEffect dashPath)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolyLine_getPathEffect"
													href="#android/docs/androidDoc.TMapPolyLine_getPathEffect">DashPathEffect
														getPathEffect()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapPolygon"
												href="#android/docs/androidDoc.TMapPolygon">TMapPolygon</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapPolygon_setAreaColor"
													href="#android/docs/androidDoc.TMapPolygon_setAreaColor">void
														setAreaColor(int Color)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getAreaColor"
													href="#android/docs/androidDoc.TMapPolygon_getAreaColor">int
														getAreaColor()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_setLineColor"
													href="#android/docs/androidDoc.TMapPolygon_setLineColor">void
														setLineColor(Int Color)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getLineColor"
													href="#android/docs/androidDoc.TMapPolygon_getLineColor">int
														getLineColor()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_setPolygonWidth"
													href="#android/docs/androidDoc.TMapPolygon_setPolygonWidth">void
														setPolygonWidth(float width)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getPolygonWidth"
													href="#android/docs/androidDoc.TMapPolygon_getPolygonWidth">float
														getPolygonWidth()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_setAreaAlpha"
													href="#android/docs/androidDoc.TMapPolygon_setAreaAlpha">void
														setAreaAlpha(int alpha)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getAreaAlpha"
													href="#android/docs/androidDoc.TMapPolygon_getAreaAlpha">int
														getAreaAlpha()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_setLineAlpha"
													href="#android/docs/androidDoc.TMapPolygon_setLineAlpha">void
														setLineAlpha(int alpha)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getLineAlpha"
													href="#android/docs/androidDoc.TMapPolygon_getLineAlpha">int
														getLineAlpha()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_addPolygonPoint"
													href="#android/docs/androidDoc.TMapPolygon_addPolygonPoint">void
														addPolygonPoint(TMapPoint Point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getPolygonPoint"
													href="#android/docs/androidDoc.TMapPolygon_getPolygonPoint">ArrayList
														<TMapPoint> getPolygonPoint() 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPolygon_getPolygonArea"
													href="#android/docs/androidDoc.TMapPolygon_getPolygonArea">double
														getPolygonArea()</a></li>
												<li><a id="android_docs_androidDoc_TMapPolygon_getID"
													href="#android/docs/androidDoc.TMapPolygon_getID">String
														getID()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapCircle"
												href="#android/docs/androidDoc.TMapCircle">TMapCircle</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapCircle_setCenterPoint"
													href="#android/docs/androidDoc.TMapCircle_setCenterPoint">void
														setCenterPoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getCenterPoint"
													href="#android/docs/androidDoc.TMapCircle_getCenterPoint">TMapPoint
														getCenterPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setRadius"
													href="#android/docs/androidDoc.TMapCircle_setRadius">void
														setRadius(double radius)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getRadius"
													href="#android/docs/androidDoc.TMapCircle_getRadius">double
														getRadius()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setAreaColor"
													href="#android/docs/androidDoc.TMapCircle_setAreaColor">void
														setAreaColor(int Color)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getAreaColor"
													href="#android/docs/androidDoc.TMapCircle_getAreaColor">int
														getAreaColor()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setLineColor"
													href="#android/docs/androidDoc.TMapCircle_setLineColor">void
														setLineColor(int Color)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getLineColor"
													href="#android/docs/androidDoc.TMapCircle_getLineColor">int
														getLineColor()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setCircleWidth"
													href="#android/docs/androidDoc.TMapCircle_setCircleWidth">void
														setCircleWidth(float width)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getCircleWidth"
													href="#android/docs/androidDoc.TMapCircle_getCircleWidth">float
														getCircleWidth()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setAreaAlpha"
													href="#android/docs/androidDoc.TMapCircle_setAreaAlpha">void
														setAreaAlpha(int alpha)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getAreaAlpha"
													href="#android/docs/androidDoc.TMapCircle_getAreaAlpha">int
														getAreaAlpha()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setLineAlpha"
													href="#android/docs/androidDoc.TMapCircle_setLineAlpha">void
														setLineAlpha(int alpha)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_getLineAlpha"
													href="#android/docs/androidDoc.TMapCircle_getLineAlpha">int
														getLineAlpha()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapCircle_setRadiusVisible"
													href="#android/docs/androidDoc.TMapCircle_setRadiusVisible">void
														setRadiusVisible(boolean blradius)</a></li>
												<li><a id="android_docs_androidDoc_TMapCircle_getID"
													href="#android/docs/androidDoc.TMapCircle_getID">String
														getID()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapGpsManager"
												href="#android/docs/androidDoc.TMapGpsManager">TMapGpsManager</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_onLocationChangedCallback"
													href="#android/docs/androidDoc.TMapGpsManager_onLocationChangedCallback">Interface
														onLocationChangedCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_onLocationChange"
													href="#android/docs/androidDoc.TMapGpsManager_onLocationChange">void
														onLocationChange(Location location)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_OpenGps"
													href="#android/docs/androidDoc.TMapGpsManager_OpenGps">void
														OpenGps()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_CloseGps"
													href="#android/docs/androidDoc.TMapGpsManager_CloseGps">void
														CloseGps()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_setMinTime"
													href="#android/docs/androidDoc.TMapGpsManager_setMinTime">void
														setMinTime(long mintime)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_getMinTime"
													href="#android/docs/androidDoc.TMapGpsManager_getMinTime">long
														getMinTime()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_setMinDistance"
													href="#android/docs/androidDoc.TMapGpsManager_setMinDistance">void
														setMinDistance(float mindistance)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_getMinDistance"
													href="#android/docs/androidDoc.TMapGpsManager_getMinDistance">float
														getMinDistance()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_getLocation"
													href="#android/docs/androidDoc.TMapGpsManager_getLocation">TMapPoint
														getLocation()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_getSatellite"
													href="#android/docs/androidDoc.TMapGpsManager_getSatellite">int
														getSatellite()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_setProvider"
													href="#android/docs/androidDoc.TMapGpsManager_setProvider">void
														setProvider(String type)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_getProvider"
													href="#android/docs/androidDoc.TMapGpsManager_getProvider">String
														getProvider()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapGpsManager_setLocationCallback"
													href="#android/docs/androidDoc.TMapGpsManager_setLocationCallback">boolean
														setLocationCallback()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapPOIItem"
												href="#android/docs/androidDoc.TMapPOIItem">TMapPOIItem</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getPOIID"
													href="#android/docs/androidDoc.TMapPOIItem_getPOIID">String
														getPOIID()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getPOIName"
													href="#android/docs/androidDoc.TMapPOIItem_getPOIName">String
														getPOIName()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getPOIPoint"
													href="#android/docs/androidDoc.TMapPOIItem_getPOIPoint">TMapPoint
														getPOIPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getPOIAddress"
													href="#android/docs/androidDoc.TMapPOIItem_getPOIAddress">String
														getPOIAddress()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getPOIContent"
													href="#android/docs/androidDoc.TMapPOIItem_getPOIContent">String
														getPOIContent()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapPOIItem_getDistance"
													href="#android/docs/androidDoc.TMapPOIItem_getDistance">double
														getDistance()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapData"
												href="#android/docs/androidDoc.TMapData">TMapData</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapData_findAllPOI_1"
													class="TMapData_findAllPOI_1"
													href="#android/docs/androidDoc.TMapData_findAllPOI_1">ArrayList<TMapPOIItem>
														findAllPOI(String data)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTitlePOI_1"
													class="TMapData_findTitlePOI_1"
													href="#android/docs/androidDoc.TMapData_findTitlePOI_1">ArrayList<TMapPOIItem>
														findTitlePOI(String data)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAddressPOI_1"
													class="TMapData_findAddressPOI_1"
													href="#android/docs/androidDoc.TMapData_findAddressPOI_1">ArrayList<TMapPOIItem>
														findAddressPOI(String data)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundNamePOI_1"
													class="TMapData_findAroundNamePOI_1"
													href="#android/docs/androidDoc.TMapData_findAroundNamePOI_1">ArrayList<TMapPOIItem>
														findAroundNamePOI(TMapPoint tmappoint, String name )</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathData_1"
													class="TMapData_findPathData_1"
													href="#android/docs/androidDoc.TMapData_findPathData_1">TMapPolyLine
														findPathData(TMapPoint startpoint, TMapPoint endpoint)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_getBizCategory_1"
													class="TMapData_getBizCategory_1"
													href="#android/docs/androidDoc.TMapData_getBizCategory_1">ArrayList<BizCategory>
														getBizCategory()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_convertGpsToAddress_1"
													class="TMapData_convertGpsToAddress_1"
													href="#android/docs/androidDoc.TMapData_convertGpsToAddress_1">String
														convertGpsToAddress(double lat, double lon)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_convertGpsToAddress_2"
													class="TMapData_convertGpsToAddress_2"
													href="#android/docs/androidDoc.TMapData_convertGpsToAddress_2">void
														convertGpsToAddress(final double lat, final double lon,
														final ConvertGPSToAddressListenerCallback addressListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAllPOI_2"
													class="TMapData_findAllPOI_2"
													href="#android/docs/androidDoc.TMapData_findAllPOI_2">void
														findAllPOI(final String data, final
														FindAllPOIListenerCallback findAllPoiListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAddressPOI_2"
													class="TMapData_findAddressPOI_2"
													href="#android/docs/androidDoc.TMapData_findAddressPOI_2">void
														findAddressPOI(final String data, final
														FindAddressPOIListenerCallback findAddressPOIListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTitlePOI_2"
													class="TMapData_findTitlePOI_2"
													href="#android/docs/androidDoc.TMapData_findTitlePOI_2">void
														findTitlePOI(final String data, final
														FindTitlePOIListenerCallback findTitlePOIListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_getBizCategory_2"
													class="TMapData_getBizCategory_2"
													href="#android/docs/androidDoc.TMapData_getBizCategory_2">void
														getBizCategory(final BizCategoryListenerCallback
														BizCategoryListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathData_2"
													class="TMapData_findPathData_2"
													href="#android/docs/androidDoc.TMapData_findPathData_2">void
														findPathData(final TMapPoint startpoint, final TMapPoint
														endpoint, final FindPathDataListenerCallback
														findPathDataListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataAll_1"
													class="TMapData_findPathDataAll_1"
													href="#android/docs/androidDoc.TMapData_findPathDataAll_1">Document
														findPathDataAll(TMapPoint startpoint, TMapPoint endpoint)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataAll_2"
													class="TMapData_findPathDataAll_2"
													href="#android/docs/androidDoc.TMapData_findPathDataAll_2">void
														findPathDataAll(final TMapPoint startpoint, final
														TMapPoint endpoint, final FindPathDataAllListenerCallback
														findPathDataAllListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataWithType_1"
													class="TMapData_findPathDataWithType_1"
													href="#android/docs/androidDoc.TMapData_findPathDataWithType_1">TMapPolyLine
														findPathDataWithType(TMapPathType type, TMapPoint
														startpoint, TMapPoint endpoint)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataWithType_2"
													class="TMapData_findPathDataWithType_2"
													href="#android/docs/androidDoc.TMapData_findPathDataWithType_2">void
														findPathDataWithType(final TMapPathType type, final
														TMapPoint startpoint, final TMapPoint endpoint, final
														FindPathDataListenerCallback findPathDataListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataAllType"
													class="TMapData_findPathDataAllType"
													href="#android/docs/androidDoc.TMapData_findPathDataAllType">Document
														findPathDataAllType(TMapPathType type, TMapPoint
														startpoint, TMapPoint endpoint)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAllPOI_3"
													class="TMapData_findAllPOI_3"
													href="#android/docs/androidDoc.TMapData_findAllPOI_3">ArrayList<TMapPOIItem>
														findAllPOI(String data, int nSearchCount)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAllPOI_4"
													class="TMapData_findAllPOI_4"
													href="#android/docs/androidDoc.TMapData_findAllPOI_4">void
														findAllPOI(final String data, final int nSearchCount,
														final FindAllPOIListenerCallback findAllPoiListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTitlePOI_3"
													class="TMapData_findTitlePOI_3"
													href="#android/docs/androidDoc.TMapData_findTitlePOI_3">ArrayList<TMapPOIItem>
														findTitlePOI(String data, int nSearchCount)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTitlePOI_4"
													class="TMapData_findTitlePOI_4"
													href="#android/docs/androidDoc.TMapData_findTitlePOI_4">void
														findTitlePOI(final String data, final int nSearchCount,
														final FindTitlePOIListenerCallback findTitlePOIListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAddressPOI_3"
													class="TMapData_findAddressPOI_3"
													href="#android/docs/androidDoc.TMapData_findAddressPOI_3">ArrayList<TMapPOIItem>
														findAddressPOI(String data, int nSearchCount)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAddressPOI_4"
													class="TMapData_findAddressPOI_4"
													href="#android/docs/androidDoc.TMapData_findAddressPOI_4">void
														findAddressPOI(final String data, final int nSearchCount,
														final FindAddressPOIListenerCallback
														findAddressPOIListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundNamePOI_2"
													class="TMapData_findAroundNamePOI_2"
													href="#android/docs/androidDoc.TMapData_findAroundNamePOI_2">void
														findAroundNamePOI(final TMapPoint tmappoint, final String
														categoryName, final FindAroundNamePOIListenerCallback
														findAroundNamePoiListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundNamePOI_3"
													class="TMapData_findAroundNamePOI_3"
													href="#android/docs/androidDoc.TMapData_findAroundNamePOI_3">ArrayList<TMapPOIItem>
														findAroundNamePOI(TMapPoint tmappoint, String
														categoryName, int nRadius, int nSearchCount)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundNamePOI_4"
													class="TMapData_findAroundNamePOI_4"
													href="#android/docs/androidDoc.TMapData_findAroundNamePOI_4">void
														findAroundNamePOI(final TMapPoint tmappoint, final String
														categoryName, final int nRadius, final int nSearchCount,
														final FindAroundNamePOIListenerCallback
														findAroundNamePoiListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTimeMachineCarPath_1"
													class="TMapData_findTimeMachineCarPath_1"
													href="#android/docs/androidDoc.TMapData_findTimeMachineCarPath_1">Document
														findTimeMachineCarPath(HashMap<String , String>
														pathInfo, Date date, ArrayList<TMapPoint>
														wayPoint) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_reverseGeocoding_1"
													class="TMapData_reverseGeocoding_1"
													href="#android/docs/androidDoc.TMapData_reverseGeocoding_1">TMapAddressInfo
														reverseGeocoding(double lat, double lon, String
														addressType)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_reverseGeocodingListenerCallback"
													href="#android/docs/androidDoc.TMapData_reverseGeocodingListenerCallback">interface
														reverseGeocodingListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_reverseGeocoding_2"
													class="TMapData_reverseGeocoding_2"
													href="#android/docs/androidDoc.TMapData_reverseGeocoding_2">void
														reverseGeocoding(final double lat, final double lon, final
														String addressType, final reverseGeocodingListenerCallback
														addressListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundKeywordPOI_1"
													class="TMapData_findAroundKeywordPOI_1"
													href="#android/docs/androidDoc.TMapData_findAroundKeywordPOI_1">ArrayList<TMapPOIItem>
														findAroundKeywordPOI(TMapPoint tmappoint, String
														keywordName, int nRadius, int nSearchCount)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_FindAroundKeywordPOIListenerCallback"
													href="#android/docs/androidDoc.TMapData_FindAroundKeywordPOIListenerCallback">interface
														FindAroundKeywordPOIListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findAroundKeywordPOI_2"
													class="TMapData_findAroundKeywordPOI_2"
													href="#android/docs/androidDoc.TMapData_findAroundKeywordPOI_2">void
														findAroundKeywordPOI(final TMapPoint tmappoint, final
														String keywordName, final int nRadius, final int
														nSearchCount, final FindAroundKeywordPOIListenerCallback
														PoiListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_FindTimeMachineCarPathListenerCallback"
													href="#android/docs/androidDoc.TMapData_FindTimeMachineCarPathListenerCallback">interface
														FindTimeMachineCarPathListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTimeMachineCarPath_2"
													class="TMapData_findTimeMachineCarPath_2"
													href="#android/docs/androidDoc.TMapData_findTimeMachineCarPath_2">void
														findTimeMachineCarPath(final HashMap<String , String>
														pathInfo, final Date date, final ArrayList<TMapPoint>
														wayPoint,final FindTimeMachineCarPathListenerCallback
														findTimeMachineCarPathListener) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_autoComplete_1"
													class="TMapData_autoComplete_1"
													href="#android/docs/androidDoc.TMapData_autoComplete_1">ArrayList<String>
														autoComplete(String keyword)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_AutoCompleteListenerCallback"
													href="#android/docs/androidDoc.TMapData_AutoCompleteListenerCallback">interface
														AutoCompleteListenerCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_autoComplete_2"
													class="TMapData_autoComplete_2"
													href="#android/docs/androidDoc.TMapData_autoComplete_2">void
														autoComplete(final String keyword, final
														AutoCompleteListenerCallback autoCompleteListener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_OnResponseCodeInfoCallback"
													href="#android/docs/androidDoc.TMapData_OnResponseCodeInfoCallback">interface
														OnResponseCodeInfoCallback</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_setResponseCodeInfoCallBack"
													href="#android/docs/androidDoc.TMapData_setResponseCodeInfoCallBack">void
														setResponseCodeInfoCallBack(OnResponseCodeInfoCallback
														listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataWithType_3"
													class="TMapData_findPathDataWithType_3"
													href="#android/docs/androidDoc.TMapData_findPathDataWithType_3">TMapPolyLine
														findPathDataWithType(TMapPathType type, TMapPoint
														startpoint, TMapPoint endpoint, ArrayList<TMapPoint>
														passList, int searchOption) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findPathDataWithType_4"
													class="TMapData_findPathDataWithType_4"
													href="#android/docs/androidDoc.TMapData_findPathDataWithType_4">void
														findPathDataWithType(final TMapPathType type, final
														TMapPoint startpoint, final TMapPoint endpoint, final
														ArrayList<TMapPoint> passList, final int
														searchOption, final FindPathDataListenerCallback
														findPathDataListener) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTimeMachineCarPath_3"
													class="TMapData_findTimeMachineCarPath_3"
													href="#android/docs/androidDoc.TMapData_findTimeMachineCarPath_3">Document
														findTimeMachineCarPath(HashMap<String , String>
														pathInfo, Date date, ArrayList<TMapPoint>
														waypoint, String searchOption) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findTimeMachineCarPath_4"
													class="TMapData_findTimeMachineCarPath_4"
													href="#android/docs/androidDoc.TMapData_findTimeMachineCarPath_4">void
														findTimeMachineCarPath(final HashMap<String , String>
														pathInfo, final Date date, final ArrayList<TMapPoint>
														wayPoint, final String searchOption, final
														FindTimeMachineCarPathListenerCallback
														findTimeMachineCarPathListener) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findMultiPointPathData_1"
													class="TMapData_findMultiPointPathData_1"
													href="#android/docs/androidDoc.TMapData_findMultiPointPathData_1">TMapPolyLine
														findMultiPointPathData(TMapPoint startpoint, TMapPoint
														endpoint, ArrayList<TMapPoint> passList, int
														searchOption) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapData_findMultiPointPathData_2"
													class="TMapData_findMultiPointPathData_2"
													href="#android/docs/androidDoc.TMapData_findMultiPointPathData_2">void
														findMultiPointPathData(final TMapPoint startpoint, final
														TMapPoint endpoint, final ArrayList<TMapPoint>
														passList, final int searchOption, final
														FindPathDataListenerCallback findPathDataListener) 
												</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapTapi"
												href="#android/docs/androidDoc.TMapTapi">TMapTapi</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapTapi_setSKTMapAuthentication"
													href="#android/docs/androidDoc.TMapTapi_setSKTMapAuthentication">void
														setSKTMapAuthentication(String apiKey)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_setOnAuthenticationListener"
													href="#android/docs/androidDoc.TMapTapi_setOnAuthenticationListener">void
														setOnAuthenticationListener(OnAuthenticationListenerCallback
														listener)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_SKTMapApikeySucceed"
													href="#android/docs/androidDoc.TMapTapi_SKTMapApikeySucceed">void
														SKTMapApikeySucceed()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_SKTMapApikeyFailed"
													href="#android/docs/androidDoc.TMapTapi_SKTMapApikeyFailed">void
														SKTMapApikeyFailed(String errorMsg)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeRoute"
													href="#android/docs/androidDoc.TMapTapi_invokeRoute">Boolean
														invokeRoute(String szDestName, float fX, float fY)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeSetLocation"
													href="#android/docs/androidDoc.TMapTapi_invokeSetLocation">Boolean
														invokeSetLocation(String szDestName, float fX, float fY)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeSafeDrive"
													href="#android/docs/androidDoc.TMapTapi_invokeSafeDrive">Boolean
														invokeSafeDrive()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeSearchPortal"
													href="#android/docs/androidDoc.TMapTapi_invokeSearchPortal">Boolean
														invokeSearchPortal(String szDestName)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_isTmapApplicationInstalled"
													href="#android/docs/androidDoc.TMapTapi_isTmapApplicationInstalled">Boolean
														isTmapApplicationInstalled()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeGoHome"
													href="#android/docs/androidDoc.TMapTapi_invokeGoHome">Boolean
														invokeGoHome()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeGoCompany"
													href="#android/docs/androidDoc.TMapTapi_invokeGoCompany">Boolean
														invokeGoCompany()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeRoute_2"
													href="#android/docs/androidDoc.TMapTapi_invokeRoute_2">Boolean
														invokeRoute(HashMap<String , String> routeInfo) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_getTMapDownUrl"
													href="#android/docs/androidDoc.TMapTapi_getTMapDownUrl">ArrayList<String>
														getTMapDownUrl()</a></li>
												<li><a id="android_docs_androidDoc_TMapTapi_invokeTmap"
													href="#android/docs/androidDoc.TMapTapi_invokeTmap">ArrayList<String>
														invokeTmap()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapTapi_invokeNavigate"
													href="#android/docs/androidDoc.TMapTapi_invokeNavigate">Boolean
														invokeNavigate(String szDestName, float fX, float fY, int
														poiid, boolean isAutoClose)</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapOverlay"
												href="#android/docs/androidDoc.TMapOverlay">TMapOverlay</a></span>
											<ul style="display: none">
												<li><a id="android_docs_androidDoc_TMapOverlay_draw"
													href="#android/docs/androidDoc.TMapOverlay_draw">boolean
														draw(Canvas canvas, TMapView mapView, boolean showCallout)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapOverlay_onSingleTapUp"
													href="#android/docs/androidDoc.TMapOverlay_onSingleTapUp">boolean
														onSingleTapUp(PointF p, TMapView mapView)</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapMarkerItem2"
												href="#android/docs/androidDoc.TMapMarkerItem2">TMapMarkerItem2</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setTMapPoint"
													class="TMapMarkerItem2_setTMapPoint"
													href="#android/docs/androidDoc.TMapMarkerItem2_setTMapPoint">void
														setTMapPoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getTMapPoint"
													class="TMapMarkerItem2_getTMapPoint"
													href="#android/docs/androidDoc.TMapMarkerItem2_getTMapPoint">TMapPoint
														getTMapPoint()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setIcon"
													class="TMapMarkerItem2_setIcon"
													href="#android/docs/androidDoc.TMapMarkerItem2_setIcon">void
														setIcon(Bitmap bitmap)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getIcon"
													class="TMapMarkerItem2_getIcon"
													href="#android/docs/androidDoc.TMapMarkerItem2_getIcon">Bitmap
														getIcon()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getID"
													class="TMapMarkerItem2_getID"
													href="#android/docs/androidDoc.TMapMarkerItem2_getID">String
														getID()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setID"
													class="TMapMarkerItem2_setID"
													href="#android/docs/androidDoc.TMapMarkerItem2_setID">void
														setID(String id)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setAnimationIcons"
													class="TMapMarkerItem2_setAnimationIcons"
													href="#android/docs/androidDoc.TMapMarkerItem2_setAnimationIcons">void
														setAnimationIcons(ArrayList<Bitmap> list) 
												</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getAnimationIcons"
													class="TMapMarkerItem2_getAnimationIcons"
													href="#android/docs/androidDoc.TMapMarkerItem2_getAnimationIcons">ArrayList<Bitmap>
														getAnimationIcons()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setAniDuration"
													class="TMapMarkerItem2_setAniDuration"
													href="#android/docs/androidDoc.TMapMarkerItem2_setAniDuration">void
														setAniDuration(int nDurationTime)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getAniDuration"
													class="TMapMarkerItem2_getAniDuration"
													href="#android/docs/androidDoc.TMapMarkerItem2_getAniDuration">int
														getAniDuration()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setPosition"
													class="TMapMarkerItem2_setPosition"
													href="#android/docs/androidDoc.TMapMarkerItem2_setPosition">void
														setPosition(float dx, float dy)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getPositionX"
													class="TMapMarkerItem2_getPositionX"
													href="#android/docs/androidDoc.TMapMarkerItem2_getPositionX">float
														getPositionX()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getPositionY"
													class="TMapMarkerItem2_getPositionY"
													href="#android/docs/androidDoc.TMapMarkerItem2_getPositionY">float
														getPositionY()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_startAnimation"
													class="TMapMarkerItem2_startAnimation"
													href="#android/docs/androidDoc.TMapMarkerItem2_startAnimation">void
														startAnimation()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_setCalloutRect"
													class="TMapMarkerItem2_setCalloutRect"
													href="#android/docs/androidDoc.TMapMarkerItem2_setCalloutRect">void
														setCalloutRect(Rect rect)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapMarkerItem2_getCalloutRect"
													class="TMapMarkerItem2_getCalloutRect"
													href="#android/docs/androidDoc.TMapMarkerItem2_getCalloutRect">Rect
														getCalloutRect()</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapOverlayItem"
												href="#android/docs/androidDoc.TMapOverlayItem">TMapOverlayItem</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapOverlayItem_setImage"
													href="#android/docs/androidDoc.TMapOverlayItem_setImage">void
														setImage(Bitmap bitmap)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapOverlayItem_setLeftTopPoint"
													href="#android/docs/androidDoc.TMapOverlayItem_setLeftTopPoint">void
														setLeftTopPoint(TMapPoint point)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapOverlayItem_setRightBottomPoint"
													href="#android/docs/androidDoc.TMapOverlayItem_setRightBottomPoint">void
														setRightBottomPoint(TMapPoint point)</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="android_docs_androidDoc_TMapBesselPoint"
												href="#android/docs/androidDoc.TMapBesselPoint">TMapBesselPoint</a></span>
											<ul style="display: none">
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_setX"
													href="#android/docs/androidDoc.TMapBesselPoint_setX">void
														setX(double x)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_setY"
													href="#android/docs/androidDoc.TMapBesselPoint_setY">void
														setY(double y)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_getX"
													href="#android/docs/androidDoc.TMapBesselPoint_getX">void
														getX()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_getY"
													href="#android/docs/androidDoc.TMapBesselPoint_getY">void
														getY()</a></li>
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_convertToWgs_t"
													href="#android/docs/androidDoc.TMapBesselPoint_convertToWgs_t">TMapPoint
														convertToWgs(TMapBesselPoint besselPoint)</a></li>
												<li><a
													id="android_docs_androidDoc_TMapBesselPoint_convertToWgs_a"
													href="#android/docs/androidDoc.TMapBesselPoint_convertToWgs_a">ArrayList
														convertToWgs(ArrayList alBesselPoint)</a></li>
											</ul></li>
									</ul></li>
							</ul></li>

						<li style="background: none"><span id="tit_iOS"
							class="tit tit_ico_ios">iOS</span>
							<ul>
								<li><span class="">Guide</span>
									<ul style="display: none">
										<li><a id="ios_guide_iosGuide_sample1"
											href="#ios/guide/iosGuide.sample1">T map SDK 소개</a></li>
										<li><a id="ios_guide_iosGuide_sample2"
											href="#ios/guide/iosGuide.sample2">T map SDK package 구조</a></li>
										<li><a id="ios_guide_iosGuide_sample3"
											href="#ios/guide/iosGuide.sample3">IOS SDK 개발준비</a></li>
										<li><a id="ios_guide_iosGuide_sample4"
											href="#ios/guide/iosGuide.sample4">환경설정</a></li>
										<li><a id="ios_guide_iosGuide_sample5"
											href="#ios/guide/iosGuide.sample5">Tmap API SDK추가하기</a></li>
										<li><a id="ios_guide_iosGuide_sample6"
											href="#ios/guide/iosGuide.sample6">API Key 발급</a></li>
										<li><a id="ios_guide_iosGuide_sample7"
											href="#ios/guide/iosGuide.sample7">API Key 설정</a></li>
										<li><a id="ios_guide_iosGuide_sample8"
											href="#ios/guide/iosGuide.sample8">좌표계</a></li>
									</ul></li>

								<li><span class="">Sample</span>
									<ul style="display: none">
										<li><a id="ios_sample_iosSample_sdk_download"
											href="#ios/sample/iosSample.sdk_download">SDK 다운로드</a></li>
										<li><a id="ios_sample_iosSample_sample1"
											href="#ios/sample/iosSample.sample1">지도 생성하기</a></li>
										<li><a id="ios_sample_iosSample_sample2"
											href="#ios/sample/iosSample.sample2">지도 이벤트 설정하기</a></li>
										<li><a id="ios_sample_iosSample_sample3"
											href="#ios/sample/iosSample.sample3">지도 중심점 및 레벨 변경하기</a></li>
										<li><a id="ios_sample_iosSample_sample4"
											href="#ios/sample/iosSample.sample4">마커 생성하기</a></li>
										<li><a id="ios_sample_iosSample_sample5"
											href="#ios/sample/iosSample.sample5">선 그리기</a></li>
										<li><a id="ios_sample_iosSample_sample6"
											href="#ios/sample/iosSample.sample6">Polygon 그리기</a></li>
										<li><a id="ios_sample_iosSample_sample7"
											href="#ios/sample/iosSample.sample7">Circle 그리기</a></li>
										<li><a id="ios_sample_iosSample_sample8"
											href="#ios/sample/iosSample.sample8">자동차 경로안내</a></li>
										<li><a id="ios_sample_iosSample_sample9"
											href="#ios/sample/iosSample.sample9">리버스 지오코딩</a></li>
										<li><a id="ios_sample_iosSample_sample10"
											href="#ios/sample/iosSample.sample10">명칭(POI) 통합 검색</a></li>
										<li><a id="ios_sample_iosSample_sample13"
											href="#ios/sample/iosSample.sample13">TMapApp 길안내</a></li>
										<li><a id="ios_sample_iosSample_sample14"
											href="#ios/sample/iosSample.sample14">TMapApp 지도이동</a></li>
										<li><a id="ios_sample_iosSample_sample15"
											href="#ios/sample/iosSample.sample15">TMapApp 통합검색</a></li>
										<li><a id="ios_sample_iosSample_sample16"
											href="#ios/sample/iosSample.sample16">TMapApp 집으로</a></li>
										<li><a id="ios_sample_iosSample_sample17"
											href="#ios/sample/iosSample.sample17">TMapApp 회사로</a></li>
										<li><a id="ios_sample_iosSample_sample18"
											href="#ios/sample/iosSample.sample18">TMapApp 길안내(경유지포함)</a></li>
									</ul></li>

								<li><span class="">Docs</span>
									<ul style="display: none">
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapView"
												href="#ios/docs/iosDoc.TMapView">TMapView</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapView_setSKTMapApiKey"
													href="#ios/docs/iosDoc.TMapView_setSKTMapApiKey">-
														(void)setSKTMapApiKey:(NSString*)key</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setHttpsMode"
													href="#ios/docs/iosDoc.TMapView_setHttpsMode">-
														(void)setHttpsMode:(BOOL)isActive</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setCenterPoint"
													href="#ios/docs/iosDoc.TMapView_setCenterPoint">-
														(void)setCenterPoint:(TMapPoint*)tmp</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setLocationPoint"
													href="#ios/docs/iosDoc.TMapView_setLocationPoint">-
														(void)setLocationPoint:(TMapPoint*)tmp</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getLocationPoint"
													href="#ios/docs/iosDoc.TMapView_getLocationPoint">-
														(TMapPoint*)getLocationPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setIcon"
													href="#ios/docs/iosDoc.TMapView_setIcon">-
														(void)setIcon:(UIImage *)icon</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setIconVisibility"
													href="#ios/docs/iosDoc.TMapView_setIconVisibility">-
														(void)setIconVisibility:(BOOL)visible</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setZoomLevel"
													href="#ios/docs/iosDoc.TMapView_setZoomLevel">-
														(void)setZoomLevel:(NSInteger)level</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getZoomLevel"
													href="#ios/docs/iosDoc.TMapView_getZoomLevel">-
														(NSInteger)getZoomLevel</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_zoomIn"
													href="#ios/docs/iosDoc.TMapView_zoomIn">- (void)zoomIn</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_zoomOut"
													href="#ios/docs/iosDoc.TMapView_zoomOut">-
														(void)zoomOut</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_zoomEnable"
													href="#ios/docs/iosDoc.TMapView_zoomEnable">-
														(bool)zoomEnable</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setCompassMode"
													href="#ios/docs/iosDoc.TMapView_setCompassMode">-
														(void)setCompassMode:(BOOL)compassMode</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getIsCompass"
													href="#ios/docs/iosDoc.TMapView_getIsCompass">-
														(BOOL)getIsCompass</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setSightVisible"
													href="#ios/docs/iosDoc.TMapView_setSightVisible">-
														(void)setSightVisible:(BOOL)flag</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getSightVisible"
													href="#ios/docs/iosDoc.TMapView_getSightVisible">-
														(BOOL)getSightVisible</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setTrackingMode"
													href="#ios/docs/iosDoc.TMapView_setTrackingMode">-
														(void)setTrackingMode:(BOOL)trackingMode</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getIsTracking"
													href="#ios/docs/iosDoc.TMapView_getIsTracking">-
														(BOOL)getIsTracking</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_onCustomObjectLongClick"
													href="#ios/docs/iosDoc.TMapView_onCustomObjectLongClick">-
														(void)onCustomObjectLongClick:(TMapObject*)obj
														screenPoint:(CGPoint)point</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapCircleID"
													href="#ios/docs/iosDoc.TMapView_addTMapCircleID">-
														(void)addTMapCircleID:(NSString *)circleID
														Circle:(TMapCircle *)circle</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_removeTMapCircleID"
													href="#ios/docs/iosDoc.TMapView_removeTMapCircleID">-
														(void)removeTMapCircleID:(NSString *)circleID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeAllTMapCircles"
													href="#ios/docs/iosDoc.TMapView_removeAllTMapCircles">-
														(void)removeAllTMapCircles</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapPolygonID"
													href="#ios/docs/iosDoc.TMapView_addTMapPolygonID">-
														(void)addTMapPolygonID:(NSString *)polygonID
														Polygon:(TMapPolygon *)polygon</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeTMapPolygonID"
													href="#ios/docs/iosDoc.TMapView_removeTMapPolygonID">-
														(void)removeTMapPolygonID:(NSString *)polygonID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeAllTMapPolygons"
													href="#ios/docs/iosDoc.TMapView_removeAllTMapPolygons">-
														(void)removeAllTMapPolygons</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapPolyLineID"
													href="#ios/docs/iosDoc.TMapView_addTMapPolyLineID">-
														(void)addTMapPolyLineID:(NSString *)polyLineID
														Line:(TMapPolyLine *)line</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeTMapPolyLineID"
													href="#ios/docs/iosDoc.TMapView_removeTMapPolyLineID">-
														(void)removeTMapPolyLineID:(NSString *)polyLineID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeAllTMapPolyLines"
													href="#ios/docs/iosDoc.TMapView_removeAllTMapPolyLines">-
														(void)removeAllTMapPolyLines</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_addTMapMarkerItemID"
													href="#ios/docs/iosDoc.TMapView_addTMapMarkerItemID">-
														(void)addTMapMarkerItemID:(NSString *)markerID
														Marker:(TMapMarkerItem *)marker</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeTMapMarkerItemID"
													href="#ios/docs/iosDoc.TMapView_removeTMapMarkerItemID">-
														(void)removeTMapMarkerItemID:(NSString *)markerID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeAllTMapMarkerItems"
													href="#ios/docs/iosDoc.TMapView_removeAllTMapMarkerItems">-
														(void)removeAllTMapMarkerItems</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapPOIItemID"
													href="#ios/docs/iosDoc.TMapView_addTMapPOIItemID">-
														(void)addTMapPOIItemID:(NSString *)poiID Poi:(TMapPOIItem
														*)poiitem</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeTMapPOIItemID"
													href="#ios/docs/iosDoc.TMapView_removeTMapPOIItemID">-
														(void)removeTMapPOIItemID:(NSString *)poiID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapPath"
													href="#ios/docs/iosDoc.TMapView_addTMapPath">-
														(void)addTMapPath:(TMapPolyLine *)polyline</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_removeTMapPath"
													href="#ios/docs/iosDoc.TMapView_removeTMapPath">-
														(void)removeTMapPath</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_setTMapPathIconStart"
													href="#ios/docs/iosDoc.TMapView_setTMapPathIconStart">-
														(void)setTMapPathIconStart:(TMapMarkerItem *)start
														End:(TMapMarkerItem *)end</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_onLongClick"
													href="#ios/docs/iosDoc.TMapView_onLongClick">-
														(void)onLongClick:(TMapPoint*)TMP</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_onClick"
													href="#ios/docs/iosDoc.TMapView_onClick">-
														(void)onClick:(TMapPoint*)TMP</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_getMarketItemFromID"
													href="#ios/docs/iosDoc.TMapView_getMarketItemFromID">-
														(TMapMarkerItem *)getMarketItemFromID:(NSString *)markerID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getPolyLineFromID"
													href="#ios/docs/iosDoc.TMapView_getPolyLineFromID">-
														(TMapPolyLine *)getPolyLineFromID:(NSString *)polyLineID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getPolygonFromID"
													href="#ios/docs/iosDoc.TMapView_getPolygonFromID">-
														(TMapPolygon *)getPolygonFromID:(NSString *)polygonID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getCircleFromID"
													href="#ios/docs/iosDoc.TMapView_getCircleFromID">-
														(TMapCircle *)getCircleFromID:(NSString *)circleID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_convertPointToGpsX"
													href="#ios/docs/iosDoc.TMapView_convertPointToGpsX">-
														(TMapPoint *)convertPointToGpsX:(float)x andY:(float)y</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getCenterPoint"
													href="#ios/docs/iosDoc.TMapView_getCenterPoint">-
														(TMapPoint*)getCenterPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setTMapTileType"
													href="#ios/docs/iosDoc.TMapView_setTMapTileType">-
														(void)setTMapTileType:(TMapTileType)tileType</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_tmapTileType"
													href="#ios/docs/iosDoc.TMapView_tmapTileType">-
														(TMapTileType)tmapTileType</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_getTMapPointFromScreenPoint"
													href="#ios/docs/iosDoc.TMapView_getTMapPointFromScreenPoint">-
														(TMapPoint*)getTMapPointFromScreenPoint:(CGPoint)screenPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_bringMarkerToFront"
													href="#ios/docs/iosDoc.TMapView_bringMarkerToFront">-
														(void)bringMarkerToFront:(TMapMarkerItem *)item</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_sendMarkerToBack"
													href="#ios/docs/iosDoc.TMapView_sendMarkerToBack">-
														(void)sendMarkerToBack:(TMapMarkerItem *)item</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getDisplayTMapInfo"
													href="#ios/docs/iosDoc.TMapView_getDisplayTMapInfo">-
														(TMapInfo*)getDisplayTMapInfo:(NSArray*)points</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_onCalloutRightbuttonClick"
													href="#ios/docs/iosDoc.TMapView_onCalloutRightbuttonClick">-
														(void)onCalloutRightbuttonClick:
														(TMapMarkerItem*)markerItem</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_setEnableClustering"
													href="#ios/docs/iosDoc.TMapView_setEnableClustering">-
														(void)setEnableClustering:(BOOL)enable</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_setClusteringIcon"
													href="#ios/docs/iosDoc.TMapView_setClusteringIcon">-
														(void)setClusteringIcon:(UIImage*)icon
														anchorPoint:(CGPoint)point</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getCaptureImage"
													href="#ios/docs/iosDoc.TMapView_getCaptureImage">-
														(UIImage*)getCaptureImage</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_setUserScrollZoomEnable"
													href="#ios/docs/iosDoc.TMapView_setUserScrollZoomEnable">-
														(void)setUserScrollZoomEnable:(BOOL)enable</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_isValidTMapPoint"
													href="#ios/docs/iosDoc.TMapView_isValidTMapPoint">-
														(BOOL)isValidTMapPoint:(TMapPoint*)tmp</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_getMarketItem2FromID"
													href="#ios/docs/iosDoc.TMapView_getMarketItem2FromID">-
														(TMapMarkerItem2 *)getMarketItem2FromID:(NSString
														*)markerID</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getLeftTopPoint"
													href="#ios/docs/iosDoc.TMapView_getLeftTopPoint">-
														(TMapPoint*)getLeftTopPoint</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_getRightBottomPoint"
													href="#ios/docs/iosDoc.TMapView_getRightBottomPoint">-
														(TMapPoint*)getRightBottomPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_getMetersToPixel"
													href="#ios/docs/iosDoc.TMapView_getMetersToPixel">-
														(int)getMetersToPixel:(double) meters</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_addTMapOverlayID"
													href="#ios/docs/iosDoc.TMapView_addTMapOverlayID">-
														(void)addTMapOverlayID:(NSString*)overlayID
														overlayItem:(TMapOverlayItem*)overlayItem</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_removeTMapOverlayID"
													href="#ios/docs/iosDoc.TMapView_removeTMapOverlayID">-
														(void)removeTMapOverlayID:(NSString*)overlayID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_getOverlayItemFromID"
													href="#ios/docs/iosDoc.TMapView_getOverlayItemFromID">-
														(TMapOverlayItem *)getOverlayItemFromID:(NSString
														*)overlayID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_setTMapLogoPosition"
													href="#ios/docs/iosDoc.TMapView_setTMapLogoPosition">-
														(void)setTMapLogoPosition:(TMapLogoPositon)logoPosition</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_zoomToLatSpan"
													href="#ios/docs/iosDoc.TMapView_zoomToLatSpan">-
														(void)zoomToLatSpan:(double)latSpan
														lonSpan:(double)lonSpan</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_zoomToTMapPointLeftTop"
													href="#ios/docs/iosDoc.TMapView_zoomToTMapPointLeftTop">-
														(void)zoomToTMapPointLeftTop:(TMapPoint*)leftTop
														rightBottom:(TMapPoint*)rightBottom</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_SKTMapApikeySucceed"
													href="#ios/docs/iosDoc.TMapView_SKTMapApikeySucceed">-
														(void)SKTMapApikeySucceed</a></li>
												<li><a id="ios_docs_iosDoc_TMapView_SKTMapApikeyFailed"
													href="#ios/docs/iosDoc.TMapView_SKTMapApikeyFailed">-
														(void)SKTMapApikeyFailed:(NSError*)error</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_onClickReverseLabelInfo"
													href="#ios/docs/iosDoc.TMapView_onClickReverseLabelInfo">-
														(void)onClickReverseLabelInfo:(NSDictionary*)labelInfo</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapView_setTMapPathIconStart_2"
													href="#ios/docs/iosDoc.TMapView_setTMapPathIconStart_2">-
														(void)setTMapPathIconStart:(TMapMarkerItem *)start
														end:(TMapMarkerItem *)end pass:(TMapMarkerItem *)pass</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapPoint"
												href="#ios/docs/iosDoc.TMapPoint">TMapPoint</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapPoint_setLatitude"
													href="#ios/docs/iosDoc.TMapPoint_setLatitude">-
														(void)setLatitude:(double)lat</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoint_getLatitude"
													href="#ios/docs/iosDoc.TMapPoint_getLatitude">-
														(double)getLatitude</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoint_getKatechLat"
													href="#ios/docs/iosDoc.TMapPoint_getKatechLat">-
														(double)getKatechLat</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoint_setLongitude"
													href="#ios/docs/iosDoc.TMapPoint_setLongitude">-
														(void)setLongitude:(double)lon</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoint_getLongitude"
													href="#ios/docs/iosDoc.TMapPoint_getLongitude">-
														(double)getLongitude</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoint_getKatechLon"
													href="#ios/docs/iosDoc.TMapPoint_getKatechLon">-
														(double)getKatechLon</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapMarkerItem"
												href="#ios/docs/iosDoc.TMapMarkerItem">TMapMarkerItem</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_setTMapPoint"
													href="#ios/docs/iosDoc.TMapMarkerItem_setTMapPoint">-
														(void)setTMapPoint:(TMapPoint *)_point</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_getTMapPoint"
													href="#ios/docs/iosDoc.TMapMarkerItem_getTMapPoint">-
														(TMapPoint*)getTMapPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_setName"
													href="#ios/docs/iosDoc.TMapMarkerItem_setName">-
														(void)setName:(NSString*)_name</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_getName"
													href="#ios/docs/iosDoc.TMapMarkerItem_getName">-
														(NSString*)getName</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_setVisible"
													href="#ios/docs/iosDoc.TMapMarkerItem_setVisible">-
														(void)setVisible:(BOOL)visible</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_getVisible"
													href="#ios/docs/iosDoc.TMapMarkerItem_getVisible">-
														(BOOL)getVisible</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_setIcon"
													href="#ios/docs/iosDoc.TMapMarkerItem_setIcon">-
														(void)setIcon:(UIImage *)icon</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem_getID"
													href="#ios/docs/iosDoc.TMapMarkerItem_getID">-
														(NSString*)getID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setCanShowCallout"
													href="#ios/docs/iosDoc.TMapMarkerItem_setCanShowCallout">-
														(void)setCanShowCallout:(BOOL)show</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setCalloutTitle"
													href="#ios/docs/iosDoc.TMapMarkerItem_setCalloutTitle">-
														(void)setCalloutTitle:(NSString*)title</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setCalloutSubtitle"
													href="#ios/docs/iosDoc.TMapMarkerItem_setCalloutSubtitle">-
														(void)setCalloutSubtitle:(NSString*)subtitle</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setCalloutLeftImage"
													href="#ios/docs/iosDoc.TMapMarkerItem_setCalloutLeftImage">-
														(void)setCalloutLeftImage:(UIImage*)image</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setCalloutRightButtonImage"
													href="#ios/docs/iosDoc.TMapMarkerItem_setCalloutRightButtonImage">-
														(void)setCalloutRightButtonImage:(UIImage*)image</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setEnableClustering"
													href="#ios/docs/iosDoc.TMapMarkerItem_setEnableClustering">-
														(void)setEnableClustering:(BOOL)enable</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem_setAutoCalloutVisible"
													href="#ios/docs/iosDoc.TMapMarkerItem_setAutoCalloutVisible">-
														(void)setAutoCalloutVisible:(BOOL)visible</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapPolyLine"
												href="#ios/docs/iosDoc.TMapPolyLine">TMapPolyLine</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapPolyLine_setLineColor"
													href="#ios/docs/iosDoc.TMapPolyLine_setLineColor">-
														(void)setLineColor:(CGColorRef)_color</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_getLineColor"
													href="#ios/docs/iosDoc.TMapPolyLine_getLineColor">-
														(CGColorRef)getLineColor</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_setLineWidth"
													href="#ios/docs/iosDoc.TMapPolyLine_setLineWidth">-
														(void)setLineWidth:(float)_width</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_getLineWidth"
													href="#ios/docs/iosDoc.TMapPolyLine_getLineWidth">-
														(float)getLineWidth</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_addLinePoint"
													href="#ios/docs/iosDoc.TMapPolyLine_addLinePoint">-
														(void)addLinePoint:(TMapPoint *)point</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_getLinePoint"
													href="#ios/docs/iosDoc.TMapPolyLine_getLinePoint">-
														(NSArray *)getLinePoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolyLine_getDistance"
													href="#ios/docs/iosDoc.TMapPolyLine_getDistance">-
														(double) getDistance</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolyLine_setLineDashPattern"
													href="#ios/docs/iosDoc.TMapPolyLine_setLineDashPattern">-
														(void)setLineDashPattern:(NSArray*)lineDashParttern</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolyLine_getLineDashPattern"
													href="#ios/docs/iosDoc.TMapPolyLine_getLineDashPattern">-
														(NSArray *)getLineDashPattern</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapPolygon"
												href="#ios/docs/iosDoc.TMapPolygon">TMapPolygon</a></span>
											<ul style="display: none">
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_setPolygonAreaColor"
													href="#ios/docs/iosDoc.TMapPolygon_setPolygonAreaColor">-
														(void)setPolygonAreaColor:(CGColorRef)_color</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_getPolygonAreaColor"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonAreaColor">-
														(CGColorRef)getPolygonAreaColor</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_setPolygonLineColor"
													href="#ios/docs/iosDoc.TMapPolygon_setPolygonLineColor">-
														(void)setPolygonLineColor:(CGColorRef)_color</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_getPolygonLineColor"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonLineColor">-
														(CGColorRef)getPolygonLineColor</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_setPolygonLineWidth"
													href="#ios/docs/iosDoc.TMapPolygon_setPolygonLineWidth">-
														(void)setPolygonLineWidth:(float)_width</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_getPolygonLineWidth"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonLineWidth">-
														(float)getPolygonLineWidth</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolygon_setPolygonAlpha"
													href="#ios/docs/iosDoc.TMapPolygon_setPolygonAlpha">-
														(void)setPolygonAlpha:(int)alpha</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolygon_getPolygonAlpha"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonAlpha">-
														(int)getPolygonAlpha</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_setPolygonLineAlpha"
													href="#ios/docs/iosDoc.TMapPolygon_setPolygonLineAlpha">-
														(void)setPolygonLineAlpha:(int)alpha</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPolygon_getPolygonLineAlpha"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonLineAlpha">-
														(int)getPolygonLineAlpha</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolygon_addPolygonPoint"
													href="#ios/docs/iosDoc.TMapPolygon_addPolygonPoint">-
														(void)addPolygonPoint:(TMapPoint *)point</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolygon_getPolygonPoint"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonPoint">-
														(NSArray *)getPolygonPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapPolygon_getPolygonArea"
													href="#ios/docs/iosDoc.TMapPolygon_getPolygonArea">-
														(double)getPolygonArea</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapCircle"
												href="#ios/docs/iosDoc.TMapCircle">TMapCircle</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapCircle_setCenterPoint"
													href="#ios/docs/iosDoc.TMapCircle_setCenterPoint">-
														(void)setCenterPoint:(TMapPoint *)_point</a></li>
												<li><a id="ios_docs_iosDoc_TMapCircle_getCenterPoint"
													href="#ios/docs/iosDoc.TMapCircle_getCenterPoint">-
														(TMapPoint *)getCenterPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapCircle_setCircleRadius"
													href="#ios/docs/iosDoc.TMapCircle_setCircleRadius">-
														(void)setCircleRadius:(int)_radius</a></li>
												<li><a id="ios_docs_iosDoc_TMapCircle_getCircleRadius"
													href="#ios/docs/iosDoc.TMapCircle_getCircleRadius">-
														(int)getCircleRadius</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_setCircleAreaColor"
													href="#ios/docs/iosDoc.TMapCircle_setCircleAreaColor">-
														(void)setCircleAreaColor:(CGColorRef)_color</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_getCircleAreaColor"
													href="#ios/docs/iosDoc.TMapCircle_getCircleAreaColor">-
														(CGColorRef)getCircleAreaColor</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_setCircleLineColor"
													href="#ios/docs/iosDoc.TMapCircle_setCircleLineColor">-
														(void)setCircleLineColor:(CGColorRef)_color</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_getCircleLineColor"
													href="#ios/docs/iosDoc.TMapCircle_getCircleLineColor">-
														(CGColorRef)getCircleLineColor</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_setCircleLineWidth"
													href="#ios/docs/iosDoc.TMapCircle_setCircleLineWidth">-
														(void)setCircleLineWidth:(float)_width</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_getCircleLineWidth"
													href="#ios/docs/iosDoc.TMapCircle_getCircleLineWidth">-
														(float)getCircleLineWidth</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_setCircleAreaAlpha"
													href="#ios/docs/iosDoc.TMapCircle_setCircleAreaAlpha">-
														(void)setCircleAreaAlpha:(int)alpha</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_getCircleAreaAlpha"
													href="#ios/docs/iosDoc.TMapCircle_getCircleAreaAlpha">-
														(int)getCircleAreaAlpha</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_setCircleLineAlpha"
													href="#ios/docs/iosDoc.TMapCircle_setCircleLineAlpha">-
														(void)setCircleLineAlpha:(int)alpha</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapCircle_getCircleLineAlpha"
													href="#ios/docs/iosDoc.TMapCircle_getCircleLineAlpha">-
														(int)getCircleLineAlpha</a></li>
												<li><a id="ios_docs_iosDoc_TMapCircle_setRadiusVisible"
													href="#ios/docs/iosDoc.TMapCircle_setRadiusVisible">-
														(void)setRadiusVisible:(bool)flag</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapGpsManager"
												href="#ios/docs/iosDoc.TMapGpsManager">TMapGpsManager</a></span>
											<ul style="display: none">
												<li><a
													id="ios_docs_iosDoc_TMapGpsManager_locationChanged"
													href="#ios/docs/iosDoc.TMapGpsManager_locationChanged">-
														(void)locationChanged:(TMapPoint*)newTmp</a></li>
												<li><a id="ios_docs_iosDoc_TMapGpsManager_openGps"
													href="#ios/docs/iosDoc.TMapGpsManager_openGps">-
														(void)openGps</a></li>
												<li><a id="ios_docs_iosDoc_TMapGpsManager_closeGps"
													href="#ios/docs/iosDoc.TMapGpsManager_closeGps">-
														(void)closeGps</a></li>
												<li><a id="ios_docs_iosDoc_TMapGpsManager_setMinTime"
													href="#ios/docs/iosDoc.TMapGpsManager_setMinTime">-
														(void)setMinTime:(int)mintime</a></li>
												<li><a id="ios_docs_iosDoc_TMapGpsManager_getMinTime"
													href="#ios/docs/iosDoc.TMapGpsManager_getMinTime">-
														(int)getMinTime</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapGpsManager_setMinDistance"
													href="#ios/docs/iosDoc.TMapGpsManager_setMinDistance">-
														(void)setMinDistance:(int)mindistance</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapGpsManager_getMinDistance"
													href="#ios/docs/iosDoc.TMapGpsManager_getMinDistance">-
														(int)getMinDistance</a></li>
												<li><a id="ios_docs_iosDoc_TMapGpsManager_getLocation"
													href="#ios/docs/iosDoc.TMapGpsManager_getLocation">-
														(TMapPoint*)getLocation</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapGpsManager_setAlwaysAuthorization"
													href="#ios/docs/iosDoc.TMapGpsManager_setAlwaysAuthorization">-
														(void)setAlwaysAuthorization:(BOOL)alwaysAuthorization</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapPoiItem"
												href="#ios/docs/iosDoc.TMapPoiItem">TMapPoiItem</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getPOIID"
													href="#ios/docs/iosDoc.TMapPoiItem_getPOIID">-
														(NSString*)getPOIID</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getPOIName"
													href="#ios/docs/iosDoc.TMapPoiItem_getPOIName">-
														(NSString*)getPOIName</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getPOIPoint"
													href="#ios/docs/iosDoc.TMapPoiItem_getPOIPoint">-
														(TMapPoint*)getPOIPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getPOIAddress"
													href="#ios/docs/iosDoc.TMapPoiItem_getPOIAddress">-
														(NSString*)getPOIAddress</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getPOIContent"
													href="#ios/docs/iosDoc.TMapPoiItem_getPOIContent">-
														(NSString*)getPOIContent</a></li>
												<li><a id="ios_docs_iosDoc_TMapPoiItem_getDistance"
													href="#ios/docs/iosDoc.TMapPoiItem_getDistance">-
														(double)getDistance:(TMapPoint*)compareTmp</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapPathData"
												href="#ios/docs/iosDoc.TMapPathData">TMapPathData</a></span>
											<ul style="display: none">
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindAllPOI"
													href="#ios/docs/iosDoc.TMapPathData_requestFindAllPOI">-
														(NSArray*)requestFindAllPOI:(NSString *)keyword</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindTitlePOI"
													href="#ios/docs/iosDoc.TMapPathData_requestFindTitlePOI">-
														(NSArray*)requestFindTitlePOI:(NSString*)keyword</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindAddressPOI"
													href="#ios/docs/iosDoc.TMapPathData_requestFindAddressPOI">-
														(NSArray*)requestFindAddressPOI:(NSString*)keyword</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindNameAroundPOI"
													href="#ios/docs/iosDoc.TMapPathData_requestFindNameAroundPOI">-
														(NSArray*)requestFindNameAroundPOI:(TMapPoint*)point
														categoryName:(NSString *)categoryName
														radius:(NSInteger)radius
														resultCount:(NSInteger)resultCount</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_findPathDataFrom"
													href="#ios/docs/iosDoc.TMapPathData_findPathDataFrom">-
														(TMapPolyLine *)findPathDataFrom:(TMapPoint*)startPoint
														to:(TMapPoint*)endPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapPathData_getBizCategory"
													href="#ios/docs/iosDoc.TMapPathData_getBizCategory">-
														(NSArray *)getBizCategory</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_convertGpsToAddressAt"
													href="#ios/docs/iosDoc.TMapPathData_convertGpsToAddressAt">-
														(NSString*)convertGpsToAddressAt:(TMapPoint*)tmp</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_convertGpsToAddressInfo"
													href="#ios/docs/iosDoc.TMapPathData_convertGpsToAddressInfo">-
														(NSDictionary*)convertGpsToAddressInfo:(TMapPoint*)tmp</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindAllPOI_2"
													href="#ios/docs/iosDoc.TMapPathData_requestFindAllPOI_2">-
														(NSArray*)requestFindAllPOI:(NSString *)keyword
														resultCount:(NSInteger)resultCount</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindAddressPOI_2"
													href="#ios/docs/iosDoc.TMapPathData_requestFindAddressPOI_2">-
														(NSArray*)requestFindAddressPOI:(NSString *)keyword
														resultCount:(NSInteger)resultCount</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindTitlePOI_2"
													href="#ios/docs/iosDoc.TMapPathData_requestFindTitlePOI_2">-
														(NSArray*)requestFindTitlePOI:(NSString*)keyword
														resultCount:(NSInteger)resultCount</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_findPathDataAllWithStartPoint"
													href="#ios/docs/iosDoc.TMapPathData_findPathDataAllWithStartPoint">-
														(NSDictionary*)findPathDataAllWithStartPoint:(TMapPoint*)startPoint
														endPoint:(TMapPoint*)endPoint</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_findPathDataWithType"
													href="#ios/docs/iosDoc.TMapPathData_findPathDataWithType">-
														(TMapPolyLine *)findPathDataWithType:(TMapPathType)type
														startPoint:(TMapPoint*)startPoint
														endPoint:(TMapPoint*)endPoint</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_findTimeMachineCarPathWithStartPoint"
													href="#ios/docs/iosDoc.TMapPathData_findTimeMachineCarPathWithStartPoint">-
														(NSDictionary*)findTimeMachineCarPathWithStartPoint:(TMapPoint*)startPoint
														endPoint:(TMapPoint*)endPoint
														isStartTime:(BOOL)isStartTime time:(NSDate*)date
														wayPoints:(NSArray*)wayPoints</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_reverseGeocoding"
													href="#ios/docs/iosDoc.TMapPathData_reverseGeocoding">-
														(NSDictionary*)reverseGeocoding:(TMapPoint*)mapPoint
														addressType:(NSString*)type</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_requestFindAroundKeywordPOI"
													href="#ios/docs/iosDoc.TMapPathData_requestFindAroundKeywordPOI">-
														(NSArray*)requestFindAroundKeywordPOI:(TMapPoint*)point
														keywordName:(NSString *)keywordName
														radius:(NSInteger)radius
														resultCount:(NSInteger)resultCount</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_autoCompleteWithText"
													href="#ios/docs/iosDoc.TMapPathData_autoCompleteWithText">-
														(NSArray*)autoCompleteWithText:(NSString*)text</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapPathData_findMultiPathDataWithStartPoint"
													href="#ios/docs/iosDoc.TMapPathData_findMultiPathDataWithStartPoint">-
														(TMapPolyLine*)findMultiPathDataWithStartPoint:(TMapPoint*)startPoint
														endPoint:(TMapPoint*)endPoint
														passPoints:(NSArray*)passPoints
														searchOption:(NSInteger)searchOption</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapTapi"
												href="#ios/docs/iosDoc.TMapTapi">TMapTapi</a></span>
											<ul style="display: none">
												<li><a
													id="ios_docs_iosDoc_TMapTapi_setSKTMapAuthenticationWithDelegate"
													href="#ios/docs/iosDoc.TMapTapi_setSKTMapAuthenticationWithDelegate">+
														(void)setSKTMapAuthenticationWithDelegate:(id<TMapTapiDelegate>)delegate
														apiKey:(NSString*)apiKey 
												</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapTapi_SKTMapApikeySucceed"
													href="#ios/docs/iosDoc.TMapTapi_SKTMapApikeySucceed">-
														(void)SKTMapApikeySucceed</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_SKTMapApikeyFailed"
													href="#ios/docs/iosDoc.TMapTapi_SKTMapApikeyFailed">-
														(void)SKTMapApikeyFailed:(NSError*)error</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_invokeRoute"
													href="#ios/docs/iosDoc.TMapTapi_invokeRoute">+
														(BOOL)invokeRoute:(NSString*)destName
														coordinate:(CLLocationCoordinate2D)coordinate</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_invokeSearchPortal"
													href="#ios/docs/iosDoc.TMapTapi_invokeSearchPortal">+
														(BOOL)invokeSearchPortal:(NSString*)destName</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapTapi_isTmapApplicationInstalled"
													href="#ios/docs/iosDoc.TMapTapi_isTmapApplicationInstalled">+
														(BOOL)isTmapApplicationInstalled</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_invokeGoHome"
													href="#ios/docs/iosDoc.TMapTapi_invokeGoHome">+
														(BOOL)invokeGoHome</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_invokeGoCompany"
													href="#ios/docs/iosDoc.TMapTapi_invokeGoCompany">+
														(BOOL)invokeGoCompany</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_invokeRoute_2"
													href="#ios/docs/iosDoc.TMapTapi_invokeRoute_2">+
														(BOOL)invokeRoute:(NSDictionary*)routeInfo</a></li>
												<li><a id="ios_docs_iosDoc_TMapTapi_getTMapDownUrl"
													href="#ios/docs/iosDoc.TMapTapi_getTMapDownUrl">+
														(NSString*)getTMapDownUrl</a></li>
											</ul></li>

										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapMarkerItem2"
												href="#ios/docs/iosDoc.TMapMarkerItem2">TMapMarkerItem2</a></span>
											<ul style="display: none">
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_setTMapPoint"
													href="#ios/docs/iosDoc.TMapMarkerItem2_setTMapPoint">-
														(void)setTMapPoint:(TMapPoint *)_point</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_getTMapPoint"
													href="#ios/docs/iosDoc.TMapMarkerItem2_getTMapPoint">-
														(TMapPoint*)getTMapPoint</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem2_setIcon"
													href="#ios/docs/iosDoc.TMapMarkerItem2_setIcon">-
														(void)setIcon:(UIImage *)icon</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem2_getIcon"
													href="#ios/docs/iosDoc.TMapMarkerItem2_getIcon">-
														(UIImage*)getIcon</a></li>
												<li><a id="ios_docs_iosDoc_TMapMarkerItem2_getID"
													href="#ios/docs/iosDoc.TMapMarkerItem2_getID">-
														(NSString*)getID</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_setAnimationIcons"
													href="#ios/docs/iosDoc.TMapMarkerItem2_setAnimationIcons">-
														(void)setAnimationIcons:(NSArray*)icons
														anchorPoint:(CGPoint)anchorPoint</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_setAniDuration"
													href="#ios/docs/iosDoc.TMapMarkerItem2_setAniDuration">-
														(void)setAniDuration:(double)aniDuration</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_startAnimation"
													href="#ios/docs/iosDoc.TMapMarkerItem2_startAnimation">-
														(void)startAnimation</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_stopAnimation"
													href="#ios/docs/iosDoc.TMapMarkerItem2_stopAnimation">-
														(void)stopAnimation</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapMarkerItem2_setCanShowCallout"
													href="#ios/docs/iosDoc.TMapMarkerItem2_setCanShowCallout">-
														(void)setCanShowCallout:(BOOL)show</a></li>
											</ul></li>
										<li><span class=""><a style="margin-left: 0px;"
												id="ios_docs_iosDoc_TMapOverlayItem"
												href="#ios/docs/iosDoc.TMapOverlayItem">TMapOverlayItem</a></span>
											<ul style="display: none">
												<li><a id="ios_docs_iosDoc_TMapOverlayItem_setImage"
													href="#ios/docs/iosDoc.TMapOverlayItem_setImage">-
														(void)setImage:(UIImage *)image</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapOverlayItem_setLeftTopPoint"
													href="#ios/docs/iosDoc.TMapOverlayItem_setLeftTopPoint">-
														(void)setLeftTopPoint:(TMapPoint *)leftTopPoint</a></li>
												<li><a
													id="ios_docs_iosDoc_TMapOverlayItem_setRightBottomPoint"
													href="#ios/docs/iosDoc.TMapOverlayItem_setRightBottomPoint">-
														(void)setRightBottomPoint:(TMapPoint *)rightBottomPoint</a></li>
											</ul></li>
									</ul></li>
							</ul></li>

						<li style="background: none"><span id="tit_Web_service"
							class="tit tit_ico_earth">Web service</span>
							<ul>

								<li><span class="">Guide</span>
									<ul style="display: none">
										<li><a id="webservice_guide_webserviceGuide_guide1"
											href="#webservice/guide/webserviceGuide.guide1">API
												Console</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide2"
											href="#webservice/guide/webserviceGuide.guide2">경로안내</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide3"
											href="#webservice/guide/webserviceGuide.guide3">주소검색</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide4"
											href="#webservice/guide/webserviceGuide.guide4">명칭검색</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide5"
											href="#webservice/guide/webserviceGuide.guide5">유가정보</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide12"
											href="#webservice/guide/webserviceGuide.guide12">다중 경유지안내</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide6"
											href="#webservice/guide/webserviceGuide.guide6">경유지 최적화</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide7"
											href="#webservice/guide/webserviceGuide.guide7">공간검색</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide8"
											href="#webservice/guide/webserviceGuide.guide8">교통정보</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide9"
											href="#webservice/guide/webserviceGuide.guide9">Road API</a></li>
										<li><a id="webservice_guide_webserviceGuide_guide10"
											href="#webservice/guide/webserviceGuide.guide10">StaticMap</a></li>
									</ul></li>

								<li><span class="">Sample</span>
									<ul style="display: none">
										<li><span class="">경로탐색</span>
											<ul style="display: none">
												<!-- style="display:none" -->
												<li><a id="webservice_sample_WebSampleRoutes"
													href="#webservice/sample/WebSampleRoutes">자동차 경로 안내</a></li>
												<li><a id="webservice_sample_WebSamplePrediction"
													href="#webservice/sample/WebSamplePrediction">타임머신 자동차
														길 안내</a></li>
												<li><a id="webservice_sample_WebSamplePedestrian"
													href="#webservice/sample/WebSamplePedestrian">보행자 안내</a></li>
												<li><a id="webservice_sample_WebSampleRouteStaticMap"
													href="#webservice/sample/WebSampleRouteStaticMap">경로
														이미지 안내</a></li>
												<li><a id="webservice_sample_WebSampleTruckRoutes"
													href="#webservice/sample/WebSampleTruckRoutes">화물차 경로
														안내</a></li>
												<li><a id="webservice_sample_WebSampleDistance"
													href="#webservice/sample/WebSampleDistance">직선거리 계산</a></li>
											</ul></li>
										<li><span class="">주소검색</span>
											<ul style="display: none">
												<li><a id="webservice_sample_WebSampleFullAddrGeo"
													href="#webservice/sample/WebSampleFullAddrGeo">Full
														Text Geocoding</a></li>
												<li><a id="webservice_sample_WebSampleGeocoding"
													href="#webservice/sample/WebSampleGeocoding">Geocoding</a>
												</li>
												<li><a id="webservice_sample_WebSampleReverseGeocoding"
													href="#webservice/sample/WebSampleReverseGeocoding">Reverse
														Geocoding</a></li>
												<li><a id="webservice_sample_WebSampleConvertAddress"
													href="#webservice/sample/WebSampleConvertAddress">주소 변환</a>
												</li>
												<li><a id="webservice_sample_WebSampleCoordConvert"
													href="#webservice/sample/WebSampleCoordConvert">좌표 변환</a></li>
												<li><a id="webservice_sample_WebSampleReverseLabel"
													href="#webservice/sample/WebSampleReverseLabel">Reverse
														Label</a></li>
												<li><a id="webservice_sample_WebSamplePostCode"
													href="#webservice/sample/WebSamplePostCode">우편번호 검색</a></li>
												<li><a id="webservice_sample_WebSampleNearToRoad"
													href="#webservice/sample/WebSampleNearToRoad">가까운도로찾기</a></li>
												<!-- <li>
													<a  id="webservice_sample_WebSampleRoadApi" href="#webservice/sample/WebSampleRoadApi">Road API</a>
												</li>
												<li>
													<a  id="webservice_sample_WebSampleStaticMap" href="#webservice/sample/WebSampleStaticMap">Static Map</a>
												</li> -->
											</ul></li>
										<li><span class="">명칭(POI)</span>
											<ul style="display: none">
												<li><a id="webservice_sample_WebSamplePoi"
													href="#webservice/sample/WebSamplePoi">명칭(POI) 통합 검색</a></li>
												<li><a id="webservice_sample_WebSamplePoiDetail"
													href="#webservice/sample/WebSamplePoiDetail">명칭(POI) 상세
														검색</a></li>
												<li><a id="webservice_sample_WebSamplePoiAround"
													href="#webservice/sample/WebSamplePoiAround">주변 POI
														카테고리 검색</a></li>
												<li><a id="webservice_sample_WebSamplePoiFindArea"
													href="#webservice/sample/WebSamplePoiFindArea">읍면동/도로명
														조회</a></li>
												<li><a id="webservice_sample_WebSamplePoiAreascode"
													href="#webservice/sample/WebSamplePoiAreascode">지역분류코드 검색</a>
												</li>
											</ul></li>
										<li><span class="">유가정보</span>
											<ul style="display: none">
												<li><a id="webservice_sample_WebSampleOilinfoPoiDetail"
													href="#webservice/sample/WebSampleOilinfoPoiDetail">명칭(POI)
														상세 검색</a></li>
												<li><a id="webservice_sample_WebSampleOilinfoPoiAround"
													href="#webservice/sample/WebSampleOilinfoPoiAround">주변
														명칭(POI) 상세 검색</a></li>
											</ul></li>

										<li><span class=""><a
												id="webservice_sample_WebSampleRouteSeq"
												href="#webservice/sample/WebSampleRouteSeq">다중 경유지 안내</a></span></li>

										<li><span class=""><a
												id="webservice_sample_WebSampleRouteOptimization"
												href="#webservice/sample/WebSampleRouteOptimization">경유지
													최적화</a></span></li>
										<li><span class=""><a
												id="webservice_sample_WebSampleGeofencing"
												href="#webservice/sample/WebSampleGeofencing">공간 검색</a></span></li>
										<li><span class=""><a
												id="webservice_sample_WebSampleTraffic"
												href="#webservice/sample/WebSampleTraffic">교통 정보</a></span></li>
										<li><span class="">Road API</span>
											<ul style="display: none">
												<!-- style="display:none" -->
												<li><a id="webservice_sample_WebSampleRoadApi"
													href="#webservice/sample/WebSampleRoadApi">이동한도로찾기</a></li>
											</ul></li>
										<li><span class="">StaticMap</span>
											<ul style="display: none">
												<!-- style="display:none" -->
												<li><a id="webservice_sample_WebSampleStaticMap"
													href="#webservice/sample/WebSampleStaticMap">StaticMap</a>
												</li>
											</ul></li>
										<!-- <li>
											<span class="">Invoke</span>
											<ul style="display:none">style="display:none"
												<li>
													<a  id="webservice_sample_WebSampleStaticMap" href="#webservice/sample/InvokeSampleTmapApp">TmapApp</a>
												</li>
											</ul>
										</li> -->
									</ul></li>

								<li><span class="">Docs</span>
									<ul style="display: none">
										<li><span class="">경로안내</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapRouteDoc"
													href="#webservice/docs/tmapRouteDoc">자동차 경로안내</a></li>

												<li><a id="webservice_docs_tmapRoutePredictionDoc"
													href="#webservice/docs/tmapRoutePredictionDoc">타임머신 자동차
														길 안내</a></li>
												<li><a id="webservice_docs_tmapRoutePedestrianDoc"
													href="#webservice/docs/tmapRoutePedestrianDoc">보행자 경로안내</a>
												</li>
												<li><a id="webservice_docs_RouteStaticMapDoc"
													href="#webservice/docs/RouteStaticMapDoc">경로 이미지 안내</a></li>
												<li><a id="webservice_docs_tmapTruckRouteDoc"
													href="#webservice/docs/tmapTruckRouteDoc">화물차 경로안내</a></li>
												<li><a id="webservice_docs_tmapRouteDistanceDoc"
													href="#webservice/docs/tmapRouteDistanceDoc">직선 거리 계산</a></li>
											</ul></li>
										<li><span class="">주소검색</span>
											<ul style="display: none">
												<li><a id="webservice_docs_fullTextGeocoding"
													href="#webservice/docs/fullTextGeocoding">Full Text
														Geocoding</a></li>
												<li><a id="webservice_docs_geocoding"
													href="#webservice/docs/geocoding">Geocoding</a></li>
												<li><a id="webservice_docs_reverseGeocoding"
													href="#webservice/docs/reverseGeocoding">Reverse
														Geocoding</a></li>
												<li><a id="webservice_docs_convertAddress"
													href="#webservice/docs/convertAddress">주소 변환</a></li>
												<li><a id="webservice_docs_convertCoord"
													href="#webservice/docs/convertCoord">좌표 변환</a></li>
												<li><a id="webservice_docs_reverseLabel"
													href="#webservice/docs/reverseLabel">Reverse Label</a></li>
												<li><a id="webservice_docs_postCode"
													href="#webservice/docs/postCode">우편번호 검색</a></li>
												<li><a id="webservice_docs_nearToRoad"
													href="#webservice/docs/nearToRoad">가까운도로찾기</a></li>
												<!-- <li>
													<a  id="webservice_docs_roadApi" href="#webservice/docs/roadApi">Road API</a>
												</li>
												<li>
													<a  id="webservice_docs_staticMap" href="#webservice/docs/staticMap">Static Map</a>
												</li> -->
											</ul></li>
										<li><span class="">명칭검색</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapPoiSearch"
													href="#webservice/docs/tmapPoiSearch">명칭(POI) 통합 검색</a></li>
												<li><a id="webservice_docs_tmapPoiDetail"
													href="#webservice/docs/tmapPoiDetail">명칭(POI) 상세 검색</a></li>
												<li><a id="webservice_docs_tmapPoiAroundSearch"
													href="#webservice/docs/tmapPoiAroundSearch">주변 POI
														카테고리 검색</a></li>
												<li><a id="webservice_docs_tmapPoiEMDSearch"
													href="#webservice/docs/tmapPoiEMDSearch">읍면동/도로명 조회</a></li>
												<li><a id="webservice_docs_tmapPoiAreaTypeCd"
													href="#webservice/docs/tmapPoiAreaTypeCd">지역분류코드 검색</a></li>
											</ul></li>
										<li><span class="">유가정보</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapOilinfoPoiDetail"
													href="#webservice/docs/tmapOilinfoPoiDetail">명칭(POI) 상세
														검색</a></li>
												<li><a id="webservice_docs_tmapOilinfoPoiAroundSearch"
													href="#webservice/docs/tmapOilinfoPoiAroundSearch">주변
														명칭(POI) 상세 검색</a></li>
											</ul></li>

										<li><span class="">다중 경유지 안내</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapRouteSequential30"
													href="#webservice/docs/tmapRouteSequential30">다중 경유지안내
														30</a></li>
												<li><a id="webservice_docs_tmapRouteSequential100"
													href="#webservice/docs/tmapRouteSequential100">다중 경유지안내
														100</a></li>
											</ul></li>



										<li><span class="">경유지 최적화</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapRouteOptimization10Doc"
													href="#webservice/docs/tmapRouteOptimization10Doc">경유지
														최적화 10</a></li>
												<li><a id="webservice_docs_tmapRouteOptimization20Doc"
													href="#webservice/docs/tmapRouteOptimization20Doc">경유지
														최적화 20</a></li>
												<li><a id="webservice_docs_tmapRouteOptimization30Doc"
													href="#webservice/docs/tmapRouteOptimization30Doc">경유지
														최적화 30</a></li>
												<li><a id="webservice_docs_tmapRouteOptimization100Doc"
													href="#webservice/docs/tmapRouteOptimization100Doc">경유지
														최적화 100</a></li>
											</ul></li>
										<li><span class="">공간검색</span>
											<ul style="display: none">
												<li><a id="webservice_docs_tmapGeofencingRegionsDoc"
													href="#webservice/docs/tmapGeofencingRegionsDoc">Geofencing-공간검색</a>
												</li>
												<li><a
													id="webservice_docs_tmapGeofencingRegionsDetailDoc"
													href="#webservice/docs/tmapGeofencingRegionsDetailDoc">Geofencing-영역조회</a>
												</li>
											</ul></li>
										<li><a id="webservice_docs_tmapTrafficDoc"
											href="#webservice/docs/tmapTrafficDoc">교통정보</a></li>
										<li><span class="">Road API</span>
											<ul style="display: none">
												<li><a id="webservice_docs_roadApi"
													href="#webservice/docs/roadApi">이동한도로찾기</a></li>
											</ul></li>
										<li><span class="">StaticMap</span>
											<ul style="display: none">
												<li><a id="webservice_docs_staticMap"
													href="#webservice/docs/staticMap">StaticMap</a></li>
											</ul></li>
									</ul></li>

							</ul></li>

					</ul>
				</div>

				<div id="sidetreecontrol" class="btn_wrap">
					<a href="#" class="btn_collapse_all"><img
						src="/resources/images/sub/btn_collapse_all_01.png"
						alt="- Collapse all"></a> <a href="#" class="btn_expand_all"><img
						src="/resources/images/sub/btn_expand_all_01.png"
						alt="+ Expand all"></a>
				</div>
			</div>

			<a href="#" id="btn_resize" class="btn_side_toggle"><img
				src="/resources/images/sub/btn_side_toggle.png" alt="side toggle"></a>
		</div>
		<!-- //left -->
		<!-- main_contents -->
		<main class="main" id="contents"> </main>
		<!-- //main_contents -->

	</div>
	<!-- //wrapper -->

</body>
</html>
