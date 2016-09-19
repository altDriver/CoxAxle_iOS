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
    
    @IBOutlet var insuranceCardsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
