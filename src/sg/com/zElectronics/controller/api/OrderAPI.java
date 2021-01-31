package sg.com.zElectronics.controller.api;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.core.MediaType;

import sg.com.zElectronics.model.utilityBean.CartDb;
import sg.com.zElectronics.model.utilityBean.OrderDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Cart;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.Order;

import javax.ws.rs.core.GenericEntity;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.sql.SQLException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.PATCH;
import javax.ws.rs.POST;

import java.util.ArrayList;
import javax.ws.rs.core.Context;

@Path("orders")
public class OrderAPI {

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Object[] doGet(@Context HttpServletRequest req, @QueryParam("productId") int productId,
			@QueryParam("sort") int sort, @QueryParam("buyerId") int buyerId, @QueryParam("day") int day,@QueryParam("dayTo")int dayTo,
			@QueryParam("week") int week, @QueryParam("month") int month, @QueryParam("year") int year,@QueryParam("country")String country,
			@QueryParam("status") int status, @QueryParam("limit") int limit, @QueryParam("page") int page)
			throws Exception {
		try {
			if (((Logined) req.getSession().getAttribute("logIn")).getViewAdmin()) {
				Object[] orders = OrderDb.getOrderByArgs(productId, buyerId, sort, day, dayTo,week, month, year, status,country,
						limit, page);
				return orders;
			} else {
				throw new WebApplicationException(401);
			}
		} catch (NullPointerException e) {
			throw new WebApplicationException(401);
		}

	}

	@Path("{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public GenericEntity<Order> getOrderbyId(@Context HttpServletRequest req, @PathParam("id") int id)
			throws SQLException {
		try {
			if (((Logined) req.getSession().getAttribute("logIn")).getViewAdmin()) {
				Order order = OrderDb.getOrder(id);
				return new GenericEntity<Order>(order, Order.class);
			} else {
				throw new WebApplicationException(403);

			}
		} catch (NullPointerException e) {
			throw new WebApplicationException(401);
		}
	}

	@POST
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public void checkout(@Context HttpServletRequest req, @FormParam("address") String address,
			@FormParam("postal") int postal, @FormParam("ccname") String ccName, @FormParam("ccnum") String ccNum,
			@FormParam("cvv") int cvv, @FormParam("shipaddress") String shipAddress,
			@FormParam("shipPostal") int shipPostal, @FormParam("sameadr") int sameadr,
			@FormParam("expDate") long expDate, @FormParam("country") String country,
			@FormParam("shipCountry") String shipCountry) throws SQLException {
		HttpSession session = req.getSession();
		Logined logined = (Logined) session.getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		try {
			if (validateCreditCardNumber(ccNum) && !address.trim().equals("") && !ccName.trim().equals("") && cvv < 1000
					&& System.currentTimeMillis() < expDate) {
				int userId = logined.getUserId();
				ArrayList<Cart> carts = CartDb.findAndDeleteByBuyer(userId);
				int rows = carts.size();
				double spent = 0.0;
				Order[] orders = new Order[rows];
				for (int i = 0; i < rows; i++) {
					Cart cart = carts.get(i);
					Order order = new Order();
					spent += cart.getProductRetailPrice();
					order.setFkBuyerId(userId);
					order.setFkProductId(cart.getFkProductId());
					order.setQuantity(cart.getQuantity());
					order.setBillAddress(address);
					order.setBillPostal(postal);
					order.setBillCountry(country);
					if (sameadr == 1) {
						order.setShipAddress(address);
						order.setShipPostal(postal);
						order.setShipCountry(country);
					} else {
						order.setShipAddress(shipAddress);
						order.setShipPostal(shipPostal);
						order.setShipCountry(shipCountry);
					}
					orders[i] = order;
				}
				OrderDb.addOrder(orders);
				UserDb.addSpent(userId, spent);
				session.setAttribute("cartAmount", new Integer(0));
			} else {
				throw new WebApplicationException(400);
			}
		} catch (NullPointerException e) {
			e.printStackTrace();
			throw new WebApplicationException(400);
		}

	}

	@Path("{id}/status")
	@PATCH
	@Consumes(MediaType.TEXT_PLAIN)
	public void changeStatus(@Context HttpServletRequest req, @PathParam("id") int id, int status)
			throws NotFoundException, SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		if (RoleDb.getRole(logined.getRoleId()).isSetOrderStatus()) {
			OrderDb.setStatus(id, status);
		} else {
			throw new WebApplicationException(401);
		}
	}

	@Path("{id}")
	@DELETE
	public void deleteOrder(@Context HttpServletRequest req, @PathParam("id") int id)
			throws NotAuthorizedException, SQLException {
		HttpSession session = req.getSession();
		Logined logined = (Logined) session.getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		if (RoleDb.getRole(logined.getRoleId()).isSetOrderStatus()) {
			OrderDb.deleteOrder(id);
		} else {
			throw new WebApplicationException(403);
		}
	}

	private static boolean validateCreditCardNumber(String str) {

		int[] ints = new int[str.length()];
		for (int i = 0; i < str.length(); i++) {
			ints[i] = Integer.parseInt(str.substring(i, i + 1));
		}
		for (int i = ints.length - 2; i >= 0; i = i - 2) {
			int j = ints[i];
			j = j * 2;
			if (j > 9) {
				j = j % 10 + 1;
			}
			ints[i] = j;
		}
		int sum = 0;
		for (int i = 0; i < ints.length; i++) {
			sum += ints[i];
		}
		return sum % 10 == 0;
	}
}
