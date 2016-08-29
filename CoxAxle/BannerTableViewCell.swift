//
//  BannerTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 09/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
