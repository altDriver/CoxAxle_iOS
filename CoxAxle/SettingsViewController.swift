//
//  SettingsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 19/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: GAITrackedViewController, UIAlertController_UIAlertView {
    
    var language: String?

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "SettingsViewController"
        self.setText()
        self.callFetchUserDetailsAPI()
        //self.callUpdateUserDetailsAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "SessionExpired")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.bool(forKey: "CALL_API") {
            UserDefaults.standard.set(false, forKey: "CALL_API")
            UserDefaults.standard.synchronize()
            self.callFetchUserDetailsAPI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
    }
    
    //MARK:-  UIBUTTON ACTIONS
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        if let frostView = self.view{
            frostView.endEditing(true)
        }
        
        if let frostingViewController = self.frostedViewController{
            frostingViewController.view.endEditing(true)
            frostingViewController.presentMenuViewController()
        }
    }
    
    //MARK:- FETCH USER DETAILS API
    func callFetchUserDetailsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching User Details API Called", label: "Fetching User Details", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"user/list", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                              do {
                             let dict: UserDetails = try UserDetails(dictionary: JSON as! [AnyHashable: Any])

                             print(dict.response)
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
    
    
    //MARK:- UPDATE USER DETAILS API
    func callUpdateUserDetailsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Update User Details API Called", label: "Update User Details", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
             let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId, "first_name": "Pru", "last_name": "Krish", "email": "pru@gmail.com", "phone": "7799002145", "language": "EN"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"user/update", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: UpdateUserDetails = try UpdateUserDetails(dictionary: JSON as! [AnyHashable: Any])
                                
                                print(dict.message)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
