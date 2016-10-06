//
//  PriceRangeTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import TTRangeSlider

class PriceRangeTableViewCell: UITableViewCell {
    
    @IBOutlet var rangeSliderCustom: TTRangeSlider!
    
    @IBOutlet var sliderTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rangeSliderCustom.minLabelColour = UIColor.SlateColor()
        rangeSliderCustom.maxLabelColour = UIColor.SlateColor()
        rangeSliderCustom.minLabelFont = UIFont.regularFont().withSize(10)
        rangeSliderCustom.maxLabelFont = UIFont.regularFont().withSize(10)
        
        //rangeSliderCustom.handleImage = UIImage(named: "downArrow")
        rangeSliderCustom.handleDiameter = 22
        rangeSliderCustom.selectedHandleDiameterMultiplier = 1
        rangeSliderCustom.tintColorBetweenHandles = UIColor.AzureColor()
        rangeSliderCustom.tintColor = UIColor.uncheckButtonBackgroundColor()
        rangeSliderCustom.handleColor = UIColor.AzureColor()
        
        rangeSliderCustom.lineHeight = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
