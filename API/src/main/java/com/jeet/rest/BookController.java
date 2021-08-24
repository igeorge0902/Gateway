package com.jeet.rest;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import javax.activation.MimetypesFileTypeMap;
import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
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

import org.json.JSONObject;

import com.concretepage.StudentClient;
import com.concretepage.StudentClient2;
import com.concretepage.wsdl.GetStudentResponse;
import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.api.Tokens;
import com.jeet.db.HibernateUtil;
import com.jeet.service.BookingHandlerImpl;
import com.jeet.utils.AesUtil;
import com.jeet.utils.CustomNotFoundException;

@Path("/")
public class BookController {
	
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
	
	public Response getUser(@Context HttpServletRequest request, @Context HttpHeaders headers, @PathParam(value = "user") String user) throws ParseException {
		
		try{
		    //you can call it from behind any Servlet or dispatchedRequest to REST endpoint
			StudentClient studentClient = HibernateUtil.ctx.getBean(StudentClient.class);
			System.out.println("For Student Id: 1");
			
			//actual logic goes here. Have your entity ready to set it with the received 
			//SOAP response to finally pass it the REST response. Bend it like Beckham.
			GetStudentResponse response1 = studentClient.getStudentById(1);
			System.out.println("Name:"+response1.getStudent().getName());
			System.out.println("Age:"+response1.getStudent().getAge());
			System.out.println("Class:"+response1.getStudent().getClazz());

			
			StudentClient2 studentClient2 = HibernateUtil.ctx.getBean(StudentClient2.class);
			System.out.println("For Student Id: 2");
			
			GetStudentResponse response2 = studentClient2.getStudentById(2);
			System.out.println("Name:"+response2.getStudent().getName());
			System.out.println("Age:"+response2.getStudent().getAge());
			System.out.println("Class:"+response2.getStudent().getClazz());
			} catch (Exception e) {
				System.out.println("SOAP is down!");
			}
		
		Logins user_ = new BookingHandlerImpl().getUser(user);
	        
				if (user_.getId() != 0) {
								
						return Response.ok().status(200).entity(user_).header("User", user_.getUuid()).build();		
					
					} else {
				
						return Response.ok().status(Status.PRECONDITION_FAILED).entity(user_).build();
			}
	}
	
	@GET
	@Path("/newuser/{newuser}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
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
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
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
