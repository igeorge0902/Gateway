package com.jeet.rest;

import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.service.BookingHandlerImpl;
import com.jeet.utils.AesUtil;
import com.jeet.utils.CustomNotFoundException;
import jakarta.enterprise.context.RequestScoped;
import jakarta.enterprise.context.SessionScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.*;
import org.json.JSONObject;

import jakarta.activation.MimetypesFileTypeMap;
import javax.imageio.ImageIO;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.text.ParseException;
import java.util.List;

@RequestScoped
@Path("/")
public class BookController extends Application implements Serializable {
	
    private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    private static volatile String ciphertext;
    private static volatile Cookie[] cookies;
    private static volatile String xsrfToken;
    private static volatile Boolean xsrf;
    private static volatile String plaintext;
    private static final String ORIGINPLAINTEXT = "G";
    private static final String PASSPHRASE = "SecretPassphrase";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;
    private static AesUtil aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);

	@GET
	@Path("/device/{uuid}")
	@Produces({ MediaType.APPLICATION_JSON })
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
	@Produces({ MediaType.APPLICATION_JSON })
	public Response getUser(@Context HttpServletRequest request, @Context HttpHeaders headers, @PathParam(value = "user") String user) throws ParseException {

		String token2 = request.getHeader("X-Token");

		JSONObject myObject_user = new JSONObject();
		Object myObject = null;

		if(request.getAttribute("Error Details") != null) {
        myObject = request.getAttribute("Error Details");
		JSONObject myObject_ = new JSONObject(myObject.toString());
		myObject_user.append("Error Details", myObject_);
		}

		Logins user_ = new BookingHandlerImpl().getUser(user);

		myObject_user.put("uuid", user_.getUuid());
		myObject_user.put("user", user_.getUser());
		myObject_user.put("email", user_.getEmail());

	        
				if (user_.getId() != 0) {
					if (myObject != null) {

						return Response.ok().status(300).entity(myObject_user.toString())
								.header("User", user_.getUuid()).header("X-Token", token2).build();	
						} else {
							return Response.ok().status(200).entity(myObject_user.toString())
									.header("User", user_.getUuid()).build();
						}
					
					} else {
				
						return Response.ok().status(Response.Status.PRECONDITION_FAILED).entity(user_).build();
			}
	}
	
	@GET
	@Path("/newuser/{newuser}")
	@Produces({ MediaType.APPLICATION_JSON })
	public Response getNewUser(@PathParam(value = "newuser") String newuser) {
		
		int newuser_ = new BookingHandlerImpl().getNewUser(newuser);
		   
		   JSONObject myObject = new JSONObject();		   
		   myObject.put("name", "My name is...");
		   
			if (newuser_ > 0) {

					return Response.ok().status(412).entity(myObject.toString()).type(MediaType.APPLICATION_JSON).build();		
				
				} else {
			
					return Response.status(200).entity(myObject.toString()).build();
		
				}		
    
	}
	
	@GET
	@Path("/newemail/{newemail}")
	@Produces({ MediaType.APPLICATION_JSON })
	public Response getNewEmail(@PathParam(value = "newemail") String newemail) {
		
		int newuser_ = new BookingHandlerImpl().getNewEmail(newemail);
		   
		   JSONObject myObject = new JSONObject();		   
		   myObject.put("name", "My email is...");
		   
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
