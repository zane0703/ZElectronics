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
<title>Not Found</title>
<%@include file="../header.jsp"%>

<div class="d-flex justify-content-center" ><p class="display-1">Oops</p></div>
<div class="d-flex justify-content-center" ><p>Looks like the content you are looking for in [<%=request.getAttribute("javax.servlet.error.request_uri")%>] not found</p></div>
<div class="d-flex justify-content-center" ><div style="min-width:15rem;display:flex;justify-content:space-between" ><button class="btn btn-danger" onclick="window.history.back()">Go Back</button><a class="btn btn-warning" href="<%=contextPath%>">Go Home</a></div></div>
<%@include file="../footer.html" %>
</body>
</html>