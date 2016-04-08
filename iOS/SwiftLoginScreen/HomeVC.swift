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



class HomeVC: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate {

    deinit {
        print(#function, "\(self)")
    }
    
    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
//    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
//    lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
   
    lazy var session = NSURLSession.sharedCustomSession

    var running = false
    
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var sessionIDLabel : UILabel!
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        // COREDATA:
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: self.managedObjectContext) as! LogItem
        
        newItem.title = "Wrote Core Data Tutorial"
        newItem.itemText = "Wrote and post a tutorial on the basics of Core Data to blog."

        backgroundDict = ["Background1":"background1"]
        
        let view:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
        
        self.view.addSubview(view)
        
        self.view.sendSubviewToBack(view)

        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Background1"]!)
        
        
        imageView = UIImageView(frame: view.frame);
        
        imageView.image = backgroundImage;
        
        view.addSubview(imageView);
        
        print(managedObjectContext)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [LogItem] {
            
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
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
        
            self.performSegueWithIdentifier("goto_login", sender: self)
        
        } else {
        
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
            self.sessionIDLabel.text = prefs.valueForKey("JSESSIONID") as? String
        }
        
        }
        
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
    
    let url:NSURL = NSURL(string:"https://milo.crabdance.com/login/logout")!
    
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(onCompletion: ServiceResponse) {
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("", forHTTPHeaderField: "Referer")
        
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
                
                alertView.title = self.title!
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                
                
            } else {
                
                let json:JSON = JSON(data: data!)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                NSLog("got some data")
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    NSLog("got a 200")
                    
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                    
                    let success:NSString = jsonData.valueForKey("Success") as! NSString
                    
                    if(success == "true")
                    {
                        NSLog("LogOut SUCCESS");
                        
                        let appDomain = NSBundle.mainBundle().bundleIdentifier
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
                    }
                    self.performSegueWithIdentifier("goto_login", sender: self)
                    
                default:
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Server error!"
                    alertView.message = "Server error \(httpResponse.statusCode)"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    NSLog("Got an HTTP \(httpResponse.statusCode)")
                    
                }
                
            } else {
                
                let alertView:UIAlertView = UIAlertView()
                
                alertView.title = "LogOut Failed!"
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
    

    @IBAction func logoutTapped(sender : UIButton) {
        
        self.dataTask() {
            (resultString, error) -> Void in
            
            print(error)
            print(resultString)
            
        }
    }
    
    @IBAction func Navigation(sender : UIButton) {
        
       /*
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vcs = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
        self.navigationController?.pushViewController(vcs, animated: true)
        */
        
        self.performSegueWithIdentifier("goto_menu", sender: self)

        /*
        let vc = MenuVC(nibName: "MenuVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @IBAction func WebView(sender : UIButton) {
        
        /*
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vcs = storyboard.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
        self.navigationController?.pushViewController(vcs, animated: true)
        */
        
        self.performSegueWithIdentifier("goto_webview", sender: self)
        

    }
    
    @IBAction func Test(sender: UIButton) {
        
        self.performSegueWithIdentifier("goto_test", sender: self)

    }

    
}
