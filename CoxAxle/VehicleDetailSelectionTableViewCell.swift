//
//  VehicleDetailSelectionTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 25/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleDetailSelectionTableViewCell: UITableViewCell {

    @IBOutlet var selectYearButton: UIButton!
    
    @IBOutlet var selectVehicleMakeButton: UIButton!
    
    @IBOutlet var selectVehicleModelButton: UIButton!
   
//    @IBOutlet var selectTagExpirationButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
