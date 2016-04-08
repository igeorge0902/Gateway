package com.jeet.db;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.api.Movie;
import com.jeet.api.Screen;
import com.jeet.api.Ticket;
import com.jeet.api.Tokens;

public class DAO {

	private static DAO instance;
	private SessionFactory factory;

	private DAO() {
		Configuration conf = new Configuration();
		conf.configure();
				
		StandardServiceRegistry reg = new StandardServiceRegistryBuilder().applySettings(conf.getProperties()).build();
		factory = conf.buildSessionFactory(reg);
		
		System.out.println("Creating factory");
	}

	public static synchronized DAO instance() {
		if (instance == null) {
			instance = new DAO();
		}
		return instance;
	}
	
	public Screen getScreen(Movie movie){
		
		Session session = factory.openSession();
		String hql = "from Screen where movie_movieId = :mId";
		
		Query query = session.createQuery(hql);
		query.setParameter("mId", movie.getMovieId());
		
		@SuppressWarnings("unchecked")
		List<Screen> list = query.list();
		
		session.close();
		return list.get(0);
	}
	
	public Movie getMovie(String movieName){
		
		Session session = factory.openSession();
		String hql = "from Movie where name = :mName";
		
		Query query = session.createQuery(hql);
		query.setParameter("mName", movieName);
		
		@SuppressWarnings("unchecked")
		List<Movie> list = query.list();
		
		return list.get(0);
	}
	
	public Movie getGenre(String detail){
		
		Session session = factory.openSession();
		String hql = "from Movie where detail = :mDetail";
		
		Query query = session.createQuery(hql);
		query.setParameter("mDetail", detail);
		
		@SuppressWarnings("unchecked")
		List<Movie> list = query.list();
		
		return list.get(0);
	}
	
	public Devices getDevices(String uuid){
		
		Session session = factory.openSession();
		String hql = "from Devices where uuid = :mUuid";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUuid", uuid);
		
		@SuppressWarnings("unchecked")
		List<Devices> list = query.list();
		
		return list.get(0);
	}
	
	public Logins getUser(String user){
		
		Session session = factory.openSession();
		String hql = "from Logins where user = :mUser";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUser", user);
		
		@SuppressWarnings("unchecked")
		List<Logins> list = query.list();
		
		ArrayList<Logins> elements = new ArrayList<>();
		elements.add(list.get(0));
		
		return list.get(0);
	}
	
	public int getNewUser(String newuser){
		
		Session session = factory.openSession();
		String hql = "from Logins where user like :mUser";
		String hql_ = "from Logins where user = :mUser";

		Query query = session.createQuery(hql);
		query.setParameter("mUser", newuser+"%").list();
		
		Query query_ = session.createQuery(hql_);
		query_.setParameter("mUser", newuser).list();
		
		@SuppressWarnings("unchecked")
		List<Logins> list = query.list();
		@SuppressWarnings("unchecked")
		List<Logins> list_ = query_.list();

		if (list_.isEmpty()) {
		
		return list_.size();
	} else {
		return list.size(); }
	}
	
	public Logins getUuid(String uuid){
		
		Session session = factory.openSession();
		String hql = "from Logins where uuid = :mUuid";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUuid", uuid);
		
		@SuppressWarnings("unchecked")
		List<Logins> list = query.list();
		
		return list.get(0);
	}
	
	public Tokens getToken(String token1){
		
		Session session = factory.openSession();
		String hql = "from Tokens where token1 = :mToken1";
		
		Query query = session.createQuery(hql);
		query.setParameter("mToken1", token1);
		
		@SuppressWarnings("unchecked")
		List<Tokens> list = query.list();
		
		return list.get(0);
	}
	
	public Ticket getTicket(String screenId, String seatId){
		
		Session session = factory.openSession();
		String hql = "from Ticket where screen_screenId=:screenId and seat_seatNum=:seatId";
		
		Query query = session.createQuery(hql);
		query.setParameter("screenId", screenId);
		query.setParameter("seatId", seatId);
		
		@SuppressWarnings("unchecked")
		List<Ticket> list = query.list();
		
		if(list.size() > 0){
		
			return list.get(0);
		}else{
			return null;
		}
		
	}
	
	public Ticket bookTicket(Ticket ticket){
		
		Session session = factory.openSession();
		System.out.println("DAO.bookTicket()");
		
		session.beginTransaction();
		session.save(ticket);
		session.getTransaction().commit();
		
		return ticket;
	}
	
	public Movie movieGenre (String detail) {
		Session session = factory.openSession();
		session.beginTransaction();
		Movie movie = (Movie)session.load(Movie.class, detail);
		return movie;
	}
	
	public void cancelTicket(int ticketId){
		
		System.out.println(ticketId);
		Session session = factory.openSession();
		
		Transaction trx = session.beginTransaction();
		Ticket tic = (Ticket)session.load(Ticket.class, ticketId);
		
		session.delete(tic);
		trx.commit();
		session.close();
	}

}
