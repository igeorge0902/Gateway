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
//import Starscream

@available(iOS 9.0, *)
class HomeVC: UIViewController, UIViewControllerTransitioningDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout /*, WebSocketDelegate */{

    deinit {
        print(#function, "\(self)")
    }

    var imageView:UIImageView = UIImageView()
    var backgroundDict:Dictionary<String, String> = Dictionary()
    
//    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
//    lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
   
    lazy var session = URLSession.sharedCustomSession
    var url:URL?

    var running = false
    var beenViewed = false
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var sessionIDLabel : UILabel!
    
    var collectionView: UICollectionView!
    //var socket: WebSocket!
    //var stream: Stream = Stream()

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
        
        let view:UIView = UIView(frame: CGRect(x: -15, y: 0, width: self.view.frame.size.width /* * 0.7*/, height: self.view.frame.size.height));
        
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)

        
        let backgroundImage:UIImage? = UIImage(named: backgroundDict["Background1"]!)
        
        imageView = UIImageView(frame: view.frame);
        imageView.image = backgroundImage;
        
       // view.addSubview(imageView);
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width * 0.7, height: 200)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(FeedCells.self, forCellWithReuseIdentifier: "FeedCell")
       // collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.backgroundColor = UIColor.lightGray
        
        view.addSubview(collectionView)
        
        /*
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context) as NSManagedObject
        context.refresh(cachedResponse, mergeChanges: false)
        */
        
        MoviesData.addData()
        
       // socket = WebSocket(url: URL(string: "wss://milo.crabdance.com:8444/login/jsr356toUpper")!)
       // socket.delegate = self
       // socket.connect()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
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
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goto_login", sender: self)
        
        } else {
        
            //self.usernameLabel.text = prefs.value(forKey: "USERNAME") as? String
            //self.sessionIDLabel.text = prefs.value(forKey: "JSESSIONID") as? String
            
            /*
            if (socket.isConnected) {
                
                socket.write(string: "hello!", completion: {
                    print("hello!")
                    })
                }*/

            }
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: finish
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goto_map" {
            let nextSegue = segue.destination as? MapViewController
            nextSegue?.map2 = false
            
        }
        
    }
    
    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    func dataTask(_ onCompletion: ServiceResponse) {
        url = URL(string: serverURL + "/login/logout")!

        var request:URLRequest = URLRequest(url: url!)
        
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
                        self.performSegue(withIdentifier: "goto_login", sender: self)
                        
                    default:
                        
                        NSLog("Got an HTTP \(httpResponse.statusCode)")
                        
                    }
                    
                }
                
                self.running = false
                
            }
        })
        
        
        running = true
        task.resume()
        
    }
    
       @IBAction func basket(_ sender: UIButton) {
        
        if BasketData_.count < 1 {
            
            UIAlertController.popUp(title: "Warning!", message: "No free seat(s) to be reserved!")
            
        } else {
            
            let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "Basket")
            
            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.transitioningDelegate = self
            //pvc.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            self.present(pvc, animated: true, completion: nil)
            
        }
        
    }

    @IBAction func logoutTapped(_ sender : UIButton) {
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {

        self.dataTask() {
            (resultString, error) -> Void in
    
            print(error!)
            print(resultString)
            
            }
            
        }
        
        
    }
    
    
    @IBAction func NearbyVenues(_ sender: UIButton) {
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue != 0 {

        self.performSegue(withIdentifier: "goto_map", sender: self)
        
        }
        
    }
    
    @IBAction func Navigation(_ sender : UIButton) {
        
        
       //Create the AlertController
               let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Choose an option!", preferredStyle: .actionSheet)
               
               //Create and add the Cancel action
               let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                   //Just dismiss the action sheet
               }
               actionSheetController.addAction(cancelAction)
        
               //Create and add first option action
               let goToMenu: UIAlertAction = UIAlertAction(title: "Go to Menu", style: .default) { action -> Void in
                   
                   self.performSegue(withIdentifier: "goto_menu", sender: self)
                
               }
               actionSheetController.addAction(goToMenu)
        
               //Create and add a second option action
               let goToLogin: UIAlertAction = UIAlertAction(title: "Go to Login Screen", style: .default) { action -> Void in
                let prefs:UserDefaults = UserDefaults.standard
                prefs.set(0, forKey: "ISLOGGEDIN")
                prefs.synchronize()
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goto_login", sender: self)
        
               }
               actionSheetController.addAction(goToLogin)
               
               //Present the AlertController
               self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func WebView(_ sender : UIButton) {
        
        self.performSegue(withIdentifier: "goto_webview", sender: self)
        

    }
    
    @IBAction func Movies(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goto_movies", sender: self)

    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCells
        
        cell.textLabel?.text = "label"
        
        
        
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = 4
        
        
        let title = NSMutableAttributedString(string: (cell.textLabel?.text!)!, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 14.0)!]))
        title.append(NSAttributedString(string: "\nBudapest", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 12.0)!, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])))
        title.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle ,range: NSMakeRange(0, title.string.characters.count))
        
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "Shit Hits Fan-25")
        icon.bounds = CGRect(x: 10, y: -2, width: 12, height: 12)
        
        title.append(NSAttributedString(attachment: icon))
        
        cell.textLabel?.attributedText = title
        cell.profileImage?.image = UIImage(named: "milo")
        
        let myTextAttribute = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)! ]
        let detailText = NSMutableAttributedString(string: "Meanwhile, Milo turned to the bright side.", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute) )
        
        cell.statusText?.attributedText = detailText
        
        return cell
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    /*
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
        let str: NSString? = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(str as Any)
       // socket.stream(stream, handle: Stream.Event.hasBytesAvailable)

    }
    */



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

}
