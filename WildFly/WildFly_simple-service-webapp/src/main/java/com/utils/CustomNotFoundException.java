package com.utils;

import java.io.Serializable;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

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
	  * Create a HTTP 404 (Not Found) exception.
	  * @param message the String that is the entity of the 404 response.
	  */
	  public CustomNotFoundException(String message) {
	    super(Response.status(Response.Status.NOT_FOUND).entity(message).type("text/plain").build());
	  }
	}