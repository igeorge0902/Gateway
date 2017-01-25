# General Authentication Service - GAS 

Check the listed components above, and their readme for specific notes, instructions.

# General instructions for debugging
You can create a fully functional debug environment in Eclipse using any of your chosen application server, where you can add any of your exisiting installations, too. Make sure you set your file permission rights permissively, otherwise you will not be able start up the application server properly, because Eclipse doesn't run the applicaton servers as the root user. For the complete debug environment with Apache http webserver just start the service as usual, then start your application server in debug mode on the port that your mod_jk port listens to. The most important thing, however, is you need to copy the hibernate descriptor file for macOS under the Eclipse, somewhere like this (pls watch the corresponding error message in the log for Windows, or other systems):

- /Applications/Eclipse.app/Contents/Eclipse

- Please be so kind and use sqlitebrowser to verify what the iOS will hold in cache. It is crucial when you are interested in, and want to understand, what really happens under the hood, especially for the login through the webView. (You can use sqlitebrowser because the app itself use sqlite for this, for example when you use the iOS simulator...)

- Make sure you have 'marked' your custom certificates "Always trusted", that you imported on the server (into Keychain Access on macOS, for example, and so on with different operating systems systems). If you have still SSL connection issues, install the CA on the device, too. For me it was not necessary, however.

# headerField M and headerField M-Device
- the Gateway/WWW/jsR/app.js is handling the headerField value, named localStorage.M. The variable can only be checked for if it holds an object or not. However, you will not have direct access to it, but the object exists. The same behaviour occurs when we check if the headersGetter['M-Device'] != undefined. So it is possible to pass the object to substitute the original value generated by the var uuid = guid() function for the value sitting in the header. The server will calculate the hash with the deviceId sent by the iPhone, and it will match it with the one created at line 78. So it would be impossible to login otherwise, if the two hashes would not be seamlessly, perfectly the same. You can verify it the following way:

######@Gateway/dalogin/src/main/java/com/dalogin/HelloWorld.java

The following code snipet is going to take as argument the "deviceId_ = request.getHeader("M-Device");", where this headerField is set by the iOS device. It is necessary if you want to calculate the same hash, which is sent in, if the user logs in through the iOS webView, and then the hash can be retrieved by "hmac = request.getHeader("X-HMAC-HASH");". The dataBase is going to save therefore the actual iOS deviceId, too. As you can see there is no other way around to let the user login through the iOS webView. If there is a hash mismatch 502 response will be thrown. 

```java
            try{ 
                
            	log.info("deviceId to be decrypted: " +  deviceId_ );
            	deviceId = aesUtil.decrypt(SALT, IV, PASSPHRASE, deviceId_);
            	log.info("deviceId decrypted: " +  deviceId );
            
            } catch (Exception e) {
            	
            	log.info("There was no deviceId to be decrypted.");
            	
            }
            
			hash1 = SQLAccess.hash(pass, context);
			devices = SQLAccess.insert_device(deviceId, user, context);

```

######@Gateway/WWW/jsR/app.js

Have a look at the following snipet. The data object will change if the headerField M-Device holds data.

```javascript

            if (headersGetter['M-Device'] != undefined) {
            var newData = '';
            
                var originalId = /deviceId=[0-9]*/gi;
                var str = data;
                var newId = 'deviceId='+headersGetter['M-Device'];
                newData = str.replace(originalId, newId);
                
                data = newData;

            }
            
        // 4RI "Message", "secret"
        var hash = CryptoJS.HmacSHA512(headersGetter()['X-URL'] + ':' + data + ':' + microTime + ':' + data.length, localStorage.hmacSecret);
        
	var hashInBase64 = CryptoJS.enc.Base64.stringify(hash);
	    
 	headersGetter()['X-HMAC-HASH'] = hashInBase64;
```


# Error on retrieving the user object through the AdminServlet
The server will handle two error cases once the login has succeeded. 

- 403 response: the server will throw response 403, if and only when the token in the Ciphertext is not the correct one. This can happen whenever the token2 is not the same on the server, which it sent previously to the client. You will pass this stage if and only when the client can supply a valid token2 belonging to the corresponding user. It is a security measurement to overwrite the token pairs automatically if any logout or new session creation occurs for the corresponding user. Also, obviously 403 will be thrown, if no Ciphertext is supplied.
- 412 response: it actually will never occur, but it handles the case when the user is no longer present in the dataBase, but on the client and server the session is valid and active.

# dateBase
All the sql scripts should run flawlessly. If not, check your schema, user, etc. The sql script files are a result of dumping my working schema.

# Murphy's Law
If you have still issues, pls do not hesitate to contact me!

# Swift
- updates will be coming soon to Swift 3.0!;)

# Analytics
You can find various analytics services for web and mobile, as well. Please check out one of them if you want to track app events like app start, login, logout, registration, etc.

######@Facebook
- https://developers.facebook.com/docs/analytics

######@Google
- https://developers.google.com/analytics/devguides/collection/

######@Amazon (mobile only)
- https://www.google.com/aclk?sa=L&ai=DChcSEwi2_eufh9jRAhXLDxgKHQTlDzwYABAA&sig=AOD64_3iKzYsiGgpp5iPc06DrgFf6d6LJA&q=&ved=0ahUKEwidl-afh9jRAhXEDpoKHd8yA2oQ0QwIGA&adurl=


# Contacts:
- email: igeorge1982@gmail.com (primary), igeorge1982@hotmail.com, igeorge1982@yahoo.com
- mobile: +36304088520
