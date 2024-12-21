package com.jeet.db;

import com.jeet.api.*;
import jakarta.enterprise.context.Dependent;
import jakarta.persistence.FlushModeType;
import org.hibernate.*;
import org.hibernate.resource.transaction.spi.TransactionStatus;
import org.hibernate.search.engine.search.query.SearchResult;
import org.hibernate.search.mapper.orm.Search;
import org.hibernate.search.mapper.orm.session.SearchSession;
import org.hibernate.stat.Statistics;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Dependent
public class DAO {

	private static DAO instance;
	private final SessionFactory factory;
	private static volatile Session session;
	private static volatile Transaction trans;
	private static volatile Seats seat;
	private static volatile Purchase purchase;
	private final SearchSession searchSession;
	private static volatile Screen screen;


	/**
	 * Intantiate DAO class that loads configured SessionFactory object. 
	 * You can also configure further settings for the session.
	 * 
	 */
	private DAO() throws InterruptedException {

		factory = HibernateUtil.getSessionFactory();
		System.out.println("Creating factory");

		Statistics stats = factory.getStatistics(); 
		stats.setStatisticsEnabled(true);
		
		session = factory.openSession();
		session.setFlushMode(FlushModeType.AUTO);
		
		// clear cache
		factory.getCache().evictAllRegions();
		System.out.println("Cache cleared.");

		searchSession = Search.session(session);
		Search.mapping(factory)
				.scope(Movie.class)
				.massIndexer()
				.startAndWait();
	}

	/**
	 * DAO instance is always synchronized, for sake of memory consistency, 
	 * and we use a shared static session object.
	 * 
	 * @return DAO instance
	 */
	public synchronized static DAO instance() throws InterruptedException {
		if (instance == null) {
			instance = new DAO();
		}
		return instance;
	}
	
	/**
	 * Return the screen object as per movie object, i.e the movie object you call at the previous step.
	 * 
	 * @param movie
	 * @return
	 */
	public synchronized Screen getScreen(Movie movie){
		
		session = factory.getCurrentSession();
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		Screen screen = session.get(Screen.class, movie.getMovieId());
		
		//String hql = "from Screen where movie_movieId = :mId";
		
		//Query query = session.createQuery(hql);
		//query.setParameter("mId", movie.getMovieId());
		
		//List<Screen> list = query.list();
		
		trans.commit();
		
		return screen;
	}
	
	/**
	 * Returns a movie object by movieId.
	 * 
	 * @param movieId
	 * @return
	 */
	public synchronized Movie getMovie(int movieId){
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		Movie movie = session.get(Movie.class, movieId);

		trans.commit();
		
		return movie;
	}
	
	/**
	 * Returns all the movies as a list.
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized List<Movie> getAllMovies(int setFirstResult, String category) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		List<Movie> movies;
		String hql;
		if(category.isBlank()) {
		hql = "from Movie order by name asc";
		} else {
		hql = "from Movie where category = :mCategory order by name asc";
		}
		
		if(setFirstResult == -1 && category.equals("")) {
		movies = session.createQuery(hql, Movie.class)
				.setCacheable(true)
				.setCacheRegion("movies")
				.setCacheMode(CacheMode.NORMAL)
				.getResultList();
		
		} else if(!category.isEmpty() && setFirstResult > -1) {
		movies = session.createQuery(hql)
				.setCacheable(true)
				.setParameter("mCategory", category)
				.setCacheRegion("movies")
				.setCacheMode(CacheMode.NORMAL)
				.setFirstResult(setFirstResult)
				.setMaxResults(30).getResultList();
		
		} else {
			 movies = session.createQuery(hql)
			.setCacheable(true)
			.setCacheRegion("movies")
			.setCacheMode(CacheMode.NORMAL)
			.setFirstResult(setFirstResult)
			.setMaxResults(30).getResultList();
	
	    }
				 

		trans.commit();
		
		return movies;
	}
	
	/**
	 * Returns a list of movies matching the search criteria. 
	 * 
	 * @param name
	 * @param order
	 * @return
	 */
	public synchronized List<Movie> searchMovies(String name, String order){
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			trans.begin();
		}
		
		String hql = "from Movie m where name like '%"+name+"%' order by m.name "+order;
		List<Movie> list = session.createQuery(hql)
		.setCacheable(true)
		.setCacheRegion("movies").getResultList();
		
