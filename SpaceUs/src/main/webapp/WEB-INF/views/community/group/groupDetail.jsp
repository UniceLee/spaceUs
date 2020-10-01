<%@page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- 한글 인코딩처리 -->
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- icons -->
<script src="https://kit.fontawesome.com/b74a25ff1b.js" crossorigin="anonymous"></script>
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
/*드롭*/
body{
    margin:0;
    padding:0;
}
/* ul, li 요소 초기화 */
.main-menu,.sub-menu {
    margin:0;
    padding:0;
    list-style-type:none;
    float: right;
    margin-top: 10px;
}
.sub-menu{
	position:absolute;
	display: block;
	border: 1px solid #d0d0d0;
	border-radius: 10px;
	padding: 10px;
	background: #fff;
	box-shadow: 0px 0px 10px .1px #d0d0d0;
}
.click .sub-menu{
	opacity: 1;
	visibility: visible;	
}
.sub-menu > li {
	padding: 10px;
}
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
	            <h1 class="mb-4">소모임</h1>
	            <p class="h6">
	                        소모임 게시판은 공동체 활동에 대한 소모임 관련 정보를 교환하는 게시판으로, SpaceUs에서는 정보교환의 온라인 공간을 제공할 뿐 중개에 관여하지 않으며,
				그에 따른 과실 또는 손해발생에 대해 일체 책임을 지지 않음을 알려드립니다.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 소모임 시작-->
	<section class="blog-section spad">
	 <div class="row m-5">
                 <!-- column -->
                 <c:forEach items="${list}" var="list">
	                 <div class="col-12">
	                         <div class="m-5" style="border-bottom: 1px solid #dddddd;">
	                         <c:forEach items="${boardList}" var="board">
							 <div style="color: #00c89e; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/community/group/groupList/${board.boardNo}/${board.boardRef}.do'">${board.boardName} > </div>		
	                         </c:forEach>
	                         <div style="border-bottom: 1px solid #dddddd; padding-bottom: 15px;">
	                            <p class="h4">${list.groupBoardTitle}</p>
	                         	<table style="display: inline-block;">
	                                <tr>
	                                    <th><i class="fa fa-user"></i>&nbsp; ${list.nickname}</th>
	                                    <th class="col-xl-auto">|</th>
	                                    <th><i class="fa fa-calendar"></i>&nbsp; ${list.groupBoardDate}</th>
	                                    <th class="col-xl-auto">|</th>
	                                    <th><i class="fa fa-eye"></i> 조회수 &nbsp; ${list.viewCnt}</th>
	                                    <th class="col-xl-auto">|</th>
	                                    <th><i class="fa fa-comment"></i> 댓글수 &nbsp; ${list.viewCnt}</th>
	                                </tr>
	                                <input type="hidden" name="groupBoardNo" value="${list.groupBoardNo}"/>
	                            </table>
	                            
		                        <!-- 수정삭제 버튼시작 -->
		                        <sec:authorize access="hasAnyRole('USER','ADMIN')">
		                        	<%-- <sec:authentication property="principal.username" var="loginMember"/> --%>
		                        	<c:if test="${loginMember != list.memberEmail}">
			                            <button class="btn btn-sm btn-danger"  
			                            		data-toggle="modal" data-target="#intro"
			                            		style="margin-top:50px; font-size:15px; color:white; float:right; margin-right: 35px; margin-top: 0;">
			                            		신고하기 
			                            </button>	
		                        	</c:if>
		                          	<c:if test="${loginMember != null && loginMember eq list.memberEmail }">
			                            <button id="modifyBtn" class="btn btn-sm" onclick="location.href='${pageContext.request.contextPath}/community/group/modifyBoard/${list.groupBoardNo}.do'" 
			                            		style="margin-top:50px; background-color: #00c89e; font-size:15px; color:white; float:right; margin-right: 10px; margin-top: 0;">글 수정 </button>
			                           	<div style="display: inline-block;"></div>
			                            <button id="deleteBtn" class="btn btn-sm" style="margin-top:42px;background-color: #00c89e;font-size:15px;color:white;float:right;margin-right: 10px;margin-top: 0;border-right-width: 0px;padding-right: 9px;">글 삭제 </button>
		                          	</c:if>	                          	
		                        </sec:authorize>
		                        <!-- 수정삭제 버튼끝-->
	                         </div>
	                         
	                         <!-- 본문 시작 -->
		                         <div class="m-5">
			                         <div class="mb-5">
			                   			${list.groupBoardContent}
			                         </div>	                         
		                         </div>
	                         </div>
	                         <!-- 본문 끝 -->
	                         
	                         
	                         <!-- 댓글 시작 -->
	                         <p style="margin-left:5%;"><i class="fa fa-comment"></i> 댓글수 &nbsp; ${list.viewCnt}</p>
                         	
	                         <div style="background-color: #fafafa; width:90%; margin: auto;">
	                         	<div class="pl-5 pr-5 pt-4">
	                         		<form id="inserCommentFrm">
	                         			<input type="hidden" name="groupBoardRef" value="${list.groupBoardNo}"/>
	                         			<input type="hidden" name="memberEmail" value="${loginMember}"/>
	                         			<input type="hidden" name="groupBoardCommentLevel" value="1" />
	                         			<input type="hidden" name="groupBoardCommentRef" value="" />
	                         		
		                         		<div class="form-check" style="display: block;">
										  <input class="form-check-input" type="checkbox" name="secret" id="secret" value="secret">
										  <label class="form-check-label" for="secret">비밀글</label>
										</div>
										<div >
			                         		<textarea class="col-lg-11 textarea1" name="textarea1" style="resize: none; border:1px solid #edeceb; height: 80px; border-radius: 4px;"></textarea>
			                           		<input type="button" class="btn insertCmt" id="insertCmt"
			                           				style="margin-bottom: 70px;height: 80px; border: 1px solid #dddddd;width: 70px;" value="등록">
										</div>
	                         		</form>
	                         		
	                           		<!-- 댓글보기시작 -->
	                           		<c:forEach items="${commentList}" var="cm" varStatus="vs">
	                           			<c:if test="${cm.groupBoardCommentLevel eq '1' }">
			                           		<div class="level1" style="margin-top: 10px;">
				                           		<tr class="col-md-1">
				                                    <th><b>${cm.nickname}</b></th>
				                                    <th><p style="display: inline; margin: 0 0 0 10px; color: #d0d0d0;">${cm.groupBoardDate}</p></th>
				                                    <th>|</th>
				                                    <th><a href="#" style="color: #6d6d6d !important; font-size: 13px; margin-left: 8px;">답글쓰기</a></th>
			                                         
			                                        <sec:authorize access="hasAnyRole('USER', 'HOST','ADMIN')">
				                                         <th>			                                    	
					                                    	<ul class="main-menu" id="main-menu${cm.groupBoardCommentNo}" onclick="menu${cm.groupBoardCommentNo}();">
					                                    		<li>
					                                    			<i class="fa fa-ellipsis-v layerMore">
						                                    			<ul class="sub-menu" name="sub-menu" id="sub-menu${cm.groupBoardCommentNo}">
						                                    				<c:if test="${loginMember != list.memberEmail}">
						                                    					<li><a href="#">신고하기</a></li>
						                                    				</c:if>
						                                    				<c:if test="${loginMember == list.memberEmail}">
						                                    					<li><a href="#">수정</a></li>
						                                    					<li><a href="#">삭제</a></li>
						                                    				</c:if>
						                                    			</ul>
					                                    			</i>
					                                    		</li>
					                                    	</ul>
				                                    	</th>
				                                    	<script type="text/javascript">
					                                    	function menu${cm.groupBoardCommentNo}(){
					                                    		var element = document.getElementById("main-menu${cm.groupBoardCommentNo}");
					                                    		element.classList.toggle("click");
	
					                                    	    if($('#main-menu${cm.groupBoardCommentNo}').hasClass("click")){
					                                    		   $('#sub-menu${cm.groupBoardCommentNo}').show();
					                                    	    }else{
					                                    	   	   $('#sub-menu${cm.groupBoardCommentNo}').hide();
					                                    	    }
					                                    	}
														</script>
			                                    	</sec:authorize>
			                                	</tr>
			                                	
				                         		<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px;">${cm.groupBoardContent}</div>
				                         	</div>
	                           			</c:if>
										<c:if test="${cm.groupBoardCommentLevel eq '2' }">
				                         	<div class="level2" style="margin: 10px 0 0 3%;">
				                         		<tr class="col-md-1">
				                                    <th><b>${list.nickname}</b></th>
				                                    <th><p style="display: inline; margin: 0 0 0 10px; color: #d0d0d0;">${cm.groupBoardDate}</p></th>
				                                     
				                                     <sec:authorize access="hasAnyRole('USER', 'HOST','ADMIN')">
					                                     <th>
					                                    	<ul class="main-menu" id="main-menu${cm.groupBoardCommentNo}" onclick="menu${cm.groupBoardCommentNo}();">
					                                    		<li>
					                                    			<i class="fa fa-ellipsis-v layerMore">
						                                    			<ul class="sub-menu" name="sub-menu" id="sub-menu${cm.groupBoardCommentNo}">
						                                    				<c:if test="${loginMember != list.memberEmail}">
						                                    					<li><a href="#">신고하기</a></li>
						                                    				</c:if>
						                                    				<c:if test="${loginMember == list.memberEmail}">
						                                    					<li><a href="#">수정</a></li>
						                                    					<li><a href="#">삭제</a></li>
						                                    				</c:if>
						                                    			</ul>
					                                    			</i>
					                                    		</li>
					                                    	</ul>
					                                    </th>
					                                    <script type="text/javascript">
					                                    	function menu${cm.groupBoardCommentNo}(){
					                                    		var element = document.getElementById("main-menu${cm.groupBoardCommentNo}");
					                                    		element.classList.toggle("click");
	
					                                    	    if($('#main-menu${cm.groupBoardCommentNo}').hasClass("click")){
					                                    		   $('#sub-menu${cm.groupBoardCommentNo}').show();
					                                    	    }else{
					                                    	   	   $('#sub-menu${cm.groupBoardCommentNo}').hide();
					                                    	    }
					                                    	}
														</script>
				                                    </sec:authorize>
				                                    
			                                	</tr>
				                         		<div style="border-bottom : .5px solid #d0d0d0; padding-bottom: 10px;">${cm.groupBoardContent}</div>
				                         	</div>
										</c:if>			                         	
		                         	</c:forEach>		                         	
	                           		<!-- 댓글보기끝-->
	                           		
	                           </div>
	                         </div>
	                         <!-- 댓글 끝 -->
	                         
	                         
	                         <div class="text-center">
				                <a href='${pageContext.request.contextPath }/community/group/groupList.do' class="btn m-1" style="background-color: #00c89e; font-size:20px; color:white;"><i class="fa fa-list"></i> 목록</a>
	                         </div>
	                     </div>
	                     
	                     
	                     
	                   <!-- Modal -->
                       <div class="modal fade" id="intro" role="dialog" aria-labelledby="introHeader" aria-hidden="true" tabindex="-1">
                           <div class="modal-dialog">
                               <div class="modal-content">
                                   <div class="modal-header">
                                       <h4 class="modal-title">신고하기</h4>
                                   </div>
                                   <div class="modal-body">
                                      <p style=" padding-top: 20px; font-size: 16px; margin-bottom:0;">신고 게시물 : <input style="border: none; color:#666; font-size: 16px;" type="text" value="${list.groupBoardTitle }" /></p>
                                       <p style="border-bottom: 1px solid #efefef; font-size: 16px; padding-bottom: 30px;">작&nbsp;&nbsp;&nbsp;  성&nbsp;&nbsp;&nbsp;  자 &nbsp;: <input id="reportNick" style="border: none; color:#666; font-size: 16px;" type="text" value="${list.nickname }" /></p>
                                       <p style=" font-size: 16px;">사 유&nbsp; 선 택 &nbsp;: <span style="font-size: 12px; color:#888;">여러 사유에 해당되는 경우, 대표적인 사유 1개를 선택해 주세요.</span></p>
                                       <input type="radio" name="reportReason" style="margin-left:85px;" value="부적절한 홍보 게시글"/> 부적절한 홍보 게시글<br/>
                                       <input type="radio" name="reportReason" style="margin-left:85px;" value="음란성 또는 청소년에게 부적합한 내용"/> 음란성 또는 청소년에게 부적합한 내용<br/>
                                       <input type="radio" name="reportReason" style="margin-left:85px;" value="명예훼손/사생활 침해 및 저작권침해등"/> 명예훼손/사생활 침해 및 저작권침해등<br/>
                                       <input type="radio" name="reportReason" style="margin-left:85px;" value="기타"/> 기타
                                   </div>
                                   <div class="modal-footer">
                                       <button type="submit" class="btn btn-primary" data-dismiss="modal" id="alertBtn">신고</button>
                                       <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                                   </div>
                               </div>
                           </div>
                       </div>
                       <!-- Modal end -->
                   </c:forEach>
          
                 </div>
             </section>
               
    <!-- 소모임 리스트 끝-->
