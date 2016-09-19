//
//  VehicleProgressTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 29/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import MSSimpleGauge

class VehicleProgressTableViewCell: UITableViewCell {
    
    @IBOutlet var monthsProgressView: UIView!
    @IBOutlet var milesProgressView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
