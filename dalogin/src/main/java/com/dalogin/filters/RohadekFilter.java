package com.dalogin.filters;

/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com 
 * 
 * @Year: 2015
 */

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;


public class RohadekFilter implements Filter
{

    @Override
    public void doFilter( ServletRequest request, ServletResponse response, FilterChain chain )
                          throws IOException, ServletException
    {
    	  HttpServletResponse response_ = (HttpServletResponse) response;
    	  //HttpServletRequest request_ = (HttpServletRequest) request;


          response_.addHeader("Cache-Control", "no-cache, must-revalidate, post-check=0, pre-check=0, proxy-revalidate"); // HTTP 1.1.
          response_.addHeader("Pragma", "no-cache"); // HTTP 1.0.

          response_.addDateHeader("Expires", 0);
          
          chain.doFilter(request, response);
    }

    @Override
    public void init( FilterConfig filterConfig )
    {        
        
    }

    @Override
    public void destroy()
    {
    }
}