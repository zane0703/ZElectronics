package sg.com.zElectronics.controller.api;
import javax.ws.rs.POST;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.FormParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import java.sql.SQLException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.PATCH;

import javax.ws.rs.core.Context;
import org.springframework.security.crypto.bcrypt.BCrypt;

import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Captcha;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.User;

@Path("/login")
public class LoginAPI {

@POST
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public Response login(@Context HttpServletRequest req , @FormParam("username") String Username,@FormParam("password") String password,@FormParam("rmb") String rmb,@FormParam("recaptcha")String recaptcha ) {
	try {
		Client client = ClientBuilder.newClient();
		Response response = client.target("https://www.google.com/recaptcha/api").path("siteverify")
				.queryParam("secret", "?").queryParam("response", recaptcha)
				.request(MediaType.APPLICATION_JSON).get();
		if (response.getStatus() != 200) {
			return Response.status(502).build();
		}
		Captcha captcha = response.readEntity(Captcha.class);
		if(captcha.isSuccess()) {
		User user = UserDb.getUserByName(Username);
		/*check password is correct*/
		
		if(BCrypt.checkpw( password,user.getPassword())) {
			HttpSession session = req.getSession();
			/* if the user want to the website remember*/
			if(rmb!=null){
			    session.setMaxInactiveInterval(2592000);
			}
			/*creat a new login session*/
			Logined logined = new Logined();
			logined.setUserId(user.getId());
			logined.setUsername(user.getName());
			logined.setRoleId(user.getRoleID());
			/*check if the user is admin*/
			logined.setViewAdmin(RoleDb.getRole(user.getRoleID()).isViewAdmin());
			session.setAttribute("logIn", logined);
		    return Response.status(200).build();
		}else {
			return Response.status(401).build();
		}
		}else {
			return Response.status(422).build();
		}
	} catch (SQLException e) {
		e.printStackTrace();
		return Response.status(500).build();
	}catch (NotFoundException  e) {
		return Response.status(404).build();
	}
	
}
@Path("currency")
@PATCH
@Consumes(MediaType.TEXT_PLAIN)
public void onChangeCurrency(@Context HttpServletRequest req,String currency) {
	HttpSession session = req.getSession();
	try {
		if(currency.equals("SGD")) {
			session.setAttribute("currency", null);
		}else {
			session.setAttribute("currency", currency);
		}
	} catch (NullPointerException e) {
		throw new WebApplicationException(400);
	}
	
}
@DELETE
public void logOut(@Context HttpServletRequest req) {
	req.getSession().invalidate();
}
}
