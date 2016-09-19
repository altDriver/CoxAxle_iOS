//
//  SideMenuVC.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class SideMenuVC: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView {

     let MenuReuseIdentifier = "MenuCell"
    @IBOutlet weak var sideMenuTbl: UITableView!
    
    let menuArray: NSArray = ["Home","My Cars","Service","Roadside Assistance","Accident Help","Car Shopping", "Contact Dealership", "Settings"]
    var logoImage: [UIImage] = [
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "callIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "searchCarsIcon")!
    ]
    
    var oldPassword: String?
    var newPassword: String?
    var confirmNewPassword: String?
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "SideMenuVC"
        // Do any additional setup after loading the view.
        
        sideMenuTbl.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIBUTTON ACTIONS

    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard .instantiateViewController(withIdentifier: "SocialContent") as! WebViewController
        vc.webViewUrl = "https://www.facebook.com/VensaiTechnologies"
        self.navigationController?.pushViewController(vc, animated: true)
        navigationVC.viewControllers = [vc];
        self.frostedViewController.contentViewController = navigationVC
        self.frostedViewController.hideMenuViewController()
        
    }
    
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
        let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard .instantiateViewController(withIdentifier: "SocialContent") as! WebViewController
        vc.webViewUrl = "https://twitter.com/vensaiinc"
        self.navigationController?.pushViewController(vc, animated: true)
        navigationVC.viewControllers = [vc];
        self.frostedViewController.contentViewController = navigationVC
        self.frostedViewController.hideMenuViewController()
    }
    
    
    //MARK: UITABLEVIEW DATA SOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.sideMenuTbl.dequeueReusableCell(withIdentifier: MenuReuseIdentifier, for: indexPath) as UITableViewCell
        
        let lblTitle:UILabel = cell.viewWithTag(701) as! UILabel
        let cellImageView = cell.viewWithTag(702) as! UIImageView
        
        lblTitle.text = menuArray[(indexPath as NSIndexPath).row] as? String
        cellImageView.image = logoImage[(indexPath as NSIndexPath).row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).row {
        case 0:
            let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewController(withIdentifier: "HomeVC") as! LandingScreen
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        case 1:
            let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewController(withIdentifier: "VehiclesList") as! VehiclesViewController
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
       // case 8:
            //        case 2:
            //            let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
            //
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard .instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            navigationVC.viewControllers = [vc];
            //            self.frostedViewController.contentViewController = navigationVC
            //            self.frostedViewController.hideMenuViewController()
        //            break
//        case 7:
//            
//            let alertController = UIAlertController(title: "Change Password", message: "", preferredStyle: .Alert)
//            
//            let changePasswordAction = UIAlertAction(title: "Change", style: UIAlertActionStyle.Default, handler: {
//                alert -> Void in
//                
//                let oldPasswordtextField = alertController.textFields![0] as UITextField
//                let newPasswordTextField = alertController.textFields![1] as UITextField
//                let confirmNewPasswordTextField = alertController.textFields![2] as UITextField
//                
//                self.oldPassword = oldPasswordtextField.text
//                self.newPassword = newPasswordTextField.text
//                self.confirmNewPassword = confirmNewPasswordTextField.text
//                
//                if self.newPassword! != self.confirmNewPassword! {
//                    
//                    self.showAlertwithCancelButton("Error", message: "Passwords do not match", cancelButton: "OK")
//                    return
//                } else {
//                    self.callChangePasswordAPI(self.oldPassword!, newPassword: self.newPassword!)
//                }
//                
//            })
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
//                (action : UIAlertAction!) -> Void in
//                
//            })
//            
//            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//                textField.secureTextEntry = true
//                textField.placeholder = "Enter current password"
//            }
//            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//                textField.secureTextEntry = true
//                textField.placeholder = "Enter new password"
//            }
//            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
//                textField.secureTextEntry = true
//                textField.placeholder = "Confirm new password"
//            }
//            
//            alertController.addAction(changePasswordAction)
//            alertController.addAction(cancelAction)
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.presentViewController(alertController, animated: true, completion: nil)
//            })
//            break
//        case 8:
//            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
//                self.callLogoutAPI()
//            })
//            alertController.addAction(defaultAction)
//            
//            let otherAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
//            })
//            alertController.addAction(otherAction)
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.presentViewController(alertController, animated: true, completion: nil)
//            })
//            
//            break
        default:
            DispatchQueue.main.async(execute: {
                self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
            })
            break
        }
        
    }
    
    //MARK:- LOGOUT API
    func  callLogoutAPI() -> Void {
//        if Reachability.isConnectedToNetwork() == true {
//            print("Internet connection OK")
//            
//            let tracker = GAI.sharedInstance().defaultTracker
//            let trackDictionary = GAIDictionaryBuilder.createEventWithCategory("API", action: "Logout API Called", label: "Logout", value: nil).build()
//            tracker.send(trackDictionary as AnyObject as! [NSObject : AnyObject])
//            
//            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
//            self.view.addSubview(loading)
//             let userId: String = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as! String
//            let paramsDict: [ String : AnyObject] = ["uid": userId] as Dictionary
//            print(NSString(format: "Request: %@", paramsDict))
//            
//            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"customer/logout", parameters: paramsDict)
//                .responseJSON { response in
//                    loading.hide()
//                    if let JSON = response.result.value {
//                        
//                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
//                        let status = JSON.valueForKey("status") as! String
//                        if status == "True"  {
//                            do {
//                                let dict: Logout = try Logout(dictionary: JSON as! [NSObject : AnyObject])
//                                
//                                print(dict.message)
        
                                UserDefaults.standard.set(false, forKey: "USER_LOGGED_IN")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(false, forKey: "SHOW_INTRODUCTORY")
                                UserDefaults.standard.synchronize()
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.LoginView()
//                            }
//                            catch let error as NSError {
//                                NSLog("Unresolved error \(error), \(error.userInfo)")
//                            }
//                        }
//                        else {
//                            let errorMsg = JSON.valueForKey("message") as! String
//                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
//                        }
//                    }
//            }
//        }
//        else {
//            print("Internet connection FAILED")
//            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
//            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
//        }
    }
    
    //MARK:- CHANGE PASSWORD API
    func callChangePasswordAPI(_ oldPassword: String, newPassword: String) -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Change Password API Called", label: "Change Password", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let userId = UserDefaults.standard.object(forKey: "UserId") as? String
            
            let paramsDict: [ String : String] = ["uid": userId!,
                                                     "old_password":oldPassword,
                                                     "new_password": newPassword] as Dictionary
            
            Alamofire.request(Constant.API.kBaseUrlPath+"customer/updatepwd", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            
                            self.showAlertwithCancelButton("Password Changed", message: "Your password has been changed successfully", cancelButton: "OK")
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

    
}