<!-- 컨텐츠 끝 -->
<script type="text/javascript">

$("#deleteBtn").click(function(){
	let groupBoardNo = $("[name=groupBoardNo]").val();
	if(!confirm('정말 삭제하시겠습니까?')) return;
	location.href="${pageContext.request.contextPath }/community/group/deleteBoard.do?groupBoardNo="+groupBoardNo;
});

$("#alertBtn").click(function(){
	let groupBoardNo = $("[name=groupBoardNo]").val();
	let reportReason = $("[name=reportReason]:checked").val();
	
	location.href="${pageContext.request.contextPath }/community/group/alertBoard.do?groupBoardNo="+groupBoardNo+"&reportReason="+reportReason;
});
//댓글 삼지창
$(function(){
	$('.sub-menu').hide();	
});

/* function menu1(){
	var element = document.getElementById("main-menu1");
	element.classList.toggle("click");

    if($('#main-menu1').hasClass("click")){
	   $('#sub-menu1').show();
    }else{
   	   $('#sub-menu1').hide();
    }
} */

$(".textarea1").click(function(){
	alert('${loginMember}');
 	if('${loginMember}' == 'anonymousUser'){
		alert("로그인 후 사용해 주세요");
		location.href="${pageContext.request.contextPath }/member/memberLoginForm.do";
	}
	else{
		return;
	}
});

