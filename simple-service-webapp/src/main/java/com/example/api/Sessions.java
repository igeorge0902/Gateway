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
  private String description;
  
  public Sessions(){
    
  }
  
  public Sessions (String id, String session){
    this.id = id;
    this.session = session;
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
  
  public String getDescription() {
    return description;
  }
  
  public void setDescription(String description) {
    this.description = description;
  }
  
  
} 