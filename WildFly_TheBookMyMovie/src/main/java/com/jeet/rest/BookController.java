package com.jeet.rest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.NewCookie;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.Response.StatusType;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import com.braintreegateway.BraintreeGateway;
import com.braintreegateway.ClientTokenRequest;
import com.braintreegateway.CreditCardVerification;
import com.braintreegateway.Customer;
import com.braintreegateway.CustomerRequest;
import com.braintreegateway.Environment;
import com.braintreegateway.PaymentMethod;
import com.braintreegateway.PaymentMethodNonce;
import com.braintreegateway.PaymentMethodRequest;
import com.braintreegateway.Result;
import com.braintreegateway.Transaction;
import com.braintreegateway.TransactionRequest;
import com.braintreegateway.ValidationError;
import com.braintreegateway.ValidationErrors;
import com.braintreegateway.exceptions.NotFoundException;
import com.jeet.api.Location;
import com.jeet.api.Movie;
import com.jeet.api.Purchase;
import com.jeet.api.Screen;
import com.jeet.api.ScreeningDates;
import com.jeet.api.Seats;
import com.jeet.api.Ticket;
import com.jeet.api.Venues;
import com.jeet.service.BookingHandlerImpl;
import com.jeet.utils.AesUtil;
import com.jeet.utils.CustomExceptions;
import com.jeet.utils.CustomNotFoundException;

//TODO: add APIKEY container request filter
/*
 * https://eclipse-ee4j.github.io/jersey.github.io/documentation/latest/filters-and-interceptors.html#d0e9368
 */
//TODO: error handling
/*
 * https://eclipse-ee4j.github.io/jersey.github.io/documentation/latest/representations.html#d0e6367
 */
@SuppressWarnings("unused")
@Path("/")
public class BookController {
	
	private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
    private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
    private static volatile String ciphertext;
    private static volatile String uuid;
    private static volatile String orderId;
    private static volatile String xsrfToken;
    private static volatile Boolean xsrf;
    private static volatile Cookie[] cookies;
    private static volatile String plaintext;
    private static final String ORIGINPLAINTEXT = "G";
    private static final String PASSPHRASE = "SecretPassphrase";
    private static final int KEYSIZE = 128;
    private static final int ITERATIONCOUNT = 1000;   
    private static AesUtil aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
    private static volatile String APIKEY = "19891213";
    private static volatile String c;
    private static volatile String seatsToBeReserved;
    private static volatile String ticketsToBeCancelled;
    private static volatile String screeningDateId;
    private static volatile String nonce;
    private static volatile String customerId;
    private static volatile String clientToken;
        
