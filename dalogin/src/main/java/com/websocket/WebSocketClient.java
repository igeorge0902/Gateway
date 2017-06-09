package com.websocket;

import javax.websocket.ClientEndpoint;
import javax.websocket.OnMessage;
import javax.websocket.Session;

@ClientEndpoint(subprotocols="chat")
public class WebSocketClient {
	
	     @OnMessage
	     public void processMessageFromServer(String message, Session session) {
	         System.out.println("Message came from the server ! " + message);
	     }

}
