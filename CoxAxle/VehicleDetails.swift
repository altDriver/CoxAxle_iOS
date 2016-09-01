//
//  VehicleDetails.Swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel
class VehicleDetailsResponse: JSONModel {
    var id: String!
    var date_entered: String!
    var date_modified: String!
    var deleted: String!
    var name: String!
    var user_id: String!
    var dealer_id: String!
    var vin: String!
    var vehicle_type: String!
    var make: String!
    var model: String!
    var year: String!
    var color: String!
    var photo: String!
    var waranty_from: String!
    var waranty_to: String!
    var extended_waranty_from: String!
    var extended_waranty_to: String!
    var kbb_price: String!
    var manual: String!
    var loan_amount: String!
    var emi: String!
    var interest: String!
    var loan_tenure: String!
    var insurance_document: String!


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
class VehicleDetails: JSONModel {
    var status: String!
    var message: String!
    var response: VehicleDetailsResponse?


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}