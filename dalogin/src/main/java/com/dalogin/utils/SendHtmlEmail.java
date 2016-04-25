package com.dalogin.utils;

import java.util.*; 
import javax.mail.*; 
import javax.mail.internet.*;

import org.apache.log4j.Logger; 

public class SendHtmlEmail { 
	
	static Properties mailServerProperties;
	static Session getMailSession;
	static MimeMessage generateMailMessage;
	private volatile static String emailBody;
	
	private static Logger log = Logger.getLogger(Logger.class.getName());

	/*
	public static void main(String args[]) throws AddressException, MessagingException {
		generateAndSendEmail();
		System.out.println("\n\n ===> Your Java Program has just sent an Email successfully. Check your email..");
	}*/
	
	public static void generateAndSendEmail(String email, String url) throws AddressException, MessagingException {
		 
		// Step1
		log.info("\n 1st ===> setup Mail Server Properties..");
		
		mailServerProperties = System.getProperties();
		mailServerProperties.put("mail.smtp.port", "587");
		mailServerProperties.put("mail.smtp.auth", "true");
		mailServerProperties.put("mail.smtp.starttls.enable", "true");
		
		log.info("Mail Server Properties have been setup successfully..");
 
		// Step2
		log.info("\n\n 2nd ===> get Mail Session..");
		
		getMailSession = Session.getDefaultInstance(mailServerProperties, null);
		generateMailMessage = new MimeMessage(getMailSession);
		generateMailMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
		generateMailMessage.setSubject("Greetings from Crunchify..");
		
		emailBody = "Test email: "+ url + "<br><br> Regards, <br>GG";
		
		generateMailMessage.setContent(emailBody, "text/html");
		
		log.info("Mail Session has been created successfully..");
 
		// Step3
		log.info("\n\n 3rd ===> Get Session and Send mail");
		Transport transport = getMailSession.getTransport("smtp");
 
		// Enter your correct gmail UserID and Password
		// if you have 2FA enabled then provide App Specific Password
		transport.connect("smtp.gmail.com", "igeorge1982", "epgxkbdhawcbpcrr");
		transport.sendMessage(generateMailMessage, generateMailMessage.getAllRecipients());
		transport.close();
	}
}
		
		
	
	