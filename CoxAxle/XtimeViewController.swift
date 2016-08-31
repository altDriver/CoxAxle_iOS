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

        // Do any additional setup after loading the view.
        self.setText()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://consumer-ptr1.xtime.com/scheduling/?webKey=hus20131206112630208569&VIN=5J6RE3H74AL049448&Provider=COXAXLE&Keyword=SCHEDULE&cfn=Prudhvi&cln=Krishna&cpn=9912841997&cem=prudhvi.moturi@vensaiinc.com&NOTE=NOTE4Q3&extid=SCHEDULE&extctxt=COXAXLE&dest=VEHICLE")!))
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
