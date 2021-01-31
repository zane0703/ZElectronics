<%@page import="sg.com.zElectronics.model.utilityBean.RoleDb"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.Properties,java.sql.*,java.io.File,org.apache.jasper.tagplugins.jstl.core.Catch,java.util.List"%>

<%!
private RoleDb roleDb;
	public void jspInit() {
		headerInit();
		fileConfig = (Properties) servletContext.getAttribute("fileConfig");
	}
	private java.util.Properties fileConfig = new java.util.Properties();%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Add Product</title>
<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet"
	type="text/css" />
<style>
#banner {
	background-color: #ffccbf
}

#indicators .active {
	background-color: #ff918f
}

#feature {
	text-align: center
}

#feature>img {
	max-height: 300px;
}
</style>
	<%@ include file="../../header.jsp"%>
	<%
	try {
		if (roleDb.getRole(logined.getRoleId()).isAddProduct()) {
%>
	<div class="container-fluid">
	<div class="row my-3">
		<div class="col-sm-2"></div>
		<div class="col-sm-8">
			<form id="form" action="javascript:onSubmit()">
				<h1>Add Product Details</h1>
				<div class="form-group">
					<label for="title">Item Name:</label> <input type="text"
						name="title" id="title" class="form-control" required />
				</div>
				<div class="form-group">
					<label for="costPr">Cost Price:</label> <input type="number"
						min="1" step="any" name="costPr" id="costPr" placeholder="10"
						required class="form-control" required />
				</div>
				<div class="form-group">
					<label for="retailPr">Retail Price:</label> <input type="number"
						min="1" step="any" name="retailPr" id="retailPr" placeholder="10"
						required class="form-control" required />
				</div>
				<div class="form-group">
					<label for="category">Category:</label> <select id="category"
						name="category" class="form-control"> <
						<%
							for (Category category : categories) {
							out.print("<option value=\"" + category.getId() + "\">" + category.getName() + "</option>");
						}
						%>
					</select>
				</div>
				<div class="form-group">
					<label for="qty">Stock Quantity:</label> <input type="number"
						min="1" name="qty" id="qty" value="1" required
						class="form-control" required />
				</div>
				<div class="form-group">
					<label for="briefD">Brief Description:</label>
					<textarea name="briefD" class="form-control" id="briefD" cols="30"
						rows="5"></textarea>
				</div>
				<div class="form-group">
					<label for="detailD">Detail Description:</label>
					<textarea name="detailD" class="form-control" id="detailD"
						cols="30" rows="5"></textarea>
				</div>
				<fieldset style="width: 244.8px;">
					<%-- upload image --%>
					<legend>Product Picture</legend>
					<div class="form-check form-check-inline">
						<label class="form-check-label" for="url">URL</label> <input type="radio" name="upload" class="form-check-input"
							onclick="FILE.required =false;URLT.required=true;FILE.style.display='none';URLAERA.style.display='block'"
							value="0" checked />
					</div>
					<div class="form-check form-check-inline">
						<label class="form-check-label" for="file">File</label> <input
							type="radio" name="upload" class="form-check-input"
							onclick="FILE.required =true;URLT.required=false;FILE.style.display='block';URLAERA.style.display='none'"
							value="1" />
					</div>

					<div id="urlArea">
						<label  for="urlField">URL</label> <input
							 type="url" name="picture_url"
							id="urlField" placeholder="http://example.com/picture.jpg"
							required />
					</div>
					<input style="display: none;" type="file" name="pic" id="pic"
						accept="<%=fileConfig.getProperty("accept")%>" />
				</fieldset>
				<div class="row" id="buttons">
					<div class="col">
						<button type="reset" class="btn btn-warning btn-block" id="Clear">Clear</button>
					</div>

					<div class="col">
						<input type="submit" class="btn btn-success btn-block" value="add">
					</div>
				</div>
			</form>
		</div>
		<div class="col-sm-2"></div>
	</div>
	</div>
	<button  id="top" title="Go to top">&#8593;</button>
	<%@include file="../../footer.html" %>
	<script>
		const URLAERA = document.getElementById("urlArea");
		const FILE = document.getElementById("pic");
		const URLT = document.getElementById("urlField");
		const form = document.getElementById("form");
		function onSubmit(){
			let formData = new FormData(form);
			swal({
				  title: "Loading...",
				  icon: "<%=contextPath%>/img/loading.gif",
				  buttons: false,
			});
			fetch("<%=contextPath%>/api/product",{
				method:"POST",
				body:formData
			}).then(res=>{
				if(res.ok){
					swal({
    					icon:"success",
    					title:"You have successfully added a product"
    				}).then(()=>window.location.href="<%=contextPath%>/admin")
					
				}else{
					 swal({
	    					icon:"error",
	    					title:"Look like something went wrong",
	    					text: "error code "+res.status
	    				})
				}
			})
		}
			<%
}else{
	response.sendError(403, "only admin user can access the page");
}
} catch (NullPointerException e) {
response.sendError(401, "only admin user can access the page");
}%>

	</script>
</body>

</html>