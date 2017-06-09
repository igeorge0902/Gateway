package com.jeet.rest;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.activation.MimetypesFileTypeMap;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.json.JSONException;
import org.json.JSONObject;

import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.api.Tokens;
import com.jeet.service.BookingHandlerImpl;
import com.jeet.utils.AesUtil;
import com.jeet.utils.CustomNotFoundException;

@Path("/")
public class BookController {
	
    private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    private static volatile String ciphertext;
    
    private static volatile String plaintext;
    private static final String ORIGINPLAINTEXT = "G";
    
    private static final String PASSPHRASE = "SecretPassphrase";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;
    
    private static AesUtil aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
	
	
	@GET
	@Path("/device/{uuid}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public Response getDevice(@PathParam(value = "uuid") String uuid) {
		
		List<Devices> device = new BookingHandlerImpl().getDevice(uuid);
		GenericEntity<List<Devices>> entity = new GenericEntity<List<Devices>>(device) {};
		
		if (device.get(0).getId() != 0) {
			
			return Response.ok().status(200).entity(entity).header("Device", device.get(0).getDevice()).build();
		
		}
		
		else {
			
			return Response.status(404).entity(device.get(0)).build();

		}
	}
	@GET
	@Path("/user/{user}/{token1}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response getUser(@Context HttpHeaders headers, @PathParam(value = "user") String user, @PathParam(value = "token1") String token1) {
		
		Logins user_ = new BookingHandlerImpl().getUser(user);
		Tokens token2 = new BookingHandlerImpl().getToken2(token1);
		
		if (headers.getRequestHeader("Ciphertext").isEmpty()) {	         
			throw new CustomNotFoundException("User is not authorized!");
		}
		
		ciphertext = headers.getRequestHeader("Ciphertext").get(0);

		if (ciphertext.equals(token2.getToken2())) {
	        
				if (user_.getId() != 0) {
								
						return Response.ok().status(200).entity(user_).header("User", user_.getUuid()).header("TEST", token2).build();		
					
					} else {
				
						return Response.ok().status(Status.PRECONDITION_FAILED).entity(user_).build();
			
					}		        			
		} else {
			
	          throw new CustomNotFoundException("User is not authorized!");
		}

	}
	
	@GET
	@Path("/newuser/{newuser}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
	public Response getNewUser(@PathParam(value = "newuser") String newuser) {
		
		int newuser_ = new BookingHandlerImpl().getNewUser(newuser);
		   
		   JSONObject myObject = new JSONObject();
		   
		   myObject.put("name", "Agamemnon");
		   myObject.put("age", 32);
		   
			if (newuser_ > 0) {

					return Response.ok().status(412).entity(myObject.toString()).type(MediaType.APPLICATION_JSON).build();		
				
				} else {
			
					return Response.status(200).entity(myObject.toString()).build();
		
				}		
    
	}
	
	@GET
	@Path("/newemail/{newemail}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
	public Response getNewEmail(@PathParam(value = "newemail") String newemail) {
		
		int newuser_ = new BookingHandlerImpl().getNewEmail(newemail);
		   
		   JSONObject myObject = new JSONObject();
		   
		   myObject.put("name", "Agamemnon");
		   myObject.put("age", 32);
		   
			if (newuser_ > 0) {

					return Response.ok().status(412).entity(myObject.toString()).type(MediaType.APPLICATION_JSON).build();		
				
				} else {
			
					return Response.status(200).entity(myObject.toString()).build();
		
				}		
    
	}
	
    @GET
    @Path("/images/{image}")
    @Produces("image/*")
    public Response getImage(
    		@Context HttpHeaders header,
    		@Context HttpServletResponse response,
    		@PathParam("image") String image) throws IOException {
    	
        response.setContentType("images/jpg");

      File f = new File("/Users/georgegaspar/Pictures/Exports/" + image);
      
      if (f.exists() == false) 
          throw new CustomNotFoundException();
      
      BufferedImage img = ImageIO.read(f);
          
      String mt = new MimetypesFileTypeMap().getContentType(f);
      return Response.ok(img, mt).build();
    }
	
}