    private static BraintreeGateway gateway = new BraintreeGateway(
    		  Environment.SANDBOX,
      		  "j3ndqpzrhy4gp2p7",
      		  "rzmyrsbswb3hwsmk",
      		  "37113dbf6dc015806f510e7e630755fb"
    		);
    
    
    /**
     * TODO: with BrainTree Payment API
     * The user completes the checkout: the user needs to have a customer, therefore create a new CustomerRequest, if necessary. 
     * Unless the card is not valid, the booking takes places, and the order will be recorded with purchase and payment details, that 
     * defines an order: the Order table will hold the payment details, 
     * linked with the order_orderId to the Purchase table, which holds all the purchased items for a given order, 
     * so the "order" is an abstraction of the purchase(s) with payment.
     * 
     * For reservation only, the scenario is the same, but without payment transactions.
     * 
     * @param headers
     * @param request_
     * @return
     * @throws IOException
     */
    @POST
    @Path("/book/payment/fullcheckout")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response fullcheckout(
    		@Context HttpHeaders headers,
    		@Context HttpServletRequest request_) throws IOException {

		uuid = request_.getAttribute("uuid").toString();
		orderId = request_.getParameter("orderId").toString();
	    seatsToBeReserved = request_.getParameter("seatsToBeReserved").trim();
	    nonce = request_.getParameter("payment_method_nonce").trim();

	    int price = new Integer(0);
	    double price_ = price;
	    
	    int ticketPrice = new Integer(0);
	    double ticketPrice_ = ticketPrice;
	    
	    int sum = new Integer(0);
	    double sum_ = sum;
	    
	    int taxPrice = new Integer(0);
	    double taxPrice_ = taxPrice;
	    
	    int taxedTicketPrice = new Integer(0);
	    double taxedTicketPrice_ = taxedTicketPrice;
	    
	    int taxSum = new Integer(0);
	    double taxSum_ = taxSum;
	    	    
	    List<Ticket> allTickets = new ArrayList<Ticket>();
	    List<Ticket> failedTickets = new ArrayList<Ticket>();
	    List<Seats> allSeats = new ArrayList<Seats>();
	    
		String AuthCode = "";
		String ResponseCode = "";
		String ResponseText = "";
		String Status = "";
		BigDecimal Amount = null;
		BigDecimal TaxAmount = null;
		String CVS = "";
		
      	BookingHandlerImpl bh = new BookingHandlerImpl();

	    JSONObject jsonObj = new JSONObject(seatsToBeReserved);
	    JSONArray companyList = (JSONArray) jsonObj.get("seatsToBeReserved");
	        	        
		for (int i = 0; i < companyList.length(); i++) { 
	
		    	JSONObject jObj = new JSONObject(companyList.get(i).toString());
			    
		    	screeningDateId = jObj.getString("screeningDateId");
		        String seats = jObj.getString("seat");
		        
		        List<String> seatList = new ArrayList<>();
		        for (String seat: seats.split("-")){
				 	
					 if (!seat.isEmpty()) {
						 
						 seatList.add(seat);
					 
					 } else {
						 
						 throw new CustomExceptions("Error", "Seats might have been lost in the ether...");
						 
					 }
					 
				 }
				 
				//TODO: add error cases
		        // we do the payment first, then book the tickets
				// if any of the tickets cannot be booked...rollback the order, let the purchase cancel
				List<Ticket> ticket = bh.returnTickets(Integer.parseInt(screeningDateId), seatList, uuid, orderId);					

					allTickets.addAll(ticket);	
								
				if(ticket.size() != seatList.size()) {	
					// exclude purchases, where race-condition occurred (each screening is a different purchase)
					failedTickets.addAll(ticket);					
				}
				
				// return updated seats for screenings
				List<Seats> seats_ = bh.returnUpdatedseats(Integer.parseInt(screeningDateId));   
				allSeats.addAll(seats_);
		    	
				// we use ticket resource to calculate the price + tax, since the DAO ensures it is correct.				
		    	for (int j = 0; j < ticket.size(); j++) {
		    		
		    		if (ticket.get(0).getTicketId() == 0) {
		    			
		    		} else {
		    		
		    		ticketPrice_ = ticket.get(j).getPrice();
		    		taxedTicketPrice_ = ticketPrice_ * ticket.get(j).getTax();
		    		
		    		price_ = sum_ + taxedTicketPrice_;
		    		taxPrice_ = taxSum_ + (taxedTicketPrice_ - ticketPrice_);
		    		
		    		sum_ = price_;
		    		taxSum_ = taxPrice_;
		    		
		    		}
		    		
		    	}
		    }
		//End of reserving seats//
		List<Integer> ticketIds = new ArrayList<Integer>();	
		List<Integer> ticketIds_ = allTickets.stream().map(e -> e.getTicketId()).collect(Collectors.toList());	
		
		// TODO: create a customer request, first, if it does not exist, and store its id (or go with the anonymous way)
		// FIX: you need to save the Braintree customerId, and link to the uuid
		// TODO: then verify the card and amount		
		// TODO: upon the result of verification proceed with the transaction, or clear the reserved seats.
		CharSequence customer_ = uuid.subSequence(0, 7);
		String customerId = "";
		try {
			  Customer customer = gateway.customer().find(String.valueOf(customer_));
			  customerId = customer.getId();

		} catch (NotFoundException e) {
			  System.err.println(e.getMessage());
			  
				CustomerRequest requestCustomer = new CustomerRequest()
						  .firstName("Mark")
						  .lastName("Jones")
						  .company("Jones Co.")
						  .email("mark.jones@example.com")
						  .fax("419-555-1234")
						  .phone("614-555-1234")
						  .customerId(String.valueOf(customer_));
						Result<Customer> resultCustomer = gateway.customer().create(requestCustomer);
						customerId = resultCustomer.getTarget().getId();
			}
		

		
		String taxSumma = String.format("%.2f", sum_);
		TransactionRequest request = new TransactionRequest()
				.merchantAccountId("testcompany")
				.customerId(customerId)
    		    .amount(new BigDecimal(Double.toString(sum_)))
    		    .taxAmount(new BigDecimal(taxSumma))
    		    .paymentMethodNonce(nonce)
    		    .options()
    		      .submitForSettlement(true)
    		      .done();
    	    	
    	Result<Transaction> result = gateway.transaction().sale(request);
		System.out.println("Transaction finished...");

		Transaction transaction = result.getTarget();	
		if (result.isSuccess()) {
		
			AuthCode = transaction.getProcessorAuthorizationCode().trim();
			ResponseCode = transaction.getProcessorResponseCode().trim();
			ResponseText = transaction.getProcessorResponseText().trim();
			Amount = transaction.getAmount();
			TaxAmount = transaction.getTaxAmount();
			Status = gateway.transaction().find(transaction.getId()).getStatus().toString();
			CVS = transaction.getCvvResponseCode().trim();
			//String TransactionID = transaction.getAuthorizedTransactionId();
			//bh.saveTransactionId(TransactionID);
			
		} else {			
			
			System.out.print("Error with Transaction: " + result.getMessage());
			ticketIds.addAll(ticketIds_);

			bh.deleteTicket(ticketIds, allTickets.get(0).getPurchase().getPurchaseId());
			JSONObject json = new JSONObject();
			json.put("Error with Transaction", result.getMessage());  

    		return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();	

			}
		

		//TODO: save the main transaction details into dB (order table), to keep records independently from Ticket/Purchase tables 
		JSONObject json = new JSONObject();

		if (allTickets.isEmpty() || !failedTickets.isEmpty()) {
					
			ticketIds.addAll(ticketIds_);
			
			bh.deleteTicket(ticketIds, allTickets.get(0).getPurchase().getPurchaseId());

			json.put("Error","Tickets are already sold!");  
			json.put("Success", "true");
			json.put("failedTickets", failedTickets);
						
    		return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();	

		}

		json.put("AuthCode", AuthCode);
		json.put("ResponseCode", ResponseCode);
		json.put("ResponseText", "hello");
		json.put("Status", Status);  
		json.put("Amount",String.valueOf(sum_));  
		json.put("TaxAmount",String.valueOf(taxSum_)); 
		json.put("Success", "true");
		json.put("tickets", allTickets);
		//updates seats in the popOver as reserved
		json.put("seatsforscreen", allSeats);
		
		System.out.println(AuthCode);
		System.out.println(ResponseCode); 
		System.out.println(ResponseText);
	    System.out.println(Amount); 
		System.out.println(TaxAmount);
		System.out.println(Status);
		System.out.println(CVS);
				
		return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();	
		
    }
    
