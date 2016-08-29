//
//  UIAlertController+UIAlertView.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
import UIKit

protocol UIAlertController_UIAlertView {}

extension UIAlertController_UIAlertView where Self: UIViewController {
    
    func showAlertwithCancelButton(title: NSString, message: NSString, cancelButton: NSString) -> Void {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: cancelButton as String, style: .Default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(defaultAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func showAlertwithCancelButtonandOtherButton(title: NSString, message: NSString, cancelButton: NSString, otherButton: NSString) -> Void {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: cancelButton as String, style: .Default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(defaultAction)
        
        let otherAction = UIAlertAction(title: otherButton as String, style: .Default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(otherAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
}