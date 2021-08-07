package com.dalogin.filters;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;

@WebFilter(servletNames= {"AdminServlet", "GetAllPurchases", "CheckOut", "ManagePurchases", "Loggingout"})
public class RohadekFilter implements Filter {

    private ServletContext context;
	private static Logger log = Logger.getLogger(Logger.class.getName());

    public void init(FilterConfig fConfig) throws ServletException {
        this.context = fConfig.getServletContext();
        this.context.log("AuthenticationFilter initialized");
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
       	HashMap<String, String> error = new HashMap<>();

    	// Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
               		
		Cookie [] cookies = req.getCookies();
		
        // Get JSESSION url parameter. Later it needs to be sent as header
        String sessionId = req.getParameter("JSESSIONID");	
        if(session != null && sessionId == null) {
        	sessionId = session.getId();
        }
        log.info("SessionId from request parameter: " + sessionId);
    	if (cookies == null || !req.isRequestedSessionIdValid() || session == null) {
        	
			res.setContentType("application/json"); 
			res.setCharacterEncoding("utf-8"); 
			res.setStatus(502);
			
			PrintWriter out = response.getWriter(); 
			
			//create Json Object 
			JSONObject json = new JSONObject(); 
			
			// put some value pairs into the JSON object . 				
			error.put("acticeUsers", "failed"); 
			error.put("Success", "false");
			error.put("ErrorMsg:", "no valid session");
			json.put("Error Details", error); 
			
			// finally output the json string 
			out.print(json.toString());
			out.flush();
        	
        } else if (session != null && req.isRequestedSessionIdValid() && cookies != null) {
                
                for (Cookie cookie : cookies) {
    			 
                	if (cookie.getName().equalsIgnoreCase("XSRF-TOKEN")) {
						String actualToken = cookie.getValue().trim();
						
                		if (!session.getAttribute("XSRF-TOKEN").toString().equals(actualToken)) {
                			throw new ServletException("There is no valid XSRF-TOKEN");

                		} else {
                            // pass the request along the filter chain
                            chain.doFilter(request, response);
                        }
  			   
                	}
                }
        }
    }

    public void destroy() {
        //close any resources here
    }
}