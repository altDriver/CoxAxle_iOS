//
//  VehicleProgressTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 29/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleProgressTableViewCell: UITableViewCell {

    @IBOutlet var monthsProgressView: KNCirclePercentView!
    @IBOutlet var milesProgressView: KNCirclePercentView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
