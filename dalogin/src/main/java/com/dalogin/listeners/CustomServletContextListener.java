package com.dalogin.listeners;
/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com
 * @Year: 2015
 */

import com.dalogin.DBConnectionManager;
import com.dalogin.utils.PropertyUtils;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multimaps;
import com.google.common.collect.TreeMultimap;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.apache.log4j.Logger;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class CustomServletContextListener implements ServletContextListener {
    public static String gmail_password = null;
    public static String gmail_username = null;
    public static String gmail_smtp = null;
    /**
     *
     */
    private static Logger log = Logger.getLogger(Logger.class.getName());
    /**
     *
     */
    private volatile static ConcurrentHashMap<String, Object> activeUsers;
    /**
     *
     */
    private static volatile Multimap<String, String> sessions;
    /**
     *
     */
    private static volatile HashMap<String, String> attributes;
    /**
     *
     */
    private static volatile HashMap<String, String> urls;

    /**
     *
     */
    public void contextInitialized(ServletContextEvent event) {
        ServletContext context = event.getServletContext();
        try {
            ClassLoader cl = this.getClass().getClassLoader();
            InputStream is = cl.getResourceAsStream("properties.properties");
            DataInputStream in = new DataInputStream(is);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            PropertyUtils.loadPropertyFile("properties.properties", br);
            gmail_password = PropertyUtils.getProperty("gmail_password");
            gmail_username = PropertyUtils.getProperty("gmail_username");
            gmail_smtp = PropertyUtils.getProperty("gmail_smtp");
            in.close();
            br.close();
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        /*
         * dB parameters loaded from web.xml
         */
        final String url = context.getInitParameter("DBURL");
        final String u = context.getInitParameter("DBUSER");
        final String p = context.getInitParameter("DBPWD");
        /*
         * timeOut parameter for session creation (& to prevent playback attacks)
         */
        final String time = context.getInitParameter("TIME");
        context.setAttribute("time", time);
        //create database connection from init parameters and set it to context
        DBConnectionManager dbManager = new DBConnectionManager(url, u, p);
        context.setAttribute("DBManager", dbManager);
        log.info("Database connection initialized for Application.");
        //
        // instanciate a map to store references to all the active
        // sessions and bind it to context scope.
        //
        activeUsers = new ConcurrentHashMap<String, Object>();
        context.setAttribute("activeUsers", activeUsers);
        attributes = new HashMap<String, String>();
        context.setAttribute("attributes", attributes);
        sessions = Multimaps.synchronizedSortedSetMultimap(TreeMultimap.create());
        context.setAttribute("sessions", sessions);
        //PBI: resolve dependencies for WildFly, smoothly
        //WS SOAP taken out due to dependency conflict on WildFly.
        //put it here
    }

    /**
     * Needed for the ServletContextListener interface.
     */
    public void contextDestroyed(ServletContextEvent event) {
        // To overcome the problem with losing the session references
        // during server restarts, put code here to serialize the
        // activeUsers HashMap.  Then put code in the contextInitialized
        // method that reads and reloads it if it exists...
        ServletContext context = event.getServletContext();
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            dbManager.closeConnection();
        } catch (SQLException e) {
            log.error(e.getLocalizedMessage());
        }
        log.info("Database connection closed for Application.");
    }
}
