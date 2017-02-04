#General Authentication Service @George Gaspar
(Release Candidate)


#Tested (with Apache httpd fronting Tomcat or GlassFish): OK!

Questions:
igeorge1982@gmail.com

Update
----
- Registration is considered to be finished combined with voucher activation
- native, mobile web &webView login, registration are considered to be complete (session object is going to be attached any time and request/response headers carry the necessary key/values to communicate with the server in specific occasions, over all the three platforms)

# New
WebSocket and rabbitMQ
----
- WebSocket connection servlet and rabbitMQ send / recieve classes are included. The corresponding sample html and js file is included in the WWW app. You have to use a different secure port number on your AS for the wss connection, otherwise all the common servlet and JKMount configuration apply.

Description
----

The complete service system consists of several parts, layers that makes it easy to alter or extend the functionalities. The server part can be deployed as it is, just take care of the web.xml. The current configuration shall work without modification.

- as for WWW platform deploy directly the angular js web app onto TOMCAT or GlassFish to your preferred context (Note: the AngularJS is the preferred and tested, only)
- as for iOS build the project and you can use the registration/login service in native way or through webview, too. The registration is not implemented yet fully, but will work the same way as the login.

The iOS swift code contains both type of login method, where the webview login serves as "ChangeUser" function.

Important:
----
- configure your links according your environment setup (server, webApp, iOS)!
- make sure you place the hibernate-configuration-3.0.dtd file, found at the resource folder of the dalogin project, to the configuration folder, which is the TOMCAT_BASE/bin or your GLASSFISH_DOMAIN/config, or alternatively you can obtain one from the internet and use it with the default configuration that needs web access. Please refer to the Hibernate configuration! 

Documentation will be coming soon!!
----

The structure:
----
- dB layer (MySQL 5.x)
- (ORM) service model with Hibernate 5.1:
- Data Access Object layer
- RESTful service methods that passes the DAO objects to the controller
- RESTful controller layer to provide HTTP methods
- TOMCAT 7 or GlassFish 4 servlet container as middleware component (Tomcat with crossContext enabled (required))
- APACHE httpd 2.2 server with mod_jk connector to front TOMCAT or GlassFish with AJP (optional for load-balancing) 

Configured to run on SSL only, which is required as right now the iOS part is configured to use Certificate Authority (CA) -> https://blog.httpwatch.com/2013/12/12/five-tips-for-using-self-signed-ssl-certificates-with-ios/)

The webserver and the application server is configured not to use cache, but it worked for me without cache settings, too!

Apache HTTPD configuration files are included that you should use to get started.

Cache Settings for Apache (put it inside httpd.conf or the httpd-ssl.conf):

  <IfModule mod_headers.c>
    Header unset X-Powered-By
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    Header always set X-Frame-Options DENY
    Header always set X-Frame-Options SAMEORIGIN
    Header always set X-XSS-Protection 1;mode=block
    Header always set X-Content-Type-Options nosniff
    Header always set Access-Control-Expose-Headers "X-Token"
    Header always set Access-Control-Max-Age "1800"
    Header always set Access-Control-Allow-Headers "X-Requested-With, Content-Type, Origin, Authorization, Accept, X-Token, Accept-Encoding"
    Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
  </IfModule>

  <FilesMatch "\.(html|ico|pdf|flv|jpg|jpeg|png|gif|js|jsp|css|swf)$">
    Header set Cache-Control "no-store, no-cache, must-revalidate, max-age=0"
    Header set Pragma "no-cache"
  </FilesMatch>

The project uses and needs Java JDK 1.8.x 
----

Notes on Windows:
- mod_jk - ISAPI redirector - NSAPI redirector is available as connector for IIS
- NHibernate is available as an object-relational mapping (ORM) solution for the Microsoft .NET platform. 

Notes on GlassFish:
- you will need to replace the jBoss logging jar to the newest version because of the Hibernate that is used in the APIs. You will find this jar here in GLASSFISH_HOME/glassfish/modules, and then also insert a new logger at the server console referencing this logger.

