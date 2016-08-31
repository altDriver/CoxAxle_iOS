//
//  InsuranceCardTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 29/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class InsuranceCardTableViewCell: UITableViewCell {

    @IBOutlet var uploadInsuranceCardPictureButton: UIButton!
    
    @IBOutlet var thumbnailButtonFirst: UIButton!
   
    @IBOutlet var thumbnailButtonSecond: UIButton!
    
    @IBOutlet var thumbnailButtonThird: UIButton!
    
    @IBOutlet var thumbnailButtonFourth: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailButtonFirst.hidden  = true
        thumbnailButtonSecond.hidden = true
        thumbnailButtonThird.hidden  = true
        thumbnailButtonFourth.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
