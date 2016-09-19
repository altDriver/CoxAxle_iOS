//
//  RootVC.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import REFrostedViewController

class RootVC: REFrostedViewController {

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationVC") as! NavigationVC
        self.menuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        
    }

}
