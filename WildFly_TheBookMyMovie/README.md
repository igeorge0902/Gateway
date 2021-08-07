RESTful API component for the Booking project
- serving data endpoints for movies, booking, venues and admin interface

- standard JAX-RS API implementation with RestEasy provided on wildFly
- do not use the hibernate test config, when deployed

Make sure you have the proper versions as in the pom, on wildFly:
- hibernate-core-5.0.10.Final.jar
- hibernate-core-5.1.0.Final.jar
- hibernate-entitymanager-5.0.10.Final.jar
- hibernate-envers-5.0.10.Final.jar
- hibernate-java8-5.0.10.Final.jar

For module.xml check the following in the Hibernate main directory on wildFly:

<!-- Represents the Hibernate 5.0.x module-->
<module xmlns="urn:jboss:module:1.3" name="org.hibernate">
    <resources>
        <resource-root path="hibernate-core-5.0.10.Final.jar"/>
        <resource-root path="hibernate-envers-5.0.10.Final.jar"/>
        <resource-root path="hibernate-entitymanager-5.0.10.Final.jar"/>
        <resource-root path="hibernate-java8-5.0.10.Final.jar"/>
    </resources>

    <dependencies>
        <module name="asm.asm"/>
        <module name="com.fasterxml.classmate"/>
        <module name="javax.api"/>
        <module name="javax.annotation.api"/>
        <module name="javax.enterprise.api"/>
        <module name="javax.persistence.api"/>
        <module name="javax.transaction.api"/>
        <module name="javax.validation.api"/>
        <module name="javax.xml.bind.api"/>
        <module name="org.antlr"/>
        <module name="org.dom4j"/>
        <module name="org.javassist"/>
        <module name="org.jboss.as.jpa.spi"/>
        <module name="org.jboss.jandex"/>
        <module name="org.jboss.logging"/>
        <module name="org.jboss.vfs"/>
        <module name="org.hibernate.commons-annotations" export="true"/>
        <module name="org.hibernate.infinispan" services="import" optional="true"/>
        <module name="org.hibernate.jipijapa-hibernate5" services="import"/>
    </dependencies>
</module>
