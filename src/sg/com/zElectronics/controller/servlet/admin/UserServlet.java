package sg.com.zElectronics.controller.servlet.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import sg.com.zElectronics.model.utilityBean.OrderDb;
import sg.com.zElectronics.model.utilityBean.RoleDb;
import sg.com.zElectronics.model.utilityBean.UserDb;
import sg.com.zElectronics.model.valueBean.Country;
import sg.com.zElectronics.model.valueBean.Logined;
import sg.com.zElectronics.model.valueBean.Order;
import sg.com.zElectronics.model.valueBean.Role;
import sg.com.zElectronics.model.valueBean.User;

import java.util.ArrayList;
@WebServlet("/userServlet")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 try {
			Role role = RoleDb.getRole(((Logined) request.getSession().getAttribute("logIn")).getRoleId());
			if(role.isViewAdmin()) {
				String path = request.getPathInfo();
				if (path != null && !path.equals("/")) {
					String[] path2 = path.split("/");
					switch (path2.length) {
					case 4:if(!path2[3].equals("")) {
						response.sendError(404);
						return;
					}
					case 3: if(!path2[2].equals("")) {
						if(path2[2].equals("edit")) {
							if(role.isEditUser()) {
								if(path2[2].equals("edit")) {
									int userId  = Integer.parseInt(path2[1]);
									User user = UserDb.getUser(userId);
									ArrayList<Role> roles = RoleDb.getRole();
									Response res = ClientBuilder.newClient().target("https://restcountries.eu/rest")
											.path("v2")
											.path("all")
											.queryParam("fields", "alpha3Code;name")
											.request(MediaType.APPLICATION_JSON).get();
									/* check if the api is ok*/
									if (res.getStatus() != 200) {
										response.sendError(502);
										return;
									}
									Country[] countries = res.readEntity(Country[].class);
									request.setAttribute("userInfo", user);
									request.setAttribute("role", roles);
									request.setAttribute("country",countries);
									request.getRequestDispatcher("/admin/user/edit.jsp").forward(request, response);
								}else {
									response.sendError(401,"You are unauthorized to edit other users");
								}
								
							}else {
								response.sendError(401,"You are unauthorized to edit other users");
							}
						}else {
							response.sendError(404," The requested resource ["+request.getRequestURI()+"] is not available");
						}
						break;
					}
					case 2:{
					int userId  = Integer.parseInt(path2[1]);
					User user = UserDb.getUser(userId);
					ArrayList<Order> orders = OrderDb.getOrderByOfferorId(userId);
					String userType = RoleDb.getRole(user.getRoleID()).getName();
					request.setAttribute("editLink",role.isEditUser()?path2[1]:"not");
					request.setAttribute("userInfo", user);
					request.setAttribute("role", userType );
					request.setAttribute("order", orders);
					request.getRequestDispatcher("/user.jsp").forward(request, response);
					}
						break;
					default:
						response.sendError(404," The requested resource ["+request.getRequestURI()+"] is not available");
						break;
					}
				}else {
					Object[] users = UserDb.getUser(0,0,null,null,10,1);
					ArrayList<Role> roles = RoleDb.getRole();
					Response res = ClientBuilder.newClient().target("https://restcountries.eu/rest")
							.path("v2")
							.path("all")
							.queryParam("fields", "alpha3Code;name")
							.request(MediaType.APPLICATION_JSON).get();
					/* check if the api is ok*/
					if (res.getStatus() != 200) {
						response.sendError(502);
						return;
					}
					Country[] countries = res.readEntity(Country[].class);
					request.setAttribute("country",countries);
					int page = (int)Math.floor((((Integer)users[0])-1)/10)+1;
					request.setAttribute("page",new Integer(page));
					request.setAttribute("userInfo", users[1]);
					request.setAttribute("role", roles);
					request.setAttribute("userRole", role);
					request.getRequestDispatcher("/admin/user/user.jsp").forward(request, response);
					
				}
			}
		}catch (NumberFormatException e) {
			response.sendError(400,"User ID must be a number");
		}
		 catch (NotFoundException e) {
			response.sendError(404);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendError(500,"Database Error");
		}catch (NullPointerException e) {
			response.sendError(401);
		}
	}


}
