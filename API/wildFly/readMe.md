# wildFly specific files

- jboss-deployment-structure.xml
- web.xml
- pom.xml

Substitute the following files for the originally included ones to make the build be able to run on wildFly application server. Don't forget to rebuild the project with the new pom.xml. Place the jboss-deployment-structure.xml to the WEB-INF directory. You may need to manually upgrade certain wildFly dependencies, as well as replace the jboss-logging.jar file, which is a dependency for Hibernate 5.x. Check your versions carefully!

## Deploy the WWW app 
- You must create an unmanaged deployment for the WWW app because it runs JSP files: set the absolute path of your WWW app, which includes the WEB-INF sub-folder already, the add the Name and Runtime Name, which should be the context (location) name with war extension like example.war. 
- Alternatively you can create a sub-folder in the ${wildFly_HOME}/standalone/deployments directory with example.war and place your WWW app here, and flag the deployment directory as deployed! [wildFly Application deployment](https://docs.jboss.org/author/display/WFLY10/Application+deployment) 

### tested on wildFly 10.x

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
