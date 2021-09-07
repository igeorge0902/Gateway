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
import com.jeet.utils.CustomNotFoundException;

@Provider
@PreMatching
public class CiphertextFilter implements ContainerRequestFilter {
 
    public CiphertextFilter() {
        super();
    }
    
    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
    	System.out.println("Ciphertext filter...");
    	
    	if(requestContext.getUriInfo().getPath().contains("user")) {
    	System.out.println("Ciphertext filter running...");

    	String headerToken = requestContext.getHeaderString("Ciphertext");
    	System.out.println("headerToken: " + headerToken);
    	System.out.println("token2: " + requestContext.getProperty("token2").toString());

          if(!headerToken.trim().equals(requestContext.getProperty("token2").toString().trim())) {
          	requestContext.abortWith(Response.status(Response.Status.FORBIDDEN)
                      .entity("Cannot access")
                      .build());
                }
    		}
    	}
    
}
