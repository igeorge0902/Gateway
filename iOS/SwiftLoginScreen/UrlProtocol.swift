//
//  MyURLProtocol.swift
//  NSURLProtocolExample
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.//

import CoreData
import Foundation
import SwiftyJSON
import UIKit
// import Kanna
// import Toaster

var requestCount = 0
var pattern_ = "https://([^/]+)(/example/tabularasa.jsp.*?)(/$|$)"
var pattern_rs = "https://([^/]+)(/example/tabularasa.jsp.*?JSESSIONID=)"

class MyURLProtocol: URLProtocol, NSURLConnectionDelegate {
    var connection: NSURLConnection!
    var mutableData: NSMutableData!
    var response: URLResponse!
    var httpresponse: HTTPURLResponse!
    var newRequest: NSMutableURLRequest!

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
            return false
        }

        if URLProtocol.property(forKey: "MyRedirectHandledKey", in: request) != nil {
            return false
        }

        print("Request #\(requestCount += 1): URL = \(request.url!.absoluteString)")
        NSLog("Relative path ==> %@", request.url!.relativePath)

        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to: bRequest)
    }

    override func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if AFNetworkReachabilityManager.shared().isReachable {
            NSLog("AFNetwork is reachable...")

            // 1
            let possibleCachedResponse = cachedResponseForCurrentRequest()

            if let cachedResponse = possibleCachedResponse {
                NSLog("Serving response from Cache. url == %@", request.url!.absoluteString)

                // 2
                let data = cachedResponse.value(forKey: "data") as! Data
                let mimeType = cachedResponse.value(forKey: "mimeType") as! String
                let encoding = cachedResponse.value(forKey: "encoding") as? String?

                // 3
                let response = URLResponse(url: request.url!, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: encoding!)

                // 4
                client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client!.urlProtocol(self, didLoad: data)
                client!.urlProtocolDidFinishLoading(self)

            } else {
                // 5
                NSLog("Serving response from NSURLConnection. url == %@", request.url!.absoluteString)

                if request.url!.relativePath == "/login/HelloWorld" ||
                    request.url!.relativePath == "/login/forgotPSw" ||
                    request.url!.relativePath == "/login/forgotPSwCode" ||
                    request.url!.relativePath == "/login/forgotPSwNewPSw" {
                    newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest
                    URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest)
                    /* We set the headerfield and value that the Apache webserver will accept */

                    let ciphertext = cipherText.getCipherText(deviceId)
                    newRequest.setValue(ciphertext, forHTTPHeaderField: "M-Device")

                    newRequest.setValue("M", forHTTPHeaderField: "M")
                    connection = NSURLConnection(request: newRequest as URLRequest, delegate: self)
                }

                if request.url!.relativePath != "/example/tabularasa.jsp", request.url!.relativePath != "/login/HelloWorld" {
                    newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest
                    URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest)
                    /* We set the headerfield and value that the Apache webserver will accept */

                    newRequest.setValue("M", forHTTPHeaderField: "M")
                    connection = NSURLConnection(request: newRequest as URLRequest, delegate: self)
                }
            }

        } else {
            NSLog("AFNetwork failed to respond......")

            // 1
            let possibleCachedResponse = cachedResponseForCurrentRequest()

            if let cachedResponse = possibleCachedResponse {
                NSLog("Serving response from Cache. url == %@", request.url!.absoluteString)

                // 2
                let data = cachedResponse.value(forKey: "data") as! Data
                let mimeType = cachedResponse.value(forKey: "mimeType") as! String
                let encoding = cachedResponse.value(forKey: "encoding") as? String?

                // 3
                let response = URLResponse(url: request.url!, mimeType: mimeType, expectedContentLength: data.count, textEncodingName: encoding!)

                // 4
                client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client!.urlProtocol(self, didLoad: data)
                client!.urlProtocolDidFinishLoading(self)

            } else {
                let failedResponse = HTTPURLResponse(url: request.url!, statusCode: 0, httpVersion: nil, headerFields: nil)

                client?.urlProtocol(self, didReceive: failedResponse!, cacheStoragePolicy: .notAllowed)

                client?.urlProtocolDidFinishLoading(self)

                if request.url!.absoluteString.contains(serverURL) {
                    NSLog("Failed to load url == %@", request.url!.absoluteString)
                    /*
                     var errorOnLogin:RequestManager?
                     errorOnLogin = RequestManager(url: serverURL + "/login/HelloWorld", errors: "No internet connection : " + (self.request.url?.absoluteString)!)

                         errorOnLogin!.getResponse { _ in }
                     */
                }
            }
        }
    }

    override func stopLoading() {
        if connection != nil {
            connection.cancel()
        }
        connection = nil
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func connection(_: NSURLConnection!, willSendRequest request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        let prefs: UserDefaults = UserDefaults.standard
        // var xtoken = prefs.value(forKey: "X-Token")

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 302 { /* && httpResponse.url?.baseURL?.absoluteString == "https://milo.crabdance.com" */
                let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
                URLProtocol.setProperty(true, forKey: "MyRedirectHandledKey", in: newRequest)
                //   self.client?.URLProtocol(self, wasRedirectedToRequest: newRequest, redirectResponse: response!)

                let jsonHeaders: NSDictionary = httpResponse.allHeaderFields as NSDictionary

                if let xtoken = jsonHeaders.value(forKey: "X-Token") as? NSString {
                    prefs.setValue(xtoken, forKey: "X-Token")
                }

                // NSLog("Sending Request from %@ to %@", response!.url!, request.url!);

                let match = RegEx()
                let url = request.url!.absoluteString
                var requestLogin: RequestManager?

                if match.containsMatch(pattern_, inString: url) {
                    let adminUrl = match.replaceMatches(pattern_rs, inString: url, withString: serverURL + "/login/admin?JSESSIONID=")
                    let sessionID = match.replaceMatches(pattern_rs, inString: url, withString: "")

                    prefs.setValue(sessionID, forKey: "JSESSIONID")
                    NSLog("SessionId ==> %@", sessionID!)

                    requestLogin = RequestManager(url: adminUrl!, errors: "")

                    requestLogin?.getResponse {
                        (json: JSON, _: NSError?) in

                        print(json)
                    }
                }

                //  NSLog("Url to be redirected ==> %@", request.URL!.absoluteString)
            }
        }

        //  self.client!.URLProtocol(self, wasRedirectedToRequest: request, redirectResponse: response!)
        return request
    }

    func connection(_: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        self.response = response
        mutableData = NSMutableData()
        httpresponse = response as? HTTPURLResponse

        let cookieStorage = HTTPCookieStorage.shared
        if let cookies_ = cookieStorage.cookies {
            for cookie in cookies_ {
                print("(using UrlProtocol)Cookie_ name: \(cookie.name), (using UrlProtocol)Cookie_ value: \(cookie.value)")
            }
        }
    }

    func connection(_: NSURLConnection!, didReceiveData data: Data!) {
        client!.urlProtocol(self, didLoad: data)
        mutableData.append(data)
    }

    func connectionDidFinishLoading(_: NSURLConnection!) {
        client!.urlProtocolDidFinishLoading(self)
        saveCachedResponse()
    }

    // It sends a call to RequestManager to present an alert view about the error
    func connection(_: NSURLConnection!, didFailWithError error: NSError!) {
        client!.urlProtocol(self, didFailWithError: error)

        if newRequest != nil {
            var errorOnLogin: RequestManager?

            errorOnLogin = RequestManager(url: serverURL + "/login/HelloWorld", errors: "Connection error!")
            errorOnLogin?.getResponse { _, _ in }
        }
    }

    func connection(_: NSURLConnection, canAuthenticateAgainstProtectionSpace _: URLProtectionSpace) -> Bool {
        print("canAuthenticateAgainstProtectionSpace method Returning True")
        return true
    }

    func connection(_: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        print("did autherntcationchallenge = \(challenge.protectionSpace.authenticationMethod)")

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            print("send credential Server Trust")

            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.use(credential, for: challenge)

        } else {
            challenge.sender!.performDefaultHandling!(for: challenge)
        }
    }

    func saveCachedResponse() {
        // 1
        let delegate = UIApplication.shared.delegate as! AppDelegate

        // Create a private NSManagedObjectContext with private queue concurrency type and use it to access CoreData whenever operating on a background thread.
        let context = delegate.managedObjectContext

        // let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        // privateMOC.parentContext = context

        // 2
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context) as NSManagedObject

        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:

                if request.url!.absoluteString.contains(serverURL) {
                    if request.url!.relativePath != "/login/HelloWorld" &&
                        request.url!.relativePath != "/login/admin" &&
                        request.url!.relativePath != "/login/forgotPSw" &&
                        request.url!.relativePath != "/login/forgotPSwCode" &&
                        request.url!.relativePath != "/login/forgotPSwNewPSw" {
                        NSLog("Saving cached response url == %@", request.url!.absoluteString)

                        cachedResponse.setValue(mutableData, forKey: "data")
                        cachedResponse.setValue(request.url!.absoluteString, forKey: "url")
                        cachedResponse.setValue(Date(), forKey: "timestamp")
                        cachedResponse.setValue(response.mimeType, forKey: "mimeType")
                        cachedResponse.setValue(response.textEncodingName, forKey: "encoding")
                        cachedResponse.setValue(httpresponse.statusCode, forKey: "statusCode")

                        if request.url!.relativePath == "/example/jsR/app.js" {
                            NSLog("Saving cached response url == %@", request.url!.absoluteString)

                            let urldata: Data = mutableData as Data
                            let convertedString = NSString(data: urldata, encoding: String.Encoding.utf8.rawValue)

                            let newString: NSString = convertedString!.replacingOccurrences(of: "(uuid)", with: "(" + "\"\(deviceId)\"" + ")") as NSString
                            let newurldata: Data = newString.data(using: String.Encoding.ascii.rawValue)!
                            mutableData.append(newurldata)
                            cachedResponse.setValue(mutableData, forKey: "data")
                        }
                    }
                }

            case 502:

                if request.url!.relativePath == "/login/HelloWorld" {
                    let prefs: UserDefaults = UserDefaults.standard
                    prefs.set(0, forKey: "ISWEBLOGGEDIN")

                    var errorOnLogin: RequestManager?

                    let data: Data = mutableData as Data

                    if let jsonData: NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: AnyObject] as NSDictionary? {
                        let errmsg = jsonData["Session creation"] as! String
                        errorOnLogin = RequestManager(url: serverURL + "/login/HelloWorld", errors: errmsg)
                        errorOnLogin?.getResponse { _, _ in }
                    }
                }

            case 503:

                //   if request.url!.relativePath == "/login/HelloWorld" {
                let prefs: UserDefaults = UserDefaults.standard
                prefs.set(0, forKey: "ISWEBLOGGEDIN")

                var errorOnLogin: RequestManager?

                let data: Data = mutableData as Data

                if let result = NSString(data: data, encoding: String.Encoding.ascii.rawValue) as String? {
                    //   if let doc = Kanna.HTML(html: result, encoding: String.Encoding.ascii) {
                    //       errorOnLogin = RequestManager(url: serverURL + "/login/HelloWorld", errors: doc.title!)
                    //       errorOnLogin?.getResponse { _ in }

                    //   }
                }

                //    }

            default:

                NSLog("Url was redirected.")
            }
        }

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        // 1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext

        // 2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "CachedURLResponse", in: context)
        fetchRequest.entity = entity

        // 3
        let predicate = NSPredicate(format: "url == %@", request.url!.absoluteString)
        fetchRequest.predicate = predicate

        // 4
        let possibleResult = try? context.fetch(fetchRequest) as! [NSManagedObject]

        /*
         let fetchRequests = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedURLResponse")
         let results = try?context.fetch(fetchRequests) as! [CachedURLResponse]
         */

        for managedObject in possibleResult! {
            if let timestamp: Date = managedObject.value(forKey: "timestamp") as! Date? {
                if timestamp.addingTimeInterval(3600) < Date() {
                    context.delete(managedObject)
                }
            }
        }

        // 5
        if let result = possibleResult {
            if !result.isEmpty {
                return result[0]
            }
        }

        return nil
    }
}
