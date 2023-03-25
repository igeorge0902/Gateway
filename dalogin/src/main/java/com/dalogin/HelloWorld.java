package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

//Import required java libraries
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.dalogin.listeners.CustomServletContextListener;
import com.dalogin.utils.AesUtil;
import com.dalogin.utils.hmac512;

/**
 * 
 *
 */
public class HelloWorld extends HttpServlet implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6378614133674149101L;

	/**
	 * User password received from the request as parameter.
	 */
	private volatile static String pass;
	
	/**
	 * Username received from the request as parameter.
	 */
	private volatile static String user;
	
	/**
	 * User password value retrieved from the dB.
	 */
	private volatile static String hash1;
	private volatile static String deviceId;
	private volatile static String deviceId_;
	private volatile static String contentLength;
	private volatile static String ios;
	private volatile static String WebView;
	private volatile static String M;
	private volatile static HttpSession session;
	private volatile static boolean devices;
	private volatile static long SessionCreated;
	private volatile static String sessionID;
	private volatile static List <String> token2;
	private volatile static String hmac;
	private volatile static String hmacHash;
	private volatile static String time;
	private static AesUtil aesUtil;
    private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    private static final String PASSPHRASE = "SecretPassphrase";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;
    private static volatile Cookie c;
    private static volatile Cookie d;
    private static volatile long T;

	private static Logger log = Logger.getLogger(Logger.class.getName());

	/**
	 * {@link AesUtil}
	 * 
	 */
    public void init() throws ServletException {
    
    	aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
    }
    
    /**
     * Receive a POST request to do the authentication.
     *     
     * FYI: 
     * good performance test combined with API is advised to run with multiple deviceIds due to the logic that the session is tied to a device
     */
    public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	
    	// Set response content type
		response.setContentType("application/json"); 
		response.setCharacterEncoding("utf-8"); 
		
	 	session = request.getSession(false);
      	
 	     if(session != null){
 	  		 
 		     session.invalidate();
 	     }
 		
 	     ServletContext context = request.getServletContext();
	      
 	     final long T2 = Long.parseLong(context.getAttribute("time").toString());

        // Actual logic goes here.		

        	// hmac is not encrypted, just the password inside
        	hmac = request.getHeader("X-HMAC-HASH").trim();
        	contentLength = request.getHeader("Content-Length").trim();
        	time = request.getHeader("X-MICRO-TIME").trim();
    		pass = request.getParameter("pswrd").trim();	
    		user = request.getParameter("user").trim();	
    		deviceId = request.getParameter("deviceId").trim();
    		ios = request.getParameter("ios");
    		WebView = request.getHeader("User-Agent");
    		M = request.getHeader("M");
    		if (M == null){
    			M = "";
    		}
    		deviceId_ = request.getHeader("M-Device");
            T = Long.parseLong(time.trim());
            hmacHash = hmac512.getLoginHmac512(user, pass, deviceId, time, contentLength);
    		    		
    		log.info("HandShake was given: "+hmac+" & "+hmacHash);
    		
            try{ 
            	log.info("deviceId to be decrypted: " +  deviceId_ );
            	deviceId = aesUtil.decrypt(SALT, IV, PASSPHRASE, deviceId_);
            	log.info("deviceId decrypted: " +  deviceId );
            
            } catch (Exception e) {
            	
            	log.info("There was no deviceId to be decrypted.");
            	
            }
            
            hash1 = hash_(pass, user, context);

        	/*
        	 *  user authentication only can happen during the intervallum that the network latency produces 
        	 *  plus seconds given as context parameter
        	 *  
        	 */
        	if(pass.equals(hash1) && hmac.equals(hmacHash)){
        		
        		// Create new session
				session = request.getSession(true);
				
				System.out.println("Session created: " +session.getId());

				// synchronized session object to prevent concurrent update		        	   
				synchronized(session) {
	                
				session.setAttribute("user", user);
				session.setAttribute("deviceId", deviceId);
				
				session.removeAttribute("pswrd");
				SessionCreated = session.getCreationTime();
				sessionID = session.getId();
		           }

				try {
					SQLAccess.insert_device(deviceId, user, context);
					SQLAccess.insert_sessionCreated(deviceId, SessionCreated, sessionID, context);
				} catch (Exception e) {	
					throw new ServletException(e.getCause().toString());
				}

				//setting session to expiry in 30 mins
				session.setMaxInactiveInterval(30*60); 	

				// X-Token should be sent as json response I guess
				// native mobile
						if (ios != null) {
						try {
						log.info("1");
						token2 = SQLAccess.token2(deviceId, context);
						
						//TODO: IV can be the sessionId
						String xsrfToken = aesUtil.encrypt(SALT, IV, token2.get(1), token2.get(0));						
						int l = xsrfToken.length();	
						String actualToken = "";	

						if (xsrfToken.endsWith("=")) {	
								actualToken = xsrfToken.substring(0, l-1);	

							} else {	
								actualToken = xsrfToken.trim();	
								}
						
						c = new Cookie("XSRF-TOKEN", actualToken);
						c.setSecure(true);
						c.setMaxAge(session.getMaxInactiveInterval());
						c.setHttpOnly(true);
						c.setPath(context.getContextPath());

						d = new Cookie("X-Token", token2.get(0));								
						d.setSecure(true);
						d.setMaxAge(session.getMaxInactiveInterval());
						
						response.addCookie(c);
						response.addCookie(d);
						
						// The token2 will be used as key-salt-whatever as originally planned.
						response.addHeader("X-Token", token2.get(0));						
						response.setContentType("application/json"); 
						response.setCharacterEncoding("utf-8"); 
						response.setStatus(200);
		
						// set XSRF-TOKEN as session attribute
						session.setAttribute(c.getName(), c.getValue());
						
						// set timestamp for device login as session attribute
						session.setAttribute("TIME_", token2.get(1));

						PrintWriter out = response.getWriter(); 
						
						JSONObject json = new JSONObject(); 
						
						json.put("success", 1);
						json.put("JSESSIONID", sessionID);
						json.put("X-Token", token2.get(0));
						
						out.print(json.toString());
						out.flush();
						
						} catch (Exception e) {
							
							throw new ServletException(e.getCause().toString());
							
							}
						
						} 
						// standard path
						else {
							try {
								log.info("3");
								token2 = SQLAccess.token2(deviceId, context);
								//TODO: IV can be the sessionId
								String xsrfToken = aesUtil.encrypt(SALT, IV, token2.get(1), token2.get(0));						
								int l = xsrfToken.length();	
								String actualToken = "";	

								if (xsrfToken.endsWith("=")) {	
										actualToken = xsrfToken.substring(0, l-1);	

									} else {	
										actualToken = xsrfToken.trim();	

										}
								
								c = new Cookie("XSRF-TOKEN", actualToken);
								c.setSecure(true);
								c.setMaxAge(session.getMaxInactiveInterval());

								d = new Cookie("X-Token", token2.get(0));								
								d.setSecure(true);
								d.setMaxAge(session.getMaxInactiveInterval());
								
								response.addCookie(c);
								response.addCookie(d);
								
								// The token2 will be used as key-salt-whatever as originally planned.
								response.addHeader("X-Token", token2.get(0));								
								response.setContentType("application/json"); 
								response.setCharacterEncoding("utf-8"); 
								response.setStatus(200);
				
								// set XSRF-TOKEN as session attribute
								session.setAttribute(c.getName(), c.getValue());
								
								// set timestamp for device login as session attribute
								session.setAttribute("TIME_", token2.get(1));
								
								PrintWriter out = response.getWriter(); 
								
								JSONObject json = new JSONObject(); 
								
								json.put("Session", "raked"); 
								json.put("Success", "true"); 
								// this is necessary because the X-Token header did not appear in the native mobile app
								json.put("X-Token", token2.get(0));
								
								out.print(json.toString());
								out.flush();
								
							} catch (Exception e) {
								
								throw new ServletException(e.getCause().toString());
								
							}

		
						}
				

			}else {
				
				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				response.setStatus(502);

				PrintWriter out = response.getWriter(); 
				
				JSONObject json = new JSONObject(); 
				
				json.put("Session creation", "failed"); 
				json.put("Success", "false"); 
				
				out.print(json.toString());
				out.flush();
	    		
			}
        
    }
    
    public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        
    	
    	// Set response content type
        response.setContentType("text/html");
        
	 	session = request.getSession(false);
      	
	     if(session != null){
	  		 
		     session.invalidate();
	     }
	      
        // Actual logic goes here.		
        try {
    		pass = request.getParameter("pswrd");	
    		user = request.getParameter("user");	
    		deviceId = request.getParameter("deviceId");
			
			if (user.trim().isEmpty() || pass.trim().isEmpty() || deviceId.trim().isEmpty()) {
	    		response.sendError(HttpServletResponse.SC_BAD_GATEWAY);
			}
					
		} catch (Exception e) {
			
    		response.sendError(HttpServletResponse.SC_BAD_GATEWAY);

		}
    	
    }
    
    public void destroy()
    {
        // do nothing.
    }
    
    private String hash_(String pass, String user, ServletContext context) throws ServletException {
    	try {
			hash1 = SQLAccess.hash(pass, user, context);
		} catch (Exception e) {
			
			throw new ServletException(e.getMessage());	
		}
    	return hash1;
    }
}