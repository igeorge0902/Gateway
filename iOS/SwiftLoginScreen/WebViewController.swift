//
//  WebViewController.swift
//
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class WebViewController: UIViewController, UIWebViewDelegate {
    lazy var webView:UIWebView = UIWebView()
    
    deinit {
        webView.delegate = nil
       // webView = nil
        print(#function, "\(self)")
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
       // webView = UIWebView()
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.addTarget(self, action: #selector(WebViewController.navigateBack), for: UIControl.Event.touchUpInside)
        
        let btnReload = UIButton(frame: CGRect(x: view.frame.width / 2, y: 25, width: view.frame.width / 2, height: 20))
        btnReload.backgroundColor = UIColor.black
        btnReload.setTitle("Reload", for: UIControl.State())
        btnReload.showsTouchWhenHighlighted = true
        btnReload.addTarget(self, action: #selector(WebViewController.reloadPage), for: UIControl.Event.touchUpInside)
        
        view.addSubview(btnNav)
        view.addSubview(btnReload)
        
        webView.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        definesPresentationContext = true
        webView.delegate = self
        webView.scrollView.bounces = true
        webView.scalesPageToFit = true

        let ciphertext = cipherText.getCipherText(deviceId)
        let requestURL = URL(string: serverURL + "/example/index.html")
        let request = URLRequest.requestWithURL(requestURL!, method: "GET", queryParameters: nil, bodyParameters: nil, headers: ["M-Device": ciphertext], cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20, isCacheable: nil, contentType: "", bodyToPost: nil)
        
        view.addSubview(webView)
        webView.loadRequest(request)
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadPage() {
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

    func webView(_: UIWebView, shouldStartLoadWith request: URLRequest, navigationType _: UIWebView.NavigationType) -> Bool {
        // We have to also close the webview, without user-interaction.
        if request.url!.relativePath == "/example/tabularasa.jsp" {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        return true
    }

    func webView(_: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        /*
         let alertView:UIAlertView = UIAlertView()

         alertView.title = "Error!"
         alertView.message = "Connection Failure: \(error!.localizedDescription)"
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         */
        print(error.localizedDescription)
        NSLog("There was a problem loading the web page!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
