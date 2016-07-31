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
	
	public int getNewEmail(String newemail){
		
		Session session = factory.openSession();
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
	
	public Tokens getToken2(String token1){
		
		Session session = factory.openSession();
		String hql = "from Tokens where token1 = :mToken1";
		
		Query query = session.createQuery(hql);
		query.setParameter("mToken1", token1);
		
		@SuppressWarnings("unchecked")
		List<Tokens> list_ = query.list();
		
		return list_.get(0);
	}

}
