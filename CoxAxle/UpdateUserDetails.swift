//
//  UpdateUserDetails.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class UpdateUserDetails: JSONModel {
    var status: String!
    var session_status: String!
    var message: String!
    var response: String?
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }

}
