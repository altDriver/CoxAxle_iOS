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
    
    let menuArray: NSArray = ["Home","Notifications","Settings","My Cars","Dealer Services","ON Demand Services", "Dealership", "Logout"]
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "SideMenuVC"
        // Do any additional setup after loading the view.
        
        sideMenuTbl.tableFooterView = UIView(frame: CGRectZero)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIBUTTON ACTIONS

    @IBAction func facebookButtonClicked(sender: UIButton) {
       /* let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard .instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        navigationVC.viewControllers = [vc];
        self.frostedViewController.contentViewController = navigationVC
        self.frostedViewController.hideMenuViewController()*/
    }
    
    @IBAction func twitterButtonClicked(sender: UIButton) {
    /*    let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard .instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        navigationVC.viewControllers = [vc];
        self.frostedViewController.contentViewController = navigationVC
        self.frostedViewController.hideMenuViewController()*/
    }
    
    
    //MARK: UITABLEVIEW DATA SOURCE METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.sideMenuTbl.dequeueReusableCellWithIdentifier(MenuReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let lblTitle:UILabel = cell.viewWithTag(701) as! UILabel
        
        lblTitle.text = menuArray[indexPath.row] as? String
        
        switch indexPath.row {
        case 7:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 2:
            let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        case 3:
            let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewControllerWithIdentifier("VehiclesList") as! VehiclesViewController
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        case 7:
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                self.callLogoutAPI()
            })
            alertController.addAction(defaultAction)
            
            let otherAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            })
            alertController.addAction(otherAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
            break
        default:
            let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard .instantiateViewControllerWithIdentifier("HomeVC") as! LandingScreen
            self.navigationController?.pushViewController(vc, animated: true)
            navigationVC.viewControllers = [vc];
            self.frostedViewController.contentViewController = navigationVC
            self.frostedViewController.hideMenuViewController()
            break
        }
        
    }
    
    //MARK:- LOGOUT API
    func  callLogoutAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let paramsDict: [ String : AnyObject] = ["uid": "21"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"customer/logout", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: Logout = try Logout(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict.message)
                                
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "USER_LOGGED_IN")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "SHOW_INTRODUCTORY")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.LoginView()
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        else {
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