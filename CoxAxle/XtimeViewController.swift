//
//  XtimeViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 16/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class XtimeViewController: GAITrackedViewController,UIWebViewDelegate, UIAlertController_UIAlertView {

    var loading: UIActivityIndicatorView_ActivityClass! = nil
    @IBOutlet var webView: UIWebView!
    var language: String?
    
     //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        self.screenName = "XTimeViewController"
        super.viewDidLoad()

        self.title = "CoxAxle"
        // Do any additional setup after loading the view.
        self.setText()
        
        self.fetchXtimeDataAPI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        
    }
    
    //MARK:- XTIME API
    func fetchXtimeDataAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            Alamofire.request(.GET, Constant.API.kBaseUrlPath+"xtime")
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: XTime = try XTime(dictionary: JSON as! [NSObject : AnyObject])
                                
                                let firstName = NSUserDefaults.standardUserDefaults().objectForKey("FirstName") as! String
                                let lastname = NSUserDefaults.standardUserDefaults().objectForKey("LastName") as! String
                                let email = NSUserDefaults.standardUserDefaults().objectForKey("Email") as! String
                                let phone = NSUserDefaults.standardUserDefaults().objectForKey("Phone") as! String
                                
                                let deepLinkingURL = NSString(format: "https://consumer-ptr1.xtime.com/scheduling/?webKey=%@&VIN=5J6RE3H74AL049448&Provider=%@&Keyword=%@&cfn=%@&cln=%@&cpn=%@&cem=%@&NOTE=NOTE4Q3&extid=%@&extctxt=%@&dest=VEHICLE", (dict.response?.WebKey)!,(dict.response?.Provider)!, (dict.response?.Keyword)!, firstName, lastname, phone, email, (dict.response?.Extid)!, (dict.response?.Extctxt)!)
                                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: deepLinkingURL as String)!))

                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                        }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }

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
