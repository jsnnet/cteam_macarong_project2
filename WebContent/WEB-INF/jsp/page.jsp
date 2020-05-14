<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--Page 이전 페이지 구현 --%> 
						<c:choose>
							<c:when test="${searchType == null}">
								<c:choose>
									<c:when test="${pageInfo.currentBlock eq 1}">
										<img src="resources/img/prev.png" style="width: 15px; height: 15px;">
									</c:when>
									<c:otherwise>
										<a
											href="storelistController?page=
									${(pageInfo.currentBlock-1)*pageInfo.pagesPerBlock }">
											<img src="resources/img/prev.png" style="width: 15px; height: 15px;">
										</a>
									</c:otherwise>
								</c:choose>

								<%--Page  페이지 구현 --%>
								<c:choose>
									<c:when test="${pageInfo.currentBlock ne pageInfo.totalBlocks}">
										<c:forEach begin="1" end="${pageInfo.pagesPerBlock}"
											varStatus="num">
                        [<a
												href="storelistController?page=
                        ${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }">
												${(pageInfo.currentBlock- 1) * pageInfo.pagesPerBlock + num.count }</a>]
                    			</c:forEach>
									</c:when>
									<c:otherwise>
										<c:forEach
											begin="${(pageInfo.currentBlock-1)*pageInfo.pagesPerBlock + 1}"
											end="${pageInfo.totalPages}" varStatus="num">
                        [<a
												href="storelistController?page=
										${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }">
												${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }</a>]
                    </c:forEach>
									</c:otherwise>
								</c:choose>


								<%--Page 다음 페이지 구현 --%>
								<c:choose>
									<c:when test="${pageInfo.currentBlock eq pageInfo.totalBlocks}">
										<img src="resources/img/next.png" style="width: 15px; height: 15px;">
									</c:when>
									<c:otherwise>
										<a
											href="storelistController?page=
									${pageInfo.currentBlock * pageInfo.pagesPerBlock + 1 }">
											<img src="resources/img/next.png" style="width: 15px; height: 15px;">
										</a>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>

								<c:choose>
									<c:when test="${pageInfo.currentBlock eq 1}">
										<img src="resources/img/prev.png" style="width: 15px; height: 15px;">
									</c:when>
									<c:otherwise>
										<a
											href="storelistController?searchType=${searchType}&searchValue=${searchValue}&page=
									${(pageInfo.currentBlock-1)*pageInfo.pagesPerBlock }">
											<img src="resources/img/prev.png" style="width: 15px; height: 15px;">
										</a>
									</c:otherwise>
								</c:choose>

								<%--Page  페이지 구현 --%>
								<c:choose>
									<c:when test="${pageInfo.currentBlock ne pageInfo.totalBlocks}">
										<c:forEach begin="1" end="${pageInfo.pagesPerBlock}"
											varStatus="num">
                        [<a href="storelistController?searchType=${searchType}&searchValue=${searchValue}&page=
                        ${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }">
												${(pageInfo.currentBlock- 1) * pageInfo.pagesPerBlock + num.count }</a>]
                    			</c:forEach>
									</c:when>
									<c:otherwise>
										<c:forEach
											begin="${(pageInfo.currentBlock-1)*pageInfo.pagesPerBlock + 1}"
											end="${pageInfo.totalPages}" varStatus="num">
                        [<a href="storelistController?searchType=${searchType}&searchValue=${searchValue}&page=
										${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }">
												${(pageInfo.currentBlock - 1) * pageInfo.pagesPerBlock + num.count }</a>]
                    </c:forEach>
									</c:otherwise>
								</c:choose>


								<%--Page 다음 페이지 구현 --%>
								<c:choose>
									<c:when test="${pageInfo.currentBlock eq pageInfo.totalBlocks}">
										<img src="resources/img/next.png" style="width: 15px; height: 15px;">
									</c:when>
									<c:otherwise>
										<a
											href="storelistController?searchType=${searchType}&searchValue=${searchValue}&page=
									${pageInfo.currentBlock * pageInfo.pagesPerBlock + 1 }">
											<img src="resources/img/next.png" style="width: 15px; height: 15px;">
										</a>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
