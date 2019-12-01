# iOS component for the Gateway
General Authentication Service

Copyright © 2015-2019 George Gaspar. All rights reserved.

# Swift
- updated to Swift 4.2!;)
- updated/fixed for XCode 11.1

# Notes on iOS build:
- You should run 'POD install' to install the pods into your local environment. After installing the pods you must run the project with SwiftLoginScreen.xcworkspace!
- if you want to exclude any pods you may break the code therefor I strongly recommend to install all the pods you find in the podfile!
- AFNetwork is an Objective-C dependency that is supposed to be re-installed as the official Objective-C class bridging into Swift code describes it, if any problem occurs. 
- You may need full internet connection depending on your AFNetwork settings
- Check also the Other Linker Flags for consistency
- Take care of the App Transport Security Exceptions: it needs to be set accordingly to run on https
- If you use self-signed certs with the server, you must install your custom cerificate authority file onto your server and device/simulator  (You must use certificate authority format - I use it with Apache http server with mod_jk AJP connector on GlassFish or TomCat).
- strictly follow the instructions at [Using Self Signed SSL Certificates with iOS](https://blog.httpwatch.com/2013/12/12/five-tips-for-using-self-signed-ssl-certificates-with-ios/) and go with Tip # 5: Consider Creating Your Own Certificate Authority (CA). You will have two choices, however: either you import the CA on the server, or install it on the device.

### CFNetwork Debug and using Instruments
- in general the built-in XCode Profiler is fine. However, I cannot get it run with XCode 10.1, for some of its tools, that I was able to use in XCode 9.*, because the CoreProfile.framework is missing
- please check out this article: [CFNetwork Debug and using Instruments](https://www.agnosticdev.com/blog-entry/networking-swift/advanced-network-debugging-xcode)
- please try out on real device, to verify the network and SSL, before doing any bold things. The Simulator sucks, but it's cheap, because you don't have to subscribe for the Apple developer program. I did test it on real device throughout my one and only one time occasion, when I paid to be a so-called iOS developer and to test it; worked everything fine, tried it on Google Cloud with the server side deployed. However, with self-signed certs you may recieve any kind of boring SSL error, for which not even the Google knows the answer... God bless you!;)


### CriptoJS
- please check-out this source, that gives a comprehensive understanding, as to how to use the encryptions. I guess it's fine for those, who just want to implement the function: [crypto-js](https://code.google.com/archive/p/crypto-js/) 

### CoreData cache
- there is a CoreData based cache mechanism built in, that works from the UrlProtocol. If you don't want to use it, just uncomment the following function:

```swift
func connectionDidFinishLoading(_ connection: NSURLConnection!) {
    self.client!.urlProtocolDidFinishLoading(self)
  //  self.saveCachedResponse()
}
```

# How it works
- it's a login and movie ticket booking client, currently. Please checkout the other parts of the backend at the following repository:

### gitRepo link to AWS
[CollectionOfApplications](https://github.com/igeorge0902/CollectionOfApplications)

### AWS repos
[WildFly_TheBookMyMovie](https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-west-2#)
[TheBook_MyMovie](https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-west-2#)

Update your hostnames!
----


Usefull links:
----
Web Debugging tool for iOS, web:
- [Charles Web Proxy Debugging](https://www.charlesproxy.com/documentation/welcome/) - to use Charles you may need to modify your app transport security settings to allow traffic.
- if everythings is set and both the Charles and your server CA certificates are in place you can verify the traffic between your server and iOS client app.

Copyright © 2015-2019 George Gaspar. All rights reserved.
