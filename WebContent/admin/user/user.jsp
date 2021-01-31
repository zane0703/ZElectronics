
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.text.DecimalFormat,sg.com.zElectronics.model.valueBean.Role,sg.com.zElectronics.model.valueBean.Country,sg.com.zElectronics.model.valueBean.User,org.apache.commons.text.StringEscapeUtils,java.util.ArrayList,org.json.JSONArray"%>
<%!
private final DecimalFormat FORMET = new DecimalFormat();
public void jspInit(){
	headerInit();
}
%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>user</title>
	<%
		@SuppressWarnings("unchecked")
		ArrayList<User> users = (ArrayList<User>) request.getAttribute("userInfo");
		Role userRole = (Role) request.getAttribute("userRole");
		if(users==null){
			response.sendError(404," The requested resource ["+request.getRequestURI()+"] is not available");
			return;
		}
		int pageAmount = (Integer) request.getAttribute("page");
		Country[] countries = (Country[])request.getAttribute("country");
	%>

	<style>
		#product {
			text-align: center;
		}
	</style>
	<%@include file="../../header.jsp"%>
	<div class="container-fluid">
	<div class="row mt-5">
		<!-- Create a For Loop Here to get the necessary amount of rows for products -->
		<div class="col-sm-3">
			<div class="pl-5">
				<h4>Account Type:</h4>
				<select name="role" id="role" class="form-control" onchange="onChangeRole(value);">
					<option value="0">All Role</option>
					<%	@SuppressWarnings("unchecked")
					    ArrayList<Role> roles = (ArrayList<Role>) request.getAttribute("role");
						for(Role role :roles){
							 out.print("<option value=\""+role.getId() +"\">"+role.getName()+"</option>");
						}
					%>
				</select>
				<h4>Country:</h4>
				<select id="country" class="form-control" onChange="onChangeCountry(value)">
					<option value="">All Country</option>
					<%
					for(Country country:countries){
						 out.print("<option value=\""+country.getAlpha3Code() +"\">"+country.getName()+"</option>");
					}
					%>
				</select>
				<h4>Search:</h4>
				<input type="text" id="searchInput" class="form-control" placeholder="User Name"/>
				<button class="btn btn-success mt-2 w-50" onclick="onSearch();this.blur();" >Search</button>
			</div>
		</div>
		<div class="col-sm-8">
		<div class="dropdown">
				<button class="btn btn-success dropdown-toggle" type="button" id="dropdownMenuButton"
					data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Sort By</button>
				<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
					<a class="dropdown-item" href="javascript:sort(1)">new</a> 
					<a class="dropdown-item" href="javascript:sort(0)">old</a>
					<a class="dropdown-item" href="javascript:sort(2)">most order</a> 
					<a class="dropdown-item" href="javascript:sort(3)">least order</a>
					<a class="dropdown-item" href="javascript:sort(4)">most spent</a> 
					<a class="dropdown-item" href="javascript:sort(5)">least spent</a>
					<a class="dropdown-item" href="javascript:sort(6)">postal code (Lowest to Highest)</a> 
					<a class="dropdown-item" href="javascript:sort(7)">postal code (Highest to Lowest)</a>
				</div>
			</div>
			<table class="table table-striped">
				<thead id="thead">
					<tr>
						<th>Id</th>
						<th>name</th>
						<th>Role</th>
						<th>Email</th>
						<th>Contact</th>
						<th>Amount spent</th>
						<th>Order</th>
						<th></th>
					</tr>
				</thead>
				<tbody id="tbody">
					<%
					
							for (User user :users) {
								int uId = user.getId();
					%>
					<tr>
						<td><%=uId%></td>
						<td><%=StringEscapeUtils.escapeHtml4(user.getName()) %></td>
						<td><%
						for(Role role :roles){
							if(role.getId()==user.getRoleID()){
								out.print(role.getName());
							}
						}
						%></td>
						<td><%=StringEscapeUtils.escapeHtml4(user.getEmail() )%></td>
						<td><%= StringEscapeUtils.escapeHtml4(user.getContact())%></td>
						<td>$<%=FORMET.format((user.getSpent())) %></td>
						<td><a href="<%=contextPath%>/admin/order?buyerId=<%=uId%>"><%=user.getOrderAmount()%></a></td>
						<td><a class="btn btn-info" href="users/<%=uId%>">Detail</a>
							<% 
								if(userRole.isEditUser()){
									out.print("<a class=\"btn btn-primary\" href=\"users/"+uId+"/edit\">Edit</a>");
								}
								if(userRole.isDelUser()){
									out.print("<button class=\"btn btn-danger\" onClick=\"removeUser("+uId+",this)\">Remove</button> ");
								}
								%>
						</td>
					</tr>
					<%} %>
				</tbody>
			</table>
			<div class="justify-content-center" style="display:none" id="loading" ><img src="<%=contextPath%>/img/loading.gif"></div>
			<%
			if(userRole.isAddUser()){
				out.print("<a class=\"btn btn-success\" href=\"users/add\">Add Users</a>");
			}
			%>
			<div class="d-flex justify-content-center" ><div><button disabled  onclick="this.blur();onChangePage(1)" class="btn btn-primary" id="firstPage">First</button><button disabled id="previousPage" onclick="this.blur();onChangePage(page-1)" class="btn btn-primary" disabled>Previous</button>Page: <input  type="number" id="pageInput" value="1" max="<%=pageAmount%>" />/<span id="pageNum"><%=pageAmount%></span><button onclick="this.blur();onChangePage(page+1)" id="nextPage" class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled"); %> >Next</button><button id="lastPage" class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled");   %> onclick="onChangePage(<%=pageAmount%>)" >Last</button></div></div>
		</div>
		<div class="col-sm-1"></div>
	</div>
	</div>
	<button  id="top" title="Go to top">&#8593;</button>
	<%@include file="../../footer.html" %>
	<script>
		let roles = JSON.parse('<%=new JSONArray(roles.toArray())%>')

		const role = document.getElementById("role");
		const range = document.getElementById("Range");
		const tbody = document.getElementById("tbody");
		  const FIRST_page = document.getElementById("firstPage");
		  const PREV_PAGE =document.getElementById("previousPage");
		  const PAGE_INPUT = document.getElementById("pageInput");
		  const SEARCH_INPUT = document.getElementById("searchInput");
		  const NEXT_PAGE = document.getElementById("nextPage");
		  const LAST_PAGE = document.getElementById("lastPage");
		  const PAGE_NUM = document.getElementById("pageNum");
		  const LOADING = document.getElementById("loading");
		let sort2 =0;
		let roleId = 0;
		  let page = 1;
		let country="";
		  PAGE_INPUT.addEventListener("keydown",(e)=>{
			  if(e.which===13||e.keyCode==13){
				  page = PAGE_INPUT.value.trim()
				  onReLoad()
				  PAGE_INPUT.blur();
			  }
		  })
		  SEARCH_INPUT.addEventListener("keydown",(e)=>{
			  if(e.which===13||e.keyCode==13){
				  onSearch();
				  PAGE_INPUT.blur();
			  }
		  })
		  let searchText=""
		function removeUser(id,ref) {
			swal({
			      title: "Are you Sure you want to delete this user",
			      icon: 'warning',
			      dangerMode: true ,
			      buttons: ['Cancel','Delete']
			    }).then(resolve=>{
			if (resolve) {
				swal({
					title: "Loading...",
					icon: "<%=contextPath%>/img/loading.gif",
					buttons: false,
				});
				fetch("<%=contextPath %>/api/users/" + id,{
					method:"DELETE"
				}).then(res => {
					if (res.ok) {
						swal({
	    					icon:"success",
	    					title:"You have successfully delete user"
	    				}).then(()=>{
	    					let {parentNode} = ref.parentNode
							parentNode.parentNode.removeChild(parentNode);
	    				})
						
					} else {
						swal({
							icon: "Error",
							title: "Look like something went wrong",
							text: "error code " + res.status
						})
					}
				})
			}
			})
		}

		function onReLoad() {
			LOADING.style.display="flex";
			tbody.innerHTML = "";
			fetch("<%=contextPath%>/api/users?limit=10&page="+page+"&role="+roleId+"&sort="+sort2+(searchText ? "&search=" + encodeURI(searchText ): "")+(country?"&country="+country:"")).then(res=>{
				if(res.ok){
					res.json().then(data=>{
						LOADING.style.display="none";
						tbody.innerHTML = ""
					data[1].forEach(x => {
						let td1 = document.createElement("td");
						td1.textContent = x.id;
						let td2 = document.createElement("td");
						td2.textContent = x.name;
						let td3 = document.createElement("td");
						td3.textContent = roles.find(y=>y.id===x.roleID).name;
						let td4 = document.createElement("td");
						let td5 = document.createElement("td");
						td4.textContent = x.email||"";
						td5.textContent = x.contact||"";
						let td6 = document.createElement("td");
						let td7 = document.createElement("td");
						td6.textContent = "$"+x.spent.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");;
						let orderAmu=  document.createElement("a");
						orderAmu.textContent = x.orderAmount;
						orderAmu.href ="<%=contextPath%>/admin/order?buyerId="+x.id
						td7.appendChild(orderAmu)
						let detail = document.createElement("a");
						detail.classList.add("btn", "btn-info");
						detail.href = "users/" + x.id;
						detail.textContent='Detail'
						detail.classList.add('btn', 'btn-info')
						let td8 = document.createElement("td")
						td8.appendChild(detail);
						<%
						if(userRole.isEditUser()){
							out.print("let edit = document.createElement('a');edit.textContent = 'Edit';edit.href = 'users/' + x.id + '/edit';edit.classList.add('btn', 'btn-primary');td8.appendChild(edit);");
						}
						if(userRole.isDelUser()){
							out.print("let remove = document.createElement('button');remove.textContent = 'Remove';remove.classList.add('btn', 'btn-danger');remove.addEventListener('click', removeUser.bind(null, x.id,remove));td8.appendChild(remove);");
						}
						%>
						let tr = document.createElement("tr")
						tr.appendChild(td1);
						tr.appendChild(td2);
						tr.appendChild(td3);
						tr.appendChild(td4);
						tr.appendChild(td5);
						tr.appendChild(td6);
						tr.appendChild(td7);
						tr.appendChild(td8);
						tbody.appendChild(tr);
				})
				 if(page>1){
					 PREV_PAGE.disabled=false
					 FIRST_page.disabled=false
				 }else{
					PREV_PAGE.disabled=true
					 FIRST_page.disabled=true
				 }
				 let pageAmount = Math.floor((data[0]-1)/10)+1
				 PAGE_INPUT.max=pageAmount;
				 LAST_PAGE.onclick = onChangePage.bind(null,pageAmount)
				 PAGE_NUM.textContent=pageAmount
				 if(page<pageAmount){
					 NEXT_PAGE.disabled = false;
					 LAST_PAGE.disabled = false;
				 }else{
					NEXT_PAGE.disabled = true;
					 LAST_PAGE.disabled = true;
				 }
						
					})
				}else{
					swal({
						icon: "Error",
						title: "Look like something went wrong",
						text: "error code " + res.status
					})
				}
			})
			}
		function onChangeCountry(value){
			country = value
			page =1
			PAGE_INPUT.value=1
			onReLoad() 
		}
		function onChangeRole(value){
			roleId = value
			page =1
			PAGE_INPUT.value=1
			onReLoad() 
		}
		function sort(value){
			sort2 = value
			page =1
			PAGE_INPUT.value=1
			onReLoad()
		}
		function onChangePage(value){
			  page =value
			  PAGE_INPUT.value=value
			  onReLoad()
			 
		  }
		function onSearch(){
			searchText= SEARCH_INPUT.value.trim()
			page =1
			PAGE_INPUT.value=1
			onReLoad()
		}
			


	</script>
	</body>

</html>