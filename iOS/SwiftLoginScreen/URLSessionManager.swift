//
//  RequestManager2.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 16/11/15.
//  Copyright © 2015 Dipin Krishna. All rights reserved.
//

import Foundation
import SwiftyJSON

class URLSessionManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    typealias CallbackBlock = (_ result: String, _ error: NSError?) -> ()
    
    
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print(resultString)
        } else {
            print(error!)
        }
    }
    
    func httpGet(_ request: URLRequest!, callback: @escaping (String, String?) -> Void) {
        
        let session = Foundation.URLSession.sharedCustomSession
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error)  in
            if error != nil {
                callback("", error!.localizedDescription)
                
            } else {
                let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!
                
                callback(result as String, nil)
            }
        })
        task.resume()
    }
    /*
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
            completionHandler(
                
                NSURLSessionAuthChallengeDisposition.UseCredential,
                NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }*/
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
            
            let newRequest : URLRequest? = request
            
            print(newRequest?.description);
            completionHandler(newRequest)
    }
}

