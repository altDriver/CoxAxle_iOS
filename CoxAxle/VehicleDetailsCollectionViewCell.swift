//
//  VehicleDetailsCollectionViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 11/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import YLProgressBar

class VehicleDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var progressBar: YLProgressBar!
    @IBOutlet var vehicleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initFlatWithIndicatorProgressBar()
        self.progressBar.setProgress(0.50, animated: true)
    }
    
    //MARK:- UIPROGRESSVIEW METHODS
    func initFlatWithIndicatorProgressBar() {
        self.progressBar.type = YLProgressBarType.Flat
        self.progressBar.indicatorTextDisplayMode =  YLProgressBarIndicatorTextDisplayMode.Progress
        self.progressBar.behavior = YLProgressBarBehavior.Indeterminate
        self.progressBar.hideStripes = true
        //self.progressBar.stripesOrientation = YLProgressBarStripesOrientation.Vertical
        self.progressBar.progressTintColor = UIColor.PumpkinColor()
        self.progressBar.trackTintColor = UIColor.init(red: 97/255.0, green: 127/255.0, blue: 161/255.0, alpha: 1)
        self.progressBar.hideGloss = true
        self.progressBar.indicatorTextLabel.text = "Vehicle Profile: 50%"
    }
}
