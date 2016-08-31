//
//  AddVehicleImageTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 25/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class AddVehicleImageTableViewCell: UITableViewCell {

    @IBOutlet var uploadVehiclePictureButton: UIButton!
    
    @IBOutlet var vehicleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
