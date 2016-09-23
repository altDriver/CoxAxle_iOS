//
//  SaveSearch.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 22/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import JSONModel

class SaveSearchData: JSONModel {
   
    var search_name: String!
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class SaveSearchResponse: JSONModel {
   
    var data: SaveSearchData?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

class SaveSearch: JSONModel {
   
    var status: String!
    var message: String!
    var response: SaveSearchResponse?
    
    func propertyIsOptional(_ propertyName: String) -> Bool {
        return true
    }
}

