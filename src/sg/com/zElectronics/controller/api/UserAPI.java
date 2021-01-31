package sg.com.zElectronics.controller.api;

import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;

import java.io.IOException;
import java.io.InputStream;

import java.io.OutputStream;

import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.regex.Pattern;
import java.util.Properties;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.AddressException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.PATCH;
import javax.ws.rs.PUT;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.File;
import java.io.FileOutputStream;
import io.github.biezhi.webp.WebpIO;
import sg.com.zElectronics.MailService;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Captcha;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.User;

import org.glassfish.jersey.media.multipart.FormDataBodyPart;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.apache.commons.lang3.RandomStringUtils;

@Path("users")
public class UserAPI {
	private final Pattern EMAIL_PATTERN = Pattern
			.compile("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");
	private final Pattern PW_PATTERN = Pattern.compile("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=\\S+$).{8,}");
	private final Pattern TEL_PATTERN = Pattern
			.compile("^(\\+\\d{1,3}( )?)?((\\(\\d{1,3}\\))|\\d{1,3})[- .]?\\d{3,4}[- .]?\\d{4}$");
	private final Pattern URL_PATTERN = Pattern.compile(
			"^((((https?|ftps?)://)|(mailto:|news:))(%[0-9A-Fa-f]{2}|[-()_.!~*';/?:@&=+$,A-Za-z0-9])+)([).!';/?:,][[:blank:|:blank:]])?$");
	private String contextPath;
	private String folder;
	private String[] acceptFile;

