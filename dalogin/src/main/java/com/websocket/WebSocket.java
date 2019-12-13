package com.websocket;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.TimeoutException;

import javax.websocket.CloseReason;
import javax.websocket.Endpoint;
import javax.websocket.EndpointConfig;
import javax.websocket.MessageHandler;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.SendHandler;
import javax.websocket.SendResult;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;

@ServerEndpoint("/jsr356toUpper")
public class WebSocket extends Endpoint implements SendHandler{

	  private final static String QUEUE_NAME = "hello";
	
	@OnOpen
    public void onOpen(Session session, EndpointConfig config) {
  
		System.out.println("WebSocket opened: " + session.getId());
		
        session.addMessageHandler(String.class, new MessageHandler.Whole<String>() {
        	
            public void onMessage(String text) {
                try {
                	session.getBasicRemote().sendText("Got your message (" + text + "). Thanks !");
                } catch (IOException ioe) {
            		System.out.println("WebSocket error: " + ioe.getCause().toString());
                }
            }
        });
        
    }
	
	
	@OnMessage
	public void onMessage(String txt, Session session) throws IOException, TimeoutException {
		System.out.println("Message received: " + txt);
		
		try {
		    ConnectionFactory factory = new ConnectionFactory();
		    factory.setHost("localhost");
		    Connection connection = factory.newConnection();
		    Channel channel = connection.createChannel();

		    channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		    String message = "Hello World!";
		    channel.basicPublish("", QUEUE_NAME, null, message.getBytes("UTF-8"));
		    System.out.println(" [x] Sent '" + message + "'");
			

		} catch (IOException e) {
			System.out.println("RabbitMQ failed");
		}
		
		ByteArrayOutputStream bOutput = new ByteArrayOutputStream();

	      bOutput.write(txt.getBytes());  
	    
	      byte b [] = bOutput.toByteArray();
	      bOutput.close();
	      session.getBasicRemote().sendBinary(ByteBuffer.wrap(b));
	}

	@OnClose
	public void onClose(CloseReason reason, Session session) {
		System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());

	}

	@Override
	public void onResult(SendResult result) {
	    System.out.println(" [x] Error ");
		
	}
}

