package sg.com.zElectronics.controller.api;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.FormParam;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.PUT;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import sg.com.zElectronics.model.utilityBean.CartDb;
import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.valueBean.Cart;
import sg.com.zElectronics.model.valueBean.Logined;

@Path("cart")
public class CartAPI {

	/* adding cart is at productApi.java */
	@Path("{id}")
	@PUT
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public void updateCart(@Context HttpServletRequest req, @PathParam("id") int id, @FormParam("qty") int qty)
			throws SQLException {

		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		/* check ig the user is login */
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		if (qty > 0) {

			int userId = logined.getUserId();
			Cart cart = CartDb.getCart(id);
			if (cart.getFkBuyerId() == userId) {
				int different = qty - cart.getQuantity();
				ProductDb.setQuantity(cart.getFkProductId(), different);
				CartDb.setQuantity(id, qty);
			} else {
				throw new WebApplicationException(403);
			}
		} else {
			throw new WebApplicationException(400);
		}
	}

	@Path("{id}")
	@DELETE
	public void deleteCart(@Context HttpServletRequest req, @PathParam("id") int id)
			throws NotAuthorizedException, SQLException {
		HttpSession session = req.getSession();
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		/* check ig the user is login */
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		int userId = logined.getUserId();
		int[] product = CartDb.deleteCart(id, userId);
		Integer cartAmount = (Integer) session.getAttribute("cartAmount");
		cartAmount--;
		session.setAttribute("cartAmount", cartAmount);
		ProductDb.setQuantity(product[1], -product[0]);
	}
}
