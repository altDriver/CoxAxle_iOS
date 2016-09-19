//
//  SelectionTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 12/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet var cellValue: UILabel!
    @IBOutlet var selectionButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
