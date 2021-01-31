package sg.com.zElectronics.controller.servlet.admin;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import sg.com.zElectronics.model.utilityBean.OrderDb;
import sg.com.zElectronics.model.valueBean.Country;
import sg.com.zElectronics.model.valueBean.Logined;

/**
 * Servlet implementation class OrderServlet
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String productId = request.getParameter("productId");
		String buyerId = request.getParameter("buyerId");
		Logined logined = (Logined) request.getSession().getAttribute("logIn");
		//check if the user login
		if (logined == null) {
			response.sendError(401, "Admin only");
			return;
		}
		//check if the user is admin
		if(logined.getViewAdmin()) {
			try {
				Object[] orders = OrderDb.getOrderByArgs(productId==null?0:Integer.parseInt(productId), buyerId==null?0:Integer.parseInt(buyerId),0,0,0,0,0, 0,0,null,10,1);
				int page = (int)Math.floor((((Integer)orders[0])-1)/10)+1;
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
				request.setAttribute("country",countries);
				request.setAttribute("productId", productId);
				request.setAttribute("order", orders[1]);
				request.setAttribute("page", page);
				request.setAttribute("buyerId", buyerId);
				request.getRequestDispatcher("/admin/order.jsp").forward(request, response);
			} catch (SQLException e) {
				e.printStackTrace();
				response.sendError(500,"Database Error");
			}catch (NumberFormatException e) {
				response.sendError(400,"product id must be a number");
			}
		}else {
			response.sendError(403, "Admin only");
		}
	}


}
