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
    		
    	HashMap<String, String> error = new HashMap<>();

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Get JSESSION url parameter. Later it needs to be sent as header
        sessionId = request.getParameter("JSESSIONID");		        
        log.info("SessionId from request parameter: " + sessionId);
       
        // Return current session
		session = request.getSession();		
		cookies = request.getCookies();
		
    	if (cookies == null || !request.isRequestedSessionIdValid() ) {
        	
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);
						
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			error.put("acticeUsers", "failed"); 
			error.put("Success", "false");
			error.put("ErrorMsg:", "no valid session");
			json.put("Error Details", error); 
			
			PrintWriter out = response.getWriter(); 
			out.print(json.toString());
			out.flush();
						        	
        } else {
		
		ServletContext context = request.getServletContext();
        
        // check if the original response cookie for the same client is present
		if (cookies != null) {
		 for (Cookie cookie : cookies) {
			 
			   if (cookie.getName().equalsIgnoreCase("XSRF-TOKEN")) {
			   
				   if (!session.getAttribute("XSRF-TOKEN").toString().equals(cookie.getValue())) {
					   
						throw new ServletException("There is no valid XSRF-TOKEN");

				   }
			   
			   }
		  }
		} else {
			throw new ServletException("There is no valid XSRF-TOKEN");
		}

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
}
