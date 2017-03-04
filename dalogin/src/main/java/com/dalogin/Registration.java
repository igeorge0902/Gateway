package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.dalogin.utils.AesUtil;
import com.dalogin.utils.EmailValidator;
import com.dalogin.utils.SendHtmlEmail;
import com.dalogin.utils.hmac512;


//Extend HttpServlet class
public class Registration extends HttpServlet {
	
	private static Logger log = Logger.getLogger(Logger.class.getName());

    /**
    *
    */
    private static final long serialVersionUID = 1L;	
	private volatile static String pass;
	private volatile static String user;
	private volatile static String voucher;
	private volatile static String deviceId;
	private volatile static String contentLength;
	private volatile static HttpSession session;
	private volatile static long SessionCreated;
	private volatile static String sessionID;

	private volatile static String email;
	private volatile static String ios;
	private volatile static String WebView;
	private volatile static String M;
	private volatile static String token2;
	private volatile static String hmac;
	private volatile static String hmacHash;
	private volatile static String time;
	private static AesUtil aesUtil;
    private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;
    private static volatile Cookie c;
    private static volatile long T;
    private static volatile String new_hash;
    private static volatile String activationData;
    private static final String activationToken = "G";


    public void init() throws ServletException
    {
    	aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);

    }
    
    public synchronized void processRequest (HttpServletRequest request, HttpServletResponse response)
    	    throws ServletException, IOException {
		    	
    }
    
    public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	    	
    	// Set response content type
		response.setContentType("application/json"); 
		response.setCharacterEncoding("utf-8"); 	             
        
        // Actual logic goes here.
		user = request.getParameter("user").trim();			
    	pass = request.getParameter("pswrd").trim();
    	email = request.getParameter("email").trim();
        voucher = request.getParameter("voucher_").trim();
        deviceId = request.getParameter("deviceId").trim();
        
    	hmac = request.getHeader("X-HMAC-HASH");
    	contentLength = request.getHeader("Content-Length");
    	time = request.getHeader("X-MICRO-TIME");
		ios = request.getParameter("ios");
		WebView = request.getHeader("User-Agent");
		M = request.getHeader("M");
        T = Long.parseLong(time.trim());

		ServletContext context = request.getServletContext();

		final long T2 = Long.parseLong(context.getAttribute("time").toString());

        // Check core request parameters first
        if (voucher != null) voucher = voucher.trim();
        if (email != null) email = email.trim();
        
        //TODO: add password policy
        if (voucher != null && !voucher.equals("") && !user.equals("") && user.length() > 0 && EmailValidator.validate(email)) {
        	
        	hmacHash = hmac512.getRegHmac512(user, email, pass, deviceId, voucher, time, contentLength);
    		
    		log.info("HandShake was given: "+hmac+" & "+hmacHash);
        	
        	session = request.getSession(true);

           // synchronized session object to prevent concurrent update
           synchronized(session) {
              
        	   session.setAttribute("voucher", voucher);
        	   
        // Try - catch is necessary anyways, and will catch user names that have become used in the meantime
        try {
			if (SQLAccess.register_voucher(voucher, context) && hmac.equals(hmacHash) && ((T+T2) > System.currentTimeMillis())) {
                  
              if ((new_hash_(pass, user, email, context) == "I") && SQLAccess.insert_voucher(voucher, user, pass, context) && SQLAccess.insert_device(deviceId, user, context)) {
				
				session.setAttribute("user", user);				
				session.setAttribute("deviceId", deviceId);
				
				//setting session to expire in 30 mins
				session.setMaxInactiveInterval(30*60);
				SessionCreated = session.getCreationTime();
				sessionID = session.getId();
				
				// insert sessionId for the device, then, if success, we can copy the token2
				if(SQLAccess.insert_sessionCreated(deviceId, SessionCreated, sessionID, context)){
					
					SQLAccess.copy_token2(voucher, context);
					
					// send email for activation 
				    String scheme = request.getScheme();             
					String serverName = request.getServerName();
					String servletContext = context.getContextPath();
					token2 = SQLAccess.token2(deviceId, context);

				    // prepare data
				    activationData = "user="+user+"&token2="+token2;
				    //activationToken = SQLAccess.activation_token(user, context).get(0);
					
				    // Construct requesting URL
				    StringBuilder url = new StringBuilder();
				    
				    url.append(scheme).append("://")
				    .append(serverName).append(servletContext).append("/activation")
				    .append("?").append("activation=").append(aesUtil.encrypt(SALT, IV, activationToken, activationData));
				    
				    if(!SendHtmlEmail.generateAndSendEmail(email, url.toString())) {

				    	throw new ServletException("Huston, we got a problem!");

				    }
					
				}
			
				else{
					
					throw new ServletException("Huston, we got a problem!");
			
				}
				
		        String homePage = getServletContext().getInitParameter("homePage");
		        
				ServletContext otherContext = getServletContext().getContext(homePage);
								
				// X-Token should be sent as json response I guess
				// native mobile
						if (ios != null) {
						try {
						log.info("1");
						token2 = SQLAccess.token2(deviceId, context);
						c = new Cookie("XSRF-TOKEN", aesUtil.encrypt(SALT, IV, time, token2));
						c.setSecure(true);
						c.setMaxAge(session.getMaxInactiveInterval());
						
						response.addCookie(c);
						response.setContentType("application/json"); 
						response.setCharacterEncoding("utf-8"); 
						response.setStatus(200);
		
						session.setAttribute(c.getName(), c.getValue());

						PrintWriter out = response.getWriter(); 
						
						JSONObject json = new JSONObject(); 
						
						json.put("success", 1);
						json.put("JSESSIONID", sessionID);
						json.put("X-Token", token2);
						
						out.print(json.toString());
						out.flush();
						
						} catch (Exception e) {
							e.printStackTrace();
						}
						
						// mobile webview (there is no session in iOS simulator in normal webview with GlassFish. Interesting.)
						} else if (WebView.contains("Mobile") && M.equals("M")){ 
							
							try {
								log.info("2");
								token2 = SQLAccess.token2(deviceId, context);
								c = new Cookie("XSRF-TOKEN", aesUtil.encrypt(SALT, IV, time, token2));
								c.setSecure(true);
								c.setMaxAge(session.getMaxInactiveInterval());

								response.addCookie(c);
								// The token2 will be used as key-salt-whatever as originally planned.
								response.addHeader("X-Token", token2);
												
								session.setAttribute(c.getName(), c.getValue());

								JSONObject json = new JSONObject(); 
								
								json.put("Session", "raked"); 
								json.put("Success", "true");
								json.put("JSESSIONID", sessionID);

								// this is necessary because the X-Token header did not appear in the native mobile app
								json.put("X-Token", token2);
								
								response.sendRedirect(otherContext.getContextPath() + "/tabularasa.jsp?JSESSIONID="+sessionID);		

								
							} catch (Exception e) {
								e.printStackTrace();
							}
						
						} 
						// standard path
						else {
							try {
								log.info("3");
								token2 = SQLAccess.token2(deviceId, context);
								c = new Cookie("XSRF-TOKEN", aesUtil.encrypt(SALT, IV, time, token2));
								c.setSecure(true);
								c.setMaxAge(session.getMaxInactiveInterval());

								response.addCookie(c);
								// The token2 will be used as key-salt-whatever as originally planned.
								response.addHeader("X-Token", token2);
								
								// TODO: finish cross-site request forgery protection
								session.setAttribute(c.getName(), c.getValue());
								
								PrintWriter out = response.getWriter(); 
								
								JSONObject json = new JSONObject(); 
								
								json.put("Session", "raked"); 
								json.put("Success", "true"); 
								// this is necessary because the X-Token header did not appear in the native mobile app
								json.put("X-Token", token2);
								
								out.print(json.toString());
								out.flush();
								
							} catch (Exception e) {
								e.printStackTrace();
							}

		
						}
					
				  }	else {
					  
						response.setContentType("application/json"); 
					  	response.setStatus(502);
					  	
						PrintWriter out = response.getWriter(); 

					  	SQLAccess.reset_voucher(voucher, context);
					    
						out.print(new_hash);
						out.flush();
				  }
              
	           } else {

	        	   // hmac error
	        	   response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Line 255");
	           }
		
		} catch (Exception e) {

			// servlet runtime error

			try {
				
				SQLAccess.reset_voucher(voucher, context);
				
			} catch (Exception e1) {

				log.info("Voucher reset FAILED for vouchet:" + voucher + "!");

				throw new ServletException();
				
					}
		
				}

           } 
        
        } else {
        	
        	// email format failed
			try {
				
				SQLAccess.reset_voucher(voucher, context);
				
			} catch (Exception e1) {

				log.info("Voucher reset FAILED for vouchet:" + voucher + "!");

				throw new ServletException();
				
				}
			
        	response.setContentType("application/json"); 
		  	response.setStatus(502);
		  	
			PrintWriter out = response.getWriter(); 
			JSONObject json = new JSONObject(); 
			
			json.put("Registration", "failed"); 
			json.put("Email", "false"); 
			json.put("Message", "Not a valid email format!"); 

			out.print(json);
			out.flush();
			
        }
    
    }
    
    public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	
    	processRequest(request, response);

    	// Set response content type
        response.setContentType("text/html");
	      
        try {
    		voucher = request.getParameter("voucher");
        	pass = request.getParameter("pswrd");
            voucher = request.getParameter("voucher_");
            deviceId = request.getParameter("deviceId");
			
			if (voucher.trim().isEmpty() || user.trim().isEmpty() || pass.trim().isEmpty() || deviceId.trim().isEmpty()) {
	    		response.sendError(HttpServletResponse.SC_BAD_GATEWAY, "Line 325");
			}
					
		} catch (Exception e) {			
    		response.sendError(HttpServletResponse.SC_BAD_GATEWAY, "Line 329");

		}
        
    }
    
    public void destroy()
    {
        // do nothing.
    }
    
    private String new_hash_(String pass, String user, String email, ServletContext context) throws Exception {
    	new_hash = SQLAccess.new_hash(pass, user, email, context);
    	return new_hash;
    }
}
