//
//  Constants.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
struct Constant {
    
    //MARK:- BASE URL
    struct API {
        static let kBaseUrlPath = "http://192.168.8.101/ecommerce_crm/coxaxle_api/public/"
    }
    
    struct iPhoneScreen {
        static let Ratio = UIScreen.mainScreen().bounds.size.width/320.0
    }
    
}
