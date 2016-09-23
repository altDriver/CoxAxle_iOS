//
//  InventoryResultsCollectionViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 12/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class InventoryResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var vehicleImageView: UIImageView!
    @IBOutlet var vehicleType: UILabel!
    @IBOutlet var vehicleModel: UILabel!
    @IBOutlet var vehiclePrice: UILabel!
    @IBOutlet var vehicleMiles: UILabel!
    @IBOutlet var vehicleImageViewHeight: NSLayoutConstraint!
    @IBOutlet var vehicleNameTopConstraint: NSLayoutConstraint!
}
