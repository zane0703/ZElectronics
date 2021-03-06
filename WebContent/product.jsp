<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="sg.com.zElectronics.model.valueBean.Product,java.util.ArrayList,org.apache.commons.text.StringEscapeUtils"%>
<%!
private final java.text.DecimalFormat format = new java.text.DecimalFormat();
public void jspInit(){
	headerInit();
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Products</title>
	<link rel="icon" href="<%=contextPath%>/favicon.ico" type="image/x-icon" />
<style>
	#product {
		text-align: center;
	}
	img{
	max-width:100%;
	max-height:100%;
	}
</style>
	<%@include file="header.jsp" %>
	<div class="container-fluid">
	<div class="row mt-5"> <!-- Create a For Loop Here to get the necessary amount of rows for products -->
		<div class="col-sm-3">
			<div class="pl-5">
				<h4>Product Type:</h4>
				<select class="form-control" name="cat" id="cat" onchange="onChangeCat(value);">
				<option value="0">all</option>
				<%
					String catId =(String) request.getAttribute("catId");
						if (catId==null){
						    for(Category category :categories){
							    out.print("<option value=\""+category.getId() +"\">"+category.getName()+"</option>");
							}
						}else{
							int catidInt = Integer.parseInt(catId);
						    for(Category category :categories){
							    out.print("<option value=\""+category.getId() +"\" "+(catidInt==category.getId()?"selected":"")+" >"+category.getName()+"</option>");
							}
						}
				%>
				</select>
				<h4 class="mt-2">Price Range:</h4>
				<div class="input-group">
			        <div class="input-group-prepend">
			          <span class="input-group-text">S$</span>
			        </div>
			        <input id="Range" type="text" class="form-control" placeholder="Maximum Price" required />
			    </div>
			    <button onClick="onChangeRange()" class="btn btn-success mt-2 w-50">Filter</button>
			</div>
		</div>
		<div class="col-sm-8">
			<div class="dropdown">
			  <button class="btn btn-success dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    Sort By:
			  </button>
			  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
			  <a class="dropdown-item" href="javascript:sort(7)">Title</a>
			  <a class="dropdown-item" href="javascript:sort(5)">New</a>
			  <a class="dropdown-item" href="javascript:sort(6)">Old</a>
			    <a class="dropdown-item" href="javascript:sort(1)">Price (Lowest to Highest)</a>
			    <a class="dropdown-item" href="javascript:sort(2)">Price (Highest to Lowest)</a>
			    <a class="dropdown-item" href="javascript:sort(4)">Popular</a>
			    <a class="dropdown-item" href="javascript:sort(3)">Unpopular</a>
			  </div>
			</div>
			<div class="row" id="product">
				<%
				ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("product");
				if(products==null){
					response.sendError(404," The requested resource ["+request.getRequestURI()+"] is not available");
					return;
				}
				int pageAmount = (Integer) request.getAttribute("page");
				if(products.size()==0){
					out.print("<div style=\"width:100%;\" class=\"d-flex justify-content-center\" ><p class=\"text-secondary\">No product found</p></div>");
				}
				for (Product product:products) {
			%>
				<div class="col-md-4 col-sm-6 mt-2" >
					<div class="card">
						<div style="height: 200px; text-align: center">
							<img class="card-img-top pt-2" src="<%=product.getImage()%>" style="width: 200px;">
						</div>
						<div class="card-body mt-auto">
							<h4 class="card-title border-bottom pb-2" style="text-align: left">
								<%=currency+format.format(product.getRetailPrice()) %></h4>
							<h5 class="card-title"><%=product.getTitle() %></h5>
							<p class="card-text"><%=StringEscapeUtils.escapeHtml4(product.getBriefDescription()) %></p>
							<div class="row">
								<a href="product/<%=product.getId() %>" class="btn btn-primary col ml-1">View Product</a>
							</div>
						</div>
					</div>
				</div>
				<%
				}
			%>
			</div>
			<div class="justify-content-center" style="display:none" id="loading" ><img src="<%=contextPath%>/img/loading.gif"></div>
		</div>
		<div class="col-sm-1"></div>
	</div>
	<div class="d-flex justify-content-center" ><div><button disabled  onclick="this.blur();onChangePage(1)" class="btn btn-primary" id="firstPage">First</button><button disabled id="previousPage" onclick="this.blur();onChangePage(page-1)" class="btn btn-primary" disabled>Previous</button>Page: <input  type="number" id="pageInput" value="1" max="<%=pageAmount%>" />/<span id="pageNum"><%=pageAmount%></span><button onclick="this.blur();onChangePage(page+1)" id="nextPage" class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled"); %> >Next</button><button id="lastPage" class="btn btn-primary" <%if(pageAmount<=1)out.print("disabled");   %> onclick="onChangePage(<%=pageAmount%>)" >Last</button></div></div>
	</div>
	<button  id="top" title="Go to top">&#8593;</button>
	<%@include file="footer.html" %>
	<script>
  const CAT = document.getElementById("cat")
  const listings = document.getElementById("listings")
  const range = document.getElementById("Range")
  const PRODUCT = document.getElementById("product")
  const FIRST_page = document.getElementById("firstPage")
  const PREV_PAGE =document.getElementById("previousPage")
  const PAGE_INPUT = document.getElementById("pageInput")
  const NEXT_PAGE = document.getElementById("nextPage")
  const LAST_PAGE = document.getElementById("lastPage")
  const PAGE_NUM = document.getElementById("pageNum")
  const LOADING = document.getElementById("loading");
  let page = 1;
  let sortNum=5
  let search="" 
  PAGE_INPUT.addEventListener("keydown",function(e){
	  if(e.which===13||e.keyCode==13){
		  onChangePage(PAGE_INPUT.value)
		  PAGE_INPUT.blur();
	  }
  })
  function getProduct(args){
	  PRODUCT.innerHTML="";
	  LOADING.style.display="flex"
	  fetch('api/product?limit=6&hasQty=true<%if(!currency.equals("S$"))out.print("&currency="+currency.trim());%>&'+args).then(function(res){
		  if(res.ok){
			 res.json().then(function(data){
				 LOADING.style.display="none"
				 if(!data[1].length){
					 PRODUCT.innerHTML= "<div style=\"width:100%;\" class=\"d-flex justify-content-center\" ><p class=\"text-secondary\">No product found</p></div>"
				 }else{
					 PRODUCT.innerHTML="";
				 }
						
				 
				 data[1].forEach(function(x){
					 let div = document.createElement("div");
					 div.classList.add("col-md-4","col-sm-6","mt-2");
					 let imgDiv = document.createElement("div");
					 imgDiv.style.height="200px";
					 imgDiv.style.textAlign="center";
					 let img =document.createElement("img")
					 img.classList.add("card-img-top","pt-2");
					 img.src = x.image;
					 imgDiv.appendChild(img);
					 div.appendChild(imgDiv)
					 let bodyDiv = document.createElement("div");
					 bodyDiv.classList.add("card-body","mt-auto");
					 let h4 = document.createElement("h4");
					 h4.classList.add("card-title","border-bottom","pb-2");
					 h4.style.textAlign= "left";
					 h4.textContent= "<%=currency%>"+x.retailPrice.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
					 bodyDiv.appendChild(h4);
					let h5 = document.createElement("h5");
					 h5.classList.add("card-title");
					 h5.textContent=x.title;
					 bodyDiv.appendChild(h5);
					 let p = document.createElement("p")
					 p.classList.add("card-title");
					p.textContent= x.briefDescription;
					bodyDiv.appendChild(p); 
					let linkDiv =document.createElement("div");
					linkDiv.classList.add("row")
					let a  = document.createElement("a");
					a.classList.add("btn","btn-primary","col","ml-1");
					a.href= "product/"+x.id
					a.textContent="View Product";
					linkDiv.appendChild(a);
					bodyDiv.appendChild(linkDiv);
					div.appendChild(bodyDiv)
					PRODUCT.appendChild(div)
				 })
				 if(page>1){
				 PREV_PAGE.disabled=false
				 FIRST_page.disabled=false
			 }else{
				PREV_PAGE.disabled=true
				 FIRST_page.disabled=true
			 }
			 let pageAmount = Math.floor((data[0]-1)/6)+1
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
                  icon: "error",
                  title: "Look like something went wrong",
                  text: "error code " + res.status
              })
		  }
	  })
  }
  
  function onChangeCat(value){
	 let rValue = range.value.trim()
	 page =1
	 PAGE_INPUT.value=1
	  getProduct("page=1&sort="+sortNum+(value==="0"?"":"&catId="+value)+(rValue?"&range="+rValue:""))
	  
  }
  function onChangePage(value){
	  let rValue = range.value.trim()
	  page =value
	  PAGE_INPUT.value=value
	  getProduct("page="+page+"&sort="+sortNum+(CAT.value==="0"?"":"&catId="+CAT.value)+(rValue?"&range="+rValue:""))
  }
  range.addEventListener("keydown",function(e){
	  if(e.which===13||e.keyCode==13){
		  onChangeRange()
		  PAGE_INPUT.blur();
	  }
  })
  function onChangeRange(){
	  page =1
	  PAGE_INPUT.value=1
	  let rValue = range.value.trim()
	  getProduct("page=1&sort="+sortNum+(CAT.value==="0"?"":"&catId="+CAT.value)+(rValue?"&range="+rValue:""))
  }
  function sort(value){
	  page =1
	  PAGE_INPUT.value=1
	  let rValue = range.value.trim()
	  sortNum = value
	  getProduct("page=1&sort="+sortNum+(CAT.value==="0"?"":"&catId="+CAT.value)+(rValue?"&range="+rValue:""))
  }
</script>
</body>
</html>