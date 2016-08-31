//
//  SessionExpireViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 26/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class SessionExpireViewController: UIViewController, UITextFieldDelegate, UIAlertController_UIAlertView {

    @IBOutlet var sessionPasswordField: UITextField!
    var language: String?
    
    @IBOutlet var usernameLabel: UILabel!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        
        let username = NSUserDefaults.standardUserDefaults().objectForKey("Email") as! String

        self.usernameLabel.text = String(format: "Please re-enter your password for %@", username)
        self.sessionPasswordField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
         self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
    }
    
    
    //MARK:- REGENERATE SESSION API
    func reCreateSession() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            if self.sessionPasswordField.text?.characters.count > 0 {
                    
                    let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                    self.view.addSubview(loading)
                    let email = NSUserDefaults.standardUserDefaults().objectForKey("Email") as! String
                    let passwordEncryption = self.sessionPasswordField.text?.encodeStringTo64()
                    
                    let paramsDict: [ String : AnyObject] = ["email": email, "password": passwordEncryption! as String] as Dictionary
                    print(NSString(format: "Request: %@", paramsDict))
                    
                    Alamofire.request(.POST, Constant.API.kBaseUrlPath+"customer", parameters: paramsDict)
                        .responseJSON { response in
                            loading.hide()
                            if let JSON = response.result.value {
                                
                                print(NSString(format: "Response: %@", JSON as! NSDictionary))
                                let status = JSON.valueForKey("status") as! String
                                if status == "True" {
                                    do {
                                        let dict: Login = try Login.init(dictionary: JSON as! [NSObject : AnyObject])
                                        
                                        print(dict.response!.data)
                                        let restArray = dict.response!.data[0] as! NSDictionary
                                        print(restArray.valueForKey("token"))
                                        NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("token"), forKey: "Token")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("email"), forKey: "Email")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "USER_LOGGED_IN")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        
                                    }
                                    catch let error as NSError {
                                        NSLog("Unresolved error \(error), \(error.userInfo)")
                                    }
                                    
                                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "SESSION_EXPIRED")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CALL_API")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                else
                                {
                                    let errorMsg = JSON.valueForKey("message") as! String
                                    self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                                }
                            }
                    }
            }
            else {
                    showAlertwithCancelButton("Error", message: "Please enter your password".localized(self.language!), cancelButton: "OK".localized(self.language!))
            }
        }
        else {
            print("Internet connection FAILED")
            showAlertwithCancelButton("No Internet Connection".localized(self.language!), message: "Make sure your device is connected to the internet.".localized(self.language!), cancelButton: "OK".localized(self.language!))
        }
    }
    
    //MARK:- UITEXTFIELD DELEGATE METHODS
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        self.reCreateSession()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.reCreateSession()
        return true
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
