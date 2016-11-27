wildFly specific files

- jboss-deployment-structure.xml
- web.xml
- pom.xml

Substitute the following files for the originally included ones to make the build be able to run on wildFly application server.

- tested on wildFly 10.x

Edit your wildFly xml configuration file (${wildFly_HOME}/standalone/configuration/standalone.xml) to add the AJP listening port and to serve the WWW app, as well: 

```xml
        <subsystem xmlns="urn:jboss:domain:undertow:3.1">
            <buffer-cache name="default"/>
            <server name="default-server">
                <ajp-listener name="Apache" socket-binding="ajp"/>
                <http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"/>
                <https-listener name="https" socket-binding="https" security-realm="ApplicationRealm" enable-http2="true"/>
                <host name="default-host" alias="localhost">
                    <location name="/" handler="welcome-content"/>
                    <location name="/example" handler="Example"/>
                    <filter-ref name="server-header"/>
                    <filter-ref name="x-powered-by-header"/>
                </host>
            </server>
            <servlet-container name="default">
                <jsp-config development="true" check-interval="1" modification-test-interval="1" recompile-on-fail="true"/>
                <websockets/>
            </servlet-container>
            <handlers>
                <file name="welcome-content" path="${jboss.home.dir}/welcome-content"/>
                <file name="Example" path="/Users/georgegaspar/Documents/Gateway-master/example"/>
            </handlers>
            <filters>
                <response-header name="server-header" header-name="Server" header-value="WildFly/10"/>
                <response-header name="x-powered-by-header" header-name="X-Powered-By" header-value="Undertow/1"/>
            </filters>
        </subsystem>
```

and for the AJP port:

```xml
<socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
 
        <socket-binding name="ajp" port="${jboss.ajp.port:8008}"/>
    
    </socket-binding-group>
```
