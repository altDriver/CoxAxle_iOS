//
//  BasicFilterOptionsTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class BasicFilterOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet var selectMakeButton: UIButton!
    @IBOutlet var selectModelButton: UIButton!
    @IBOutlet var selectYearButton: UIButton!
    
    @IBOutlet var selectMakeDropdownButton: UIButton!
    @IBOutlet var selectModelDropdownButton: UIButton!
    @IBOutlet var selectYearDropdownButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
