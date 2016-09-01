//
//  Login.Swift
//  CoxAxle
//
//  Created by Prudhvi on 29/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel

class Data: JSONModel {
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
class Response: JSONModel {
     var data: NSArray = [Data()]


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
class Login: JSONModel {
    var status: String!
    var message: String!
    var response: Response?


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
