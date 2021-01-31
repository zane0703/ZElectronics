<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.apache.commons.text.StringEscapeUtils,sg.com.zElectronics.model.valueBean.User,sg.com.zElectronics.model.valueBean.Country,sg.com.zElectronics.model.valueBean.Role,java.util.ArrayList"%>
<%!
	private java.util.Properties fileConfig;
	public void jspInit() {
		headerInit();
		ServletContext context = getServletContext();
		fileConfig = (Properties) context.getAttribute("fileConfig");
	}%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Update user</title>
<script src="<%=contextPath%>/script/FormValidation.js"></script>
<%@include file="../../header.jsp"%>
<%
	User user = (User) request.getAttribute("userInfo");
@SuppressWarnings("unchecked")
ArrayList<Role> roles = (ArrayList<Role>) request.getAttribute("role");
if (user == null) {
	response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
	return;
}
Country[] countries = (Country[])request.getAttribute("country");
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
						name="name" id="name" class="form-control"
						placeholder="Please Enter Your Full Name" value="<%=StringEscapeUtils.escapeHtml4(user.getName())%>"  required />
						<div class="invalid-feedback">Name must be alphabetical
				</div>
				</div>
			<div class="form-group">
				<label for="username">Email address</label> <input type="email"
					class="form-control" id="email" name="email"
					aria-describedby="emailHelp" placeholder="Enter email"
					value="<%=StringEscapeUtils.escapeHtml4(user.getEmail())%>" required>
					<div class="invalid-feedback">Invalid email</div>
			</div>
			<div class="form-group">
			<label for="cPassword">Contact number</label> 
				<input type="tel" class="form-control" id="contact"
					name="contact" value="<%=StringEscapeUtils.escapeHtml4(user.getContact())%>" placeholder="Enter Your phone number" autocomplete="tel" required>
					<div class="invalid-feedback">Invalid Contact number</div>
			</div>
			<div class="form-group">
					<label for="nameinput">Address:</label> <input type="text"
						name="address" id="adr" class="form-control" value="<%=StringEscapeUtils.escapeHtml4(user.getAddress())%>"
						placeholder="Please Enter Your Address" required />
				</div>
				<div class="form-group">

					<label for="country">Country</label> <select name="country" class="form-control"
						id="country" autocomplete="country">
						<%
							for (Country country : countries) {
											String code = country.getAlpha3Code();
											out.print("<option value=\"" + code + "\"");
											if (code.equals(user.getCountry())) {
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
						class="form-control" value="<%=user.getPostalCode()%>" placeholder="Please Enter Postal Code"
						required />
						<div class="invalid-feedback">Postal code must be a number</div>
				</div>
			<div class="form-group">
				<label for="role">Acount Type</label> <select class="form-control" id="role" name="role">
					<%
						for (Role role : roles) {
						out.print("<option class=\"form-control\" value=\"" + role.getId() + "\" "
						+ (role.getId() == user.getRoleID() ? "selected" : "") + ">" + role.getName() + "</option>");
					}
					%>
				</select>
			</div>
			<div class="form-group">
				<label for="password">Password</label> <input type="password"
					class="form-control" id="password" name="password"  placeholder="Enter New Password to change password" autocomplete="new-password"
					placeholder="Password">
					<div class="invalid-feedback">Password Must Contain a Number as well as a Lowercase and Uppercase Character and must Be At Least 8 Characters Long</div>
			</div>
			<div class="form-group">
				<label for="cPassword">Password Confirmation</label> <input
					type="password" class="form-control" id="cPassword" autocomplete="new-password"
					name="cPassword" placeholder="Enter the new Password Again">
					<div class="invalid-feedback">password not match</div>
			</div>
			
			<fieldset>
				<legend>Profile Picture</legend>
				<div class="form-check form-check-inline">
					<label class="form-check-label" for="noImgChange">No Change</label>
					<input class="form-check-input" type="radio" id="noImgChange"
						value="0" name="upload" checked
						onclick="FILE.required =false;URLT.required=false;FILE.style.display='none';URLAERA.style.display='none';" />
				</div>
				<div class="form-check form-check-inline">
					<label class="form-check-label" for="url">URL</label> <input
						class="form-check-input" type="radio" name="upload"
						onclick="FILE.required =false;URLT.required=true;FILE.style.display='none';URLAERA.style.display='block';"
						value="1" />
				</div>
				<div class="form-check form-check-inline">
					<label class="form-check-label" for="file">File</label> <input
						class="form-check-input" type="radio" name="upload"
						onclick="FILE.required =true;URLT.required=false;FILE.style.display='block';URLAERA.style.display='none';"
						value="2" />
				</div>
				<div id="urlArea" style="display: none;">
					<label for="urlField">URL</label> <input type="url"
						name="profile_pic_url" id="urlField"
						placeholder="http://example.com/picture.jpg" />
				</div>
				<input style="display: none;" type="file" name="pic" id="pic"
					accept="<%=fileConfig.getProperty("accept")%>" />
					<div class="invalid-feedback">Invalid file type</div>
			</fieldset>
			 <input
				type="submit" class="btn btn-success my-2" value="update">
		</form>
	</div>
	<div class="col-sm-3"></div>
</div>
</div>
<button  id="top" title="Go to top">&#8593;</button>
<%@include file="../../footer.html" %>
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
			input = document.getElementById("password")
			if(input.value.trim()){
				isValidPassword(input,"Password Must Contain a Number as well as a Lowercase and Uppercase Character amd must Be At Least 8 Characters Long")
				isMetchPassword(input,"cPassword","Password not match")
			}
			if(FILE.style.display==="block"){
				isValidFile(FILE,"")
			}
			if (Valid) {
				let formData = new FormData(signUp);
				formData.append("isAdmin","true")
				swal({
				title: "Loading...",
				icon: "<%=contextPath%>/img/loading.gif",
				buttons: false,
			});
				fetch("<%=contextPath%>/api/users/<%=user.getId()%>",{
					method:"put",
					body:formData
				}
				).then(res=>{
					switch(res.status){
					case 204:
						swal({
	    					icon:"success",
	    					title:"successfullu update user"
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
							icon: "error",
							title: "Look like something went wrong",
							text: "error code " + res.status
						})
					}
				})
				
			}
		}
	</script>
</body>
</html>