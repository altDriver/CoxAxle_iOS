//
//  SavedSearchesList.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class SavedSearchesData: JSONModel {
    
    var name: String!
    var date: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class SavedSearchesResponse: JSONModel {
     var data: NSArray = [SavedSearchesData()]
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class SavedSearchesList: JSONModel {
    var status: String!
    var message: String!
    var response: SavedSearchesResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }

}
