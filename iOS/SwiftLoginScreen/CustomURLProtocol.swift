//
//  MyURLProtocol.swift
//  CustomURLProtocol
//
//  Created by Horatiu Potra.
//  Copyright (c) 2015 3PillarGlobal. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Realm

class CustomURLProtocol: NSURLProtocol, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {

    private var dataTask:NSURLSessionDataTask?
    private var urlResponse:NSURLResponse?
    private var receivedData:NSMutableData?
    
    class var CustomKey:String {
        return "myCustomKey"
    }
    
    // MARK: NSURLProtocol
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
       
        if (NSURLProtocol.propertyForKey(CustomURLProtocol.CustomKey, inRequest: request) != nil) {
            return false
        }

        NSLog("Relative path for SessionDataTask==> %@", request.URL!.relativePath!)
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override func startLoading() {
       
        if AFNetworkReachabilityManager.sharedManager().reachable {
        NSLog("AFNetwork is reachable...")
            let newRequest = self.request.mutableCopy() as! NSMutableURLRequest
            
        //    NSURLProtocol.setProperty("true", forKey: CustomURLProtocol.CustomKey, inRequest: newRequest)
            
            let defaultConfigObj = NSURLSessionConfiguration.defaultSessionConfiguration()
            let defaultSession = NSURLSession(configuration: defaultConfigObj, delegate: self, delegateQueue: nil)
            
            self.dataTask = defaultSession.dataTaskWithRequest(newRequest)
            self.dataTask!.resume()
        
        } /*else {

            NSLog("No AFNetwork is reachable...")

            let httpVersion = "1.1"
            
            if let localResponse = cachedResponseForCurrentRequest(), data = localResponse.data {
            
                var headerFields:[String : String] = [:]
                
                headerFields["Content-Length"] = String(format:"%d", data.length)
                
                if let mimeType = localResponse.mimeType {
                    headerFields["Content-Type"] = mimeType as String
                }
                
                headerFields["Content-Encoding"] = localResponse.encoding!
                
                let okResponse = NSHTTPURLResponse(URL: self.request.URL!, statusCode: 200, HTTPVersion: httpVersion, headerFields: headerFields)
                self.client?.URLProtocol(self, didReceiveResponse: okResponse!, cacheStoragePolicy: .NotAllowed)
                self.client?.URLProtocol(self, didLoadData: data)
                self.client?.URLProtocolDidFinishLoading(self)
            
            } else {
            
                NSLog("AFNetwork failed to respond......")

                let failedResponse = NSHTTPURLResponse(URL: self.request.URL!, statusCode: 0, HTTPVersion: httpVersion, headerFields: nil)
                
                self.client?.URLProtocol(self, didReceiveResponse: failedResponse!, cacheStoragePolicy: .NotAllowed)
                
                self.client?.URLProtocolDidFinishLoading(self)
            }
            
        }*/
    }
    
    override func stopLoading() {
        
        self.dataTask?.cancel()
        self.dataTask       = nil
        self.receivedData   = nil
        self.urlResponse    = nil
    }
    
    // MARK: NSURLSessionDataDelegate
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask,
        
        didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            
            self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
            
            self.urlResponse = response
            self.receivedData = NSMutableData()
            
            completionHandler(.Allow)
            
            NSLog("AFNetwork has received session response data from dataTask...")

    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
       
        self.client?.URLProtocol(self, didLoadData: data)
        
        self.receivedData?.appendData(data)
    }
    
    // MARK: NSURLSessionTaskDelegate
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
      
        if error != nil && error!.code != NSURLErrorCancelled {
            self.client?.URLProtocol(self, didFailWithError: error!)
            
            NSLog("AFNetwork error code: \(error!.code)")

        
        } else {
        
          //  saveCachedResponse()
          //  NSLog("AFNetwork saved cahced response")
           
            self.client?.URLProtocolDidFinishLoading(self)
        }
    }
    
    // MARK: Private methods
    
    /**
    Save the current response in local storage for use when offline.
    */
    private func saveCachedResponse() {
       
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        var cachedResponse = cachedResponseForCurrentRequest()
        
        if cachedResponse == nil {
            cachedResponse = CachedResponse()
        }
        
        if let data = self.receivedData {
            cachedResponse!.data = data
        }
        
        if let url:NSURL? = self.request.URL, let absoluteString = url?.absoluteString {
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
        if let url:NSURL? = self.request.URL, let absoluteString = url?.absoluteString {
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