//
//  AutoTraderSearchFilters.swift
//  CoxAxle
//
//  Created by Prudhvi on 08/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class Models: JSONModel {
    var code: String!
    var name: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class MakesArray: JSONModel {
    var code: String!
    var models: NSArray = [Models()]
    var name: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class EngineGroups: JSONModel {
    var code: String!
    var displayOrder: String!
    var name: String!
    var shortName: String!
    
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class ExtColorGroups: JSONModel {
    var code: String!
    var name: String!
    var rgbHex: String!
    var shortName: String!
    
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class IntColorGroups: JSONModel {
    var code: String!
    var name: String!
    var rgbHex: String!
    var shortName: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class Styles: JSONModel {
    var code: String!
    var displayOrder: String!
    var name: String!
    var priority: String!
    var shortName: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class Years: JSONModel {
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class SearchFiltersResponse: JSONModel {
    var makes: NSArray = [MakesArray()]
    var engineGroups: NSArray = [EngineGroups()]
    var extColorGroups: NSArray = [ExtColorGroups()]
    var intColorGroups: NSArray = [IntColorGroups()]
    var styles: NSArray = [Styles()]
    var years: NSArray = [Years()]
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class AutoTraderSearchFilters: JSONModel {
    var status: String!
    var message: String!
    var response: SearchFiltersResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}
