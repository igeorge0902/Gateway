//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON

let deviceId = UIDevice.current.identifierForVendor!.uuidString
var kKeychainItemName: String?
class LoginVC: UIViewController,UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    deinit {
        print(#function, "\(self)")
    }
    
    
    
    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
    //lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    //lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
    
    lazy var session = Foundation.URLSession.sharedCustomSession

    
    var running = false
    
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewWillAppear(_ animated: Bool) {
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        
        if (isLoggedIn == 1) {
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backgroundDict = ["Login":"login"]
        
        let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height));
        
        self.view.addSubview(view)
        
        self.view.sendSubview(toBack: view)
        
        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Login"]!)
        
        
        imageView = UIImageView(frame: view.frame);
        
        imageView.image = backgroundImage;
        
        view.addSubview(imageView);
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self

        view.addGestureRecognizer(tap)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let url:URL = URL(string:"https://milo.crabdance.com/login/HelloWorld")!
    
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(_ username: String, hash: String, deviceId: String, systemVersion: String, onCompletion: @escaping ServiceResponse) {
        
        var request = URLRequest.init(url: url)
      //  let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        // post data. The server will use this data to reproduce the hash
        let post:NSString = "user=\(username)&pswrd=\(hash)&deviceId=\(deviceId)&ios=\(systemVersion)" as NSString
        
        
        let postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
        
        // content length
        let postLength:NSString = String( postData.count ) as NSString

        let time = zeroTime(0).getCurrentMillis()
        
        // hmac data
        let post_ = "/login/HelloWorld:user=\(username)&pswrd=\(hash)&deviceId=\(deviceId):\(time):\(post.length)"
        
        let hmacSHA512 = CryptoJS.hmacSHA512()
        
        // Create secret for "X-HMAC-HASH" header generation
        let hmacSec:NSString = hmacSHA512.hmac(username as String, secret: hash as String) as NSString
        
        // Create base64 encoded hmacHash for "X-HMAC-HASH" header
        let hmacHash:NSString = hmacSHA512.hmac(post_, secret: hmacSec as String) as NSString
            
        NSLog("hmacSecret: %@",hmacSec);

        NSLog("PostData: %@",post);
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(hmacHash as String, forHTTPHeaderField: "X-HMAC-HASH")
        request.setValue(String(time), forHTTPHeaderField: "X-MICRO-TIME")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, sessionError -> Void in
            
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
                
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
                
                
            } else {
            
            let json:JSON = JSON(data: data!)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("got some data")
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                        
                        let prefs:UserDefaults = UserDefaults.standard

                        let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: data!, options:
                            
                            JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                    
                        let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                        let sessionID:NSString = jsonData.value(forKey: "JSESSIONID") as! NSString
                        let xtoken:NSString = jsonData.value(forKey: "X-Token") as! NSString
                        
                        NSLog("sessionId ==> %@", sessionID);
                        
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                            NSLog("Login SUCCESS");
                                                        
                            prefs.set(username, forKey: "USERNAME")
                            prefs.set(1, forKey: "ISLOGGEDIN")
                            prefs.set(0, forKey: "ISWEBLOGGEDIN")
                            prefs.setValue(sessionID, forKey: "JSESSIONID")
                            prefs.setValue(deviceId, forKey: "deviceId")
                            prefs.setValue(xtoken, forKey: "X-Token")
                            
                            prefs.synchronize()
                            
                            kKeychainItemName = username
                        }
                        
                    NSLog("got a 200")
                    self.dismiss(animated: true, completion: nil)
                        
                    } catch {
                        
                        //TODO: handle error
                    }
                    
                default:
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Server error \(httpResponse.statusCode)"
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    alertView.show()
                    NSLog("Got an HTTP \(httpResponse.statusCode)")
                }
                
            } else {
                
                // create a helper method
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
                NSLog("Connection Failure")
            }
            
            self.running = false
            onCompletion(json, error as NSError?)
            
            }
        })
        
        running = true
        task.resume()
     
    }
    
    
    
    @IBAction func signinTapped(_ sender : UIButton) {
        //let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        NSLog("deviceId ==> %@", deviceId)
        let username:NSString = txtUsername.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let systemVersion = UIDevice.current.systemVersion

        let SHA3 = CryptoJS.SHA3()

        let hash:String = SHA3.hash(password as String,outputLength: 512)
        
        
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        
        } else {
            
            self.dataTask(username as String, hash: hash, deviceId: deviceId, systemVersion: systemVersion){
                
                (resultString, error) -> Void in
                
                print(resultString)
                
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
            textField.resignFirstResponder()
            return true
    }


}
