<%@page import="javax.ws.rs.PUT"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.util.regex.Pattern,java.io.File,java.util.List,java.util.regex.Pattern,sg.com.zElectronics.model.valueBean.Country,javax.ws.rs.client.Client,javax.ws.rs.client.ClientBuilder,javax.ws.rs.core.MediaType,javax.ws.rs.core.Response"%>
<%!public void jspInit() {
		headerInit();
		fileConfig = (Properties) servletContext.getAttribute("fileConfig");
	}
	private java.util.Properties fileConfig;%>
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
<title>Sign Up</title>
<script src="https://www.google.com/recaptcha/api.js" defer></script>
<script src="script/FormValidation.js" defer></script>
<%@include file="header.jsp"%>
<div class="container-fluid">
	<div class="row mt-5">
		<div class="col-sm-3"></div>
		<div class="col-sm-6">
			<h3 style="text-align: center; text-decoration: bold">Create
				Your Account!</h3>
			<form action="javascript:onsubmit()" id="form">
				<p style="color: red;" id="errorText"></p>
				<div class="form-group">
					<label for="nameinput">Full Name:</label> <input type="text"
						name="name" id="name" class="form-control"
						placeholder="Please Enter Your Full Name" autocomplete="name"
						required />
				</div>
				<div class="form-group">
					<label for="username">Email address</label> <input type="email"
						class="form-control" id="email" name="email"
						aria-describedby="emailHelp" autocomplete="email"
						placeholder="Enter email" required>
					<div class="invalid-feedback">Invalid email</div>
				</div>
				<div class="form-group">
					<label for="cPassword">Contact number</label> <input type="tel"
						class="form-control" id="contact" name="contact"
						placeholder="Enter Your phone number" autocomplete="tel" required>
					<div class="invalid-feedback">Invalid Contact number</div>
				</div>
				<div class="form-group">
					<label for="nameinput">Address:</label> <input type="text"
						name="address" id="adr" class="form-control"
						placeholder="Please Enter Your Address" required />
				</div>
				<div class="form-group">

					<label for="country">Country</label> <select name="country"
						class="form-control" id="country" autocomplete="country">
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
					<label for="password">Password</label> <input type="password"
						class="form-control" id="password" name="password"
						placeholder="Password" autocomplete="new-password" required>
					<div class="invalid-feedback">Password Must Contain a Number
						as well as a Lowercase and Uppercase Character and must Be At
						Least 8 Characters Long</div>
				</div>
				<div class="form-group">
					<label for="cPassword">Password Confirmation</label> <input
						type="password" class="form-control" id="cPassword"
						name="cPassword" placeholder="Enter Your Password Again"
						autocomplete="new-password" required>
					<div class="invalid-feedback">password not match</div>
				</div>

				<fieldset>
					<legend>Profile Picture</legend>
					<div class="form-check form-check-inline">
						<label class="form-check-label" for="url">URL</label> <input
							type="radio" name="upload" class="form-check-input"
							onclick="FILE.style.display='none';FILE.required =false;URLAERA.style.display='block';URLT.required =true"
							value="0" checked />
					</div>
					<div class="form-check form-check-inline">
						<label class="form-check-label" for="file">File</label> <input
							class="form-check-input" type="radio" name="upload"
							onclick="FILE.style.display='block';FILE.required =true;URLAERA.style.display='none';URLT.required =false"
							value="1" />
					</div>

					<div id="urlArea">
						<label for="urlField">URL</label> <input type="url"
							name="profile_pic_url" id="urlField"
							placeholder="http://example.com/picture.jpg" required />
					</div>
					<input style="display: none;" type="file" name="pic" id="pic"
						accept="<%=fileConfig.getProperty("accept")%>" />
						<div class="invalid-feedback">Invalid file type</div>
				</fieldset>
				<div class="g-recaptcha"
					data-sitekey="??"></div>
				<div class="form-check">
					<input class="form-check-input" type="checkbox" id="tAndC" /> <label
						class="form-check-label" for="tAndC">I agree to the <a
						href="javascript:showTandC()">Terms and Conditions</a></label>
					<div class="invalid-feedback">You must agree before
						submitting.</div>
				</div>
				<br> <input class="btn btn-warning" type="reset" value="clear"
					onclick="clearDisplay()"> <input type="submit"
					class="btn btn-success my-2" value="Sign Up">
			</form>
			Already Have An Account? <a href="login">Log In</a> Now!
		</div>
		<div class="col-sm-3"></div>
	</div>
	<button id="top" title="Go to top">&#8593;</button>
