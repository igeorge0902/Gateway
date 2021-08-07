/**
 * 
 */
package com.jeet.api;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * @author georgegaspar
 *
 *	<br><br>
 *	Used to save purchases for user.
 *
 */
@Entity
public class Purchase implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7691131736435222234L;

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
    protected int purchaseId;
    
	protected String uuid;
	
	protected String orderId;
		
	@Temporal(TemporalType.TIMESTAMP)
    protected Date TIME_;
	
	/**
	 * Do not use CascadeType.REMOVE, because it will remove the whole purchase once a corresponding ticket is deleted!
	 */
    @OneToMany(mappedBy="purchase", cascade={/*CascadeType.REMOVE,*/ CascadeType.PERSIST, CascadeType.REFRESH}, fetch=FetchType.EAGER)
    protected List<Ticket> ticket;

    
    public Purchase() {
    }
    
    public Purchase(int purchaseId, String uuid) {
    	this.purchaseId = purchaseId;
    	this.uuid = uuid;
    }
    
	/**
	 * @return the purchaseId
	 */
	public int getPurchaseId() {
		return purchaseId;
	}

	/**
	 * @param purchaseId the purchaseId to set
	 */
	public void setPurchaseId(int purchaseId) {
		this.purchaseId = purchaseId;
	}

	/**
	 * @return the uuid
	 */
	public String getUuid() {
		return uuid;
	}

	/**
	 * @param uuid the uuid to set
	 */
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	/**
	 * Returns the tickets for a given purchase.
	 * 
	 * @return
	 */
    public List<Ticket> getTicketsForPurchase() {
        if (ticket == null) {
            ticket = new ArrayList<Ticket>();
        }
        return this.ticket;
    }

	/**
	 * @return the orderId
	 */
	public String getOrderId() {
		return orderId;
	}

	/**
	 * @param orderId the orderId to set
	 */
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	/**
	 * @return the time
	 */
	public Date getTime() {
		return TIME_;
	}

	/**
	 * @param time the time to set
	 */
	public void setTime(Date time) {
		TIME_ = time;
	}

	/**
	 * @return the ticket
	 */
	public List<Ticket> getTicket() {
		return ticket;
	}

	/**
	 * @param ticket the ticket to set
	 */
	public void setTicket(List<Ticket> ticket) {
		this.ticket = ticket;
	}
   
}