		//query.setParameter("mName", "%"+name+"%");
		//query.setParameter("mOrder", order);
		
		trans.commit();
		
		return list;
	}
	
	/**
	 * Returns a list of movies by fulltext search in movie names and details.
	 * 
	 * @param match
	 * @return
	 */

	public synchronized List<Movie> fullTextSearchMovies(String match, String category, int setFirstResult) {
         
        session = factory.getCurrentSession(); 
        trans = session.getTransaction(); 
         
        if (trans.getStatus() != TransactionStatus.ACTIVE) {             
            trans.begin(); 
        }

		SearchResult<Movie> result = null;
			// Full-text search query
			result = searchSession.search(Movie.class)
					.where(f -> f.bool()
							.must(f.match().field("name").matching(match))
							.should(f.match().field("detail").matching(match))) // Search term
					.fetch(20);

        List<Movie> results = result.hits();
        
        trans.commit(); 
 
        if(session.isOpen()) {           
            session.close(); 
        }  
         
        return results;
    }

	
	/**
	 * Returns all seats for a screen (movie/venue) by screeningDateId.
	 * 
	 * @param screeningDateId
	 * @return
	 */
	public synchronized List<Seats> getSeatsForScreening(int screeningDateId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select screeningdates.venues.screen.seat from ScreeningDates as screeningdates where screeningDatesId = :mScreeningDatesId";

		List<Seats> list = session.createQuery(hql)
		.setParameter("mScreeningDatesId", screeningDateId).getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	/**
	 * Returns seats state (availability).
	 * 
	 * @param screeningDatesId
	 * @param seatNumber
	 * @return
	 */
	public synchronized Seats getSeatForAvailability(int screeningDatesId, String seatNumber) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {

			trans.begin();
		}

		String hql = "select seats from ScreeningDates as screeningdates inner join screeningdates.venues.screen.seat as seats where screeningdates.screeningDatesId = :mScreeningDatesId and seats.seatNumber = :mSeatNumber";

		Seats seat = (Seats) session.createQuery(hql)
				.setParameter("mScreeningDatesId", screeningDatesId)
				.setParameter("mSeatNumber", seatNumber).uniqueResult();

		return seat;	
	}
	
	/**
	 * Returns all movies for a given venue.
	 * 
	 * @return
	 */
	public synchronized List<Movie> getMoviesForVenue(int locationId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues.screen.movie from Venues as venues where venues.location.locationId = :mLocationId";

		List<Movie> list = session.createQuery(hql)
			.setParameter("mLocationId", locationId)
			//.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
			.getResultList();

		trans.commit();
		
		return list;	
	}
	
	/**
	 * Returns a list of movies by fulltext search in movie names and details.
	 * 
	 * @param match
	 * @return
	 */
	/*
	public synchronized List<Movie> fullTextSearchMoviesForVenue(String match) { 
        
        if(!session.isOpen()) {          
            session = factory.openSession(); 
        } 
         
        session = factory.getCurrentSession(); 
        trans = session.getTransaction(); 
         
        if (trans.getStatus() != TransactionStatus.ACTIVE) {             
            trans.begin(); 
        } 
 
        // create native Lucene query using the query DSL 
        QueryBuilder qb = fullTextSession.getSearchFactory().buildQueryBuilder().forEntity(Movie.class).get(); 
         
        if (!match.contains(" ")) { 
        query = qb 
          .keyword()
          .onField("venues.screen.movie.name") 
          .andField("venues.screen.movie.detail") 
          .matching(match) 
          .createQuery();    
        } 
         
        if (match.contains(" ")) { 
        query = qb 
                  .phrase() 
                  .onField("venues.screen.movie.name") 
                  .andField("venues.screen.movie.detail") 
                  .sentence(match)
                  .createQuery(); 
        } 
         
        // wrap Lucene query in a org.hibernate.Query 
        FullTextQuery hibQuery = fullTextSession.createFullTextQuery(query, Movie.class); 
     
        hibQuery.initializeObjectsWith( 
                ObjectLookupMethod.SECOND_LEVEL_CACHE, 
                DatabaseRetrievalMethod.QUERY 
            ); 
             
        hibQuery 
        .setCacheable(true) 
        .setCacheRegion("movies") 
        .setCacheMode(CacheMode.NORMAL); 
        
        // execute search 
        @SuppressWarnings("unchecked") 
        List<Movie> result = hibQuery.list(); 
        
        trans.commit(); 
 
        if(session.isOpen()) {           
            session.close(); 
        }  
         
        return result; 
    } 
	*/
	/**
	 * Returns location for a venue by locationId. It will be called from individual screens. 
	 * 
	 * @param name
	 * @return
	 */
	public synchronized Location getlocationForVenue(int locationId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "";

		Location location = (Location) session.createQuery(hql)
			.setParameter("mlocationId", locationId)
			.setCacheable(true)
			.setCacheRegion("location").uniqueResult();
		
		trans.commit();
		
		return location;	
	}
	
	/**
	 * Returns venue for a location by locationId.  
	 * 
	 * @param locationId
	 * @return
	 */
	public synchronized List<Venues> getVenueByLocation(int locationId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues from Venues as venues inner join venues.location where venues.location.locationId = :mlocationId";

		List<Venues> venue = session.createQuery(hql)
			.setParameter("mlocationId", locationId)
			.setCacheable(true)
			.setCacheRegion("venues").getResultList();

		trans.commit();
		
		return venue;	
	}
	
	/**
	 * Returns all movies on venues.
	 * 
	 * @return
	 */
	public synchronized List<Venues> getAllVenuesForUpdate() {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues from Venues as venues inner join venues.screen.movie";
		List<Venues> list = session.createQuery(hql)
			.setCacheable(true)
			.setCacheRegion("movies").getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	/**
	 * Returns all movies on venues.
	 * 
	 * @return
	 */
	public synchronized List<Movie> getAllMoviesOnVenues() {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues.screen.movie from Venues as venues inner join venues.screen.movie";
		List<Movie> list = session.createQuery(hql)
			.setCacheable(true)
			.setCacheRegion("movies").getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	/**
	 * Returns all location for the map.
	 * 
	 * @return
	 */
	public synchronized List<Location> getAllLocations() {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select location from Location as location";
		List<Location> list = session.createQuery(hql)
			.setCacheable(true)
			.setCacheRegion("location").getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	public synchronized Venues getLocationForVenue(int venuesId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues from Venues as venues inner join venues.location where venues.venuesId = :mVenuesId";
		Venues venue = (Venues) session.createQuery(hql)
			.setParameter("mVenuesId", venuesId)
			.setCacheable(true)
			.setCacheRegion("location").uniqueResult();
		
		trans.commit();
		
		return venue;	
	}
	
	/**
	 * Select venue:location for screening movie, i.e. where the movie, on which venue its screening happens.
	 * 
	 * @param movieId
	 * @return
	 */
	public synchronized List<Location> getLocationForMovie(int movieId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}

		String sql = "SELECT distinct * FROM book.location join book.venues on venues.location_locationId = location.locationId join book.Screen on venues.screen_screenId = Screen.screenId join book.Movie on Screen.movie_movieId = Movie.movieId where movieId = :movieId";
		List<Location> location = session.createNativeQuery(sql)
			.setParameter("movieId", movieId)
		// query.addEntity(Location.class);
			.addEntity(Location.class)
			.setCacheable(true)
			.setCacheRegion("location").getResultList();
		// criteria filters for a location, discarding all other matches for the same location, 
		// i.e. for the query; hence the criteria is the location as distinct root entity, by selecting a kind of movie
		//query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		
		trans.commit();
		
		return location;	
	}
	
	/**
	 * Returns venues for a movie.
	 * 
	 * @param movieId
	 * @return
	 */
	public synchronized List<Venues> getVenuesForMovie(int movieId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select venues from Venues as venues inner join venues.screen.movie as movie where movie.movieId = :mMovieId";

		List<Venues> list = session.createQuery(hql)
			.setParameter("mMovieId", movieId)
			.setCacheable(true)
			.setCacheRegion("venues").getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	/**
	 * Get the unique screeningDate for a movie on a venue.
	 * 
	 * @param locationId
	 * @param movieId
	 * @return
	 */
	public synchronized List<ScreeningDates> getScreeningDatesForMovieOnVenue(int locationId, int movieId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select date from ScreeningDates as date inner join date.venues.location as location where date.movieId = :mMovieId and location.locationId = :mLocationId";

		List<ScreeningDates> list = session.createQuery(hql)
			.setParameter("mMovieId", movieId)
			.setParameter("mLocationId", locationId).getResultList();
		
		trans.commit();
		
		return list;	
	}
	
	/**
	 * Returns tickets to the client.
	 * 
	 * @param screenId
	 * @param seatId
	 * @return
	 */
	public synchronized Ticket getTicket(String screenId, String seatId){
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Ticket where screen_screenId=:screenId and seats_seatNumber=:seatId";

		List<Ticket> list = session.createQuery(hql)
			.setParameter("screenId", screenId)
			.setParameter("seatId", seatId).getResultList();
		
		trans.commit();
		
		if(list.size() > 0){
		
			return list.get(0);
		}else{
			return null;
		}
		
	}
	
	/**
	 * Prepares the purchaseId for the transaction.
	 * 
	 * @param uuid
	 * @return
	 */
	public synchronized Purchase setPurchaseId(String uuid, String orderId) {

		session = factory.getCurrentSession();
		trans = session.getTransaction();

		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			trans.begin();
		}

		Purchase newPurchase = new Purchase();
		newPurchase.setUuid(uuid);
		newPurchase.setOrderId(orderId);
		newPurchase.setTime(new Date());
		
		session.save(newPurchase);
		
		Purchase purchase = session.load(Purchase.class, newPurchase.getPurchaseId());
		
		return purchase;
	}

	/**
	 * Sets the BrainTree customerId for the transaction.
	 *
	 * @param uuid
	 * @return
	 */
	public synchronized Purchase getBraintreeId(String uuid) {

		session = factory.getCurrentSession();
		trans = session.beginTransaction();

		String hql = "select purchase from Purchase as purchase where uuid = :uuid and braintree_customerId != null";

		List<Purchase> purchase = session.createQuery(hql)
			.setParameter("uuid", uuid).getResultList();

		session.getTransaction().commit();
		
		if(purchase.size() > 0) {
			return purchase.get(0);
		} else {
			return null;
		}
	}

	/**
	 * Sets the BrainTree customerId for the transaction.
	 *
	 * @param customerId
	 * @param purchaseId
	 * @return
	 */
	public synchronized Purchase setBraintreeId(String customerId, int purchaseId) {

		session = factory.getCurrentSession();
		trans = session.beginTransaction();

		String hql = "select purchase from Purchase as purchase where purchaseId = :purchaseId";

		Purchase purchase = (Purchase) session.createQuery(hql)
			.setParameter("purchaseId", purchaseId).uniqueResult();
		purchase.setBrainTreeId(customerId);
		session.saveOrUpdate(purchase);

		session.getTransaction().commit();

		return purchase;
	}
	
	/**
	 * Reserves seats for a screening, produces tickets for the purchase.
	 * 
	 * @param screeningDateId
	 * @param seats
	 * @param uuid
	 * @return
	 */
	public synchronized List<Ticket> bookTickets(int screeningDateId, List<String> seats, String uuid, String orderId) throws InterruptedException {
		
		purchase = DAO.instance().setPurchaseId(uuid, orderId);
		List<Ticket> tickets = new ArrayList<Ticket>();
		
		for (int i = 0; i < seats.size(); i++) {
		
		// because seats won't be checked (reserved) in advance, in vain
		seat = DAO.instance().getSeatForAvailability(screeningDateId, seats.get(i));
		
			if(seat.getIsReserved().equals("0")){
			
				Ticket newTic = new Ticket();
				newTic.setScreen(seat.getScreen());
				newTic.setPrice(seat.getPrice());
				newTic.setTax(seat.getTax());
				newTic.setSeats_seatNumber(seat.getSeatNumber());
				newTic.setSeats_seatRow(seat.getSeatRow());
				newTic.setSeats(seat);
				newTic.setPurchase(purchase);
				seat.setIsReserved("1");
								
				session = factory.getCurrentSession();
				
				trans = session.getTransaction();
				
				if (trans.getStatus() != TransactionStatus.ACTIVE) {
					
					trans.begin();
				}
				
				// ez mi?
				session.save(newTic.getSeats());
				//
				session.save(newTic);
				
				tickets.add(newTic);
			}
		
		}
		
		if (tickets.size() != seats.size()) {
		
			tickets.clear();
			
			session.getTransaction().rollback();
			
			Ticket newTic = new Ticket();
			newTic.setTicketId(0);
			newTic.setScreen(seat.getScreen());
			newTic.setPrice(seat.getPrice());
			newTic.setTax(seat.getTax());
			newTic.setSeats_seatNumber(seat.getSeatNumber());
			newTic.setSeats_seatRow(seat.getSeatRow());
			
			tickets.add(newTic);

		
		} else {
			
			try {
				
				// save to dB
				session.getTransaction().commit();

			} catch (Exception e) {
				
				tickets.clear();

				session.getTransaction().rollback();
				
				Ticket newTic = new Ticket();
				newTic.setTicketId(0);
				newTic.setScreen(seat.getScreen());
				newTic.setPrice(seat.getPrice());
				newTic.setTax(seat.getTax());
				newTic.setSeats_seatNumber(seat.getSeatNumber());
				newTic.setSeats_seatRow(seat.getSeatRow());

				tickets.add(newTic);

				
			}
			
		}
		
		return tickets;
	}
	
	/*
	public synchronized void saveTransactionId(String transactionId) {
		
		session = factory.getCurrentSession(); 
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select max(orderId) from Purchase";
		Query query = session.createQuery(hql);
		@SuppressWarnings("unchecked")
		List<Purchase> lastPurchase =  query.list();
		
		for(int i = 0; i < lastPurchase.size(); i++) {
		
			Purchase purchase = lastPurchase.get(i);
			purchase.setTransactionId(transactionId);
			session.save(purchase);
		}
		
		try {
		session.getTransaction().commit();

		
		} catch (Exception e) {
		
		System.out.println(e.getLocalizedMessage());
		session.getTransaction().rollback();
		}
	}
	*/
	
	/**
	 * Returns the seats after the booking transaction has been completed.
	 * 
	 * @param screeningDateId
	 * @return
	 */
	public synchronized List<Seats> updatetedSeats(int screeningDateId) {
			
		session = factory.getCurrentSession(); 
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		ScreeningDates date = (ScreeningDates)session.load(ScreeningDates.class, screeningDateId);
		
		List<Seats> seats = date.getVenues().getScreen().getSeatsForScreen();
		
		trans.commit();

		return seats;	
	}
	
	/**
	 * Deletes individual ticket, in a purchase package, of reserved seat(s), and sets the seat free.
	 * It is not applicable for purchases that are settled, unless void transaction is worked out.
	 * 
	 * @param ticketIds
	 * @param purchaseId
	 * @return
	 */
	public synchronized boolean cancelTicket(List<Integer> ticketIds, Integer purchaseId){
		
		session = factory.getCurrentSession();
		trans = session.beginTransaction();
		
		try {

		for (int i = 0; i < ticketIds.size(); i++) {
		Ticket tic = (Ticket)session.load(Ticket.class, ticketIds.get(i));
		Seats seat = (Seats)session.load(Seats.class, tic.getSeats().getSeatId());
		seat.setIsReserved("0");

		session.saveOrUpdate(seat);
		session.delete(tic);
			
		}
		
		Purchase pur = (Purchase)session.load(Purchase.class, purchaseId);
		List<Ticket> tickets = pur.getTicketsForPurchase();
		
		// remove purchase if it has no more associated ticket
		if (tickets.size() - ticketIds.size() == 0) {
			
			session.delete(pur);

		}
		
		session.getTransaction().commit();

		
		} catch (Exception e) {
			
			System.out.println(e.getLocalizedMessage());
			session.getTransaction().rollback();
			return false;
		}
		return true;
	}
	
	/**
	 * Returns all purchases per order for the user.
	 * 
	 * @return
	 */
	public synchronized List<Purchase> getPurchases(String uuid) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "select purchase from Purchase as purchase where uuid = :uuid";
		List<Purchase> list = session.createQuery(hql)
			.setParameter("uuid", uuid)
			.setCacheable(true)
			.setCacheRegion("purchases").getResultList();
		
		trans.commit();
		
		return list;
		
	}
	
	/**
	 * Deletes purchase with associated tickets
	 * 
	 * @param purchaseId
	 * @return
	 */
	public synchronized boolean deletePurchase(Integer purchaseId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		Purchase pur = (Purchase)session.load(Purchase.class, purchaseId);
		List<Ticket> ticketIds = pur.getTicketsForPurchase();
		
		for (int i = 0; i < ticketIds.size(); i++) {
			Ticket tic = (Ticket)session.load(Ticket.class, ticketIds.get(i).getTicketId());
			Seats seat = (Seats)session.load(Seats.class, tic.getSeats().getSeatId());
			seat.setIsReserved("0");

			session.saveOrUpdate(seat);
			session.delete(tic);
				
			
			}
		
		// remove purchase once it has no more associated ticket
		session.delete(pur);

		trans.commit();
		
		return true;
		
	}
	
	/**
	 * Returns tickets per purchase to the client.
	 * 
	 * @param screenId
	 * @param seatId
	 * @return
	 */
	public synchronized List<Ticket> getTicketPerPurchase(int purchaseId){
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "FROM Ticket WHERE purchase_purchaseId = :purchaseId";

		List<Ticket> list = session.createQuery(hql)
			.setParameter("purchaseId", purchaseId).getResultList();
		
		trans.commit();
		
		if(list.size() > 0){
		
			return list;
		}else{
			return null;
		}
		
	}
	
	//TODO: add controller and admin user in iOS
	public boolean deleteScreen(int screeningDateId) {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		ScreeningDates date = session.get(ScreeningDates.class, screeningDateId);				
		session.delete(date);
		
		try {			
			// save to dB
			session.getTransaction().commit();
			return true;
		} catch (Exception e) {
			session.getTransaction().rollback();
			return false;
		}
		
	}
	
	public  Screen insertNewScreen() {
		
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
				
		Location location = session.get(Location.class, 2); 
		 
        Venues venue = new Venues(); 
        venue.setVenuesId(4); 
        venue.setAddress(location.getFormatted_address()); 
        venue.setContact("Tim Roth"); 
        venue.setLocation(location); 
        venue.setName(location.getName()); 
        venue.setVenues_picture("/images/venues/urania_mozi.jpg"); 
        venue.setScreen_screenId("T11"); 
        session.save(venue); 
         
        ScreeningDates dates = new ScreeningDates(); 
        dates.setScreeningDatesId(4); 
        dates.setMovieId(1082); 
        dates.setScreeningDate(new Date()); 
        dates.setVenues(venue); 
        session.save(dates); 
        
        
        Screen screen = new Screen(); 
        screen.setScreenId("T11"); 
        screen.setMovie(session.get(Movie.class, 1082)); 
        screen.setSeats(30); 
        screen.setScreeningDates(dates); 
        session.save(screen); 
        venue.setScreen(screen); 
        session.saveOrUpdate(venue); 
         
        Seats seat = new Seats(); 
        seat.setSeatId(24); 
        seat.setIsReserved("0"); 
        seat.setScreen(screen); 
        seat.setSeatNumber("A1"); 
        seat.setSeatRow("1"); 
        seat.setPrice(1002); 
        seat.setTax(1.33); 
         
        Seats seat2 = new Seats(); 
        seat2.setSeatId(25); 
        seat2.setIsReserved("0"); 
        seat2.setScreen(screen); 
        seat2.setSeatNumber("A2"); 
        seat2.setSeatRow("1"); 
        seat2.setPrice(1002); 
        seat2.setTax(1.33); 
         
        Seats seat3 = new Seats(); 
        seat3.setSeatId(26); 
        seat3.setIsReserved("0"); 
        seat3.setScreen(screen); 
        seat3.setSeatNumber("A3"); 
        seat3.setSeatRow("1"); 
        seat3.setPrice(1002); 
        seat3.setTax(1.33); 
         
        Seats seat4 = new Seats(); 
        seat4.setSeatId(27); 
        seat4.setIsReserved("0"); 
        seat4.setScreen(screen); 
        seat4.setSeatNumber("A4"); 
        seat4.setSeatRow("1"); 
        seat4.setPrice(1002); 
        seat4.setTax(1.33); 
         
        Seats seat5 = new Seats(); 
        seat5.setSeatId(28); 
        seat5.setIsReserved("0"); 
        seat5.setScreen(screen); 
        seat5.setSeatNumber("A5"); 
        seat5.setSeatRow("1"); 
        seat5.setPrice(1002); 
        seat5.setTax(1.33); 
         
        Seats seat6 = new Seats(); 
        seat6.setSeatId(29); 
        seat6.setIsReserved("0"); 
        seat6.setScreen(screen); 
        seat6.setSeatNumber("B1"); 
        seat6.setSeatRow("2"); 
        seat6.setPrice(1002); 
        seat6.setTax(1.33); 
         
        Seats seat7 = new Seats(); 
        seat7.setSeatId(30); 
        seat7.setIsReserved("0"); 
        seat7.setScreen(screen); 
        seat7.setSeatNumber("B2"); 
        seat7.setSeatRow("2"); 
        seat7.setPrice(1002); 
        seat7.setTax(1.33); 
         
        Seats seat8 = new Seats(); 
        seat8.setSeatId(31); 
        seat8.setIsReserved("0"); 
        seat8.setScreen(screen); 
        seat8.setSeatNumber("B3"); 
        seat8.setSeatRow("2"); 
        seat8.setPrice(1002); 
        seat8.setTax(1.33); 
         
        Seats seat9 = new Seats(); 
        seat9.setSeatId(32); 
        seat9.setIsReserved("0"); 
        seat9.setScreen(screen); 
        seat9.setSeatNumber("B4"); 
        seat9.setSeatRow("2"); 
        seat9.setPrice(1002); 
        seat9.setTax(1.33); 
         
        Seats seat10 = new Seats(); 
        seat10.setSeatId(33); 
        seat10.setIsReserved("0"); 
        seat10.setScreen(screen); 
        seat10.setSeatNumber("B5"); 
        seat10.setSeatRow("2"); 
        seat10.setPrice(1002); 
        seat10.setTax(1.33); 
        session.save(seat); 
        session.save(seat2); 
        session.save(seat3); 
        session.save(seat4); 
        session.save(seat5); 
        session.save(seat6); 
        session.save(seat7); 
        session.save(seat8); 
        session.save(seat9); 
        session.save(seat10); 
         
        List<Seats> seats = new ArrayList<>(); 
        seats.add(seat10); 
        seats.add(seat9); 
        seats.add(seat8); 
        seats.add(seat7); 
        seats.add(seat6); 
        seats.add(seat5); 
        seats.add(seat4); 
        seats.add(seat3); 
        seats.add(seat2); 
        seats.add(seat); 
 
         
        screen.setSeats(seats); 
        session.saveOrUpdate(screen); 

		
		
		try {			
			// save to dB
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return screen;
	}
	
public synchronized Screen getScreenForAvailability(String movie, String Date, String Venue, String ScreeningId, String category) throws HibernateException, ParseException {
        
        session = factory.getCurrentSession();
        
        trans = session.beginTransaction();
        String hql = "from Location where name = :mLocationName";
		Location location = (Location) session.createQuery(hql)
        	.setParameter("mLocationName", Venue).uniqueResult();
        
        String hql_ = "from Movie where name = :mMovieName";
	    Movie movie_ = (Movie) session.createQuery(hql_)
        	.setParameter("mMovieName", movie).uniqueResult();
        movie_.setCategory(category);
        session.save(movie_);
        
        String hql__ = "select max(venuesId) from Venues";
		int venuesId = (int) session.createQuery(hql__).uniqueResult();
        int newVenuesId = venuesId+1;
        
        Venues venue = new Venues(); 
        venue.setVenuesId(newVenuesId); 
        venue.setAddress(location.getFormatted_address()); 
        venue.setContact("Tim Roth"); 
        venue.setLocation(location); 
        venue.setName(location.getName()); 
        venue.setVenues_picture(location.getThumbnail()); 
        venue.setScreen_screenId(ScreeningId); 
        session.save(venue); 
        session.buildLockRequest(LockOptions.UPGRADE).lock(venue);

        String hql___ = "select max(screeningDatesId) from ScreeningDates";
	    int date = (int) session.createQuery(hql___).uniqueResult();
        int newScreeningDatesId = date+1;

        ScreeningDates dates = new ScreeningDates(); 
        dates.setScreeningDatesId(newScreeningDatesId); 
        dates.setMovieId(movie_.getMovieId());

        //SimpleDateFormat formattedDate = new SimpleDateFormat("yyyy-MMM-dd HH:mm:ss");
        //Date date_ =  formattedDate.parse("2020-10-01 12:00:00");

        dates.setScreeningDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(Date)); 
        dates.setVenues(venue); 
        session.save(dates); 
        
        
        Screen screen = new Screen();
        screen.setScreenId(ScreeningId); 
        screen.setMovie(session.get(Movie.class, movie_.getMovieId())); 
        screen.setSeats(30); 
        screen.setScreeningDates(dates); 
        session.save(screen); 
        venue.setScreen(screen); 
        session.saveOrUpdate(venue); 
        
        Screen screen_ = session.load(Screen.class, screen.getScreenId(), LockMode.UPGRADE_NOWAIT);

        return screen_; 
    }
    
    public  Screen insertNewScreen(String movie, String Date, String Venue, int nrOfRows, int nrOfSeatsInRow, String ScreeningId, String category) throws HibernateException, ParseException {
        
        session = factory.getCurrentSession();
        session.setFlushMode(FlushMode.MANUAL.toJpaFlushMode());
        trans = session.getTransaction();
        
        if (trans.getStatus() != TransactionStatus.ACTIVE) {            
            trans.begin();
        }
        
        try {
        screen = DAO.instance().getScreenForAvailability(movie, Date, Venue, ScreeningId, category);
        
        } catch (HibernateException | InterruptedException e) {
        e.printStackTrace();
        session = factory.getCurrentSession();
        session.getTransaction().rollback();
        Screen error = new Screen();
        error.setScreenId("Error: "+e.getMessage());
        return error;
        }
    
        String hql_Seats = "select max(seatId) from Seats";
		int seats = (int) session.createQuery(hql_Seats).uniqueResult();
        int newSeatsId = seats+1;
        
        List<Seats> seats_ = new ArrayList<>(); 

        String [] alphabet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"};
        for(int i = 0; i<= nrOfRows; i++) {
            
            session = factory.getCurrentSession();
            
            trans = session.getTransaction();
            
            if (trans.getStatus() != TransactionStatus.ACTIVE) {                
                trans.begin();

            }
            
        for(int j = 1; j<= nrOfSeatsInRow; j++) {
            
            session = factory.getCurrentSession();
            
            trans = session.getTransaction();
            
            if (trans.getStatus() != TransactionStatus.ACTIVE) {                
                trans.begin();

            }
            
            Seats seat = new Seats(); 
            seat.setSeatId(newSeatsId++); 
            seat.setIsReserved("0"); 
            seat.setScreen(screen); 
            
            seat.setSeatNumber(alphabet[i].concat(String.valueOf(j))); 
            seat.setSeatRow(String.valueOf(i+1)); 
            seat.setPrice(3); 
            seat.setTax(1.33); 
            
            try {
            session.save(seat); 
            } catch (HibernateException e) {
            	e.printStackTrace();
            	session = factory.getCurrentSession();
            	session.getTransaction().rollback();
            	Screen error = new Screen();
            	error.setScreenId("Error: "+e.getMessage());
            	return error;
            }
            seats_.add(seat); 


            }
        }
         
        screen.setSeats(seats_); 
        session.saveOrUpdate(screen); 
        
        try {           
            // save to dB
            
            session = factory.getCurrentSession();
            session.setFlushMode(FlushMode.MANUAL.toJpaFlushMode());
            trans = session.getTransaction();
            
            if (trans.getStatus() != TransactionStatus.ACTIVE) {                
                trans.begin();
            }
            session.flush();
            session.getTransaction().commit();

        } catch (HibernateException e) {
            e.printStackTrace();
            session = factory.getCurrentSession();
            session.getTransaction().rollback();
            Screen error = new Screen();
            error.setScreenId("Error: "+e.getMessage());
            return error;
        }
        
        return screen;
    }
	
	public  Screen updateScreen(String Venue, int venuesId, int screeningDatesId, int moviesId, String screenId, String Date, String category) throws ParseException {
	
		session = factory.getCurrentSession();
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		// change venue i.e. cinema location
        String hql = "from Location where name = :mLocationName";
		Location location = (Location) session.createQuery(hql)
			.setParameter("mLocationName", Venue).uniqueResult();
        
        // keep original venuesId
		Venues venue_ = session.get(Venues.class, venuesId);
		
		// do the change here
		venue_.setLocation(location);
		venue_.setName(location.getName());
		venue_.setAddress(location.getFormatted_address());
		venue_.setContact("Quentin Tarantino");
		session.saveOrUpdate(venue_);
		
		// change date
        ScreeningDates dates = session.get(ScreeningDates.class, screeningDatesId); 
        dates.setScreeningDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(Date));
		session.saveOrUpdate(dates);
		
		// change date and movie for the venuesId
        Screen screen = session.get(Screen.class, screenId);
        Movie movie = session.get(Movie.class, moviesId);
        movie.setCategory(category);
        screen.setMovie(session.get(Movie.class, moviesId));
        session.saveOrUpdate(movie);
        session.saveOrUpdate(screen); 

		
		
		try {			
			// save to dB
			session.getTransaction().commit();
		} catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return screen;
	}
	
	public  Screen updateTrollCategory() {
		return null;
	}
}
