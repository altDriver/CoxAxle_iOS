//
//  NSString+ValidationClass.swift
//  CoxAxle
//
//  Created by Prudhvi on 27/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func encodeStringTo64() -> String {
        let plainData: NSData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var base64String: String
        base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        return base64String
    }
}
