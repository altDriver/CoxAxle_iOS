//
//  Settings.swift
//  CoxAxle
//
//  Created by Prudhvi on 19/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class SettingsResponse: JSONModel {
    var first_name: String!
    var last_name: String!
    var email: String!
    var phone: String!
    var language: String!
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}

class UserDetails: JSONModel {
    var status: String!
    var session_status: String!
    var message: String!
    var response: SettingsResponse?
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }

}
