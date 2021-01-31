<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.text.DecimalFormat,org.apache.commons.text.StringEscapeUtils,java.util.ArrayList,sg.com.zElectronics.model.valueBean.Order,sg.com.zElectronics.model.valueBean.Product,org.json.JSONArray"%>
<%!private final DecimalFormat FORMET = new DecimalFormat();
	public void jspInit() {
		headerInit();
	}%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Admin</title>
	<%
		@SuppressWarnings("unchecked")
		ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("product");
	if (products == null) {
		response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
		return;
	}
	int pageAmount = (Integer) request.getAttribute("page");
	%>
	<style type="text/css">
		#product {
			text-align: center;
		}

		.container {
			margin: 0
		}
	</style>
	<%@include file="header.jsp"%>

	<div class="container-fluid">
		<div class="row mt-5">
			<!-- Create a For Loop Here to get the necessary amount of rows for products -->
			<div class="col-md-3">
				<div class="pl-5">
					<h4>Product Type:</h4>
					<select class="form-control" name="cat" id="cat" onchange="onChangeCat(value);">>
						<option value="0">all</option>
						<%
							String catId = request.getParameter("catId");
									if (catId == null) {
										for (Category category : categories) {
											out.print("<option value=\"" + category.getId() + "\">" + category.getName() + "</option>");
										}
									} else {
										for (Category category : categories) {
											out.print("<option value=\"" + category.getId() + "\" "
											+ (Integer.parseInt(catId) == category.getId() ? "selected" : "") + " >" + category.getName()
											+ "</option>");
										}
									}
						%>
					</select>
					<h4 class="mt-2">Price Range:</h4>
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text">S$</span>
						</div>
						<input id="Range" type="number" min="0" class="form-control" placeholder="Maximum Price"
							step="any" />
					</div>
					<h4 class="mt-2">Search:</h4>
					<div class="input-group">
						<input id="aSearch" type="text" class="form-control" placeholder="Item Name" />
					</div>
					<button onClick="onChangeRange()" class="btn btn-success mt-2 w-50">Filter</button>
					<h4 class="mt-2">Category</h4>
					<table class="table table-striped">
						<thead>
							<tr>
								<th>Id</th>
								<th>Name</th>
								<th></th>
							</tr>
						</thead>
						<tbody id="catList">

							<%
							for (Category category : categories) {
							out.print("<tr><td>" + category.getId() + "</td><td>" + category.getName()
							+ "</td><td><button class=\"btn btn-danger\" onClick=\"delCat(" + category.getId()
							+ ",this)\" >X</button></tr>");
						}
						%>
						</tbody>
					</table>
					<div class="form-inline">
						<input id="addCatTxt" type="text" class="form-control" placeholder="Add Category">
						<button onClick="addCat()" class="btn btn-success">Add</button>
					</div>
				</div>
			</div>
			<div class="col-md-9">
				<div class="dropdown">
					<button class="btn btn-success dropdown-toggle" type="button" id="dropdownMenuButton"
						data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Sort By:</button>
					<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
						<a class="dropdown-item" href="javascript:sort(7)">Title</a>
						<a class="dropdown-item" href="javascript:sort(5)">new</a>
						<a class="dropdown-item" href="javascript:sort(6)">old</a>
						<a class="dropdown-item" href="javascript:sort(1)">Price (Lowest to Highest)</a>
						<a class="dropdown-item" href="javascript:sort(2)">Price (Highest to Lowest)</a>
						<a class="dropdown-item" href="javascript:sort(4)">popular</a> 
						<a class="dropdown-item" href="javascript:sort(3)">unpopular</a>
						<a class="dropdown-item" href="javascript:sort(8)">Quantity (Lowest to Highest)</a>
						<a class="dropdown-item" href="javascript:sort(9)">Quantity (Highest to Lowest)</a>
					</div>
				</div>
				<table class="table table-striped">
					<thead id="thead">
						<tr>
							<th>Id</th>
							<th>name</th>
							<th>Category</th>
							<th>Quantity</th>
							<th>Order Amount</th>
							<th>Cost Price</th>
							<th>Retail Price</th>
							<td></td>
						</tr>
					</thead>
					<tbody id="tbody">
						<%
						for (Product product : products) {
						int pId = product.getId();
					%>
						<tr>
							<td><%=pId%></td>
							<td><%=StringEscapeUtils.escapeHtml4(product.getTitle())%></td>
							<td><%
							int fKCategoryId = product.getfKCategoryId();
							for(Category category:categories){
								if(category.getId()==fKCategoryId){
									out.print(StringEscapeUtils.escapeHtml4(category.getName()));
									break;
								}
							}
							%></td>
							<td ><%=product.getQuantity()%></td>
							<td><a href="<%=contextPath%>/admin/order?productId=<%=pId%>" ><%=product.getOrderAmount()%></a></td>
							<td>S$<%=FORMET.format(product.getCostPrice())%></td>
							<td>S$<%=FORMET.format(product.getRetailPrice())%></td>
							<td><a class="btn btn-info" href="<%=contextPath%>/product/<%=pId%>">Detail</a> <a
									target="_top" class="btn btn-primary" href="admin/product/edit/<%=pId%>">Edit</a>
								<button class="btn btn-danger" onClick="removeProduct(<%=pId%>,this)">Remove</button>
						</tr>
						<%
						}
					%>
					</tbody>
				</table>
				<div class="justify-content-center" style="display:none" id="loading" ><img src="<%=contextPath%>/img/loading.gif"></div>
				<a class="btn btn-success" href="admin/product/add">Add Product</a> <a class="btn btn-info"
					href="admin/users">View all Account</a> <a class="btn btn-info" href="admin/order">View all
					Order</a>
					<div class="d-flex justify-content-center">
			<div><button disabled onclick="this.blur();onChangePage(1)" class="btn btn-primary"
					id="firstPage">First</button><button disabled id="previousPage"
					onclick="this.blur();onChangePage(page-1)" class="btn btn-primary" disabled>Previous</button>Page:
				<input type="number" id="pageInput" value="1" max="<%=pageAmount%>" />/<span
					id="pageNum"><%=pageAmount%></span><button onclick="this.blur();onChangePage(page+1)" id="nextPage"
					class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled"); %>>Next</button><button
					id="lastPage" class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled");   %>
					onclick="onChangePage(<%=pageAmount%>)">Last</button></div>
		</div>
			</div>
		</div>
		
		<button id="top" title="Go to top">&#8593;</button>
	</div>
	<%@include file="footer.html" %>
	<script>
		let categorys = JSON.parse('<%=new JSONArray(categories)%>')
		function resizeIframe(obj) {
			obj.style.height = obj.contentWindow.document.documentElement.scrollHeight + 'px';
		}
		const cat = document.getElementById("cat");
		const range = document.getElementById("Range");
		const aSearch = document.getElementById("aSearch");
		const addCatTxt = document.getElementById("addCatTxt");
		const thead = document.getElementById("thead");
		const tbody = document.getElementById("tbody");
		const back = document.getElementById("back");
		const FIRST_page = document.getElementById("firstPage")
		const PREV_PAGE = document.getElementById("previousPage")
		const PAGE_INPUT = document.getElementById("pageInput")
		const NEXT_PAGE = document.getElementById("nextPage")
		const LAST_PAGE = document.getElementById("lastPage")
		const PAGE_NUM = document.getElementById("pageNum")
		const CAT_LIST = document.getElementById("catList")
		const LOADING = document.getElementById("loading");
		let page = 1
		let sortNum=5
		PAGE_INPUT.addEventListener("keydown",(e)=>{
			  if(e.which===13||e.keyCode==13){
				  onChangePage(PAGE_INPUT.value)
				  PAGE_INPUT.blur();
			  }
		  })
		function removeProduct(id, that) {
			swal({
				title: "Are you Sure you want to delete product",
				icon: 'warning',
				dangerMode: true,
				buttons: ['Cancel', 'Delete']
			}).then(resolve => {
				if (resolve) {
					swal({
						  title: "Loading...",
						  icon: "<%=contextPath%>/img/loading.gif",
						  buttons: false,
					});
					fetch("<%=contextPath%>/api/product/" + id, {
						method: 'DELETE'
					}).then(res => {
						if (res.ok) {
							swal({
								icon: "success",
								title: "You have successfully delete product"
							})
							let parentNode = that.parentNode.parentNode;
							parentNode.parentNode.removeChild(parentNode);
						} else {
							swal({
								icon: "error",
								title: "Look like something went wrong",
								text: "error code " + res.status
							})
						}
					})
				}
			})

		}
		function onReloadProduct(args) {
			LOADING.style.display="flex"
				tbody.innerHTML = ""
			fetch("<%=contextPath%>/api/product?limit=10&" + args).then(res => {
				if (res.ok) {
					res.json().then(data => {
						LOADING.style.display="none"
						tbody.innerHTML = "";
						data[1].forEach(x => {
							let th1 = document.createElement("td");
							let th2 = document.createElement("td");
							let th3 = document.createElement("td");
							let th4 = document.createElement("td");
							let th8 = document.createElement("td");
							let th5 = document.createElement("td");
							let th6 = document.createElement("td");
							let th7 = document.createElement("td");
							th1.textContent = x.id;
							th2.textContent = x.title;
							th3.textContent = categorys.find(y => x.fKCategoryId === y.id).name;
							th4.textContent = x.quantity;
							th5.textContent = "S$"+x.costPrice.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");;
							th6.textContent = "S$"+x.retailPrice.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");;
							let order = document.createElement("a");
							order.textContent = x.orderAmount;
							order.href = "<%=contextPath%>/admin/order?productId=" + x.id;
							th8.appendChild(order)
							let detail = document.createElement("a")
							detail.href = "<%=contextPath%>/product/" + x.id;
							detail.textContent = "Detail"
							detail.classList.add("btn", "btn-info")
							th7.appendChild(detail)
							let edit = document.createElement("a");
							edit.href = "admin/product/edit/" + x.id;
							edit.textContent = "Edit";
							edit.classList.add("btn", "btn-primary");
							th7.appendChild(edit);
							let remove = document.createElement("button");
							remove.textContent = "Remove";
							remove.classList.add("btn", "btn-danger");
							remove.addEventListener("click", removeProduct.bind(null, x.id, remove))
							th7.appendChild(remove)
							let tr = document.createElement("tr");
							tr.appendChild(th1);
							tr.appendChild(th2);
							tr.appendChild(th3);
							tr.appendChild(th4);
							tr.appendChild(th8);
							tr.appendChild(th5);
							tr.appendChild(th6);
							tr.appendChild(th7);
							tbody.appendChild(tr);
						});
						if (page > 1) {
							PREV_PAGE.disabled = false
							FIRST_page.disabled = false
						} else {
							PREV_PAGE.disabled = true
							FIRST_page.disabled = true
						}
						let pageAmount = Math.floor((data[0]-1) / 10) + 1
						LAST_PAGE.onclick = onChangePage.bind(null, pageAmount)
						PAGE_NUM.textContent = pageAmount
						PAGE_INPUT.max=pageAmount;
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
		function onChangeCat(value) {
			let rValue = range.value.trim()
			let sValue = aSearch.value.trim()
			PAGE_INPUT.value=1
			page=1
			onReloadProduct("page=1&sort="+sortNum+(value === "0" ? "" : "&catId=" + value) + (rValue ? "&range=" + rValue : "") + (sValue ? "&search=" + encodeURI(sValue) : ""))

		}
		function onChangeRange() {
			let rValue = range.value.trim()
			let sValue = aSearch.value.trim()
			PAGE_INPUT.value=1
			onReloadProduct("page=1&sort="+sortNum+(cat.value === "0" ? "" : "&catId=" + cat.value) + (rValue ? "&range=" + rValue : "") + (sValue ? "&search=" + encodeURI(sValue) : ""))
		}
		function sort(value) {
			let rValue = range.value.trim()
			let sValue = aSearch.value.trim()
			sortNum =value
			page=1
			PAGE_INPUT.value=1
			onReloadProduct("page=1&sort=" + value + (cat.value === "0" ? "" : "&catId=" + cat.value) + (rValue ? "&range=" + encodeURI(rValue) : "")+ (sValue ? "&search=" + encodeURI(sValue) : ""))
		}
		function onChangePage(value){
	  let rValue = range.value.trim()
	  let sValue = aSearch.value.trim()
	  page =value
	  PAGE_INPUT.value=value
	  onReloadProduct("page="+page+"&sort="+sortNum+(cat.value==="0"?"":"&catId="+cat.value)+(rValue?"&range="+rValue:"")+ (sValue ? "&search=" + encodeURI(sValue) : ""))
  }

		function delCat(id,that) {
			swal({
				title: "Are you Sure you want to delete category",
				icon: 'warning',
				dangerMode: true,
				buttons: ['Cancel', 'Delete']
			}).then(resolve => {
				if (resolve) {
					swal({
						  title: "Loading...",
						  icon: "<%=contextPath%>/img/loading.gif",
						  buttons: false,
					});
					fetch("<%=contextPath%>/api/category/" + id, {
						method: "DELETE"
					}).then(res => {
						if (res.ok) {
							swal({
								icon: "success",
								title: "You have successfully delete category"
							}).then(() => {
								let parentNode = that.parentNode.parentNode;
								parentNode.parentNode.removeChild(parentNode);
								let option= document.querySelector("#cat option[value='"+id+"']")
								option.parentNode.removeChild(option);
								
							})
						} else {
							swal({
								icon:"error",
								title:"Look like something went wrong",
								text: "error code "+res.status
							})
						}

					})
				}
			})

		}
		addCatTxt.addEventListener("keydown", (e) => {
			if (e.which === 13 || e.keyCode == 13) {
				addCat()
				PAGE_INPUT.blur();
			}
		});
		function addCat() {
			swal({
				  title: "Loading...",
				  icon: "<%=contextPath%>/img/loading.gif",
				  buttons: false,
			});
			let value = addCatTxt.value;
			addCatTxt.value="";
			fetch("<%=contextPath%>/api/category", {
				method: "POST",
				body: "name=" + value,
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				}
			}).then(res => {
				if (res.ok) {
					swal({
						icon: "success",
						title: "You have successfully aded category"
					})
					res.text().then(id=>{
						
						let	td1 = document.createElement("td");
						td1.textContent = id
						let td2 = document.createElement("td");
						td2.textContent = value
						let button = document.createElement("button");
						button.textContent = "X"
						button.classList.add("btn","btn-danger")
						button.addEventListener("click",delCat.bind(null,id,button))
						let td3 = document.createElement("td");
						td3.appendChild(button)
						let tr = document.createElement("tr");
						tr.appendChild(td1)
						tr.appendChild(td2)
						tr.appendChild(td3)
						CAT_LIST.appendChild(tr)
						let option = document.createElement("option")
						option.textContent = value
						option.value=id
						cat.appendChild(option)
						
						
					})
				} else {
					if(res.status===409){
						swal({
							icon:"error",
							title:"category name have used",
							text: "error code "+res.status
						})
					}else{
						swal({
							icon:"error",
							title:"Look like something went wrong",
							text: "error code "+res.status
						})
					}
					
				}

			})

		}
	</script>
	</body>

</html>