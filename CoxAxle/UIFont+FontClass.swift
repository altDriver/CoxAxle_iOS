//
//  UIFont+FontClass.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    //MARK:- REGULAR FONT
    class func regularFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 20.0)!
    }
    
    //MARK:- BOLD FONT
    class func boldFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: 20.0)!
    }
    
    //MARK:- ITALIC FONT
    class func italicFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: 17.0)!
    }
    
    //MARK:- LIGHT FONT
    class func lightFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 17.0)!
    }
    
}