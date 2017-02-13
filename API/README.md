RESTful API component for the Gateway project
----

- standard JAX-RS implementation for TomCat, GlassFish and wildFly 
- make sure you configure your container for servlets 3.0
- it uses Hibernate 5.x
- make sure to replace the jBoss logging library in the GlassFish installation to the newest version if you use GlassFish 4.x (it's because Hibernate is dependent on it and the container may attempt to use its own) [NoSuchMethodError](https://medium.com/@mertcal/using-hibernate-5-on-payara-cc242212a5d6#.n537odinq)
- it is not a mistake that the web.xml is configured for TomCat. You can find the GlassFish configuration in the [simple-service-webapp](https://github.com/igeorge0902/Gateway/tree/master/simple-service-webapp/src/main/webapp/WEB-INF)
- [wildFly settings](https://github.com/igeorge0902/Gateway/tree/update/API/wildFly)

Features:
----
- right now it is placed upon the Gateway dB, solely, only to access the login table for authentication (Please refer to AdminServlet.java class for usage. #Line 139)
- aesUtil is ready to use, only config is necessary
- ciphertext is to be verified upon user request
- it's able to check if the new user, or email is used in system or not, but upon result no further action is enforced

Build from Eclipse:
- import as Maven project
- maven install
- configure your MySql connection

Useful links:
----
Hibernate's C3P0ConnectionProvider settings
- http://www.mchange.com/projects/c3p0/#hibernate-specific
