//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON


class SignupVC: UIViewController {
    
    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
    deinit {
        print(#function, "\(self)")
    }
    
    lazy var session = NSURLSession.sharedCustomSession
    var running = false

    @IBOutlet var txtVoucher : UITextField!
    @IBOutlet var txtEmail : UITextField!

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundDict = ["Signup":"signup"]
        
        let view:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
        
        self.view.addSubview(view)
        
        self.view.sendSubviewToBack(view)
        
        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Signup"]!)
        
        
        imageView = UIImageView(frame: view.frame);
        
        imageView.image = backgroundImage;
        
        view.addSubview(imageView);
        
        self.hideKeyboardWhenTappedAround();
    
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
    
    @IBAction func gotoLogin(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let url:NSURL = NSURL(string:"https://milo.crabdance.com/login/voucher")!
    let urlR:NSURL = NSURL(string:"https://milo.crabdance.com/login/register")!

    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(voucher: String, email: String, username: String, hash: String, deviceId: String, systemVersion: String, onCompletion: ServiceResponse) {
        
        let requestV:NSMutableURLRequest = NSMutableURLRequest(URL: url)

        let request:NSMutableURLRequest = NSMutableURLRequest(URL: urlR)
        
        // post data. The server will use this data to reproduce the hash
        let post:NSString = "user=\(username)&email=\(email)&pswrd=\(hash)&deviceId=\(deviceId)&voucher_=\(voucher)&ios=\(systemVersion)"
        
        let postV:NSString = "voucher=\(voucher)"
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let postDataV:NSData = postV.dataUsingEncoding(NSASCIIStringEncoding)!
        
        // content length
        let postLength:NSString = String( postData.length )
        let postLengthV:NSString = String( postDataV.length )

        let time = zeroTime(0).getCurrentMillis()
        
        // hmac data
        let post_ = "/login/register:user=\(username)&email=\(email)&pswrd=\(hash)&deviceId=\(deviceId)&voucher_=\(voucher):\(time):\(post.length)"
        
        let hmacSHA512 = CryptoJS.hmacSHA512()
        
        // Create secret for "X-HMAC-HASH" header generation
        let hmacSec:NSString = hmacSHA512.hmac(username as String, secret: hash as String)
        
        
        // Create base64 encoded hmacHash for "X-HMAC-HASH" header
        let hmacHash:NSString = hmacSHA512.hmac(post_, secret: hmacSec as String)
        
        NSLog("hmacSecret: %@",hmacSec);
        NSLog("PostData: %@",post);
        NSLog("PostData: %@",postV);

        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(hmacHash as String, forHTTPHeaderField: "X-HMAC-HASH")
        request.setValue(String(time), forHTTPHeaderField: "X-MICRO-TIME")
        
        requestV.HTTPMethod = "POST"
        requestV.HTTPBody = postDataV
        requestV.setValue(postLengthV as String, forHTTPHeaderField: "Content-Length")
        
        requestV.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestV.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let taskV = session.dataTaskWithRequest(requestV, completionHandler: {data, response, sessionError -> Void in
            
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
                    
                    if httpResponse.statusCode == 412 {
                    
                        alertView.title = "SignUp Failed!"
                        alertView.message = "Voucher is already used!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    
                    } else {
                        
                        alertView.title = "Connection Failure!"
                        alertView.message = error!.localizedDescription
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                }
                
                else {
                    
                    alertView.title = "Connection Failure!"
                    alertView.message = error!.localizedDescription
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                }

                
            } else {
                
                let json:JSON = JSON(data: data!)
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    print("got some data")
                    
                    switch(httpResponse.statusCode) {
                    case 200:
                        
                        do {
                            
                                self.dataTask(request, username: username, onCompletion: { (json) in
                                    //
                                })
                        }
                        
                    default:
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "SignUp Failed!"
                        alertView.message = "Server error \(httpResponse.statusCode)"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                    }
                    
                }
                
                self.running = false
                onCompletion(json, error)
                
            }
        })
        
        running = true
        taskV.resume()
        
       
    }
    
    func dataTask (request:NSMutableURLRequest, username:String, onCompletion: ServiceResponse) {
        
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, sessionError -> Void in
            
            var error = sessionError
            let json:JSON = JSON(data: data!)

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
                    
                    if httpResponse.statusCode == 502 {
                        
                        let jsonData:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:
                            
                            NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                        
                        let message:NSString = jsonData.valueForKey("Message") as! NSString
                        
                        
                        alertView.title = "SignUp Failed!"
                        alertView.message = "Error: \(message)"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
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
                
               // let json:JSON = JSON(data: data!)
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    print("got some data")
                    
                    switch(httpResponse.statusCode) {
                    case 200:
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            
                            let jsonData:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:
                                
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
                                prefs.setInteger(0, forKey: "ISWEBLOGGEDIN")
                                prefs.setValue(sessionID, forKey: "JSESSIONID")
                                prefs.setValue(deviceId, forKey: "deviceId")
                                prefs.setValue(xtoken, forKey: "X-Token")
                                
                                prefs.synchronize()
                            }
                            
                            NSLog("got a 200")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    default:
                        
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "SignUp Failed!"
                        alertView.message = "Server error \(httpResponse.statusCode)"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                    }
                    
                }
                
                self.running = false
                onCompletion(json, error)
                
            }
        })
        
        running = true
        task.resume()
        
    }
    
    
    @IBAction func signupTapped(sender : UIButton) {
        //let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        NSLog("deviceId ==> %@", deviceId)
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let voucher:NSString = txtVoucher.text!
        let email:NSString = txtEmail.text!

        let systemVersion = UIDevice.currentDevice().systemVersion
        
        let SHA3 = CryptoJS.SHA3()
        
        let hash = SHA3.hash(password as String,outputLength: 512)
                
        let isUsername = username.isEqualToString("")
        let isPassword = password.isEqualToString("")
        let isEmail = email.isEqualToString("")
        let isVoucher = voucher.isEqualToString("")

        var ErrorData:Array< String > = Array < String >()

        if ( isUsername || isPassword || isEmail || isVoucher) {
            
            let Message:NSDictionary = ["Username":isUsername, "Password":isPassword, "Email":isEmail, "Voucher":isVoucher]
            
            for (bookid, title) in Message {
                if (title.isEqualToNumber(1)) {
                    
                    ErrorData.append(bookid as! String)
                    
                }
                
            }
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "SignUp Failed!"
            alertView.message = "Please enter \(ErrorData.minimalDescrption)!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
                    
                
            
            
        } else {
            
            self.dataTask(voucher as String, email: email as String, username: username as String, hash: hash, deviceId: deviceId, systemVersion: systemVersion){
                (resultString, error) -> Void in
                
                print(resultString)
                
            }
        
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
