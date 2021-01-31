<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.JSONArray,java.text.SimpleDateFormat,java.text.DecimalFormat,org.apache.commons.text.StringEscapeUtils,java.util.ArrayList,sg.com.zElectronics.model.valueBean.Order,sg.com.zElectronics.model.valueBean.Country,org.json.JSONArray"%>
<%!private DecimalFormat format = new DecimalFormat();
	public void jspInit() {
		headerInit();
	}
	private final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("d MMMM yyyy");%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin</title>
<%
	@SuppressWarnings("unchecked")
ArrayList<Order> orders = (ArrayList<Order>) request.getAttribute("order");
String productId = (String) request.getAttribute("productId");
String buyerId = (String) request.getAttribute("buyerId");
if (orders == null) {
	response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
	return;
}
int pageAmount = (Integer) request.getAttribute("page");
Country[] countries = (Country[]) request.getAttribute("country");
%>

<style>
#product {
	text-align: center;
}

.detilePage {
	display: grid;
	grid-template-columns: min-content auto;
}

.detilePageIn {
	display: grid;
	grid-auto-rows: 2.5rem;
	grid-template-columns: 100%;
}

.detilePageIn>p, .detilePageIn>a {
	text-align: left;
}
</style>
<%@include file="../header.jsp"%>
<div class="container-fluid">
	<div class="row mt-5">
		<!-- Create a For Loop Here to get the necessary amount of rows for products -->
		<div class="col-sm-3">
			<div class="pl-5">
				<h4>Status:</h4>
				<select id="statusInput" class="form-control">
					<option value="0">All</option>
					<option value="2">Padding</option>
					<option value="3">Accept</option>
					<option value="4">Sent</option>
					<option value="1">Reject</option>
				</select>
				<h4>Year:</h4>
				<input type="number" min="0" class="form-control" id="yearInput">
				<h4>Month:</h4>
				<select id="monthInput" class="form-control">
					<option value="0">All Months</option>
					<option value="1">January</option>
					<option value="2">February</option>
					<option value="3">March</option>
					<option value="4">April</option>
					<option value="5">May</option>
					<option value="6">June</option>
					<option value="7">July</option>
					<option value="8">August</option>
					<option value="9">September</option>
					<option value="10">October</option>
					<option value="11">November</option>
					<option value="12">December</option>
				</select>
				<h4>Day Of Date:</h4>
				<div  class="form-inline">
				<span>From:</span>
				<input min="0" type="number" id="dayInput" max="31"
					class="form-control">
					<span>&nbsp;To:</span>
					<input min="0" type="number" id="dayToInput" max="31"
					class="form-control">
				</div>
				
				<h4>Week:</h4>
				<select id="weekInput" class="form-control">
					<option value="0">All Weeks</option>
					<option value="2">Monday</option>
					<option value="3">Tuesday</option>
					<option value="4">Wednesday</option>
					<option value="5">Thursday</option>
					<option value="6">Friday</option>
					<option value="7">Saturday</option>
					<option value="1">Sunday</option>
				</select>
				<h4>Ship Country:</h4>
				 <select id="country" class="form-control">
					<option value="">All Country</option>
					<%
						for (Country country : countries) {
						out.print("<option value=\"" + country.getAlpha3Code() + "\">" + country.getName() + "</option>");
					}
					%>
				</select>
				<button class="btn btn-success mt-2 w-50"
					onclick="page=1;loadOrder();this.blur();">Filter</button>
			</div>
		</div>
		<div class="col-sm-9">
			<div class="dropdown">
				<button class="btn btn-success dropdown-toggle" type="button"
					id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false">Sort By</button>
				<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
					<a class="dropdown-item" href="javascript:sort(0)">new</a>
					 <a class="dropdown-item" href="javascript:sort(1)">old</a> 
					 <a class="dropdown-item" href="javascript:sort(3)">Postal code (Lowest to Highest)</a> 
						<a class="dropdown-item"href="javascript:sort(4)">Postal code (Highest to Lowest)</a>
				</div>
			</div>
			<button class="btn btn-info" id="back" style="display: none"
				onclick="this.style.display='none';onReloadProduct('')" )>Back</button>
			<table class="table table-striped">
				<thead id="thead">
					<tr>
						<th>Id</th>
						<th>Product Title</th>
						<th>Quantity</th>
						<th>Buyer</th>
						<th>Order Date</th>
						<th>Order Details</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="tbody">
					<%
						for (Order order : orders) {
						int pId = order.getId();
					%>
					<tr>
						<td><%=pId%></td>
						<td><a
							href="<%=contextPath + "/product/" + order.getFkProductId()%>"><%=StringEscapeUtils.escapeHtml4(order.getProductTitle())%></a>
						</td>
						<td><%=order.getQuantity()%></td>
						<td><a href="users/<%=order.getFkBuyerId()%>"><%=StringEscapeUtils.escapeHtml4(order.getBuyerName())%></a>
						</td>
						<td><%=simpleDateFormat.format(order.getCreatedAt())%></td>
						<td>
							<button type="button" onclick="showDetile(<%=pId%>)"
								class="btn btn-primary">Details</button>
						</td>
						<td>
							<%
								switch (order.getStatus()) {
								case -1 :
									out.print("rejected");
									break;
								case 0 :
							%>
							<button class="btn btn-danger"
								onclick="respondOrder(-1,<%=pId%>)">Reject</button>
							<button class="btn btn-success"
								onclick="respondOrder(1,<%=pId%>)">Accept</button> <%
 	break;
 case 1 :
 	out.print("<button class=\"btn btn-success\" onclick=\"respondOrder(2," + pId + ")\" >Send</button>");
 	break;
 case 2 :
 	out.print("Sent");

 }
 %>
						</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<div class="justify-content-center" style="display: none"
				id="loading">
				<img src="<%=contextPath%>/img/loading.gif">
			</div>
			<div class="d-flex justify-content-center">
				<div>
					<button disabled onclick="this.blur();onChangePage(1)"
						class="btn btn-primary" id="firstPage">First</button>
					<button disabled id="previousPage"
						onclick="this.blur();onChangePage(page-1)" class="btn btn-primary"
						disabled>Previous</button>
					Page: <input type="number" id="pageInput" value="1"
						max="<%=pageAmount%>" />/<span id="pageNum"><%=pageAmount%></span>
					<button onclick="this.blur();onChangePage(page+1)" id="nextPage"
						class="btn btn-primary"
						<%if (pageAmount <= 1)
	out.print("disabled");%>>Next</button>
					<button id="lastPage" class="btn btn-primary"
						<%if (pageAmount <= 1)
	out.print("disabled");%>
						onclick="onChangePage(<%=pageAmount%>)">Last</button>
				</div>
			</div>
		</div>
	</div>
	<button id="top" title="Go to top">&#8593;</button>
	<%@include file="../footer.html"%>
	<script>
			function resizeIframe(obj) {
				obj.style.height = obj.contentWindow.document.documentElement.scrollHeight + 'px';
			}
			const thead = document.getElementById("thead");
			const tbody = document.getElementById("tbody");
			const back = document.getElementById("back");
			const FIRST_page = document.getElementById("firstPage")
			const PREV_PAGE = document.getElementById("previousPage")
			const PAGE_INPUT = document.getElementById("pageInput")
			const NEXT_PAGE = document.getElementById("nextPage")
			const LAST_PAGE = document.getElementById("lastPage")
			const PAGE_NUM = document.getElementById("pageNum")
			const YEAR_INPUT = document.getElementById("yearInput")
			const MONTH_INPUT = document.getElementById("monthInput")
			const DAY_INPUT = document.getElementById("dayInput")
			const DAY_TO_INPUT = document.getElementById("dayToInput")
			const WEEK_INPUT = document.getElementById("weekInput")
			const LOADING = document.getElementById("loading");
			const STATUS_INPUT=document.getElementById("statusInput");
			const COUNTRY =document.getElementById("country");
			listOfCountry = JSON.parse('<%=new JSONArray(countries).toString().replace("'", "\\'")%>')
			
			YEAR_INPUT.max = new Date().getFullYear();
			let page = 1
			let detileDiv = document.createElement("div");
			let detileDiv1 = document.createElement("div");
			let detileDiv2 = document.createElement("div");
			detileDiv.appendChild(detileDiv1)
			detileDiv.appendChild(detileDiv2)
			detileDiv.classList.add("detilePage")
			detileDiv1.classList.add("detilePageIn")
			detileDiv2.classList.add("detilePageIn")
			detileDiv1.innerHTML = "<p><b>Id:</b></p><p><b>product&nbsp;title:</b></p><p><b>Buyer</b></p><p><b>Buyer&nbsp;Contact:</b></p><p><b>Buyer&nbsp;Email:</b></p><p><b>Quantity:</b></p><p><b>Ship&nbsp;Address:</b></p><p><b>Ship&nbsp;Country:</b></p><p><b>Ship&nbsp;Postal&nbsp;Code:</b><p><b>Bill&nbsp;Address:</b></p><p><b>Bill&nbsp;Country:</b></p><p><b>Bill&nbsp;Postal&nbsp;Code:</b></p><p><b>Status:</b></p><p><b>Date&nbsp;Order:</b></p><p><b>Week&nbsp;Order:</b></p>";
			let detileId = document.createElement("p");
			let detileTitle = document.createElement("a");
			let detileBN = document.createElement("a");
			let detileBC = document.createElement("a");
			let detileBE = document.createElement("a");
			let detileQty = document.createElement("p");
			let detileSA = document.createElement("p");
			let detileSC = document.createElement("p");
			let detileSP = document.createElement("p");
			let detileBA = document.createElement("p");
			let detileBiC = document.createElement("p");
			let detileBP = document.createElement("p");
			let detileStatus = document.createElement("a");
			let detileDate = document.createElement("p");
			let detileWeek = document.createElement("p");
			detileTitle.style.display = "block"
			detileBN.style.display = "block"
			detileDiv2.appendChild(detileId);
			detileDiv2.appendChild(detileTitle);
			detileDiv2.appendChild(detileBN);
			detileDiv2.appendChild(detileBC);
			detileDiv2.appendChild(detileBE);
			detileDiv2.appendChild(detileQty);
			detileDiv2.appendChild(detileSA);
			detileDiv2.appendChild(detileSC);
			detileDiv2.appendChild(detileSP);
			detileDiv2.appendChild(detileBA);
			detileDiv2.appendChild(detileBiC);
			detileDiv2.appendChild(detileBP);
			detileDiv2.appendChild(detileStatus);
			detileDiv2.appendChild(detileDate);
			detileDiv2.appendChild(detileWeek);
			DAY_TO_INPUT.addEventListener("keydown", (e) => {
				if (e.which === 13 || e.keyCode == 13) {
					if(!DAY_INPUT.value|parseInt(DAY_TO_INPUT.value)<parseInt(DAY_INPUT.value)){
						DAY_INPUT.value = DAY_TO_INPUT.value
						DAY_INPUT.focus();
					}else{
						page = PAGE_INPUT.value
						loadOrder();
						PAGE_INPUT.blur();
					}
					
				}
			});
			DAY_INPUT.addEventListener("keydown", (e) => {
				if (e.which === 13 || e.keyCode == 13) {
					DAY_TO_INPUT.focus();
					if(!DAY_TO_INPUT.value||parseInt(DAY_TO_INPUT.value)<parseInt(DAY_INPUT.value )){
						DAY_TO_INPUT.value=formValue
					}
				}
			});
			DAY_INPUT.addEventListener("change",()=>{
				let formValue = parseInt(DAY_INPUT.value)
				if(!DAY_TO_INPUT.value||parseInt(DAY_TO_INPUT.value)<formValue ){
					DAY_TO_INPUT.value=formValue
				}
				
			})
			DAY_TO_INPUT.addEventListener("change",()=>{
				if(parseInt(DAY_TO_INPUT.value)<parseInt(DAY_INPUT.value)){
					DAY_INPUT.value = DAY_TO_INPUT.value
				}
				
			})
			let month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
			let dayOfWeek=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
			let sort2 = 0;
			function showDetile(id) {
				swal({
					title: "Loading...",
					icon: "<%=contextPath%>/img/loading.gif",
					buttons: false,
				});
				fetch("<%=contextPath%>/api/orders/" + id).then(res => {
					if (res.ok) {
						res.json().then(data => {
							detileId.textContent = data.id;
							detileTitle.textContent = data.productTitle
							detileTitle.href = "<%=contextPath%>/product/" + data.fkProductId
							detileBN.textContent = data.buyerName;
							detileBN.href = "users/" + data.fkBuyerId;
							detileBC.textContent = data.buyerContact;
							detileBC.href="tel:"+data.buyerContact;
							detileBE.textContent = data.buyerEmail;
							detileBE.href="mailto:"+data.buyerEmail;
							detileQty.textContent = data.quantity;
							detileSA.textContent = data.shipAddress;
							detileSC.textContent= listOfCountry.find(x=>x.alpha3Code===data.shipCountry).name;
							detileSP.textContent = data.shipPostal;
							detileBA.textContent = data.billAddress;
							detileBiC.textContent = listOfCountry.find(x=>x.alpha3Code===data.billCountry).name;
							detileBP.textContent = data.billPostal;
							detileStatus.innerHTML = ""
							switch (data.status) {
								case -1:
									detileStatus.innerHTML = "<p>Rejected</p>";
									break;
								case 0:
									let reject = document.createElement("button")
									reject.textContent = "Reject"
									reject.addEventListener("click", respondOrder.bind(null, -1, data.id))
									reject.classList.add("btn", "btn-danger")
									detileStatus.appendChild(reject);
									let accept = document.createElement("button");
									accept.textContent = "Accept"
									accept.addEventListener("click", respondOrder.bind(null, 1, data.id))
									accept.classList.add("btn", "btn-success");
									detileStatus.appendChild(accept)
									break;
								case 1:
									let sent = document.createElement("button")
									sent.textContent = "Send"
									sent.classList.add("btn", "btn-success")
									sent.addEventListener("click", respondOrder.bind(null, 2, data.id))
									detileStatus.appendChild(sent);
									break;
								case 2:
									detileStatus.innerHTML = "<p>Sent<p>"
									break;
							}
							let orderDate = new Date(data.createdAt);
							detileDate.textContent = orderDate.getDate() + " " + month[orderDate.getMonth()] + " " + orderDate.getFullYear();
							detileWeek.textContent = dayOfWeek[orderDate.getDay()]
							swal({
								title: "Order Details",
								content: detileDiv
							});


						})
					}else{
						swal({
							icon: "error",
							title: "Look like something went wrong",
							text: "error code " + res.status
						})
					}
				})
			}
			function loadOrder() {
				LOADING.style.display="flex";
					tbody.innerHTML = "";
				fetch("<%=contextPath%>/api/orders?<%=(productId == null ? "" : "productId = " + productId + " & ")
		+ (buyerId == null ? "" : "buyerId = " + buyerId + " & ")%>limit=10&page=" + page + "&sort=" + sort2+(YEAR_INPUT.value?"&year="+YEAR_INPUT.value:"")+"&month="+MONTH_INPUT.value+(DAY_INPUT.value?"&day="+DAY_INPUT.value+"&dayTo="+DAY_TO_INPUT.value:"")+"&week="+WEEK_INPUT.value+"&status="+STATUS_INPUT.value+(COUNTRY.value?"&country="+COUNTRY.value:"")).then(res => {
					if (res.ok) {
						res.json().then(data => {
							LOADING.style.display="none";
							tbody.innerHTML = "";
							data[1].forEach(x => {
								let tr = document.createElement("tr");
								let th1 = document.createElement("td");
								let th2 = document.createElement("td");
								let th3 = document.createElement("td");
								let th4 = document.createElement("td");
								let th5 = document.createElement("td");
								let th6 = document.createElement("td");
								let th7 = document.createElement("td");
								th1.textContent = x.id;
								th3.textContent = x.quantity;
								let proTitle = document.createElement("a");
								proTitle.href = "<%=contextPath%>/product/" + x.fkProductId
								proTitle.textContent = x.productTitle
								th2.appendChild(proTitle)
								let buyer = document.createElement("a");
								buyer.textContent = x.buyerName;
								buyer.href = "users/" + x.fkBuyerId
								th4.appendChild(buyer)
								let orderDate = new Date(x.createdAt);
								th5.textContent = orderDate.getDate() + " " + month[orderDate.getMonth()] + " " + orderDate.getFullYear();
								let modalBtn = document.createElement("button")
								modalBtn.classList.add("btn", "btn-primary")
								modalBtn.textContent = "Details"
								modalBtn.addEventListener("click", showDetile.bind(null, x.id))
								th6.appendChild(modalBtn)

								switch (x.status) {
									case -1:
										th7.textContent = "rejected";
										break;
									case 0:
										let reject = document.createElement("button")
										reject.textContent = "Reject"
										reject.addEventListener("click", respondOrder.bind(null, -1, x.id))
										reject.classList.add("btn", "btn-danger")
										th7.appendChild(reject);
										let accept = document.createElement("button");
										accept.textContent = "Accept"
										accept.addEventListener("click", respondOrder.bind(null, 1, x.id))
										accept.classList.add("btn", "btn-success");
										th7.appendChild(accept)
										break;
									case 1:
										let sent = document.createElement("button")
										sent.textContent = "Send"
										sent.classList.add("btn", "btn-success")
										sent.addEventListener("click", respondOrder.bind(null, 2, x.id))
										th7.appendChild(sent);
										break;
									case 2:
										th7.textContent = "Sent"
										break;
								}
								tr.appendChild(th1);
								tr.appendChild(th2);
								tr.appendChild(th3);
								tr.appendChild(th4);
								tr.appendChild(th5);
								tr.appendChild(th6);
								tr.appendChild(th7);
								tbody.appendChild(tr);
							})
							if (page > 1) {
								PREV_PAGE.disabled = false
								FIRST_page.disabled = false
							} else {
								PREV_PAGE.disabled = true
								FIRST_page.disabled = true
							}
							let pageAmount = Math.floor((data[0] - 1) / 10) + 1
							PAGE_INPUT.max = pageAmount;
							LAST_PAGE.onclick = onChangePage.bind(null, pageAmount)
							PAGE_NUM.textContent = pageAmount
							if (page < pageAmount) {
								NEXT_PAGE.disabled = false;
								LAST_PAGE.disabled = false;
							} else {
								NEXT_PAGE.disabled = true;
								LAST_PAGE.disabled = true;
							}
						})
					}else{
						swal({
							icon: "error",
							title: "Look like something went wrong",
							text: "error code " + res.status
						})
					}
				})
			}
			function respondOrder(sta, id) {
				swal({
					title: "Loading...",
					icon: "<%=contextPath%>/img/loading.gif",
					buttons: false,
				});
				fetch("<%=contextPath%>/api/orders/" + id + "/status", {
					method: "PATCH",
					body: sta.toString(),
					headers: {
						'Content-Type': 'text/plain',
					}
				}).then(res => {
					if (res.ok) {
						swal.close()
						loadOrder()
					} else {
						swal({
							icon: "Error",
							title: "Look like something went wrong",
							text: "error code " + res.status
						})
					}
				})

			}
			function sort(value) {
				sort2 = value
				PAGE_INPUT.value = 1
				page = 1
				loadOrder()
			}
			function onChangePage(value) {
				page = value
				PAGE_INPUT.value = value
				loadOrder()
			}

		</script>
	</body>