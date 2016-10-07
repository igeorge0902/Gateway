# Gateway
General Authentication Service

# Updated to Swift 2.3 
- Refactored

# Notes on iOS build:
- You should run 'POD install' to install the pods into your local environment. After installing the pods you must run the project with SwiftLoginScreen.xcworkspace!
- if you want to exclude any pods you may break the code therefor I strongly recommend to install all the pods you find in the podfile!
- AFNetwork is an Objective-C dependency that is supposed to be re-installed as the official Objective-C class bridging into Swift code describes it, if any problem occurs. 
- Check also the Other Linker Flags for consistency
- Take care of the App Transport Security Exceptions: it needs to be set accordingly to run on https
----
- If you use self-signed certs with the server, you must install your custom cerificate authority file onto your server and device/simulator  (You must use certificate authority format - I use it with Apache http server with mod_jk AJP connector on GlassFish or TomCat).
- strictly follow the instructions at https://blog.httpwatch.com/2013/12/12/five-tips-for-using-self-signed-ssl-certificates-with-ios/ and go with Tip # 5: Consider Creating Your Own Certificate Authority (CA)


Usefull links:
----
Web Debugging tool for iOS, web:
- https://www.charlesproxy.com/documentation/welcome/ (to use Charles you may need to modify your app transport security settings)
- if everythings is set and both the Charles and your server CA certificates are in place you can verify the traffic between your server and iOS client app.

