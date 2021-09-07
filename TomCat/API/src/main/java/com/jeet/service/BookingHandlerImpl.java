package com.jeet.service;

import java.util.ArrayList;
import java.util.List;

import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.api.Tokens;
import com.jeet.db.DAO;

public class BookingHandlerImpl {

	
	public List<Devices> getDevice(String uuid) {
		
		List<Devices> device = DAO.instance().getDevices(uuid);

		return device;
	}
	
	public Logins  getUser(String user)  {
		
		Logins user_ = DAO.instance().getUser(user);

		return user_;
	}
	
	public int getNewUser(String newuser) {
		
		int newuser_ = DAO.instance().getNewUser(newuser);

		return newuser_;
	}
	
	public int getNewEmail(String newemail) {
		
		int newemail_ = DAO.instance().getNewEmail(newemail);

		return newemail_;
	}
	
	public Logins getUuid(String uuid) {
		
		Logins uuid_ = DAO.instance().getUuid(uuid);

		return uuid_;
	}
	
	public Tokens getToken(String token1) {
		
		Tokens token = DAO.instance().getToken(token1);

		return token;
	}
	
	public Tokens getToken2(String token1) {
		
		Tokens token_ = DAO.instance().getToken2(token1);

		return token_;
	}
	
	public List<Devices> getDevice_() {
		
		
		Devices device = new Devices();
		device.setId(1);
		device.setDevice("Samsung");
		device.setUuid("11-11");
		
		Devices device_ = new Devices();
		device_.setId(2);
		device_.setDevice("iPhone");
		device_.setUuid("11-11");
		
		List<Devices> allDevices = new ArrayList<Devices>();
		allDevices.add(device);
		allDevices.add(device_);
		
		
		return allDevices;
	}

}
