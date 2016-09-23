//
//  DealerInfo.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class DealerBannerData: JSONModel {
    var banner: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class DealersInfoResponse: JSONModel {
    var name: String!
    var phone: String!
    var email: String!
    var dealer_twiter_page_link: String!
    var dealer_fb_page_link: String!
    var main_contact_number: String!
    var sale_contact: String!
    var service_desk_contact: String!
    var collision_desk_contact: String!
    var dealer_logo: String!
    var banner_image: NSArray = [DealerBannerData()]
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class DealerInfo: JSONModel {
   
    var status: String!
    var message: String!
    var session_status: String!
    var response: DealersInfoResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
