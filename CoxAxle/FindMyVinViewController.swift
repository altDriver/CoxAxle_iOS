//
//  FindMyVinViewController.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 01/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class FindMyVinViewController: GAITrackedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "FindMyVinViewController"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DismissViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
