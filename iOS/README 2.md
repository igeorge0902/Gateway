# Gateway
General Authentication Service


# Note on iOS build:
- I have included xcconfig files for build settings configuration (Project-Shared.xcconfig)
- You must run 'POD install' to install the pods into your local environment. After installing the pods you must run the project with SwiftLoginScreen.xcworkspace!
- if you want to exclude any pods you may break the code therefor I strongly recommend to install all the pods you find in the podfile!
- AFNetwork is an Objective-C dependency that is supposed to be re-installed as the official Objective-C class bridging into Swift code describes it, if any problem occurs. 
- Take care of the App Transport Security Exceptions: it needs to be set accordingly
- If you use self-signed certs with the server, you must install your custom cerificate properly. See description at [Using Self Signed SSL Certificates with iOS](https://blog.httpwatch.com/2013/12/12/five-tips-for-using-self-signed-ssl-certificates-with-ios/)
- Check also the Other Linker Flags for consistency

