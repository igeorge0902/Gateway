//
//  WebViewController.swift
//  
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    deinit {
        print(#function, "\(self)")
    }
    
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

        let requestURL = NSURL(string: "https://milo.crabdance.com/example/index.html")
        let request = NSURLRequest.requestWithURL(requestURL!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["hello" : "hello"], cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
        
        webView.loadRequest(request)
        view.addSubview(webView)

    }
    
    /*
    override func loadView() {
        super.loadView() // call parent loadView
        
        self.view = self.web // make it the main view
    }*/
    
    func reloadPage(sender: AnyObject) {
        webView.reload()
    }
    
    func webViewDidStartLoad(_: UIWebView) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSLog("WebView started loading...")
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        NSLog("WebView finished loading...")

    }
    
    func webView(_: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.URL!.relativePath == "/example/tabularasa.jsp" {
                webView = nil
                self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        return true;
    }
    
    
    @IBAction func close(sender : UIButton) {
        
        webView = nil
        self.dismissViewControllerAnimated(true, completion: {
            print(self);
        })
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
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
