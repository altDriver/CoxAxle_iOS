//
//  VehicleInsuranceDetailsTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 29/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleInsuranceDetailsTableViewCell: UITableViewCell {

    @IBOutlet var insuranceExpirationDateButton: UIButton!
   
    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
