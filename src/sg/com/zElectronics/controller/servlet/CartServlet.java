package sg.com.zElectronics.controller.servlet;

import java.io.IOException;
import java.sql.SQLException;

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
import sg.com.zElectronics.model.valueBean.Cart;
import sg.com.zElectronics.model.valueBean.Logined;

import java.util.ArrayList;

/**
 * Servlet implementation class Cart
 */
@WebServlet("/Cart")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			//check if the user is login
			HttpSession session = request.getSession();
			int userId = ((Logined) session.getAttribute("logIn")).getUserId();
		    ArrayList<Cart> carts = CartDb.getcartByBuyer(userId);
		     String currency= (String)session.getAttribute("currency");
		     if(currency!=null) {
		    	 Client client = ClientBuilder.newClient();
			     Response res = client.target("https://api.exchangeratesapi.io/")
							.path("latest")
							.queryParam("base","SGD")
							.queryParam("symbols", currency)
							.request(MediaType.APPLICATION_JSON).get();
					/* check if the api is ok*/
					if (res.getStatus() != 200) {
						response.sendError(502);
						return;
					}
					double	rate = new JSONObject(res.readEntity(String.class)).getJSONObject("rates").getDouble(currency);
		    	 for(Cart cart:carts) {
		    		 cart.setProductRetailPrice(((double)Math.round(cart.getProductRetailPrice()*100*rate))/100);
		    	 }
		     }
		    request.setAttribute("userId", new Integer(userId));
		    request.setAttribute("cart", carts);
		    RequestDispatcher dispatcher =  request.getRequestDispatcher("cart.jsp");
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
