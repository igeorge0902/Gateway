//
//  Downloader.swift
//  MyFirstSwiftApp
//
//  Created by Gaspar Gyorgy on 18/07/15.
//  Copyright (c) 2015 Gaspar Gyorgy. All rights reserved.
//

import Foundation
import SwiftyJSON
//import Kanna
//import Toaster
//import Toast_Swift

typealias ServiceResponses = (JSON, NSError?) -> Void
// Only used to handle webview logins
class RequestManager: NSObject {
    
    var url: URL!
    var errors: String!
    var prefs:UserDefaults = UserDefaults.standard
    
    init?(url: String, errors: String) {
        super.init()
        self.url = URL(string: url)!
        self.errors = errors
        if url.isEmpty { }
        if errors.isEmpty { self.errors = "Trouble" }
        
    }
    
    deinit {
        
        NSLog("\(url!) is being deinitialized")
        NSLog("\(errors!) is being deinitialized")
        NSLog(#function, "\(self)")
        
    }
    
    // lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    // lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
    
    lazy var session: URLSession = URLSession.sharedCustomSession
    
    var running = false
    
    func getResponse(_ onCompletion: @escaping ServiceResponses) {
        
        dataTask ({ json, err in
            
            onCompletion(json as JSON, err)
            
        })
    }
    
    
    func dataTask(_ onCompletion: @escaping ServiceResponses) {
        
        var xtoken = prefs.value(forKey: "X-Token")
        
        if xtoken == nil {
            xtoken = ""
        }

        let request = URLRequest.requestWithURL(url, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["Ciphertext": xtoken as! String], cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20, isCacheable: nil, contentType: "", bodyToPost: nil)
        
        let task = session.dataTask(with: request, completionHandler: {data, response, sessionError -> Void in
            
            var error = sessionError
            
            if let httpResponse = response as? HTTPURLResponse {
                
                let description = "HTTP response was \(httpResponse.statusCode)"
                
                error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                NSLog(error!.localizedDescription)
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    
                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                    
                    let headers:NSDictionary = httpResponse.allHeaderFields as NSDictionary
                    
                    if let xtoken:NSString = headers.value(forKey: "X-Token") as? NSString {
                        
                        self.prefs.set(xtoken, forKey: "X-Token")
                        
                    }
                    
                    if let user:NSString = headers.value(forKey: "User") as? NSString {
                        
                        self.prefs.set(user, forKey: "USERNAME")
                        
                    }
                    
                }
            
                    if httpResponse.statusCode == 300 {
                        
                        let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: data!, options:
                            
                            JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        guard let message = jsonData.value(forKey: "Error Details"),
                            let activation = (message as AnyObject).value(forKey: "Activation") else { return }
                        
                        self.prefs.setValue(activation, forKey: "Activation")
                        self.prefs.set(1, forKey: "ISWEBLOGGEDIN")
                        
                        
                        UIAlertController.popUp(title: "Warning", message: "Your account is not activated yet: \(message)")
                        
                    }
                    
                    if httpResponse.statusCode == 503 {
                        
                        
                        UIAlertController.popUp(title: self.errors, message: "Connection Failure: \(error!.localizedDescription)")
                        
                    }
                    
                    if httpResponse.statusCode == 502 {
                        
                        if self.errors != nil {
                            
                            UIAlertController.popUp(title: "Error:", message: self.errors)
                        }
                    
                    else {
                        
                        UIAlertController.popUp(title: self.errors, message: "Connection Failure: \(error!.localizedDescription)")
                        }
                    }
                
            else {
                
                let json:JSON = try! JSON(data: data!)
                let prefs:UserDefaults = UserDefaults.standard
                        
                if let httpResponse = response as? HTTPURLResponse {
                    
                    NSLog("got a " + String(httpResponse.statusCode) + " response code")
                    
                    if httpResponse.statusCode == 200 {
                        
                    if let user = json["user"].string, let uuid = json["uuid"].string {
                        
                        if uuid != "no UUID" {
                            
                            prefs.set(user, forKey: "USERNAME")
                            prefs.set(1, forKey: "ISWEBLOGGEDIN")
                            prefs.set(1, forKey: "ISLOGGEDIN")
                            
                            UIAlertController.popUp(title: "Welcome", message: user as String)

                            NSLog("User ==> %@", user);
                            
                            
                        } else {
                            // TODO: add corresponding server response
                            UIAlertController.popUp(title: "Sorry!", message: "User does not exist!")
                            
                            NSLog("User ==> %@", user);
                            
                        }
                        
                    }
                }
            }
                
                
                self.running = false
                onCompletion(json, error as NSError?)
                
                }
            }
            
        })
        
        running = true
        task.resume()
        
        
    }
    
}
