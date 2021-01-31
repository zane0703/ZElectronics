package sg.com.zElectronics.model.utilityBean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.WebApplicationException;

import sg.com.zElectronics.model.valueBean.Order;

public class OrderDb {
    private static String url;
  //get SQL config from the Listener class
 public static void setConfig(String sqlUrl){
		url= sqlUrl;
	}
 public static ArrayList<Order> getOrder() throws SQLException{
	 Connection conn = DriverManager.getConnection(url);
     ResultSet rs = conn.createStatement().executeQuery("SELECT  o.id, title,o.qty,status,FkProductId,FkBuyerId,name,o.createdAt FROM `order` o INNER JOIN product p ON FkProductId=p.id INNER JOIN users u ON u.id =FkBuyerId ;");
     ArrayList<Order>orders = new ArrayList<Order>();
     while(rs.next()) {
    	 Order order = new Order();
    	 order.setId(rs.getInt("id"));
    	 order.setFkProductId(rs.getInt("FkProductId"));
    	 order.setFkBuyerId(rs.getInt("FkBuyerId"));
    	 order.setProductTitle(rs.getString("title"));
    	 order.setQuantity(rs.getInt("qty"));
    	 order.setStatus(rs.getInt("status"));
    	 order.setBuyerName(rs.getNString("name"));
    	 order.setCreatedAt(rs.getDate("createdAt"));
    	 orders.add(order);
         }
     conn.close();
     return orders;
 }
 public static Order getOrder(int id) throws SQLException {
	 Connection conn = DriverManager.getConnection(url);
	 ResultSet rs = conn.createStatement().executeQuery("SELECT billCountry,shipCountry, o.id,email, title,o.qty,status,FkProductId,FkBuyerId,billAddr,shipAddr,billPostal,shipPostal ,contact,u.name ,o.createdAt FROM `order` o INNER JOIN product p ON FkProductId=p.id INNER JOIN users u ON u.id =FkBuyerId WHERE  o.id="+id+";");
	 if(rs.next()) {
		 Order order = new Order();
    	 order.setId(rs.getInt("id"));
    	 order.setFkProductId(rs.getInt("FkProductId"));
    	 order.setFkBuyerId(rs.getInt("FkBuyerId"));
    	 order.setProductTitle(rs.getString("title"));
    	 order.setQuantity(rs.getInt("qty"));
    	 order.setStatus(rs.getInt("status"));
    	 order.setBuyerContact(rs.getString("contact"));
    	 order.setBillAddress(rs.getString("billAddr"));
    	 order.setShipAddress(rs.getString("shipAddr"));
    	 order.setBillPostal(rs.getInt("billPostal"));
    	 order.setShipPostal(rs.getInt("shipPostal"));
    	 order.setBuyerName(rs.getString("name"));
    	 order.setBuyerEmail(rs.getString("email"));
    	 order.setCreatedAt(rs.getDate("createdAt"));
    	 order.setShipCountry(rs.getString("shipCountry"));
    	 order.setBillCountry(rs.getString("billCountry"));
    	 conn.close();
    	 return order;
	 }else {
		 conn.close();
		throw new NotFoundException();
	}
 }
 
