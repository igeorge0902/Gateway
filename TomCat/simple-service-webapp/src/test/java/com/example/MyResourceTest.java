package com.example;

import javax.ws.rs.client.AsyncInvoker;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.grizzly.http.server.HttpServer;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

public class MyResourceTest {

    private HttpServer server;
    private WebTarget target;

    @Before
    public void setUp() throws Exception {
        // start the server
        server = Main.startServer();
        // create the client
        Client c = ClientBuilder.newClient();

        // uncomment the following line if you want to enable
        // support for JSON in the client (you also have to uncomment
        // dependency on jersey-media-json module in pom.xml and Main.startServer())
        // --
        // c.configuration().enable(new org.glassfish.jersey.media.json.JsonJaxbFeature());

        target = c.target(Main.BASE_URI);
    }

    @After
    public void tearDown() throws Exception {
        server.shutdownNow();
    }

    
    /**
     * Test to see that the message "Got it!" is sent in the response.
     * @throws ExecutionException 
     * @throws InterruptedException 
     */
    
    
    @Test
    public void testGetIt() throws InterruptedException, ExecutionException {
    	
    	final AsyncInvoker asyncInvoker = target.path("myresource")
    	        .request().async();
    	final Future<Response> responseFuture = asyncInvoker.get();
    	System.out.println("Request is being processed asynchronously.");
    	final Response response = responseFuture.get();
    	    // get() waits for the response to be ready
    	System.out.println("Response received.");
    	
    	System.out.println(response.toString());

    	/*
        String responseMsg = target.path("myresource").request().get(String.class);
        assertEquals("Got it!", responseMsg);
    	System.out.println(target.getUri());
        System.out.println(responseMsg);
       */
    }
    
    
    
    @Test
    public void testGetImage() {
    	
    	WebTarget images = target.path("resource");
    	//WebTarget image = images.path("Bp-1.jpg");
    	Invocation.Builder invocationBuilder = images.request(MediaType.MEDIA_TYPE_WILDCARD);
    	Response response = invocationBuilder.get();
    	
    	System.out.println(images.getUri());
    	System.out.println(response.getStatus());    	

    }
}
