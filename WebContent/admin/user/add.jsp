<%@page import="sg.com.zElectronics.model.utilityBean.RoleDb"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="sg.com.zElectronics.model.valueBean.User,sg.com.zElectronics.model.valueBean.Role,java.util.ArrayList,java.util.regex.Pattern,sg.com.zElectronics.model.valueBean.Country,javax.ws.rs.client.Client,javax.ws.rs.client.ClientBuilder,javax.ws.rs.core.MediaType,javax.ws.rs.core.Response"%>
<%!
	private java.util.Properties fileConfig;
	private RoleDb roleDb;
	public void jspInit() {
		headerInit();
		fileConfig = (Properties) servletContext.getAttribute("fileConfig");
	}%>
	
	<%
			Client client = ClientBuilder.newClient();

		/*get the the list of country using an api as country come and go so i have to take it from an api*/
		Response res = client.target("https://restcountries.eu/rest").path("v2").path("all")
				.queryParam("fields", "alpha3Code;name").request(MediaType.APPLICATION_JSON).get();
		/* check if the api is ok*/
		if (res.getStatus() != 200) {
			response.sendError(502);
			return;
		}
		Country[] countries = res.readEntity(Country[].class);
		%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Update user</title>
<script src="<%=contextPath%>/script/FormValidation.js"></script>
<%@include file="../../header.jsp"%>
<%
	ArrayList<Role> roles = RoleDb.getRole();
	if(logined==null){
		response.sendError(401,"admin only");
		return;
	}
	for(Role role:roles){
		if(role.getId()==logined.getRoleId()){
	if(role.isAddUser()){
		break;
	}else{
		response.sendError(403,"admin only");
		return;
	}
		}
	}
%>

<div class="container-fluid">
<div class="row mt-5">
	<div class="col-sm-3"></div>
	<div class="col-sm-6">
		<h3 style="text-align: center; text-decoration: bold">Update
			Other Account!</h3>
		<form id="signUp" action="javascript:onSubmit()">
			<p style="color: red;" id="errMag"></p>
			<div class="form-group">
					<label for="nameinput">Full Name:</label> <input type="text"
						name="name" id="name" class="form-control" autocomplete="name"
						placeholder="Please Enter Your Full Name"   required />
			<div class="form-group">
				<label for="username">Email address</label> <input type="email"
					class="form-control" id="email" name="email"  autocomplete="email"
					aria-describedby="emailHelp" placeholder="Enter email"
					 required>
					 <div class="invalid-feedback">Invalid email</div>	
			</div>
			<div class="form-group">
			<label for="cPassword">Contact number</label> 
				<input type="tel" class="form-control" id="contact" autocomplete="tel"
					name="contact"  placeholder="Enter Your phone number" required>
					<div class="invalid-feedback">Invalid Contact number</div>
			</div>
			<div class="form-group">
					<label for="nameinput">Address:</label> <input type="text"
						name="address" id="adr" class="form-control"
						placeholder="Please Enter Your Address" required />
				</div>
				<div class="form-group">

					<label for="country">Country</label> <select name="country" class="form-control"
						id="country" autocomplete="country">
						<%
							for (Country country : countries) {
											String code = country.getAlpha3Code();
											out.print("<option value=\"" + code + "\"");
											if (code.equals("SGP")) {
												out.print(" selected ");
											}
											out.print(">" + country.getName() + "</option>");
										}
						%>
					</select>
				</div>
				<div class="form-group">
					<label for="postal">Postal Code:</label> <input type="text"
						autocomplete="postal-code" name="postalCode" id="postal"
						class="form-control" placeholder="Please Enter Postal Code"
						required />
						<div class="invalid-feedback">Postal code must be a number</div>
				</div>
			<div class="form-group">
				<label for="role">Account Type</label> <select class="form-control" id="role" name="role">
					<%
						for (Role role : roles) {
						out.print("<option class=\"form-control\" value=\"" + role.getId() + "\" "
						 + ">" + role.getName() + "</option>");
					}
					%>
				</select>
			</div>
			<div class="form-group">
				<label for="password">Password</label> <input type="password"
					class="form-control" id="password" name="password" autocomplete="new-password" 
					placeholder="Password">
					<div class="invalid-feedback">Password Must Contain a Number as well as a Lowercase and Uppercase Character and must Be At Least 8 Characters Long</div>
			</div>
			<div class="form-group">
				<label for="cPassword">Password Confirmation</label> <input
					type="password" class="form-control" id="cPassword" autocomplete="new-password" 
					name="cPassword" placeholder="Enter Your Password Again">
					<div class="invalid-feedback">password not match</div>
			</div>
			
			<fieldset>
						<legend>Profile Picture</legend>
						<div class="form-check form-check-inline">
							<label class="form-check-label" for="url">URL</label> <input type="radio" name="upload"
								class="form-check-input"
								onclick="FILE.style.display='none';FILE.required =false;URLAERA.style.display='block';URLT.required =true"
								value="0" checked />
						</div>
						<div class="form-check form-check-inline">
							<label class="form-check-label" for="file">File</label> <input class="form-check-input"
								type="radio" name="upload"
								onclick="FILE.style.display='block';FILE.required =true;URLAERA.style.display='none';URLT.required =false"
								value="1" />
						</div>

						<div id="urlArea">
							<label for="urlField">URL</label> <input type="url" name="profile_pic_url" id="urlField"
								placeholder="http://example.com/picture.jpg" required />
						</div>
						<input style="display: none;" type="file" name="pic" id="pic" accept="<%=fileConfig.getProperty("accept")%>" />
						<div class="invalid-feedback">Invalid file type</div>
					</fieldset>
			 <input
				type="submit" class="btn btn-success my-2" value="update">
		</form>
	</div>
	<div class="col-sm-3"></div>
</div>
</div>
<%@include file="../../footer.html" %>
<button  id="top" title="Go to top">&#8593;</button>
<script>
		const URLAERA = document.getElementById("urlArea")
		const URLT = document.getElementById("urlField")
		const FILE = document.getElementById("pic")
		const signUp =  document.getElementById("signUp")
		const errMag =  document.getElementById("errMag")
		function onSubmit() {
			foc=null
			massage = []
			Valid = true
			let input;
			inputMark = !inputMark
			isValidEmail("email","Invalid Email")
			isPhoneNumber("contact","Invalid Contact Number")	
			isValidPassword("password","Password Must Contain a Number as well as a Lowercase and Uppercase Character amd must Be At Least 8 Characters Long")
			isMetchPassword("password","cPassword","Password not match")
			if(FILE.style.display==="block"){
				isValidFile(FILE,"")
			}
			if (Valid) {
				swal({
					title: "Loading...",
					icon: "<%=contextPath%>/img/loading.gif",
					buttons: false,
				});
				let formData = new FormData(signUp);
				formData.append("isAdmin","true")
				fetch("<%=contextPath%>/api/users/",{
					method:"POST",
					body:formData
				}
				).then(res=>{
					switch(res.status){
					case 201:
						swal({
	    					icon:"success",
	    					title:"successfullu added user"
	    				}).then(()=>window.location.href="<%=contextPath%>/admin/users")
						break;
					case 409 :
						swal({
							icon: "error",
							title: "Email have been used"
						})
					break;
					default:
						swal({
	    					icon:"error",
	    					title:"Look like something went wrong",
	    					text: "error code "+res.status
	    				})
					}
				})
				
			}
		}
	</script>
</body>
</html>