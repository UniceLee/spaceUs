<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- 한글 인코딩처리 -->
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<%
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
String loginMember = auth.getName();
pageContext.setAttribute("loginMember",loginMember);
%>
<style>
.image-div {
	background-color:#f7f7f7;
	border:1px solid gray;
	display:inline-block;
	width:200px;
	height: 200px;
	margin-right: 20px;
}
.fas {position: absolute; padding: 90px;}
input[type=file], .address-input {margin-bottom:20px; margin-top:10px;}
.site-btn {width: 100%; font-size: 17px;}
</style>
<!-- 컨텐츠 시작 -->
<!-- 헤더 -->
<section class="ftco-section ftco-agent">

 <div class="navbar justify-content-center navbar-dark bg-dark">
	  <ul class="nav">
		  <li class="nav-item">
		    <a class="nav-link active" href="${pageContext.request.contextPath }/community/group/groupList.do">소모임</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link" href="${pageContext.request.contextPath }/community/recruit/recruitList.do">구인/구직</a>
		  </li>
		</ul>
	</div>
	</section>
    <div class="hero-wrap ftco-degree-bg"
    	 style="background-image: url('${pageContext.request.contextPath }/resources/images/bg_1.jpg');
    	 		height: 400px"
    	 data-stellar-background-ratio="0.5">
	
      <div class="overlay"></div>
	
      <div class="container">
        <div class="row no-gutters slider-text justify-content-center align-items-center">
          <div class="col-lg-8 col-md-6 ftco-animate d-flex align-items-end">
          	<div class="text text-center mx-auto" style="margin-bottom:80%;">
	            <h1 class="mb-4">구인/구직</h1>
	            <p class="h6">구인ㆍ구직 게시판은 각 숙소에서의 스태프(매니저, 아르바이트, 주방 아주머니 등)의
				구인/구직 관련 정보를 교환하는 게시판으로, SpaceUs에서는 정보교환의 온라인 공간을 제공할 뿐 중개에 관여하지 않으며,
				그에 따른 과실 또는 손해발생에 대해 일체 책임을 지지 않음을 알려드립니다.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 구인구직 시작-->
	<section class="blog-section spad">
	 <div class="row m-5">
                 <!-- column -->
                 <div class="col-12">
                         <div class="m-5" >
								
                         <input type="hidden" name="no" id="no" value="${ recruit.no }"/> 
                         <input type="hidden" name="memberEmail" id="memberEmail" value="${ loginMember }"/> 
                         <div style="border-bottom: 1px solid #dddddd; padding-bottom: 15px;">
                            <p class="h4">${recruit.title }</p>
                         	<table>
                                <tr>
                                    <th><i class="fa fa-user"></i>&nbsp;${recruit.nickName } </th>
                                    <th class="col-xl-auto">|</th>
                                    <th><i class="fa fa-calendar"></i>&nbsp;<fmt:formatDate value="${recruit.enrollDate}" pattern="yyyy/MM/dd"/></th>
                                    <th class="col-xl-auto">|</th>
                                    <th><i class="fa fa-eye"></i>&nbsp;${ recruit.viewCnt}</th>
                                     <sec:authorize access="hasAnyRole('USER','HOST','ADMIN')">
                                     <sec:authentication property="principal.username" var="loginMember"/>
                                    <th class="col-xl-auto">|</th>
                                    <th><i class="fa fa-bullhorn"></i>
                                    	<button style="border: none; background: none; color:#666; cursor: pointer;" data-toggle="modal" data-target="#intro">&nbsp;신고하기</button>
                                    </th>
                                    	<c:if test="${loginMember != null && loginMember eq recruit.email }">
	                                    <th style="position: absolute;right: 110px; cursor: pointer;" class="mr-5" id="modifyBtn">수정하기</th>
	                                    <th class="col-xl-auto mr-5" style="position: absolute;right: 70px;">|</th>
	                                    <th style="position: absolute;right: 10px; cursor: pointer;" class="mr-5" onclick="deleteBtn('${ recruit.no }')">삭제하기</th>
                               			</c:if>	
                               		</sec:authorize>
                                </tr>
                            </table>
                            <!-- Modal -->
					        <div class="modal fade" id="intro" role="dialog" aria-labelledby="introHeader" aria-hidden="true" tabindex="-1">
					            <div class="modal-dialog">
					                <div class="modal-content">
					                    <div class="modal-header">
					                        <h4 class="modal-title">신고하기</h4>
					                    </div>
					                    <div class="modal-body">
					                    	<p style=" padding-top: 20px; font-size: 16px; margin-bottom:0;">신고 게시물 : <input style="border: none; color:#666; font-size: 16px;" type="text" value="${recruit.title }" /></p>
					                        <p style="border-bottom: 1px solid #efefef; font-size: 16px; padding-bottom: 30px;">작&nbsp;&nbsp;&nbsp;  성&nbsp;&nbsp;&nbsp;  자 &nbsp;: <input id="reportNick" style="border: none; color:#666; font-size: 16px;" type="text" value="${recruit.nickName }" /></p>
					                        <p style=" font-size: 16px;">사 유&nbsp; 선 택 &nbsp;: <span style="font-size: 12px; color:#888;">여러 사유에 해당되는 경우, 대표적인 사유 1개를 선택해 주세요.</span></p>
					                        <input type="radio" name="reportCon" style="margin-left:85px;" value="부적절한 홍보 게시글"/> 부적절한 홍보 게시글<br/>
					                        <input type="radio" name="reportCon" style="margin-left:85px;" value="음란성 또는 청소년에게 부적합한 내용"/> 음란성 또는 청소년에게 부적합한 내용<br/>
					                        <input type="radio" name="reportCon" style="margin-left:85px;" value="명예훼손/사생활 침해 및 저작권침해등"/> 명예훼손/사생활 침해 및 저작권침해등<br/>
					                        <input type="radio" name="reportCon" style="margin-left:85px;" value="기타"/> 기타
					                    </div>
					                    <div class="modal-footer">
					                        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="reportBtn();">신고</button>
					                        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
					                    </div>
					                </div>
					            </div>
					        </div>


                         <div class="m-5">
                         <div class="mb-5">${recruit.reportCnt >=10 ? "게시글이 비공개 처리 되었습니다." : recruit.content}</div>
                         
                         
                         <div style="background-color: #fafafa; border: 1px solid #edeceb; padding-bottom: 50px; ">
                         <div class="pl-5 pr-5 pt-4">
                         	<p><i class="fa fa-comment mr-1"></i>댓글 0개</p>
                         	<div class="form-check" style="display: block;">
								 <input class="form-check-input mt-2" type="checkbox" name="secret" id="secret" value="secret">
								 <label class="form-check-label" for="secret" style="font-size: 14px;">비밀글</label>
							</div>
							<div class="row" style="height: 120px;">
	                         	<textarea class="col-lg-11 ml-2 mr-1 mt-1" id=content style="resize: none; border:1px solid #edeceb; height: 80px; border-radius: 4px;"></textarea>
	                           	<button type="button" class="btn mt-1" id="insertComment" style="margin-bottom: 70px;height: 80px; border: 1px solid #dddddd;width: 70px;">등록</button>
                         	</div>
                         <!-- 댓글 보기 -->
                         <c:forEach items="${commentList}" var="list" varStatus="vs">
                       			<c:if test="${list.level == 1 }">
                         		<div class="level1_${list.no}" style="margin-top: 10px;">
                         			<div class="level1__${list.no}">
                           		<tr class="col-md-1">                           		
                           			<input type="hidden" name="groupBoardCommentNo" value="${list.no}" />
                           			
                                    <th><b>${list.nickName}</b></th>
                                    <th><p style="display: inline; margin: 0 0 0 10px; color: #d0d0d0;"><fmt:formatDate value="${list.date}" pattern="yyyy.MM.dd HH:mm"/></p></th>
                                    <th> |</th>
                                    <th><p class="ml-2" style="font-size: 13px; color: #6d6d6d; display: inline; cursor: pointer;">답글쓰기</p> </th>
                                        
                                       <sec:authorize access="hasAnyRole('USER', 'HOST','ADMIN')">
	                                         <th>	
 
		                                    			<i class="fa fa-ellipsis-v pull-right">
			                                    			 <ul class="dropdown-menu" role="menu" id="commentMenuBtn">
															    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">신고</a></li>
															  </ul>
			                                    				<%-- <c:if test="${loginMember != list.email}">
			                                    					<li><button name="alertComment" 
			                                    								value="${list.no }" style="border:0; background: #fafafa;"
			                                    								data-toggle="modal" data-target="#commentReport">신고하기</button></li>
			                                    				</c:if> --%>
			                                    				<%-- <c:if test="${loginMember == list.email}">
			                                    					<li><button name="updateComment"   style="border:0; background: #fafafa;">수정</button></li>
			                                    					<li><button name="deleteComment"  style="border:0; background: #fafafa;">삭제</button></li>
			                                    				</c:if> --%>
		                                    			</i>
	                                    	</th>
                                    	
                                   	</sec:authorize>
                               	</tr>
                               	
                                <c:if test="${list.secret == 0 || list.email eq loginMember || loginMember eq recruit.nickName}">
                         			<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px;">${list.content}</div>
                                </c:if>
                                <c:if test="${list.secret == 1 && list.email != loginMember}">
                         			<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px; color: #9e9e9e;">비밀 댓글입니다</div>
                                </c:if>
                             
                              </div>
                        	</div>
                        	
                
                        	
             					<!-- 대댓글 폼 시작 -->
                        			                           			
                       			<!-- 대댓글 폼 끝 -->
                       			</c:if>
                       			
	                           			
										 <c:if test="${cm.groupBoardCommentLevel eq '2' }">
										<div  class="level2_${cm.groupBoardCommentNo}">
				                         	<div class="level2__${cm.groupBoardCommentNo}" style="margin: 10px 0 0 3%;">
				                         		<tr class="col-md-1">
				                         			<input type="hidden" name="groupBoardCommentNo${cm.groupBoardCommentNo}" value="${cm.groupBoardCommentNo}" />
				                                    
				                                    <th><b>${cm.nickname}</b></th>
				                                    <th><p style="display: inline; margin: 0 0 0 10px; color: #d0d0d0;">${cm.groupBoardDate}</p></th>
				                                     
				                                     <sec:authorize access="hasAnyRole('USER', 'HOST','ADMIN')">
					                                     <th>
					                                    	<ul class="main-menu" id="main-menu${cm.groupBoardCommentNo}" onclick="menu${cm.groupBoardCommentNo}();">
					                                    		<li>
					                                    			<i class="fa fa-ellipsis-v layerMore">
						                                    			<ul class="sub-menu" name="sub-menu" id="sub-menu${cm.groupBoardCommentNo}">
						                                    				<c:if test="${loginMember != cm.writer}">
						                                    					<li><button name="alertComment${cm.groupBoardCommentNo}" value="${cm.groupBoardCommentNo}" style="border:0; background: #fafafa;">신고하기</button></li>
						                                    				</c:if>
						                                    				<c:if test="${loginMember == cm.writer}">
						                                    					<li><button name="updatereply_${cm.groupBoardCommentNo}" value="${cm.groupBoardCommentRef}" style="border:0; background: #fafafa;">수정</button></li>
								                                    			<li><button name="deleteComment${cm.groupBoardCommentNo}" style="border:0; background: #fafafa;">삭제</button></li>
						                                    				</c:if>
						                                    			</ul>
					                                    			</i>
					                                    		</li>
					                                    	</ul>
					                                    </th>
					                                   
				                                    </sec:authorize>
				                                    
			                                	</tr>
			                                	<c:if test="${cm.secret eq '0'}">
				                         			<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px;">${cm.groupBoardContent}</div>
			                                	</c:if>
			                                	<c:if test="${cm.secret eq '1'}">
				                         			<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px; color: #9e9e9e;">비밀 댓글 입니다</div>
			                                	</c:if>
				                         	</div>
				                         </div>
				                         	
										</c:if>	                       	
		                         	</c:forEach>		                         	
	                           		<!-- 댓글보기끝-->
	                           		</div>
	                         <!-- 댓글 끝 -->
	                           </div>
	                         </div>
                         </div>
                         </div>
                         <div class="text-center mt-4">
			                 	<a href='${pageContext.request.contextPath }/community/recruit/recruitList.do' class="btn m-1" style="background-color: #00c89e; font-size:20px; color:white;"><i class="fa fa-list"></i> 목록</a>
                             </div>
                         </div>
                     </div>
             </section>
    <!-- 구인구직 리스트 끝-->
