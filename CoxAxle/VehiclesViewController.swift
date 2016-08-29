//
//  VehiclesViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class VehiclesViewController: UIViewController, UIAlertController_UIAlertView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let vehicleListReuseIdentifier = "VehiclesListCell"
    
    @IBOutlet var collectionView: UICollectionView!
    var language: String?
    var imagesArray: NSArray!

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setText()
         imagesArray = ["car1Img", "car2Img", "car3Img", "car4Img"]
         self.fetchVehiclesListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func addVehicleButtonClicked(sender: UIButton) {
        
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 15
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            let position: CGSize = CGSizeMake(self.view.frame.size.width-30, Constant.iPhoneScreen.Ratio * 230)
            
            return position
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(vehicleListReuseIdentifier, forIndexPath: indexPath) as! VehiclesListCollectionViewCell
            
        
            return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.performSegueWithIdentifier("VehicleDetails", sender: self)
    }
    
    
    //MARK:- FETCH VEHICLES LIST API
    func fetchVehiclesListAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let token: String = NSUserDefaults.standardUserDefaults().objectForKey("Token") as! String
            let paramsDict: [ String : AnyObject] = ["uid": "21", "token": token] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/list", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let sessionStatus = JSON.valueForKey("session_status") as! String
                        if sessionStatus == "1" {
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
//                              do {
//                             let dict: VehiclesList = try VehiclesList(dictionary: JSON as! [NSObject : AnyObject])
//                             
//                             print(dict.response)
//                             }
//                             catch let error as NSError {
//                             NSLog("Unresolved error \(error), \(error.userInfo)")
//                             }
                        }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                        }
                        }
                        else {
                            
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SESSION_EXPIRED")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
                            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
                        }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            showAlertwithCancelButton("No Internet Connection", message: "Make sure your device is connected to the internet.", cancelButton: "OK")
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
