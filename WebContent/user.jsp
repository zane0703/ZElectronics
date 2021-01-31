<%@ page language="java"
	import="org.apache.commons.text.StringEscapeUtils,sg.com.zElectronics.model.valueBean.User,sg.com.zElectronics.model.valueBean.Order,java.text.SimpleDateFormat"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!public void jspInit() {
		headerInit();
	}
private final java.text.DecimalFormat format = new java.text.DecimalFormat();
	private final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("d MMM yyyy");%>
<!DOCTYPE html>
<%
	User user = (User) request.getAttribute("userInfo");
if (user == null) {
	response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
	return;
}
String symbol= (String)request.getAttribute("symbol");
%>
<html>
<head>
<meta charset="ISO-8859-1">
<title>user</title>
<style type="text/css">
th {
	margin: 0;
	border: #ff3333;
}

table {
	border-collapse: collapse;
}

.table tr {
	text-align: center
}
</style>

<%@ include file="header.jsp"%>
<article style="display: grid; grid-template-columns: 1fr 1fr;">
	<div id="info" class="ml-5">
		<h1>My info</h1>
		<img src="<%=user.getImage()%>"
			style="max-height: 500px; max-width: 100%;" alt="profile">
		<h3><%=StringEscapeUtils.escapeHtml4(user.getName())%></h3>
		<h3><%=StringEscapeUtils.escapeHtml4(user.getEmail())%></h3>
		<table >
		<tbody>
		<tr>
		<td>Account type:</td>
		<td><%=request.getAttribute("role")%></td>
		</tr>
		<tr>
		<td>Contact Number:</td>
		<td><%=StringEscapeUtils.escapeHtml4(user.getContact())%></td>
		</tr>
		<tr>
		<td>Address:</td>
		<td><%=StringEscapeUtils.escapeHtml4(user.getAddress())%></td>
		</tr>
		<tr>
		<td>Country:</td>
		<td><%=StringEscapeUtils.escapeHtml4(user.getCountry())%></td>
		</tr>
		<tr>
		<td>Postal Code:</td>
		<td><%=user.getPostalCode()%></td>
		</tr>
		<tr>
		<td>Amount Span:</td>
		<td><%=(symbol==null?"S$":symbol+" ")+format.format(user.getSpent())%></td>
		</tr>
		<tr>
		<td>Joined at:</td>
		<td><%=simpleDateFormat.format(user.getCreatedAt())%></td>
		</tr>
		</tbody>
		</table>
		<%
			String editLink = (String) request.getAttribute("editLink");
				if (!editLink.equals("not")) {
			out.print("<a class=\"btn btn-primary\" href=\"" + editLink + "/edit\">Edit</a>");
				}
		%>
	</div>

	<div>
		<h2>My Orders</h2>
		<div id="offer">
			<%
			@SuppressWarnings("unchecked")
				ArrayList<Order> orders = (ArrayList<Order>) request.getAttribute("order");
			if (orders.size() > 0) {
			%>
			<table class="table">
				<thead>
					<tr>
						<th>No</th>
						<th style="width: 50%">Product Title</th>
						<th>Quantity</th>
						<th>status</th>
					</tr>
				</thead>
				<tbody>
					<%
						int j = 1;
					for (Order order : orders) {
					%>
					<tr>
						<td><%=j++%></td>
						<td><a href="<%=contextPath%>/product/<%=order.getFkProductId() %>"><%=StringEscapeUtils.escapeHtml4(order.getProductTitle())%></a></td>
						<td><%=order.getQuantity()%></td>
						<td>
							<%
								switch (order.getStatus()) {
							case -1:
								out.print("rejected");
								break;
							case 0:
								out.print("panding");
								break;
							case 1:
								out.print("accepted");
								break;
							case 2:
								out.print("sent");
								break;
							}
							%>
						</td>
						<td>
					</tr>
					<%
						}
					out.print("</tbody></table>");
					}
					%>
					</div>
					</div>
					</article>
					<button  id="top" title="Go to top">&#8593;</button>
					</body>
					</html>