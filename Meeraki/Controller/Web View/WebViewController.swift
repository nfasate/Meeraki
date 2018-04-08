//
//  WebViewController.swift
//  Meeraki
//
//  Created by NILESH_iOS on 30/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    //MARK:- IBOutlet variables
    @IBOutlet var webView: UIWebView!
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "http://www.samsung.com/in/")
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




/*
 class ViewController: UIViewController , WKNavigationDelegate{
 
 Write code on viewDidLoad():
 
 // loading URL :
 let myBlog = "https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile"
 let url = NSURL(string: myBlog)
 let request = NSURLRequest(URL: url!)
 
 // init and load request in webview.
 webView = WKWebView(frame: self.view.frame)
 webView.navigationDelegate = self
 webView.loadRequest(request)
 self.view.addSubview(webView)
 self.view.sendSubviewToBack(webView)
 
 Write delegate methods:
 
 //MARK:- WKNavigationDelegate
 
 func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
 print(error.localizedDescription)
 }
 
 
 func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
 print("Strat to load")
 }
 
 func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
 print("finish to load")
 }
 
 
 
 
 import UIKit
 import WebKit
 class ViewController: UIViewController, WKUIDelegate {
 
 var webView: WKWebView!
 
 override func loadView() {
 let webConfiguration = WKWebViewConfiguration()
 webView = WKWebView(frame: .zero, configuration: webConfiguration)
 webView.uiDelegate = self
 view = webView
 }
 override func viewDidLoad() {
 super.viewDidLoad()
 
 let myURL = URL(string: "https://www.apple.com")
 let myRequest = URLRequest(url: myURL!)
 webView.load(myRequest)
 }}
 */
