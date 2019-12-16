# General Authentication Service - GAS 

Copyright © 2015-2019 George Gaspar. MIT License.

Apache HTTPD configuration
----

- config files are included that you should use as a template to get started, just modify it for your local configuration. 
- it facilitates AJP protocol with separate modjk configuration file (define a loadbalancer worker and assign its routes in the designated workers.properties file. For more info, pls see the corresponding Apache documentation! 
- [Apache Connectors - mod_jk](http://tomcat.apache.org/connectors-doc/) 
and 
- [The Apache Tomcat Connectors - Web Server HowTo](http://tomcat.apache.org/connectors-doc/webserver_howto/apache.html)

# setup
- install openssl - for macOs you can use homebrew: brew install openssl
- build your Apache HTTP server with openssl and optionally apr included (you can use alternative installation solutions like homebrew, linux apt get install or specific to Windows) 
- [Apache Install](https://httpd.apache.org/docs/2.4/install.html), 
- [Compiling Apache for Microsoft Windows](http://httpd.apache.org/docs/current/platform/win_compiling.html), 
- [Manual install on Windows 7 with Apache and MySQL](https://docs.moodle.org/29/en/Manual_install_on_Windows_7_with_Apache_and_MySQL)
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


# Additional mods, that may consider
- Since it is a complex system, you shall understand the importance of logging. Please take note on the following add-ons, that will satisfy the most eager eyes, too:

[Forensic Logging](https://httpd.apache.org/docs/2.4/mod/mod_log_forensic.html)
[Headers](https://httpd.apache.org/docs/2.4/mod/mod_headers.html)
[Cache Control](https://httpd.apache.org/docs/2.4/mod/mod_cache.html)


# Recommended config for the headers
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


# Contacts:
- email: igeorge1982@gmail.com (primary), igeorge1982@hotmail.com, igeorge1982@yahoo.com
- mobile: +36304088520

Copyright © 2015-2019 George Gaspar. MIT License.
