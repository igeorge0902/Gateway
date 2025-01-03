package com.example.interceptors;

import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.ext.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;
 
@Provider
@Compress
public class GZIPWriterInterceptor implements WriterInterceptor, ReaderInterceptor {
	 
    @Override
    public void aroundWriteTo(WriterInterceptorContext context) throws IOException, WebApplicationException {
    	
    	MultivaluedMap<String,Object> headers = context.getHeaders();
    	headers.add("Content-Encoding", "Gzip");
    	
        final OutputStream outputStream = context.getOutputStream();
        context.setOutputStream(new GZIPOutputStream(outputStream));
        context.proceed();
    }

    @Override
    public Object aroundReadFrom(ReaderInterceptorContext context) throws IOException, WebApplicationException {
        
    	List<String> header = context.getHeaders().get("Content-Encoding");
       
        // decompress gzip stream only       
    	if (header != null && header.contains("Gzip")) {
        final InputStream originalInputStream = context.getInputStream();
        context.setInputStream(new GZIPInputStream(originalInputStream));
        }
        return context.proceed();
    }
    
}
	