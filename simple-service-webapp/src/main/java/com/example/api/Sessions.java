package com.example.api;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * MasterPiece :)
 * 
 * @author georgegaspar
 *
 */
@XmlRootElement
@Entity
public class Sessions {
  @Id
  @GeneratedValue(strategy=GenerationType.AUTO)
  private String id;
  private String session;
  private String deviceId;
  
  public Sessions(){
    
  }
  
  public Sessions (String id, String sessionId, String deviceId){
    this.id = id;
    this.session = sessionId;
    this.deviceId = deviceId;
  }
  
  public String getId() {
    return id;
  }
  
  public void setId(String id) {
    this.id = id;
  }
  
  public String getSessions() {
    return session;
  }
  
  public void setSessions(String session) {
    this.session = session;
  }

/**
 * @return the deviceId
 */
public String getDeviceId() {
	return deviceId;
}

/**
 * @param deviceId the deviceId to set
 */
public void setDeviceId(String deviceId) {
	this.deviceId = deviceId;
}
  
  
  
} 