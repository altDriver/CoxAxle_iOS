//
//  Constants.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
let appDelegate = UIApplication.shared.delegate as! AppDelegate
struct Constant {
    
    //MARK:- BASE URL
    struct API {
        // Local Base URL
        static let kBaseUrlPath = "http://192.168.8.101/ecommerce_crm/coxaxle_api/public/"
        
        //UAT Base URL
       // static let kBaseUrlPath = "http://123.176.36.197/ecommerce_crm/coxaxle_api/public/"
    }
    
    struct iPhoneScreen {
        static let Ratio = UIScreen.main.bounds.size.width/320.0
    }
    
}
