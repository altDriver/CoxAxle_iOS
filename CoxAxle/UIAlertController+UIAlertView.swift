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
    
    func showAlertwithCancelButton(_ title: NSString, message: NSString, cancelButton: NSString) -> Void {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: cancelButton as String, style: .default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func showAlertwithCancelButtonandOtherButton(_ title: NSString, message: NSString, cancelButton: NSString, otherButton: NSString) -> Void {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: cancelButton as String, style: .default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(defaultAction)
        
        let otherAction = UIAlertAction(title: otherButton as String, style: .default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(otherAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
}
