package com.jeet.filters;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.Provider;
import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerRequestFilter;

@Provider
public class CookieFilter implements ContainerRequestFilter {

    
    @Override
    public ContainerRequest filter(ContainerRequest request) throws WebApplicationException {
    	System.out.println("\nCiphertext filter...");
    	
    	if(request.getRequestUri().getPath().contains("user")) {
    	System.out.println("\nCiphertext filter running...");

    	String headerToken = request.getHeaderValue("Ciphertext");

          if(!request.getCookies().containsKey("X-Token")) {
  				throw new WebApplicationException(Status.FORBIDDEN);

          			}
                }
		return request;
    		}
    	}
    

