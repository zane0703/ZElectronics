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
<title>Bad Gateway</title>
<%@include file="../header.jsp"%>

<div class="d-flex justify-content-center" ><p class="display-1">Oops</p></div>
<div class="d-flex justify-content-center" ><p>Looks like something want wrong with our external API</p></div>
<%@include file="../footer.html" %>
</body>
</html>