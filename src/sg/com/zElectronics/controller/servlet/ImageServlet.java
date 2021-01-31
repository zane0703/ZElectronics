package sg.com.zElectronics.controller.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.NotFoundException;
import org.apache.commons.io.FilenameUtils;


import org.apache.commons.io.FileUtils;

/**
 * Servlet implementation class ImageServlet
 */
@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String folder;

	@Override
	public void init() throws ServletException {
		try {
			ServletContext context = getServletContext();
			Properties fileConfig = (Properties) context.getAttribute("fileConfig");
			folder = fileConfig.getProperty("folder");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String path = request.getPathInfo();
			if (path == null) {
				throw new NotFoundException();
			}
			path = folder + path.substring(1);
			File file;
			//check if the browser support webp ferment
			if (request.getHeader("Accept").contains("image/webp")) {
				file = new File(path+".webp");
				//check if there is a webp file if not send the  original
				if(file.exists()) {
					response.setContentType("image/webp");			
				}else{
					file = new File(path);
					response.setContentType("image/" + FilenameUtils.getExtension(path));
				}
			} else {
				response.setContentType("image/" + FilenameUtils.getExtension(path));
				file=new File(path);
			}
			response.setHeader("Content-Disposition", "filename=\""+file.getName()+"\"");
			response.setContentLength((int) file.length());
			//send the image
			/*
			FileUtils.copyFile(file, response.getOutputStream());*/
			FileInputStream in = new FileInputStream(file);
			int buf=0;
			ServletOutputStream out = response.getOutputStream();
			while((buf=in.read())!=-1) {
				out.write(buf);
			}
			out.flush();
			out.close();
			in.close();
		} catch (NotFoundException | FileNotFoundException e) {
			e.printStackTrace();
			response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
		}

	}

}
