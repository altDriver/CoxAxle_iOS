//
//  StringExtension.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation


extension String {
    
    //MARK:- LOCALISATION METHOD
    func localized(_ lang:String) -> String {
        
        
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
    
}
