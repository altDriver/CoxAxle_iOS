//
//  FavoriteCars.swift
//  CoxAxle
//
//  Created by Prudhvi on 23/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class FavoriteCarsData: JSONModel {
   
    var image_url: String!
    var miles: String!
    var price: String!
    var sub_model: String!
    var vehicle_name: String!
    var vehicle_type: String!
    var year: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }

}

class FavouriteCarsResponse: JSONModel {
    
    var data: NSArray = [FavoriteCarsData()]
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class FavoriteCars: JSONModel {
    var status: String!
    var message: String!
    var response: FavouriteCarsResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
