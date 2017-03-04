//
//  HomeVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.

import UIKit
import SwiftyJSON
import CoreData
import WebKit
import Starscream

@available(iOS 9.0, *)
class HomeVC: UIViewController, WebSocketDelegate {

    deinit {
        print(#function, "\(self)")
    }

    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
//    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
//    lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
   
    lazy var session = URLSession.sharedCustomSession

    var running = false
    
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var sessionIDLabel : UILabel!
    
    var collectionView: UICollectionView!
    var socket: WebSocket!

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // COREDATA:
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "LogItem", into: self.managedObjectContext) as! LogItem
        
        newItem.title = "Wrote Core Data Tutorial"
        newItem.itemText = "Wrote and post a tutorial on the basics of Core Data to blog."

        backgroundDict = ["Background1":"background1"]
        
        let view:UIView = UIView(frame: CGRect(x: -25, y: 0, width: self.view.frame.size.width * 0.7, height: self.view.frame.size.height));
        
        self.view.addSubview(view)
        self.view.sendSubview(toBack: view)

        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Background1"]!)
        
        imageView = UIImageView(frame: view.frame);
        imageView.image = backgroundImage;
        
        
        print(managedObjectContext)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        //TODO: keep the connection open with a wrapped method returning a boolean value, for example 
        socket = WebSocket(url: URL(string: "wss://milo.crabdance.com:8444/login/jsr356toUpper")!)
        socket.delegate = self
        socket.connect()
        
        // let isFirstLaunch = UserDefaults.isFirstLaunch()
        // print(isFirstLaunch)
        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LogItem")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext.fetch(fetchRequest)) as? [LogItem] {
            
            /*
            // Create an Alert, and set it's message to whatever the itemText is
            let alert = UIAlertController(title: fetchResults[0].title,
                message: fetchResults[0].itemText,
                preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let okayAction: UIAlertAction = UIAlertAction(title: "Okay", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            
            alert.addAction(okayAction)
            
            // Display the alert
            self.presentViewController(alert,
                animated: true,
                completion: nil)
        }*/
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
        
            self.performSegue(withIdentifier: "goto_login", sender: self)
        
        } else {
        
            self.usernameLabel.text = prefs.value(forKey: "USERNAME") as? String
            self.sessionIDLabel.text = prefs.value(forKey: "JSESSIONID") as? String

        }
        
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let url:URL = URL(string:"https://milo.crabdance.com/login/logout")!
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(_ onCompletion: ServiceResponse) {
        
        var request:URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("", forHTTPHeaderField: "Referer")
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, sessionError)  in

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
                
                alertView.title = self.title!
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
                
                
            } else {
                
            if let httpResponse = response as? HTTPURLResponse {
                NSLog("got some data")
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    NSLog("got a 200")
                    
                    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                    
                    let success:NSString = jsonData.value(forKey: "Success") as! NSString
                    
                    if(success == "true")
                    {
                        NSLog("LogOut SUCCESS");
                        
                        let appDomain = Bundle.main.bundleIdentifier
                        UserDefaults.standard.removePersistentDomain(forName: appDomain!)

                    }
                    self.performSegue(withIdentifier: "goto_login", sender: self)
                    
                default:
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Server error!"
                    alertView.message = "Server error \(httpResponse.statusCode)"
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    alertView.show()
                    NSLog("Got an HTTP \(httpResponse.statusCode)")
                    
                }
                
            } else {
                
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = "LogOut Failed!"
                alertView.message = "Connection Failure"
                
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
                NSLog("Connection Failure")
            }
            
            self.running = false
            
            }
        })
        
            
        running = true
        task.resume()
        
    }
    

    @IBAction func logoutTapped(_ sender : UIButton) {
        
        self.dataTask() {
            (resultString, error) -> Void in
    
            print(error!)
            print(resultString)
            
        }
        
        
    }
    
    
    @IBAction func NearbyVenues(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goto_map", sender: self)

        
    }
    
    @IBAction func Navigation(_ sender : UIButton) {
        
       /*
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vcs = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
        self.navigationController?.pushViewController(vcs, animated: true)
        */
        
        self.performSegue(withIdentifier: "goto_menu", sender: self)

        /*
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @IBAction func WebView(_ sender : UIButton) {
        
        /*
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vcs = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
        self.navigationController?.pushViewController(vcs, animated: true)
        */
        
        self.performSegue(withIdentifier: "goto_webview", sender: self)
        

    }
    
    @IBAction func Movies(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goto_movies", sender: self)

    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
    
}

extension UIView {
    
    func addConstraintswithFormat(_ format: String, views: UIView...) {
        
        var ViewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            ViewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: ViewsDictionary))
    }
    
}

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> NSString {
       
        let prefs:UserDefaults = UserDefaults.standard
        let isFirstLaunch_:NSString?
        //TODO: replace with coreData
        if let isFirstLaunch = prefs.value(forKey: "FirstLaunchFlag") as? NSString {
            
            isFirstLaunch_ = isFirstLaunch;
            
        } else {
            isFirstLaunch_ = "true";
            prefs.setValue("false", forKey: "FirstLaunchFlag")
            prefs.synchronize()
        }

           // prefs.synchronize()
        

        return isFirstLaunch_!
    }
}


