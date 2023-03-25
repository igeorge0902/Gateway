package com.jeet.rest;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;
import com.jeet.exceptions.BookingException;
 
@Provider
public class BookingExceptionMapper implements ExceptionMapper<Exception> {
 
    public Response toResponse(Exception arg0) {
       
    	if (arg0 instanceof BookingException)
        
    		return Response.status(404).entity(arg0.getMessage()).build();
        else
            return Response.status(100).build();
    }
 
}
