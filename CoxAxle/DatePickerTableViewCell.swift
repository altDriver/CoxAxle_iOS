//
//  DatePickerTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 30/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet var insuranceDatePicker: UIDatePicker!
    
    @IBOutlet var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if  let datePicker = insuranceDatePicker {
            
            datePicker.datePickerMode = UIDatePickerMode.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
