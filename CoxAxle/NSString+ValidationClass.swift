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
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func isValidPhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingType.PhoneNumber.rawValue)
            let matches = detector.matchesInString(self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .PhoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func convertDateToString() -> String {
        //String to Date Convert
        
        let dateString = self
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.dateFromString(dateString)
        
        
        //CONVERT FROM NSDate to String
        
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        let stringDate = dateFormatter.stringFromDate(dateObj!)
        print(stringDate)
        
        return stringDate
    }
    
    func encodeStringTo64() -> String {
        let plainData: NSData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var base64String: String
        base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        return base64String
    }
}
