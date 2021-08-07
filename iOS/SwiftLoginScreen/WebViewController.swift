//
//  WebViewController.swift
//
//
//  Created by Gaspar Gyorgy on 27/03/16.
//  Copyright © 2016 George Gaspar. All rights reserved.
//
  
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    lazy var webView:WKWebView = WKWebView()
    var response: URLResponse!
    var httpresponse: HTTPURLResponse!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //let config = WKWebViewConfiguration()
        //config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        definesPresentationContext = true
        webView.scrollView.bounces = true
        view.addSubview(webView)
        
        let requestURL = URL(string: "https://igeorge1982.local/login/index.html")
        var urlrequest = URLRequest(url: requestURL!)
        
        //urlrequest.setValue("M", forHTTPHeaderField: "M")
        webView.load(urlrequest)
    }
    
    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadPage() {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            print("cookis: \(cookies)")
          
                for cookie in cookies {
                let cookieStorage = HTTPCookieStorage.shared
                cookieStorage.setCookie(cookie)
                    
                    if (cookie.name == "X-Token") {
                        let prefs: UserDefaults = UserDefaults.standard
                        prefs.setValue(cookie.value, forKey: "X-Token")
                    }
                }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.relativePath == "/login/index.jsp" {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
