package sg.com.zElectronics.model.utilityBean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.sql.Types;
import javax.ws.rs.NotFoundException;

import sg.com.zElectronics.model.valueBean.User;
public class UserDb {
	private static String url;
	//get SQL config from the Listener class
	  public static void setConfig(String sqlUrl){
			url = sqlUrl;
		}
	 public static User getUserByName(String name) throws SQLException,NotFoundException{
		  User user = new User();			
		  Connection conn = DriverManager.getConnection(url);
		  PreparedStatement stmt = conn.prepareStatement("SELECT id,email,name,password,createdAt,FkRoleId ,country FROM users WHERE email=?");
		 stmt.setString(1, name);
		  ResultSet rs = stmt.executeQuery();
		 if(rs.next()) {
			 user.setId(rs.getInt("id"));
			 user.setName(rs.getString("name"));
			 user.setEmail(rs.getString("email"));
			 user.setPassword(rs.getString("Password"));
			 user.setRoleID(rs.getInt("FkRoleId"));
			 user.setCountry(rs.getString("country"));
			 user.setCreatedAt(rs.getDate("createdAt"));
			 conn.close();
			 return user;
		 }else {
			 conn.close();
			throw new NotFoundException("user not found");
		}
	  }
	 public static Object[] getUser(int role,int sort,String country, String search,int limit,int page) throws SQLException{
		 Connection conn = DriverManager.getConnection(
					url);
		 /* get the amount of user so i can calculate the amount of page*/
		 StringBuilder sql = new StringBuilder("SELECT  COUNT(*) AS amount FROM users  WHERE true "); // new StringBuilder("SELECT  u.id,name,email,image,password,contact,u.createdAt,FkRoleId,spent,COUNT(o.id) as orderAmount FROM users u LEFT JOIN `order` o ON u.id=FkBuyerId  ");
		 if(role!=0) {
			 sql.append(" && FkRoleId=");
			 sql.append(role);
		 }
		 boolean hasSeach=search!=null&&!search.trim().equals("");
		 boolean hasCountry = country!=null&&!country.trim().equals("");
		 if(hasSeach) {
			 sql.append(" &&( name like CONCAT('%', ? ,'%') || email like CONCAT('%', ? ,'%'))");
		 }
		 if(hasCountry) {
			 sql.append(" && country=? ");
		 }
		 PreparedStatement stmt = conn.prepareStatement(sql.toString());
		 int parameterIndex = 1;
		 if(hasSeach) {
			 stmt.setString(parameterIndex++, search);
			 stmt.setString(parameterIndex++, search);
		 }
		 
		 if(hasCountry) {
			 stmt.setString(parameterIndex, country);
		 }
		 ResultSet rs = stmt.executeQuery();
		 rs.next();
		 Integer  userAmount = new Integer(rs.getInt("amount"));
		 /*get users*/
		 sql.replace(7, 39,"u.id,name,email,image,password,contact,u.createdAt,FkRoleId,spent,COUNT(o.id) AS orderAmount,address,country,postalCode FROM users u LEFT JOIN `order` o ON u.id=FkBuyerId ");
		 sql.append(" GROUP BY u.id ");
		 
		 switch (sort) {
		case 1:
			sql.append("ORDER BY u.id DESC");
			break;
		case 2:
			sql.append("ORDER BY orderAmount DESC");
			break;
		case 3:
			sql.append("ORDER BY orderAmount ASC");
			break;
		case 4:
			sql.append("ORDER BY spent DESC");
			break;
		case 5:
			sql.append("ORDER BY spent ASC");
			break;
		case 6:
			sql.append("ORDER BY postalCode ASC");
			break;
		case 7:
			sql.append("ORDER BY postalCode DESC");
			break;
		}
		 if(limit!=0) {
			 sql.append(" LIMIT ");
			 sql.append(((page-1)*limit));
			 sql.append(',');
			 sql.append(limit);
		}
		 sql.append(';');
		 stmt = conn.prepareStatement(sql.toString());
		 parameterIndex =1; 
		 if(hasSeach) {
			 stmt.setString(parameterIndex++, search);
			 stmt.setString(parameterIndex++, search);
		 }
		 if(hasCountry) {
			 stmt.setString(parameterIndex, country);
		 }
		 rs = stmt.executeQuery();
		 ArrayList<User> users = new ArrayList<User>();
		 while(rs.next()) {
			 User user = new User();
			 user.setId(rs.getInt("id"));
			 user.setName(rs.getString("name"));
			 user.setEmail(rs.getString("email"));
			 user.setRoleID(rs.getInt("FkRoleId"));
			 user.setContact(rs.getString("contact"));
			 user.setOrderAmount(rs.getInt("orderAmount"));
			 user.setImage(rs.getString("image"));
			 user.setPassword(rs.getString("password"));
			 user.setCreatedAt(rs.getDate("createdAt"));
			 user.setSpent(rs.getDouble("spent"));
			 user.setAddress(rs.getString("address"));
			 user.setCountry(rs.getString("country"));
			 user.setPostalCode(rs.getInt("postalCode"));
			 users.add(user);
		 }
		 conn.close();
		 return new Object[] {userAmount,users};
	 }
	 public static void addSpent(int id,double spent) throws SQLException {
		 Connection conn = DriverManager.getConnection(
					url);
		 int row= conn.createStatement().executeUpdate("UPDATE users SET spent =spent+"+spent+" WHERE id="+id+";");
		 conn.close();
		 if(row<1) {
			 throw new NotFoundException();
		 }
	 }
	 public static User getUser(int id) throws SQLException,NotFoundException {
		 User user = new User();			
		 Connection conn = DriverManager.getConnection(
					url);
		  PreparedStatement stmt = conn.prepareStatement("SELECT  id,name,email,password,image,contact,createdAt,FkRoleId,spent,address,country,postalCode FROM users  WHERE id=?");
		 stmt.setInt(1, id);
		 ResultSet rs = stmt.executeQuery();
		 if(rs.next()) {
			 user.setId(rs.getInt("id"));
			 user.setName(rs.getString("name"));
			 user.setEmail(rs.getString("email"));
			 user.setPassword(rs.getString("Password"));
			 user.setRoleID(rs.getInt("FkRoleId"));
			 user.setImage(rs.getString("image"));
			 user.setContact(rs.getString("contact"));
			 user.setCreatedAt(rs.getDate("createdAt"));
			 user.setSpent(rs.getDouble("spent"));
			 user.setAddress(rs.getString("address"));
			 user.setCountry(rs.getString("country"));
			 user.setPostalCode(rs.getInt("postalCode"));
			 conn.close();
			 return user;
		 }else {
			 conn.close();
			throw new NotFoundException("user not found");
		}
	 }
	 public static void verifyUser(int id) throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		 if(conn.createStatement().executeUpdate("UPDATE users SET verify=0 WHERE id="+id)<1) {
			 conn.close();
			 throw new NotFoundException();
		 }
		 conn.close();
	 }
	 public static String addUser(User user,boolean isUpload,String contextPath)throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		    PreparedStatement stmt = conn.prepareStatement(
				    "INSERT INTO users(name,email,Password,FkRoleId,image,contact,address,country,postalCode) VALUES(?,?,?,?,?,?,?,?,?) ;",
				    PreparedStatement.RETURN_GENERATED_KEYS);
		    stmt.setString(1, user.getName());
		    stmt.setString(2, user.getEmail());
		    stmt.setString(3, user.getPassword());
		    stmt.setInt(4,user.getRoleID());
			stmt.setString(5, user.getImage());
			stmt.setString(6, user.getContact());
			stmt.setString(7, user.getAddress());
			stmt.setString(8, user.getCountry());
			stmt.setInt(9, user.getPostalCode());
		    if (stmt.executeUpdate() == 0) {
				throw new SQLException();
		    } else {
	    		ResultSet rs = stmt.getGeneratedKeys();
			    rs.next();
			    String row = rs.getString(1);
		    	if(isUpload) {
				    conn.createStatement().execute("UPDATE users SET image=\"" + contextPath
				    + "/image/profile/" + row + "."+user.getImage()+"\" WHERE id=" + row);
				    conn.close();
				    return row;
		    	}else {
		    		conn.close();
		    		return row;
				}
		    }
	 }
	 public static void updateUser(int id, User user) throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		 PreparedStatement stmt= conn.prepareStatement("UPDATE users SET name=COALESCE(?,name) ,email=COALESCE(?,email), password=COALESCE(?,password),image=COALESCE(?,image), FkRoleId=COALESCE(?,FkRoleId), contact=COALESCE(?,contact),address=COALESCE(?,address),country=COALESCE(?,country),postalCode=COALESCE(?,postalCode) WHERE id=? ;");
		 String tempStr;
		 int tempInt;
		 if((tempStr=user.getName())!=null) {
			 stmt.setString(1, tempStr);
		 }else {
			 stmt.setNull(1,Types.VARCHAR );
		 }
		 if((tempStr=user.getEmail())!=null) {
			 stmt.setString(2, tempStr);
		 }else {
			 stmt.setNull(2,Types.VARCHAR );
		 }
		 if((tempStr=user.getPassword())!=null){
			 stmt.setString(3, tempStr);
		 }else {
			 stmt.setNull(3, Types.CHAR);
		 }
		 
		 if((tempStr=user.getImage())!=null&&!tempStr.trim().equals("")) {
			 stmt.setString(4, tempStr);
		 }else {
			 stmt.setNull(4, Types.VARCHAR);
		 }
		 if((tempInt=user.getRoleID())!=0) {
			 stmt.setInt(5, tempInt);
		 }else {
			 stmt.setNull(5, Types.INTEGER);
		 }
		 if((tempStr=user.getContact())!=null&&!tempStr.trim().equals("")) {
			 stmt.setString(6, tempStr);
		 }else {
			 stmt.setNull(6, Types.VARCHAR);
		 }
		 if((tempStr=user.getAddress())!=null&&!tempStr.trim().equals("")) {
			 stmt.setString(7, tempStr);
		 }else {
			 stmt.setNull(7, Types.VARBINARY);
		 }
		 if((tempStr=user.getCountry())!=null&&!tempStr.trim().equals("")) {
			 stmt.setString(8, tempStr);
		 }else {
			 stmt.setNull(8, Types.CHAR);
		 }
		 if((tempInt=user.getPostalCode())!=0) {
			 stmt.setInt(9, tempInt);
		 }else {
			 stmt.setNull(9, Types.INTEGER);
		 }
		 stmt.setInt(10, id);
		 stmt.execute();
		 conn.close();
	 }
	 public static void updateEmail(int id, String email) throws SQLException {
		 Connection conn = DriverManager.getConnection(url);
		 PreparedStatement stmt = conn.prepareStatement("UPDATE users SET email=? WHERE id=?");
		 stmt.setString(1, email);
		 stmt.setInt(2, id);
		 if(stmt.executeUpdate()<1) {
			 conn.close();
			 throw new NotFoundException();
		 }
		 conn.close();
	 }
	 public static void deleteUser(int id) throws SQLException{
			Connection conn = DriverManager.getConnection(url);
			 if(conn.createStatement().executeUpdate("DELETE FROM users WHERE id ="+id)<1) {
			 conn.close();
			 throw new NotFoundException();
		 }
		 conn.close();
	 }
}
