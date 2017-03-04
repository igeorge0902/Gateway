package com.jeet.db;

import java.util.List;
import org.hibernate.FlushMode;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.resource.transaction.spi.TransactionStatus;
import org.hibernate.stat.Statistics;
import com.jeet.api.Devices;
import com.jeet.api.Logins;
import com.jeet.api.Tokens;

public class DAO {

	private static DAO instance;
	private SessionFactory factory;
	private static volatile Session session;
	private static volatile Transaction trans;


	/**
	 * Intantiate DAO class that loads configured SessionFactory object. 
	 * 
	 * You can also configure further settings for the session. 
	 * 
	 */
	private DAO() {

		factory = HibernateUtil.getSessionFactory();
		System.out.println("Creating factory");

		Statistics stats = factory.getStatistics(); 
		stats.setStatisticsEnabled(true);
		
		session = factory.openSession();
		session.setFlushMode(FlushMode.ALWAYS);

		
	}

	/**
	 * DAO instance is always synchronized, for sake of memory consistency, 
	 * and we use a shared static session object.
	 * 
	 * @return DAO instance
	 */
	public static synchronized DAO instance() {
		if (instance == null) {
			instance = new DAO();
		}
		return instance;
	}
	
	public synchronized List<Devices> getDevices(String uuid){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		
		} else {
		
			session = factory.getCurrentSession();
		
		}
	    
		trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Devices where uuid = :mUuid";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUuid", uuid);
		
		@SuppressWarnings("unchecked")
		List<Devices> list = query.list();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 

		if (list.isEmpty()) {
			
			Devices dev = new Devices();
			dev.setDevice("The user does not have devices");
			dev.setId(0);
			dev.setUuid(uuid);
			
			list.add(dev);
			
		}
		
		return list;
	}
	
	public synchronized Logins getUser(String user){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Logins where user = :mUser";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUser", user);
		
		Logins user_ = (Logins) query.uniqueResult();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 
		
		if (user_ == null) {
			
			Logins ls = new Logins();
			ls.setId(0);
			ls.setUser(user);
			ls.setUuid("no UUID");	
			ls.setEmail("no email");
			
			return ls; 
			
		} else
		
		return user_;
	}
	
	public synchronized int getNewUser(String newuser){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
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
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 

		if (list_.isEmpty()) {
		
		return list_.size();
	} else {
		return list.size(); }
	}
	
	public synchronized int getNewEmail(String newemail){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}

		String hql = "from Logins where email like :mEmail";
		String hql_ = "from Logins where email = :mEmail";

		Query query = session.createQuery(hql);
		query.setParameter("mEmail", newemail+"%").list();
		
		Query query_ = session.createQuery(hql_);
		query_.setParameter("mEmail", newemail).list();
		
		@SuppressWarnings("unchecked")
		List<Logins> list = query.list();
		@SuppressWarnings("unchecked")
		List<Logins> list_ = query_.list();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 
		
		if (list_.isEmpty()) {
		
		return list_.size();
	} else {
		return list.size(); }
	}
	
	public synchronized Logins getUuid(String uuid){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Logins where uuid = :mUuid";
		
		Query query = session.createQuery(hql);
		query.setParameter("mUuid", uuid);
		
		Logins ilu = (Logins) query.uniqueResult();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 
		
		return ilu;
	}
	
	public synchronized Tokens getToken(String token1){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Tokens where token1 = :mToken1";
		
		Query query = session.createQuery(hql);
		query.setParameter("mToken1", token1);
		
		Tokens token_taylor = (Tokens) query.uniqueResult();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 
		
		return token_taylor;
	}
	
	public synchronized Tokens getToken2(String token1){
		
		if(!session.isOpen()) {			
			session = factory.openSession();
		}
		
		session = factory.getCurrentSession();
		
	    trans = session.getTransaction();
		
		if (trans.getStatus() != TransactionStatus.ACTIVE) {
			
			trans.begin();
		}
		
		String hql = "from Tokens where token1 = :mToken1";
		
		Query query = session.createQuery(hql);
		query.setParameter("mToken1", token1);
		
		Tokens token_swift = (Tokens) query.uniqueResult();
		
		trans.commit();
		
		if(session.isOpen()) {			
			session.close();
		} 
		
		return token_swift;
	}

}
