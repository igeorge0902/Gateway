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

// TODO: replace it with NSUrlSession based protocol
var requestCount = 0
class MyURLProtocol: URLProtocol, NSURLConnectionDelegate {
    weak var connection: NSURLConnection!
    var mutableData: NSMutableData = NSMutableData()
    var response: URLResponse!
    var httpresponse: HTTPURLResponse!
    var newRequest: NSMutableURLRequest!

    override class func canInit(with request: URLRequest) -> Bool {

        // tag the request
        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
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

                    newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest
               
                    // tag the request
                    URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest)
                   
                    connection = NSURLConnection(request: newRequest as URLRequest, delegate: self)

            }
    }

    override func stopLoading() {
        if connection != nil {
            connection.cancel()
        }
    }

    func connection(_: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        self.response = response
       // mutableData = NSMutableData()

    }

    @objc func connection(_: NSURLConnection!, didReceiveData data: Data!) {
        client!.urlProtocol(self, didLoad: data)
     //   mutableData = NSMutableData()
        mutableData.append(data)
        
    }

    @objc func connectionDidFinishLoading(_: NSURLConnection!) {
        client!.urlProtocolDidFinishLoading(self)
        saveCachedResponse()
    }

    func connection(_: NSURLConnection, didFailWithError error: Error) {
        client!.urlProtocol(self, didFailWithError: error)

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

        // 2
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context) as NSManagedObject

        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:

                        cachedResponse.setValue(mutableData, forKey: "data")
                        cachedResponse.setValue(request.url!.absoluteString, forKey: "url")
                        cachedResponse.setValue(Date(), forKey: "timestamp")
                        cachedResponse.setValue(response.mimeType, forKey: "mimeType")
                        cachedResponse.setValue(response.textEncodingName, forKey: "encoding")
                        cachedResponse.setValue(httpresponse.statusCode, forKey: "statusCode")

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
        let possibleResult = try? context.fetch(fetchRequest) as? [NSManagedObject]

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
