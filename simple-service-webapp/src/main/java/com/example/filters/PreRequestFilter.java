package com.example.filters;

import java.io.IOException;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.PreMatching;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.Provider;

@Provider
@PreMatching
public class PreRequestFilter implements ContainerRequestFilter {
	public static final String HOST_HEADER = "Host";

	public PreRequestFilter() {
        super();
    }

	@Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        
		String host = requestContext.getHeaderString(HOST_HEADER);
		System.out.println(host);
    	requestContext.getHeaders().add("Accept-Hello", "hello");
    	
		if (host.isEmpty()) {
			throw new WebApplicationException(Status.UNAUTHORIZED);
		}
        
    }
}