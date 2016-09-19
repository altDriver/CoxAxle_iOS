//
//  VehicleTypeTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 25/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleTypeTableViewCell: UITableViewCell {

    @IBOutlet var newVehicleButton : UIButton!
    @IBOutlet var usedVehicleButton: UIButton!
    @IBOutlet var CPOVehicleButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
