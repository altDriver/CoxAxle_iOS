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
import SDWebImage

class CreateAccount: GAITrackedViewController, UIAlertController_UIAlertView{
    
    @IBOutlet var firstNameField: SMFloatingLabelTextField!
    
    @IBOutlet var lastNameField: SMFloatingLabelTextField!
    
    @IBOutlet var emailField: SMFloatingLabelTextField!
    
    @IBOutlet var passwordField: SMFloatingLabelTextField!
    var language: String?
    var logoImage: String?
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var phoneNumberField: SMFloatingLabelTextField!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        self.screenName = "CreateAccount"
        self.setText()
        
         self.logoImageView.setImageWith(URL(string: logoImage!), placeholderImage: nil, options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        self.title = "Register".localized(self.language!)
        
    }
    
    // MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func registerClicked(_ sender: UIButton) {
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
            if (self.passwordField.text!.isValidPassword()) {
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
            else {
                self.showAlertwithCancelButton("Error", message: "Password should be minimum 6 characters and maxmimum 10 characters length with one alphabet and one number", cancelButton: "OK")
            }
        }
        
    }
    
    
    // MARK:- REGISTERATION API
    
    func callRegisterationAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Registration API Called", label: "Registration", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let passwordEncryption = self.passwordField.text?.encodeStringTo64()
            let deviceType = UIDevice.current.modelName
            let deviceVersion = UIDevice.current.iOSVersion
            let model = String(format: "%@,%@", deviceType,deviceVersion)
            
            let deviceToken = UserDefaults.standard.object(forKey: "Device_Token") as! String
            
             let paramsDict: [String : String] = ["first_name": self.firstNameField.text! as String, "last_name": self.lastNameField.text! as String, "password": passwordEncryption! as String, "email": self.emailField.text! as String, "phone": self.phoneNumberField.text! as String, "dealer_code": Constant.Dealer.DealerCode, "device_token": deviceToken, "device_type": "iOS", "os_version": model] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))

            
            Alamofire.request(Constant.API.kBaseUrlPath+"register", method: .post, parameters: paramsDict).responseJSON
                { response in
                
                loading.hide()
                    
                    if let JSON = response.result.value {
                        
                    print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                    if status == "True" {
                        do {
                            let dict: Register = try Register(dictionary: JSON as! [AnyHashable: Any])
                            
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
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LoggedIn", sender: self)
                        }
                       
                    }
                    else
                    {
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
}
