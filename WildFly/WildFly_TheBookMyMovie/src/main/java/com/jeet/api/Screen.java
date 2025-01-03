//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.07.06 at 03:49:17 PM IST 
//


package com.jeet.api;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Screen implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 8446331570761659788L;
	
	@Id
    protected String screenId;
    protected int seats;
    /**
    * Any movies to one screen 
    */
    @ManyToOne(cascade={CascadeType.PERSIST, CascadeType.REFRESH}, fetch=FetchType.EAGER)
    @JoinColumn(name="movie_movieId")
    protected Movie movie;
    @OneToOne(cascade=CascadeType.ALL, fetch=FetchType.EAGER)
    protected ScreeningDates screeningDates;
    @OneToMany(mappedBy="screen", cascade=CascadeType.ALL, fetch=FetchType.EAGER)
    protected List<Seats> seat;

    /**
     * Gets the value of the screenId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getScreenId() {
        return screenId;
    }

    /**
     * Sets the value of the screenId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setScreenId(String value) {
        this.screenId = value;
    }

    /**
     * Gets the value of the seats property.
     * 
     */
    public int getSeats() {
        return seats;
    }

    /**
     * Sets the value of the seats property.
     * 
     */
    public void setSeats(int value) {
        this.seats = value;
    }

    /**
     * Gets the value of the movie property.
     * 
     * @return
     *     possible object is
     *     {@link Movie }
     *     
     */
    public Movie getMovie() {
        return movie;
    }

    /**
     * Sets the value of the movie property.
     * 
     * @param value
     *     allowed object is
     *     {@link Movie }
     *     
     */
    public void setMovie(Movie value) {
        this.movie = value;
    }

    /**
     * Gets the value of the seat property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the seat property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getSeatsForScreen().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Seats }
     * 
     * 
     */
    public List<Seats> getSeatsForScreen() {
        if (seat == null) {
            seat = new ArrayList<Seats>();
        }
        return this.seat;
    }
    
	/**
	 * @param seat the seats to set
	 */
	public void setSeats(List<Seats> seat) {
		this.seat = seat;
	}

	/**
	 * @return the screeningDates
	 */
	public ScreeningDates getScreeningDates() {
		return screeningDates;
	}

	/**
	 * @param screeningDates the screeningDates to set
	 */
	public void setScreeningDates(ScreeningDates screeningDates) {
		this.screeningDates = screeningDates;
	}

}
