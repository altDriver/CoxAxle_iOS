//
//  Logout.swift
//  CoxAxle
//
//  Created by Prudhvi on 26/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class Logout: JSONModel {
    var status: String!
    var message: String!
    var response: String?
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }

}
