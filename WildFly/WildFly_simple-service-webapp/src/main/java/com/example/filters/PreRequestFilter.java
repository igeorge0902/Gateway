package com.example.filters;

import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.container.PreMatching;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;

import java.io.IOException;


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
    	requestContext.getHeaders().add("Accept-Hello", "hello");
    	
		if (host.isEmpty()) {
			throw new WebApplicationException(Response.Status.UNAUTHORIZED);
		}        
    }
}