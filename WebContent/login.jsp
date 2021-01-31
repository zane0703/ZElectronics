<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!public void jspInit(){
	headerInit();
}%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Log In</title>
<script src="https://www.google.com/recaptcha/api.js" defer></script>
	<%@include file="header.jsp" %>
	<div class="container-fluid">
	<div class="row mt-5">
		<div class="col-sm-3"></div>
		<div class="col-sm-6">
			<h3 style="text-align: center; text-decoration: bold">Log In to Your Account Now!</h3>
			<p style="color:red;" id="errorText"></p>
			<form method="post" action="javascript:login()" id >
				<div class="form-group">
					<label for="emailLogIn">Email address</label>
					<input name="username" type="text" autocomplete="username" class="form-control" id="emailLogIn" aria-describedby="emailHelp" placeholder="Enter email">
				</div>
				<div class="form-group">
					<label for="Password">Password</label>
					<input name="password" autocomplete="current-password" type="password" class="form-control" id="Password" placeholder="Password">
				</div>
				<div class="form-check">
					<input name="rmb" value="1" type="checkbox" class="form-check-input" id="rememberLogIn">
					<label  class="form-check-label" for="rememberLogIn">Remember Me</label>
				</div>
				<div class="g-recaptcha" data-sitekey="??"></div>
				<button type="submit" class="btn btn-success my-2">Login</button>
				<button type="button" onclick="forget()" class="btn btn-warning" >Forget Passowrd</button>
			</form>
			Don't have an account yet? <a href="signUp">Sign Up</a> Now!
		</div>
		<div class="col-sm-3"></div>
	</div>
	</div>
	<%@include file="footer.html" %>
	<script>
	const username = document.getElementById("emailLogIn");
	const password = document.getElementById("Password");
	const checkBox = document.getElementById("rememberLogIn");
	const errorText = document.getElementById("errorText");
	username.addEventListener("keydown",(e)=>{
		  if(e.which===13||e.keyCode==13){
			  e.preventDefault()
			  password.focus();
		  }
	  })
	function forget(){
		swal({
		      title: "Forget Password",
		      text:"enter your email",
		      icon: "info",
		      content: {
				    element: "input",
				    attributes: {
				      placeholder: "user@example.com",
				      type: "email",
				    },
				  },
		      buttons: ['Cancel','Submit']
		    }).then(email=>{
		    	if(email){
		    		swal({
						  title: "Loading...",
						  icon: "img/loading.gif",
						  buttons: false,
					});
			    	fetch("api/users/forgetpassword",{
			    		method:"POST",
			    		headers: {
						      'Content-Type': 'text/plain',
						    },
						body:email
			    	}).then(res=>{
			    		switch(res.status){
			    		case 200:
			    			res.text().then(id=>{
			    				window.location.href="forget?id="+id
			    			})
			    			break;
			    		case 404:
			    			swal({
		    					icon:"error",
		    					title:"User not found"
		    				})
		    				break;
			    		default:
			    			swal({
		    					icon:"error",
		    					title:"Look like something went wrong",
		    					text: "eror code "+res.status
		    				})
			    		}
			    		
			    	})
			   
		    	}
		    	
		    })
	}
	
	function login(){
		const data = new URLSearchParams();
		data.append("username", username.value);
		data.append("password", password.value);
		data.append("recaptcha", grecaptcha.getResponse());
		if(checkBox.checked){
			data.append("rmb", "true");
		}/* Incorrect username or passwordIncorrect username */
		swal({
			  title: "Loading...",
			  icon: "<%=contextPath%>/img/loading.gif",
			  buttons: false,
		});
		fetch("api/login",{
			method:"POST",
			body:data
		}).then(res=>{
			swal.close()
			switch(res.status){
			case 200 :
				window.location.href = "<%=contextPath%>/"
				break;
			case 404:
				errorText.textContent="Incorrect username"
				break;
			case 401:
				errorText.textContent="Incorrect username or password"
				break;
			case 422:
				errorText.textContent="Please Verify With Captcha"
				break;
			case 500:
				swal({
					icon:"error",
					title:"Look like something went wrong",
					text: "error code "+res.status
				})
				
			}
			grecaptcha.reset();
		})
		
	}
	
	</script>
</body>
</html>
