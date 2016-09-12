//
//  ForgotPasswordViewController.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 07/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import SMFloatingLabelTextField

class ForgotPasswordViewController: UIViewController, UIAlertController_UIAlertView {

    @IBOutlet var emailTextField: SMFloatingLabelTextField!
    
    @IBOutlet var resetPasswordButton: UIButton!
    
    var language: String?

    //MARK:- VIEW LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        emailTextField.layer.cornerRadius = 5
        self.setText()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT

    func setText() -> Void {
        
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        self.emailTextField.placeholder = "Email".localized(self.language!)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Email".localized(self.language!), attributes:[NSForegroundColorAttributeName: placeHolderColor])

        self.resetPasswordButton.setTitle("Reset Password".localized(self.language!), forState: UIControlState.Normal)
    }
    
    //MARK:- BUTTON ACTION METHODS
    
    @IBAction func backClicked(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func resetPasswordButtonClicked(sender: AnyObject) {
        
        self.callForgotPasswordAPI()
    }
    
    //MARK:- FORGOT PASSWORD API

    func callForgotPasswordAPI() -> Void {
        
        self.emailTextField.resignFirstResponder()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            if (self.emailTextField.text!.isValidEmail()) {
                
                let tracker = GAI.sharedInstance().defaultTracker
                let trackDictionary = GAIDictionaryBuilder.createEventWithCategory("API", action: "Forgot Password API Called", label: "Forgot Password", value: nil).build()
                tracker.send(trackDictionary as AnyObject as! [NSObject : AnyObject])
                
                let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
                self.view.addSubview(loading)
                
                let paramsDict: [ String : AnyObject] = ["email": self.emailTextField.text! as String] as Dictionary
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
                showAlertwithCancelButton("Error", message: "Invalid email address".localized(self.language!), cancelButton: "OK".localized(self.language!))
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
