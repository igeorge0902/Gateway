package com.example.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.example.api.Sessions;

	public class DAO {
	
	private static DAO instance;
	
	
	public static synchronized DAO instance(Set<String> sessions, List<String> deviceId) {
	//	if (instance == null) {
			instance = new DAO(sessions, deviceId);
	//	}
		return instance;
	}
	
	private Map<String, Sessions> sessionProvider = new HashMap<>();
	
	private DAO(Set<String> sessions, List<String> deviceId) {
		
		List <String> sessionIds = new ArrayList<String>();
		sessionIds.addAll(sessions);
		
		for(int i = 0; i < sessionIds.size(); i++) {

				Sessions session_ = new Sessions(Integer.toString(i), sessionIds.get(i), deviceId.get(i));
				sessionProvider.put(Integer.toString(i), session_);
			}
		}
		
	
	public Map<String, Sessions> getModel(){
	    return sessionProvider;
	  }
  
}

