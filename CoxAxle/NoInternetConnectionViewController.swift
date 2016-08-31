//
//  NoInternetConnectionViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 31/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class NoInternetConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func retryButtonClicked(sender: UIButton) {
         if Reachability.isConnectedToNetwork() == true {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CALL_API")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
         }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(CGColor: self.borderColor!)
        } set {
            self.borderColor = newValue.CGColor
        }
    }
}
