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
import java.util.Map;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.dalogin.utils.AesUtil;
import com.dalogin.utils.SendHtmlEmail;

public class RegActivation extends HttpServlet {
    
	/**
	 * 
	 */
	private static final long serialVersionUID = -933199811013368066L;

	/**
	 * 
	 */
	private volatile static String user;
	
	/**
	 * 
	 */
	private volatile static String token2;
	
	/**
	 * 
	 */
	private volatile static String ciphertext;
	
	/**
	 * 
	 */
	protected volatile static HttpSession session = null;
	
	/**
	 * 
	 */
	private volatile static String deviceId;
	
	/**
	 * 
	 */
	public static volatile String token;
	
	/**
	 * 
	 */
	private static volatile String email;
	
	/**
	 * 
	 */
	private static volatile List<String> list;
	
	/**
	 * 
	 */
    private static volatile String activationData;
    
    /**
     * 
     */
	private static AesUtil aesUtil;
	
	/**
	 * 
	 */
    private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    
    /**
     * 
     */
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    
    /**
     * 
     */
    private static final String activationToken_ = "G";
    
    /**
     * 
     */
    private static final int KEYSIZE = 128;
    
    /**
     * 
     */
    private static final int ITERATIONCOUNT = 1000;
    
    /**
     * 
     */
    private static volatile boolean True;
    
    /**
     * 
     */
    private static volatile String query;
    
    /**
     * 
     */
    private static volatile String[] params;
    
    /**
     * 
     */
    private static volatile Map<String, String> queryMap;
    
    /**
     * 
     */
    private static volatile String name;
    
    /**
     * 
     */
    private static volatile String value;
    
    /**
     * 
     */
	private static Logger log = Logger.getLogger(Logger.class.getName());
	

	/**
	 * 
	 */
    public void init() throws ServletException {
    	aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);

    }
    
    /**
     * 
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    public synchronized void processRequest (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    }
    
    /**
     * 
     */
    public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 	

		session = request.getSession(false);		
		
        ServletContext context = session.getServletContext();

        ciphertext = request.getHeader("Ciphertext");
    	user = request.getParameter("user");
    	deviceId = request.getParameter("deviceId");

    	
    	if (ciphertext != null) ciphertext = ciphertext.trim();
        if (user != null) user = user.trim();
               
	    StringBuilder sb = new StringBuilder();
	    BufferedReader br = request.getReader();
	    
	    String str;
	    while( (str = br.readLine()) != null ){
	        sb.append(str);
	    }    
	    
	    JSONObject jObj = new JSONObject(sb.toString());
	    
	        user = jObj.getString("user");
	        deviceId = jObj.getString("deviceId");

	    try {
        	
            token2 = SQLAccess.token2(deviceId, context);
            True = token2.equals(ciphertext);

			if (True) {
				
				list = SQLAccess.activation_token(user, context);

				token = list.get(0);
				email = list.get(1);
				
				// send email for activation 
			    String scheme = request.getScheme();             
				String serverName = request.getServerName();
				String servletContext = context.getContextPath();
			
			    // prepare data
			    activationData = "user="+user+"&token2="+token;
			    //activationToken = SQLAccess.activation_token(user, context).get(0);

			    // Construct requesting URL
			    StringBuilder url = new StringBuilder();

			    url.append(scheme).append("://")
			    .append(serverName).append(servletContext).append("/activation")
			    .append("?").append("activation=").append(aesUtil.encrypt(SALT, IV, activationToken_, activationData));
			    
			    SendHtmlEmail.generateAndSendEmail(email, url.toString()); 
			    
			    JSONObject json = new JSONObject(); 
				json.put("Success", "true");
				json.put("Email was sent to:", email);
				
				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				response.setStatus(200);
				response.getWriter().write(json.toString());
				
			} else {

				response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, "Line 125");
			}
			
			
		} catch (Exception e) {
			
			String error = e.getCause().toString();
			log.info(error);

		    JSONObject json = new JSONObject(); 
			json.put("Error", error);

			response.setContentType("application/json"); 
			response.setCharacterEncoding("utf-8"); 
			response.setStatus(502);
			response.getWriter().write(json.toString());
			response.flushBuffer();

		}
    
    }
    
    /**
     * 
     */
    public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json"); 
		response.setCharacterEncoding("utf-8"); 

		activationData = request.getParameter("activation");
		query = aesUtil.decrypt(SALT, IV, activationToken_, activationData);
		
	    params = query.split("&");
	    queryMap = new HashMap<String, String>();
	    
	    for (String param : params)
	    
	    {
	        name = param.split("=")[0];
	        value = param.split("=")[1];
	        queryMap.put(name, value);
	    }

		//TODO: activate the voucher		
		
		PrintWriter out = response.getWriter(); 

		JSONObject json = new JSONObject(); 
		JSONArray list = new JSONArray();
		list.put(queryMap);
		json.put("activation", list);
		
		out.print(json.toString());
		out.flush();
    	
    }
    
    /**
     * 
     */
    public void destroy() {
        // do nothing.
    }
}
