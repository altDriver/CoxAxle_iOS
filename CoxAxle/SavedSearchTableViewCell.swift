//
//  SavedSearchTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 27/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class SavedSearchTableViewCell: UITableViewCell {

    @IBOutlet var searchName: UILabel!
    @IBOutlet var searchTime: UILabel!
    @IBOutlet var searchDeleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
