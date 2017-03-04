package com.dalogin.listeners;



/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.Serializable;
import java.util.Collection;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import org.apache.log4j.Logger;

import com.google.common.collect.SetMultimap;
import com.dalogin.SQLAccess;


/**
 * 
 * Listener to manage session attributes, session creation. 
 * 
 * Session is bound to deviceId, i.e. one device with identical id will always have one session.
 * Session-based calls for sensitive data are verified with tokens, therefore over-spawning sessionIds 
 * at extreme condition are not considered an issue because the dB will store/overwrite the tokens for the same device id with the last sessionId.
 *  
 * It is guaranteed to work in normal conditions. 
 *
 */
@WebListener
public class CustomHttpSessionListener extends HttpServlet implements HttpSessionListener, Serializable, HttpSessionAttributeListener {

	private static final long serialVersionUID = -6951824749917799153L;
	
	private static Logger log = Logger.getLogger(Logger.class.getName());
	
	public static volatile ConcurrentHashMap<String, HttpSession> activeUsers;
	private static volatile SetMultimap<String, String> sessions;
	private static volatile TreeMap<String,String> attributes = new TreeMap<String, String>();
	private static volatile TreeMap<String,String> attributes_ = new TreeMap<String, String>();
	private static volatile Set<String> sessionData;
	private static volatile String id;
	private static volatile String name;
	private static volatile String value;
	private static volatile String D;
	private static volatile String D_;
	private static volatile String G;
	private static volatile String G_;
	private static volatile String useR;
	private static volatile String g;


    public void init(ServletConfig config){
    	
    }

    /**
     * Returns a TreeMap with a name - value entry of a given attribute.
     * 
     * @param name
     * @param value
     * @return attributes
     */
    private TreeMap<String,String> SetMappings(String name, String value) {
    		    	
    		attributes.put(name, value);
   
    		Collection<String> fruits = attributes.values();    		
    		log.info("Values: " + fruits);
    		
        	return 	attributes;
    	}

    
    /**
     * Returns the value of the given attribute name.
     * 
     * @param name
     * @return G
     */
    private String GetMappings(String name) {
    	
    	G = attributes.get(name);
    	return 	G;
    }
    
    /**
     * Returns a TreeMap with a name - value entry of a given attribute.
     * 
     * @param name
     * @param value
     * @return attributes_
     */
    private TreeMap<String,String> SetMappings_(String name, String value) {
    	
    	attributes_.put(name, value);
		
    	Collection<String> fruits_ = attributes_.values();		
		log.info("Values_: " + fruits_);

		return 	attributes_;
    }
    
    /**
     * Returns the value of the given attribute name.
     * 
     * @param name
     * @return G_
     */
    private String GetMappings_(String name) {
    	
    	G_ = attributes_.get(name);
    	return 	G_;
    }

    /** Session attribute changes **/
	@SuppressWarnings("unchecked")
	@Override
	public void attributeAdded(HttpSessionBindingEvent se) {
		
	    HttpSession session = se.getSession();
	    ServletContext context = session.getServletContext();
        activeUsers = (ConcurrentHashMap<String, HttpSession>) context.getAttribute("activeUsers");
        sessions = (SetMultimap<String, String>) context.getAttribute("sessions");

	    id = session.getId();
	    name = se.getName();
	    value = (String)se.getValue();
	    
	    log.info("Name: " + attributes.keySet() + "Value: " + attributes.values());
	    
	    String source = se.getSource().getClass().getName();
	    String message = new StringBuffer("Attribute bound to session in ")
	        .append(source).append("\nThe attribute name: ").append(name)
	        .append("\n").append("The attribute value:").append(value)
	        .append("\n").append("The session ID: ").append(id).toString();
	    log.info(message);		
	    
	 SetMappings(name, value);
	    
   	 D = GetMappings("deviceId");
     useR = GetMappings("user");
    
     // last step - we check if we have the deviceId already. If so, we try to remove its sessionId, if not yet concluded.
      if (sessions.containsKey(D)) {
 
     sessionData = sessions.get(D);
     
  // Synchronizing on multimap, not values!
     synchronized (sessions) {  
    	 
    	// TODO: the set is not ordered, it is relevant only if we want to use an ordered set.
         // the value g might not be always the sessionId
    	g = sessionData.toArray()[1].toString();
    	try {
    	
    		activeUsers.remove(g);
    		
    	} catch (Exception e) {
    	    log.info("SessionId "+g+" does not exist anymore.");		

    		}
  		
    	sessionData.clear();
  		sessionData.add(useR);
  		sessionData.add(id);
     
     }
      
          } else {
        	  
            activeUsers.put(id, session);
            
            // It will be null at first time. 
            try {
            	sessions.put(D, useR);
            	sessions.put(D, id);
            	} catch (Exception e) {
            		log.info(e.getMessage());
            }

          }
     
      context.setAttribute("activeUsers", activeUsers);
      context.setAttribute("sessions", sessions);
      
     log.info("SessionUsers: " + sessions.entries());
     log.info("Active UserSessions (attribute Added): " + activeUsers.keySet().toString());
     
	}

