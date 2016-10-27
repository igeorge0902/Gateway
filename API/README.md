RESTful API component for the Gateway project
----

- standard Jersey API implementation 
- make sure you configure your container for servlets 3.0
- it uses Hibernate 5.x
- make sure to replace the jBoss logging library in the GlassFish installation to the newest version if you use GlassFish 4.x (it's because Hibernate is dependent on it and the container may attempt to use its own)

Features:
----
- right now it is placed upon the Gateway dB, solely, only to access the login table for authentication (Please refer to the Login branch - AdminServlet.java class for usage. #Line 156)
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
