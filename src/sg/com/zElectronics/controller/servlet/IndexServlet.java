package sg.com.zElectronics.controller.servlet;

import java.io.IOException;

import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.valueBean.Product;

import java.util.ArrayList;

@WebServlet("/Index")
public class IndexServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			//get remdom 2 product 
			ArrayList<Product> products = ProductDb.get3Products();
			request.setAttribute("product", products);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
			dispatcher.forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
			response.sendError(500,"Database Error");
		}
	}


}
