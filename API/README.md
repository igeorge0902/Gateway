RESTful API component for the Gateway project
----
General Authentication Service

Copyright © 2015-2017 George Gaspar. All rights reserved.

- standard JAX-RS implementation for TomCat, GlassFish and wildFly 
- make sure you configure your container for servlets 3.0
- it uses Hibernate 5.x
- make sure to replace the jBoss logging library in the GlassFish installation to the newest version if you use GlassFish 4.x (it's because Hibernate is dependent on it and the container may attempt to use its own) [NoSuchMethodError](https://medium.com/@mertcal/using-hibernate-5-on-payara-cc242212a5d6#.n537odinq)
- it is not a mistake that the web.xml is configured for TomCat. You can find the GlassFish configuration in the [simple-service-webapp](https://github.com/igeorge0902/Gateway/tree/master/simple-service-webapp/src/main/webapp/WEB-INF)
- [wildFly settings](https://github.com/igeorge0902/Gateway/tree/master/API/wildFly)

@ wildFly
- You may need to manually include your Hibernate jar files. I have done this way, but please check the documentation how it works with whichever wildFly distribution.
- You will find a working package at AWS CodeCommit

Cookie settings and Request parameters:
----
- You can tunnel your request parameters in the HttpServletRequest object at least since Java EE 6, that you will send with the client and/or the Servlet(s) as a dispatched call to any resource.
- You may want to send cookies with the API response, where your best option is to place them into the entity response, which returns the method call! Check the available JAVA JAX-RS Api documentations.

Please read the JAX-RS documentation and examples about HttpServletRequest injection
- https://dzone.com/articles/what-is-javaxwsrscorecontext-part-4
- https://www.logicbig.com/tutorials/java-ee-tutorial/jax-rs/servlet-resources.html
- https://docs.oracle.com/javaee/6/api/javax/servlet/ServletRequest.html

Hibernate class mapping with annotations and the dB (MySql, MSSQL)
----
- I use default naming strategy, that comes out of box, which is convinient, I think. The classes have XML decorations, but I use the JSON content-type.
- If you are bold enough, and want to create the database without schema export with Hibernate, make sure that you use snake_case table name conventions, when you add i.e. Many-to- relationships, where you have to use JoinColumn, and then you just have to add the foreign key, that points to the primary key of the referenced table from the referencing one, which is like a Tickets table will have a 'purchase_purchaseId' column pointing to the 'purchaseId' in the Purchase table:

```java
@Entity
public class Ticket {
    
   @ManyToOne (cascade={CascadeType.PERSIST, CascadeType.REFRESH}, fetch=FetchType.EAGER)
    @JoinColumn(name="purchase_purchaseId")
    protected Purchase purchase;
```

The example above is in the [WildFly_TheBookMyMovie](https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-west-2#)
Ticket.java class, where I had to create an entity query relationship, like one purchase and its many tickets.

- for MSSQL the same thing goes on, but you are better off with SQL login user, instead of integratedSecurity, and you have to explicitly define the schema, in which you keep your table:

```java
@Entity
@Table(name="Ticket", schema="yourschema")
public class Ticket {
```

Once everything is up and running, you can check the sql statements in the hibernate debug logs, or MySql query log table, where you will find them in snake case interpretation. To set the MySQL to show the query logs, just run the following commands:

```sql
SET global general_log = 1;
SET global log_output = 'table';
SELECT CONVERT(argument USING utf8), event_time FROM mysql.general_log;
```

Features:
----
- provides authenticated access to the user's "profile"
- aesUtil is ready to use, only config is necessary. For more info see it at [WWW](https://github.com/igeorge0902/Gateway/tree/update/WWW)
- you may want to verify the XSRF-Token (cookie) during the API calls, which is available after a successful login. Please implement your own verification of the cookies to protect the API endpoint from direct call.
- ciphertext is to be verified upon user request, but there is an error as to it triggers a new token pair and sets wrongly the device state to 'logged_out', when you use it in TomCat cluster, since the ServeltSession Listener sessionDestroyed() method will be called each time a node goes down. I will come up with a solution.
- it's able to check if the new user, or email is used in system or not, but upon result no further action is enforced
- direct dB modifications are instantly reflected due to session is always flushed before queries.

Build from Eclipse:
- import as Maven project
- maven install
- configure your MySql connection for the proper version

Useful links:
----
Hibernate's C3P0ConnectionProvider settings
- http://www.mchange.com/projects/c3p0/#hibernate-specific
Hibernate User Guide
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html

Copyright © 2015-2017 George Gaspar. All rights reserved.
