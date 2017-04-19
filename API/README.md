RESTful API component for the Gateway project
----
General Authentication Service

Copyright © 2015-2017 George Gaspar. All rights reserved.

- standard JAX-RS implementation for TomCat, GlassFish and wildFly 
- make sure you configure your container for servlets 3.0
- it uses Hibernate 5.x
- make sure to replace the jBoss logging library in the GlassFish installation to the newest version if you use GlassFish 4.x (it's because Hibernate is dependent on it and the container may attempt to use its own) [NoSuchMethodError](https://medium.com/@mertcal/using-hibernate-5-on-payara-cc242212a5d6#.n537odinq)
- it is not a mistake that the web.xml is configured for Jersey on TomCat. You can find the Jersey on TomCat and GlassFish configuration in the [simple-service-webapp](https://github.com/igeorge0902/Gateway/tree/master/simple-service-webapp/src/main/webapp/WEB-INF)
- [wildFly settings](https://github.com/igeorge0902/Gateway/tree/update/API/wildFly)

Features:
----
- provides authenticated access to the user's "profile"
- aesUtil is ready to use, only config is necessary. For more info see it at [WWW](https://github.com/igeorge0902/Gateway/tree/update/WWW)
- you may want to verify the XSRF-Token during the API calls, which is available after a successful login
- ciphertext is to be verified upon user request
- it's able to check if the new user, or email is used in system or not, but upon result no further action is enforced
- direct dB modifications are instantly reflected due to session is always flushed before queries.

Build from Eclipse:
- import as Maven project
- maven install
- configure your MySql connection

Useful links:
----

For TomCat and GlassFish you can use the Jersey implementation of the JAX-RS:
[Jersey REST API](https://jersey.java.net/documentation/latest/jaxrs-resources.html#d0e2822)

For wildFly you are better off to use the RESTEasy implementation:
[RESTEasy](https://docs.jboss.org/resteasy/2.0.0.GA/userguide/html_single/#_Context)
-> see the pre-confiured web.xml [wildFly](https://github.com/igeorge0902/Gateway/blob/master/API/wildFly/web.xml)

Hibernate's C3P0ConnectionProvider settings
- http://www.mchange.com/projects/c3p0/#hibernate-specific

Copyright © 2015-2017 George Gaspar. All rights reserved.
