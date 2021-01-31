<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.JSONArray,java.util.Properties,sg.com.zElectronics.model.valueBean.Logined,sg.com.zElectronics.model.valueBean.Category,sg.com.zElectronics.model.utilityBean.CategoryDb,sg.com.zElectronics.model.utilityBean.CartDb,java.util.ArrayList"%>
<%!public void headerInit() {
		try {
			servletContext = getServletContext();
			contextPath = servletContext.getContextPath();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private String contextPath = null;
	private Category[] categories;
	private CartDb cartDb;
	private CategoryDb categoryDb;
	private ServletContext servletContext;%>
<%
	Logined logined = (Logined) session.getAttribute("logIn");
categories = (Category[]) servletContext.getAttribute("category");
%>

<link rel="icon" href="<%=contextPath%>/favicon.ico" type="image/x-icon" />
<link rel='shortcut icon' type='image/x-icon'
	href='<%=contextPath%>/favicon.ico' />
<meta charset="UTF-8">
<!--CSS-->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css"
	integrity="sha256-aAr2Zpq8MZ+YA/D6JtRD3xtrwpEz2IqOS+pWD/7XKIw="
	crossorigin="anonymous" />
<!--Scripts-->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.slim.min.js"
	integrity="sha256-4+XzXVhsDmqanXGHaHvgh1gMQKX40OUvDEBTu8JcmNs="
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.min.js"
	integrity="sha256-OFRAJNoaD8L3Br5lglV7VyLRf0itmoBzWUoM+Sji4/8="
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"
	integrity="sha512-AA1Bzp5Q0K1KanKKmvN/4d3IRKVlv9PYgwFPvm32nPO6QS8yH1HO7LbgB1pgiOxPtfeg5zEn2ba64MUcqJx6CA=="
	crossorigin="anonymous"></script>
<script src="<%=contextPath%>/script/scroll.js" defer></script>
<link rel="stylesheet" href="<%=contextPath%>/style.css" />
</head>
<body>
	<nav
		class="navbar navbar-expand-lg navbar-light bg-light justify-content-between">
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<a class="nav-link" href="<%=contextPath%>/"><img
			src="<%=contextPath%>/img/zelectronics.png" style="max-height: 40px"></a>
		<div class="collapse navbar-collapse" id="navbarNav">
			<!-- Left Side Content -->
			<ul class="navbar-nav mr-auto">
				<li class="nav-item dropdown" style="vertical-align: middle"><a
					class="nav-link dropdown-toggle"
					onclick="window.location.href='<%=contextPath%>/product'"
					id="navbardrop" data-toggle="dropdown"> All Products </a>
					<div class="dropdown-content">
						<!-- Maybe Add a For Loop Here -->
						<%
							for (Category category : categories) {
											out.print("<a class=\"dropdown-item\" href=\"" + contextPath + "/product?catId=" + category.getId() + "\">"
											+ category.getName() + "</a>");
										}
						%>
					</div></li>
				<li class="nav-item">
					<div class="form-inline my-2 my-lg-0">
						<input id="search" class="form-control mr-sm-2" type="search"
							placeholder="Search" aria-label="Search">
						<button id="searchBtn"
							onClick="location.href='<%=contextPath%>/product?search='+encodeURI(SEARCH.value)"
							class="btn btn-outline-info my-2 my-sm-0 mr-3">Search</button>
						<script type="text/javascript">
						const SEARCH = document.getElementById("search");
						SEARCH.addEventListener("keyup", function(event) {
						    event.preventDefault();
						    if (event.keyCode === 13) {
						        document.getElementById("searchBtn").click();
						    }
						});
						</script>
					</div>
				</li>
				<li><select class="form-control"
					onchange="onChangeCurrency(this) ">
						<%
							String[] currencyList = {"SGD", "CAD", "HKD", "ISK", "PHP", "DKK", "HUF", "CZK", "GBP", "RON", "SEK", "IDR", "INR",
												"BRL", "RUB", "HRK", "JPY", "THB", "CHF", "EUR", "MYR", "BGN", "TRY", "CNY", "NOK", "NZD", "ZAR", "USD", "MXN",
												"AUD", "ILS", "KRW", "PLN"};
										String currency = (String) session.getAttribute("currency");
										for (String currencyKey : currencyList) {
											out.print("<option " + (currencyKey.equals(currency) ? "selected" : "") + " >" + currencyKey + "</option>");
										}
										if (currency == null) {
											currency = "S$";
										} else {
											currency += " ";
										}
						%>
				</select> <script>
					
				function onChangeCurrency(that){
					fetch("<%=contextPath%>/api/login/currency",{
						method:"PATCH",
						headers: {
							'Content-Type': 'text/plain',
						},
						body:that.value
					}).then(res=>{
						if(res.ok){
							window.location.reload();
						}else{
							swal({
                                icon: "error",
                                title: "Look like something went wrong",
                                text: "error code " + res.status
                            })
						}
					})
				}
				</script></li>
			</ul>
			<!-- Right Side Content -->
			<%
				try {
				if (logined == null) {
					throw new NullPointerException();
				}
				out.print("<a class=\"btn btn-primary mx-2\" href=\"" + contextPath + "/user\" >" + logined.getUsername() + "</a>");
				if (logined.getViewAdmin()) {
					out.print("<a class=\"btn btn-secondary mx-2\" href=\"" + contextPath + "/admin\" >Admin</a>");
				}
				Object cartAmount = session.getAttribute("cartAmount");
				if (cartAmount == null) {
					cartAmount = CartDb.getCartAmount(logined.getUserId());
					session.setAttribute("cartAmount", cartAmount);
				}
			%>
			<button class="btn btn-danger" onClick="logOut()"
				style="margin-right: 15px">log out</button>
			<script type="text/javascript">
				function logOut(){
					swal({
					      title: "Are you sure you want to log out?",
					   	text:"note: currency select will also be reset",
					      icon: 'warning',
					      dangerMode: true ,
					      buttons: ['Cancel','Log Out']
					    }).then(resolve=>{
					    	if(resolve){
					    		swal({
									  title: "Loading...",
									  icon: "<%=contextPath%>/img/loading.gif",
									  buttons: false,
								});
					    		fetch("<%=contextPath%>/api/login",{
									method:"DELETE"
								}).then(res=>{
									if(res.ok){
										window.location.href= "<%=contextPath%>/login"
									}else{
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
				</script>
			<div class="border btn btn-info ml-2"
				onclick="window.location.href='<%=contextPath%>/cart'">
				<img src="<%=contextPath%>/img/cart.png" style="max-height: 20px"
					class="d-inline" />
				<p class="d-inline">Item(s):</p>
				<p class="d-inline"><%=cartAmount%></p>
				<!-- Get Number -->
			</div>
			<%
				} catch (NullPointerException e) {
			out.print("<a href=\"" + contextPath + "/signUp\" style=\"margin-right: 15px\">Sign Up</a>");
			out.print("<button class=\"btn btn-warning my-2 my-sm-0\" onclick=\"window.location.href='" + contextPath
					+ "/login'\">Login</button>");
			}
			%>

		</div>
	</nav>