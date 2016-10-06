//
//  SideMenuVC.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class SideMenuVC: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView {

     let MenuReuseIdentifier = "MenuCell"
    @IBOutlet weak var sideMenuTbl: UITableView!
    
    let menuArray: NSArray = ["Home","My Cars","Service","Roadside Assistance","Car Shopping", "Contact Dealership", "Settings"]
    var logoImage: [UIImage] = [
        UIImage(named: "fill2")!,
        UIImage(named: "group9")!,
        UIImage(named: "noun12674Cc")!,
        UIImage(named: "flatTire")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "sidecallIcon")!,
        UIImage(named: "noun539837Cc")!
    ]
    
    var oldPassword: String?
    var newPassword: String?
    var confirmNewPassword: String?
    
    @IBOutlet var logoImageView: UIImageView!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "SideMenuVC"
        // Do any additional setup after loading the view.
        
        let imageURLString = UserDefaults.standard.object(forKey: "Dealer_Logo") as! NSString
        self.logoImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: nil, options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        sideMenuTbl.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIBUTTON ACTIONS

    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        
        let facebook = UserDefaults.standard.object(forKey: "Dealer_FB") as! String
        if UIApplication.shared.canOpenURL(NSURL(string: facebook)! as URL) {
            UIApplication.shared.openURL(NSURL(string: facebook)! as URL)
        } else {
            UIApplication.shared.openURL(NSURL(string: facebook)! as URL)
        }
        
//        let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard .instantiateViewController(withIdentifier: "SocialContent") as! WebViewController
//        vc.webViewUrl = "https://www.facebook.com/VensaiTechnologies"
//        self.navigationController?.pushViewController(vc, animated: true)
//        navigationVC.viewControllers = [vc];
//        self.frostedViewController.contentViewController = navigationVC
//        self.frostedViewController.hideMenuViewController()
        
    }
    
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
        
        let twitterURL = UserDefaults.standard.object(forKey: "Dealer_TW") as! String
        
        if UIApplication.shared.canOpenURL(NSURL(string: twitterURL)! as URL) {
            UIApplication.shared.openURL(NSURL(string: twitterURL)! as URL)
        } else {
            UIApplication.shared.openURL(NSURL(string: twitterURL)! as URL)
        }
        
//        let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard .instantiateViewController(withIdentifier: "SocialContent") as! WebViewController
//        vc.webViewUrl = "https://twitter.com/vensaiinc"
//        self.navigationController?.pushViewController(vc, animated: true)
//        navigationVC.viewControllers = [vc];
//        self.frostedViewController.contentViewController = navigationVC
//        self.frostedViewController.hideMenuViewController()
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
        case 2:
            let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewController(withIdentifier: "VehiclesList") as! VehiclesViewController
            vc.fromXTime = true
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        case 3:
            var phoneNumber = UserDefaults.standard.object(forKey: "Dealer_Collision") as! String
            phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            let phoneUrl: URL = URL(string: "telprompt:\(phoneNumber)")!
            if UIApplication.shared.canOpenURL(phoneUrl) {
                UIApplication.shared.openURL(phoneUrl)
            }
            else {
                self.showAlertwithCancelButton("Error", message: "Call facility is not available!!!", cancelButton: "OK")
            }
            break
        case 4:
            let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewController(withIdentifier: "CarShopping") as! CarShoppingViewController
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        case 5:
            let alertController = UIAlertController(title: "CoxAxle", message: "Call Dealer", preferredStyle: .actionSheet)
            
            let main = UserDefaults.standard.object(forKey: "Dealer_Main") as! String
            let mainNumber = String(format: "Main: %@", main)
            let mainAction = UIAlertAction(title: mainNumber, style: .default, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.callNumber(phoneNumber: mainNumber)
                }
            })
            alertController.addAction(mainAction)
            
            let sales = UserDefaults.standard.object(forKey: "Dealer_Sales") as! String
            let saleNumber = String(format: "Sales: %@", sales)
            let saleAction = UIAlertAction(title: saleNumber, style: .default, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.callNumber(phoneNumber: saleNumber)
                }
            })
            alertController.addAction(saleAction)
            
            let service = UserDefaults.standard.object(forKey: "Dealer_Services") as! String
            let serviceNumber = String(format: "Service: %@", service)
            let serviceAction = UIAlertAction(title: serviceNumber, style: .default, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.callNumber(phoneNumber: serviceNumber)
                }
            })
            alertController.addAction(serviceAction)
            
            let collision = UserDefaults.standard.object(forKey: "Dealer_Collision") as! String
            let collisionNumber = String(format: "Collision: %@", collision)
            let collisionAction = UIAlertAction(title: collisionNumber, style: .default, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.callNumber(phoneNumber: collisionNumber)
                }
            })
            alertController.addAction(collisionAction)
            
            let otherAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            })
            alertController.addAction(otherAction)
            
            DispatchQueue.main.async(execute: {
                self.present(alertController, animated: true, completion: nil)
            })

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
           // DispatchQueue.main.async(execute: {
                self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
            //})
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
                                                     "new_password": newPassword, "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            
            Alamofire.request(Constant.API.kBaseUrlPath+"customer/updatepwd", method: .post, parameters: paramsDict).responseJSON
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
    
    //CALL
    func callNumber(phoneNumber: String) -> Void {
        var phoneNumber = phoneNumber
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "Main:", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "Sales:", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "Service:", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "Collision:", with: "")
        
        let phoneUrl: URL = URL(string: "telprompt:\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.openURL(phoneUrl)
        }
        else {
            self.showAlertwithCancelButton("Error", message: "Call facility is not available!!!", cancelButton: "OK")
        }
    }


    
}
