//
//  NavigationVC.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
         if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
      //  self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized)))
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        // Dismiss keyboard (optional)
        //
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.panGestureRecognized(sender)
    }
    
}
