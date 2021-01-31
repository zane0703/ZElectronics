package sg.com.zElectronics.controller.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

import sg.com.zElectronics.model.utilityBean.CartDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Cart;
import sg.com.zElectronics.model.valueBean.Country;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.User;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession();
			int userId = ((Logined) session.getAttribute("logIn")).getUserId();
		    ArrayList<Cart> carts = CartDb.getcartByBuyer(userId);
		    Client client = ClientBuilder.newClient();
		    User user = UserDb.getUser(userId);
		    /*get the the list of country using an api as country come and go so i have to take it from an api*/
			Response res = client.target("https://restcountries.eu/rest")
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
		    	 for(Cart cart:carts) {
		    		 cart.setProductRetailPrice(((double)Math.round(cart.getProductRetailPrice()*100*rate))/100);
		    	 }
		     }
		    request.setAttribute("userInfo", user);
		    request.setAttribute("cart", carts);
		    request.setAttribute("countries", countries);
		    RequestDispatcher dispatcher =  request.getRequestDispatcher("/payment.jsp");
		    dispatcher.forward(request, response);
		}catch (NullPointerException e) {
			response.sendRedirect("login");
		}
		catch (SQLException e) {
		  response.sendError(500,"Database Error");
		    e.printStackTrace();
		}
	}

}
