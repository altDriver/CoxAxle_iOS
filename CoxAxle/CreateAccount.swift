//
//  CreateAccount.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import SMFloatingLabelTextField


class CreateAccount: GAITrackedViewController, UIAlertController_UIAlertView{
    
    @IBOutlet var firstNameField: SMFloatingLabelTextField!
    
    @IBOutlet var lastNameField: SMFloatingLabelTextField!
    
    @IBOutlet var emailField: SMFloatingLabelTextField!
    
    @IBOutlet var passwordField: SMFloatingLabelTextField!
    var language: String?
    
    @IBOutlet var phoneNumberField: SMFloatingLabelTextField!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        self.screenName = "CreateAccount"
        self.setText()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
    
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        self.title = "Register".localized(self.language!)
        
    }
    
    // MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func registerClicked(sender: UIButton) {
        if self.firstNameField.text?.characters.count == 0 {
            self.showAlertwithCancelButton("Error", message: "Please enter your first name", cancelButton: "OK")
        }
        else if self.lastNameField.text?.characters.count == 0  {
            self.showAlertwithCancelButton("Error", message: "Please enter your last name", cancelButton: "OK")
        }
        else if self.phoneNumberField.text?.characters.count == 0 {
            self.showAlertwithCancelButton("Error", message: "Please enter your phone number", cancelButton: "OK")
        }
        else if self.emailField.text?.characters.count == 0 {
            self.showAlertwithCancelButton("Error", message: "Please enter your email", cancelButton: "OK")
        }
        else if self.passwordField.text?.characters.count == 0 {
            self.showAlertwithCancelButton("Error", message: "Please enter your password", cancelButton: "OK")
        }
        else {
            if (self.phoneNumberField.text!.isValidPhoneNumber()) {
                if (self.emailField.text!.isValidEmail()) {
                    self.callRegisterationAPI()
                }
                else {
                    self.showAlertwithCancelButton("Error", message: "Invalid email address", cancelButton: "OK")
                }
            }
            else {
                self.showAlertwithCancelButton("Error", message: "Invalid mobile number", cancelButton: "OK")
            }
        }
        
    }
    
    
    // MARK:- REGISTERATION API
    
    func callRegisterationAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let passwordEncryption = self.passwordField.text?.encodeStringTo64()
            
             let paramsDict: [String : AnyObject] = ["first_name": self.firstNameField.text! as String, "last_name": self.lastNameField.text! as String, "password": passwordEncryption! as String, "email": self.emailField.text! as String, "phone": self.phoneNumberField.text! as String] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))

            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"register", parameters: paramsDict)
                .responseJSON { response in
                
                loading.hide()
                    
                    if let JSON = response.result.value {
                        
                    print(NSString(format: "Response: %@", JSON as! NSDictionary))
                    let status = JSON.valueForKey("status") as! String
                    if status == "True" {
                        do {
                            let dict: Register = try Register(dictionary: JSON as! [NSObject : AnyObject])
                            
                            print(dict.response!.data)
                            let restArray = dict.response!.data[0] as! NSDictionary
                            NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("uid"), forKey: "UserId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("first_name"), forKey: "FirstName")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("last_name"), forKey: "LastName")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("email"), forKey: "Email")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSUserDefaults.standardUserDefaults().setObject(restArray.valueForKey("phone"), forKey: "Phone")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "USER_LOGGED_IN")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        catch let error as NSError {
                            NSLog("Unresolved error \(error), \(error.userInfo)")
                        }
                        
                       self.performSegueWithIdentifier("LoggedIn", sender: self)
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
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
        
    }
}
