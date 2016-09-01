//
//  LandingScreen.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import Alamofire

class LandingScreen: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIAlertController_UIAlertView, MFMailComposeViewControllerDelegate  {
    
    let bannerReuseIdentifier = "BannerCell"
    let dealerReuseIdentifier = "DealerCell"
    let contactReuseIdentifier = "ContactCell"
    let bannerCollectionViewCellReuseIdentifier = "BannerCollectionViewCell"
    let myCarsReuseIdentifier = "MyCarsCell"
    let myCarsCollectionViewCellReuseIdentifier = "MyCarsCollectionViewCell"
    
    var language: String?
    var bannerCollectionView: UICollectionView!
    var myCarsCollectionView: UICollectionView!
    
    var bannerPageControl: UIPageControl!
    var myCarsPageControl: UIPageControl!
    
    @IBOutlet var hamBurgerButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var vehiclesArray = [AnyObject]()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setText()
        
        self.tableView.sectionHeaderHeight = 60
        
        if NSUserDefaults.standardUserDefaults().boolForKey("USER_LOGGED_IN") {
         self.callFetchMyCarsAPI()
         self.hamBurgerButton.hidden = false
        }
        else {
         self.hamBurgerButton.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandingScreen.setText), name: "LanguageChanged", object: nil)
        if NSUserDefaults.standardUserDefaults().boolForKey("SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("CALL_API") {
            if NSUserDefaults.standardUserDefaults().boolForKey("USER_LOGGED_IN") {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "CALL_API")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.callFetchMyCarsAPI()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
      //  NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        self.title = "Home".localized(self.language!)
    }
    
    //MARK:-  UIBUTTON ACTIONS
    @IBAction func showMenu(sender:UIButton!)
    {
        if let frostView = self.view{
            frostView.endEditing(true)
        }
        
        if let frostingViewController = self.frostedViewController{
            frostingViewController.view.endEditing(true)
            frostingViewController.presentMenuViewController()
        }
    }
    
