package com.jeet.utils;

import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

import java.io.Serializable;

public class CustomNotFoundException extends WebApplicationException implements Serializable {
	 
	  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	  * Create a HTTP 404 (Not Found) exception.
	  */
	  public CustomNotFoundException() {
	    
		  super(Response.noContent().build());
	  
	  }
	 
	  /**
	  * Create a HTTP 401 (Unauthorized) exception.
	  * @param message the String that is the entity of the 401 response.
	  */
	  public CustomNotFoundException(String message) {
	    
		  super(Response.status(Response.Status.UNAUTHORIZED).entity(message).type("text/plain").build());
	  	
	  	}
	}