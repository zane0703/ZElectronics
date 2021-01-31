package sg.com.zElectronics.controller.api;

import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.media.multipart.FormDataBodyPart;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.json.JSONObject;

import io.github.biezhi.webp.WebpIO;
import sg.com.zElectronics.model.utilityBean.CartDb;
import sg.com.zElectronics.model.utilityBean.ProductDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.valueBean.Cart;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.Product;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.regex.Pattern;

@Path("/product")
public class ProductAPI {

	private String folder;
	private String[] acceptFile;
	private String contextPath;
	private final Pattern URL_PATTERN = Pattern.compile(
			"^((((https?|ftps?)://)|(mailto:|news:))(%[0-9A-Fa-f]{2}|[-()_.!~*';/?:@&=+$,A-Za-z0-9])+)([).!';/?:,][[:blank:|:blank:]])?$");

	public ProductAPI(@Context ServletContext context) throws IOException {
		Properties fileConfig = (Properties) context.getAttribute("fileConfig");
		folder = fileConfig.getProperty("folder") + "product/";
		acceptFile = fileConfig.getProperty("accept").split(",");

		contextPath = context.getContextPath();
	}

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Response doGet(@Context HttpServletRequest req, @QueryParam("catId") int catId,
			@QueryParam("range") double range, @QueryParam("search") String search, @QueryParam("sort") int sort,
			@QueryParam("limit") int limit, @QueryParam("page") int page, @QueryParam("hasQty") boolean hasQty,
			@QueryParam("currency") String currency) {
		try {
			Logined logined = (Logined) req.getSession().getAttribute("logIn");
			Object[] products = ProductDb.getProductByArgs(catId, range, search, sort,
					logined != null && logined.getViewAdmin(), limit, page, hasQty);
			if (currency != null) {
				@SuppressWarnings("unchecked")
				ArrayList<Product> products2 = (ArrayList<Product>) products[1];
				Client client = ClientBuilder.newClient();
				Response res = client.target("https://api.exchangeratesapi.io/").path("latest")
						.queryParam("base", "SGD").queryParam("symbols", currency).request(MediaType.APPLICATION_JSON)
						.get();
				/* check if the api is ok */
				if (res.getStatus() != 200) {
					throw new WebApplicationException(502);
				}
				double rate = new JSONObject(res.readEntity(String.class)).getJSONObject("rates").getDouble(currency);
				for (Product product : products2) {
					product.setRetailPrice(((double) Math.round(product.getRetailPrice() * 100 * rate)) / 100);
				}
			}
			return Response.status(200).entity(products).build();
		} catch (NumberFormatException e) {
			return Response.status(400).build();
		} catch (SQLException e) {
			e.printStackTrace();
			return Response.status(500).build();
		}
	}
	@Path("{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Product getOneProduct(@PathParam("id")int id) throws SQLException {
		return ProductDb.getProduct(id);
	}
	@POST
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response addProduct(@Context HttpServletRequest req, @FormDataParam("title") String title,
			@FormDataParam("costPr") double costPr, @FormDataParam("retailPr") double retailPr,
			@FormDataParam("qty") int qty, @FormDataParam("category") int category,
			@FormDataParam("briefD") String briefD, @FormDataParam("detailD") String detailD,
			@FormDataParam("upload") int upload, @FormDataParam("picture_url") String picture_url,
			@FormDataParam("pic") InputStream data, @FormDataParam("pic") FormDataBodyPart fileInfo) {
		try {
			Logined logined = (Logined) req.getSession().getAttribute("logIn");
			if (logined == null) {
				return Response.status(401).build();
			}
			//check quantity not negative
			if(qty<0) {
				return Response.status(400).build();
			}
			//check if user can add product
			if (RoleDb.getRole(logined.getRoleId()).isAddProduct()) {
				Product product = new Product();
				product.setTitle(title);
				product.setCostPrice(costPr);
				product.setRetailPrice(retailPr);
				product.setQuantity(qty);
				product.setFKCategoryId(category);
				product.setBriefDescription(briefD);
				product.setDetailDescription(detailD);
				if (upload == 1) {
					String fileType = fileInfo.getMediaType().toString();
					for (int i = 0, size = acceptFile.length;;) {
						if (acceptFile[i].equals(fileType)) {
							break;
						}
						if (size <= ++i) {
							return Response.status(415).build();
						}
					}
					fileType = fileType.split("/")[1];
					product.setImage(fileType);
					String row = ProductDb.addProduct(product, true, contextPath);
					OutputStream out = new FileOutputStream(new File(folder + row + "." + fileType));
					int read = 0;
					byte[] bytes = new byte[1024];
					while ((read = data.read(bytes)) != -1) {
						out.write(bytes, 0, read);
					}
					out.flush();
					out.close();
					// this is a added features it doesn't matter if is not work
					try {
						WebpIO.create().toWEBP("\"" + folder + row + "." + fileType + "\"",
								"\"" + folder + row + "." + fileType + ".webp\"");
					} catch (Exception e) {
					}

					return Response.status(201).build();
				} else {
					if (URL_PATTERN.matcher(picture_url).matches()) {
						product.setImage(picture_url);
					} else {
						return Response.status(400).build();
					}
					ProductDb.addProduct(product, false, "");
					return Response.status(201).build();
				}
			} else {
				return Response.status(403).build();
			}
		} catch (Exception e) {
			return Response.status(500).build();
		}

	}
	
