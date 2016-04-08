package com.jeet.utils;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.codehaus.jettison.json.JSONObject;

public class MyException extends WebApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MyException(JSONObject jsonObject) {
		
	    super(Response.status(Response.Status.OK)
	            .entity(jsonObject)
	            .type(MediaType.APPLICATION_JSON)
	            .build());
		}

}