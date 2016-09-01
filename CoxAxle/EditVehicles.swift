//
//  EditVehicles.swift
//  CoxAxle
//
//  Created by Prudhvi on 18/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel
//class EditVehiclesResponse: JSONModel {
//    func propertyIsOptional(propertyName: String) -> Bool {
//        return true
//    }
//}

class EditVehicles: JSONModel {
    var status: String!
    var message: String!
    var response: String?
    
    
    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }

}
