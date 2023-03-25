# iOS component for the Gateway
General Authentication Service

Copyright © 2015-2019 George Gaspar. All rights reserved.

# Swift
- updated to Swift 4.2!;)
- updated/fixed for XCode 11.1
- 4 years in the &making

## Road map
- updating to Swift 5.x (2020)

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

The CoreData cache is taking care of the caching of the webpage and its sources the first time you open up the WebView, so that the app does not need to download it from the server again, and the deviceId will be put into the app.js, for the sake of convinience. 

The CoreData cache will store also the images of the movies and venues, if you use the full system, found through AWS repository.

All the data will be rerieved based on the url.

You can access and check the data with SqlLite. 

### Realm cache
- the app also includes another cache system, out of convinience, which is the Realm cache. It is taking care of storing the responses of the Booking api.

You can access and check the data with Realm browser.

### Document Directory on the device and simulator
- please check for the following print out in the logs, that will tell you where you can find the dB locations:

```swift
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         print("dB location: \(urls[urls.count-1] as URL)")
```

### URL Loading System
- the app has 3 different request manager, combined with a NSUrlProtocol, and a WebView, therefor it is advisable to read the official Apple documentation, as to how it works (cookies, etc) 
- [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) 
- [NSMutableURLRequest](https://developer.apple.com/documentation/foundation/nsmutableurlrequest)
- [HttpCookieStorage](https://developer.apple.com/documentation/foundation/httpcookiestorage)
- the app uses 2 different cookies, the JSESSIONID, and XSRF-TOKEN. Both abide the naming strategy, and standards, and it's part of the URL Loading System, how they are sent and recieved, while the WebView only initiates the request, the cookies are managed by the app's default CookieStorage, and not the WebView, which some may think confusingly. The path the server uses is '/login' for both cookies. You can introduce more cookies, if you want.

#### Configure cookie handling
You can set up the policy at three different points, at the same time:

In the CustomURLRequest:
```swift
// TEST
request.httpShouldHandleCookies = false
return request as URLRequest
```

In the CustomSessionConfiguration:
```swift
/// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised
/// from the default to your requirements.
class func CustomSessionConfiguration() -> URLSessionConfiguration {
    
    let config = `default`
    
    //config.timeoutIntervalForRequest = 20 // Make things timeout quickly.
    config.sessionSendsLaunchEvents = true
    config.httpAdditionalHeaders = ["MyResponseType": "JSON"] // My web service needs to be explicitly asked for JSON.
    config.httpShouldUsePipelining = true // Might speed things up if your server supports it.
    
    return config
```

In the UrlProtocol, in general, but mainly at this point, when you work with NSMutableURLRequest:
```swift
   func connection(_ connection: NSURLConnection!, willSendRequest request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
```

Since the app employs a custom UrlProtocol class, it gives you the possibility to take control over the request - response of any NSUrlConnection, by making deep copies with NSMutableRequest, witch means you can add/modify header fields, set Cookie policy, etc. That also happens for the UIWebView, witch is basic ttyl just a canvas for the authentication, using NSUrlConnection: the app uses context URI based cookies ('/login'), and they are managed by the shared Cookie Storage (since iOS SDK 2.0), as well as the UrlSession based /login requests, so you can use the same cookies without a fuss, let it be got back from UIWebView (NSUrlConnection), or UrlSession, as per default session object configuration, witch means shouldAcceptCookies 'true' by default. 

Since the CustomURLRequest extension of URLRequest is used by both UrlSession and NSUrlConnection you can add convinient system wide settings, or separately at the UrlProtocol for NSUrlConnection, or at the CustomSessionConfiguration.. Find the solution best for you, are you ready? 

>More about the Url Loading System
* [Url Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)

# UIWebView debugging
- if you wish to solely debug a webview session, please follow the guide lines in the following article, that will help to launch a debug session on the webview in your app:
* [Debugging UIWebView on iOS app](https://medium.com/@mattcroak718/debugging-your-iphone-mobile-web-app-using-safari-development-tools-71240657c487)

# AFNetworking
- you may find invocations of the AFNetworkReachabilityManager at points, where you navigate to the next segue. Please consider it yourself, if you need it at all. I left it in the code intentionally.
- please check the corresponding docs:
* [AFNetworkReachabilityManager](http://cocoadocs.org/docsets/AFNetworking/3.1.0/Classes/AFNetworkReachabilityManager.html)

# How it works
- it's a login and movie ticket booking client, currently. Please checkout the other parts of the backend at the following repository:

### gitRepo link to AWS
[CollectionOfApplications](https://github.com/igeorge0902/CollectionOfApplications)

### AWS repos for the movie ticket booking API
[WildFly_TheBookMyMovie](https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-west-2#)
[TheBook_MyMovie](https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-west-2#)

Update your hostnames!
----


Usefull links:
----
Web Debugging tool for iOS, web:
- [Charles Web Proxy Debugging](https://www.charlesproxy.com/documentation/welcome/) - to use Charles you may need to modify your app transport security settings to allow traffic.
- if everythings is set and both the Charles and your server CA certificates are in place you can verify the traffic between your server and iOS client app.

HTTPCookieStorage - Foundation | Apple Developer Documentation

Copyright © 2015-2019 George Gaspar. All rights reserved.
