<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="sg.com.zElectronics.model.valueBean.Product,java.util.ArrayList,org.apache.commons.text.StringEscapeUtils"%>
    <%!
public void jspInit(){
	headerInit();
}
ArrayList<Product> products;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Home</title>
<style>
	#banner {
		background-color: #ffccbf
	}
	#indicators .active{
		background-color: #ff918f
	}
	#feature {
		text-align: center
	}
	#feature > img {
		height: 300px;
	}
	img{
	max-width:100%;
	max-height:100%;
	}
</style>
	<%@include file="header.jsp" %>
	<div class="container-fluid">
	<div class="row" style="margin-top: 10px">
		<div class="col-sm-2"></div>
		<div id="banners" class="carousel slide col-sm-8" data-ride="carousel">
		  <!-- Indicators -->
		  <ul class="carousel-indicators" id="indicators">
		    <li id="banner" data-target="#banners" data-slide-to="0" class="active"></li>
		    <li id="banner" data-target="#banners" data-slide-to="1"></li>
		  </ul>
		  <!-- The slideshow -->
		  <div class="carousel-inner">
		    <div class="carousel-item active">
		      <img src="img/banner1.png" class="img-fluid" alt="Banner 1">
		    </div>
		    <div class="carousel-item">
		      <img src="img/banner2.png" class="img-fluid" alt="Banner 2">
		    </div>
		  </div>
		  
		  <!-- Left and right controls -->
		  <a class="carousel-control-prev" href="#banners" data-slide="prev">
		    <span class="carousel-control-prev-icon"></span>
		  </a>
		  <a class="carousel-control-next" href="#banners" data-slide="next">
		    <span class="carousel-control-next-icon"></span>
		  </a>
		</div>
		<div class="col-sm-2"></div>
	</div>
	<div class="row mt-3">
		<div class="col-sm-2"></div>
		<div class="col-sm-8">
			<h1 style="text-align: center">Featured Products</h1>
			<div class="row">
			<%
			
			products= (ArrayList<Product>) request.getAttribute("product");
			if(products==null){
				response.sendError(404," The requested resource ["+request.getRequestURI()+"] is not available");
				return;
			}
				for (Product product:products) {
			%>
				<div class="col-md-4" id="feature">
					<div class="card">
					  <div style="height:200px"><img class="card-img-top pt-2" src="<%=product.getImage() %>" style="width: 200px;"></div>
					  <div class="card-body mt-auto">
					    <h5 class="card-title"><%=StringEscapeUtils.escapeHtml4(product.getTitle()) %></h5>
					    <a href="product/<%=product.getId()%>" class="btn btn-primary">View Product</a>
					  </div>
					</div>
				</div>
			<%
				}
			%>
			</div>
			<div class="text-center my-3">
				<button onclick="window.location.href='product'" class="btn btn-success w-50">View More</button>
			</div>
		</div>
		<div class="col-sm-2"></div>
	</div>
	</div>
	<button id="top" title="Go to top">&#8593;</button>
	<%@include file="footer.html" %>
</body>
</html>