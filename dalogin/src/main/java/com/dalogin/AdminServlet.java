package com.dalogin;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.lang3.exception.ExceptionUtils;
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
	public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	
		// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Return current session
		session = request.getSession(false);		
		cookies = request.getCookies();
		
        // Get JSESSION url parameter. By now it is just a logging..
        sessionId = request.getParameter("JSESSIONID");	
        if(sessionId == null) {
        	sessionId = session.getId();
        	
        }
        log.info("SessionId from request parameter: " + sessionId);       
         performTask(request, response);

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
			 * 
			 * Beverly Cops 2: pofa be, nem téged kérdeztelek.
			 * Velazquez: Las Maninas - s a mester egy nagy ajtót fest, amin két fontos alak van.
			 */
			RequestDispatcher rd = otherContext.getRequestDispatcher(webApiContextUrl + user.trim().toString()+"/"+token_.trim().toString());
			log.info(request.getContentType());
			token2 = new ArrayList<String>();

			try {
				
				token2 = SQLAccess.token2((String)session.getAttribute("deviceId"), context);
				
				} catch (Exception e) {
				
					throw new ServletException(e.getCause().toString());

			}
			request.setAttribute("user", user);
			request.setAttribute("token2", token2.get(0));
      	   System.out.print("Token2: "+ token2.get(0));

			request.setAttribute("TIME_", session.getCreationTime());
			rd.forward(request, response); 
			}
		/*
		else if(token_ != null && session != null && deviceId != null && user != null) {
			
			// it does not work yet due to some mystic SSL connection error 
			// plain HTTP request, so should work
			// money for nothing, and chicks for free! (RBB)
			
			try {
				doHTTPrequest(response, user, token_);
			
			} catch (KeyManagementException e) {
				String stacktrace = ExceptionUtils.getStackTrace(e);
	        	System.out.println(stacktrace);			
	        	} catch (NoSuchAlgorithmException e) {
	        		String stacktrace = ExceptionUtils.getStackTrace(e);
	            	System.out.println(stacktrace);			}
			
		}*/
		
		else {
			
			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);

			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			error.put("ErrorMsg:", "User does not bear valid paramteres."); 
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

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               
        // Return current session
		session = request.getSession(false);		
		cookies = request.getCookies();
		
        // Get JSESSION url parameter. By now it is just a logging..
        sessionId = request.getParameter("JSESSIONID");	
        if(sessionId == null) {
        	sessionId = session.getId();
        	
        }
        log.info("SessionId from request parameter: " + sessionId);       
         performTask(request, response);
    	}
    
    /**
     * 
     */
    public void destroy()
    {
        // do nothing.
    }
    
    // Plain Url connection experiment
    private void doHTTPrequest(HttpServletResponse response, String user, String token_) throws IOException, NoSuchAlgorithmException, KeyManagementException {
    
     	 // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] {new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }
                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                }
            }
        };
 
        // Install the all-trusting trust manager
        SSLContext sc = SSLContext.getInstance("SSL");
        sc.init(null, trustAllCerts, new java.security.SecureRandom());
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
 
        // Create all-trusting host name verifier
        HostnameVerifier allHostsValid = new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        };
 
        
        // Install the all-trusting host verifier
        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        
        try {
    	URL url = new URL("https://milo.crabdance.com/mbook-1/rest/user/" + user.trim().toString()+"/"+token_.trim().toString());
    	HttpURLConnection con = (HttpURLConnection) url.openConnection();
    	con.setRequestMethod("GET");
    	 
    	con.setRequestProperty("Content-Type", "application/json");
    	con.setRequestProperty("Ciphertext", token_);
        
        if (con.getResponseCode() == 404) {
        	Reader reader = new InputStreamReader(con.getErrorStream());
            while (true) {
                int ch = reader.read();
                if (ch==-1) {
                    break;
                }
                
                PrintWriter out = response.getWriter(); 
                
                out.print((char)ch);
    			out.flush();
            }
        }
        
        if (con.getResponseCode() == 412) {
        	Reader reader = new InputStreamReader(con.getErrorStream());
            while (true) {
                int ch = reader.read();
                if (ch==-1) {
                    break;
                }
                
                PrintWriter out = response.getWriter(); 
                
                out.print((char)ch);
    			out.flush();
            }

        }
        
        if (con.getResponseCode() == 200) {
        	Reader reader = new InputStreamReader(con.getInputStream());
            while (true) {
                int ch = reader.read();
                if (ch==-1) {
                    break;
                }
                
                PrintWriter out = response.getWriter(); 
 
    			out.print((char)ch);
    			out.flush();
            }
        }
        
        } catch (Exception e) {
        	String stacktrace = ExceptionUtils.getStackTrace(e);
        	System.out.println(stacktrace);
        }
    	    	
    }
  
   
}