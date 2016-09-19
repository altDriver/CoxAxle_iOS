//
//  VehiclesList.h
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//
import UIKit
import JSONModel

class VehiclesImages: JSONModel {
    
    var image_url: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class VehiclesListData: JSONModel {
    var dealer_id: String!
    var waranty_from: String!
    var waranty_to: String!
    var hypothecate: String!
    var id: String!
    var mileage: String!
    var style: String!
    var tag_renewal_date: String!
    var trim: String!
    var user_id: String!
    var color: String!
    var emi: String!
    var extended_waranty_from: String!
    var extended_waranty_to: String!
    var vehicle_id: String!
    var insurance_document: String!
    var interest: String!
    var kbb_price: String!
    var loan_amount: String!
    var loan_tenure: String!
    var make: String!
    var manual: String!
    var model: String!
    var vehicle_name: String!
    var vehicle_photo: String!
    var vin: String!
    var vehicle_waranty_from: String!
    var vehicle_waranty_to: String!
    var year: String!
    var date_entered: String!
    var date_modified: String!
    var deleted: String!
    var name: String!
    var vehicle_type: String!
    var vechicle_image: NSArray = [VehiclesImages()]

    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class VehiclesListResponse: JSONModel {
    var data: NSArray = [VehiclesListData()]
    
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class VehiclesList: JSONModel {
    var status: String!
    var message: String!
    var response: VehiclesListResponse?


    func propertyIsOptional(_ propertyName: String) -> Bool {
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
