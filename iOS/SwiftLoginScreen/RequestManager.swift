//
//  Downloader.swift
//  MyFirstSwiftApp
//
//  Created by Gaspar Gyorgy on 18/07/15.
//  Copyright (c) 2015 Gaspar Gyorgy. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponses = (JSON, NSError?) -> Void

class RequestManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    var url: NSURL!
    var errors: String!
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    init?(url: String, errors: String) {
        super.init()
        self.url = NSURL(string: url)!
        self.errors = errors
        if url.isEmpty { }
        if errors.isEmpty { }
    }
    
    deinit {
        
        NSLog("\(url) is being deinitialized")
        NSLog("\(errors) is being deinitialized")
        NSLog(#function, "\(self)")

    }

  // lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
  // lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
    
  lazy var session: NSURLSession = NSURLSession.sharedCustomSession

    var running = false
    
    func getResponse(onCompletion: (JSON, NSError?) -> Void) {
        
        dataTask ({ json, err in
        
            onCompletion(json as JSON, err)
        
        })
    }
    
    func dataTask(onCompletion: ServiceResponses) {
       
        let xtoken = prefs.valueForKey("X-Token")
        
        let request = NSMutableURLRequest.requestWithURL(url, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["Ciphertext": xtoken as! String], cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, sessionError -> Void in
            
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
                

                let json:JSON = JSON(data: data!)

                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                let alertView:UIAlertView = UIAlertView()

                    NSLog("got a 200")
                
                if self.url.relativePath?.containsString("/login") != true {
                    
                    }
                
                    else if let user = json["user"].string {
                   
                        if !user.isEmpty {
                        
                        prefs.setObject(user, forKey: "USERNAME")
                        
                        alertView.title = "Welcome"
                        alertView.message = user as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                            
                            NSLog("User ==> %@", user);

                        
                        } else {
                           
                            alertView.title = "Sorry!"
                            alertView.message = "User does not exist!"
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                            NSLog("User ==> %@", user);

                        }

                    } else {
                        
                        alertView.title = "Hmmm..."
                        alertView.message = "Something went wrong... \(json["user"].error?.localizedDescription)" as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                        NSLog("Dictionary\(["user"]) does not exist")
                    }
                
            self.running = false            
            onCompletion(json, error)
                
                }
            
            //  }
        })
        
        running = true
        task.resume()
        
        
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
            print("didReceiveAuthenticationChallenge")
            
            completionHandler(
                
                NSURLSessionAuthChallengeDisposition.UseCredential,
                NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    /*
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        // For example, you may want to override this to accept some self-signed certs here.
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust &&
            Constants.selfSignedHosts.contains(challenge.protectionSpace.host) {
                
                // Allow the self-signed cert.
                let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                completionHandler(.UseCredential, credential)
        } else {
            // You *have* to call completionHandler either way, so call it to do the default action.
            completionHandler(.PerformDefaultHandling, nil)
        }
    }
    
    // MARK: - Constants
    
    struct Constants {
        
        // A list of hosts you allow self-signed certificates on.
        // You'd likely have your dev/test servers here.
        // Please don't put your production server here!
        static let selfSignedHosts: Set<String> = ["milo.crabdance.com", "localhost"]
    }*/
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
            let newRequest : NSURLRequest? = request
            
            print(newRequest?.description);
            completionHandler(newRequest)
    }
    
}
