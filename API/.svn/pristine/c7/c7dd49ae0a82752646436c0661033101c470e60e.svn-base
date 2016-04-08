package com.jeet.api;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name="Pictures")
public class Pictures {

 @Id
 @GeneratedValue
 @Column(name="PictureId")
 private long id;

 @Column(name="PictureName", nullable=false)
 private String name;

 @Lob
 @Column(name="PictureImage", nullable=false, columnDefinition="mediumblob")
 private byte[] image;

 public long getId() {
  return id;
 }

 public void setId(long id) {
  this.id = id;
 }

 public String getName() {
  return name;
 }

 public void setName(String name) {
  this.name = name;
 }

 public byte[] getImage() {
  return image;
 }

 public void setImage(byte[] image) {
  this.image = image;
 }
}