</div>
<%@include file="footer.html" %>
<script>
		const URLAERA = document.getElementById("urlArea")
		const URLT = document.getElementById("urlField")
		const FILE = document.getElementById("pic")
		const errorText = document.getElementById("errorText")
		const form = document.getElementById("form")
		const T_AND_C = document.getElementById("tAndC")
		const tAndCText =document.createElement("div")
		tAndCText.innerHTML=`<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Neque egestas congue quisque egestas diam in arcu. Mi sit amet mauris commodo quis imperdiet massa tincidunt nunc. Dis parturient montes nascetur ridiculus mus. Magna etiam tempor orci eu. Dapibus ultrices in iaculis nunc sed augue lacus. Diam phasellus vestibulum lorem sed. Blandit volutpat maecenas volutpat blandit aliquam etiam. Nec tincidunt praesent semper feugiat nibh sed pulvinar. Consectetur adipiscing elit ut aliquam. In hac habitasse platea dictumst quisque sagittis purus sit amet. Adipiscing at in tellus integer feugiat scelerisque. Nec ultrices dui sapien eget mi proin sed. Tortor vitae purus faucibus ornare.</p>
			<p>Facilisis leo vel fringilla est ullamcorper eget nulla. Tincidunt ornare massa eget egestas purus viverra accumsan in. Tincidunt augue interdum velit euismod in pellentesque massa placerat. Dictum sit amet justo donec enim diam vulputate ut. Nunc mi ipsum faucibus vitae aliquet nec. Dictum fusce ut placerat orci nulla. Ut diam quam nulla porttitor massa id. Sagittis id consectetur purus ut faucibus pulvinar elementum. Congue mauris rhoncus aenean vel elit scelerisque mauris. Pulvinar sapien et ligula ullamcorper malesuada proin libero nunc.</p>
			<p>Vestibulum morbi blandit cursus risus at. Enim diam vulputate ut pharetra. Ut tortor pretium viverra suspendisse potenti. Duis ut diam quam nulla porttitor. In pellentesque massa placerat duis ultricies. Eu nisl nunc mi ipsum faucibus vitae aliquet nec ullamcorper. Placerat orci nulla pellentesque dignissim enim sit amet venenatis urna. Porta lorem mollis aliquam ut porttitor leo a diam. Amet cursus sit amet dictum sit amet justo. Massa enim nec dui nunc mattis. Sem et tortor consequat id porta nibh venenatis cras sed. Risus at ultrices mi tempus imperdiet nulla. Proin nibh nisl condimentum id venenatis a condimentum vitae. Eget velit aliquet sagittis id consectetur purus ut faucibus pulvinar. Sollicitudin ac orci phasellus egestas tellus rutrum tellus. Nunc faucibus a pellentesque sit amet porttitor.</p>
			<p>Etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus. Elementum tempus egestas sed sed risus pretium quam vulputate. Molestie a iaculis at erat pellentesque adipiscing. Sapien pellentesque habitant morbi tristique senectus et netus et malesuada. Lorem ipsum dolor sit amet consectetur adipiscing elit. Quam adipiscing vitae proin sagittis nisl rhoncus mattis. Egestas purus viverra accumsan in. Velit aliquet sagittis id consectetur. Purus semper eget duis at tellus at urna. Aenean vel elit scelerisque mauris. Semper risus in hendrerit gravida rutrum quisque non. Id leo in vitae turpis massa sed elementum.</p>
			<p>Ultrices neque ornare aenean euismod elementum nisi quis. Proin fermentum leo vel orci porta non. Faucibus in ornare quam viverra orci sagittis. Mi ipsum faucibus vitae aliquet. Pellentesque massa placerat duis ultricies lacus sed turpis tincidunt id. Lacus viverra vitae congue eu consequat ac felis donec. Scelerisque in dictum non consectetur. Nulla porttitor massa id neque aliquam vestibulum morbi blandit. Mollis aliquam ut porttitor leo a diam sollicitudin. Sed tempus urna et pharetra pharetra massa. Malesuada nunc vel risus commodo viverra maecenas accumsan lacus. Blandit turpis cursus in hac habitasse platea dictumst quisque.</p>`	
			tAndCText.style.overflowY = "scroll"
				tAndCText.style.height="65vh"
			function verify(token) {
			swal({
				title: "Loading...",
				icon: "img/loading.gif",
				buttons: false,
			});
			fetch("api/users/verify", {
				method: "PATCH",
				headers: {
					'Content-Type': 'text/plain',
				},
				body: token
			}).then((res) => {
				swal.close();
				switch(res.status){
				case 204:
					swal({
						icon: "success",
						title: "You have successfully create an account"
					}).then(() => window.location.href = "login")
					break;
				case 401:
					swal({
						icon: "info",
						title: "opps wrong token Key in the token again",
						content: {
							element: "input",
							attributes: {
								placeholder: "token",
								type: "text",
							},
						}
					}).then(verify);
					break;
				case 409 :
					swal({
						icon: "error",
						title: "Email have been used"
					})
					break;
				default:
					swal({
						icon: "Error",
						title: "Look like something went wrong",
						text: "error code " + res.status
					})
					
				}

			})
		}
		function onsubmit() {
			foc = null
			massage = []
			Valid = true
			inputMark = !inputMark
			isPhoneNumber("contact", "Invalid Contact Number")
			isValidEmail("email", "Invalid Email")
			isValidPassword("password", "Password Must Contain a Number as well as a Lowercase and Uppercase Character amd must Be At Least 8 Characters Long")
			isMetchPassword("password","cPassword","Password not match")
			isNumeric("postal", "Postal code must be a number")
			if(FILE.style.display==="block"){
				isValidFile(FILE,"")
			}
			if(T_AND_C.checked){
				T_AND_C.classList.remove("is-invalid")
				T_AND_C.classList.add("is-valid")
			}else{
				T_AND_C.classList.remove("is-valid")
				T_AND_C.classList.add("is-invalid")
				Valid = false
			}
			if (Valid) {
					let formData = new FormData(form);
					swal({
						title: "Loading...",
						icon: "img/loading.gif",
						buttons: false,
					});
					fetch("api/users", {
						method: "POST",
						body: formData
					}).then((res) => {
						swal.close();
						switch (res.status) {
							case 201:

								swal({
									icon: "info",
									title: "Key in the token that was sent to your email",
									content: {
										element: "input",
										attributes: {
											placeholder: "token",
											type: "test",
										},
									}
								}).then(verify);
								break;
							case 400:
								res.text().then((data) => {
									switch (data) {
										case "password":
											swal({
												icon: "error",
												title: "Password Must Contain a Number as well as a Lowercase and Uppercase Character amd must Be At Least 8 Characters Long"
											})
											break;
										case "email":
											swal({
												icon: "error",
												title: "Invalid Email"
											})
											break;
										case "different":
											swal({
												icon: "error",
												title: "Password not match"
											})
											break;
										case "contact":
											swal({
												icon: "error",
												title: "Invalid Contact Number"
											})
									}
								})
								break;

							case 422:
								swal({
									icon: "error",
									title: "Verify Your Captcha"
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
			grecaptcha.reset();
		}
		function showTandC(){
			
			swal({
				html:true,
				title:"Terms and Conditions",
				content:tAndCText
			})
		}
	</script>
</body>

</html>