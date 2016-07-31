package com.dalogin.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;


public class HSTSFilter implements Filter {
	
	private static Logger log = Logger.getLogger(Logger.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("HSTSFilter init");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        
    	((HttpServletResponse) res).setHeader("Strict-Transport-Security", "max-age=12960000; includeSubdomains; preload");
        log.info("Added Strict-Transport-Security header to response");

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
