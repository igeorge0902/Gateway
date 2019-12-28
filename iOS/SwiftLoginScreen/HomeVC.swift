//
//  HomeVC.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.

import CoreData
import SwiftyJSON
import UIKit
import WebKit
// import Starscream

@available(iOS 9.0, *)
class HomeVC: UIViewController, UIViewControllerTransitioningDelegate { /* , WebSocketDelegate */
    deinit {
        print(#function, "\(self)")
    }

    var imageView: UIImageView!
    var backgroundDict: [String: String] = Dictionary()

    lazy var session = URLSession.sharedCustomSession
    var url: URL?

    var running = false
    var beenViewed = false
    
    // var socket: WebSocket!
    // var stream: Stream = Stream()

    // Retreive the managedObjectContext from AppDelegate
    //let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        // COREDATA:
     //   let newItem = NSEntityDescription.insertNewObject(forEntityName: "LogItem", into: managedObjectContext) as! LogItem

     //   newItem.title = "Wrote Core Data Tutorial"
     //   newItem.itemText = "Wrote and post a tutorial on the basics of Core Data to blog."


       // let view: UIView = UIView(frame: CGRect(x: -15, y: 0, width: self.view.frame.size.width /* * 0.7*/, height: self.view.frame.size.height))
       // self.view.addSubview(view)
       // self.view.sendSubviewToBack(view)
        
        backgroundDict = ["Background1": "background1"]
        let backgroundImage: UIImage? = UIImage(named: backgroundDict["Background1"]!)

        imageView = UIImageView(frame: view.bounds)
        imageView.image = backgroundImage
        view.addSubview(imageView);

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

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        // Create a new fetch request using the LogItem entity
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LogItem")

        // Execute the fetch request, and cast the results to an array of LogItem objects
        //if let fetchResults = (try? managedObjectContext.fetch(fetchRequest)) as? [LogItem] {
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

            let prefs: UserDefaults = UserDefaults.standard
            let isLoggedIn: Int = prefs.integer(forKey: "ISLOGGEDIN") as Int

            if isLoggedIn != 1 {
                dismiss(animated: true, completion: nil)
                performSegue(withIdentifier: "goto_login", sender: self)

            } else {
                /*
                 if (socket.isConnected) {

                     socket.write(string: "hello!", completion: {
                         print("hello!")
                         })
                     }*/
            }
    }

    // TODO: finish
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_map" {
            let nextSegue = segue.destination as? MapViewController
            nextSegue?.map2 = false
        }
    }

    typealias ServiceResponse = (JSON, NSError?) -> Void

    func dataTask(_: ServiceResponse) {
        url = URL(string: serverURL + "/login/logout")!

        var request: URLRequest = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("", forHTTPHeaderField: "Referer")

        let task = session.dataTask(with: request, completionHandler: { data, response, sessionError in

            var error = sessionError

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    let description = "HTTP response was \(httpResponse.statusCode)"

                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                }
            }

            if error != nil {
                let alertView: UIAlertView = UIAlertView()

                alertView.title = "Error!"
                alertView.message = "Connection Failure: \(error!.localizedDescription)"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()

            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    NSLog("got some data")

                    switch httpResponse.statusCode {
                    case 200:

                        NSLog("got a " + String(httpResponse.statusCode) + " response code")

                        let jsonData: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary

                        let success: NSString = jsonData.value(forKey: "Success") as! NSString

                        if success == "true" {
                            NSLog("LogOut SUCCESS")

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

    @IBAction func basket(_: UIButton) {
        if BasketData_.count < 1 {
            UIAlertController.popUp(title: "Warning!", message: "No free seat(s) to be reserved!")

        } else {
            let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "Basket")

            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.transitioningDelegate = self
            // pvc.view.backgroundColor = UIColor.groupTableViewBackgroundColor()

            present(pvc, animated: true, completion: nil)
        }
    }

    @IBAction func logoutTapped(_: UIButton) {
            dataTask {
                (resultString, error) -> Void in

                print(error!)
                print(resultString)
            }
    }

    @IBAction func NearbyVenues(_: UIButton) {
            performSegue(withIdentifier: "goto_map", sender: self)
    }

    @IBAction func Navigation(_: UIButton) {
        // Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Choose an option!", preferredStyle: .actionSheet)

        // Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            // Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)

        // Create and add first option action
        let goToMenu: UIAlertAction = UIAlertAction(title: "Go to Menu", style: .default) { _ -> Void in

            self.performSegue(withIdentifier: "goto_menu", sender: self)
        }
        actionSheetController.addAction(goToMenu)

        // Create and add a second option action
        let goToLogin: UIAlertAction = UIAlertAction(title: "Go to Login Screen", style: .default) { _ -> Void in
            let prefs: UserDefaults = UserDefaults.standard
            prefs.set(0, forKey: "ISLOGGEDIN")
          //  prefs.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goto_login", sender: self)
        }
        actionSheetController.addAction(goToLogin)
        // Present the AlertController
        //self.present(actionSheetController, animated: false, completion: nil)
        DispatchQueue.main.async {
        let topViewController = UIApplication.shared.keyWindow?.rootViewController
        topViewController?.present(actionSheetController, animated: true, completion: nil)
        }
    }

    @IBAction func WebView(_: UIButton) {
        // Dismiss the Old
        if let presented = self.presentedViewController {
            presented.removeFromParent()
        }
        performSegue(withIdentifier: "goto_webview", sender: self)
    }

    @IBAction func Movies(_: UIButton) {
        performSegue(withIdentifier: "goto_movies", sender: self)
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
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
