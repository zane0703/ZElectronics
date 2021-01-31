package sg.com.zElectronics.controller.servlet.user;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.NotFoundException;

import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Country;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.User;
@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       private String contextPath;
    @Override
    public void init() throws ServletException {
    	super.init();
         try {
      	   contextPath = getServletContext().getContextPath();
  	} catch (Exception e) {
  		e.printStackTrace();
  	}
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try { /*check if the use login*/
			Logined logined = (Logined) session.getAttribute("logIn");
			if(logined==null) {
				response.sendRedirect(contextPath+"/login");
				return;
			}
			 /*get the the list of country using an api as country come and go so i have to take it from an api*/
			Response res = ClientBuilder.newClient().target("https://restcountries.eu/rest")
					.path("v2")
					.path("all")
					.queryParam("fields", "alpha3Code;name")
					.request(MediaType.APPLICATION_JSON).get();
			/* check if the api is ok*/
			if (res.getStatus() != 200) {
				response.sendError(502);
				return;
			}
			Country[] countries = res.readEntity(Country[].class);
		User user = UserDb.getUser(logined.getUserId());
		request.setAttribute("userInfo", user);
		request.setAttribute("country", countries);
		 request.getRequestDispatcher("/user/edit.jsp").forward(request, response);;
		
	} catch (SQLException e) {
		response.sendError(500,"Database Error");
		e.printStackTrace();
	}catch (NotFoundException e) {
		response.sendError(404,"user not Found or you are not login");
	}
	}


}
