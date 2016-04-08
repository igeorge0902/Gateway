package com.dalogin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.apache.log4j.Logger;


public class DBConnectionManager {

	private static Logger log = Logger.getLogger(Logger.class.getName());

	private String dbURL;
	private String user;
	private String password;
	private volatile Connection con;
	
	public DBConnectionManager(String url, String u, String p){
		
		this.dbURL=url;
		this.user=u;
		this.password=p;
		//create db connection now
		
	}
	
	public Connection getConnection() throws SQLException, ClassNotFoundException{
		
		//if (con == null) {
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection(dbURL, user, password);	
		con.setCatalog("login");
		log.info("dB Connection created, catalog set to \"login\"");

		//}
		return this.con;
	}
	
	public void closeConnection() throws SQLException{
		con.close();
	}
}