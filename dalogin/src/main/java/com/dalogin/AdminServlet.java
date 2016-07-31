package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.*;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.json.JSONObject;


//Extend HttpServlet class
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
	private volatile static String user = null;
	private volatile static String token_;
	private volatile static String Response = null;
	private volatile static String deviceId;
	protected volatile static HttpSession session = null;
	protected volatile static String sessionId = null;
	protected volatile static String sessionId_ = null;
	private volatile static String token2;

	
	private static Logger log = Logger.getLogger(Logger.class.getName());
	private static volatile ConcurrentHashMap<String, HttpSession> activeUsers;


    public void init() throws ServletException
    {
        // Do required initialization

    }
    
    public synchronized void doPost(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws ServletException, IOException
    {

    }
    

	private synchronized void performTask(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException {	

			//session = request.getSession();
    		ServletContext context = session.getServletContext();
			//log.info("Session ID check: "+ session.getId());
		
		try {
			
			// Get deviceId from session
			deviceId = (String) session.getAttribute("deviceId");
			
			// Get user from session
			user = (String) session.getAttribute("user");
			
			// Get token1 from dB. token1 will be used to make a user related API call
			token_ = SQLAccess.token(deviceId, context);
			
			// Get voucher activation method
			Response = SQLAccess.isActivated(user, context);

		
		} catch (Exception e) {
			
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			json.put("SQLAccess", "failed"); 
			json.put("Success", "false"); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
			
		}
		
		if (deviceId == null || user == null) {
			
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			json.put("deviceId", "null"); 
			json.put("user", "null"); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();

		}
		
		// else if voucher needs activation
		if(Response == "S") {
			
			try {
				token2 = SQLAccess.token2(deviceId, context);
			
			} catch (Exception e) {

				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				response.setStatus(502);
				
				log.info(e.getMessage());
			}

				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				response.setHeader("Response", "S");
				response.setStatus(300);
				response.addHeader("User", user);
				response.addHeader("X-Token", token2);

				PrintWriter out = response.getWriter(); 
				
				//create Json Object 
				JSONObject json = new JSONObject(); 
				
				// put some value pairs into the JSON object . 				
				json.put("Activation", "false"); 
				json.put("Success", "false");
				
				// finally output the json string 
				out.print(json.toString());
				out.flush();

			}
		
		// Get user entity using API GET method, with user and token as request params
		else if(token_ != null && session != null /*&& request.isRequestedSessionIdValid()*/) {			
			
			String webApiContext = context.getInitParameter("webApiContext");
			String webApiContextUrl = context.getInitParameter("webApiContextUrl");
			
			ServletContext otherContext = getServletContext().getContext(webApiContext);

			/**
			 * the black hole, where the magic happens :) and represents the whole logic of the system:
			 * 
			 * - it only can work one way.
			 * 
			 * It takes token1 to verify user. All user must have a valid token pair. 
			 * Token pair will be overwritten upon logout to prevent malicious usage.
			 */
			RequestDispatcher rd = otherContext.getRequestDispatcher(webApiContextUrl + user.trim().toString()+"/"+token_.trim().toString());

			rd.forward(request, response); 
			}
		else {
			
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			json.put("Success", "false"); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
			
				}

		}
    
    @SuppressWarnings("unchecked")
	public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Get JSESSION url parameter. Later it needs to be sent as header
        sessionId = request.getParameter("JSESSIONID");			
        log.info("SessionId from request parameter: " + sessionId);
       
        // Return current session
		session = request.getSession();		
        //log.info("admin SessionID:" + session.getId().toString());
    	
        // Check session for user attribute
    	if(session.getAttribute("user") == null){
    	
            if (sessionId != null) {
                
                // Get the existing session and creates a new one
            	session = request.getSession(true);
            	
            	// Get ServletContext
                ServletContext context = session.getServletContext();
                
                // Init HashMap that stores session objects
                activeUsers = (ConcurrentHashMap<String, HttpSession>)context.getAttribute("activeUsers");
                
                // Get session with sessionId
                session = activeUsers.get(sessionId);
                //log.info("activeUsers sessionId:" + session.getId().toString());
            
            } else {
            	
    			response.setContentType("application/json"); 
    			response.setCharacterEncoding("utf-8"); 
    			response.setStatus(502);

    			session.invalidate();

    			PrintWriter out = response.getWriter(); 
    			
    			//create Json Object 
    			JSONObject json = new JSONObject(); 
    			
    			// put some value pairs into the JSON object . 				
    			json.put("acticeUsers", "failed"); 
    			json.put("Success", "false"); 
    			
    			// finally output the json string 
    			out.print(json.toString());
    			out.flush();
    			
            }
    	
    	}
    	
    	if (session == null || session.getAttribute("user") == null) {
        	
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

			session.invalidate();
			
			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			json.put("acticeUsers", "failed"); 
			json.put("Success", "false"); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
        	

        } else {
    		
		            performTask(request, response);
    			//	log.info("CurrentUserSessionId: " + sessionId);
        	}
    	
    	}
    
    
    public void destroy()
    {
        // do nothing.
    }
  
   
}