	@Path("{id}")
	@PUT
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public void editProduct(@Context HttpServletRequest req, @FormDataParam("title") String title,
			@PathParam("id") int id, @FormDataParam("costPr") double costPr, @FormDataParam("retailPr") double retailPr,
			@FormDataParam("qty") int qty, @FormDataParam("category") int category,
			@FormDataParam("briefD") String briefD, @FormDataParam("detailD") String detailD,
			@FormDataParam("upload") int upload, @FormDataParam("picture_url") String picture_url,
			@FormDataParam("pic") InputStream data, @FormDataParam("pic") FormDataBodyPart fileInfo) throws Exception {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		//check quantity not negative
		if(qty<0) {
			throw new WebApplicationException(400);
		}
		//check if user can edit product
		if (RoleDb.getRole(logined.getRoleId()).isEditProduct()) {
			Product product = new Product();
			product.setTitle(title);
			product.setCostPrice(costPr);
			product.setRetailPrice(retailPr);
			product.setQuantity(qty);
			product.setFKCategoryId(category);
			product.setBriefDescription(briefD);
			product.setDetailDescription(detailD);
			switch (upload) {
			case 2: {
				for (String accept : acceptFile) {
					String ext = accept.split("/")[1];
					File dirFile = new File(folder + id + "." + ext);
					if (dirFile.exists()) {
						dirFile.delete();
						dirFile = new File(folder + id + "." + ext + ".webp");
						if (dirFile.exists()) {
							dirFile.delete();
						}
					}
				}
				String fileType = fileInfo.getMediaType().toString();
				for (int i = 0, size = acceptFile.length;;) {
					if (acceptFile[i].equals(fileType)) {
						break;
					}
					if (size <= ++i) {
						throw new WebApplicationException(415);
					}
				}
				fileType = fileType.split("/")[1];
				product.setImage(contextPath + "/image/product/" + id + "." + fileType);
				ProductDb.editProduct(id, product);
				OutputStream out = new FileOutputStream(new File(folder + id + "." + fileType));
				int read = 0;
				byte[] bytes = new byte[1024];
				while ((read = data.read(bytes)) != -1) {
					out.write(bytes, 0, read);
				}
				out.flush();
				out.close();
				// this is a added features it doesn't matter if is not work
				try {
					WebpIO.create().toWEBP("\"" + folder + id + "." + fileType + "\"",
							"\"" + folder + id + "." + fileType + ".webp\"");
				} catch (Exception e) {
				}

			}
			break;
			case 1:
				if (URL_PATTERN.matcher(picture_url).matches()) {
					product.setImage(picture_url);
				} else {
					throw new WebApplicationException(400);
				}
			case 0:
				ProductDb.editProduct(id, product);
				break;
			default:
				throw new WebApplicationException(400);
			}
		}else {
			throw new WebApplicationException(403);
		}

	}

	@Path("{id}/cart")
	@POST
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public Response addProductToCart(@Context HttpServletRequest req, @PathParam("id") int id,
			@FormParam("qty") int qty) throws Exception {
		HttpSession session = req.getSession();
		Logined logined = (Logined) session.getAttribute("logIn");
		// check if the user is login
		if (logined == null) {
			return Response.status(401).build();
		}
		// check if the quantity not negative number
		if (qty > 0) {
			Cart cart = new Cart();
			cart.setQuantity(qty);
			cart.setFkBuyerId(logined.getUserId());
			cart.setFkProductId(id);
			ProductDb.setQuantity(id, qty);
			CartDb.addCart(cart);
			// get the user char amount so as to add it
			Integer cartAmount = (Integer) session.getAttribute("cartAmount");
			if (cartAmount == null) {
				cartAmount = new Integer(1);
			} else {
				cartAmount++;
			}
			session.setAttribute("cartAmount", cartAmount);
			return Response.status(201).build();
		} else {
			return Response.status(400).build();
		}
	}

	@Path("{id}")
	@DELETE
	public void deleteProduct(@Context HttpServletRequest req, @PathParam("id") int id)
			throws NotFoundException, SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		// only admin can delete product
		if (RoleDb.getRole(logined.getRoleId()).isDelProduct()) {
			ProductDb.deleteProduct(id);
			for (String accept : acceptFile) {
				File dirFile = new File(folder + id + "." + accept.split("/")[1]);
				if (dirFile.exists()) {
					dirFile.delete();
					dirFile = new File(folder + id + "." + accept.split("/")[1] + ".webp");
					if (dirFile.exists()) {
						dirFile.delete();
					}
				}
			}
		} else {
			throw new WebApplicationException(401);
		}
	}
}
