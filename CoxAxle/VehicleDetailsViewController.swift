//
//  VehicleDetailsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 11/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import YLProgressBar

class VehicleDetailsViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertController_UIAlertView {
    
    let vehicleBannerReuseIdentifier = "VehicleBannerCell"
    let vehicleReuseIdentifier = "VehicleNormalCell"
    let vehicleButtonReuseIdentifier = "VehicleButtonCell"
    let vehicleProgressReuseIdentifier = "VehicleProgressReuseIdentifier"
    let vehicleDocumentReuseIdentifier = "VehicleDocumentReuseIdentifier"
    let vehicleContactReuseIdentifier = "VehicleContactReuseIdentifier"
    let vehicleCollectionViewCellReuseIdentifier = "VehicleCollectionViewCell"
    
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height

    @IBOutlet var tableView: UITableView!
    var bannerCollectionView: UICollectionView!
    var pageControl: UIPageControl!
    var language: String?
    var sessionPasswordField: UITextField!
    @IBOutlet var progressBar: YLProgressBar!
    
    var vehiclesDetailsDict: NSDictionary!
    var vehicleImagesArray = [AnyObject]()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "VehicleDetailsViewController"
        self.setText()
        print(self.vehiclesDetailsDict)
        self.vehicleImagesArray = self.vehiclesDetailsDict.valueForKey("vechicle_image") as! Array<AnyObject>
        //self.callEditVehiclesAPI()
        self.setProgressBarProperties()
    
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
            self.fetchVehicleDetails()
            //self.callEditVehiclesAPI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        
    }
    
    //MARK:- UIBUTTONS ACTIONS
    func openBrowserButtonClicked() -> Void {
        
    }
    
    //MARK:- SET PROGRESS BAR
    func setProgressBarProperties() {
        
       self.progressBar.type           = .Flat
       self.progressBar.trackTintColor = UIColor.SlateColor().colorWithAlphaComponent(0.4)
        
        let titleLabel             = UILabel(frame: CGRect(x:  0, y: 0, width: screenWidth/2, height: 15))
        titleLabel.text            = "Vehicle Profile: 50%"
        titleLabel.textAlignment   = .Right
        titleLabel.font            = UIFont.boldFont().fontWithSize(10)
        titleLabel.backgroundColor = UIColor.orangeColor()
        titleLabel.textColor       = UIColor.whiteColor()
        
        self.progressBar.addSubview(titleLabel)
    }
    
    //MARK:- UITABLEVIEW DATA SOURCE METHODS
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 1
        case 5:
            return 1
        case 6:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleBannerReuseIdentifier) as! VehicleDetailsTableViewCell!
                
                cell.vehicleBannerCollectionView.backgroundColor = UIColor.WhiteColor()
                
                self.bannerCollectionView = cell.vehicleBannerCollectionView
                self.pageControl = cell.vehicleDetailsPageControl
                self.pageControl.numberOfPages = self.vehicleImagesArray.count
                return cell
        case 1:
            switch indexPath.row {
            case 0:
                 let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleButtonReuseIdentifier) as UITableViewCell!
                 return cell
                
            default:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleReuseIdentifier) as UITableViewCell!
                return cell
            }
        case 2:
            let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleProgressReuseIdentifier) as! VehicleProgressTableViewCell!
            
            cell.monthsProgressView.drawCircleWithPercent(30, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fillColor: UIColor.init(red: 228/255.0, green: 229/255.0, blue: 230/255.0, alpha: 1), strokeColor: UIColor.PumpkinColor(), animatedColors: nil)
            
            cell.milesProgressView.drawCircleWithPercent(55, duration: 2, lineWidth: 10, clockwise: true, lineCap: kCALineCapRound, fillColor: UIColor.init(red: 228/255.0, green: 229/255.0, blue: 230/255.0, alpha: 1), strokeColor: UIColor.init(red: 36/255.0, green: 166/255.0, blue: 237/255.0, alpha: 1), animatedColors: nil)
            
            cell.monthsProgressView.percentLabel.text = "18 \nMonths"
            cell.monthsProgressView.percentLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            cell.monthsProgressView.percentLabel.numberOfLines = 2
            cell.monthsProgressView.percentLabel.textAlignment = NSTextAlignment.Center
            cell.milesProgressView.percentLabel.text = "12,584 \nMiles"
            cell.milesProgressView.percentLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            cell.milesProgressView.percentLabel.numberOfLines = 2
            cell.milesProgressView.percentLabel.textAlignment = NSTextAlignment.Center
            
            cell.monthsProgressView.startAnimation()
            cell.milesProgressView.startAnimation()
            return cell
        case 3:
            switch indexPath.row {
            case 0:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell.viewWithTag(102) as! UILabel
                
                cellTitle.text = "Vehicle identification no. (VIN)"
                cellSubTitle.text = self.vehiclesDetailsDict.valueForKey("vin") as? String
                return cell
            case 1:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell.viewWithTag(102) as! UILabel
                
                cellTitle.text = "Tag expiration"
                let tagDate = self.vehiclesDetailsDict.valueForKey("tag_expiration_date") as! String
                cellSubTitle.text = tagDate.convertDateToString()
                return cell
            default:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell.viewWithTag(102) as! UILabel
                
                cellTitle.text = ""
                cellSubTitle.text = ""
                return cell
            }
        case 4:
            let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleDocumentReuseIdentifier) as UITableViewCell!
            let cellTitle: UILabel = cell.viewWithTag(111) as! UILabel
            let cellSubTitle: UIImageView = cell.viewWithTag(112) as! UIImageView
            
            cellTitle.text = "Insurance"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
            
        case 5:
            let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleDocumentReuseIdentifier) as UITableViewCell!
            let cellTitle: UILabel = cell.viewWithTag(111) as! UILabel
            let cellSubTitle: UIImageView = cell.viewWithTag(112) as! UIImageView
            
            cellTitle.text = "Extended Warranty"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        case 6:
            switch indexPath.row {
            case 0:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleContactReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell.viewWithTag(121) as! UILabel
                let cellSubTitle: UIButton = cell.viewWithTag(122) as! UIButton
                
                cellTitle.text = "Car Manual"
                cellSubTitle.setImage(UIImage(named: "openInBrowserIcon"), forState: UIControlState.Normal)
                cellSubTitle.addTarget(self, action: #selector(self.openBrowserButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            case 1:
                let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleContactReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell.viewWithTag(121) as! UILabel
                let cellSubTitle: UIButton = cell.viewWithTag(122) as! UIButton
                
                cellTitle.text = "Roadside Assistance"
                cellSubTitle.setImage(UIImage(named: "roadAssistanceIcon"), forState: UIControlState.Normal)
                return cell
                
            default:
                 let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleContactReuseIdentifier) as UITableViewCell!
                return cell
            }
            
        default:
            let cell = self.tableView.dequeueReusableCellWithIdentifier(vehicleBannerReuseIdentifier) as! VehicleDetailsTableViewCell!
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 369
        case 1:
            switch indexPath.row {
            case 0:
                return 60
            default:
                return 0
            }
        case 2:
            return 265
        case 3:
            return 74
        case 4:
            return 65
        case 5:
            return 65
        case 6:
            return 65
        default:
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    
//    }
//    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00002
        default:
            return 2.5
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    
    // MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
       return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicleImagesArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let position: CGSize = CGSizeMake(self.view.frame.size.width, 369)
            
        return position
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(vehicleCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! VehicleDetailsCollectionViewCell
        
        let imageURLString = self.vehicleImagesArray[indexPath.row].valueForKey("image_url") as! NSString
        cell.vehicleImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
            cell.vehicleImageView.alpha = 1;
            
            }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
        cell.vehicleTitle.text = self.vehiclesDetailsDict.valueForKey("name") as? String
        cell.vehicleName.text = String(format: "%@ %@ • %@", (self.vehiclesDetailsDict.valueForKey("year") as? String)!, (self.vehiclesDetailsDict.valueForKey("model") as? String)!, (self.vehiclesDetailsDict.valueForKey("mileage") as? String)!)
        
            return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    //MARK:- UISCROLLVIEW DELEGATE METHODS
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageWidth = CGRectGetWidth(scrollView.frame)
        self.pageControl.currentPage = Int(bannerCollectionView.contentOffset.x / pageWidth)
    }
    
    //MARK:- VEHICLE DETAILS API
    func fetchVehicleDetails() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let paramsDict: [ String : AnyObject] = ["vid": "7", "uid": "21"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/view", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                          /*  do {
                                let dict: VehicleDetails = try VehicleDetails(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict)
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }*/
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
    
    //MARK:- EDIT VEHICLES API
    func callEditVehiclesAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let image : UIImage = UIImage(named: "splash_image")!
            //Now use image to create into NSData format
            let imageData:NSData = UIImagePNGRepresentation(image)!
            
            let strBase64:String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let paramsDict: [ String : AnyObject] = ["vid": "7","name": "Maruti Swift", "uid": "21", "dealer_id": "1", "vin": "9007", "vehicle_type": "Sedan", "make": "Maruthi", "model": "", "color": "Silver", "photo": strBase64, "waranty_from": "", "waranty_to": "", "extended_waranty_from": "", "extended_waranty_to": "", "kbb_price": "1000", "manual": "", "loan_amount": "200", "emi": "50", "interest": "9", "loan_tenure": "6", "insurance_document": "", "mileage": "12345", "style": "", "trim": "", "year": "2010"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/update", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: EditVehicles = try EditVehicles(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
