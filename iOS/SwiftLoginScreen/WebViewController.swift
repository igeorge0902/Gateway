//
//  WebViewController.swift
//  
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 9.0, *)
class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var webView: UIWebView!
   // var mutableData: NSMutableData!


    deinit {
        webView = nil
        print(#function, "\(self)")
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setTitle("R", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "reloadPage:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = button
        self.navigationItem.rightBarButtonItem = rightBarButton
        */
        
        webView.scrollView.bounces = true
        webView.scalesPageToFit = true
        
        /*
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        */

        let ciphertext = cipherText.getCipherText(deviceId)
        let requestURL = URL(string: serverURL + "/example/index.html")
        let request = URLRequest.requestWithURL(requestURL!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["M-Device" : ciphertext], cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20, isCacheable: nil, contentType: "", bodyToPost: nil)
        
        webView.loadRequest(request)
        view.addSubview(webView)
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
    }
    /*
    override func loadView() {
        super.loadView() // call parent loadView
        
        self.view = self.web // make it the main view
    }*/
    
    func reloadPage(_ sender: AnyObject) {
        webView.reload()
    }
    
    func webViewDidStartLoad(_: UIWebView) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NSLog("WebView started loading...")
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        NSLog("WebView finished loading...")

    }
    
    func webView(_: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url!.relativePath == "/example/tabularasa.jsp" {
                webView = nil
                self.dismiss(animated: true, completion: nil)
        }
        
        return true;
    }
    
    
    @IBAction func close(_ sender : UIButton) {
        
        webView = nil
        self.dismiss(animated: true, completion: {
            print(self);
        })
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        /*
        let alertView:UIAlertView = UIAlertView()
        
        alertView.title = "Error!"
        alertView.message = "Connection Failure: \(error!.localizedDescription)"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
        */
        NSLog("There was a problem loading the web page!")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
