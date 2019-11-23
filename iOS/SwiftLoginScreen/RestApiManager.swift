//
//  File.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import Foundation
import SwiftyJSON
//import Kanna

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
            
            errorOnLogin = GeneralRequestManager(url: serverURL + "/login/activation", errors: "", method: "POST", queryParameters: nil , bodyParameters: ["deviceId": deviceId as String, "user": user as! String], isCacheable: nil, contentType: "", bodyToPost: nil)
            
            errorOnLogin?.getResponse {
                
                (resultString, error) -> Void in
                
                print(resultString)
                print(error as Any)
            }
            
        default: break
            
        }
    }
    
    //let baseURL = "http://api.randomuser.me/"
    let baseURL = serverURL + "/login/admin?JSESSIONID="
    
    var running = false
    
    func getRandomUser(_ onCompletion: @escaping (JSON, NSError?) -> Void) {
        
        let prefs:UserDefaults = UserDefaults.standard
        
        if let sessionId:NSString = prefs.value(forKey: "JSESSIONID") as? NSString {
        
        let route = baseURL+(sessionId as String)
        // let route = baseURL
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON, err)
            })
        }
    }
    
    func makeHTTPGetRequest(_ path: String, onCompletion: @escaping ServiceResponse) {
        
        let prefs:UserDefaults = UserDefaults.standard
        let xtoken = prefs.value(forKey: "X-Token")
        
        let request = URLRequest.requestWithURL(URL(string: path)!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["Ciphertext": xtoken as! String], cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20, isCacheable: nil, contentType: "", bodyToPost: nil)
        
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
                        
                        guard let message_ = jsonData.value(forKey: "Error Details"),
                            let message = (message_ as AnyObject).value(forKey: "Activation") else { return }
                        
                        alertView.title = "Activation is required! To send the activation email tap on the Okay button!"
                        alertView.message = "Voucher is active: \(message)"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "Okay")
                        alertView.addButton(withTitle: "Cancel")
                        alertView.cancelButtonIndex = 1
                        alertView.show()
                        
                        let json:JSON = try! JSON(data: data!)
                        onCompletion(json, error as NSError?)

                        
                    }
                    
                    if httpResponse.statusCode == 503 {
                            
                        if let result = (NSString(data: data!, encoding: String.Encoding.ascii.rawValue)) as String? {
                                
                           // if let doc = Kanna.HTML(html: result, encoding: String.Encoding.ascii) {
                                    
                            //  UIAlertController.popUp(title: "Error:", message: result)
                              
                           //     }
                                
                            }
                        }
                    
                    if httpResponse.statusCode == 502 {
                        
                      //  let json:JSON = try! JSON(data: data!)
                        
                       // if let dataBlock = json["Error Details"].object as? NSDictionary {
                            
                         //   let errorMsg = dataBlock.value(forKey: "ErrorMsg:") as! String
                            
                         //   if
                              let errorMsg = "User does not bear valid paramteres. No valid session" //{
                            
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(0, forKey: "ISLOGGEDIN")

                         //   }
                            
                            
                     //   }
                        
                        UIAlertController.popUp(title: "Error: \(httpResponse.statusCode)", message: errorMsg)
                    }
                    
                    if httpResponse.statusCode == 500 {
                       
                        let json:JSON = try! JSON(data: data!)

                        UIAlertController.popUp(title: "Error: \(httpResponse.statusCode)", message: json.rawString()!)
                    }
                }
                
                
            } else {
                
                let json:JSON = try! JSON(data: data!)
                onCompletion(json, error as NSError?)
            }
        })
        running = true
        task.resume()
    }
    
}
