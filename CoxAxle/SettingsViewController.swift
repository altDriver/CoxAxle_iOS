//
//  SettingsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 19/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UIAlertController_UIAlertView {
    
    var language: String?

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
        self.callFetchUserDetailsAPI()
        //self.callUpdateUserDetailsAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("CALL_API") {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "CALL_API")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.callFetchUserDetailsAPI()
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
    
    //MARK:-  UIBUTTON ACTIONS
    @IBAction func menuButtonClicked(sender: UIButton) {
        sideMenuVC.toggleMenu()
    }
    
    //MARK:- FETCH USER DETAILS API
    func callFetchUserDetailsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let token: String = NSUserDefaults.standardUserDefaults().objectForKey("Token") as! String
            let paramsDict: [ String : AnyObject] = ["uid": "21", "token": token] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"user/list", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let sessionStatus = JSON.valueForKey("session_status") as! String
                        if sessionStatus == "1" {
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                              do {
                             let dict: UserDetails = try UserDetails(dictionary: JSON as! [NSObject : AnyObject])

                             print(dict.response)
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
                        else {
                            
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SESSION_EXPIRED")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
                            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
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
    
    
    //MARK:- UPDATE USER DETAILS API
    func callUpdateUserDetailsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let token: String = NSUserDefaults.standardUserDefaults().objectForKey("Token") as! String
            let paramsDict: [ String : AnyObject] = ["uid": "21", "token": token, "first_name": "Pru", "last_name": "Krish", "email": "pru@gmail.com", "phone": "7799002145", "language": "EN"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"user/update", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: UpdateUserDetails = try UpdateUserDetails(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict.message)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
