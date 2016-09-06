//
//  LoginViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 12/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import JTMaterialSwitch
import SMFloatingLabelTextField

class LoginViewController: GAITrackedViewController,UIAlertController_UIAlertView {
    
    @IBOutlet weak var usernameField: SMFloatingLabelTextField!
    @IBOutlet weak var passwordField: SMFloatingLabelTextField!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    var forgotPasswordField: UITextField!
    @IBOutlet weak var switchView: UIView!
    
    var language: String?

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "LoginViewController"
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBarHidden = true
        
        let swi: JTMaterialSwitch = JTMaterialSwitch.init(size: JTMaterialSwitchSizeSmall, style: JTMaterialSwitchStyleDefault, state: JTMaterialSwitchStateOff)
        swi.frame = CGRectMake(0, 0, 30, 25)
        swi.isEnabled = true
        swi.isBounceEnabled = true
        swi.isRippleEnabled = true
        swi.rippleFillColor = UIColor.redColor()
        swi.thumbOnTintColor = UIColor.whiteColor()
        swi.thumbOffTintColor = UIColor.whiteColor()
        swi.trackOnTintColor = UIColor.redColor()
        swi.trackOffTintColor = UIColor.whiteColor()
        swi.addTarget(self, action: #selector(LoginViewController.switchStateChanged), forControlEvents: UIControlEvents.ValueChanged)
        //   self.switchView.addSubview(swi)
        
        self.setText()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
                self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
                self.usernameField.placeholder = "Email".localized(self.language!)
                self.usernameField.attributedPlaceholder = NSAttributedString(string:"Email".localized(self.language!), attributes:[NSForegroundColorAttributeName: placeHolderColor])
                self.passwordField.placeholder = "Password".localized(self.language!)
                self.passwordField.attributedPlaceholder = NSAttributedString(string:"Password".localized(self.language!), attributes:[NSForegroundColorAttributeName: placeHolderColor])
              //  self.rememberMeLabel.text = "Remember me".localized(self.language!)
                self.forgotPasswordButton.setTitle("Forgot Password".localized(self.language!), forState: UIControlState.Normal)
                self.loginButton .setTitle("Login".localized(self.language!), forState: UIControlState.Normal)
             //   self.createAnAccountButton.setTitle("Don’t have an account? Sign up".localized(self.language!), forState: UIControlState.Normal)
    }
    
    @IBAction func forgotPasswordClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Forgot Password".localized(self.language!), message: "Please enter your email address".localized(self.language!), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            // you can use this text field
            self.forgotPasswordField = textField
            self.forgotPasswordField.keyboardType = UIKeyboardType.EmailAddress
        }
        alert.addAction(UIAlertAction(title: "OK".localized(self.language!), style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
            print("User click Ok button")
            if(self.forgotPasswordField.text?.characters.count == 0)
            {
                self.showAlertwithCancelButton("Error", message: "Email address cannot be empty".localized(self.language!), cancelButton: "OK".localized(self.language!))
                return
            }
            
            self.callForgotPasswordAPI()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(self.language!), style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //MARK:- UISWITCH ACTION
    func switchStateChanged() -> Void {
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        self.callLoginAPI()
    }
    
    
    @IBAction func createAccountButtonClicked(sender: UIButton) {
        self.performSegueWithIdentifier("Register", sender: self)
    }
    
    //MARK:- LOGIN API
    func callLoginAPI() -> Void {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            if self.usernameField.text?.characters.count > 0 && self.passwordField.text?.characters.count > 0 {
                
                if (self.usernameField.text! .isValidEmail()) {
                    
                    let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                    self.view.addSubview(loading)
                    
                    let passwordEncryption = passwordField.text?.encodeStringTo64()
                    
                    let paramsDict: [ String : AnyObject] = ["email": self.usernameField.text! as String, "password": passwordEncryption! as String] as Dictionary
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
                    showAlertwithCancelButton("Error", message: "Invalid email id".localized(self.language!), cancelButton: "OK".localized(self.language!))
                }
            }
            else {
                if self.usernameField.text?.characters.count == 0 {
                    showAlertwithCancelButton("Error", message: "Please enter your username".localized(self.language!), cancelButton: "OK".localized(self.language!))
                }
                else if self.passwordField.text?.characters.count == 0 {
                    showAlertwithCancelButton("Error", message: "Please enter your password".localized(self.language!), cancelButton: "OK".localized(self.language!))
                }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- FORGOT PASSWORD API
    
    func callForgotPasswordAPI() -> Void {
        self.forgotPasswordField.resignFirstResponder()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            if (self.forgotPasswordField.text! .isValidEmail()) {
                let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                self.view.addSubview(loading)
                
                let paramsDict: [ String : AnyObject] = ["email": self.forgotPasswordField.text! as String] as Dictionary
                print(NSString(format: "Request: %@", paramsDict))
                
                Alamofire.request(.POST, Constant.API.kBaseUrlPath+"customer/resetpassword", parameters: paramsDict)
                    .responseJSON { response in
                        loading.hide()
                        if let JSON = response.result.value {
                            
                            print(NSString(format: "Response: %@", JSON as! NSDictionary))
                            let status = JSON.valueForKey("status") as! String
                            if status == "True" {
                                
                                let successMsg = JSON.valueForKey("message") as! String
                                self.showAlertwithCancelButton("Success".localized(self.language!), message: successMsg, cancelButton: "OK".localized(self.language!))
                            }
                            else
                            {
                                let errorMsg = JSON.valueForKey("message") as! String
                                self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK".localized(self.language!))
                            }
                        }
                }
            }
            else {
                showAlertwithCancelButton("Error", message: "Invalid email id".localized(self.language!), cancelButton: "OK".localized(self.language!))
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }

    //MARK:- UITEXTFIELD DELEGATE METHODS
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }

}
