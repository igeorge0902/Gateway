//
//  File.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject, UIAlertViewDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate  {

    static let sharedInstance = RestApiManager()
    
    func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 0:
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let deviceId = prefs.valueForKey("deviceId")
            let user = prefs.valueForKey("USERNAME")

            var errorOnLogin:GeneralRequestManager?
            
            var i = ["a","b"]
            
            let stringRepresentation = i.joinWithSeparator("-")
            
            errorOnLogin = GeneralRequestManager(url: "https://milo.crabdance.com/login/activation", errors: "", method: "POST", queryParameters: nil , bodyParameters: ["deviceId": stringRepresentation as String, "user": user as! String])
            
            errorOnLogin?.getResponse {
                
                (resultString, error) -> Void in
                
                print(resultString)
            }

        default: break
            
        }
    }

    //let baseURL = "http://api.randomuser.me/"
    let baseURL = "https://milo.crabdance.com/login/admin?JSESSIONID="

    var running = false

    func getRandomUser(onCompletion: (JSON, NSError?) -> Void) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let sessionId:NSString = prefs.valueForKey("JSESSIONID") as! NSString
        
        let route = baseURL+(sessionId as String)
       // let route = baseURL
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON, err)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let xtoken = prefs.valueForKey("X-Token")

        let request = NSMutableURLRequest.requestWithURL(NSURL(string: path)!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["Ciphertext": xtoken as! String], cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
        
       //let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
       //let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:NSOperationQueue.mainQueue())

        let session = NSURLSession.sharedCustomSession
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, sessionError -> Void in
            
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
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    if httpResponse.statusCode == 300 {
                        
                        let jsonData:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:
                            
                            NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        
                        let message:NSString = jsonData.valueForKey("Activation") as! NSString
                        
                        alertView.title = "Activation is required! To send the activation email tap on the Okay button!"
                        alertView.message = "Voucher is active: \(message)"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("Okay")
                        alertView.addButtonWithTitle("Cancel")
                        alertView.cancelButtonIndex = 1
                        alertView.show()
                        
                        
                    } else {
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Connection Failure!"
                        alertView.message = error!.localizedDescription
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                        
                    }
                }
                
                
            } else {
            
            let json:JSON = JSON(data: data!)
                
                onCompletion(json, error)
            }
        })
        running = true
        task.resume()
    }
    
    //MARK: Perform a POST Request
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"

        let body = body as? NSData
        
        // Set the POST body for the request
        request.HTTPBody = (try! NSJSONSerialization.JSONObjectWithData(body!, options:NSJSONReadingOptions.MutableContainers)) as? NSData
        
        //NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            let err = error

            onCompletion(json, err)
        })
        task.resume()
    }
    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        print("didReceiveAuthenticationChallenge")
        
        completionHandler(
            
            NSURLSessionAuthChallengeDisposition.UseCredential,
            NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse,
                    newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        
        let newRequest : NSURLRequest? = request
        
        print(newRequest?.description);
        completionHandler(newRequest)
    }

    
}