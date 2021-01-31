<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" isErrorPage="true"%>
<%!public void jspInit() {
		contextPath = getServletContext().getContextPath();
	}

	private String contextPath;%>
<%
	String message = (String) request.getAttribute("javax.servlet.error.message");
if (message == null) {
	response.sendError(404);
}
boolean isDbErr = message.equals("Database Error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Internal Server Error</title>
<!--CSS-->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css"
	integrity="sha256-aAr2Zpq8MZ+YA/D6JtRD3xtrwpEz2IqOS+pWD/7XKIw="
	crossorigin="anonymous" />
<link rel="icon" href="<%=contextPath%>/favicon.ico" type="image/x-icon" />
<style>
body{
position: relative;
padding-bottom: 2rem;
min-height: 100vh;
}
footer{
	width: 100%;
	display: flex;
	background-color: #f8f9fa;
	position: absolute;
	bottom: 0;
	height: 1.5rem;
	left: 0;
	justify-content: center;
}
</style>
</head>
<body>
	<div class="d-flex justify-content-center">
		<img src="<%=contextPath%>/img/zelectronics.png"
			style="max-height: 40px">
	</div>
	<div class="d-flex justify-content-center">
		<p class="display-1"><%
		if(isDbErr){
			%>
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="200" height="200"><path fill="#dc3545" fill-rule="evenodd" d="M12 1.25c-2.487 0-4.774.402-6.466 1.079-.844.337-1.577.758-2.112 1.264C2.886 4.1 2.5 4.744 2.5 5.5v12.987l.026.013H2.5c0 .756.386 1.4.922 1.907.535.506 1.268.927 2.112 1.264 1.692.677 3.979 1.079 6.466 1.079s4.773-.402 6.466-1.079c.844-.337 1.577-.758 2.112-1.264.536-.507.922-1.151.922-1.907h-.026l.026-.013V5.5c0-.756-.386-1.4-.922-1.907-.535-.506-1.268-.927-2.112-1.264C16.773 1.652 14.487 1.25 12 1.25zM4 5.5c0-.21.104-.487.453-.817.35-.332.899-.666 1.638-.962C7.566 3.131 9.655 2.75 12 2.75c2.345 0 4.434.382 5.909.971.74.296 1.287.63 1.638.962.35.33.453.606.453.817 0 .21-.104.487-.453.817-.35.332-.899.666-1.638.962-1.475.59-3.564.971-5.909.971-2.345 0-4.434-.382-5.909-.971-.74-.296-1.287-.63-1.638-.962C4.103 5.987 4 5.711 4 5.5zM20 12V7.871a7.842 7.842 0 01-1.534.8C16.773 9.348 14.487 9.75 12 9.75s-4.774-.402-6.466-1.079A7.843 7.843 0 014 7.871V12c0 .21.104.487.453.817.35.332.899.666 1.638.961 1.475.59 3.564.972 5.909.972 2.345 0 4.434-.382 5.909-.972.74-.295 1.287-.629 1.638-.96.35-.33.453-.607.453-.818zM4 14.371c.443.305.963.572 1.534.8 1.692.677 3.979 1.079 6.466 1.079s4.773-.402 6.466-1.079a7.842 7.842 0 001.534-.8v4.116l.013.013H20c0 .21-.104.487-.453.817-.35.332-.899.666-1.638.962-1.475.59-3.564.971-5.909.971-2.345 0-4.434-.382-5.909-.971-.74-.296-1.287-.63-1.638-.962-.35-.33-.453-.606-.453-.817h-.013L4 18.487V14.37z"></path></svg>
			<%
		}else{
			%>
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="200" height="200"><path fill="#dc3545" d="M10.75 6.5a.75.75 0 000 1.5h6.5a.75.75 0 000-1.5h-6.5zM6 7.25a.75.75 0 01.75-.75h.5a.75.75 0 010 1.5h-.5A.75.75 0 016 7.25zm4 9a.75.75 0 01.75-.75h6.5a.75.75 0 010 1.5h-6.5a.75.75 0 01-.75-.75zm-3.25-.75a.75.75 0 000 1.5h.5a.75.75 0 000-1.5h-.5z"></path><path fill="#dc3545" fill-rule="evenodd" d="M3.25 2A1.75 1.75 0 001.5 3.75v7c0 .372.116.716.314 1a1.742 1.742 0 00-.314 1v7c0 .966.784 1.75 1.75 1.75h17.5a1.75 1.75 0 001.75-1.75v-7c0-.372-.116-.716-.314-1 .198-.284.314-.628.314-1v-7A1.75 1.75 0 0020.75 2H3.25zm0 9h17.5a.25.25 0 00.25-.25v-7a.25.25 0 00-.25-.25H3.25a.25.25 0 00-.25.25v7c0 .138.112.25.25.25zm0 1.5a.25.25 0 00-.25.25v7c0 .138.112.25.25.25h17.5a.25.25 0 00.25-.25v-7a.25.25 0 00-.25-.25H3.25z"></path></svg>
			<%
			
		}
		
		%></p>
	</div>
	<div class="d-flex justify-content-center">
		<p>Oh No! looks like something went wrong with our <%=isDbErr?"database":"server" %></p>
	</div>
	<div class="d-flex justify-content-center">
		<p>One of our developer must be punished for this unacceptable
			failure!</p>
	</div>
	<div class="d-flex justify-content-center">
		<h6>PICK WHO TO FIRE</h6>
	</div>
	
	<div class="d-flex justify-content-center">
		<div  style="min-width: 20%; display: grid ;grid-template-columns:1fr 1fr;">
			<div>
			<div class="d-flex justify-content-center">
			<img src="<%=contextPath%>/img/zane.jpg">
			</div>
			<div class="d-flex justify-content-center">
			<a class="btn btn-danger"
				href="mailto:zaneang.19@ichat.sp.edu.sg?body=YOU ARE FIRED!">Zane</a>
			</div>
			</div>
			<div>
			<div class="d-flex justify-content-center">
			<img src="<%=contextPath%>/img/junHua.jpg">
			</div>
			<div class="d-flex justify-content-center">
			<a class="btn btn-danger" href="mailto:JUNHUA02.19@ichat.sp.edu.sg?body=YOU ARE FIRED!">Jun Hua</a>
			</div>
			</div>
			
		</div>
	</div>
<%@include file="../footer.html" %>
</body>
</html>