	/** Session attribute changes **/
	@Override
	public void attributeRemoved(HttpSessionBindingEvent se) {
	   
		HttpSession session = se.getSession();

	    id = session.getId();
	    name = se.getName();
	    if (name == null)
	      name = "Unknown";
	    value = (String) se.getValue();

	    String source = se.getSource().getClass().getName();
	    String message = new StringBuffer("Attribute unbound from session in ")
	        .append(source).append("\nThe attribute name: ").append(name)
	        .append("\n").append("The attribute value: ").append(value)
	        .append("\n").append("The session ID: ").append(id).toString();
	    log.info(message);	
	    
	    SetMappings_(name, value);
        D_ = GetMappings_("deviceId");

        // first step, before handshake &new session creation (still doesn't solve the over-spawning session ids at extreme condition)
        // removes session by id from context
        activeUsers.remove(id);
        log.info("deviceId_ &sessioId at remove: "+D_ + "," + id);

        try{
        	// removes deviceId from helper list (sessions Multimap is a helper list, but is able to list the active users )
        	sessions.removeAll(D_);
        		} catch (Exception e) {
			// error handling for empty leafs
        	log.info("There was no device left over to remove...");
        		}
        
        log.info("SessionUsers (attributeRemoved): " + sessions.entries());


	}

	/** Session attribute changes **/
	@Override
	public void attributeReplaced(HttpSessionBindingEvent arg0) {
		
	}
    
    /**
     * Adds sessions to the context ConcurrentHashMap on context when they are created..
     */
    @SuppressWarnings("unchecked")
	public void sessionCreated(HttpSessionEvent event){
    	
    	HttpSession session = event.getSession();

        ServletContext context = session.getServletContext();
        log.info("Context attributes: " + context.getAttributeNames().nextElement());
        // ConcurrentHashMap in context to hold sessions
        activeUsers = (ConcurrentHashMap<String, HttpSession>) context.getAttribute("activeUsers");
        // SetMultimap helper list in context to hold values bound to deviceId as key
        sessions = (SetMultimap<String, String>) context.getAttribute("sessions");
               	
	    	 D = GetMappings("deviceId");
	         
	         if (!sessions.containsKey(D)) {
	         	
	         	activeUsers.put(session.getId(), session);
	        	log.info("sessionId addded in event context: " + session.getId());

	         } 
	         
	         else {
	        	 
	             sessionData = sessions.get(D);
	             
	             // Synchronizing on multimap, not values!
	                synchronized (sessions) {  
	               	 
	                // TODO: the set is not ordered, it is relevant only if we want to use an ordered set.
	                // the value g might not be always the sessionId	
	               	g = sessionData.toArray()[1].toString();
		        	log.info("sessionId to remove in event context: " + g);

	               	activeUsers.remove(g);

	                }

	         	activeUsers.put(session.getId(), session);
	        	log.info("sessionId addded in event context (else): " + session.getId());

	         	
	         } 	         
	      
        context.setAttribute("activeUsers", activeUsers);
        context.setAttribute("sessions", sessions);
      
        log.info("Active UserSessions (session Created): " + activeUsers.keySet().toString());
    	
    }

    /**
     * Destroy sessions from ConcurrentHashMap on context when they expire
     * or are invalidated.
     */
    @SuppressWarnings("unchecked")
	public void sessionDestroyed(HttpSessionEvent event){
        
    	HttpSession session = event.getSession();
    	try {
        ServletContext context = session.getServletContext();
        activeUsers = (ConcurrentHashMap<String, HttpSession>)context.getAttribute("activeUsers");
        sessions = (SetMultimap<String, String>)context.getAttribute("sessions");
        D_ = session.getAttribute("deviceId").toString();
        id = session.getId();
        log.info("deviceId_ at destroy: "+D_);
        
       // try {
        	SQLAccess.logout(id, context);
	        log.info("SessionID destroyed: " + id.toString());          
			
        	} catch (Exception e) {
        		
        		log.info(e.getMessage());
		}


            activeUsers.remove(session.getId());
            
            try {
            	sessions.removeAll(D_);
            		} catch (Exception e) {
            			// error handling for empty leafs
            			log.info("There was no device left over to remove...");
            		}
            
            log.info("device logging out from SessionUsers: " + D_);
            
            log.info("SessionUsers left: " + sessions.entries());
            log.info("Active UserSessions left: " + activeUsers.keySet().toString());
          
    
          String message = new StringBuffer("Session destroyed"
              + "\nValue of destroyed session ID is").append(" " + id).append(
              "\n").append("There are now ").append("" + activeUsers.size())
              .append(" live sessions in the application.").toString();
          log.info(message);
          
        
    }
   

}