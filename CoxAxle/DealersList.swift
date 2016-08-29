//
//  DealersList.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class DealersListData: JSONModel {
    var address: String!
    var dealer_code: String!
    var dealer_fb_page_link: String!
    var dealer_twiter_page_link: String!
    var email: String!
    var id: String!
    var name: String!
    var phone: String!
}

class DealersListResponse: JSONModel {
    var data: NSArray = [DealersListData()]
    
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}

class DealersList: JSONModel {
    var status: String!
    var message: String!
    var response: DealersListResponse?
    
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }

}
