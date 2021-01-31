package sg.com.zElectronics.model.utilityBean;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.ws.rs.NotFoundException;


import sg.com.zElectronics.model.valueBean.Cart;
public class CartDb {
	private static String url;
	//get SQL config from the Listener class
	public static void setConfig(String sqlUrl){
		url = sqlUrl;
	}
	public static int getCartAmount(int userId) throws SQLException {
	     Connection conn = DriverManager.getConnection(url);
	     ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) as count FROM cart WHERE FkBuyerId ="+userId+";");
	     if(rs.next()) {
		 int amount =  rs.getInt("count");
		 conn.close();
		 return amount;
	     }else {
	    conn.close();
		 return 0;
	     }
	 }
	public static void setQuantity (int id ,int qty) throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		if( conn.createStatement().executeUpdate("UPDATE `cart` SET qty="+qty+" WHERE id ="+id)<1) {
			conn.close();
			throw new NotFoundException();
		} 
		conn.close();
	 }
	public static Cart getCart(int id) throws SQLException {
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs = conn.createStatement().executeQuery("SELECT qty,FkProductId,FkBuyerId  FROM cart WHERE  id="+id+";");
		if(rs.next()) {
			Cart cart = new Cart();
			cart.setId(id);
			cart.setQuantity(rs.getInt("qty"));
			cart.setFkBuyerId(rs.getInt("FkBuyerId"));
			cart.setFkProductId(rs.getInt("FkProductId"));
			conn.close();
			return cart;
		}else {
			conn.close();
			throw new NotFoundException();
		}
	}
	public static ArrayList<Cart> getcartByBuyer(int userId)  throws SQLException{
		Connection conn = DriverManager.getConnection(url);
		ArrayList<Cart> carts =new ArrayList<Cart>();
		ResultSet rs = conn.createStatement().executeQuery("SELECT c.id as id, title,c.qty as qty,retailPr,FkBuyerId,image,p.qty as pQty,FkProductId FROM cart c INNER JOIN product p ON FkProductId=p.id WHERE  FkBuyerId="+userId);
		while(rs.next()) {
			carts.add(new Cart(rs.getInt("id"),rs.getInt("qty"),rs.getInt("FkBuyerId"),rs.getInt("FkProductId"), rs.getString("title"),rs.getString("image"),rs.getInt("pQty"),rs.getDouble("retailPr")));
		}
		conn.close();
		return carts;
	}
	 public static void addCart(Cart cart) throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		 PreparedStatement stmt =  conn.prepareStatement("INSERT INTO cart (FkProductId,FkBuyerId,qty) VALUES(?,?,?)");
		 stmt.setInt(1, cart.getFkProductId());
		 stmt.setInt(2, cart.getFkBuyerId());
		 stmt.setInt(3, cart.getQuantity());
		 if(stmt.executeUpdate()<1){
			 conn.close();
			 throw new SQLException();
		 }
		 conn.close();
	 }
	public static int[] deleteCart(int id,int userId) throws SQLException{
		 Connection conn = DriverManager.getConnection(url);
		 ResultSet rs =  conn.createStatement().executeQuery("SELECT qty,FkProductId FROM  cart WHERE id="+id+" && FkBuyerId="+userId);
		 if(rs.next()) {
			 int[] product = new int[2];
			 product[0]= rs.getInt(1);
			 product[1] =rs.getInt(2);
			 conn.createStatement().execute("DELETE FROM cart WHERE id="+id+" && FkBuyerId="+userId);
			 conn.close();
			 return product;
		 }else {
			 conn.close();
			 throw new NotFoundException();
		 }
	}
	public static ArrayList<Cart> findAndDeleteByBuyer(int userId) throws SQLException{
		Connection conn = DriverManager.getConnection(url);
		ResultSet rs =  conn.createStatement().executeQuery("SELECT c.qty,FkProductId,p.retailPr FROM  cart c INNER JOIN product p ON p.id = FkProductId WHERE FkBuyerId="+userId);
		 ArrayList<Cart> carts = new  ArrayList<Cart>();
		 while(rs.next()) {
			 Cart cart= new Cart();
			 cart.setQuantity(rs.getInt("qty"));
			 cart.setFkBuyerId(userId);
			 cart.setFkProductId(rs.getInt("FkProductId"));
			 cart.setProductRetailPrice(rs.getDouble("retailPr"));
			 carts.add(cart); 
		 }
		 conn.createStatement().execute("DELETE FROM cart WHERE FkBuyerId="+userId);
		 conn.close();
		 return carts;
	}
	
}
