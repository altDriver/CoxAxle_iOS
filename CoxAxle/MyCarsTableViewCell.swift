//
//  MyCarsTableViewCell.swift
//  CoxAxle
//
//  Created by Prudhvi on 09/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class MyCarsTableViewCell: UITableViewCell {

    @IBOutlet var myCarsCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    @IBOutlet var scrollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   


}
