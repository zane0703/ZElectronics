package sg.com.zElectronics.controller.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

/**
 * Servlet implementation class TestServerlet
 */
@WebServlet("/TestServerlet")
public class TestServerlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		javax.servlet.jsp.JspFactory _jspxFactory =
		          javax.servlet.jsp.JspFactory.getDefaultFactory();
		javax.servlet.jsp.PageContext pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
		 javax.servlet.jsp.JspWriter out = pageContext.getOut();
		long time = System.nanoTime();
		char[] a =new char[] {'h','a','a','a','a','a','a','a','a','a','a','a','a','a','a'};
		String b = "haaaaaaa";
		out.println(request.getClass());
		time = System.nanoTime();
		out.write(a);
		out.println(System.nanoTime()-time);
		time = System.nanoTime();
		time = System.nanoTime();
		out.write(b);
		out.println(System.nanoTime()-time);
		time = System.nanoTime();
		out.write('h');
		out.write('a');
		out.write('a');
		out.write('a');
		out.write('a');
		out.write('a');
		out.write('a');
		out.write('a');
		out.println(System.nanoTime()-time);
		_jspxFactory.releasePageContext(pageContext);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
