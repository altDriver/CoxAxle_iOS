//
//  VehicleDetailsTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 11/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class VehicleDetailsTableViewCell: UITableViewCell {

    @IBOutlet var vehicleBannerCollectionView: UICollectionView!
    
    @IBOutlet var vehicleDetailsPageControl: UIPageControl!
    
    @IBOutlet var carNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
