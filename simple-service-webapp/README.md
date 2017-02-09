RESTful API component for the Gateway project

- standard Jersey API implementation 
- make sure you configure your container for servlets 3.0

Feature set:
- it checks the active user sessions in the /login context
- in TomCat clustered setup the app listening on the /admin URI can read the /login context on all nodes. You may need to set crossContext flag in context.xml:

```xml
<Context crossContext="true">     

</Context>
```

[Common Attributes of context.xml](https://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-context-xml-configuration-example/)

Build from Eclipse:
- import as Maven project
- maven install
