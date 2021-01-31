<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="org.json.JSONArray,org.apache.commons.text.StringEscapeUtils,sg.com.zElectronics.model.valueBean.Cart,java.util.ArrayList"
	pageEncoding="UTF-8"%>
<%!public void jspInit() {
		headerInit();
	}

	private final java.text.DecimalFormat format = new java.text.DecimalFormat();%>
<%
	double total = 0;
@SuppressWarnings("unchecked")
ArrayList<Cart> carts = (ArrayList<Cart>) request.getAttribute("cart");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Cart</title>
<%@include file="header.jsp"%>
<%
try {
	if (carts == null) {
		response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
	}
%>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-9">
			<%
				if (!carts.isEmpty()) {
				out.print("<h3 class=\"border-bottom pl-4 py-3\">Cart</h3>");

				int j = 1;
				double price = 0;
				double uTotal = 0;
				int qty = 0;
				int pid = 0;
				for (Cart cart : carts) {
					price = cart.getProductRetailPrice() * 100;
					qty = cart.getQuantity();
					uTotal = price * qty;
					total += uTotal;
					pid = cart.getId();
			%>
			<div class="row">
				<div class="col-sm-3">
					<img src="<%=cart.getProductImage()%>" class="img-fluid" />
				</div>
				<div class="col-sm-4">
					<h3><%=StringEscapeUtils.escapeHtml4(cart.getProductTitle())%></h3>
					<a onclick="del(<%=pid + "," + uTotal%>,this)"
						href="javascript:void(0)" class="d-inline">Delete</a>
					<!-- Remove Item Function -->
					<p class="d-inline mx-2">|</p>
					<a href="javascript:update(<%=pid + "," + price%>)"
						class="d-inline">Update</a>
					<!-- Update Quantity Count Function -->
				</div>
				<div class="col-sm-2">
					<h4><%=currency%> <span id="price<%=pid%>"><%= format.format(uTotal / 100)%></span></h4>
				</div>
				<div class="col-sm-3">
					<h6 class="d-inline">Quantity:</h6>
					<input type="number" id="qty<%=pid%>"
						class="form-control input-number w-50 d-inline" value="<%=qty%>"
						min="1" max="<%=qty + cart.getProductQty()%>">
				</div>
			</div>
			<%
				}
			} else {
			out.print(
					"<p style=\"position: absolute;top: 50%;left: 50%;transform: translate(-50%,-50%);\">No Products to Show</p>");
			}

			} catch (NullPointerException e) {
			out.print(
					"<p style=\"position: absolute;top: 50%;left: 50%;transform: translate(-50%,-50%);\">No Products to Show</p>");
			}
			%>
		</div>

		<div class="col-sm-3 border p-3">
			<h3 class="border-bottom">Subtotal</h3>
			<%
				double subTotal = ((double) Math.round(total / 1.07)) / 100;
			%>
			<h4>
				<%=currency%><span id="subTotal" ><%=format.format(subTotal)%></span></h4>
			<h3 class="border-bottom">GST 7%</h3>
			<h4>
				<%=currency%> <span id="gst" ><%= format.format(((double) Math.round((subTotal * 0.07) * 100)) / 100)%></span></h4>
			<h3 class="border-bottom">Total</h3>
			<h4>
				<%=currency%><span id="total" ><%=format.format(total / 100) %></span></h4>
			<a class="btn btn-success mt-2"
				<%=carts.isEmpty() ? "" : "href=\"payment\""%>>Proceed to
				Checkout</a>
		</div>
	</div>
	<button class="btn btn-info" id="top" title="Go to top">&#8593;</button>
</div>
<%@include file="footer.html" %>
<script>
	let total = <%=total%>;
	const SUB_TOTAL = document.getElementById("subTotal")
	const Total_ELEMENT = document.getElementById("total")
	const GST = document.getElementById("gst")
function del(id,price,that){
		swal({
			title: "Are you Sure you want to delete product from cart",
			icon: 'warning',
			dangerMode: true,
			buttons: ['Cancel', 'Delete']
		}).then(resolve=>{
			if(resolve){
				swal({
					  title: "Loading...",
					  icon: "img/loading.gif",
					  buttons: false,
				});
	 fetch("<%=contextPath%>/api/cart/"+id,{
		method:"DELETE"
	}).then(res=>{
		swal.close()
		if(res.ok){
			let priceElement = document.getElementById("price"+id)
			  total-= parseFloat(priceElement.textContent.replace(",",""))*100
			let div =  that.parentElement.parentElement
			  div.parentElement.removeChild(div);
			  Total_ELEMENT.textContent = (total/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			  let subTotal =  Math.round(total/1.07);
			GST.textContent = (Math.round((subTotal*0.07))/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			SUB_TOTAL.textContent = (subTotal/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");

		}else{
			swal({
				icon:"error",
				title:"Look like something went wrong",
				text: "error code "+res.status
			})
		}
	})
			}})
}
function update(id,price){
	let newQty =  document.getElementById("qty"+id).value
	swal({
		  title: "Loading...",
		  icon: "img/loading.gif",
		  buttons: false,
	});
	fetch("<%=contextPath%>/api/cart/"+id,{
		method:"PUT",
		body:"qty="+newQty,
		 headers: {
		      'Content-Type': 'application/x-www-form-urlencoded',
		    }
	}).then(res=>{
		swal.close()
		if(res.ok){
			newQty = parseInt(newQty)
			price*=newQty;
			let priceElement = document.getElementById("price"+id)
			let uTotal =  parseFloat(priceElement.textContent.replace(",",""))*100
			priceElement.textContent=(price/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			price -=uTotal
			console.log(price)
			total += price
			Total_ELEMENT.textContent = (total/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			let subTotal =  Math.round(total/1.07);
			GST.textContent = (Math.round((subTotal*0.07))/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			SUB_TOTAL.textContent = (subTotal/100).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
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