<!-- 컨텐츠 끝 -->
<script>
$("#modifyBtn").on('click', function(){
	let no = $("[name=no]").val();
	location.href="${pageContext.request.contextPath }/community/recruit/recruitModify.do?no="+no; 
});
function deleteBtn(no){
	if(!confirm("정말 삭제하시겠습니까?")) return;
	location.href="${pageContext.request.contextPath }/community/recruit/deleteRecruit.do?no="+no; 
};
function reportBtn(){
	$.ajax({
		url : "${ pageContext.request.contextPath }/community/recruit/recruitReport.do",
		data : {
			no : $("[name=no]").val(),
			nickName : $("#reportNick").val(),
			reportReason : $("input[name=reportCon]:checked").val()
		},
		dataType : "json",
		success : function(data){
			console.log(data);
			if(data.duplication != 1)
			alert("신고가 완료되었습니다!");
			else
			alert("이미 신고된 게시물 입니다!");
		},
		error : function(xhr, status, err){
			console.log("처리실패", xhr, status, err);
		}
	});
};
//댓글 등록
$("#insertComment").click(function(){
	var secret = "0";
	if($("#secret").is(":checked")){
		secret = "1";
	}
	 $.ajax({
		url : "${ pageContext.request.contextPath }/community/recruit/insertComment.do",
		data : {
			recruitNo : $("#no").val(),
			email : $("#memberEmail").val(),
			content : $("#content").val(),
			secret : secret
		},
		dataType : "json",
		success : function(data){
			alert("댓글이 등록되었습니다!");
			location.reload();
		},
		error : function(xhr, status, err){
			console.log("처리실패", xhr, status, err);
		}
	}); 
});
//댓글 신고/수정/삭제 버튼 이벤트
$('.fa-ellipsis-v').click(function(){
	$('#commentMenuBtn').dropdown();
	
});
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>