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

class RestApiManager: NSObject, UIAlertViewDelegate {

    static let sharedInstance = RestApiManager()
    
    func alertView(_ View: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        switch buttonIndex{
            
        case 0:
            
            let prefs:UserDefaults = UserDefaults.standard
            let user = prefs.value(forKey: "USERNAME")
            
            var errorOnLogin:GeneralRequestManager?
            
            //var i = ["a","b"]
            
            //let stringRepresentation = i.joinWithSeparator("-")
            
            errorOnLogin = GeneralRequestManager(url: "https://milo.crabdance.com/login/activation", errors: "", method: "POST", queryParameters: nil , bodyParameters: ["deviceId": deviceId as String, "user": user as! String], isCacheable: nil)
            
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

    func getRandomUser(_ onCompletion: @escaping (JSON, NSError?) -> Void) {
        
        let prefs:UserDefaults = UserDefaults.standard
        
        let sessionId:NSString = prefs.value(forKey: "JSESSIONID") as! NSString
        
        let route = baseURL+(sessionId as String)
       // let route = baseURL
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON, err)
        })
    }
    
    func makeHTTPGetRequest(_ path: String, onCompletion: @escaping ServiceResponse) {
        
        let prefs:UserDefaults = UserDefaults.standard
        let xtoken = prefs.value(forKey: "X-Token")

        let request = URLRequest.requestWithURL(URL(string: path)!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["Ciphertext": xtoken as! String], cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)

        let session = URLSession.sharedCustomSession
        
        let task = session.dataTask(with: request, completionHandler: {data, response, sessionError -> Void in
            
            var error = sessionError

            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    
                    let description = "HTTP response was \(httpResponse.statusCode)"
                    
                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                    
                }
            }
            
            if error != nil {
                
                let alertView:UIAlertView = UIAlertView()
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 300 {
                        
                        let jsonData:NSDictionary = try! JSONSerialization.jsonObject(with: data!, options:
                            
                            JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        let message:NSString = jsonData.value(forKey: "Activation") as! NSString
                        
                        alertView.title = "Activation is required! To send the activation email tap on the Okay button!"
                        alertView.message = "Voucher is active: \(message)"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "Okay")
                        alertView.addButton(withTitle: "Cancel")
                        alertView.cancelButtonIndex = 1
                        alertView.show()
                        
                        
                    } else {
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Connection Failure!"
                        alertView.message = error!.localizedDescription
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                        
                    }
                }
                
                
            } else {
            
            let json:JSON = JSON(data: data!)
                onCompletion(json, error as NSError?)
            }
        })
        running = true
        task.resume()
    }
    
    //MARK: Perform a POST Request
    func makeHTTPPostRequest(_ path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        
        var request = URLRequest(url: URL(string: path)!)
        
        // Set the method to POST
        request.httpMethod = "POST"

        let body = body as? Data
        
        // Set the POST body for the request
        request.httpBody = (try! JSONSerialization.jsonObject(with: body!, options:JSONSerialization.ReadingOptions.mutableContainers)) as? Data
        
        //NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, sessionError)  in
            let json:JSON = JSON(data: data!)

            onCompletion(json, sessionError as NSError?)
        })
        task.resume()
    }
    
}
