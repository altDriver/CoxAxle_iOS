//
//  WebViewViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 07/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIAlertController_UIAlertView {
    
    @IBOutlet var carManualWebView: UIWebView!
    var loading: UIActivityIndicatorView_ActivityClass! = nil
    var webViewUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = self.navigationController!.viewControllers as NSArray
        
        for VC in viewControllers {
            if((VC as AnyObject).isKind(of: LandingScreen.self)){
                self.navigationItem.leftBarButtonItems = nil
                //  self.navigationController?.navigationBar.topItem?.title = ""
                
                var image = UIImage(named: "back")
                
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(WebViewController.backClicked(_:)))
                
                break
            }
        }
        
        self.loadWebView()
        
    }
    
    func loadWebView() {
        
        if let url = URL(string: webViewUrl!) {
            
            let requestObject = URLRequest(url: url)
            carManualWebView.loadRequest(requestObject)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIButton Action
    func backClicked(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        
        self.frostedViewController.presentMenuViewController()
    }
    
    //MARK:- UIWEBVIEW DELEGATE METHODS
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
        self.view.bringSubview(toFront: loading)
        self.view.addSubview(loading)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: NSError?) {
        loading.hide()
        self.showAlertwithCancelButton("Error", message: error!.localizedDescription as NSString, cancelButton: "OK")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
