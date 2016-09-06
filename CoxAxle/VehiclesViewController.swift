//
//  VehiclesViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class VehiclesViewController: GAITrackedViewController, UIAlertController_UIAlertView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let vehicleListReuseIdentifier = "VehiclesListCell"
    
    @IBOutlet var collectionView: UICollectionView!
    var language: String?
    var vehiclesListArray = [AnyObject]()

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
         self.screenName = "VehiclesViewController"
         self.setText()
         self.fetchVehiclesListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("CALL_API") {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "CALL_API")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.fetchVehiclesListAPI()
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
    
    @IBAction func menuButtonClicked(sender: UIButton) {
        if let frostView = self.view{
            frostView.endEditing(true)
        }
        
        if let frostingViewController = self.frostedViewController{
            frostingViewController.view.endEditing(true)
            frostingViewController.presentMenuViewController()
        }
    }
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 15
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehiclesListArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            let position: CGSize = CGSizeMake(self.view.frame.size.width-30, Constant.iPhoneScreen.Ratio * 230)
            
            return position
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(vehicleListReuseIdentifier, forIndexPath: indexPath) as! VehiclesListCollectionViewCell
            
        let imageArray = self.vehiclesListArray[indexPath.row].valueForKey("vechicle_image") as! NSArray
        let imageURLString = imageArray[0].valueForKey("image_url") as! NSString
        cell.carImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
            cell.carImageView.alpha = 1;
            
            }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
        cell.carName.text = self.vehiclesListArray[indexPath.row].valueForKey("name") as? String
        cell.carAppointmentDate.text = "Next scheduled service: Aug 27, 2016"
            return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.performSegueWithIdentifier("VehicleDetails", sender: indexPath)
    }
    
    
    //MARK:- FETCH VEHICLES LIST API
    func fetchVehiclesListAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let paramsDict: [ String : AnyObject] = ["uid": "21"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/list", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                            if status == "True"  {
                                do {
                                    let dict: VehiclesList = try VehiclesList(dictionary: JSON as! [NSObject : AnyObject])
                                    
                                    
                                    self.vehiclesListArray = dict.response?.data as! Array<AnyObject>
                                    print(self.vehiclesListArray)
                                    dispatch_async(dispatch_get_main_queue(),{
                                        
                                        self.collectionView.reloadData()
                                        
                                    })
                                }
                                catch let error as NSError {
                                    NSLog("Unresolved error \(error), \(error.userInfo)")
                                }
                            }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                        }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VehicleDetails" {
            let indexPath = sender as! NSIndexPath
            let vehicleDetails = (segue.destinationViewController as! VehicleDetailsViewController)
            vehicleDetails.vehiclesDetailsDict = self.vehiclesListArray[indexPath.row] as! NSDictionary
        }
    }
    

}