/*댓글 등록 버튼 이벤트 ajax*/
$("#inserCommentFrm #insertCmt").click(function(){
	var groupBoardContent = $("[name=textarea1]").val();
	var groupBoardRef = $("[name=groupBoardRef]").val();
	var writer = $("[name=memberEmail]").val();
	var groupBoardCommentLevel = $("[name=groupBoardCommentLevel]").val();
	var groupBoardCommentRef = $("[name=groupBoardCommentRef]").val();

	var secret = "0";

	if($("[name=secret]").is(":checked")){
		secret = "1";
	}
	var param1 = "groupBoardContent="+groupBoardContent+
				"&groupBoardRef="+groupBoardRef+"&writer="+writer+
				"&groupBoardCommentLevel="+groupBoardCommentLevel+
				"&groupBoardCommentRef="+groupBoardCommentRef+"&secret="+secret;
	alert(param1);
	
	$.ajax({
		method:"post",
		url:"${pageContext.request.contextPath}/community/comment/insertComment/"+groupBoardRef+".do",
		data:param1,
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		success:function(){
			alert("댓글이 정상적으로 등록되었습니다.");
			location.href="${pageContext.request.contextPath }/community/group/groupDetail/"+groupBoardRef+".do";
		},
		error: function(x,h,r){
			alert("댓글이 정상적으로 등록ㅌㅌㅌ.안됨");
			console.log(x,h,r);
		}
	});
});

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>