 public static void setStatus(int id , int status) throws SQLException {
	 Connection conn = DriverManager.getConnection(url);
		if( conn.createStatement().executeUpdate("UPDATE `order` SET status="+status+" WHERE id ="+id)<1) {
			conn.close();
			throw new NotFoundException();
		}
		conn.close();
 }
 public static Object[] getOrderByArgs(int productId,int buyerId,int sort,int day,int dayTo,int week,int month,int year,int status,String country,int limit,int page) throws SQLException{
	 Connection conn = DriverManager.getConnection(url);
	 /* get the amount of order so i can calculate the amount of page*/
	 StringBuilder  sql = new StringBuilder("SELECT  COUNT(*) AS amount FROM `order` o  WHERE true"); //new StringBuilder("SELECT  o.id, title,o.qty,status,FkProductId,FkBuyerId ,u.name ,contact,shipAddr,shipPostal,o.createdAt FROM `order` o INNER JOIN product p ON FkProductId=p.id INNER JOIN users u ON u.id =FkBuyerId WHERE true");
	 boolean hasCountry = country!=null &&! country.trim().equals("");
	 if(productId!=0) {
		 sql.append(" && FkProductId=");
		 sql.append(productId);
	 }
	 if(buyerId!=0) {
		 sql.append(" && FkBuyerId=");
		 sql.append(buyerId);
	 }
	 if(day!=0) {
		 sql.append(" && DAY(o.createdAt) BETWEEN ");
		 sql.append(day);
		 sql.append(" AND ");
		 sql.append(dayTo>=day?dayTo:day);
	 }
	 if(week!=0) {
		 sql.append(" && DAYOFWEEK(o.createdAt)=");
		 sql.append(week);
	 }
	 if(month!=0) {
		 sql.append(" && MONTH(o.createdAt)=");
		 sql.append(month);
	 }
	 if(year!=0) {
		 sql.append(" && YEAR(o.createdAt)=");
		 sql.append(year);
	 }
	 if(status!=0) {
		 sql.append(" && status=");
		 sql.append(status-2);
	 }
	 if(hasCountry) {
		 sql.append(" && shipCountry=?");
	 }
	 PreparedStatement stmt = conn.prepareStatement(sql.toString());
	 if(hasCountry) {
		 stmt.setString(1, country);
	 }
	 ResultSet rs = stmt.executeQuery();
	 rs.next();
	 Integer amount=new Integer(rs.getInt("amount"));
	 /*get order*/
	 sql.replace(7, 42,"o.id, title,o.qty,status,FkProductId,FkBuyerId ,u.name ,contact,shipAddr,shipPostal,o.createdAt,billCountry,shipCountry FROM `order` o INNER JOIN product p ON FkProductId=p.id INNER JOIN users u ON u.id =FkBuyerId" );
	 switch (sort) {
	case 0:
		sql.append(" ORDER BY o.createdAt DESC");
		break;
	case 1:
		sql.append(" ORDER BY o.createdAt ASC");
	break;
	case 3 :
		sql.append(" ORDER BY shipPostal ASC");
	break;
	case 4:
		sql.append(" ORDER BY shipPostal DESC");
	}
	 if(limit!=0) {
		 sql.append(" LIMIT ");
		 sql.append(((page-1)*limit));
		 sql.append(',');
		 sql.append(limit);
		}
	 stmt = conn.prepareStatement(sql.toString());
	 if(hasCountry) {
		 stmt.setString(1, country);
	 }
	 rs = stmt.executeQuery();
     ArrayList<Order>orders = new ArrayList<Order>();
     while(rs.next()) {
    	 Order order = new Order();
    	 order.setId(rs.getInt("id"));
    	 order.setFkProductId(rs.getInt("FkProductId"));
    	 order.setFkBuyerId(rs.getInt("FkBuyerId"));
    	 order.setProductTitle(rs.getString("title"));
    	 order.setQuantity(rs.getInt("qty"));
    	 order.setStatus(rs.getInt("status"));
    	 order.setShipAddress(rs.getString("shipAddr"));
    	 order.setShipPostal(rs.getInt("shipPostal"));
    	 order.setBuyerName(rs.getNString("name"));
    	 order.setShipCountry(rs.getString("shipCountry"));
    	 order.setBillCountry(rs.getString("billCountry"));
    	 order.setCreatedAt(rs.getDate("createdAt"));
    	 orders.add(order);
         }
     conn.close();
     return new Object[] {amount,orders};
 }
 public static ArrayList<Order> getOrderByOfferorId(int userId) throws SQLException {
	 ArrayList<Order> orders = new ArrayList<Order>();
	 Connection conn = DriverManager.getConnection(url);
     ResultSet rs = conn.createStatement().executeQuery("SELECT o.id as id, title,o.qty as qty,retailPr,image,p.qty as pQty,status,FkProductId,o.createdAt FROM `order` o INNER JOIN product p ON FkProductId=p.id WHERE FkBuyerId="+userId);
     while(rs.next()) {
    	 Order order = new Order();
    	 order.setId(rs.getInt("id"));
    	 order.setFkProductId(rs.getInt("FkProductId"));
    	 order.setFkBuyerId(userId);
    	 order.setProductTitle(rs.getString("title"));
    	 order.setQuantity(rs.getInt("qty"));
    	 order.setStatus(rs.getInt("status"));
    	 order.setProductQty(rs.getInt("pQty"));
    	 order.setCreatedAt(rs.getDate("createdAt"));
    	 orders.add(order);
     }
     conn.close();
     return orders;
 }

