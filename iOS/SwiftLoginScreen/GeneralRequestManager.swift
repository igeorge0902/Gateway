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
    
    fileprivate var urlResponse:URLResponse?

    var url: URL!
    var errors: String!
    var method: String!
    var queryParameters: [String:String]?
    var bodyParameters: [String:String]?
    var isCacheable: String?

    var prefs:UserDefaults = UserDefaults.standard
    
    init?(url: String, errors: String, method: String, queryParameters: [String:String]?, bodyParameters: [String:String]?, isCacheable: String?) {
        super.init()
        self.url = URL(string: url)!
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

    
    lazy var session: URLSession = URLSession.sharedCustomSession
    
    var running = false
    
    func getResponse(_ onCompletion: @escaping (JSON, NSError?) -> Void) {
        
        if self.isCacheable == "1" {
        
        if let localResponse = cachedResponseForCurrentRequest(), let data = localResponse.data {
            
            var headerFields:[String : String] = [:]
            
            headerFields["Content-Length"] = String(format:"%d", data.count)
            
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
    func dataTask(_ onCompletion: @escaping ServiceResponses) {
        
        // TODO: temp solution
        var xtoken = prefs.value(forKey: "X-Token")
        if xtoken == nil {
            
            xtoken = ""
        }

        
        let request = URLRequest.requestWithURL(url, method: method, queryParameters: queryParameters, bodyParameters: bodyParameters as NSDictionary?, headers: ["Ciphertext": xtoken as! String], cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
                
        let task = session.dataTask(with: request, completionHandler: {data, response, sessionError -> Void in

           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //  if  let json:JSON = try! JSON(data: data!) {
            var error = sessionError
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    
                    let description = "HTTP response was \(httpResponse.statusCode)"
                    
                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                    
                }
            }
            
            if error != nil {
                
                let json:JSON = JSON(data: data!)
                
                _ = UIAlertController.popUp(title: "Error:", message: error!.localizedDescription + ", " + json.rawString()!)
                
                
            }
            else {
                
               // let json: AnyObject! = try?NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                if self.isCacheable == "1" {
                    
                    self.saveCachedResponse(data!)
                }
                
                let json:JSON = JSON(data: data!)
                
                if json["movies"].object is NSArray {
                    
                    NSLog("movies are loaded...")
                    
                } else {
                    
                    _ = UIAlertController.popUp(title: "Hello!", message: json.rawString()!)
                    
                }
                
                NSLog("got a 200")
                
                self.running = false
                onCompletion(json, error as NSError?)
                
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
    fileprivate func saveCachedResponse(_ data: Data) {
        
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        
        var cachedResponse = cachedResponseForCurrentRequest()
        
        if cachedResponse == nil {
            cachedResponse = CachedResponse()
        }
        
        if let data_:Data = data {
            cachedResponse!.data = data_
        }
        
        if let url:URL? = url, let absoluteString = url?.absoluteString {
            cachedResponse!.url = absoluteString
        }
        
        cachedResponse!.timestamp = Date()
        if let response = self.urlResponse {
            
            if let mimeType = response.mimeType {
                cachedResponse!.mimeType = mimeType as NSString!
            }
            
            if let encoding = response.textEncodingName {
                cachedResponse!.encoding = encoding
            }
        }
        
        realm.add(cachedResponse!)
        
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
    fileprivate func cachedResponseForCurrentRequest() -> CachedResponse? {
        if let url:URL? = url, let absoluteString = url?.absoluteString {
            let p:NSPredicate = NSPredicate(format: "url == %@", argumentArray: [ absoluteString ])
            
            // Query
            let results = CachedResponse.objects(with: p)
            
            if results.count > 0 {
                return results.object(at: 0) as? CachedResponse
            }
        }
        
        return nil
    }
    
}

extension UIAlertController {
    
    static func popUp(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
