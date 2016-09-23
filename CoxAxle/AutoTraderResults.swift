//
//  AutoTraderResults.swift
//  CoxAxle
//
//  Created by Prudhvi on 19/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class BodyStylesData: JSONModel {
    var code: String!
    var name: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class StylesData: JSONModel {
    
    var code: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }

}

class TrimData: JSONModel {
    
    var code: String!
    var vehicle_description: String!
    var name: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
    
    override class func keyMapper() -> JSONKeyMapper {
        return JSONKeyMapper(modelToJSONDictionary: ["vehicle_description": "description"])
    }

}

class AutoTraderResultsData: JSONModel {
    
    var bodyStyles: NSArray = [BodyStylesData()]
    var derivedPrice: String!
    var styles: NSArray = [StylesData()]
    var trim: TrimData?
    var make: String!
    var year: String!
    var primaryPrice: String!
    var salePrice: String!
    var images: String!
    var listingType: String!
    var mileage: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class AutoTraderResultsResponse: JSONModel {
    var data: NSArray = [AutoTraderResultsData()]
    
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class AutoTraderResults: JSONModel {
    var status: String!
    var message: String!
    var response: AutoTraderResultsResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
