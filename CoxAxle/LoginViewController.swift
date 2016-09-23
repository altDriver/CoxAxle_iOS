
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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        
        self.navigationController?.isNavigationBarHidden = true
        
        let swi: JTMaterialSwitch = JTMaterialSwitch.init(size: JTMaterialSwitchSizeSmall, style: JTMaterialSwitchStyleDefault, state: JTMaterialSwitchStateOff)
        swi.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        swi.isEnabled = true
        swi.isBounceEnabled = true
        swi.isRippleEnabled = true
        swi.rippleFillColor = UIColor.red
        swi.thumbOnTintColor = UIColor.white
        swi.thumbOffTintColor = UIColor.white
        swi.trackOnTintColor = UIColor.red
        swi.trackOffTintColor = UIColor.white
        swi.addTarget(self, action: #selector(LoginViewController.switchStateChanged), for: UIControlEvents.valueChanged)
        //   self.switchView.addSubview(swi)
        
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
//        self.usernameField.placeholder = "Email".localized(self.language!)
//        self.usernameField.attributedPlaceholder = NSAttributedString(string:"Email".localized(self.language!), attributes:[NSForegroundColorAttributeName: placeHolderColor])
//        self.passwordField.placeholder = "Password".localized(self.language!)
//        self.passwordField.attributedPlaceholder = NSAttributedString(string:"Password".localized(self.language!), attributes:[NSForegroundColorAttributeName: placeHolderColor])
//        //  self.rememberMeLabel.text = "Remember me".localized(self.language!)
//        self.forgotPasswordButton.setTitle("Forgot Password".localized(self.language!), forState: UIControlState.Normal)
//        self.loginButton .setTitle("Login".localized(self.language!), forState: UIControlState.Normal)
        //   self.createAnAccountButton.setTitle("Don’t have an account? Sign up".localized(self.language!), forState: UIControlState.Normal)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "ForgotPasswordView", sender: nil)
    }
    
    //MARK:- UISWITCH ACTION
    func switchStateChanged() -> Void {
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        self.callLoginAPI()
    }
    
    @IBAction func createAccountButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Register", sender: self)
    }
    
    //MARK:- LOGIN API
    func callLoginAPI() -> Void {
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            if self.usernameField.text?.characters.count > 0 && self.passwordField.text?.characters.count > 0 {
                
                if (self.usernameField.text! .isValidEmail()) {
                    
                    let tracker = GAI.sharedInstance().defaultTracker
                    let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Login API Called", label: "Login", value: nil).build()
                    tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
                    
                    let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                    self.view.addSubview(loading)
                    
                    let passwordEncryption = passwordField.text?.encodeStringTo64()
                     let deviceType = UIDevice.current.modelName
                     let deviceVersion = UIDevice.current.iOSVersion
                     let model = String(format: "%@,%@", deviceType,deviceVersion)
                    
                    let deviceToken = UserDefaults.standard.object(forKey: "Device_Token") as! String
                    
                    let paramsDict: [ String : String] = ["email": self.usernameField.text! as String, "password": passwordEncryption! as String, "device_token": deviceToken, "device_type": "iOS", "os_version": model] as Dictionary
                    print(NSString(format: "Request: %@", paramsDict))
                    
                    Alamofire.request(Constant.API.kBaseUrlPath+"customer", method: .post, parameters: paramsDict).responseJSON { response in
                            loading.hide()
                            if let JSON = response.result.value {
                                
                                print(NSString(format: "Response: %@", JSON as! NSDictionary))
                                let status = (JSON as AnyObject).value(forKey:"status") as! String
                                if status == "True" {
                                    do {
                                        let dict: Login = try Login.init(dictionary: JSON as! [AnyHashable: Any])
                                        
                                        print(dict.response!.data)
                                        let restArray = dict.response!.data[0] as! NSDictionary
                                        UserDefaults.standard.set(restArray.value(forKey: "uid"), forKey: "UserId")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(restArray.value(forKey: "first_name"), forKey: "FirstName")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(restArray.value(forKey: "last_name"), forKey: "LastName")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(restArray.value(forKey: "email"), forKey: "Email")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(restArray.value(forKey: "phone"), forKey: "Phone")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(true, forKey: "USER_LOGGED_IN")
                                        UserDefaults.standard.synchronize()
                                    }
                                    catch let error as NSError {
                                        NSLog("Unresolved error \(error), \(error.userInfo)")
                                    }
                                    
                                    self.performSegue(withIdentifier: "LoggedIn", sender: self)
                                }
                                else
                                {
                                    let errorMsg = (JSON as AnyObject).value(forKey:"message") as! String
                                    self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
                                }
                            }
                    }
                    
                }
                else {
                    showAlertwithCancelButton("Error", message: "Invalid email id".localized(self.language!) as NSString, cancelButton: "OK".localized(self.language!) as NSString)
                }
            }
            else {
                if self.usernameField.text?.characters.count == 0 {
                    showAlertwithCancelButton("Error", message: "Please enter your username".localized(self.language!) as NSString, cancelButton: "OK".localized(self.language!) as NSString)
                }
                else if self.passwordField.text?.characters.count == 0 {
                    showAlertwithCancelButton("Error", message: "Please enter your password".localized(self.language!) as NSString, cancelButton: "OK".localized(self.language!) as NSString)
                }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UITEXTFIELD DELEGATE METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
