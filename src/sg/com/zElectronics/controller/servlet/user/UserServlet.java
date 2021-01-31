package sg.com.zElectronics.controller.servlet.user;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

import sg.com.zElectronics.model.utilityBean.OrderDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Country;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.Order;
import sg.com.zElectronics.model.valueBean.User;

import java.util.ArrayList;
/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	String contextPath;
	@Override
       public void init() {
    	   try {
    		   contextPath = getServletContext().getContextPath();
		} catch (Exception e) {
			e.printStackTrace();
		}
       }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			Logined logined = (Logined) session.getAttribute("logIn");
			if(logined==null) {
				response.sendRedirect(contextPath+"/login");
				return;
			}
			int id = logined.getUserId();
			/*get use info*/
			User user= UserDb.getUser(id);
			/*get user order*/
			ArrayList<Order> orders = OrderDb.getOrderByOfferorId(id);
			/* get the user role name*/
			String role = RoleDb.getRole(user.getRoleID()).getName();
			Client client = ClientBuilder.newClient();
		    
		    /*get the the list of country using an api as country come and go so i have to take it from an api*/
			Response res = client.target("https://restcountries.eu/rest")
					.path("v2")
					.path("alpha")
					.path(user.getCountry())
					.queryParam("fields", "alpha3Code;name")
					.request(MediaType.APPLICATION_JSON).get();
			/* check if the api is ok*/
			switch (res.getStatus()) {
			case 200:
				user.setCountry(res.readEntity(Country.class).getName());
				break;
			case 404:
				user.setCountry("unknown");
			default:
				response.sendError(502,"Looks like someting want wrong with our external API");
				return;
			}
			String currency= (String)session.getAttribute("currency");
		     if(currency!=null) {
			     Response res2 = client.target("https://api.exchangeratesapi.io/")
							.path("latest")
							.queryParam("base","SGD")
							.queryParam("symbols", currency)
							.request(MediaType.APPLICATION_JSON).get();
					/* check if the api is ok*/
					if (res2.getStatus() != 200) {
						response.sendError(502);
						return;
					}
					double	rate = new JSONObject(res2.readEntity(String.class)).getJSONObject("rates").getDouble(currency);
		    		 user.setSpent(((double)Math.round(user.getSpent() *100*rate))/100);
		    		 request.setAttribute("symbol", currency);
		     }
			request.setAttribute("editLink","user");
			request.setAttribute("role", role);
			request.setAttribute("order", orders);
			request.setAttribute("userInfo", user);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/user.jsp");
			dispatcher.forward(request, response);
		} catch (NotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendError(404,"user not Found or you are not login");
		}catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500,"Database Error");
		}catch (NullPointerException e) {
			/*Redirect to login page as the user is not login */
			response.sendRedirect("login");
		}
	}

}
