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
        
        webView.scrollView.bounces = true
        webView.scalesPageToFit = true

        let requestURL = NSURL(string: "https://milo.crabdance.com/example/index.html")
        let request = NSURLRequest.requestWithURL(requestURL!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["hello" : "hello"], cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
        
        webView.loadRequest(request)
        view.addSubview(webView)

    }

    
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
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError){
        
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
