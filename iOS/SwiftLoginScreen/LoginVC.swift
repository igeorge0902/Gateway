//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON


let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString

class LoginVC: UIViewController,UITextFieldDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    deinit {
        print(#function, "\(self)")
    }
    
    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
    //lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    //lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
    
    lazy var session = NSURLSession.sharedCustomSession

    
    var running = false
    
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        backgroundDict = ["Login":"login"]
        
        let view:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
        
        self.view.addSubview(view)
        
        self.view.sendSubviewToBack(view)
        
        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Login"]!)
        
        
        imageView = UIImageView(frame: view.frame);
        
        imageView.image = backgroundImage;
        
        view.addSubview(imageView);
        
        /*
        let myGesture = UITapGestureRecognizer(target: self, action: "tappedAwayFunction:")
        self.view.addGestureRecognizer(myGesture)
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    let url:NSURL = NSURL(string:"https://milo.crabdance.com/login/HelloWorld")!
    
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(username: String, hash: String, deviceId: String, systemVersion: String, onCompletion: ServiceResponse) {

        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        // post data. The server will use this data to reproduce the hash
        let post:NSString = "user=\(username)&pswrd=\(hash)&deviceId=\(deviceId)&ios=\(systemVersion)"
        
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        // content length
        let postLength:NSString = String( postData.length )

        let time = zeroTime(0).getCurrentMillis()
        
        // hmac data
        let post_ = "/login/HelloWorld:user=\(username)&pswrd=\(hash)&deviceId=\(deviceId):\(time):\(post.length)"
        
        let hmacSHA512 = CryptoJS.hmacSHA512()
        
        // Create secret for "X-HMAC-HASH" header generation
        let hmacSec:NSString = hmacSHA512.hmac(username as String, secret: hash as String)

        
        // Create base64 encoded hmacHash for "X-HMAC-HASH" header
        let hmacHash:NSString = hmacSHA512.hmac(post_, secret: hmacSec as String)
                
        NSLog("hmacSecret: %@",hmacSec);
        NSLog("PostData: %@",post);
        
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(hmacHash as String, forHTTPHeaderField: "X-HMAC-HASH")
        request.setValue(String(time), forHTTPHeaderField: "X-MICRO-TIME")
        
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
                
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
                
            } else {
            
            let json:JSON = JSON(data: data!)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print("got some data")
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                        
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

                        let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:
                            
                            NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                    
                        let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                        let sessionID:NSString = jsonData.valueForKey("JSESSIONID") as! NSString
                        let xtoken:NSString = jsonData.valueForKey("X-Token") as! NSString
                        
                        NSLog("sessionId ==> %@", sessionID);
                        
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                            NSLog("Login SUCCESS");
                                                        
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.setValue(sessionID, forKey: "JSESSIONID")
                            prefs.setValue(deviceId, forKey: "deviceId")
                            prefs.setValue(xtoken, forKey: "X-Token")
                            
                            prefs.synchronize()
                        }
                        
                    NSLog("got a 200")
                    self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } catch {
                        
                        //TODO: handle error
                    }
                    
                default:
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Server error \(httpResponse.statusCode)"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    NSLog("Got an HTTP \(httpResponse.statusCode)")
                }
                
            } else {
                
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                NSLog("Connection Failure")
            }
            
            self.running = false
            onCompletion(json, error)
            
            }
        })
        
        running = true
        task.resume()
        
    }
    
    
    
    @IBAction func signinTapped(sender : UIButton) {
        //let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        NSLog("deviceId ==> %@", deviceId)
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let systemVersion = UIDevice.currentDevice().systemVersion

        let SHA3 = CryptoJS.SHA3()

        let hash = SHA3.hash(password as String,outputLength: 512)
        
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        
        } else {
            
            self.dataTask(username as String, hash: hash, deviceId: deviceId, systemVersion: systemVersion){
                (resultString, error) -> Void in
                
                print(resultString)
                
            }
                    
    }
    
   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
            textField.resignFirstResponder()
            return true
        }
    
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
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
