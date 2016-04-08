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

  private static final long serialVersionUID = 1L;
	public volatile static String user;
	public volatile static HttpSession session;
	public volatile static String deviceId;

	
	  public void init() throws ServletException
	  {
	      // Do required initialization
	  }
	  
	  public synchronized void processRequest (HttpServletRequest request, HttpServletResponse response)
	  	    throws Exception {
			    	
	  }
	  
	  public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	  {
	
	  }
	  
	  public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	  {	 	
		/*     
		  if (request.getHeader("Referer").contains("register")) {
			  
				String elseUrl = getServletContext().getInitParameter("voucherElseRedirect");
				String encodedURL = response.encodeRedirectURL(elseUrl);
				
				response.sendRedirect(encodedURL);
		  } else {
		  */
		 	session = request.getSession(false);
		      	
		     if(session != null){
		  		 
		    	 session.removeAttribute("user");
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
					json.put("Success", "true"); 
					
					// finally output the json string 
					out.print(json.toString());
					out.flush();
		     }
	
		  }
	 // }
	  
	  public void destroy()
	  {
	      // do nothing.
	  }
}