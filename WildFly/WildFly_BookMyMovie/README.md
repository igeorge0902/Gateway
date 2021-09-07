RESTful API component for the Gateway project

- standard Jersey API implementation 
- make sure you configure your container for servlets 3.0
- it uses Hibernate 5.x
- make sure to replace the jBoss logging library in the GlassFish installation to the newest version if you use GlassFish 4.x (it's because Hibernate is dependent on it and the container may attempt to use its own)

Features:
- user API
- Jax-RS @Context filters to validate requests, request properties from ServletDispatchers 

Build from Eclipse:
- import as Maven project
- maven install
- configure your MySql connection
