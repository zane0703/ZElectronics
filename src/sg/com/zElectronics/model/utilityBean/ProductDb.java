package sg.com.zElectronics.model.utilityBean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import javax.ws.rs.NotFoundException;
import javax.ws.rs.WebApplicationException;

import sg.com.zElectronics.model.valueBean.Product;

public class ProductDb {
	private static String url;
	//get SQL config from the Listener class
	public static void setConfig(String sqlUrl) {
		url = sqlUrl;
	}

	public static ArrayList<Product> getProduct() throws SQLException {
		ArrayList<Product> products = new ArrayList<Product>();
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery(
				"SELECT p.id,title,briefD,detailD,costPr,retailPr,p.qty,image ,FKCategoryId,p.createdAt ,c.name,COUNT(o.id) AS orderAmount FROM product  p INNER JOIN category c ON FKCategoryId = c.id LEFT JOIN `order` o ON p.id=FkProductId   group by p.id ;");
		while (rs.next()) {
			Product product = new Product();
			product.setId(rs.getInt("id"));
			product.setTitle(rs.getString("title"));
			product.setBriefDescription(rs.getString("briefD"));
			product.setDetailDescription(rs.getString("detailD"));
			product.setCostPrice(rs.getDouble("costPr"));
			product.setRetailPrice(rs.getDouble("retailPr"));
			product.setQuantity(rs.getInt("qty"));
			product.setImage(rs.getString("image"));
			product.setCreatedAt(rs.getDate("createdAt"));
			product.setCategoryName(rs.getString("name"));
			product.setOrderAmount(rs.getInt("orderAmount"));
			products.add(product);
		}
		conn.close();
		return products;
	}

	public static Product getProduct(int id) throws SQLException, NotFoundException {
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery(
				"SELECT p.id,title,briefD,detailD,costPr,retailPr,p.qty,image ,FKCategoryId,p.createdAt,c.name FROM product p INNER JOIN category c ON FKCategoryId = c.id  WHERE p.id ="
						+ id);
		if (rs.next()) {
			Product product = new Product();
			product.setId(rs.getInt("id"));
			product.setTitle(rs.getString("title"));
			product.setBriefDescription(rs.getString("briefD"));
			product.setDetailDescription(rs.getString("detailD"));
			product.setCostPrice(rs.getDouble("costPr"));
			product.setRetailPrice(rs.getDouble("retailPr"));
			product.setQuantity(rs.getInt("qty"));
			product.setImage(rs.getString("image"));
			product.setCreatedAt(rs.getDate("createdAt"));
			product.setCategoryName(rs.getString("name"));
			conn.close();
			return product;
		} else {
			conn.close();
			throw new NotFoundException("Product not found");
		}
	}

	public static Object[] getProductByArgs(int catID, double range, String search, int sort, boolean showOrderAmount,
			int linit, int page, boolean hasQty) throws NumberFormatException, SQLException {
		ArrayList<Product> products = new ArrayList<Product>();
		Connection conn = DriverManager.getConnection(url);
		boolean[] hasArgs = new boolean[] { catID != 0, range != 0, search != null, linit != 0 };

		/* get the amount of product so i can calculate the amount of page */
		StringBuilder sql = new StringBuilder("SELECT  COUNT(*) AS amount FROM product p  WHERE true");
		if (hasArgs[0]) {
			sql.append(" && FKCategoryId =? ");
		}
		if (hasArgs[1]) {
			sql.append(" && retailPr<= ?");
		}
		if (hasArgs[2]) {
			sql.append(" && title like CONCAT('%', ? ,'%')");
		}
		if (hasQty) {
			sql.append(" && p.qty>0");
		}
		PreparedStatement stmt = conn.prepareStatement(sql.toString());
		int parameterIndex = 1;
		if (hasArgs[0]) {
			stmt.setInt(parameterIndex++, catID);
		}
		if (hasArgs[1]) {
			stmt.setDouble(parameterIndex++, range);
		}
		if (hasArgs[2]) {
			stmt.setString(parameterIndex++, search);
		}
		ResultSet rs = stmt.executeQuery();
		rs.next();
		Integer productAmount = new Integer(rs.getInt("amount"));
		/* get product */
		sql.replace(7, 42,
				"p.id,title,briefD,detailD,costPr,retailPr,p.qty,image ,FKCategoryId,p.createdAt,COUNT(o.id) as orderAmount FROM product p LEFT JOIN `order` o ON p.id=FkProductId ");
		sql.append(" group by p.id ");
		try {
			if (sort != 0) {
				sql.append(" ORDER BY ");
				switch (sort) {
				case 1:
					sql.append("retailPr ASC");
					break;
				case 2:
					sql.append("retailPr DESC");
					break;
				case 3:
					sql.append("orderAmount ASC");
					break;
				case 4:
					sql.append("orderAmount DESC");
					break;
				case 5:
					sql.append("p.createdAt DESC");
					break;
				case 6:
					sql.append("p.createdAt ASC");
					break;
				case 7:
					sql.append("title ASC");
					break;
				case 8:
					sql.append("p.qty ASC");
					break;
				case 9:
					sql.append("p.qty  DESC");
				}
			}
			if (hasArgs[3]) {
				sql.append(" LIMIT ? ,?");
			}
		} catch (NumberFormatException e) {
			throw new WebApplicationException(400);
		}

		stmt = conn.prepareStatement(sql.toString());
		parameterIndex = 1;
		if (hasArgs[0]) {
			stmt.setInt(parameterIndex++, catID);
		}
		if (hasArgs[1]) {
			stmt.setDouble(parameterIndex++, range);
		}
		if (hasArgs[2]) {
			stmt.setString(parameterIndex++, search);
		}
		if (hasArgs[3]) {
			stmt.setInt(parameterIndex++, (page - 1) * linit);
			stmt.setInt(parameterIndex, linit);
		}
		rs = stmt.executeQuery();
		while (rs.next()) {
			Product product = new Product();
			product.setId(rs.getInt("id"));
			product.setTitle(rs.getString("title"));
			product.setBriefDescription(rs.getString("briefD"));
			product.setDetailDescription(rs.getString("detailD"));
			product.setCostPrice(rs.getDouble("costPr"));
			product.setRetailPrice(rs.getDouble("retailPr"));
			product.setQuantity(rs.getInt("qty"));
			if (showOrderAmount) {
				product.setOrderAmount(rs.getInt("orderAmount"));
			}
			product.setImage(rs.getString("image"));
			product.setCreatedAt(rs.getDate("createdAt"));
			product.setFKCategoryId(rs.getInt("FKCategoryId"));
			products.add(product);
		}
		conn.close();
		return new Object[] { productAmount, products };
	}

