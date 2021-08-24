package com.jeet.utils;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

@Provider
	public class EntityNotFoundMapper implements ExceptionMapper<javax.persistence.EntityNotFoundException> {
	 
	public Response toResponse(javax.persistence.EntityNotFoundException ex) {
	
		return Response.status(404).entity(ex.getMessage()).type("text/plain").build();
		
	  }
	}
	

