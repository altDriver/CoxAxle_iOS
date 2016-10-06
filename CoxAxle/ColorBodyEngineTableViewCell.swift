//
//  ColorBodyEngineTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class ColorBodyEngineTableViewCell: UITableViewCell {

    @IBOutlet var colorBodyEngineLabel: UILabel!
    
    @IBOutlet var selectedValue: UILabel!
    @IBOutlet var disclosureButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
