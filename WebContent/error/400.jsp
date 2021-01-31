<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
    <%!
public void jspInit(){
	headerInit();
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bad Request</title>
<%@include file="../header.jsp"%>

<div class="d-flex justify-content-center" ><p class="display-1">Oops</p></div>
<div class="d-flex justify-content-center" ><p>Looks like you give the wrong input</p></div>
<div class="d-flex justify-content-center" ><p><%=request.getAttribute("javax.servlet.error.message") %></p></div>
<div class="d-flex justify-content-center" ><div style="min-width:15rem;display:flex;justify-content:space-between" ><button class="btn btn-danger" onclick="window.history.back()">Go Back</button><a class="btn btn-warning" href="<%=contextPath%>">Go Home</a></div></div>
<%@include file="../footer.html" %>
</body>
</html>