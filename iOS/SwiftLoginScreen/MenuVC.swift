//
//  ViewController.swift
//  devdactic-rest
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import SafariServices
import SwiftyJSON
import UIKit

class MenuVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    deinit {
        print(#function, "\(self)")
    }

    lazy var nameTextView = UITextView()
    lazy var nameTextView_ = UITextView()
    lazy var nameTextViewX = UITextView()

    lazy var session = URLSession.sharedCustomSession
    lazy var url = URL(string: serverURL + "/login/logout")

    var running = false
    lazy var items = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_: Bool) {
        let btnData = UIButton(frame: CGRect(x: view.frame.width / 2, y: 25, width: view.frame.width / 2, height: 20))
        btnData.backgroundColor = UIColor.black
        btnData.setTitle("Purchases", for: UIControl.State())
        btnData.showsTouchWhenHighlighted = true
        btnData.addTarget(self, action: #selector(MenuVC.navigateToPurchases), for: UIControl.Event.touchUpInside)

        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.addTarget(self, action: #selector(MenuVC.navigateBack), for: UIControl.Event.touchUpInside)

        view.addSubview(btnData)
        view.addSubview(btnNav)

        // create the textView
        nameTextView = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: 25 * 3.0, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextView.isEditable = false

        let myTextAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
        let detailText = NSMutableAttributedString(string: "user", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute))

        nameTextView.attributedText = detailText
        nameTextView.textAlignment = NSTextAlignment.justified
        nameTextView.alwaysBounceVertical = true
        nameTextView.layer.borderWidth = 2
        nameTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        // create the textView
        nameTextView_ = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: view.frame.height / 4.5, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextView_.isEditable = false

        let myTextAttribute_ = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                
        let detailText_ = NSMutableAttributedString(string: "JSESSION cookie", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttribute_))

        nameTextView_.attributedText = detailText_
        nameTextView_.textAlignment = NSTextAlignment.justified
        nameTextView_.alwaysBounceVertical = true
        nameTextView_.layer.borderWidth = 2
        nameTextView_.layer.borderColor = UIColor.darkGray.cgColor
        
        let cookieStorage = HTTPCookieStorage.shared
             if let cookies_ = cookieStorage.cookies {
                 for cookie in cookies_ {
                     if (cookie.name == "JSESSIONID") {
                        self.nameTextView_.text = cookie.value
                     }
                 }
         }
        
        // create the textView
        nameTextViewX = UITextView(frame: CGRect(x: view.frame.size.height * 0.05, y: (view.frame.height / 4.5)+(view.frame.height / 10)+2, width: view.frame.size.width * 0.8, height: view.frame.height / 10))
        nameTextViewX.isEditable = false

        let myTextAttributeX = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "Courier New", size: 13.0)!]
                
        let detailTextX = NSMutableAttributedString(string: "x-cookie", attributes: convertToOptionalNSAttributedStringKeyDictionary(myTextAttributeX))

        nameTextViewX.attributedText = detailTextX
        nameTextViewX.textAlignment = NSTextAlignment.justified
        nameTextViewX.alwaysBounceVertical = true
        nameTextViewX.layer.borderWidth = 2
        nameTextViewX.layer.borderColor = UIColor.darkGray.cgColor
        
             if let cookies_ = cookieStorage.cookies {
                 for cookie in cookies_ {
                     if (cookie.name == "XSRF-TOKEN") {
                        self.nameTextViewX.text = cookie.value
                     }
                 }
         }

        view.addSubview(nameTextView)
        view.addSubview(nameTextView_)
        view.addSubview(nameTextViewX)

        addData()
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        let prefs: UserDefaults = UserDefaults.standard
        let isLoggedIn: Int = prefs.integer(forKey: "ISLOGGEDIN") as Int

        //   if (isLoggedIn != 1) {

        //       self.dismiss(animated: true, completion: nil)
        //   }
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    @objc func navigateToPurchases() {
            performSegue(withIdentifier: "goto_mypurchases", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "goto_mypurchases" {
            let nextSegue = segue.destination as? PurchasesVC
        }
    }

    //TODO: put the completion into the origin (calling) method, not in the nesting class
    func addData() {
        RestApiManager.sharedInstance.getRandomUser {
            (json: JSON, error: NSError?) in

            // if response == 300
            if let message_ = json["Error Details"].object as? NSDictionary {
                if let errorMsg = message_.value(forKey: "ErrorMsg:") as? String {
                self.presentAlert(withTitle: "Error Details", message: errorMsg)
                }
            } else {
                let users: AnyObject = json["user"].object as AnyObject
                self.items.add(users)
                let user: JSON = JSON(self.items[0])
                self.nameTextView.text = user.string
            }
        }
    }

    @IBAction func logoutTapped(_: UIButton) {

        dataTask {
            (resultString, error) -> Void in

            if error == nil {
                print(resultString)

            //    self.dismiss(animated: true, completion: nil)

            } else {
                print(error!)
            }
        }

    }

    func dataTask(_ onCompletion: @escaping ServiceResponses) {
        var request: URLRequest = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("", forHTTPHeaderField: "Referer")

        let task = session.dataTask(with: request, completionHandler: { data, response, sessionError in

            // TODO: nil handling
            let json: JSON = try! JSON(data: data!)

            var error = sessionError

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    let description = "HTTP response was \(httpResponse.statusCode)"

                    error = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
                    NSLog(error!.localizedDescription)
                    print(data!)

                    DispatchQueue.main.async {
                        self.presentAlert(withTitle: "Error:", message: error!.localizedDescription)
                    }
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
                            self.presentAlert(withTitle: "LogOut SUCCESS", message: "Bye!")
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
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value) })
}
