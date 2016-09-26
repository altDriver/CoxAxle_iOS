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
    var vinNumber: String?
    
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
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        
    }
    
    //MARK:- XTIME API
    func fetchXtimeDataAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching XTime Data API Called", label: "XTime Data", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            Alamofire.request(Constant.API.kBaseUrlPath+"xtime", method: .get, parameters: nil).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: XTime = try XTime(dictionary: JSON as! [AnyHashable: Any])
                                
                                let firstName = UserDefaults.standard.object(forKey: "FirstName") as! String
                                let lastname = UserDefaults.standard.object(forKey: "LastName") as! String
                                let email = UserDefaults.standard.object(forKey: "Email") as! String
                                let phone = UserDefaults.standard.object(forKey: "Phone") as! String
                                let vin = self.vinNumber ?? ""
                                
                                let deepLinkingURL = NSString(format: "https://consumer-ptr1.xtime.com/scheduling/?webKey=%@&VIN=%@&Provider=%@&Keyword=%@&cfn=%@&cln=%@&cpn=%@&cem=%@&NOTE=NOTE4Q3&extid=%@&extctxt=%@&dest=VEHICLE", (dict.response?.WebKey)!,vin,(dict.response?.Provider)!, (dict.response?.Keyword)!, firstName, lastname, phone, email, (dict.response?.Extid)!, (dict.response?.Extctxt)!)
                                self.webView.loadRequest(NSURLRequest(url: NSURL(string: deepLinkingURL as String)! as URL) as URLRequest)

                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        else {
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
                        }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }

    }
    
    //MARK:- UIWEBVIEW DELEGATE METHODS
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
        self.view.bringSubview(toFront: loading)
        self.view.addSubview(loading)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loading.hide()
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
