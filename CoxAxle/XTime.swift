//
//  XTime.swift
//  CoxAxle
//
//  Created by Prudhvi on 02/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class XTimeResponse: JSONModel {
    var Extctxt: String!
    var Extid: String!
    var Keyword: String!
    var Provider: String!
    var WebKey: String!
}

class XTime: JSONModel {
    var status: String!
    var message: String!
    var response: XTimeResponse?
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
