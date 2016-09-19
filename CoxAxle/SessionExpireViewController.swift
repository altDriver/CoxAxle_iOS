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


class SessionExpireViewController: UIViewController, UITextFieldDelegate, UIAlertController_UIAlertView {

    @IBOutlet var sessionPasswordField: UITextField!
    var language: String?
    
    @IBOutlet var usernameLabel: UILabel!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        
        let username = UserDefaults.standard.object(forKey: "Email") as! String

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
         self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
    }
    
    
    //MARK:- REGENERATE SESSION API
    func reCreateSession() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            if self.sessionPasswordField.text?.characters.count > 0 {
                    
                    let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                    self.view.addSubview(loading)
                    let email = UserDefaults.standard.object(forKey: "Email") as! String
                    let passwordEncryption = self.sessionPasswordField.text?.encodeStringTo64()
                    
                    let paramsDict: [ String : String] = ["email": email, "password": passwordEncryption! as String] as Dictionary
                    print(NSString(format: "Request: %@", paramsDict))
                
                Alamofire.request(Constant.API.kBaseUrlPath+"customer", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                            loading.hide()
                            if let JSON = response.result.value {
                                
                                print(NSString(format: "Response: %@", JSON as! NSDictionary))
                                let status = (JSON as AnyObject).value(forKey: "status") as! String
                                if status == "True" {
                                    do {
                                        let dict: Login = try Login.init(dictionary: JSON as! [AnyHashable: Any])
                                        
                                        print(dict.response!.data)
                                        let restArray = dict.response!.data[0] as! NSDictionary
                                        print(restArray.value(forKey: "token"))
                                        UserDefaults.standard.set(restArray.value(forKey: "token"), forKey: "Token")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(restArray.value(forKey: "email"), forKey: "Email")
                                        UserDefaults.standard.synchronize()
                                        UserDefaults.standard.set(true, forKey: "USER_LOGGED_IN")
                                        UserDefaults.standard.synchronize()
                                        
                                    }
                                    catch let error as NSError {
                                        NSLog("Unresolved error \(error), \(error.userInfo)")
                                    }
                                    
                                    UserDefaults.standard.set(false, forKey: "SESSION_EXPIRED")
                                    UserDefaults.standard.synchronize()
                                    UserDefaults.standard.set(true, forKey: "CALL_API")
                                    UserDefaults.standard.synchronize()
                                    self.dismiss(animated: true, completion: nil)
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
                    showAlertwithCancelButton("Error", message: "Please enter your password".localized(self.language!) as NSString, cancelButton: "OK".localized(self.language!) as NSString)
            }
        }
        else {
            print("Internet connection FAILED")
            showAlertwithCancelButton("No Internet Connection".localized(self.language!) as NSString, message: "Make sure your device is connected to the internet.".localized(self.language!) as NSString, cancelButton: "OK".localized(self.language!) as NSString)
        }
    }
    
    //MARK:- UITEXTFIELD DELEGATE METHODS
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.reCreateSession()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
