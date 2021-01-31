package sg.com.zElectronics.model.utilityBean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.ws.rs.NotFoundException;

import sg.com.zElectronics.model.valueBean.Role;

public class RoleDb {
	private static String url;
	//get SQL config from the Listener class
	public static void setConfig(String sqlUrl) {
		url = sqlUrl;
	}

	public static ArrayList<Role> getRole() throws SQLException {
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery(
				"SELECT id, name,viewAdmin,addProduct,editProduct,delProduct,editUser,delUser,setOrderStatus,setCategory,addUser FROM role ;");
		ArrayList<Role> roles = new ArrayList<Role>();
		while (rs.next()) {
			Role role = new Role();
			role.setId(rs.getInt(1));
			role.setName(rs.getString(2));
			role.setViewAdmin(rs.getBoolean(3));
			role.setAddProduct(rs.getBoolean(4));
			role.setEditProduct(rs.getBoolean(5));
			role.setDelProduct(rs.getBoolean(6));
			role.setEditUser(rs.getBoolean(7));
			role.setDelUser(rs.getBoolean(8));
			role.setSetOrderStatus(rs.getBoolean(9));
			role.setSetCategory(rs.getBoolean(10));
			role.setAddUser(rs.getBoolean(11));
			roles.add(role);
		}
		conn.close();
		return roles;
	}

	public static Role getRole(int id) throws SQLException, NotFoundException {
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery(
				"SELECT name,viewAdmin,addProduct,editProduct,delProduct,editUser,delUser,setOrderStatus,setCategory,addUser FROM role WHERE id="
						+ id);
		if (rs.next()) {
			Role role = new Role();
			role.setId(id);
			role.setName(rs.getString(1));
			role.setViewAdmin(rs.getBoolean(2));
			role.setAddProduct(rs.getBoolean(3));
			role.setEditProduct(rs.getBoolean(4));
			role.setDelProduct(rs.getBoolean(5));
			role.setEditUser(rs.getBoolean(6));
			role.setDelUser(rs.getBoolean(7));
			role.setSetOrderStatus(rs.getBoolean(8));
			role.setSetCategory(rs.getBoolean(9));
			role.setAddUser(rs.getBoolean(10));
			conn.close();
			return role;
		} else {
			conn.close();
			throw new NotFoundException("Role not found");
		}
	}
}
