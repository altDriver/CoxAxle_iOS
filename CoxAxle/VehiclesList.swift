//
//  VehiclesList.h
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel
class VehiclesListResponse: JSONModel {
    var dealer_id: String!
    var extended_waranty_from: String!
    var extended_waranty_to: String!
    var hypothecate: String!
    var id: String!
    var mileage: String!
    var style: String!
    var tag_renewal_date: String!
    var trim: String!
    var user_id: String!
    var vehicle_color: String!
    var vehicle_emi: String!
    var vehicle_extended_waranty_from: String!
    var vehicle_extended_waranty_to: String!
    var vehicle_id: String!
    var vehicle_insurance_document: String!
    var vehicle_interest: String!
    var vehicle_kbb_price: String!
    var vehicle_loan_amount: String!
    var vehicle_loan_tenure: String!
    var vehicle_make: String!
    var vehicle_manual: String!
    var vehicle_model: String!
    var vehicle_name: String!
    var vehicle_photo: String!
    var vehicle_vin: String!
    var vehicle_waranty_from: String!
    var vehicle_waranty_to: String!
    var vehicle_year: String!


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
class VehiclesList: JSONModel {
    var status: String!
    var session_status: String!
    var message: String!
    var response: VehiclesListResponse?


    func propertyIsOptional(propertyName: String) -> Bool {
        return true
    }
}
//
//  VehiclesList.m
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//