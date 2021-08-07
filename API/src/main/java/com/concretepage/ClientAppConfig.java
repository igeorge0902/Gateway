package com.concretepage;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.transport.WebServiceMessageSender;
import org.springframework.ws.transport.http.HttpComponentsMessageSender;

@Configuration
public class ClientAppConfig {
	@Bean
	public Jaxb2Marshaller marshaller() {
		Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
		marshaller.setContextPath("com.concretepage.wsdl");
		return marshaller;
	}
	
	  @Bean
	  public WebServiceMessageSender webServiceMessageSender() {
	    HttpComponentsMessageSender httpComponentsMessageSender = new HttpComponentsMessageSender();
	    // timeout for creating a connection
	    httpComponentsMessageSender.setConnectionTimeout(29);
	    // when you have a connection, timeout the read blocks for
	    httpComponentsMessageSender.setReadTimeout(29);
	    return httpComponentsMessageSender;
	}
	  
	@Bean
	public StudentClient studentClient(Jaxb2Marshaller marshaller) {
		StudentClient client = new StudentClient();
		client.setDefaultUri("http://localhost:8082/spring4soap-1/soapws/students.wsdl");
		client.setMarshaller(marshaller);
		client.setUnmarshaller(marshaller);
		return client;
	}
	
	@Bean
	public StudentClient2 studentClient2(Jaxb2Marshaller marshaller) {
		StudentClient2 client = new StudentClient2();
		client.setDefaultUri("http://localhost:8082/spring4soap2-1/soapws2/students.wsdl");
		client.setMarshaller(marshaller);
		client.setUnmarshaller(marshaller);
		return client;
	}
}
