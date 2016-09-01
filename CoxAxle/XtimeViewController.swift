//
//  XtimeViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 16/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class XtimeViewController: UIViewController,UIWebViewDelegate {

    var loading: UIActivityIndicatorView_ActivityClass! = nil
    @IBOutlet var webView: UIWebView!
    var language: String?
    
     //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CoxAxle"
        // Do any additional setup after loading the view.
        self.setText()
        
        let firstName = NSUserDefaults.standardUserDefaults().objectForKey("FirstName") as! String
        let lastname = NSUserDefaults.standardUserDefaults().objectForKey("LastName") as! String
        let email = NSUserDefaults.standardUserDefaults().objectForKey("Email") as! String
        let phone = NSUserDefaults.standardUserDefaults().objectForKey("Phone") as! String
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let deepLinkingURL = NSString(format: "https://consumer-ptr1.xtime.com/scheduling/?webKey=hus20131206112630208569&VIN=5J6RE3H74AL049448&Provider=COXAXLE&Keyword=SCHEDULE&cfn=%@&cln=%@&cpn=%@&cem=%@&NOTE=NOTE4Q3&extid=SCHEDULE&extctxt=COXAXLE&dest=VEHICLE", firstName, lastname, phone, email)
            webView.loadRequest(NSURLRequest(URL: NSURL(string: deepLinkingURL as String)!))
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        
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
