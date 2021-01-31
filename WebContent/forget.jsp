<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%!
public void jspInit(){
	headerInit();
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>forget Password</title>
<script src="https://www.google.com/recaptcha/api.js" defer></script>
<script src="script/FormValidation.js" defer></script>
<%@include file="header.jsp" %>
<div class="container-fluid">
<div class="row mt-5">
	<div class="col-sm-3"></div>
	<div class="col-sm-6">
		<form action="javascript:onsubmit()" id="form">
			<p style="color: red;" id="errorText"></p>
			<div class="form-group">
				<label for="token">Token</label> <input type="text"
					class="form-control" id="token" name="token" required>
			</div>
			<div class="form-group">
				<label for="password">Password</label> <input type="password"
					class="form-control" id="password" name="password"
					placeholder="Enter Your New Password" required>
					<div class="invalid-feedback">Password Must Contain a Number
						as well as a Lowercase and Uppercase Character and must Be At
						Least 8 Characters Long</div>
				</div>
			<div class="form-group">
				<label for="cPassword">Password Confirmation</label> <input
					type="password" class="form-control" id="cPassword"
					name="cPassword" placeholder="Enter Your Password Again" required>
					<div class="invalid-feedback">password not match</div>
			</div>
			<div class="g-recaptcha" data-sitekey="??"></div>
			<input type="submit" class="btn btn-success my-2" value="Reset Password">
		</form>
	</div>
	<div class="col-sm-3"></div>
</div>
<button id="top" title="Go to top">&#8593;</button>
</div>
<%@include file="footer.html" %>
<script>
const password = document.getElementById("password");
const cPassword = document.getElementById("cPassword");
const token = document.getElementById("token");
const errorText =document.getElementById("errorText")
let id =  new URLSearchParams(window.location.search).get("id")
function onsubmit(){
	foc = null
	massage = []
	Valid = true
	inputMark = !inputMark
	let recaptcha = grecaptcha.getResponse()
	isValidPassword(password, "Password Must Contain a Number as well as a Lowercase and Uppercase Character amd must Be At Least 8 Characters Long")
	isMetchPassword(password,cPassword,"Password not match")
	if(!recaptcha){
		Valid = false
		massage.push("Verify Your Captcha")
	}
	if(Valid){
		swal({
			  title: "Loading...",
			  icon: "img/loading.gif",
			  buttons: false,
		});
		fetch("api/users/"+id+"/password",{
			method:"PATCH",
			headers: {
			      'Content-Type': 'application/x-www-form-urlencoded',
			    },
			 body:"token="+token.value+"&password="+password.value+"&recaptcha="+recaptcha
		}).then(res=>{
			swal.close()
			switch(res.status){
			case 204 :
				swal({
					icon:"success",
					title:"You have successfully reset your password"
				}).then(()=>window.location.href = "login")
				break;
			case 403:
				swal({
					icon:"error",
					title:"opps wrong token Key in the token again",
				})
			default:
				swal({
					icon:"error",
					title:"Look like something went wrong",
					text: "eror code "+res.status
				})
			}
		})
	}else {
		displaymassage()
	}
	grecaptcha.reset();
	
}

</script>
</body>
</html>