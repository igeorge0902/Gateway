package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.json.JSONObject;


//Extend HttpServlet class
public class AdminServlet extends HttpServlet implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5570497466931245289L;
	
	/**
	 * 
	 */
	private volatile static String user = null;
	
	/**
	 * 
	 */
	private volatile static String token_;
	
	/**
	 * 
	 */
	private volatile static String Response = null;
	
	/**
	 * 
	 */
	private volatile static String deviceId;
	
	/**
	 * 
	 */
	protected volatile static HttpSession session = null;
	
	/**
	 * 
	 */
	protected volatile static String sessionId = null;
	
	/**
	 * 
	 */
	protected volatile static String sessionId_ = null;
	
	/**
	 * 
	 */
	private volatile static List<String> token2;

	/**
	 * 
	 */
	private static Logger log = Logger.getLogger(Logger.class.getName());
	
	/**
	 * 
	 */
	private static volatile ConcurrentHashMap<String, HttpSession> activeUsers;

    /**
     * An array initialized to contain the request cookies.
     */
    private static volatile Cookie[] cookies;
	/**
	 * 
	 */
    public void init() throws ServletException
    {
        // Do required initialization

    }
    
    /**
     * 
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException 
     */
    @SuppressWarnings("unchecked")
	public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	
    	HashMap<String, String> error = new HashMap<>();

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Get JSESSION url parameter. Later it needs to be sent as header
        sessionId = request.getParameter("JSESSIONID");			
        log.info("SessionId from request parameter: " + sessionId);
       
        // Return current session
		session = request.getSession();		
    	
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

                
            } else {
            	
    			response.setContentType("application/json"); 
    			response.setCharacterEncoding("utf-8"); 
    			response.setStatus(502);

    			if (session != null) {
    				session.invalidate();				
    			}
    			
    			// put some value pairs into the JSON object . 				
    			error.put("acticeUsers", "failed"); 
    			error.put("Success", "false"); 
    			
            }
    	
    	}
    	
    	if (session == null || !request.isRequestedSessionIdValid() ) {
        	
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

		//	if (session != null) {
		//	session.invalidate();				
		//	}
			
			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			error.put("acticeUsers", "failed"); 
			error.put("Success", "false");
			error.put("ErrorMsg", "no valid session");
			json.put("Error Details", error); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
        	

        } else {
    		
		            performTask(request, response);
    			//	log.info("CurrentUserSessionId: " + session.getId());
        	}

    }
    
    /**
     * 
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
	private synchronized void performTask(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException {	

		HashMap<String, String> error = new HashMap<>();

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
			
			// put some value pairs into the JSON object . 				
			error.put("SQLAccess", "failed"); 
			error.put("Success", "false"); 
			
		}
		
		if (deviceId == null || user == null) {
			
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);
			
			// put some value pairs into the JSON object . 				
			error.put("deviceId", deviceId); 
			error.put("user", user); 

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
				response.addHeader("X-Token", token2.get(0));

				PrintWriter out = response.getWriter(); 
				
				//create Json Object 
				JSONObject json = new JSONObject(); 
				
				// put some value pairs into the JSON object . 				
				error.put("Activation", "false"); 
				error.put("Success", "false");
				error.put("User", user);
				error.put("deviceId", deviceId);
				json.put("Error Details", error);
				
				// finally output the json string 
				out.print(json.toString());
				out.flush();

			}
		
		// Get user entity using API GET method, with user and token as request params
		else if(token_ != null && session != null && deviceId != null && user != null /*&& request.isRequestedSessionIdValid()*/) {			
			
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
			log.info(request.getContentType());
			
			request.setAttribute("user", user);
			request.setAttribute("TIME_", session.getCreationTime());
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
			error.put("Error:", "User does not bear valid paramteres."); 
			json.put("Error Details", error); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
			
				}

		}

    @SuppressWarnings("unchecked")
    /**
     * 
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOExcetion
     */
	public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

		HashMap<String, String> error = new HashMap<>();

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Get JSESSION url parameter. Later it needs to be sent as header
        sessionId = request.getParameter("JSESSIONID");			
        log.info("SessionId from request parameter: " + sessionId);
       
        // Return current session
		session = request.getSession();		
		cookies = request.getCookies();

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

                
            } else {
            	
    			response.setContentType("application/json"); 
    			response.setCharacterEncoding("utf-8"); 
    			response.setStatus(502);

    			if (session != null) {
    				session.invalidate();				
    			}
    			
    			// put some value pairs into the JSON object . 				
    			error.put("acticeUsers", "failed"); 
    			error.put("Success", "false"); 
    			
            }
    	
    	}
    	
    	if (session == null || !request.isRequestedSessionIdValid() ) {
        	
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

		//	if (session != null) {
		//	session.invalidate();				
		//	}
			
			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			error.put("acticeUsers", "failed"); 
			error.put("Success", "false");
			error.put("ErrorMsg", "no valid session");
			json.put("Error Details", error); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
        	

        } else {
    		
		            performTask(request, response);
    			//	log.info("CurrentUserSessionId: " + session.getId());
        	}
    	
    	}
    
    /**
     * 
     */
    public void destroy()
    {
        // do nothing.
    }
  
   
}