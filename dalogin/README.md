# General Authentication Service
(Release Candidate)

Copyright © 2015-2019 George Gaspar. All rights reserved.

## Tested (with Apache httpd fronting Tomcat, GlassFish and wildFly 10.*): OK!

Questions:
igeorge1982@gmail.com


RoadMap
----
- update Swift 5.x (with iOS event calendar)
- adding outsourced session storage so that the session objects will not be stored in the servletContext, but in a NoSQL-like dB.
[Considered dataBases](https://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis)
- addind SOAP webservice to the API (I have it working, but still experimental)

# New
### WebSocket and rabbitMQ
----
WebSocket is a full-duplex chanel for communication between client and server.
- WebSocket connection servlet and rabbitMQ send / recieve classes are included. The corresponding sample html and js file is included in the WWW app. You have to use a different secure port number on your AS for the wss connection, otherwise all the common servlet and JKMount configuration apply. 
- WebSocket for iOS Swift: [Starscream](https://github.com/daltoniam/Starscream)

rabbitMQ is a message publishing and subscribing system (or you can include the Apache Kafka Java clients, instead, or use both for your needs).
- [rabbitMQ](https://www.rabbitmq.com/getstarted.html)


Known issues (for most recent version see the update branch!):
----
- In TomCat 9.x version somehow a sessionDestroy will be called causing the tokkens to be triggered. This has to be solved, but as quick remedy you can comment out the trigger in the logout_device procedure:
```javascript
    update Tokens
    set Tokens.token1 = 0 and Tokens.token2 = 0 
	where Tokens.deviceId = deviceId_;
```
- The logic in the CustomHttpSessionListener class in attributeAdded method stopped working, however it used to do so. Just comment out. The purpuse of the implenetation was just! to create a neat list - sessionUsers - holding (user, sessionId) per deviceId. 


Donation
----
- I have been developing this project for more than one year and finally I have come to the end of it. Although this project is not commercially licenced I would like to offer the chance to donate.

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NN35ATBZCKU4Y)

Description
----

This project is about a login - registration system that can be used on WWW and iOS mobile and provides an authentication service and can be used as a Single-Sign-On service, as well, through desktop WWW, iOS mobile native, mobile WWW and mobile webview from native app because the user will have a token that will serve as the authenticator for restricted API calls.

The iOS swift code contains both type of login method from the native app, where the webview login serves as "ChangeUser" function.

The complete service system consists of several parts, layers that makes it easy to alter or extend the functionalities. The scope of the project is to demonstrate how the whole system works, starting from a user registration, user login, user accessing restricted data through authenticated API call, logout, timeout, simultenous user logins on different platforms, device login state tracking for native mobile app.

AES encryption - decryption is available across all platforms. For client specific instructions see the [WWW](https://github.com/igeorge0902/Gateway/tree/update/WWW) readMe.

The server is also able verify the client's identity, as the most important thing to know is that who rings the bell on the door! :) For this purpose XSRF-TOKEN cookie is used on all platforms, which is generated on-the-fly with a data set that unanimously binds the client. The implemented behaviour is just an example as to how you are to send the cookie with the response, and there is no verification mechanism implemented because how it shall work for one has the utmost unique requirements. For example you may wish to store such informations in the cookie that comes with the initial request of the client and can assign it the session object, too, but you would be best off by adding another column into the table where you store your tokens and you can place your cookie value string to the corresponding row identified by the deviceId. Then you wish to read this value for each API calls and match the value of this cookie sent by the request with the one you have on the server. Since you can define and use multiple datastore for a given JPA - Hibernate project, it's not a big deal to use this authentication and authorization for separate datastores. Don't forget to overwrite the cookie value string when the session gets invalidated.

For more information on how it works: [Angular’s XSRF: How It Works](https://stormpath.com/blog/angular-xsrf) The most important thing is the Angular JS has a built-in support for the XSRF-Token meaning that with such name the cookie will be automatically sent by sub-sequent requests.

You can also add your own request / response filters to do the dirty job: 
- [CSRF For Java Web Apps](https://dzone.com/articles/preventing-csrf-java-web-apps)
- and see also [Anti cross-site scripting (XSS) filter for Java web apps](https://www.javacodegeeks.com/2012/07/anti-cross-site-scripting-xss-filter.html)

# Unix epoch time
The universal implementation of Unix epoch time in all used languages made it available that all parts of the system can and does align to the elapsed time since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970 in the same format - LONG:

- Angular JS:
```javascript
var microTime = new Date().getTime();
```
- Java:
```Java
System.currentTimeMillis();
SessionCreated = session.getCreationTime();
```
- Swift:
```swift
     func getCurrentMillis()->Int64{
        
        let time = Int64(NSDate().timeIntervalSince1970 * 1000)

        return  time
    }
```

----

The general concept was to create an "entity" of a user that consists of username, uuid, password, device, voucher and login status (derived from the sessionid into the device_status table) in the context of the system. The main link should remian the uuid, I think.

The user object will be created by the following request: 


Gateway/API/src/main/java/com/jeet/rest/BookController.java, line 68:

```java
https://your_server.hu/{appName}/{contextPath}/{user}/{token1}"
```
that will be called by the following code in AdminServlet.java at line 169

```java
RequestDispatcher rd = otherContext.getRequestDispatcher(webApiContextUrl + user.trim().toString()+"/"+token_.trim().toString());
```

The appName (or application context, which is also the base URI you define for JkMount) is defined in the pom.xml with artifactId and version nr (or finalName tag - [POM Reference](https://maven.apache.org/pom.html), if you prefer it that way), and contextPath is what you set up in your web.xml

```xml
  <context-param>
    <param-name>webApiContextUrl</param-name>
    <param-value>/rest/user/</param-value>
  </context-param>
```

You define the first part of the context in the web.xml for the API (Gateway/API/src/main/webapp/WEB-INF/web.xml):

```xml
    <servlet-mapping>
        <servlet-name>jersey</servlet-name>
        <url-pattern>/rest/*</url-pattern>
    </servlet-mapping>
```

The token parameter will be retrieved from the session, which will be the "user" attribute. See between line 60 and 70 in AdminServlet.java.

User has to provide the second key (token2) of tokens by a client request, which has to belong to the first one - retrieved from the session - by a given device.

Password reset:
----
For the first step of the password reset you may have noticed a sessionToken will be created upon the email has been successfully verified. You may wish to store it and/or use it as another security checkpoint. The XSRF-Token and the browser's localStorage is not cleaned up after the password reset has been successful, which also may be useful, but it won't do no harm, however.

Important:
----
- configure your links according to your environment setup (server, webApp, iOS)!
- for the APIs make sure you place the 'hibernate-configuration-3.0.dtd' file, found in dalogin (Gateway/dalogin/src/main/resources/) or API branch (Gateway/API/src/main/java/) of the project - or alternatively you can obtain one from the internet [hibernate dtd](http://hibernate.org/dtd/) -, to the configuration folder of your As. The 'hibernate.cfg.xml' can be configured to search for it locally or publically. Please refer to the Hibernate configurations! If you happened to forget to put the dtd file into the right folder upon the first corresponding request an exception  will be thrown showing the path you must place the file to. 

Public:
```xml
<<!DOCTYPE hibernate-configuration PUBLIC "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
										 "hibernate-configuration-3.0.dtd">
```

Local:
```xml
<!DOCTYPE hibernate-configuration SYSTEM 
"http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
```

- make sure you will use your own application password for mail sending. You can set up your configuration in the properties.properties file, now.
- as of Apple requirements https is required for server connections and it will be enforced as of 1st Jan 2017. Read more about app transport security: 
[What's new in iOS 9](https://developer.apple.com/library/content/releasenotes/General/WhatsNewIniOS/Articles/iOS9.html), 
[How to migrate to HTTPS using App Transport Security when developing iOS apps](http://www.techrepublic.com/google-amp/article/how-to-migrate-to-https-using-app-transport-security-when-developing-ios-apps/?client=safari)


Documentation will be coming soon!!
----

The structure:
----
- dB layer (MySQL 5.x)
- (ORM) service model with Hibernate 5.x
- Data Access Object layer
- service methods that passes the DAO objects to the controller
- JAX-RS controller layer to provide HTTP methods
- TOMCAT 7, GlassFish 4 or wildFly 10.x servlet container as middleware component (Tomcat with crossContext enabled (required))
- APACHE httpd 2.2 server with mod_jk connector to front the application server with AJP (optional for load-balancing, otherwise you are supposed to use a webserver to properly access the header fields) -> alternatively you can use the Apache proxy modules, but I have not tested it.

Configured to run on SSL only, which is required as right now the iOS part is configured to use Certificate Authority (CA) -> [Using Self-Signed SSL Certificates with iOS](https://blog.httpwatch.com/2013/12/12/five-tips-for-using-self-signed-ssl-certificates-with-ios/)

The webserver and the application server is configured not to use cache, but it worked for me without cache settings, too!

Apache HTTPD configuration
----

- config files are included that you should use to get started. 
- it facilitates AJP protocol with separate modjk configuration file (define a loadbalancer worker and assign its routes in the designated workers.properties file. For more info, pls see the corresponding Apache documentation! 
- [Apache Connectors](http://tomcat.apache.org/connectors-doc/) 
and 
- [The Apache Tomcat Connectors - Web Server HowTo](http://tomcat.apache.org/connectors-doc/webserver_howto/apache.html)

# setup
- install openssl - for macOs you can use homebrew: brew install openssl
- build your Apache HTTP server with openssl and optionally apr included (you can use alternative installation solutions like homebrew, linux apt get install or specific to Windows) 
- [Apache Install](https://httpd.apache.org/docs/2.4/install.html), 
- [Compiling Apache for Microsoft Windows](http://httpd.apache.org/docs/current/platform/win_compiling.html), 
- [Manual install on Windows 7 with Apache and MySQL](https://docs.moodle.org/29/en/Manual_install_on_Windows_7_with_Apache_and_MySQL)

```shell
./configure \
    --prefix=/opt/httpd \
    --with-included-apr \
    --enable-ssl \
    --with-ssl=/opt/openssl-1.0.1i \
    --enable-ssl-staticlib-deps \
    --enable-mods-static=ssl
```

- install and enable mod_ssl - [How To Install Apache 2 with SSL](http://www.thegeekstuff.com/2011/03/install-apache2-ssl)
or
- install openssl with homebrew on macOs
- add your SSL Certificate in httpd-ssl.conf (example included)
- add (compile/build/install) mod_jk pointing to your Apache installation like --with-apxs=/usr/sbin/apxs
- configure your mod_jk config file and include it in your httpd.conf file - [Apache Tomcat mod_jk Connector Configuration ](https://www.mulesoft.com/tcat/apache-tomcat-mod-jk-connector-configuration), [Configure Apache to load mod_jk](https://docs.jboss.org/jbossas/docs/Server_Configuration_Guide/4/html/clustering-http-modjk.html)
- reference your uriworkermap.properties in mod_jk config file (that is necesary, but actually we won't make use of it in this configuration)
- reference your workers.properties file in mod_jk config file and set up your workers
- the actual uri contexts (#JKMount paths with corresponding worker) are defined in httpd-ssl.conf in this configuration
- create your AJP listner with the same port in your AS (Tomcat, GlassFish - [Tomcat server.xml Configuration Example](https://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-server-xml-configuration-example/), [To Enable mod_jk on GlassFish](https://docs.oracle.com/cd/E19798-01/821-1751/gixqw/index.html), [Enable SSL Between the mod_jk Load Balancer and GlassFish Server](https://docs.oracle.com/cd/E19798-01/821-1751/gjpan/index.html)

# HTTP Strict Transport Security (HSTS)
- HTTP Strict Transport Security (HSTS) is a web security policy mechanism which helps to protect websites against protocol downgrade attacks and cookie hijacking. To complete the HSTS security you must obtain a trusted certificate from a Certificate Authority that can effectively verify your host.

# More information on security headers:
[Hardening Your HTTP Security Headers](https://www.keycdn.com/blog/http-security-headers/)

Sample cache and header settings for Apache (put it inside httpd.conf or the httpd-ssl.conf):

```xml
 <IfModule mod_headers.c>
    Header unset X-Powered-By
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    Header always set X-Frame-Options SAMEORIGIN
    Header always set X-XSS-Protection 1;mode=block
    Header always set X-Content-Type-Options nosniff
    Header always set Access-Control-Expose-Headers "X-Token"
    Header always set Access-Control-Max-Age "1800"
    Header always set Access-Control-Allow-Headers "Content-Type, Origin, Authorization, Accept, X-Token, Accept-Encoding"
    Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
    Header set MyHeader "%D ms %t ms %l %i %b"
    Header echo ^M-Device
    Header set X-SSL-PROTOCOL "expr=%{SSL_PROTOCOL}"
    Header set X-SSL-CIPHER "expr=%{SSL:SSL_CIPHER}"
    Header always set Content-Security-Policy "script-src 'self' https://apis.google.com https://www.google-analytics.com https://facebook.com"
    Header always set Public-Key-Pins "pin-sha256=\"the sha256 fingerprint of your certificate\"; max-age=5184000" 
  </IfModule>
```

```xml
  <FilesMatch "\.(html|ico|pdf|flv|jpg|jpeg|png|gif|js|jsp|css|swf)$">
    Header set Cache-Control "no-store, no-cache, must-revalidate, max-age=0"
    Header set Pragma "no-cache"
  </FilesMatch>
```

Clustering:
----
- The in-memory session replication is tested with Apache Tomcat 8.x, following the official instructions. For Apache Tomcat the Cross context attribute is set to true.
- GlassFish and Wildfly settings will be included soon, but you can use a search engine to find it out
- [Running cluster of Tomcat servers behind the Web server](https://people.apache.org/~mturk/docs/article/ftwai.html)
- [TomCat clustering](https://www.mulesoft.com/tcat/tomcat-clustering)
and
- [TomCat clustering](https://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-clustering-session-replication-tutorial/)
- [TomCat Clustering How To](http://tomcat.apache.org/tomcat-9.0-doc/cluster-howto.html)

Session handling:
----
- the main config is set in the web.xml
- AS dependent settings (TomCat, GlassFish, Wildfly) must be implemented separately, with which you also have the ability to scale the resources needed for your system (only Tomcat provides built-in session persistence if you make your session attributes serializable). Please read through carefully the official documentations when configuring the ways of your session management. Basically, you can have three main options: in-memory, file store and database session persistance.

## Related links:
###### TomCat
- [Persistence Across Restarts](http://tomcat.apache.org/tomcat-9.0-doc/config/manager.html#Persistence_Across_Restarts)

###### GlassFish
- [Persistence Types on GlassFish](https://docs.oracle.com/cd/E18930_01/html/821-2418/beaha.html#beahh)

###### WildFly
- [Undertow subsystem configuration for wildFly 10.*](https://docs.jboss.org/author/display/WFLY10/Undertow+subsystem+configuration)
- [Wildfly 8.2.0.Final Model Reference](https://wildscribe.github.io/Wildfly/8.2.0.Final/%2Fsubsystem%2Fundertow%2Fservlet-container%2Findex.html)

<br>
> The project uses and needs Java JDK 1.8.x 
----
<br>

Notes on Windows:
----
There are several solutions for Windows to use GlassFish or TomCat instance behind the IIS (Please note the how-to may differ based on the version of Windows. The links I supplied worked for me on Windows 10).
- The Apache Tomcat Connectors to IIS: [ISAPI redirector for Micrsoft IIS HowTo](https://tomcat.apache.org/connectors-doc/webserver_howto/iis.html)
- Integrate Glassfish with IIS: [How to Integrate Glassfish with IIS](https://jstoup.wordpress.com/2012/04/25/how-to-integrate-glassfish-with-iis/)
- NHibernate is available as an object-relational mapping (ORM) solution for the Microsoft .NET platform. 

Notes on GlassFish
----
- you will need to replace the jBoss logging jar to the newest version because the Hibernate is dependent on it, but there are GlassFish versions that do not include to correct version. You will find this particular jar here in GLASSFISH_HOME/glassfish/modules, and then also insert a new logger at the server console referencing this logger [NoSuchMethodError](https://medium.com/@mertcal/using-hibernate-5-on-payara-cc242212a5d6#.586d31jq2). You may need to restart your computer for the changes to take effect. 

Deploy description:
----
- as for the server part can be deployed as it is, just take care of the web.xml. The current configuration shall work without modification.
- as for WWW platform deploy directly the angular js web app onto TOMCAT or GlassFish to your preferred context (Note: the AngularJS is the preferred and tested, only). If you use wildFly then you must deploy the application with Create an unmanaged deployment option. For wildFly see the [wildFly instructions](https://github.com/igeorge0902/Gateway/tree/master/API/wildFly)
- as for iOS build the project and you can use the registration/login service in native way or through webview, too. The registration without voucher is not implemented yet fully, but will work the same way as the login, just skip the related parts.


The project contains the source code of the whole system in the dedicated branch leaf.

Import the project as Existing Maven project into your Java IDE (Eclipse) and run Maven Install.

If you just want to compile, and don't make a war, use the following command:

> mvn dependency:copy-dependencies -Dmaven.test.skip=true compile


- Create your schema first if neccessary, the run the dB scripts to create the dB schema necessary to operate.
- Create the dB user for the application
- Check the web.xml if the configuration for the dB connection is correct, and every class is defined correctly
- place the hibernate-configuration-3.0.dtd file, found in dalogin (Gateway/dalogin/src/main/resources/) or API branch (Gateway/API/src/main/java/) of the project, to the configuration folder, which is the TOMCAT_BASE/bin or your GLASSFISH_DOMAIN/config, or alternatively you can obtain one from the internet, if you use local dtd access in your hibernate.cfg.xml. Please refer to the Hibernate configuration! 
- Listeners are initialized with annotations, but you can change it back to use them directly using the web.xml (Please refer to the Java Http Servlet documentation for it)
- Place the required log configuration files into the right class folder, and configure it for your needs, if neccessary! This will be changed to be taken care of by the deployment.
- Insert initial vouchers, with activation flags set, into the voucher_states table, if you want to have registration, or just put a username and a hashed password (with the same hashing algorithm that you selected in your client apps - if you had made any changes to the code base) into the logins table. 
- Registration workflow is implemented with or without voucher and activation, but servlets and URI paths must be configured in the web.xml as to which one to use!
- Unique username and email checking is done by the underlying dB, and the supplied API will perform the check, only, without enforcement.
- The servlet context also makes it available to check the active users with a designated API call. You can found it in the [simple-service-webapp](https://github.com/igeorge0902/Gateway/tree/update/simple-service-webapp) 
- Remove the three unnecessary request overloads from the iOS app ("isCachable"), if needed.

After you have built and deployed all parts (web app, iOS) of the service, you have to be able to access the site and use the system. Start registration process and the login through WWW (mobile, too), native iOS and iOS webview from the app.

Usage:
----
- For registration you need to provide a preset and available voucher, username, email and password. After having successfully registered or logged in, you will receive a token part that you need to use for API calls. Upon each login you will receive a new token part. You will find examples in the example database. 
- Based on which type of registration you have implemented you may need to activate a voucher to access the restricted API. You can send an email to the email address you have given during the registration. (Registration without voucher workflow is supplied in the code base, however it may not be fully functional as I did some changes recently.) It is not the scope of the project to go beyond successfully recieving the response through the restricted API call, so voucher activation will not be implemented neither the registration through webview. Your part comes in to extend the code.
- For login you need to provide a valid username and password. The password is immediately transformed using sha3 hashing algoritm and that will be stored in the database. The password is a field of char type in the database. 
- After your session has been invalidated you will not be able to access the user data through the designated API call because that requires a valid token part to authenticate (once the session has been invalidated, the token will be overwritten automatically on the server, therefor the client will not know it!). You will recieve an error message when trying to access restricted data after session invalidation.
- there is a parameter in the web.xml that sets the time intervallum for the requests to be completed. This feature has been added only for performance testing purposes.

Authentication process:
----
- authentication will happen with user supplied and system generated data on the front-end that will have to match on the server where these data will be re-generated and validated. For this purpose HMAC (hashed message authentication) is used. The hmac signature will be generated on the fly before the client sends out the request. Basically the hmac will take all the necessary arguments and then will create the signature that will be regenerated on the server with the same arguments. Because the server has fix string parameters along with the supplied arguments, it can work as a secure tool to verify the request and the integrity of the data in the request the came through the internet. 
- For more information on hmac interoperabilty: [hmac interoperability for multiple systems](http://www.jokecamp.com/blog/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/#js).

- With great effort put into work on iOS the deviceId will be the real ID of the iPhone device. This is a very important step in providing the ability to have the actual device ID that we can track in all cases regardless the user logs in through native authentication, or the webview from the native app. To track a WWW and mobile WWW device login state have never been in scope.

Maintenance:
----
- there are four tables that are very sensitive and if you modify them separately unexpected behaviour may occur: Last_seen, Tokens, device_states, devices.
- if you want to clear / clean up the dB or of devices, but not of the user, because something went wrong, you need to truncate all the following tables:  Last_seen, Tokens, device_states, devices. 

About the WebView login:
----
- it will use a redirection: basically the browser in the webview will tell the server it uses a mobile browser and as such is going to use a designated headerField called M, too. 

In iOS, all the requests are going to be copied into a new mutable one, that go through the url protocol (NSURLProtocol). The protocol can and will set a header value for these particular NEW requests, and these new requests are going to make the actual connection, with the added headerField. 

The js in the webView is going to pick up this value that is set into the headerField M, but it checks only if its value is undefined or not, and sets the "window.location.href" according to the server response: As the iOS has set the value for the headerField already, the server is going to know that a redirection must be carried out, and the iOS will close the webView after the redirect has been completed out successfully, using the shouldStartLoadWith delegate, knowing that the webView has finished the redirect successfully. 

The meaning of such redirect is that the iOS, and the WWW app in the WebView will know quickly, if/when the login has succeeded. 

After the redirect has beed carried out successfully the iOS app has recieved the server response (NSData) and finalized the user login process in the app initiated through the webview, the user can access restricted data through the API, using the generated token pairs, which is when we call a subsequent request to the /login/admin (AdminServlet). These user variables are going to be up-to-date for the particular user specifically and always.

```swift
                    requestLogin = RequestManager(url: adminUrl!, errors: "")
                    
                    requestLogin?.getResponse {
                        (json: JSON, error: NSError?) in
                        
                        print(json)
                        
                    }
```

RoadMap:
----
- Angular JS update to the most newest possible version
- DONE -> I will update the project with configs for Wildfly 10.1.0 soon. The mobile part is already done. Stay tuned!
- DONE -> only for the API upgrade instructions to Hibernate 5.x with c3p0 connection pool library (independent from AS container)

Note:
----
Last update: 2019.11.27.

Copyright © 2015-2019 George Gaspar. All rights reserved.
