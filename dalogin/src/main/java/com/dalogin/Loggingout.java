package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

//Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.json.JSONObject;


//Extend HttpServlet class
public class Loggingout extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9006384818191092461L;
	
	/**
	 * 
	 */
	public volatile static String user;
	
	/**
	 * 
	 */
	public volatile static HttpSession session;
	
	/**
	 * 
	 */
	public volatile static String deviceId;

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
	   * @throws Exception
	   */
	  public synchronized void processRequest (HttpServletRequest request, HttpServletResponse response) throws Exception {
			    	
	  }
	  
	  /**
	   * 
	   */
	  public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	  }
	  
	  /**
	   * 
	   */
	  public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	 	

		 	session = request.getSession(false);
		      	
		     if(session != null){
		  		 
		    	 ServletContext context = request.getServletContext();
		    	 session.removeAttribute("user");
		    	 //TODO: on TomCat, it is called on TomCat shutdown, triggering new tokens.
		    	 //TODO: automatic logging out handling in the dB (device_states)
		         try {
					SQLAccess.logout(session.getId(), context);	
				} catch (Exception e) {

						throw new ServletException(e.getMessage());	
				}
			     session.invalidate();
				 
			     response.setContentType("application/json"); 
		    	 response.setStatus(HttpServletResponse.SC_OK);
		    	 PrintWriter out = response.getWriter(); 
					
					//create Json Object 
					JSONObject json = new JSONObject(); 
					
					// put some value pairs into the JSON object .
					json.put("isLoggedOut", "true"); 
					json.put("Success", "true"); 
					
					// finally output the json string 
					out.print(json.toString());
					out.flush();
		     }
		     
		     else {
			     
		    	 response.setContentType("application/json"); 
		    	 response.setStatus(HttpServletResponse.SC_OK);
		    	 PrintWriter out = response.getWriter(); 
					
					//create Json Object 
					JSONObject json = new JSONObject(); 
					
					// put some value pairs into the JSON object .
					json.put("isAlreadyLoggedOut", "true"); 
					json.put("Success", "true"); 
					
					// finally output the json string 
					out.print(json.toString());
					out.flush();
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