package com.jeet.service;

import java.util.List;

import com.jeet.api.BookHandler;
import com.jeet.api.BookingException;
import com.jeet.api.Devices;
import com.jeet.api.InvalidMovieException;
import com.jeet.api.InvalidTicketException;
import com.jeet.api.Logins;
import com.jeet.api.Movie;
import com.jeet.api.Screen;
import com.jeet.api.Seat;
import com.jeet.api.Ticket;
import com.jeet.api.Tokens;
import com.jeet.db.DAO;

public class BookingHandlerImpl implements BookHandler {

	public Ticket bookTicket(String movieName) throws InvalidMovieException, BookingException {
		
		Ticket ticket = null;
		Movie movie = DAO.instance().getMovie(movieName);
		Screen screen = DAO.instance().getScreen(movie);
		
		List<Seat> seats = screen.getSeat();
		
		for( Seat seat : seats){
		
			Ticket tic = DAO.instance().getTicket(screen.getScreenId(), seat.getSeatNum());
			
			if(  tic == null){
			
				Ticket newTic = new Ticket();
				newTic.setScreen(screen);
				newTic.setPrice(200);
				newTic.setSeat(seat);
				DAO.instance().bookTicket(newTic);
				
				return newTic;
			}
		}
		return ticket;
	}
	
	public Movie movieGenre(String detail) throws InvalidMovieException, BookingException {
		
		Movie movie = DAO.instance().getGenre(detail);

		return movie;
	}
	
	public Devices getDevice(String uuid) throws BookingException {
		
		Devices device = DAO.instance().getDevices(uuid);

		return device;
	}
	
	public Logins getUser(String user) throws BookingException {
		
		Logins user_ = DAO.instance().getUser(user);

		return user_;
	}
	
	public int getNewUser(String newuser) throws BookingException {
		
		int newuser_ = DAO.instance().getNewUser(newuser);

		return newuser_;
	}
	
	public Logins getUuid(String uuid) throws BookingException {
		
		Logins uuid_ = DAO.instance().getUuid(uuid);

		return uuid_;
	}
	
	public Tokens getToken(String token1) throws BookingException {
		
		Tokens token = DAO.instance().getToken(token1);

		return token;
	}


	public Ticket getTicket(int ticketId) throws InvalidTicketException, BookingException {
		
		return null;
	}

	public void deleteTicket(int ticketId) throws InvalidTicketException, BookingException {
		DAO.instance().cancelTicket(ticketId);
	}

	public Ticket updateTicket(Ticket ticket, Movie newMovie) throws InvalidTicketException, InvalidMovieException, BookingException {
		
		return null;
	}

}
