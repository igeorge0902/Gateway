//
//  ViewController.swift
//  devdactic-rest
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class MenuVC: UIViewController, SFSafariViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    deinit {
        print(#function, "\(self)")
    }
    
    lazy var nameTextView = UITextView()
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var sessionIDLabel : UILabel!
    
    lazy var session = URLSession.sharedCustomSession
    lazy var url = URL(string: serverURL + "/login/logout")

    var running = false
    lazy var items = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let btnData = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: 25, width: self.view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("Purchases", for: UIControl.State())
        btnData.showsTouchWhenHighlighted = true
        btnData.addTarget(self, action: #selector(MenuVC.navigateToPurchases), for: UIControl.Event.touchUpInside)
        
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(btnData)
        self.view.addSubview(btnNav)
        
        // create the textView
        nameTextView = UITextView(frame: CGRect(x: self.view.frame.size.height * 0.05, y: 25 * 3.0, width: self.view.frame.size.width * 0.8, height: self.view.frame.height / 5))
        nameTextView.isEditable = false
        
        let myTextAttribute = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)! ]
        let detailText = NSMutableAttributedString(string: "user", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute) )
        
        nameTextView.attributedText = detailText
        nameTextView.textAlignment = NSTextAlignment.justified
        nameTextView.alwaysBounceVertical = true
        nameTextView.layer.borderWidth = 2
        nameTextView.layer.borderColor = UIColor.darkGray.cgColor

        self.view.addSubview(nameTextView)
        
        self.addData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
            
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    @objc func navigateBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func navigateToPurchases() {
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {
            
            self.performSegue(withIdentifier: "goto_mypurchases", sender: self)

            /*
            let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "Purchases")
            
            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.transitioningDelegate = self
            //pvc.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            self.present(pvc, animated: true, completion: nil)
            */
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goto_mypurchases" {
            let nextSegue = segue.destination as? PurchasesVC
            
        }
        
    }
    
    func addData() {
        
        RestApiManager.sharedInstance.getRandomUser {
            (json: JSON, error: NSError?) in
            
            // if response == 300
            if let message_ = json["Error Details"].object as? NSDictionary {
                
                self.nameTextView.text = message_.value(forKey: "User") as! String!

            } else {
            
            let users: AnyObject = json["user"].object as AnyObject
            self.items.add(users)
            let user:JSON =  JSON(self.items[0])
            self.nameTextView.text = user.string
            
           // DispatchQueue.main.async(execute: { self.tableView?.reloadData()})
            
            }
        }
        
    }
    
    @IBAction func logoutTapped(_ sender : UIButton) {
        
        //if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {
            
            self.dataTask() {
                (resultString, error) -> Void in
                
                if error == nil {

                    print(resultString)
                    
                  self.dismiss(animated: true, completion: nil)

                } else {
                
                print(error!)
                
                }
            }
            
       // }
        
    }
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(_ onCompletion: @escaping ServiceResponse) {

        var request:URLRequest = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("", forHTTPHeaderField: "Referer")
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, sessionError)  in
            
            //TODO: nil handling
            let json:JSON = try! JSON(data: data!)

            var error = sessionError
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    
                    let description = "HTTP response was \(httpResponse.statusCode)"
                    
                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                    
                    UIAlertController.popUp(title: "Error:", message: error!.localizedDescription)
                    
                }
            }
            
            if error != nil {
                
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = "Error!"
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
                
                
            } else {
                
                if let httpResponse = response as? HTTPURLResponse {
                    NSLog("got some data")
                    
                    switch(httpResponse.statusCode) {
                    case 200:
                        
                        NSLog("got a " + String(httpResponse.statusCode) + " response code")
                        
                        let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                        
                        let success:NSString = jsonData.value(forKey: "Success") as! NSString
                        
                        if(success == "true")
                        {
                            NSLog("LogOut SUCCESS");
                            
                            let appDomain = Bundle.main.bundleIdentifier
                            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                            
                        }
                        
                        
                    default:
                        
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                        
                    }
                    
                }
                
                onCompletion(json, error as NSError?)
                self.running = false
                
            }
        })
        
        
        running = true
        task.resume()
        
        
    }
    
    //TODO: nice to have to dismiss MenuVC
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {

        controller.dismiss(animated: true, completion: nil)
        
    }

    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
