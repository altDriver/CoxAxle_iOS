//
//  VehicleDetailTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 25/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleDetailTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var vehicleNameTextField: UITextField!
    
    @IBOutlet var vinTextField: UITextField!
    
    @IBOutlet var milesDrivenTextField: UITextField!
    
    @IBOutlet var findMyVinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- UITEXTFIELD DELEGATE METHODS
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 0:
            
            if textField.text?.characters.count >= 20 && range.length == 0 {
                return false
            } else {
                return true
            }
            
        case 1:
            
            if string.characters.count == 0 {
                return true
            }
            
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            return prospectiveText.containsOnlyCharactersIn("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") && prospectiveText.characters.count <= 16
            
        case 2:
            
            if textField.text?.characters.count >= 8 && range.length == 0 {
                return false
            } else {
                
                let newCharacters = NSCharacterSet(charactersInString: string)
                let shouldChangeCharactersInRange = NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
                
                return shouldChangeCharactersInRange
            }
            
        default:
            return true
        }
        
    }
    
}

extension String {
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
}