Deploy description:
----
The project contains the source code of the whole system in the dedicated branches.

Import the project as Existing Maven project into your Java IDE (Eclipse) and run Maven Install.

If you just want to compile, and don't make a war, use the following command:

mvn dependency:copy-dependencies -Dmaven.test.skip=true compile


- Run the dB scripts to create the dB schema necessary to operate.
- Create the dB user for the application
- Check the web.xml if the configuration is correct, and every class is defined correctly
- Listeners are initialized with annotations, but you can change it back to use them directly using the web.xml (Please refer to the Java Http Servlet documentation for it)
- Place the required log configuration file into the right class folder, and configure it for your needs!
- Insert initial vouchers with activation flags set into the voucher_states table, if you want to have registration, or just put a username and a hashed password (with the same hashing algorithm that you selected in your client apps - if you had made any changes to the code base) into the logins table. 
- Registration workflow is implemented with or without voucher activation, but servlets must be configured in the web.xml!
- Unique username and email checking is not implemented yet fully, but the supplied API will perform the check
- The servlet context also makes it available to check the active users with a designated API call  (There is one supplied I have used that will make good use of on GlassFish where there is no detaild active sessions list apart from Tomcat)

After you have built and deployed all parts (web app, iOS) of the service, you have to be able to login through WWW (mobile, too), native iOS and iOS webview from the app.

Maintenance:
- there are four tables that are very sensitive and if you modify them separately unexpected behaviour may occur: Last_seen, Tokens, device_states, devices.
- if you want to clear / clean up the dB or of devices, but not of the user, because something went wrong, you need to truncate all the following tables:  Last_seen, Tokens, device_states, devices. 

The general concept was to create an "entity" of a user that consists of username, uuid, password, device, voucher and login status(derived from the sessionid into the device_status table) in the context of the system. The main link should remian the uuid, I think.

Usage:
- For registration you need to provide a preset and available voucher, username, email and password. After having successfully registered or logged in, you will receive a token part that you need to use for API calls. Upon each login you will receive a new token part. I tested it only on WWW.
- For login you need to provide a valid username and password. After your session has been invalidated you will not be able to access the user data through the designated API call that requires a valid token part to authenticate (once the session has been invalidated, the token will be overwritten automatically).  
- there is a parameter in the web.xml that sets the time intervallum for the requests to be completed. This feature has been added only for performance testing purposes.

Authentication process:
- authentication will happen with user supplied and system generated data on the front end that will have to match on the server where these data will be re-generated and validated. For this purpose HMAC (hashed message authentication) is used that will be generated on the fly, and some of its components, too, with the aim to make the process secure.

- on iOS the deviceId will not be identical for the first time when you login through the webview, only after app restart. It is due to the fact that the deviceId is generated from code in the angular js, but the device will supply its own id that will be placed into the js that is saved into the cache.

About the WebView login:
----
- it will use a redirection: basically the browser in the webview will tell the server it uses a mobile browser and as such is going to use a designated headerField called M, too. 

In iOS, as all the requests are going to be copied into a new one, that go through the url protocol (NSURLProtocol), the protocol can and will set a header value for these particular NEW requests, and these new requests are going to make the actual connection, with the added headerField. 

The js in the webView is going to pick up this value that is set into the headerField, but it checks only if its value is undefined or not, and makes an empty redirect to the same location as the server does: As the iOS has set the value for the headerField already, the server is going to know that a redirection must be carried out, and the iOS will close the webView after the redirect has been carried out successfully, knowing that the webView has finished the redirect successfully. 

The meaning of such redirect is that the iOS will know quickly if the login has succeeded. 

After the redirection has been taken place, the server will supply the necessary data for the mobile so that the user can access restricted data through the API, using the generated token pairs. These user variables are going to be up-to-date for the particular user specifically and always.
