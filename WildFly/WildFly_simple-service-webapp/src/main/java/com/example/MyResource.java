 package com.example;

 import com.example.api.Sessions;
 import com.example.dao.DAO;
 import com.example.interceptors.Compress;
 import com.utils.CustomNotFoundException;
 import jakarta.activation.MimetypesFileTypeMap;
 import jakarta.enterprise.context.RequestScoped;
 import jakarta.ws.rs.GET;
 import jakarta.ws.rs.Path;
 import jakarta.ws.rs.PathParam;
 import jakarta.ws.rs.Produces;
 import jakarta.ws.rs.core.*;

 import jakarta.servlet.ServletContext;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 import jakarta.servlet.http.HttpSession;

 import javax.imageio.ImageIO;
 import java.awt.image.BufferedImage;
 import java.io.*;
 import java.util.ArrayList;
 import java.util.List;
 import java.util.Set;
 import java.util.concurrent.ConcurrentHashMap;


/**
 * Root resource (exposed at "myresource" path)
 */
@RequestScoped
@Path("/")
public class MyResource extends Application {
	
	private static volatile HttpSession session;

    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public Response getString () throws Exception {
    	String string = "Got it";
        return Response.ok().entity(string).build();
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
      byte[] bytes = new byte[(int) f.length()];
      
      if (f.exists() == false) 
        throw new CustomNotFoundException("Image not found");
      
      BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f));
      BufferedImage images = ImageIO.read(bis);
      ByteArrayOutputStream baos = new ByteArrayOutputStream(bytes.length);
      ImageIO.write(images, "jpg", baos);
      
      byte[] imageData = baos.toByteArray();  
      
       String mt = new MimetypesFileTypeMap().getContentType(f);
       return Response.ok(new ByteArrayInputStream(imageData), mt).build();
    }
    
    //TODO: refactor!
    @GET
    @Path("/images/movies/{image}")
    @Produces("image/*")
    public Response getMovieImages(
    		@Context HttpHeaders header,
    		@Context HttpServletResponse response,
    		@PathParam("image") String image) throws IOException {
    	    
      response.setContentType("images/jpg");
      File f = new File("/Users/georgegaspar/Pictures/movies/" + image);
      byte[] bytes = new byte[(int) f.length()];
      
      if (f.exists() == false) 
        throw new CustomNotFoundException("Image not found");

      BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f));
      BufferedImage images = ImageIO.read(bis);
      ByteArrayOutputStream baos = new ByteArrayOutputStream(bytes.length);
      ImageIO.write(images, "jpg", baos);
      
      byte[] imageData = baos.toByteArray();  
      
       String mt = new MimetypesFileTypeMap().getContentType(f);
       return Response.ok(new ByteArrayInputStream(imageData), mt).build();
    }
    
    @GET
    @Path("/images/venues/{image}")
    @Produces("image/*")
    public Response getVenueImages(
    		@Context HttpHeaders header,
    		@Context HttpServletResponse response,
    		@PathParam("image") String image) throws IOException {
    	
      response.setContentType("images/jpg");
      File f = new File("/Users/georgegaspar/Pictures/venues/" + image);
      byte[] bytes = new byte[(int) f.length()];
      
      if (f.exists() == false) 
        throw new CustomNotFoundException("Image not found");

      BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f));
      BufferedImage images = ImageIO.read(bis);
      ByteArrayOutputStream baos = new ByteArrayOutputStream(bytes.length);
      ImageIO.write(images, "jpg", baos);
      
      byte[] imageData = baos.toByteArray();  
      
       String mt = new MimetypesFileTypeMap().getContentType(f);
       return Response.ok(new ByteArrayInputStream(imageData), mt).build();
    }
    
    //TODO: add pagination
    @SuppressWarnings("unchecked")
	@GET
    @Compress
    @Path("/admin")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSessions(
    		@Context HttpHeaders header,
    		@Context HttpServletResponse response,
    		@Context HttpServletRequest request,
    		@Context ServletContext context) throws IOException {
    	
    	List<Sessions> sessions_ = new ArrayList<Sessions>();
        ServletContext otherContext = context.getContext("/login");

        ConcurrentHashMap<String, HttpSession> activeUsers = new ConcurrentHashMap<String, HttpSession>();
        activeUsers = (ConcurrentHashMap<String, HttpSession>)otherContext.getAttribute("activeUsers");
        
        Set<String> sessions = activeUsers.keySet();               
        List<String> devices = new ArrayList<String>();
        
        for (String sessionId : sessions) {

        	session = activeUsers.get(sessionId);          
        	
        	try {
            	
        		devices.add(session.getAttribute("deviceId").toString());
                sessions_.addAll(DAO.instance(sessions, devices).getModel().values());

        	} catch (Exception e) {
        		
        		}
        	
        	}
                
		return Response.ok().status(200).entity(sessions_).build();
    }
    
}

