# Gateway
General Authentication Service

The native Swift part was made possible by Dipin Krishna with his project found on this website:

https://dipinkrishna.com/blog/2014/07/login-signup-screen-tutorial-xcode-6-swift-ios-8-json/comment-page-2/#comment-43081

# Note on iOS build:
- I have included xcconfig files for build settings configuration (Project-Shared.xcconfig)
- You must run 'POD install' to install the pods into your local environment. After installing the pods you must run the project with SwiftLoginScreen.xcworkspace!
- if you want to exclude any pods you may break the code therefor I strongly recommend to install all the pods you find in the podfile!
- AFNetwork is an Objective-C dependency that is supposed to be re-installed as the official Objective-C class bridging into Swift code describes it, if any problem occurs. 
- Take care of the App Transport Security Exceptions: it needs to be set accordingly
- If you use self-signed certs with the server, you must install your custom cerificate authority file onto your device and server (You must use certificate authority format - I use it with Apache http server with mod_jk AJP connector on GlassFish or TomCat).
- Check also the Other Linker Flags for consistency

