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
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

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
    private static volatile List<String> ciphertext;
    
    private static volatile String plaintext;
    private static final String ORIGINPLAINTEXT = "G";
    
    private static final String PASSPHRASE = "SecretPassphrase";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;
    
    private static AesUtil aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);

	
	/*
	@PUT
	@Path("/book/{movieName}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response getMovieTicket(@PathParam(value = "movieName") String movieName) {
		
		Ticket ticket = new BookingHandlerImpl().bookTicket(movieName);
		
		if (ticket != null) {
			return Response.ok().entity(ticket).build();
		
		} else {
		
			return Response.status(404).build();
		}
	}
	
	@GET
	@Path("/book/{detail}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response movieGenre(@PathParam(value = "detail") String detail) {
		
		Movie movie = new BookingHandlerImpl().movieGenre(detail);
		
		if (movie != null) {
			return Response.ok().entity(movie).build();
		
		} else {
		
			return Response.status(404).build();
		}
	}*/
	
	@GET
	@Path("/device/{uuid}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public Response getDevice(@PathParam(value = "uuid") String uuid) {
		
		
		Devices device = new BookingHandlerImpl().getDevice(uuid);

		if (device != null) {
			
			return Response.ok().status(200).entity(device).header("Device", device.getDevice()).build();
		
		}
		
		else {
			
			return Response.status(404).build();

		}
	}
	@GET
	@Path("/user/{user}/{token1}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response getUser(@Context HttpHeaders headers, @PathParam(value = "user") String user, @PathParam(value = "token1") String token1) {
		
		// ArrayList<Logins> userarray = new ArrayList<>();
		Logins user_ = new BookingHandlerImpl().getUser(user);
		Tokens token = new BookingHandlerImpl().getToken(token1);
		
		for(String header : headers.getRequestHeaders().keySet()){
			System.out.println(header);
		}
		
		
		ciphertext = headers.getRequestHeaders().get("Ciphertext");
		
		if (ciphertext != null) {
			
	        plaintext = aesUtil.decrypt(SALT, IV, PASSPHRASE, ciphertext.toString());
			
	        if (plaintext.equals(ORIGINPLAINTEXT)) {
	        
				if (user_ != null && token != null) {
			
				//	userarray.add(user_);
					
						return Response.ok().status(200).entity(user_).header("User", user_.getUuid()).build();		
					
					} else {
				
						return Response.ok().status(404).entity("User is not authorized!").build();
			
					}		
	        
	        } else {
				
	        	return Response.ok().status(403).entity("User is not authorized!").build();
	        	
	        }
			
		} else {
	          throw new CustomNotFoundException("User is not authorized!");
		}

	}
	
	@GET
	@Path("/newuser/{newuser}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response getNewUser(@Context HttpHeaders headers, @PathParam(value = "newuser") String newuser) {
		
		int newuser_ = new BookingHandlerImpl().getNewUser(newuser);
		
		for(String header : headers.getRequestHeaders().keySet()){
			System.out.println(header);
		}
		      
			if (newuser_ > 0) {
				
					return Response.ok().status(412).entity("User name is already taken!").build();		
				
				} else {
			
					return Response.status(200).entity("Okay!").build();
		
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
          throw new CustomNotFoundException("Image not found");
      
      BufferedImage img = ImageIO.read(f);
          
      String mt = new MimetypesFileTypeMap().getContentType(f);
      return Response.ok(img, mt).build();
    }
	
	/*
	@DELETE
	@Path("/book/{ticketId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	
	public Response cancelTicket(@PathParam(value = "ticketId") int ticketId) {
		
		new BookingHandlerImpl().deleteTicket(ticketId);
		
		return Response.ok().build();
	}*/
}
