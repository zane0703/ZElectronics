package sg.com.zElectronics.controller.servlet.admin;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.valueBean.Logined;

/**
 * Servlet implementation class ProductServlet
 */
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Logined logined = (Logined) request.getSession().getAttribute("logIn");
		/*check if the user is login*/
		if (logined == null) {
			response.sendError(401, "Admin only");
			return;
		}
		/*check if the user is admin*/
		if (logined.getViewAdmin()) {
			try {
				/*get products*/
				Object[] products = ProductDb.getProductByArgs(0,0.0,null,5,true,10,1,false);
				/*calculate how many page*/
				int page = (int)Math.floor((((Integer)products[0])-1)/10)+1;
				request.setAttribute("product", products[1]);
				request.setAttribute("page", page);
				request.getRequestDispatcher("/admin.jsp").forward(request, response);
			} catch (SQLException e) {
				e.printStackTrace();
				response.sendError(500, "Database Error");
			}
		} else {
			response.sendError(403, "Admin only");
		}

	}

}
