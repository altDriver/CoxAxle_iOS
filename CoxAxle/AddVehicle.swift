//
//  AddVehicle.Swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel
class AddVehicleResponse: JSONModel {


    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
class AddVehicle: JSONModel {
    var status: String!
    var message: String!
    //var response: AddVehicleResponse?


    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
