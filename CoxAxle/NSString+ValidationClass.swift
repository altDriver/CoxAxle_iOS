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
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,10}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func convertDateToString() -> String {
        //String to Date Convert
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: dateString)
        
        
        //CONVERT FROM NSDate to String
        
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let stringDate = dateFormatter.string(from: dateObj!)
        print(stringDate)
        
        return stringDate
    }
    
    func convertStringToDate() -> String {
        
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: dateObj!)
        print(stringDate)
        
        return stringDate
    }
    
    func convertDate() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: dateString)
        
        
        dateFormatter.dateFormat = "MMM dd, YYYY HH:mm a"
        let stringDate = dateFormatter.string(from: dateObj!)
        print(stringDate)
        
        return stringDate
    }
    
    func encodeStringTo64() -> String {
        let plainData: Foundation.Data = self.data(using: String.Encoding.utf8)!
        var base64String: String
        base64String = plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        return base64String
    }
}
