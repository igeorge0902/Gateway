package com.dalogin.utils;


import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import com.dalogin.SQLAccess;


/**
 * @author Crunchify.com
 *
 */
 
public class test {
 
	public final static int THREAD_POOL_SIZE = 5;
	
	private static boolean True;
	public static Map<String, Integer> crunchifyHashTableObject = null;
	public static Map<String, Integer> crunchifySynchronizedMapObject = null;
	//spublic static Map<String, Integer> crunchifyConcurrentHashMapObject = null;
 
	public static void main(String[] args) throws InterruptedException, IOException {
		
      //  String hmacHash = hmac512.getLoginHmac512("g", "g", "g", null, null);

		
	    File f = new File("/Users/georgegaspar/Downloads/test.json");	      
	    if (f.exists() == true) {
       
	    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f));
		BufferedReader br_ = new BufferedReader(new InputStreamReader(bis));

   	    StringBuilder sb_ = new StringBuilder();

		  String str_;
		    while( (str_ = br_.readLine()) != null ){
		        sb_.append(str_);
		    }    
		    JSONObject jObj_ = new JSONObject(sb_.toString());

	        JSONArray companyList = (JSONArray) jObj_.get("seatsToBeReserved");
	        
	      //  System.out.println(values);
	        
		    for (int i = 0; i < companyList.length(); i++) { 
	
		    	JSONObject jObj = new JSONObject(companyList.get(i).toString());
			    
		    	String value = jObj.getString("screeningDateId");
		        String value2 = jObj.getString("seat");
		        
		        List<String> seatList = new ArrayList<>();
				 for (String seat: value2.split("-")){
					 	
					 if (!seat.isEmpty()) {
						 
						 seatList.add(seat);
					 
					 } else {
						 
						 
					 }
					 
				 }
		        
		        System.out.println(value);
		        System.out.println(seatList);
		        
		    	/*
		    	String value = jObj.getString("formatted_address");
		        String value2 = jObj.getString("name");
		        JSONObject value3 = jObj.getJSONObject("geometry");
		        JSONObject value4 = value3.getJSONObject("location");
		        double lng = value4.getDouble("lng");
		        double lat = value4.getDouble("lat");
   		        
		     
		        System.out.println(value);
		        System.out.println(value2);
		        System.out.println(lng);
		        System.out.println(lat);
		        */	    	
		    	
		    }
		
		    br_.close();
	    
	    }
	    
		System.out.println(System.getProperty("user.dir"));
		//EmailValidator em = new EmailValidator();
		True = EmailValidator.validate("");
		System.out.println(String.valueOf(True));
		
	    StringBuilder sb = new StringBuilder();
	    
	    String deviceId = "{\"name\":\"abc\",\"age\":\"21\"}";
	    InputStream in_ = IOUtils.toInputStream(deviceId, "UTF-8");
	    BufferedReader br = new BufferedReader(new InputStreamReader(in_));
	    
	    String str;
	    while( (str = br.readLine()) != null ){
	        sb.append(str);
	    }    
	    JSONObject jObj = new JSONObject(sb.toString());
	    JSONArray stats = jObj.names();

	 //   String name_ = stats.getString(0);
     //   String value_ = jObj.getString("name");
     //   System.out.println(value_);
        
	    for (int i = 0; i < stats.length(); i++) {
	        String name = stats.getString(i);
	        String value = jObj.getString(name);
	        System.out.println(name);
	        System.out.println(value);

	       // JSONObject stat = jObj.getJSONObject(name);

	       // stat.getInt("min");
	       // stat.getInt("max");
	    }
	    
	    String query = "A3-A2";
	    
	    String[] params = query.split("-");

	    for (int i = 0; i < params.length; i++)
	    {
	        String value = params[i];
	        System.out.println(value);
	    }
	    

		/*
		// Test with Hashtable Object
		crunchifyHashTableObject = new Hashtable<String, Integer>();
		crunchifyPerformTest(crunchifyHashTableObject);
 
		// Test with synchronizedMap Object
		crunchifySynchronizedMapObject = Collections.synchronizedMap(new HashMap<String, Integer>());
		crunchifyPerformTest(crunchifySynchronizedMapObject);
 
		// Test with ConcurrentHashMap Object
		Map<String, Integer> crunchifyConcurrentHashMapObject = new ConcurrentHashMap<String, Integer>();
		crunchifyPerformTest(crunchifyConcurrentHashMapObject);
		 */
	}
 
	public static void crunchifyPerformTest(final Map<String, Integer> crunchifyThreads) throws InterruptedException {
 
		System.out.println("Test started for: " + crunchifyThreads.getClass());
		long averageTime = 0;
		for (int i = 0; i < 5; i++) {
 
			long startTime = System.nanoTime();
			ExecutorService crunchifyExServer = Executors.newFixedThreadPool(THREAD_POOL_SIZE);
 
			for (int j = 0; j < THREAD_POOL_SIZE; j++) {
				crunchifyExServer.execute(new Runnable() {
					@SuppressWarnings("unused")
					@Override
					public void run() {
 
						for (int i = 0; i < 500000; i++) {
							Integer crunchifyRandomNumber = (int) Math.ceil(Math.random() * 550000);
 
							// Retrieve value. We are not using it anywhere
							Integer crunchifyValue = crunchifyThreads.get(String.valueOf(crunchifyRandomNumber));
 
							// Put value
							crunchifyThreads.put(String.valueOf(crunchifyRandomNumber), crunchifyRandomNumber);
						}
					}
				});
			}
 
			// Make sure executor stops
			crunchifyExServer.shutdown();
 
			// Blocks until all tasks have completed execution after a shutdown request
			crunchifyExServer.awaitTermination(Long.MAX_VALUE, TimeUnit.DAYS);
 
			long entTime = System.nanoTime();
			long totalTime = (entTime - startTime) / 1000000L;
			averageTime += totalTime;
			System.out.println("2500K entried added/retrieved in " + totalTime + " ms");
		}
		System.out.println("For " + crunchifyThreads.getClass() + " the average time is " + averageTime / 5 + " ms\n");
	}
	
	
}