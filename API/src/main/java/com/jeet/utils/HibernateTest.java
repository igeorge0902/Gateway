package com.jeet.utils;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SessionFactory;
import org.hibernate.stat.Statistics;
import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.db.DAO;
import com.jeet.db.HibernateUtil;
import com.jeet.service.BookingHandlerImpl;

public class HibernateTest {

	public static void main(String[] args) throws Exception {

		SessionFactory factory = HibernateUtil.getSessionFactory();

		Statistics stats = factory.getStatistics(); 
		stats.setStatisticsEnabled(true);		

		BookingHandlerImpl bh = new BookingHandlerImpl();
		
		List<Devices> device = bh.getDevice("f");
		Logins user = bh.getUser("II");
		
		if(user.getId() !=0) {
			System.out.println("hello");
		} else {
			
			System.out.println("no user");
		}
		
		
        stats.logSummary();
        stats.getSecondLevelCacheStatistics("movies");
        

	}
	
}

/*
Object [] obj = movies3.toArray();
Object [] obs = null;
Object obb = null;

for (int i = 0; i < obj.length; i++) {
	obs = (Object[]) obj[i];

for (int j = 0; j < obs.length; j++) {
	
	Movie m = (Movie) obs[0];
	obb = obs[j]; 
System.out.println(obb);
	}

}
*/