    @GET
	@Path("/book/purchases")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllPurchases(
			@Context HttpHeaders headers,
    		@Context HttpServletRequest request_) throws IOException {

		uuid = request_.getAttribute("uuid").toString();
      	
		BookingHandlerImpl bh = new BookingHandlerImpl();
      	List<Purchase> purchases = bh.getAllPurchases(uuid);
      	
		JSONObject json = new JSONObject();
		HashMap<String, String> tickets = new HashMap<>();

		for (int i = 0; i < purchases.size(); i++) {
			
			JSONObject responseObj = new JSONObject();
			
			responseObj.put("purchaseId", String.valueOf(purchases.get(i).getPurchaseId()));
			responseObj.put("orderId", purchases.get(i).getOrderId());
			responseObj.put("movie_name", purchases.get(i).getTicketsForPurchase().get(0).getScreen().getMovie().getName());
			responseObj.put("movie_picture", purchases.get(i).getTicketsForPurchase().get(0).getScreen().getMovie().getLarge_picture());
			responseObj.put("screeningDate", purchases.get(i).getTicketsForPurchase().get(0).getScreen().getScreeningDates().getScreeningDate());
			responseObj.put("venue_name", purchases.get(i).getTicketsForPurchase().get(0).getScreen().getScreeningDates().getVenues().getName());
			responseObj.put("purchaseDate", purchases.get(i).getTime());
						
			json.append("purchases", responseObj);
		
		}
		
		return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();	

	}
    
    @GET
    @Path("/book/purchases/tickets")
	@Produces(MediaType.APPLICATION_JSON)
    public Response getTicketsPerPurchase(
    		@Context HttpHeaders headers,
    		@Context HttpServletRequest request_,
    		@QueryParam(value = "purchaseId") String purchaseId) throws IOException {
		
		List<Ticket> tickets = new BookingHandlerImpl().getTicketPerPurchase(Integer.valueOf(purchaseId));
		
		if (tickets.size() > 0) {
			
			JSONObject json = new JSONObject();

			for (int i = 0; i < tickets.size(); i++) {
				
				HashMap<String,Object> responseObj = new HashMap<String,Object>();
				
				responseObj.put("ticketId", tickets.get(i).getTicketId());
				responseObj.put("price", tickets.get(i).getPrice());
				responseObj.put("tax", tickets.get(i).getTax());
				responseObj.put("seats_seatNumber", String.valueOf(tickets.get(i).getSeats_seatNumber()));
				responseObj.put("seats_seatRow", String.valueOf(tickets.get(i).getSeats_seatRow()));
				responseObj.put("movie_name", tickets.get(i).getScreen().getMovie().getName());
				responseObj.put("venue_name", tickets.get(i).getScreen().getScreeningDates().getVenues().getName());
				responseObj.put("screening_date", String.valueOf(tickets.get(i).getScreen().getScreeningDates().getScreeningDate()));
				responseObj.put("screen_screenId", tickets.get(i).getScreen().getScreenId());
				responseObj.put("movie_picture",tickets.get(i).getScreen().getMovie().getLarge_picture());
				responseObj.put("iMDB_url", tickets.get(i).getScreen().getMovie().getiMDB_url());
				json.append("tickets", responseObj);
				
			}

			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No tickets available.");			
		}
    }
 
    //INFO: for web, and for iOS if BTAPIClient produces constant memory leak
    @GET
    @Path("/book/payment/clientToken")
	@Produces(MediaType.APPLICATION_JSON)
    public Response clientToken(
    		@Context HttpHeaders headers,
    		@Context HttpServletRequest request_) throws IOException {
	
    	clientToken = gateway.clientToken().generate();
    	JSONObject json = new JSONObject();

		if(clientToken != null) {
		json.put("clientToken", clientToken);
    	return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();
   	 
		} else {
		return Response.ok().status(Status.NOT_FOUND).type(MediaType.APPLICATION_JSON_TYPE).build();
		}
	}
    
