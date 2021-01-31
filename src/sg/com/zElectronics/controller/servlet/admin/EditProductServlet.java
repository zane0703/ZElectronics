package sg.com.zElectronics.controller.servlet.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.NotFoundException;

import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.Product;

/**
 * Servlet implementation class EditProductServlet
 */
@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Logined logined =  (Logined)request.getSession().getAttribute("logIn");
		/*check if the user is login*/
		if(logined==null) {
			response.sendError(401,"Admin only");
			return;
		}
		try {
			/* check if the user can edit product*/
			if(RoleDb.getRole(logined.getRoleId()).isEditProduct()) {
				String path = request.getPathInfo();
				if(path==null) {
					response.sendError(404);
					return;
				}
				String[] id = path.split("/");
				if(id.length==2) {
					Product product = ProductDb.getProduct(Integer.parseInt(id[1]));
					request.setAttribute("product", product);
					request.getRequestDispatcher("/admin/product/edit.jsp").forward(request, response);
					
				}else {
					response.sendError(404,"The requested resource ["+request.getRequestURI()+"] is not available");
				}
			}else {
				response.sendError(403,"Admin only");
				return;
			}
			
		}catch(SQLException e) {
			response.sendError(500,"Database Error");
			e.printStackTrace();
		}catch (NumberFormatException e) {
			response.sendError(400,"Id must be number");
		}catch (NotFoundException e) {
			response.sendError(404,"Product not Found");
		}
		catch (Exception e) {
			response.sendError(500,e.toString());
		}
	}


}
