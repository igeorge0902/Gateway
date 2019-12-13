package com.dalogin;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;

public class CheckOut extends HttpServlet implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 2152364900906190486L;
	private static Logger log = Logger.getLogger(Logger.class.getName());
	
	protected volatile static HttpSession session = null;
    private static volatile Cookie[] cookies;
    private static volatile List<String> token2;
    private static volatile String uuid;
	protected volatile static String sessionId = null;

	public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    		
    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Return current session
		session = request.getSession();		
		cookies = request.getCookies();
		       
		 // Get JSESSION url parameter. By now it is just a logging..
		 sessionId = request.getParameter("JSESSIONID");	
		 if(sessionId == null) {
		 	sessionId = session.getId();        	
		 }
		
		ServletContext context = request.getServletContext();
		String webApi2Context = context.getInitParameter("webApi2Context");
		String webApi2ContextUrl = context.getInitParameter("webApi2ContextUrl");
		
		ServletContext otherContext = getServletContext().getContext(webApi2Context);

		RequestDispatcher rd = otherContext.getRequestDispatcher(webApi2ContextUrl + "book/payment/fullcheckout");
		token2 = new ArrayList<String>();

		try {
			
			token2 = SQLAccess.token2((String)session.getAttribute("deviceId"), context);
			uuid = SQLAccess.uuid((String)session.getAttribute("user"), context);
			
			} catch (Exception e) {
			
				throw new ServletException(e.getCause().toString());

		}
		
		//TODO: check if account is activated, if needed
		request.setAttribute("token2", token2.get(0));
		request.setAttribute("TIME_", token2.get(1));
		request.setAttribute("uuid", uuid);

		rd.forward(request, response);
		
		}
    
}
