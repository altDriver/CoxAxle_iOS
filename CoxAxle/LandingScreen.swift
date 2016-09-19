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
import UIActivityIndicator_for_SDWebImage

class LandingScreen: GAITrackedViewController,UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIAlertController_UIAlertView, MFMailComposeViewControllerDelegate  {
    
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
    var alreadyLoaded: Bool!
    
    var vehiclesArray = [AnyObject]()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {

        self.screenName = "LandingScreen"
        self.alreadyLoaded = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setText()
        
        self.tableView.sectionHeaderHeight = 60
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.isNavigationBarHidden = false
        if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
            self.callFetchMyCarsAPI()
            self.hamBurgerButton.isHidden = false
        }
        else {
            self.hamBurgerButton.isHidden = true
        }
       
        if UserDefaults.standard.bool(forKey: "SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "SessionExpired")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.bool(forKey: "CALL_API") {
            if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
                UserDefaults.standard.set(false, forKey: "CALL_API")
                UserDefaults.standard.synchronize()
                self.callFetchMyCarsAPI()
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LandingScreen.reloadCollectionView), name: NSNotification.Name(rawValue: "VehicleAdded"), object: nil)
         super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "VehicleAdded"), object: nil)
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        self.title = "Home".localized(self.language!)
    }
    
    //MARK:-  UIBUTTON ACTIONS
    @IBAction func showMenu(_ sender:UIButton!)
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
        if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
            if self.vehiclesArray.count >= 5 {
                self.showAlertwithCancelButton("Alert", message: "You can't add more than 5 vehicles. Please delete vehicles before adding a vehicle", cancelButton: "OK")
            }
            else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.performSegue(withIdentifier: "AddVehicle", sender: self)
           }
        }
     //   self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
    }
    
    
    func callButtonClicked(_ sender: UIButton) {
        let phoneNumber: String = "+919912841997"
        let phoneUrl: URL = URL(string: "telprompt:\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.openURL(phoneUrl)
        }
        else {
            self.showAlertwithCancelButton("Error", message: "Call facility is not available!!!", cancelButton: "OK")
        }
    }
   
    func emailButtonClicked(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
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
    
    func directionButtonClicked(_ sender: UIButton) {
        
        if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!) {
            UIApplication.shared.openURL(URL(string: "http://maps.apple.com/?daddr=Atlanta+GA&saddr=Cumming")!)
//             UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?saddr=36.7783,119.4179&daddr=40.7128,74.0059")!)
        } else {
            self.showAlertwithCancelButton("Error", message: "Cannot use Apple maps", cancelButton: "OK")
        }
        
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
        self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
        }
        else {
            
            let alertController = UIAlertController(title: "CoxAxle", message: "Please log in into the coxaxle application in order to use the services", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
               
            })
            alertController.addAction(defaultAction)
            
            let otherAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            })
            alertController.addAction(otherAction)
            
            DispatchQueue.main.async(execute: {
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
   func reloadCollectionView() -> Void {
        self.alreadyLoaded = true
    }
    
    //MARK:- UITABLEVIEW DATA SOURCE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
             let cell = self.tableView.dequeueReusableCell(withIdentifier: bannerReuseIdentifier) as! BannerTableViewCell!
             
             cell?.bannerCollectionView.tag = 1
             cell?.bannerCollectionView.backgroundColor = UIColor.WhiteColor()
             
             self.bannerCollectionView = cell?.bannerCollectionView
             self.bannerPageControl = cell?.pageControl
            return cell!
        case 1:
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: dealerReuseIdentifier) as UITableViewCell!
            
            let cellImageView: UIImageView = cell.viewWithTag(501) as! UIImageView
            let cellTitle: UILabel = cell.viewWithTag(502) as! UILabel
            let cellSubTitle: UILabel = cell.viewWithTag(503) as! UILabel
            
            switch (indexPath as NSIndexPath).row {
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
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
                cell.isUserInteractionEnabled = true
            }
            else {
                cell.isUserInteractionEnabled = false
            }
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: myCarsReuseIdentifier) as! MyCarsTableViewCell!
            
            cell?.myCarsCollectionView.tag = 2
            cell?.myCarsCollectionView.backgroundColor = UIColor.WhiteColor()
            
            self.myCarsCollectionView = cell?.myCarsCollectionView
            self.myCarsPageControl = cell?.pageControl
            let deviceType = UIDevice.current.modelName
            if deviceType == "iPhone 5" || deviceType == "iPhone 5s" || deviceType == "iPhone8,4" {
                self.myCarsPageControl.numberOfPages = self.vehiclesArray.count
            }
            
            if UserDefaults.standard.bool(forKey: "USER_LOGGED_IN") {
                cell?.isUserInteractionEnabled = true
            }
            else {
                cell?.isUserInteractionEnabled = false
            }
            return cell!
        case 3:
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: dealerReuseIdentifier) as UITableViewCell!
            let cellImageView: UIImageView = cell.viewWithTag(501) as! UIImageView
            let cellTitle: UILabel = cell.viewWithTag(502) as! UILabel
            let cellSubTitle: UILabel = cell.viewWithTag(503) as! UILabel
            
            switch (indexPath as NSIndexPath).row {
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
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        case 4:
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: contactReuseIdentifier) as UITableViewCell!
            
            let callButton = cell.viewWithTag(601) as! UIButton
            let emailButton = cell.viewWithTag(602) as! UIButton
            let directionButton = cell.viewWithTag(603) as! UIButton
            
            let callLabel = cell.viewWithTag(604) as! UILabel
            let emailLabel = cell.viewWithTag(605) as! UILabel
            let directionsLabel = cell.viewWithTag(606) as! UILabel
            
            callLabel.text = "Call Us".localized(self.language!)
            emailLabel.text = "Email Us".localized(self.language!)
            directionsLabel.text = "Direction".localized(self.language!)
            
            
            callButton.addTarget(self, action: #selector(LandingScreen.callButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            emailButton.addTarget(self, action: #selector(LandingScreen.emailButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            directionButton.addTarget(self, action: #selector(LandingScreen.directionButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            return cell
        default: let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: contactReuseIdentifier) as UITableViewCell!
        return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).section {
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
                self.performSegue(withIdentifier: "XTime", sender: self)
                break
            case 1:
                self.showAlertwithCancelButton("CoxAxle", message: "Functionality in progress", cancelButton: "OK")
                break
            default:
                break
            }
            case 3:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    self.performSegue(withIdentifier: "Inventory", sender: self)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
            
            let addButton = UIButton.init(type: UIButtonType.custom)
            addButton.frame = CGRect(x: self.view.frame.size.width-50, y: 15, width: 30, height: 30)
            addButton.setImage(UIImage(named: "addVehicleBtn"), for: UIControlState())
            addButton.addTarget(self, action: #selector(LandingScreen.addButtonClicked), for: UIControlEvents.touchUpInside)
            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00002
        default:
            return 5.0
        }
        
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if collectionView.tag == 1 {
            return 0
        }
        else {
            return 15
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 5
        }
        else {
            if self.vehiclesArray.count > 0 {
                self.myCarsCollectionView.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.myCarsCollectionView.bounds.size.width, height: self.myCarsCollectionView.bounds.size.height))
                noDataLabel.text = "No vehicle added, Please add a Vehicle"
                noDataLabel.textColor = UIColor.init(red: 79/255.0, green: 90/255.0, blue: 113/255.0, alpha: 1)
                noDataLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
                noDataLabel.textAlignment = .center
                self.myCarsCollectionView.backgroundView = noDataLabel
            }

            return self.vehiclesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            let position: CGSize = CGSize(width: self.view.frame.size.width, height: 224)
            
            return position
        }
        else
        {
            let position: CGSize = CGSize(width: self.view.frame.size.width-75, height: 244)
            
            return position
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCollectionViewCellReuseIdentifier, for: indexPath) as! BannerCollectionViewCell
            
            cell.bannerImageView.image = UIImage(named: "bannerBg")
            return cell;
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCarsCollectionViewCellReuseIdentifier, for: indexPath) as! MyCarsCollectionViewCell
            
            let imageArray = self.vehiclesArray[(indexPath as NSIndexPath).row].value(forKey: "vechicle_image") as! NSArray
                let imageURLString = (imageArray[0] as AnyObject).value(forKey: "image_url") as! NSString
            
            cell.carImageView.sd_setImage(with: URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), completed: { (image, error, cacheType, url) -> Void in
                cell.carImageView.alpha = 1;
                
            })
            //            cell.carImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