	public static ArrayList<Product> get3Products() throws SQLException {
		ArrayList<Product> products = new ArrayList<Product>();
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement()
				.executeQuery("SELECT id, title, image FROM product WHERE qty!=0 ORDER BY RAND() LIMIT 3;");
		while (rs.next()) {
			Product product = new Product();
			product.setId(rs.getInt("id"));
			product.setTitle(rs.getString("title"));
			product.setImage(rs.getString("image"));
			products.add(product);
		}
		conn.close();
		return products;
	}

	public static String addProduct(Product product, boolean isUpload, String contextPath) throws SQLException {
		Connection conn = DriverManager.getConnection(url);
		PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO product(title,briefD,detailD,costPr,retailPr,FKCategoryId,qty,image) VALUE(?,?,?,?,?,?,?,?)",
				PreparedStatement.RETURN_GENERATED_KEYS);
		stmt.setString(1, product.getTitle());
		stmt.setString(2, product.getBriefDescription());
		stmt.setString(3, product.getDetailDescription());
		stmt.setDouble(4, product.getCostPrice());
		stmt.setDouble(5, product.getRetailPrice());
		stmt.setDouble(6, product.getfKCategoryId());
		stmt.setInt(7, product.getQuantity());
		stmt.setString(8, product.getImage());
		if (stmt.executeUpdate() == 0) {
			conn.close();
			throw new SQLException();
		} else {
			if (isUpload) {
				ResultSet rs = stmt.getGeneratedKeys();
				rs.next();
				String row = rs.getString(1);
				conn.createStatement().execute("UPDATE product SET image=\"" + contextPath + "/image/product/" + row
						+ "." + product.getImage() + "\" WHERE id=" + row);
				conn.close();
				return row;
			} else {
				conn.close();
				return null;
			}
		}

	}

	public static void editProduct(int id, Product product) throws SQLException {
		String image = product.getImage();
		Connection conn = DriverManager.getConnection(url);
		PreparedStatement stmt = conn.prepareStatement(
				"UPDATE product SET title=?,briefD=?,detailD=?,costPr=?,retailPr=?,FKCategoryId=?,qty=?"
						+ (image == null ? "" : ", image=?") + " WHERE id=?;");
		stmt.setString(1, product.getTitle());
		stmt.setString(2, product.getBriefDescription());
		stmt.setString(3, product.getDetailDescription());
		stmt.setDouble(4, product.getCostPrice());
		stmt.setDouble(5, product.getRetailPrice());
		stmt.setInt(6, product.getfKCategoryId());
		stmt.setInt(7, product.getQuantity());
		int parameterIndex = 8;
		if (image != null) {
			stmt.setString(parameterIndex++, image);
		}
		stmt.setInt(parameterIndex, id);
		if (stmt.executeUpdate() < 1) {
			conn.close();
			throw new NotFoundException();
		} else {
			conn.close();
		}
	}

	public static void setQuantity(int id, int qty) throws SQLException, NotFoundException {
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery("SELECT qty FROM product WHERE id=" + id);
		if (rs.next()) {
			// check if the product have enough quantity
			if (rs.getInt("qty") >= qty) {
				conn.createStatement().execute("UPDATE product SET qty=`qty`-" + qty + " WHERE id = " + id);
				conn.close();
			} else {
				conn.close();
				throw new WebApplicationException(422);
			}
		} else {
			conn.close();
			throw new NotFoundException();
		}

	}

	public static void deleteProduct(int id) throws SQLException {
		Connection conn = DriverManager.getConnection(url);
		if (conn.createStatement().executeUpdate("DELETE FROM product WHERE id =" + id) < 1) {
			conn.close();
			throw new NotFoundException();
		}
		conn.close();
	}
}
