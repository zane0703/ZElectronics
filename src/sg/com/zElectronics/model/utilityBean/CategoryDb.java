package sg.com.zElectronics.model.utilityBean;


import javax.ws.rs.NotFoundException;

import sg.com.zElectronics.model.valueBean.Category;

import java.util.ArrayList;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class CategoryDb {
    private static String url;
  //get SQL config from the Listener class
    public static void setConfig(String sqlUrl){
		url=sqlUrl;
	}
    public static ArrayList<Category> getCategor() throws SQLException {
	ArrayList<Category> categorys =  new ArrayList<Category>();
	Connection conn = DriverManager.getConnection(url);
	    ResultSet rs = conn.createStatement().executeQuery("SELECT id,name FROM category ORDER BY id;");
	    while(rs.next()) {
		categorys.add(new Category(rs.getInt("id"), rs.getString("name")));
	    }
	    conn.close();
	    return categorys;

	
    }
    public static Category getCategor(int id)throws SQLException, NotFoundException { 
    	Connection conn = DriverManager.getConnection(url);
    	ResultSet rs = conn.createStatement().executeQuery("SELECT id,name FROM category WHERE id="+id);
    	if(rs.next()) {
    		Category category = new Category(rs.getInt("id"), rs.getString("name"));
    		conn.close();
    		return category;
    	}else {
    		conn.close();
    		throw new NotFoundException();
    	}
    }
    public static int addCategor(String name) throws SQLException{
    	Connection conn = DriverManager.getConnection(url);
    	PreparedStatement stmt = conn.prepareStatement("INSERT INTO category(name) VALUES(?);",PreparedStatement.RETURN_GENERATED_KEYS);
    	stmt.setString(1, name);
    	if(stmt.executeUpdate()<1) {
    		conn.close();
    		throw new SQLException();
    	}else {
    		ResultSet rs= stmt.getGeneratedKeys();
    		rs.next();
    		int id = rs.getInt(1);
    		conn.close();
    		return id;
    	}
    	
    }
    public static void deleteCategor(int id)throws SQLException{
    	Connection conn = DriverManager.getConnection(url);
    	if(conn.createStatement().executeUpdate("DELETE FROM category WHERE id="+id)<1) {
    		conn.close();
    		throw new NotFoundException();
    	}
    	conn.close();
    }
}
