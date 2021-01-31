package sg.com.zElectronics.controller.servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import javax.json.JsonObject;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.valueBean.Product;

public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getPathInfo();
		String currency = (String) request.getSession().getAttribute("currency");
		double rate = 0.0;
		
		if (currency != null) {
			Client client = ClientBuilder.newClient();
			Response res = client.target("https://api.exchangeratesapi.io/").path("latest").queryParam("base", "SGD")
					.queryParam("symbols", currency).request(MediaType.APPLICATION_JSON).get();
			/* check if the api is ok */
			if (res.getStatus() != 200) {
				response.sendError(502);
				return;
			}
			rate = res.readEntity(JsonObject.class).getJsonObject("rates").getJsonNumber(currency).doubleValue();
		}
		try {
			// chcek there if the is a product id in the path if there show product detail
			// else show all product
			if (path != null && !path.equals("/")) {
				String[] id = path.split("/");
				if (id.length == 2) {
					try {
						Product product = ProductDb.getProduct(Integer.parseInt(id[1]));
						if (rate > 0.0) {
							product.setRetailPrice(((double) Math.round(product.getRetailPrice() * 100 * rate)) / 100);
						}
						request.setAttribute("product", product);
						RequestDispatcher dispatcher = request.getRequestDispatcher("/products/detail.jsp");
						dispatcher.forward(request, response);
					} catch (NumberFormatException e) {
						response.sendError(400, "Product ID must be a number");
					}
					
				} else {
					response.sendError(404,
							" The requested resource [" + request.getRequestURI() + "] is not available");
				}

			} else {
				try {
					String catId = request.getParameter("catId");
					// check if cat id is a number
					String search = request.getParameter("search");
					Object[] products = ProductDb.getProductByArgs(catId == null ? 0 : Integer.parseInt(catId), 0.0, search,
							5, false, 6, 1, true);
					int page = (int) Math.floor((((Integer) products[0]) - 1) / 6) + 1;
					@SuppressWarnings("unchecked")
					ArrayList<Product> products2 = (ArrayList<Product>) products[1];
					if (rate > 0.0) {
						for (Product product : products2) {
							product.setRetailPrice(((double) Math.round(product.getRetailPrice() * 100 * rate)) / 100);
						}
					}
					request.setAttribute("catId", catId);
					request.setAttribute("product", products2);
					request.setAttribute("page", Integer.valueOf(page));
					RequestDispatcher dispatcher = request.getRequestDispatcher("/product.min.jsp");
					dispatcher.forward(request, response);
				} catch (NumberFormatException e) {
					response.sendError(400, "category ID must be a number");
				}
				

			}
		} catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500, "Database Error");
		} catch (NotFoundException e) {
			response.sendError(404, "Product not found");
		}

	}

}
