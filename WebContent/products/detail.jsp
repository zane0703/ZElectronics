<%@page import="sun.swing.SwingAccessor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="sg.com.zElectronics.model.valueBean.Product,org.apache.commons.text.StringEscapeUtils"%>
<%!
public void jspInit(){
	headerInit();
}
private final java.text.DecimalFormat format = new java.text.DecimalFormat();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Product</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<style>
	#product {
		text-align: center;
	}
	#quantity {
		
	}
</style>
	<%@include file="../header.jsp" %>
	<div class="container">
	<div class="row mt-3">
		<%
			Product product = (Product) request.getAttribute("product");
		%>
		<div class="col-sm-6">
			<img src="<%=product.getImage()%>" class="img-fluid" /> <!-- Make it check for the right image -->
		</div>
		<div class="col-sm-4">
			<h2 id="productName" class="pb-2 border-bottom"><%=StringEscapeUtils.escapeHtml4(product.getTitle()) %></h2>
			<p style="font-size: 1.5em">Price: <%=currency+format.format(product.getRetailPrice()) %></p>
			<p class="h-50"><%=StringEscapeUtils.escapeHtml4( product.getDetailDescription()) %></p>
		</div>
		<div class="col-sm-2">
			<div class="border p-3">
				<p style="font-size: 1.5em; color: red" class="mb-2"><%= currency+format.format(product.getRetailPrice()) %></p>
				<p style="font-size: 1.3em" class="mb-1">Order Now!</p>
				<p style="font-size: 1em; color: red"  class="mb-1"><%= product.getQuantity() %> Left</p>
				<%if(session.getAttribute("logIn")==null){
				out.print("<p>Please login to order</p>");
				}else{    
				    %>
				
				<form action="javascript:addToCart()" class="mb-3" >
					<input type="hidden" value="<%=product.getId()%>">
					<h6 class="d-inline">Quantity: </h6>
					<input type="number" id="qty" name="qty" style="min-width:4rem;" class="form-control input-number w-25 d-inline" value="1" min="1" max="<%= product.getQuantity() %>">
					<button type="submit" class="btn btn-success mt-2 d-block">Add to Cart</button>
				</form>
				<%} %>
			</div>
		</div>
	</div>
	</div>
	<button id="top" title="Go to top">&#8593;</button>
	<%@include file="../footer.html" %>
	<script>
const qty  = document.getElementById("qty")
function addToCart(){
	swal({
		  title: "Loading...",
		  icon: "<%=contextPath%>/img/loading.gif",
		  buttons: false,
	});
	fetch("<%=contextPath%>/api/product/<%=product.getId()%>/cart",{
		method:"POST",
		headers:{
			'Content-Type': 'application/x-www-form-urlencoded'
		},
		body:"qty="+qty.value
	}).then(res=>{
		if(res.ok){
			swal({
				icon:"success",
				title:"You have successfully added a product to cart"
			}).then(()=>window.location.href= "<%=contextPath%>/cart")
			
		}else{
			swal({
				icon:"error",
				title:"Look like something went wrong",
				text: "error code "+res.status
			})
		}
	})
}
</script>
</body>

</html>
		