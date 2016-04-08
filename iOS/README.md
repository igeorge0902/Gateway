# Gateway
General Authentication Service

The native Swift part was made possible by Dipin Krishna with his project found on this website:

https://dipinkrishna.com/blog/2014/07/login-signup-screen-tutorial-xcode-6-swift-ios-8-json/comment-page-2/#comment-43081

# Note on iOS build:
- You must run POD install to install the pods into your local environment. AFNetwork is an Objective-C dependency that is supposed to be re-installed as the official Objective-C class bridging into Swift code describes it, if any problem occurs. 
- Take care of the App Transport Security Exceptions: it needs to be set accordingly
- If you use self-signed certs with the server, you must install your custom cerificate authority file onto your device (You must use certificate authority, if you go with self-signed, and install it onto the Tomcat instance).
- Check also the Other Linker Flags for consistency
- if you want to use Realm database, install it from pod

