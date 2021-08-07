//: A UIKit based Playground for presenting user interface
  
import UIKit
import Foundation
import PlaygroundSupport
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
       // webView = UIWebView()
        let btnNav = UIButton(frame: CGRect(x: 0, y: 25, width: view.frame.width / 2, height: 20))
        btnNav.backgroundColor = UIColor.black
        btnNav.setTitle("Back", for: UIControl.State())
        btnNav.addTarget(self, action: #selector(WKWebViewController.navigateBack), for: UIControl.Event.touchUpInside)
        
        let btnReload = UIButton(frame: CGRect(x: view.frame.width / 2, y: 25, width: view.frame.width / 2, height: 20))
        btnReload.backgroundColor = UIColor.black
        btnReload.setTitle("Reload", for: UIControl.State())
        btnReload.showsTouchWhenHighlighted = true
        btnReload.addTarget(self, action: #selector(WKWebViewController.reloadPage), for: UIControl.Event.touchUpInside)
        
        view.addSubview(btnNav)
        view.addSubview(btnReload)
        

    }

    deinit {
        print(#function, "\(self)")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        //view.addSubview(webView)

        let requestURL = URL(string: "https://igeorge1982.local/login/index.html")
        
        let urlrequest = URLRequest(url: requestURL!)
        webView.load(urlrequest)
        
        //webView.load(urlrequest)
    }
    
    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadPage() {
        webView.reload()
    }
    
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = WKWebViewController()
