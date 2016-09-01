//
//  Register.Swift
//  CoxAxle
//
//  Created by Prudhvi on 01/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel

class RegisterData: JSONModel {
    var uid: String!
    var first_name: String!
    var last_name: String!
    var email: String!
    var phone: String!
    var dealer_code: String!
    var zip_code: String!
    var language: String!


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
class RegisterResponse: JSONModel {
    var data: NSArray = [RegisterData()]


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
class Register: JSONModel {
    var status: String!
    var message: String!
    var response: RegisterResponse?


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}