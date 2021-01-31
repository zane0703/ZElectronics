package sg.com.zElectronics;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.net.URLEncoder;

import sg.com.zElectronics.model.utilityBean.*;
import sg.com.zElectronics.model.valueBean.Category;
public class Listener implements ServletContextListener{
@Override
public void contextInitialized(ServletContextEvent sce) {
ServletContext context= sce.getServletContext();
		try {
			//load MySQL JDBC driver as it only need to load once
		Class.forName("com.mysql.cj.jdbc.Driver");
		Properties sqlConfig = new Properties();
		//get sql config to connect to mysql 
		sqlConfig.load(context.getResourceAsStream("/WEB-INF/sql.properties"));
		//create the URL to connect to the mysql server
		String sqlUrl = new StringBuilder("jdbc:mysql://")
		.append(sqlConfig.getProperty("host"))
		.append('/')
		.append(sqlConfig.getProperty("database"))
		.append("?serverTimezone=UTC&user=")
		.append(URLEncoder.encode(sqlConfig.getProperty("user"),"UTF-8"))//using URLEncoder just in case the user & PW have special characters  
		.append("&password=")
		.append(URLEncoder.encode(sqlConfig.getProperty("password"),"UTF-8"))
		.toString();
		//sead MySQL connection URL to utility bean 
		CartDb.setConfig(sqlUrl);
		CategoryDb.setConfig(sqlUrl);
		OrderDb.setConfig(sqlUrl);
		ProductDb.setConfig(sqlUrl);
		RoleDb.setConfig(sqlUrl);
		UserDb.setConfig(sqlUrl);
		Properties fileConfig = new Properties();
		// get file config
		fileConfig.load(context.getResourceAsStream("/WEB-INF/file.properties"));
		//store config to context attribute so that it can get it form jsp and servelet
		context.setAttribute("fileConfig", fileConfig);
		// get Category as Category table going use often but not often change
		ArrayList<Category> categoriesList= CategoryDb.getCategor();
		// convert from array list to normal array and store it to context attribute so that it can get it form jsp and servelet
		context.setAttribute("category", categoriesList.toArray(new Category[categoriesList.size()]));
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
}
}
