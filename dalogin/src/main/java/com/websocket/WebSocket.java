package com.websocket;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

import javax.websocket.CloseReason;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;

@ServerEndpoint("/jsr356toUpper")
public class WebSocket {

	  private final static String QUEUE_NAME = "hello";

	  
	@OnOpen
	public void onOpen(Session session) throws TimeoutException {
		
		System.out.println("WebSocket opened: " + session.getId());
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
		
		session.getBasicRemote().sendText(txt.toUpperCase());
	}

	@OnClose
	public void onClose(CloseReason reason, Session session) {
		System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());

	}
}
