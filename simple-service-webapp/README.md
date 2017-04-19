RESTful API component for the Gateway project

Copyright © 2015-2017 George Gaspar. All rights reserved.

- standard JAX-RS implementation 
- make sure you configure your container for servlets 3.0
- this web.xml is configured for Jersey on GlassFish, but it works on TomCat, also. [TomCat](https://github.com/igeorge0902/Gateway/tree/update/API/src/main/webapp/WEB-INF), [wildFly](https://github.com/igeorge0902/Gateway/tree/update/API/wildFly)

Feature set:
- it checks the active user sessions in the /login context on the server. 
For more info on it: [ServletContext class info](https://tomcat.apache.org/tomcat-9.0-doc/servletapi/javax/servlet/ServletContext.html)
- in TomCat clustered setup the app listening on the ../simple-service-webapp/webapi/myresource/admin URI can read the /login context on all nodes. You may need to set crossContext flag in context.xml:

```xml
<Context crossContext="true">     

</Context>
```

[Common Attributes of context.xml](https://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-context-xml-configuration-example/)

- in other application servers, however, the setup is different, since the context is managed by the container, but within the same server instance it is possible to access the context through the 

```java
ServletContext otherContext = context.getContext("/login");
```
calling, if we inject the @Context annotation and pass the 

```java
@Context ServletContext context
```
as method parameter to our endpoint.

This is a standard JAX-RS method, and the @Context annotation allows you to inject instances of javax.ws.rs.core.HttpHeaders, javax.ws.rs.core.UriInfo, javax.ws.rs.core.Request, javax.servlet.HttpServletRequest, javax.servlet.HttpServletResponse, javax.servlet.ServletConfig, javax.servlet.ServletContext, and javax.ws.rs.core.SecurityContext objects, as well.

For TomCat and GlassFish you can use the Jersey implementation of the JAX-RS:
[Jersey REST API](https://jersey.java.net/documentation/latest/jaxrs-resources.html#d0e2822)

For wildFly you are better off to use the RESTEasy implementation:
[RESTEasy](https://docs.jboss.org/resteasy/2.0.0.GA/userguide/html_single/#_Context)
-> see the pre-confiured web.xml [wildFly](https://github.com/igeorge0902/Gateway/blob/master/API/wildFly/web.xml)

# How it works
We pass the retrieved sessions from the context as a Set to the DAO class, which uses the Sessions.java @Entity class to create our resource object to be returned. However, you may find a trouble with your sessions chart list, since the incrementation is odd. It's a known issue. :)  


Build from Eclipse:
- import as Maven project
- maven install

Copyright © 2015-2017 George Gaspar. All rights reserved.
