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
        //Staging Local COX Live URL
      //  static let kBaseUrlPath = "http://192.168.8.101/ecommerce_crm/uatcoxapi/public/"
        
        //UAT Public COX Live URL
        static let kBaseUrlPath = "http://123.176.36.197/ecommerce_crm/uatcoxapi/public/"
    }
    
    struct Dealer {
        // Staging Dealer code
       // static let DealerCode = "KH002"
        
        // UAT COX Dealer Code
        static let DealerCode = "1000"
    }
    
    struct Platform {
        
        static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
            //return TARGET_IPHONE_SIMULATOR != 0 // Use this line in Xcode 6
        }
    }
    
    struct iPhoneScreen {
        static let Ratio = UIScreen.main.bounds.size.width/320.0
    }
    
}
