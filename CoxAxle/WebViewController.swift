//
//  WebViewViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 07/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {
    
    @IBOutlet var carManualWebView: UIWebView!
    var loading: UIActivityIndicatorView_ActivityClass! = nil
    var webViewUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWebView()
        
    }
    
    func loadWebView() {
        
        if let url = NSURL(string: webViewUrl!) {
            
            let requestObject = NSURLRequest(URL: url)
            carManualWebView.loadRequest(requestObject)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIWEBVIEW DELEGATE METHODS
    
    func webViewDidStartLoad(webView: UIWebView) {
        loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
        self.view.bringSubviewToFront(loading)
        self.view.addSubview(loading)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loading.hide()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loading.hide()
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
