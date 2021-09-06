WWW component for the Gateway
----


# Deploy
- You do not need to build anything, just deploy the app. For proper usage this web app must be served through the Application Server of your choose, and the Apache web server fronting the AS will handle the headers. 

For TomCat just place it inside the {TOMCAT_HOME}/webapps folder, for GlassFish deploy it as "Other" pointing to your web app directory, and it will create the application context. 
- For wildFly see the instructions at [wildFly settings](https://github.com/igeorge0902/Gateway/tree/master/API/wildFly).
- For wildFly deploy it as unmanaged, and the name and runtime should have war extension
- You can also place it into the WebContent directory of the Web application

# Notes on request header transformation: 
When the user initiates a login or registration through the WWW app, the outgoing request will go through a transformation before the actual call to the server will be made. It means all the corresponding data will be altered before making the request, and the request will happen once the transformation has finished. This mechanism also helps tighten the security since for the same data, which the user sends with the client request, the final data may be different when reaching the server, however containing the same information, which the server is aware of. There is no other way around.  

- the WWW app is split into two parts due to the fact that I have implemented the requesr header transformation in 1.3.x version of angular js, and Google changed the implementation for versions above 1.3.x, but I plan to upgrade it to newer version when I'll time for it!
- the js/AesUtil.js works with at least Angular Js 1.4.x

# Usage of the AesUtil
- with the same identical setup it is interoperable with the Java and Swift implementation:

## Initialize the AesUtil
- load the following js libraries to use the AesUtil (tested against Java and Swift implementation, with the same configuration):

```javascript
    <script type="text/javascript" src="js/lib/aes.js"></script>
    <script type="text/javascript" src="js/lib/pbkdf2.js"></script>
    <script type="text/javascript" src="js/AesUtil.js"></script>
```

@Swift:
- Gateway/iOS/SwiftLoginScreen/ciphertext.swift

@Java:
- Gateway/API/src/main/java/com/jeet/utils/AesUtil.java
and
- Gateway/dalogin/src/main/java/com/dalogin/utils/AesUtil.java
- Gateway/dalogin/src/main/java/com/dalogin/HelloWorld.java

```javascript
function userApi($http) {
    return {
        getUser: function () {
            var url = '/login/admin';
            
            var iterationCount = 1000;
var keySize = 128;
var plaintext = "G";
var passphrase = "SecretPassphrase";
var iv = "F27D5C9927726BCEFE7510B1BDD3D137";
var salt = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";

            var aesUtil = new AesUtil(keySize, iterationCount);
            var ciphertext = aesUtil.encrypt(salt, iv, passphrase, plaintext);
            
            var config = {headers: {
                    'Ciphertext': ciphertext
                }
                    };
            return $http.get(url, config);
        }
    };
}
```

## $http and the XSRF-Token
- Please refer to the official documentation:
[Cross Site Request Forgery (XSRF) Protection](https://code.angularjs.org/snapshot-stable/docs/api/ng/service/$http#cross-site-request-forgery-xsrf-protection)

## Recommendation:
- you probably would like to use some variables for the passphrase and plaintext. The server and client let you take advantage on generated data linked to a user, or the UNIX epoch time so that they can be used to replace the static values. If you deal with aes encryption / decryption in the WWW app it advised to use request transformator to tighten the security. 

## Features:
- login and registration is tested on WWW
- for mobile only login and password reset is tested through the UIWebView

Configuration:
- for registration, if activation is needed the status code is set to 300, so the http interceptors has to be listening to the same status code, therefore.
- for setting the vouchers you will need to use numbers when setting the voucher and the flags in the dB

## Testing
- Testing is crucial, and I am sure, you would like to be convinced, that your page works as intended. For this purpose, please follow through the unit test guide lines and create your own test cases, esp, if you want to assure, that all the functions and their respective controllers work fine, and also I do plan on adding some example test cases to use them to test controllers:
* [Unit Testing](https://code.angularjs.org/snapshot-stable/docs/guide/unit-testing)

## Useful links:
----
The hmac authentication was implemented by the following example:

- https://github.com/Monofraps/angular-node-hmac-example
- http://www.devblogrbmz.com/angular-default-request-headers-and-interceptors/
- https://cryptojs.gitbook.io/docs/
- [GlassFish behind Apache](http://www.codefactorycr.com/glassfish-behind-apache.html)
- [To Enable mod_jk on GlassFish](https://docs.oracle.com/cd/E19798-01/821-1751/gixqw/index.html)

>Example unit test project
 * https://www.dotnetcurry.com/angularjs/1248/unit-testing-angularjs-controllers-jasmine-karma

Copyright © 2015-2021 George Gaspar. All rights reserved.