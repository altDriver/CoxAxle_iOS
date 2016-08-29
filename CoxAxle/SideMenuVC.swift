////
////  SideMenuVC.swift
////  CoxAxle
////
////  Created by Prudhvi on 21/07/16.
////  Copyright © 2016 Prudhvi. All rights reserved.
////
//
//import UIKit
//
//class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var sideMenuTbl: UITableView!
//    @IBOutlet weak var imgViewProfilePic: UIImageView!
//    @IBOutlet weak var lblProfileName: UILabel!
//    @IBOutlet weak var lblProfileAddrs: UILabel!
//    
//    let arrSideMenu: NSArray = ["Home","Notifications","Settings","My Garages","Dealer Services","ON Demand Services", "Dealership"]
//    
//    //MARK:- LIFE CYCLE METHODS
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//        
//        let headerView:UIView = self.view.viewWithTag(101)!
//        headerView.frame = CGRectMake(0, 0, sideMenuTbl.frame.size.width, 230)
//        self.sideMenuTbl.tableHeaderView = headerView
//        
//        imgViewProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
//        imgViewProfilePic.layer.borderWidth = CGFloat(1.5)
//        imgViewProfilePic.layer.cornerRadius = CGFloat(imgViewProfilePic.frame.size.width/2)
//        imgViewProfilePic.clipsToBounds = true
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SideMenuVC.imageTapped(_:)))
//        imgViewProfilePic.userInteractionEnabled = true
//        imgViewProfilePic.addGestureRecognizer(tapGestureRecognizer)
//        
//        sideMenuTbl.tableFooterView = UIView(frame: CGRectZero)
//        
//        lblProfileName.font = UIFont.regularFont()
//        lblProfileAddrs.font = UIFont.regularFont()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: UIBUTTON ACTIONS
//    func imageTapped(img: AnyObject)
//    {
//        // Your action
////        let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
////        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
////        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileVC")
////        self.navigationController?.pushViewController(vc, animated: true)
////        navigationVC.viewControllers = [vc]
////        self.frostedViewController.contentViewController = navigationVC
////        self.frostedViewController.hideMenuViewController()
//    }
//    
//    //MARK: UITABLEVIEW DATA SOURCE METHODS
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrSideMenu.count
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = self.sideMenuTbl.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath)
//        
//        let lblTitle:UILabel = cell.viewWithTag(102) as! UILabel
//        
//        lblTitle.text = arrSideMenu[indexPath.row] as? String
//        return cell
//        
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as! NavigationVC
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard .instantiateViewControllerWithIdentifier("HomeVC") as! LandingScreen
//        self.navigationController?.pushViewController(vc, animated: true)
//        navigationVC.viewControllers = [vc];
//        self.frostedViewController.contentViewController = navigationVC
//        self.frostedViewController.hideMenuViewController()
//        
//    }
//        
//}

//
//  SideMenuVC.swift
//  SideMenuSwiftDemo
//
//  Created by Kiran Patel on 1/2/16.
//  Copyright © 2016  SOTSYS175. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SideMenuVC: UIViewController, UIAlertController_UIAlertView {
    @IBOutlet var tableView: UITableView!
    
    let aData : NSArray = ["Home","Notifications","Settings", "My Garages", "Dealer Services", "On Road Services", "Dealership", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCellWithIdentifier(
            "kCell", forIndexPath: indexPath)
        let aLabel : UILabel = aCell.viewWithTag(10) as! UILabel
        aLabel.text = aData[indexPath.row] as? String
        aLabel.textColor = UIColor.BlackColor()
        return aCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 2:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            constantObj.SetMainViewController("Settings")
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
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            constantObj.SetIntialMainViewController("HomeVC")
            break
        }
        
    }
    
    //MARK:- LOGOUT API
    func  callLogoutAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            constantObj.SetIntialMainViewController("HomeVC")
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let token: String = NSUserDefaults.standardUserDefaults().objectForKey("Token") as! String
            let paramsDict: [ String : AnyObject] = ["uid": "21", "token": token] as Dictionary
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
            showAlertwithCancelButton("No Internet Connection", message: "Make sure your device is connected to the internet.", cancelButton: "OK")
        }
    }
}

