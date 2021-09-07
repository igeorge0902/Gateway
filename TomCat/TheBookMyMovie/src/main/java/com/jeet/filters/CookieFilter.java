package com.jeet.filters;

import java.io.IOException;
import java.util.Map;

import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.PreMatching;
import javax.ws.rs.core.Cookie;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import com.jeet.utils.AesUtil;

@Provider
@PreMatching
public class CookieFilter implements ContainerRequestFilter {
 
    private static volatile String xsrfToken;
    private static volatile Map<String, Cookie> cookies;
    private static volatile Cookie cookie;
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;   
    private static AesUtil aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
	private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    
	public CookieFilter() {
        super();
    }
    
    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
    	System.out.println("Cookie filter...");
    	System.out.println("Path: " + requestContext.getUriInfo().getPath());
    	
    	if(requestContext.getUriInfo().getPath().contains("purchases")
        || requestContext.getUriInfo().getPath().contains("payment")) {
    	cookies = requestContext.getCookies();
    	System.out.println("Cookie filter running...");

  		if (!cookies.isEmpty()) {
  			cookie = cookies.get("XSRF-TOKEN");
  	  		if (cookie != null) {
  		    xsrfToken = aesUtil.encrypt(SALT, IV, requestContext.getProperty("TIME_").toString(), requestContext.getProperty("token2").toString());

			   String actualToken = "";
			   String token = xsrfToken.trim();
			   int l = token.length();

				if (token.endsWith("=")) {
					actualToken = token.substring(0, l-1);
				} else {
					actualToken = xsrfToken;
				}
	  	    	System.out.println("Actual token " + actualToken);  

  			   if (!actualToken.equals(cookie.getValue())) {
  		          	
  				   requestContext.abortWith(Response.status(Response.Status.FORBIDDEN)
  	                      .entity("Cannot access X")
  	                      .build());
  	                      
  	                }
  	  			}
    		} else {
		          	requestContext.abortWith(Response.status(Response.Status.FORBIDDEN)
	  	                      .entity("Cannot access C")
	  	                      .build());
		          	}
    		}
    }
}
