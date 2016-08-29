//
//  Constants.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
let sideMenuVC = KSideMenuVC()
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
struct Constant {
    
     let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    //MARK:- BASE URL
    struct API {
        static let kBaseUrlPath = "http://192.168.8.101/ecommerce_crm/coxaxle_api/public/"
    }
    
    struct iPhoneScreen {
        static let Ratio = UIScreen.mainScreen().bounds.size.width/320.0
    }
    
    func SetIntialMainViewController(aStoryBoardID: String)->(KSideMenuVC){
        let sideMenuObj = mainStoryboard.instantiateViewControllerWithIdentifier("sideMenuID")
        let mainVcObj = mainStoryboard.instantiateViewControllerWithIdentifier(aStoryBoardID)
        let navigationController : UINavigationController = UINavigationController(rootViewController: mainVcObj)
        navigationController.navigationBarHidden = true
        navigationController.navigationBar.barTintColor = UIColor.SlateColor()
        navigationController.navigationBar.tintColor = UIColor.WhiteColor()
        sideMenuVC.view.frame = UIScreen.mainScreen().bounds
        sideMenuVC.setMainViewController(navigationController)
        sideMenuVC.setMenuViewController(sideMenuObj)
        return sideMenuVC
    }
    func SetMainViewController(aStoryBoardID: String)->(KSideMenuVC){
        let mainVcObj = mainStoryboard.instantiateViewControllerWithIdentifier(aStoryBoardID)
        let navigationController : UINavigationController = UINavigationController(rootViewController: mainVcObj)
        navigationController.navigationBarHidden = false
        navigationController.navigationBar.barTintColor = UIColor.SlateColor()
        navigationController.navigationBar.tintColor = UIColor.WhiteColor()
        sideMenuVC.view.frame = UIScreen.mainScreen().bounds
        sideMenuVC.setMainViewController(navigationController)
        return sideMenuVC
    }

    
}
