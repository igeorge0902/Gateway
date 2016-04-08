package com.jeet.api;

public interface BookHandler {

	public Ticket bookTicket(String movieName ) throws InvalidMovieException, BookingException;

	public Ticket getTicket(int ticketId) throws InvalidTicketException, BookingException;

	public void deleteTicket(int ticketId) throws InvalidTicketException, BookingException;
	
	public Ticket updateTicket(Ticket ticket, Movie newMovie) throws InvalidTicketException, InvalidMovieException, BookingException;
	
	public Devices getDevice(String uuid) throws BookingException;
	
	public Logins getUser(String user) throws BookingException;
	
	public Tokens getToken(String token1) throws BookingException;

}
