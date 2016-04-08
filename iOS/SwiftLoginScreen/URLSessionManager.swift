//
//  RequestManager2.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 16/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//

import Foundation
import SwiftyJSON

class URLSessionManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    typealias CallbackBlock = (result: String, error: String?) -> ()
    
    
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print(resultString)
        } else {
            print(error)
        }
    }
    
    func httpGet(request: NSMutableURLRequest!, callback: (String, String?) -> Void) {
        
        let session = NSURLSession.sharedCustomSession
        
        let task = session.dataTaskWithRequest(request){
            
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
                
            } else {
                let result = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    /*
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
            completionHandler(
                
                NSURLSessionAuthChallengeDisposition.UseCredential,
                NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }*/
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
            let newRequest : NSURLRequest? = request
            
            print(newRequest?.description);
            completionHandler(newRequest)
    }
}

