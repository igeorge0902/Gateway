//
//  Downloader.swift
//  MyFirstSwiftApp
//
//  Created by Gaspar Gyorgy on 18/07/15.
//  Copyright (c) 2015 Gaspar Gyorgy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Realm


let serverURL = "https://milo.crabdance.com"
class GeneralRequestManager: NSObject {
    
    private var urlResponse:NSURLResponse?

    var url: NSURL!
    var errors: String!
    var method: String!
    var queryParameters: [String:String]?
    var bodyParameters: [String:String]?
    var isCacheable: String?

    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    init?(url: String, errors: String, method: String, queryParameters: [String:String]?, bodyParameters: [String:String]?, isCacheable: String?) {
        super.init()
        self.url = NSURL(string: url)!
        self.errors = errors
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.isCacheable = isCacheable
        if url.isEmpty { }
        if errors.isEmpty { }
        
    }
    
    deinit {
        
        NSLog("\(url) is being deinitialized")
        NSLog("\(errors) is being deinitialized")
        NSLog(#function, "\(self)")
        
    }

    
    lazy var session: NSURLSession = NSURLSession.sharedCustomSession
    
    var running = false
    
    func getResponse(onCompletion: (JSON, NSError?) -> Void) {
        
        if self.isCacheable == "1" {
        
        if let localResponse = cachedResponseForCurrentRequest(), let data = localResponse.data {
            
            var headerFields:[String : String] = [:]
            
            headerFields["Content-Length"] = String(format:"%d", data.length)
            
            if let mimeType = localResponse.mimeType {
                headerFields["Content-Type"] = mimeType as String
            }
            
            headerFields["Content-Encoding"] = localResponse.encoding!
            

        } else {
            
            dataTask ({ json, err in
                
                onCompletion(json as JSON, err)
                
                    })
            }
            
            
        } else {
        
        dataTask ({ json, err in
            
            onCompletion(json as JSON, err)
            
            })
        }
    }
    
    // INFO: use this class for every dataTask operation
    func dataTask(onCompletion: ServiceResponses) {
        
        // TODO: temp solution
        var xtoken = prefs.valueForKey("X-Token")
        if xtoken == nil {
            
            xtoken = ""
        }

        
        let request = NSMutableURLRequest.requestWithURL(url, method: method, queryParameters: queryParameters, bodyParameters: bodyParameters, headers: ["Ciphertext": xtoken as! String], cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30)
                
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, sessionError -> Void in

           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //  if  let json:JSON = try! JSON(data: data!) {
            var error = sessionError
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    
                    let description = "HTTP response was \(httpResponse.statusCode)"
                    
                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.description)
                    
                }
            }
            
            if error != nil {
                
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = self.errors
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
                
            }
            else {
                
               // let json: AnyObject! = try?NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                if self.isCacheable == "1" {
                    
                    self.saveCachedResponse(data!)
                }
                
                let json:JSON = JSON(data: data!)
                
                //self.saveCachedResponse(data!)
                
                NSLog("got a 200")
                
                self.running = false
                onCompletion(json, error)
                
                }
            
           // })
            //  }
        })
        
        running = true
        task.resume()
        
        
    }
    
    /**
     Save the current response in local storage for use when offline.
     */
    private func saveCachedResponse(data: NSData) {
        
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        var cachedResponse = cachedResponseForCurrentRequest()
        
        if cachedResponse == nil {
            cachedResponse = CachedResponse()
        }
        
        if let data_:NSData = data {
            cachedResponse!.data = data_
        }
        
        if let url:NSURL? = url, let absoluteString = url?.absoluteString {
            cachedResponse!.url = absoluteString
        }
        
        cachedResponse!.timestamp = NSDate()
        if let response = self.urlResponse {
            
            if let mimeType = response.MIMEType {
                cachedResponse!.mimeType = mimeType
            }
            
            if let encoding = response.textEncodingName {
                cachedResponse!.encoding = encoding
            }
        }
        
        realm.addObject(cachedResponse!)
        
        do {
            try realm.commitWriteTransaction()
        } catch {
            print("Something went wrong!")
        }
        
    }
    
    /**
     Gets a cached response from local storage if there is any.
     
     :returns: A CachedResponse optional object.
     */
    private func cachedResponseForCurrentRequest() -> CachedResponse? {
        if let url:NSURL? = url, let absoluteString = url?.absoluteString {
            let p:NSPredicate = NSPredicate(format: "url == %@", argumentArray: [ absoluteString ])
            
            // Query
            let results = CachedResponse.objectsWithPredicate(p)
            
            if results.count > 0 {
                return results.objectAtIndex(0) as? CachedResponse
            }
        }
        
        return nil
    }
    
}
