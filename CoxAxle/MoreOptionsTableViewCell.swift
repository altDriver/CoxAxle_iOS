//
//  MoreOptionsTableViewCell.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class MoreOptionsTableViewCell: UITableViewCell {

    @IBOutlet var moreOptionsTitleLabel: UILabel!
    
    @IBOutlet var moreOptionsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