//    @IBAction func btnSideMenuPressed(sender: UIButton) {
//        sideMenuVC.toggleMenu()
//    }
    
    func addButtonClicked() -> Void {
        if NSUserDefaults.standardUserDefaults().boolForKey("USER_LOGGED_IN") {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
            self.performSegueWithIdentifier("AddVehicle", sender: self)
        }
     //   self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
    }
    
    
    func callButtonClicked(sender: UIButton) {
        let phoneNumber: String = "+919912841997"
        let phoneUrl: NSURL = NSURL(string: "telprompt:\(phoneNumber)")!
        if UIApplication.sharedApplication().canOpenURL(phoneUrl) {
            UIApplication.sharedApplication().openURL(phoneUrl)
        }
        else {
            self.showAlertwithCancelButton("Error", message: "Call facility is not available!!!", cancelButton: "OK")
        }
    }
   
    func emailButtonClicked(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
//            self.showAlertwithCancelButton("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", cancelButton: "OK")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@coxaxle.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("Hi", isHTML: false)
        
        return mailComposerVC
    }
    
    func directionButtonClicked(sender: UIButton) {
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:"http://maps.apple.com")!) {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?daddr=Atlanta+GA&saddr=Cumming")!)
//             UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?saddr=36.7783,119.4179&daddr=40.7128,74.0059")!)
        } else {
            self.showAlertwithCancelButton("Error", message: "Cannot use Apple maps", cancelButton: "OK")
        }
        
    }
    
    @IBAction func notificationButtonClicked(sender: UIButton) {
        self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
    }
    //MARK:- UITABLEVIEW DATA SOURCE METHODS
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             let cell = self.tableView.dequeueReusableCellWithIdentifier(bannerReuseIdentifier) as! BannerTableViewCell!
             
             cell.bannerCollectionView.tag = 1
             cell.bannerCollectionView.backgroundColor = UIColor.WhiteColor()
             
             self.bannerCollectionView = cell.bannerCollectionView
             self.bannerPageControl = cell.pageControl
            return cell
        case 1:
            let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(dealerReuseIdentifier) as UITableViewCell!
            
            let cellImageView: UIImageView = cell.viewWithTag(501) as! UIImageView
            let cellTitle: UILabel = cell.viewWithTag(502) as! UILabel
            let cellSubTitle: UILabel = cell.viewWithTag(503) as! UILabel
            
            switch indexPath.row {
            case 0:
                  cellImageView.image = UIImage(named: "calendarIcon")
                  cellTitle.text = "Schedule Appointment".localized(self.language!)
                  cellSubTitle.text = "At vero eos et accusamus et iusto odio dignissimos"
                  break
            case 1:
                cellImageView.image = UIImage(named: "serviceHistoryIcon")
                cellTitle.text = "Service History".localized(self.language!)
                cellSubTitle.text = "At vero eos et accusamus et iusto odio dignissimos"
                break
            default:
                break
            }
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if NSUserDefaults.standardUserDefaults().boolForKey("USER_LOGGED_IN") {
                cell.userInteractionEnabled = true
            }
            else {
                cell.userInteractionEnabled = false
            }
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCellWithIdentifier(myCarsReuseIdentifier) as! MyCarsTableViewCell!
            
            cell.myCarsCollectionView.tag = 2
            cell.myCarsCollectionView.backgroundColor = UIColor.WhiteColor()
            
            self.myCarsCollectionView = cell.myCarsCollectionView
            self.myCarsPageControl = cell.pageControl
            
            if NSUserDefaults.standardUserDefaults().boolForKey("USER_LOGGED_IN") {
                cell.userInteractionEnabled = true
            }
            else {
                cell.userInteractionEnabled = false
            }
            return cell
        case 3:
            let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(dealerReuseIdentifier) as UITableViewCell!
            let cellImageView: UIImageView = cell.viewWithTag(501) as! UIImageView
            let cellTitle: UILabel = cell.viewWithTag(502) as! UILabel
            let cellSubTitle: UILabel = cell.viewWithTag(503) as! UILabel
            
            switch indexPath.row {
            case 0:
                cellImageView.image = UIImage(named: "searchCarsIcon")
                cellTitle.text = "Search New and Used Cars".localized(self.language!)
                cellSubTitle.text = "At vero eos et accusamus et iusto odio dignissimos"
                break
            case 1:
                cellImageView.image = UIImage(named: "savedCarsIcon")
                cellTitle.text = "Saved Cars".localized(self.language!)
                cellSubTitle.text = "At vero eos et accusamus et iusto odio dignissimos"
                break
            default:
                break
            }
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        case 4:
            let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(contactReuseIdentifier) as UITableViewCell!
            
            let callButton = cell.viewWithTag(601) as! UIButton
            let emailButton = cell.viewWithTag(602) as! UIButton
            let directionButton = cell.viewWithTag(603) as! UIButton
            
            let callLabel = cell.viewWithTag(604) as! UILabel
            let emailLabel = cell.viewWithTag(605) as! UILabel
            let directionsLabel = cell.viewWithTag(606) as! UILabel
            
            callLabel.text = "Call Us".localized(self.language!)
            emailLabel.text = "Email Us".localized(self.language!)
            directionsLabel.text = "Direction".localized(self.language!)
            
            
            callButton.addTarget(self, action: #selector(LandingScreen.callButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            emailButton.addTarget(self, action: #selector(LandingScreen.emailButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            directionButton.addTarget(self, action: #selector(LandingScreen.directionButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        default: let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(contactReuseIdentifier) as UITableViewCell!
        return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
             return 225
        case 1:
             return 99
        case 2:
             return 319
        case 3:
             return 99
        case 4:
             return 99
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
                self.performSegueWithIdentifier("Appointment", sender: self)
                break
            case 1:
                self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
                break
            default:
                break
            }
            case 3:
                switch indexPath.row {
                case 0:
                    self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
                    break
                case 1:
                    self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
                    break
                default:
                    break
            }
            
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 1:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
            let label = UILabel(frame: CGRect(x: 20, y: 18, width: 234, height: 23))
            label.text = "Dealer Services".localized(self.language!)
            label.font = UIFont.regularFont()
            label.textColor = UIColor.CharcoalGrey()
            
            view.backgroundColor = UIColor.WhiteColor()
            view.addSubview(label)
            
            self.view.addSubview(view)
            
            return view
            
        case 2:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
            let label = UILabel(frame: CGRect(x: 20, y: 18, width: 154, height: 23))
            label.text = "My Cars".localized(self.language!)
            label.font = UIFont.regularFont()
            label.textColor = UIColor.CharcoalGrey()
            
            let addButton = UIButton.init(type: UIButtonType.Custom)
            addButton.frame = CGRectMake(self.view.frame.size.width-50, 15, 30, 30)
            addButton.setImage(UIImage(named: "addVehicleBtn"), forState: UIControlState.Normal)
            addButton.addTarget(self, action: #selector(LandingScreen.addButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
            view.backgroundColor = UIColor.WhiteColor()
            view.addSubview(label)
            view.addSubview(addButton)
            
            self.view.addSubview(view)
            
            return view
        case 3:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
            let label = UILabel(frame: CGRect(x: 20, y: 18, width: 294, height: 23))
            label.text = "Dealer Inventory".localized(self.language!)
            label.font = UIFont.regularFont()
            label.textColor = UIColor.CharcoalGrey()
            
            view.backgroundColor = UIColor.WhiteColor()
            view.addSubview(label)
            
            self.view.addSubview(view)
            
            return view
        default:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
            return view
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00002
        case 1:
            return 60
        case 2:
             return 60
        case 3:
             return 60
        case 4:
            return 1
        default:
            return 0
        }
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00002
        default:
            return 5.0
        }
        
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if collectionView.tag == 1 {
            return 0
        }
        else {
            return 15
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 5
        }
        else {
            return self.vehiclesArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            let position: CGSize = CGSizeMake(self.view.frame.size.width, 224)
            
            return position
        }
        else
        {
            let position: CGSize = CGSizeMake(self.view.frame.size.width-75, 244)
            
            return position
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(bannerCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! BannerCollectionViewCell
            
            cell.bannerImageView.image = UIImage(named: "bannerBg")
            
            return cell;
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(myCarsCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! MyCarsCollectionViewCell
            
            let imageArray = self.vehiclesArray[indexPath.row].valueForKey("vechicle_image") as! NSArray
                let imageURLString = imageArray[0].valueForKey("image_url") as! NSString
            cell.carImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
                cell.carImageView.alpha = 1;
                
                }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
            cell.carName.text = self.vehiclesArray[indexPath.row].valueForKey("name") as? String
            cell.carAppointmentDate.text = "Next scheduled service: Aug 27, 2016"
            
            return cell;
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if collectionView.tag == 2 {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.performSegueWithIdentifier("VehicleDetails", sender: self)
        }
    }
    
    //MARK:- UISCROLLVIEW DELEGATE METHODS
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView.tag == 1 {
            let pageWidth = CGRectGetWidth(scrollView.frame)
            self.bannerPageControl.currentPage = Int(bannerCollectionView.contentOffset.x / pageWidth)
        }
        else if scrollView.tag == 2 {
            let pageWidth = CGRectGetWidth(scrollView.frame)
            self.myCarsPageControl.currentPage = Int(myCarsCollectionView.contentOffset.x / pageWidth)
        }
    }
    
    //MARK:- MFMAILCOMPOSER DELEGATE METHODS
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK:- FETCH MY CARS API
    func callFetchMyCarsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
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
                             
                             
                             self.vehiclesArray = dict.response?.data as! Array<AnyObject>
                                print(self.vehiclesArray)
                                dispatch_async(dispatch_get_main_queue(),{
                                    
                                    self.myCarsCollectionView.reloadData()
                                    
                                })
                             }
                             catch let error as NSError {
                             NSLog("Unresolved error \(error), \(error.userInfo)")
                             }
                        }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK".localized(self.language!))
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
}