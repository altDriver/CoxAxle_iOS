//
//  VehicleDetailTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 25/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class VehicleDetailTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var vehicleNameTextField: UITextField!
    
    @IBOutlet var vinTextField: UITextField!
    
    @IBOutlet var milesDrivenTextField: UITextField!
    
    @IBOutlet var findMyVinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- UITEXTFIELD DELEGATE METHODS
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return prospectiveText.containsOnlyCharactersIn("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") && prospectiveText.characters.count <= 16
            
        case 2:
            
            if textField.text?.characters.count >= 8 && range.length == 0 {
                return false
            } else {
                
                let newCharacters = CharacterSet(charactersIn: string)
                let shouldChangeCharactersInRange = CharacterSet.decimalDigits.isSuperset(of: newCharacters)
                
                return shouldChangeCharactersInRange
            }
            
        default:
            return true
        }
        
    }
    
}

extension String {
    
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}
