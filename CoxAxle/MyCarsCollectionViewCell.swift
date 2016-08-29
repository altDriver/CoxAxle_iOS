//
//  MyCarsCollectionViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 09/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class MyCarsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var carImageView: UIImageView!
    
    @IBOutlet var carName: UILabel!
    
    @IBOutlet var carAppointmentDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