	public UserAPI(@Context ServletContext context) throws IOException {
		Properties fileConfig = (Properties) context.getAttribute("fileConfig");
		Properties mailConfig = new Properties();
		mailConfig.load(context.getResourceAsStream("/WEB-INF/maill.properties"));
		MailService.setConfig(mailConfig);
		folder = fileConfig.getProperty("folder") + "profile/";
		acceptFile = fileConfig.getProperty("accept").split(",");
		contextPath = context.getContextPath();
	}

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Object[] getUsersByArgs(@Context HttpServletRequest req, @QueryParam("role") int role,
			@QueryParam("sort") int sort, @QueryParam("country")String country,@QueryParam("search") String search, @QueryParam("limit") int limit,
			@QueryParam("page") int page) throws SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		// only admin can see all user
		if (logined.getViewAdmin()) {
			return UserDb.getUser(role, sort,country, search, limit, page);
		} else {
			throw new WebApplicationException(403);
		}
	}
	@Path("{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public User getUser(@Context HttpServletRequest req, @PathParam("id")int id) throws SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		// only admin can see all user
		if (logined.getViewAdmin()) {
			return UserDb.getUser(id);
		} else {
			throw new WebApplicationException(403);
		}
	}
	@Path("{id}")
	@PUT
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response updateUser(@Context HttpServletRequest req, @PathParam("id") int id,
			@FormDataParam("name") String name, @FormDataParam("email") String email,
			@FormDataParam("password") String password, @FormDataParam("cPassword") String cPassword,
			@FormDataParam("profile_pic_url") String profile_pic_url, @FormDataParam("contact") String contact,
			@FormDataParam("upload") int upload, @FormDataParam("role") int role,
			@FormDataParam("address") String address, @FormDataParam("country") String country,
			@FormDataParam("postalCode") int postalCode, @FormDataParam("pic") InputStream data,
			@FormDataParam("pic") FormDataBodyPart fileInfo, @FormDataParam("isAdmin") boolean isAdmin,
			@FormDataParam("currPassword") String currPassword) {
		HttpSession session = req.getSession();
		Logined logined = (Logined) session.getAttribute("logIn");
		if (logined == null) {
			return Response.status(401).build();
		}
		try {
			User user = new User();
			if (isAdmin) {
				try {// only root user can edit other user
					if (RoleDb.getRole(logined.getRoleId()).isEditUser()) {
						user.setRoleID(role);
						if (name != null && !name.trim().equals("")) {
							user.setName(name);
						}
						if (email != null && !email.trim().equals("")) {
							if (EMAIL_PATTERN.matcher(email).matches()) {
								user.setEmail(email);
							} else {
								return Response.status(400).build();
							}
						}
					} else {
						return Response.status(401).build();
					}
				} catch (NotFoundException e) {
					e.printStackTrace();
					return Response.status(401).build();
				}
			} else {
				if (logined.getUserId() == id) {

					if (name != null && !name.trim().equals("")) {
						user.setName(name);
						logined.setUsername(name);
					}
					if (email != null && !email.trim().equals("")) {
						if (EMAIL_PATTERN.matcher(email).matches()) {
							String token = RandomStringUtils.random(20, 0, 0, true, true, null, new SecureRandom());
							// send a email to verify it is the owner of the email address
							MailService.verifyEmail(email, token);
							session.setAttribute("changeEmail", new String[] { email, token });
						} else {
							return Response.status(400).build();
						}
					}
				} else {
					return Response.status(401).build();
				}
			}

			// check if the user want to change password
			if (password != null && !password.trim().equals("")) {
				if (isAdmin || BCrypt.checkpw(currPassword, UserDb.getUser(id).getPassword())) {
					// chcek if the password have upper and lower case and number
					if (PW_PATTERN.matcher(password).matches()) {
						// hash the password
						String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));
						user.setPassword(hash);
					} else {
						return Response.status(400).entity("password").build();
					}
				} else {
					return Response.status(422).build();
				}
			}
			if (contact != null && !contact.trim().equals("")) {
				if (TEL_PATTERN.matcher(contact).matches()) {
					user.setContact(contact);
				} else {
					return Response.status(400).entity("contact").build();
				}
			}
			user.setAddress(address);
			user.setCountry(country);
			System.out.println(country);
			user.setPostalCode(postalCode);
			switch (upload) {
			case 2: {
				// delete the old image
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
				// get image file extension
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
				user.setImage(contextPath + "/image/profile/" + id + "." + fileType);
				UserDb.updateUser(id, user);
				OutputStream out = new FileOutputStream(new File(folder + id + "." + fileType));
				int read = 0;
				byte[] bytes = new byte[1024];
				while ((read = data.read(bytes)) != -1) {
					out.write(bytes, 0, read);
				}
				out.flush();
				out.close();
				// convert image to webp
				// this is a added features it doesn't matter if is not work
				try {
					WebpIO.create().toWEBP("\"" + folder + id + "." + fileType + "\"",
							"\"" + folder + id + "." + fileType + ".webp\"");
				} catch (Exception e) {
				}
				return Response.status(204).build();
			}
			case 1:
				// verify is it a URL
				if (URL_PATTERN.matcher(profile_pic_url).matches()) {
					user.setImage(profile_pic_url);
				} else {
					return Response.status(400).build();
				}

			case 0:
				UserDb.updateUser(id, user);
				return Response.status(204).build();
			default:
				return Response.status(400).build();
			}

		} catch (SQLException e) {
			// check if the email have alredy been used
			if (e.getErrorCode() == 1062) {
				return Response.status(409).build();
			} else {
				e.printStackTrace();
				return Response.status(500).build();
			}
		} catch (NotFoundException e) {
			e.printStackTrace();
			return Response.status(404).build();
		} catch (Exception e) {
			e.printStackTrace();
			return Response.status(500).build();
		}

	}

	// update email after verifiy
	@Path("{id}/email")
	@PATCH
	@Consumes(MediaType.TEXT_PLAIN)
	public void updateEmail(String token, @PathParam("id") int id, @Context HttpServletRequest req)
			throws SQLException {
		HttpSession session = req.getSession();
		Logined logined = (Logined) session.getAttribute("logIn");
		String[] email = (String[]) session.getAttribute("changeEmail");
		if (logined == null || email == null) {
			throw new WebApplicationException(401);
		}
		if (logined.getUserId() == id) {
			if (email[1].equals(token)) {
				try {
					UserDb.updateEmail(id, email[0]);
					session.setAttribute("changeEmail", null);
				} catch (SQLException e) {
					// check if the email have alredy been used
					if (e.getErrorCode() == 1062) {
						throw new WebApplicationException(409);
					} else {
						throw e;
					}
				}

			} else {
				throw new WebApplicationException(403);
			}
		} else {
			throw new WebApplicationException(401);
		}
	}

	@POST
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.TEXT_PLAIN)
	public Response singup(@Context HttpServletRequest req, @FormDataParam("g-recaptcha-response") String captchaToken,
			@FormDataParam("name") String name, @FormDataParam("email") String email,
			@FormDataParam("password") String password, @FormDataParam("cPassword") String cPassword,
			@FormDataParam("profile_pic_url") String profile_pic_url, @FormDataParam("contact") String contact,
			@FormDataParam("upload") int upload, @FormDataParam("pic") InputStream data,
			@FormDataParam("pic") FormDataBodyPart fileInfo, @FormDataParam("address") String address,
			@FormDataParam("country") String country, @FormDataParam("postalCode") int postalCode,
			@FormDataParam("isAdmin") boolean isAdmin, @FormDataParam("role") int role) {
		try {
			HttpSession session = req.getSession();
			User user = new User();
			if (isAdmin) {
				Logined logined = (Logined) session.getAttribute("logIn");
				// check if the admin is login
				if (logined == null) {
					return Response.status(401).build();
				}
				// check if the admin can add user
				if (!RoleDb.getRole(logined.getRoleId()).isAddUser()) {
					return Response.status(403).build();
				}
				user.setRoleID(role);
			} else {
				user.setRoleID(1);
			}
			// chcek if the email address is legitimate
			// verify the caption token with google api to see if the user have pass the
			// caption
			Captcha captcha = new Captcha();
			// admin user created don't have to do captcha
			if (!isAdmin) {
				Client client = ClientBuilder.newClient();
				Response response = client.target("https://www.google.com/recaptcha/api").path("siteverify")
						.queryParam("secret", "??")
						.queryParam("response", captchaToken).request(MediaType.APPLICATION_JSON).get();
				if (response.getStatus() != 200) {
					return Response.status(502).build();
				}
				captcha = response.readEntity(Captcha.class);
			}

			if (isAdmin || captcha.isSuccess()) {
				// check if the password, telephone number and email is valid
				if (PW_PATTERN.matcher(password).matches() && TEL_PATTERN.matcher(contact).matches()
						&& EMAIL_PATTERN.matcher(email).matches()) {
					// chect if the contact number is legitimate
					String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));
					user.setEmail(email);
					user.setName(name);
					user.setPassword(hash);
					user.setContact(contact);
					user.setAddress(address);
					user.setPostalCode(postalCode);
					user.setCountry(country);
					// gen token for email verification
					String token = RandomStringUtils.random(20, 0, 0, true, true, null, new SecureRandom());
					// if the user upload image
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
						user.setImage(fileType);

						// store the image in temp file awaiting email verification
						File temFile = File.createTempFile(email, ".temp");
						OutputStream out = new FileOutputStream(temFile);
						int read = 0;
						byte[] bytes = new byte[1024];
						while ((read = data.read(bytes)) != -1) {
							out.write(bytes, 0, read);
						}
						out.flush();
						out.close();
						data.close();
						if (isAdmin) {
							String row = UserDb.addUser(user, true, contextPath);// move the image from temp file to
																					// permanent location base on user
																					// id
							temFile.renameTo(new File(folder + row + "." + fileType));
							// this is a added features it doesn't matter if is not work
							try {
								WebpIO.create().toWEBP("\"" + folder + row + "." + fileType + "\"",
										"\"" + folder + row + "." + fileType + ".webp\"");
							} catch (Exception e) {
							}
						} else {
							// store the req in session Attribute awaiting email verification
							session.setAttribute("image", temFile);
							session.setAttribute("token", token);
							session.setAttribute("user", user);
							// send emaill to the user email for verification
							MailService.verifyEmail(email, token);
							// if the user give the URL if the image
						}
					} else {
						// check if the url is legitimate
						if (URL_PATTERN.matcher(profile_pic_url).matches()) {
							user.setImage(profile_pic_url);
							if (isAdmin) {
								UserDb.addUser(user, false, contextPath);
							} else {
								session.setAttribute("token", token);
								session.setAttribute("user", user);
								// send emaill to the user email for verification
								MailService.verifyEmail(email, token);
								// if the user give the URL if the image
							}
						} else {
							return Response.status(400).entity("u").build();
						}
						// store the req in session Attribute awaiting email verification

					}
					return Response.status(201).build();

				} else {
					return Response.status(400).build();

				}
			} else {
				return Response.status(422).entity("captcha").build();
			}

		} catch (NullPointerException e) {
			return Response.status(400).build();
		} catch (Exception e) {
			e.printStackTrace();
			return Response.status(500).build();
		}

	}

	// continue with sign up req after email verification
	@Path("verify")
	@PATCH
	@Consumes(MediaType.TEXT_PLAIN)
	public void verifyEmail(String token, @PathParam("id") int id, @Context HttpServletRequest req)
			throws IOException, SQLException {
		HttpSession session = req.getSession();
		String token2 = (String) session.getAttribute("token");
		if (token.equals(token2)) {
			User user = (User) session.getAttribute("user");
			File data = (File) session.getAttribute("image");
			try {
				// check if the user have upload an image
				if (data == null) {
					UserDb.addUser(user, false, contextPath);
					session.invalidate();
				} else {
					String fileType = user.getImage();
					String row = UserDb.addUser(user, true, contextPath);
					// move the image from temp file to permanent location base on user id
					data.renameTo(new File(folder + row + "." + fileType));
					// this is a added features it doesn't matter if is not work
					try {
						WebpIO.create().toWEBP("\"" + folder + row + "." + fileType + "\"",
								"\"" + folder + row + "." + fileType + ".webp\"");
					} catch (Exception e) {
					}

					session.invalidate();
				}
			} catch (SQLException e) {
				// check if the email have been used
				if (e.getErrorCode() == 1062) {
					throw new WebApplicationException(409);
				} else {
					throw e;
				}
			}

		} else {
			throw new WebApplicationException(401);
		}

	}

	@Path("forgetpassword")
	@POST
	@Consumes(MediaType.TEXT_PLAIN)
	@Produces(MediaType.TEXT_PLAIN)
	public int forgetPassword(String email)
			throws NotFoundException, SQLException, AddressException, MessagingException {
		// gen token for reset passwoed
		String token = RandomStringUtils.random(20, 0, 0, true, true, null, new SecureRandom());
		// hash the token to set the token as the temp password
		String hash = BCrypt.hashpw(token, BCrypt.gensalt());
		int userid = UserDb.getUserByName(email).getId();
		User user = new User();
		user.setPassword(hash);
		UserDb.updateUser(userid, user);
		MailService.forgetPW(email, token);
		return userid;
	}

	// update the password req forgetpassword
	@Path("{id}/password")
	@PATCH
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public void updatePassword(@PathParam("id") int id, @FormParam("token") String token,
			@FormParam("password") String password, @FormParam("recaptcha") String recaptcha)
			throws NotFoundException, SQLException {
		Client client = ClientBuilder.newClient();
		Response response = client.target("https://www.google.com/recaptcha/api").path("siteverify")
				.queryParam("secret", "?").queryParam("response", recaptcha)
				.request(MediaType.APPLICATION_JSON).get();
		if (response.getStatus() != 200) {
			throw new WebApplicationException(502);
		}
		Captcha captcha = response.readEntity(Captcha.class);
		if (captcha.isSuccess()) {
			String oldPass = UserDb.getUser(id).getPassword();
			// chcek if the token is correct
			if (BCrypt.checkpw(token, oldPass)) {
				if (PW_PATTERN.matcher(password).matches()) {
					// hash the password
					String hash = BCrypt.hashpw(password, BCrypt.gensalt());
					User user = new User();
					user.setPassword(hash);
					UserDb.updateUser(id, user);
				} else {
					throw new WebApplicationException(400);
				}
			} else {
				throw new WebApplicationException(403);
			}
		} else {
			throw new WebApplicationException(401);
		}
	}

	// delete the user only root user can delete the user
	@Path("{id}")
	@DELETE
	public void deleteUser(@Context HttpServletRequest req, @PathParam("id") int id)
			throws NotFoundException, SQLException {
		Logined logined = (Logined) req.getSession().getAttribute("logIn");
		if (logined == null) {
			throw new WebApplicationException(401);
		}
		if (RoleDb.getRole(logined.getRoleId()).isDelUser()) {
			UserDb.deleteUser(id);
			// delete the user profile image
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
			throw new WebApplicationException(403);
		}
	}

}
