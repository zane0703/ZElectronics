package sg.com.zElectronics.controller.api;

import javax.ws.rs.POST;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.Arrays;
import sg.com.zElectronics.model.utilityBean.CategoryDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.valueBean.Category;
import sg.com.zElectronics.model.valueBean.Logined;

import javax.servlet.http.HttpServletRequest;

import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import javax.ws.rs.core.Context;

@Path("category")
public class CategoryAPI {
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public ArrayList<Category> getCategories() throws SQLException{
		return CategoryDb.getCategor();
	}
	@Path("{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Category getCategory(@PathParam("id") int id)throws SQLException{
		return CategoryDb.getCategor(id);
	}
	@POST
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	@Produces(MediaType.TEXT_PLAIN)
	public Response addCat(@Context ServletContext context, @Context HttpServletRequest req,
			@FormParam("name") String name) throws SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		/*check if the user is login*/
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		/* check if the user can set Category*/
		if (RoleDb.getRole(logined.getRoleId()).isSetCategory()) {
			try {
				int newId= CategoryDb.addCategor(name);
				Category[] categories =(Category[]) context.getAttribute("category");
				int catLang = categories.length;
				categories = Arrays.copyOf(categories, catLang+1);
				categories[catLang]=new Category(newId, name);
				/*update categorys in serverlet context */
				context.setAttribute("category",categories );
				return Response.status(201).entity(categories[categories.length-1].getId()).build();
			} catch (SQLException e) {
				if (e.getErrorCode() == 1062) {
					throw new WebApplicationException(409);
				} else {
					throw e;
				}
			}
			
		} else {
			return Response.status(403).build();
		}
	}

	@Path("{id}")
	@DELETE
	public void deleteCat(@Context ServletContext context, @Context HttpServletRequest req, @PathParam("id") int id)
			throws SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		if (RoleDb.getRole(logined.getRoleId()).isSetCategory()) {
			CategoryDb.deleteCategor(id);
			ArrayList<Category> categoriesList = CategoryDb.getCategor();
			Category[] categories = new Category[categoriesList.size()];
			categoriesList.toArray(categories);
			context.setAttribute("category",categories );
		} else {
			throw new WebApplicationException(401);

		}
	}
}