//                cell.carImageView.alpha = 1;
//                
//                }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
            cell.carName.text = self.vehiclesArray[(indexPath as NSIndexPath).row].value(forKey: "name") as? String
            cell.carAppointmentDate.text = String(format: "%@ %@ • %@ Miles", (self.vehiclesArray[(indexPath as NSIndexPath).row].value(forKey: "year") as? String)!, (self.vehiclesArray[(indexPath as NSIndexPath).row].value(forKey: "model") as? String)!, (self.vehiclesArray[(indexPath as NSIndexPath).row].value(forKey: "mileage") as? String)!)
            
            return cell;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView.tag == 2 {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.performSegue(withIdentifier: "VehicleDetails", sender: indexPath)
        }
    }
    
    //MARK:- UISCROLLVIEW DELEGATE METHODS
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 1 {
            let pageWidth = scrollView.frame.width
            self.bannerPageControl.currentPage = Int(bannerCollectionView.contentOffset.x / pageWidth)
        }
        else if scrollView.tag == 2 {
            let pageWidth: CGFloat = self.view.frame.size.width-75
            self.myCarsPageControl.currentPage = Int(myCarsCollectionView.contentOffset.x / pageWidth)
        }
    }
    
    //MARK:- MFMAILCOMPOSER DELEGATE METHODS
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:- FETCH MY CARS API
    func callFetchMyCarsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching My Cars API Called", label: "Fetch My Cars", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/list", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                               do {
                             let dict: VehiclesList = try VehiclesList(dictionary: JSON as! [AnyHashable: Any])
                             
                             
                             self.vehiclesArray = dict.response?.data as! Array<AnyObject>
                             
                                print(self.vehiclesArray)
                                DispatchQueue.main.async {
                                    let deviceType = UIDevice.current.modelName
                                    if deviceType == "iPhone 6" || deviceType == "iPhone 6s" || deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6s Plus" {
                                        self.myCarsPageControl.numberOfPages = self.vehiclesArray.count
                                        self.myCarsCollectionView.reloadData()
                                    }
                                    
                                    if self.alreadyLoaded == true {
                                        if deviceType == "iPhone 5" || deviceType == "iPhone 5s" || deviceType == "iPhone8,4" {
                                            self.myCarsPageControl.numberOfPages = self.vehiclesArray.count
                                            self.myCarsCollectionView.reloadData()
                                        }
                                        
                                    }
                                
                                }
                             }
                             catch let error as NSError {
                             NSLog("Unresolved error \(error), \(error.userInfo)")
                             }
                        }
                        else {
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK".localized(self.language!) as NSString)
                            }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VehicleDetails" {
            let indexPath = sender as! IndexPath
            let vehicleDetails = (segue.destination as! VehicleDetailsViewController)
            vehicleDetails.vehiclesDetailsDict = self.vehiclesArray[(indexPath as NSIndexPath).row] as! NSDictionary
        }
        else if segue.identifier == "XTime" {
            let vehiclesList = (segue.destination as! VehiclesViewController)
            vehiclesList.fromXTime = true
        }
    }

}
