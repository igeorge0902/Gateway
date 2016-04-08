package com.jeet.utils;

import java.io.Serializable;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;

import com.sun.jersey.api.Responses;

public class CustomNotFoundException extends WebApplicationException implements Serializable {
	 
	  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	  * Create a HTTP 404 (Not Found) exception.
	  */
	  public CustomNotFoundException() {
	    super(Responses.notFound().build());
	  }
	 
	  /**
	  * Create a HTTP 404 (Not Found) exception.
	  * @param message the String that is the entity of the 404 response.
	  */
	  public CustomNotFoundException(String message) {
	    super(Response.status(Responses.NOT_FOUND).
	    entity(message).type("text/plain").build());
	  }
	}