 public static void addOrder(Order order) throws SQLException {
	 Connection conn = DriverManager.getConnection(url);
	 PreparedStatement stmt =  conn.prepareStatement("INSERT INTO `order`(FkProductId,FkBuyerId,qty,status,billAddr,shipAddr,billPostal,shipPostal ,billCountry,shipCountry) VALUES(?,?,?,?,?,?,?,?,?,?)");
	 stmt.setInt(1, order.getFkProductId());
	 stmt.setInt(2, order.getFkBuyerId());
	 stmt.setInt(3, order.getQuantity());
	 stmt.setInt(4, order.getStatus());
	 stmt.setString(5, order.getBillAddress());
	 stmt.setString(6, order.getShipAddress());
	 stmt.setInt(7, order.getBillPostal());
	 stmt.setInt(8, order.getShipPostal());
	 stmt.setString(9, order.getBillCountry());
	 stmt.setString(10,order.getShipAddress());
	 if(stmt.executeUpdate()<1){
		 conn.close();
		 throw new SQLException();
	 }
	 conn.close();
 }
 public static void addOrder(Order[] orders) throws SQLException {
	 Connection conn = DriverManager.getConnection(url);
	 StringBuilder sql = new StringBuilder("INSERT INTO `order`(FkProductId,FkBuyerId,qty,status,billAddr,shipAddr,billPostal,shipPostal,billCountry,shipCountry) VALUES (?,?,?,?,?,?,?,?,?,?)");
	 int rows = orders.length;
	 if(rows==0) {
		 throw new WebApplicationException(400);
	 }
	 for(int i =  1;i<rows;i++) {
		sql.append(",(?,?,?,?,?,?,?,?,?,?)"); 
	 }
	 sql.append(';');
	 PreparedStatement stmt = conn.prepareStatement(sql.toString());
	 int parameterIndex = 1;
	 for(Order order: orders) {
		 stmt.setInt(parameterIndex++, order.getFkProductId());
		 stmt.setInt(parameterIndex++, order.getFkBuyerId());
		 stmt.setInt(parameterIndex++, order.getQuantity());
		 stmt.setInt(parameterIndex++, order.getStatus());
		 stmt.setString(parameterIndex++, order.getBillAddress());
		 stmt.setString(parameterIndex++, order.getShipAddress());
		 stmt.setInt(parameterIndex++, order.getBillPostal());
		 stmt.setInt(parameterIndex++, order.getShipPostal());
		 stmt.setString(parameterIndex++, order.getBillCountry());
		 stmt.setString(parameterIndex++, order.getShipCountry());
	 }
	 stmt.execute();
	 conn.close();
	 
	 
 }
 
 public static void deleteOrder(int id) throws SQLException,NotAuthorizedException {
	 Connection conn = DriverManager.getConnection(url);
	 if(conn.createStatement().executeUpdate("DELETE FROM `order` WHERE id="+id+";")<1) {
		 conn.close();
		 throw new NotFoundException();
	 }
	 conn.close();
	 
 }
}
