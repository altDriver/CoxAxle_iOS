//
//  InventorySearchPickerTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class InventorySearchPickerTableViewCell: UITableViewCell {

    @IBOutlet var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        pickerView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
