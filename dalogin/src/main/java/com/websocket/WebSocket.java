package com.websocket;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.websocket.CloseReason;
import javax.websocket.Endpoint;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.SendHandler;
import javax.websocket.SendResult;
import javax.websocket.Session;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpoint;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Consumer;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Channel;

@ServerEndpoint(value="/jsr356toUpper", configurator=ServletAwareConfig.class)
public class WebSocket extends Endpoint implements SendHandler{

	  private final static String QUEUE_NAME = "hello";
	  private EndpointConfig config;
	  static ScheduledExecutorService timer = Executors.newSingleThreadScheduledExecutor(); 	 
	  private static Set<Session> allSessions; 
	  DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
	  static Channel channel;
	  private volatile static String message = "";

	@OnOpen
    public void onOpen(Session session, EndpointConfig config) {
		this.config = config;

		HandshakeRequest req = (HandshakeRequest) config.getUserProperties().get("handshakereq");
		Map<String,List<String>> headers = req.getHeaders();
	    
		ConnectionFactory factory = new ConnectionFactory();
	    factory.setHost("localhost");
	    Connection connection;
		try {
			connection = factory.newConnection();
	        channel = connection.createChannel();
	        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
	        System.out.println(" [*] Waiting for messages. To exit press CTRL+C");
		
		} catch (IOException | TimeoutException e) {
			e.printStackTrace();
		}
	
	      allSessions = session.getOpenSessions();
	      
	      // start the scheduler on the very first connection
	      // to call sendTimeToAll every second   
	      if (allSessions.size()==1){   

	        timer.scheduleAtFixedRate(() -> sendRabbitMQMessage(session),5,5,TimeUnit.SECONDS);    
	      }
		System.out.println("WebSocket opened: " + session.getId());

    }
	
	
	@OnMessage
	public void onMessage(String txt, Session session) throws IOException, TimeoutException {
		System.out.println("Message received: " + txt);
		
		HttpSession httpSession = (HttpSession) config.getUserProperties().get("httpSession");
        ServletContext servletContext = httpSession.getServletContext();
		
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
      	  session.getBasicRemote().sendText("Got your message (" + txt + "). Thanks !");

	}

	@OnClose
	public void onClose(CloseReason reason, Session session) {
		System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());

	}

	@Override
	public void onResult(SendResult result) {
	    System.out.println(" [x] Error ");
		
	}
	
	private void sendTimeToAll(Session session){       

		allSessions = session.getOpenSessions();
		     for (Session sess: allSessions){          
		        try{   
		          sess.getBasicRemote().sendText("Local time: " + 
		                    LocalTime.now().format(timeFormatter));
		          } catch (IOException ioe) {        
		              System.out.println(ioe.getMessage());         
		          }   
		     }   
	}
	
	private void sendRabbitMQMessage(Session session) {

	    
		allSessions = session.getOpenSessions();
		
	    Consumer consumer = new DefaultConsumer(channel) {
	        @Override
	        public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body)
	            throws IOException {
	          message = new String(body, "UTF-8");
	          System.out.println(" [x] Received '" + message + "'");
	 	     for (Session sess: allSessions){          
	 	        try{   
	 	          sess.getBasicRemote().sendText(message);
	 	          } catch (IOException ioe) {        
	 	              System.out.println(ioe.getMessage());         
	 	          }   
	 	     } 
	        }
	      };
	      try {
			channel.basicConsume(QUEUE_NAME, true, consumer);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
}