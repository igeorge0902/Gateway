package com.example.dao;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import com.example.api.Sessions;

	public class DAO {
	
	private static DAO instance;
	
	
	public static synchronized DAO instance(Set<String> sessions) {
	//	if (instance == null) {
			instance = new DAO(sessions);
	//	}
		return instance;
	}
	
	private Map<String, Sessions> sessionProvider = new HashMap<>();
	
	private DAO(Set<String> sessions) {
		
		Integer i = new Integer( 1 );
		
		for (String session : sessions) {
		    Sessions session_ = new Sessions(Integer.toString(i++), session);
			sessionProvider.put(Integer.toString(i++), session_);
		}
		
	}
	
	public Map<String, Sessions> getModel(){
	    return sessionProvider;
	  }
  
}