    @POST
    @Path("/book/payment/webcheckout")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.MEDIA_TYPE_WILDCARD)
    public Response webcheckout(
    		@Context HttpHeaders headers,
    		@Context HttpServletRequest request_) throws IOException {
    	
    	System.out.println("Request recieved");
    	
    	nonce = request_.getParameter("payment_method_nonce_web");
    	for (Enumeration<?> e = request_.getParameterNames(); e.hasMoreElements();)

			while (e.hasMoreElements()) {
				String propertyKey = (String) e.nextElement();
				System.out.println("Request parameters: " + propertyKey);

			}
    	
   		//String clientToken = gateway.clientToken().generate();    		
    	//System.out.println(clientToken);

    	// Use payment method nonce here
    	TransactionRequest request = new TransactionRequest()
    		    .amount(new BigDecimal("10.00"))
    		    .paymentMethodNonce(nonce)
    		    .options()
    		      .submitForSettlement(true)
    		      .done();
    	
    	request.getKind();
    	
    	Result<Transaction> result = gateway.transaction().sale(request);
		Transaction transaction = result.getTarget();
		
		String AuthCode = "";
		String ResponseCode = "";
		String ResponseText = "";
		String Status = "";
		
		try {
		
			AuthCode = transaction.getProcessorAuthorizationCode();
			ResponseCode = transaction.getProcessorResponseCode();
			ResponseText = transaction.getProcessorResponseText();
			Status = gateway.transaction().find(transaction.getId()).getStatus().toString();
		
			} catch (Exception e) {
			
		}
		JSONObject json = new JSONObject();
		json.put("AuthCode", AuthCode);
		json.put("ResponseCode", ResponseCode);
		json.put("ResponseText", ResponseText);
		json.put("Status",Status);  
		json.put("Success", "true");
    	
    	return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON_TYPE).build();
   	  }

    /*
    @POST
	@Path("/book/{screeningDateId}")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Response getMovieTicket(
			@PathParam(value = "screeningDateId") int screeningDateId,
			String seatsToBeReserved) throws IOException {
		
		StringBuilder sb = new StringBuilder();
		InputStream ps = IOUtils.toInputStream(seatsToBeReserved, "UTF-8");
	    BufferedReader br = new BufferedReader(new InputStreamReader(ps));
	    
	    String str;
	    while( (str = br.readLine()) != null ){
	        sb.append(str);
	    }    
	    
		 JSONObject jObj = new JSONObject(sb.toString());
		    
	     String seats = jObj.getString("seatsToBeReserved");
	        
	     List<String> seatList = new ArrayList<>();
		 for (String seat: seats.split("-")){
			 	
			 if (!seat.isEmpty()) {
				 
				 seatList.add(seat);
			 
			 }
			 
		 }
		 
		BookingHandlerImpl bh = new BookingHandlerImpl();
		
		List<Ticket> ticket = bh.returnTickets(screeningDateId, seatList, uuid);
		List<Seats> seats_ = bh.returnUpdatedseats(screeningDateId);
		//List<Seats> seats_ = bh.getSeatsForScreenForMovieOnVenue(screeningDateId);
		
		if (ticket != null && seats != null) {
			
			JSONObject json = new JSONObject();
			json.put("tickets", ticket);
			json.put("seatsforscreen", seats_);

		return	Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();	
		
		} else {
		
			return Response.status(404).build();
		}
	}*/
	
	@GET
	@Path("/book/movies/{name}/{order}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response searchMovies(
			@PathParam(value = "name") String name,
			@PathParam(value = "order") String order) {
		
		
		List<Movie> movies = new BookingHandlerImpl().searchMovies(name, order);
		
		if (movies != null) {
			
			if (movies.size() > 0) {
				
				JSONObject json = new JSONObject();

				for (int i = 0; i < movies.size(); i++) {
					
					HashMap<String,String> responseObj = new HashMap<String,String>();
					
					responseObj.put("movieId", String.valueOf(movies.get(i).getMovieId()));
					responseObj.put("name", movies.get(i).getName());
					responseObj.put("detail", movies.get(i).getDetail());
					responseObj.put("large_picture",movies.get(i).getLarge_picture());
					responseObj.put("thumbnail_picture",movies.get(i).getThumbnail_picture());
					responseObj.put("iMDB_url", movies.get(i).getiMDB_url());
					json.append("searchedMovies", responseObj);
					
				}
				
				return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();	
				
		} else {
			
			throw new CustomExceptions("Error!", "No results for the search.");
			
			}
		
		} 
		
		else  throw new CustomExceptions("Error!", "Wrong sorting argument");
	}
	
	@GET
	@Path("/book/movies/search")
	@Produces(MediaType.APPLICATION_JSON)
	public Response fullTextSearchMovies(
			@QueryParam(value = "match") String match,
			@QueryParam(value = "setFirstResult") String setFirstResult,
    		@QueryParam(value = "category") String category) {
		
		if (match.length() < 3) {
			
			throw new CustomExceptions("Error!", "Search query has to be at least 3 characters long.");	
		
		}
		

		if(category == null) {
			category = "";
		}
		
		List<Movie> movies = new BookingHandlerImpl().fullTextSearchMovies(match, category, Integer.parseInt(setFirstResult));
		
		if (!movies.isEmpty()) {
						
			JSONObject json = new JSONObject();

			for (int i = 0; i < movies.size(); i++) {
				
				HashMap<String,String> responseObj = new HashMap<String,String>();
				
				responseObj.put("movieId", String.valueOf(movies.get(i).getMovieId()));
				responseObj.put("name", movies.get(i).getName());
				responseObj.put("detail", movies.get(i).getDetail());
				responseObj.put("large_picture",movies.get(i).getLarge_picture());
				responseObj.put("thumbnail_picture",movies.get(i).getThumbnail_picture());
				responseObj.put("iMDB_url", movies.get(i).getiMDB_url());
				json.append("searchedMovies", responseObj);
				
			}
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();		
		
		} else {
			
			HashMap<String,String> responseObj = new HashMap<String,String>();
			JSONObject json = new JSONObject();
			json.append("NotFoundMovies", "No such movie(s)");
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();
			
			}
	}
	
	@GET
	@Path("/book/movies")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllMovies(
    		@Context HttpHeaders headers,
    		@Context HttpServletResponse response,
    		@Context HttpServletRequest request,
    		@Context ServletContext contex) {
		
		//TODO PBI: use the variable X-Token and deviceId. 
		if (headers.getRequestHeader("X-Token").isEmpty() || headers.getRequestHeader("X-Device").isEmpty()) {	         
			
			JSONObject json = new JSONObject();
			json.put("Error", "User not authorized!)");
			
			return Response.status(403).entity(json.toString()).type(MediaType.APPLICATION_JSON).build();
		}
		
		ciphertext = headers.getRequestHeader("X-Device").get(0);

		List<Movie> movies = new BookingHandlerImpl().getAllMovies(-1, "");
		c = aesUtil.encrypt(SALT, IV, APIKEY, ciphertext);
		NewCookie nc = new NewCookie("ApiKey", c.trim(), request.getContextPath(), null, null, 1800, true);
		
		if (movies.size() > 0) {
			
			JSONObject json = new JSONObject();

			for (int i = 0; i < movies.size(); i++) {
				
				HashMap<String,String> responseObj = new HashMap<String,String>();
				
				responseObj.put("movieId", String.valueOf(movies.get(i).getMovieId()));
				responseObj.put("name", movies.get(i).getName());
				responseObj.put("detail", movies.get(i).getDetail());
				responseObj.put("large_picture",movies.get(i).getLarge_picture());
				responseObj.put("thumbnail_picture",movies.get(i).getThumbnail_picture());
				responseObj.put("iMDB_url", movies.get(i).getiMDB_url());
				json.append("movies", responseObj);
				
			}
			
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).header("APIKEY", c).lastModified(Date.from(Instant.now())).cookie(nc).build();
		
		} else {
			JSONObject json = new JSONObject();
			json.put("NotFoundMovies", "EndOfFile:)");
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).header("APIKEY", c).lastModified(Date.from(Instant.now())).cookie(nc).build();			
		}
	}
	
	@GET
	@Path("/book/movies/paging")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllMoviesWithPaging (
    		@Context HttpHeaders headers,
    		@Context HttpServletResponse response,
    		@Context HttpServletRequest request,
    		@Context ServletContext contex,
    		@QueryParam(value = "setFirstResult") String setFirstResult,
    		@QueryParam(value = "category") String category) {
		
		//TODO PBI: use the variable X-Token and deviceId. 
		if (headers.getRequestHeader("X-Token").isEmpty() || headers.getRequestHeader("X-Device").isEmpty()) {	         
			throw new CustomExceptions("Error!", "User is not authorized!");
		}
		
		ciphertext = headers.getRequestHeader("X-Device").get(0);
		c = aesUtil.encrypt(SALT, IV, APIKEY, ciphertext);
		NewCookie nc = new NewCookie("ApiKey", c.trim(), request.getContextPath(), null, null, 1800, true);
		
		if(setFirstResult == null) {
			setFirstResult = "-1";
		}
		if(category == null) {
			category = "";
		}
		
		List<Movie> movies = new BookingHandlerImpl().getAllMovies(Integer.parseInt(setFirstResult), category);
		if (movies.size() > 0) {
			
			JSONObject json = new JSONObject();

			for (int i = 0; i < movies.size(); i++) {
				
				HashMap<String,String> responseObj = new HashMap<String,String>();
				
				responseObj.put("movieId", String.valueOf(movies.get(i).getMovieId()));
				responseObj.put("name", movies.get(i).getName());
				responseObj.put("detail", movies.get(i).getDetail());
				responseObj.put("large_picture",movies.get(i).getLarge_picture());
				responseObj.put("thumbnail_picture",movies.get(i).getThumbnail_picture());
				responseObj.put("iMDB_url", movies.get(i).getiMDB_url());
				json.append("movies", responseObj);
				
			}
			
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).header("APIKEY", c).lastModified(Date.from(Instant.now())).cookie(nc).build();
		
		} else {
			JSONObject json = new JSONObject();
			json.put("NotFoundMovies", "EndOfFile:)");
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).header("APIKEY", c).lastModified(Date.from(Instant.now())).cookie(nc).build();			
		}
	}
	
	@GET
	@Path("/book/venue/{movieId}")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getVenuesForMovie(
			@PathParam(value = "movieId") int movieId) {
				
		List<Venues> venue = new BookingHandlerImpl().getVenues(movieId);
		
		if (venue != null) {
			
			JSONObject json = new JSONObject();  
			json.put("venues", venue);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No venues available.");
			
		}
	}
	
	@GET
	@Path("/book/venue/v2/{movieId}")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getLocationForMovie(
			@PathParam(value = "movieId") int movieId) {
				
		List<Location> locations = new BookingHandlerImpl().getLocationForMovie(movieId);
		
		if (!locations.isEmpty()) {
			
			JSONObject json = new JSONObject();  
			json.put("locations", locations);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No locations available.");
			
		}
	}
	
	@GET
	@Path("/book/venue/movies")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getMoviesForVenue(
			@QueryParam(value = "locationId") int locationId) {
				
		BookingHandlerImpl bh = new BookingHandlerImpl();

		List<Movie> movies = bh.getMoviesForVenue(locationId);
	    List<Venues> venue = bh.getVenueByLocation(locationId);
		
		if (movies != null && venue != null) {
			
			JSONObject json = new JSONObject();  
			
			for (int i = 0; i < movies.size(); i++) {
				
				HashMap<String,String> responseObj = new HashMap<String,String>();
				
				responseObj.put("movieId", String.valueOf(movies.get(i).getMovieId()));
				responseObj.put("name", movies.get(i).getName());
				responseObj.put("detail", movies.get(i).getDetail());
				responseObj.put("large_picture",movies.get(i).getLarge_picture());
				responseObj.put("thumbnail_picture",movies.get(i).getThumbnail_picture());
				responseObj.put("iMDB_url", movies.get(i).getiMDB_url());
				json.append("movies", responseObj);
				
			}
			
			json.put("venue", venue);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No movies or venue available.");
			
		}
	}
	

	@GET
	@Path("/book/locations/venue")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getLocationForVenue(
			@QueryParam(value = "venuesId") int venuesId) {
				
		Location location = new BookingHandlerImpl().getLocationForVenue(venuesId);
		
		if (location != null) {
						
			return Response.ok().entity(location).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "There is no location or venue data available.");
			
		}
	}
	
	
	@GET
	@Path("/book/locations")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllLocation() {
				
		List<Location> locations = new BookingHandlerImpl().getAllLocations();
		
		if (locations != null) {
			
			JSONObject json = new JSONObject();  
			json.put("locations", locations);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error", "No locations available.");
			
		}
	}
	
	@GET
	@Path("/book/admin/moviesonvenues")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllMoviesOnAllVenues() {
				
		List<Venues> venues = new BookingHandlerImpl().getAllVenuesForUpdate();
		
		if (venues != null) {
			JSONObject json = new JSONObject();  

			for (int i = 0; i < venues.size(); i++) {
				HashMap<String,String> responseObj = new HashMap<String,String>();

				responseObj.put("movie", venues.get(i).getScreen().getMovie().getName());
				responseObj.put("movieId", String.valueOf(venues.get(i).getScreen().getMovie().getMovieId()));
				responseObj.put("category", venues.get(i).getScreen().getMovie().getCategory());
				responseObj.put("large_picture", venues.get(i).getScreen().getMovie().getLarge_picture());

				responseObj.put("ScreeningId", venues.get(i).getScreen_screenId());
				responseObj.put("venueId", String.valueOf(venues.get(i).getVenuesId()));
				responseObj.put("venue", String.valueOf(venues.get(i).getName()));
				responseObj.put("screeningDatesId", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDatesId()));
				responseObj.put("date", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDate()));
				json.append("venues", responseObj);

			}
			
			
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error", "No locations available.");
			
		}
	}
	
	@GET
	@Path("/book/admin/moviesonvenuescategorized")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllMoviesOnAllVenuesWithCategory(
					@QueryParam(value = "category") String category) {
				
		List<Venues> venues = new BookingHandlerImpl().getAllVenuesForUpdate();
		
		if (venues != null) {
			JSONObject json = new JSONObject();  

			for (int i = 0; i < venues.size(); i++) {
				HashMap<String,String> responseObj = new HashMap<String,String>();

				if (venues.get(i).getScreen().getMovie().getCategory().equalsIgnoreCase(category)) {
				
				responseObj.put("movie", venues.get(i).getScreen().getMovie().getName());
				responseObj.put("movieId", String.valueOf(venues.get(i).getScreen().getMovie().getMovieId()));
				responseObj.put("category", venues.get(i).getScreen().getMovie().getCategory());
				responseObj.put("large_picture", venues.get(i).getScreen().getMovie().getLarge_picture());

				responseObj.put("ScreeningId", venues.get(i).getScreen_screenId());
				responseObj.put("venueId", String.valueOf(venues.get(i).getVenuesId()));
				responseObj.put("venue", String.valueOf(venues.get(i).getName()));
				responseObj.put("screeningDatesId", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDatesId()));
				responseObj.put("date", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDate()));
				json.append("venues", responseObj);
				}
			}
			
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error", "No locations available.");
			
		}
	}
	
	@GET
	@Path("/book/admin/moviesonvenuessearch")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getAllMoviesOnAllVenuesForSearch(
					@QueryParam(value = "match") String match) {
				
		List<Venues> venues = new BookingHandlerImpl().getAllVenuesForUpdate();
		
		if (venues != null) {
			JSONObject json = new JSONObject();  

			for (int i = 0; i < venues.size(); i++) {
				HashMap<String,String> responseObj = new HashMap<String,String>();

				if (venues.get(i).getScreen().getMovie().getName().toLowerCase().contains(match.toLowerCase())) {
				
				responseObj.put("movie", venues.get(i).getScreen().getMovie().getName());
				responseObj.put("movieId", String.valueOf(venues.get(i).getScreen().getMovie().getMovieId()));
				responseObj.put("category", venues.get(i).getScreen().getMovie().getCategory());
				responseObj.put("large_picture", venues.get(i).getScreen().getMovie().getLarge_picture());

				responseObj.put("ScreeningId", venues.get(i).getScreen_screenId());
				responseObj.put("venueId", String.valueOf(venues.get(i).getVenuesId()));
				responseObj.put("venue", String.valueOf(venues.get(i).getName()));
				responseObj.put("screeningDatesId", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDatesId()));
				responseObj.put("date", String.valueOf(venues.get(i).getScreen().getScreeningDates().getScreeningDate()));
				json.append("venues", responseObj);
				}
			}
			
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error", "No locations available.");
			
		}
	}
	
	
	@GET
	@Path("/book/dates/{locationId}/{movieId}")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getDatesForMovieOnVenue (
			@PathParam(value = "locationId") int locationId,
			@PathParam(value = "movieId") int movieId){
				
		List<ScreeningDates> dates = new BookingHandlerImpl().getScreeningDatesForMovieOnVenue(locationId, movieId);

		if (dates != null) {
			
			JSONObject json = new JSONObject();  
			json.put("dates", dates);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No screening dates available for the movie");
			
		}
	}
	
	@GET
	@Path("/book/seats/{screeningDateId}")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response getSeatsForScreenForMovieOnVenue (
			@PathParam(value = "screeningDateId") int screeningDateId) {
				
		List<Seats> seats = new BookingHandlerImpl().getSeatsForScreenForMovieOnVenue(screeningDateId);
		
		if (seats != null) {
			
			JSONObject json = new JSONObject();  
			json.put("seatsforscreen", seats);
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).lastModified(Date.from(Instant.now())).build();
		
		} else {
			
			throw new CustomExceptions("Error!", "No seats available for the screening.");
			
		}
	}
	
	@POST
	@Path("/book/managepurchases")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
	public Response cancelTicket(
			@Context HttpServletRequest request,
			@Context HttpHeaders headers) {
		
		ciphertext = headers.getRequestHeader("Ciphertext").get(0);
		
		if (!ciphertext.equals(request.getAttribute("token2").toString())) {
			JSONObject json = new JSONObject();
			json.put("Error", "User not authorized!)");
			
			return Response.ok().entity(json.toString()).type(MediaType.APPLICATION_JSON).build();
		} 
		
		String purchaseId = request.getParameter("purchaseId").trim();
		String ticketsToBeCancelled = request.getParameter("ticketsToBeCancelled").trim();
	    JSONObject jsonObj = new JSONObject(ticketsToBeCancelled);
	    JSONArray ticketsList = (JSONArray) jsonObj.get("ticketIds");
	    
        List<Integer> ticketIds = new ArrayList<>();
		for (int i = 0; i < ticketsList.length(); i++) { 	    	
		    
	    	int ticketId = Integer.valueOf(ticketsList.get(i).toString());
	    	ticketIds.add(ticketId);
				 
			 }
	    
		BookingHandlerImpl bh = new BookingHandlerImpl();
		boolean deleteTickets = bh.deleteTicket(ticketIds, Integer.valueOf(purchaseId));
		
		if(deleteTickets) {
			
			JSONObject json = new JSONObject();  
			json.put("Success", "true");
			
		return Response.ok().entity(json.toString()).build(); 

	} else {
	
		throw new CustomExceptions("Error!", "Something went wrong.");

			}
		
	}
	
	@POST
	@Path("/book/deletepurchases")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
	public Response deletePurchase(
			@Context HttpServletRequest request) {
		
		String purchaseId = request.getParameter("purchaseId").trim();
		    
		BookingHandlerImpl bh = new BookingHandlerImpl();
		boolean deletePurchase = bh.deletePurchase(Integer.valueOf(purchaseId));
		
		if(deletePurchase) {
			
			JSONObject json = new JSONObject();  
			json.put("Success", "true");
			
		return Response.ok().entity(json.toString()).build(); 

	} else {
	
		throw new CustomExceptions("Error!", "Something went wrong.");

		}
	}
		
		@POST
		@Path("/book/admin/addscreen")
		@Consumes(MediaType.APPLICATION_JSON)
		@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
		public Response addScreen(
				@Context HttpServletRequest request, String newScreen) throws ParseException, IOException {
			
			//String newScreen = request.getParameter("newScreen").trim();
		    //System.out.print(newScreen);

			StringBuilder sb = new StringBuilder();
			InputStream ps = IOUtils.toInputStream(newScreen);
		    BufferedReader br = new BufferedReader(new InputStreamReader(ps, StandardCharsets.UTF_8));
		    
		    String str;
		    while( (str = br.readLine()) != null ){
		        sb.append(str);
		    }    
		    
			 JSONObject jObj = new JSONObject(sb.toString());			    		        

		     String movie = jObj.getString("movie");
		     String date = jObj.getString("date");
		     String venue = jObj.getString("venue");
		     String nrOfRows_ = jObj.getString("nrOfRows");
		     String nrOfSeatsInRow_ = jObj.getString("nrOfSeatsInRow");
		     String ScreeningId = jObj.getString("ScreeningId");
		     String category = jObj.getString("category");

		     

		     int nrOfRows = Integer.parseInt(nrOfRows_);
		     int nrOfSeatsInRow = Integer.parseInt(nrOfSeatsInRow_);

			BookingHandlerImpl bh = new BookingHandlerImpl();
			Screen newScreen_ = bh.addScreen(movie, date, venue, nrOfRows, nrOfSeatsInRow, ScreeningId, category);
			
			//String movieName = newScreen_.getMovie().getName();
			//String dateTime = newScreen_.getScreeningDates().getScreeningDate().toString();
			//String venueName = newScreen_.getScreeningDates().getVenues().getName();
			String screeningId = newScreen_.getScreenId();
			if(screeningId.contains("Error:")) {
				
				 JSONObject json = new JSONObject();			    		        
				 json.put("movie", movie);
				 json.put("date", date);
				 json.put("venue", venue);
				 json.put("ScreeningId", screeningId);

				return Response.ok().status(Status.CONFLICT).entity(json.toString()).build(); 
				
			} else {
			 
			 String ScreeningDatesId = Integer.toString(newScreen_.getScreeningDates().getScreeningDatesId());
			 JSONObject json = new JSONObject();			    		        
			 json.put("movie", movie);
			 json.put("date", date);
			 json.put("venue", venue);
			 json.put("ScreeningId", screeningId);
			 json.put("ScreeningDateId", ScreeningDatesId);

			return Response.ok().entity(json.toString()).build(); 
			}
		}
		
		@POST
		@Path("/book/admin/updatescreen")				
		@Consumes(MediaType.APPLICATION_JSON)
		@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
		public Response updateScreen(
				@Context HttpServletRequest request, String updateScreen) throws ParseException, IOException {
			
			//String newScreen = request.getParameter("newScreen").trim();
		    //System.out.print(newScreen);

			StringBuilder sb = new StringBuilder();
			InputStream ps = IOUtils.toInputStream(updateScreen);
		    BufferedReader br = new BufferedReader(new InputStreamReader(ps, StandardCharsets.UTF_8));
		    
		    String str;
		    while( (str = br.readLine()) != null ){
		        sb.append(str);
		    }    
		    
			 JSONObject jObj = new JSONObject(sb.toString());			    		        

		     String moviesId = jObj.getString("movieId");
		     String Date = jObj.getString("date");
		     String Venue = jObj.getString("venue");
		     String venuesId = jObj.getString("venueId");
		     String screenId = jObj.getString("screenId");
		     String category = jObj.getString("category"); 
		     String screeningDatesId = jObj.getString("ScreeningDatesId");
		     

			BookingHandlerImpl bh = new BookingHandlerImpl();
			Screen newScreen_ = bh.updateScreen(Venue,Integer.parseInt(venuesId), Integer.parseInt(screeningDatesId), Integer.parseInt(moviesId), screenId, Date, category);
			
			String screeningId = newScreen_.getScreenId();
			if(screeningId.contains("Error:")) {
				
				 JSONObject json = new JSONObject();			    		        
				 json.put("movie", moviesId);
				 json.put("date", Date);
				 json.put("venue", Venue);
				 json.put("ScreeningId", screeningId);

				return Response.ok().status(Status.CONFLICT).entity(json.toString()).build(); 
				
			} else {
			 
			 JSONObject json = new JSONObject();			    		        
			 json.put("movie", moviesId);
			 json.put("date", Date);
			 json.put("venue", Venue);
			 json.put("ScreeningId", screeningId);

			return Response.ok().entity(json.toString()).build(); 
			}
		}
		
		@DELETE
		@Path("/book/admin/deletescreen")				
		@Consumes(MediaType.APPLICATION_JSON)
		@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })	
		public Response deleteScreen(
				@Context HttpServletRequest request, String deleteScreen) throws ParseException, IOException {
			
			//String newScreen = request.getParameter("newScreen").trim();
		    //System.out.print(newScreen);

			StringBuilder sb = new StringBuilder();
			InputStream ps = IOUtils.toInputStream(deleteScreen);
		    BufferedReader br = new BufferedReader(new InputStreamReader(ps, StandardCharsets.UTF_8));
		    
		    String str;
		    while( (str = br.readLine()) != null ){
		        sb.append(str);
		    }    
		    
			 JSONObject jObj = new JSONObject(sb.toString());			    		         
		     String screeningDatesId = jObj.getString("ScreeningDatesId");
		     

			BookingHandlerImpl bh = new BookingHandlerImpl();
			boolean deleteScreen_ = bh.deleteScreen(Integer.parseInt(screeningDatesId));
			
			if(!deleteScreen_) {
				
				 JSONObject json = new JSONObject();			    		        
				 json.put("screeningDatesId", screeningDatesId);

				return Response.ok().status(Status.CONFLICT).entity(json.toString()).build(); 
				
			} else {
			 
			 JSONObject json = new JSONObject();			    		        
			 json.put("screeningDatesId", screeningDatesId);


			return Response.ok().entity(json.toString()).build(); 
			}
		}
		
	
}
