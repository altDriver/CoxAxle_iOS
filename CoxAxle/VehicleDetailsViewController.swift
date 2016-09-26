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
import MSSimpleGauge
import SDWebImage

class VehicleDetailsViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertController_UIAlertView {
    
    let vehicleBannerReuseIdentifier = "VehicleBannerCell"
    let vehicleReuseIdentifier = "VehicleNormalCell"
    let vehicleButtonReuseIdentifier = "VehicleButtonCell"
    let vehicleProgressReuseIdentifier = "VehicleProgressReuseIdentifier"
    let vehicleDocumentReuseIdentifier = "VehicleDocumentReuseIdentifier"
    let vehicleContactReuseIdentifier = "VehicleContactReuseIdentifier"
    let vehicleCollectionViewCellReuseIdentifier = "VehicleCollectionViewCell"
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var valueArcLayer: MSGradientArcLayer!
    
    @IBOutlet var tableView: UITableView!
    var bannerCollectionView: UICollectionView!
    var pageControl: UIPageControl!
    var language: String?
    var sessionPasswordField: UITextField!
    @IBOutlet var progressBar: YLProgressBar!
    
    var vehiclesDetailsDict: NSDictionary!
    var vehicleImagesArray = [AnyObject]()
    let needleView = MSNeedleView(frame: CGRect(x: 0, y: 0, width: 8, height: 40))
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "VehicleDetailsViewController"
        self.setText()
        print(self.vehiclesDetailsDict)
        self.vehicleImagesArray = self.vehiclesDetailsDict.value(forKey: "vechicle_image") as! Array<AnyObject>
        //self.callEditVehiclesAPI()
        self.setProgressBarProperties()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "SessionExpired")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.bool(forKey: "CALL_API") {
            UserDefaults.standard.set(false, forKey: "CALL_API")
            UserDefaults.standard.synchronize()
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
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        
    }
    
    //MARK:- UIBUTTONS ACTIONS
    func openBrowserButtonClicked() -> Void {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: "CarManualWebView", sender: nil)
        }
    }
    
    @IBAction func editVehicleButtonClicked(_ sender: AnyObject) {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: "editVehicleView", sender: nil)
        }
    }
    
    //MARK:- SET PROGRESS BAR
    func setProgressBarProperties() {
        
        self.progressBar.type           = .flat
        self.progressBar.trackTintColor = UIColor.SlateColor().withAlphaComponent(0.4)
        
        let titleLabel             = UILabel(frame: CGRect(x:  0, y: 0, width: screenWidth/2, height: 15))
        titleLabel.text            = "Vehicle Profile: 50%"
        titleLabel.textAlignment   = .right
        titleLabel.font            = UIFont.boldFont().withSize(10)
        titleLabel.backgroundColor = UIColor.orange
        titleLabel.textColor       = UIColor.white
        
        self.progressBar.addSubview(titleLabel)
    }
    
    //MARK:- UITABLEVIEW DATA SOURCE METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleBannerReuseIdentifier) as! VehicleDetailsTableViewCell!
            
            cell?.vehicleBannerCollectionView.backgroundColor = UIColor.WhiteColor()
            
            self.bannerCollectionView = cell?.vehicleBannerCollectionView
            self.pageControl = cell?.vehicleDetailsPageControl
            self.pageControl.numberOfPages = self.vehicleImagesArray.count
            return cell!
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleButtonReuseIdentifier) as UITableViewCell!
                return cell!
                
            default:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleReuseIdentifier) as UITableViewCell!
                return cell!
            }
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleProgressReuseIdentifier) as! VehicleProgressTableViewCell!
            
            //MONTHS
            let warrentyFromDate = self.vehiclesDetailsDict.value(forKey: "waranty_from") as! String
            let warrentyToDate = self.vehiclesDetailsDict.value(forKey: "waranty_to") as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            let date1 = dateFormatter.date(from: warrentyFromDate)
            let date2 = dateFormatter.date(from: warrentyToDate)
            
            var months: Float = 0
            if let firstDate = date1 , let secondDate = date2 {
                
                months = Float(calculateNumberOfMonthsFromDates(firstDate, secondDate: secondDate))
            }
            let monthsPercentage = (months / 36) * 100
            
            //            let monthsProgressViewWidth: CGFloat = cell!.monthsProgressView.frame.size.width
            //            let monthsProgressViewHeight: CGFloat = cell!.monthsProgressView.frame.size.height
            
            let monthsIndicator = MSSimpleGauge(frame: CGRect(x: 0, y: 20, width: (screenWidth/2) - 30, height: (screenWidth/3)))
            monthsIndicator.fillArcFillColor = UIColor.PumpkinColor()
            monthsIndicator.backgroundArcFillColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
            monthsIndicator.backgroundGradient = nil
            monthsIndicator.needleView.needleColor = UIColor.PumpkinColor()
            
            monthsIndicator.startAngle = 0
            monthsIndicator.endAngle = 180
            monthsIndicator.value = Float(monthsPercentage)
            
            monthsIndicator.arcThickness = 20
            cell?.monthsProgressView.addSubview(monthsIndicator)
            
            let monthsCompletedLabel = UILabel(frame: CGRect(x: 0,y: 5,width: (screenWidth/2) - 30,height: 45))
            monthsCompletedLabel.numberOfLines = 0
            monthsCompletedLabel.textAlignment = .center
            
            let monthsAttributedString = NSMutableAttributedString()
            let monthsAttributes = [NSFontAttributeName : UIFont.boldFont().withSize(20), NSForegroundColorAttributeName : UIColor.PumpkinColor()]
            let monthsString = NSMutableAttributedString(string: "\(Int(months))", attributes: monthsAttributes)
            monthsAttributedString.append(monthsString)
            let newLineString = NSMutableAttributedString(string: "\n", attributes: monthsAttributes)
            monthsAttributedString.append(newLineString)
            let monthsCompletedAttributes = [NSFontAttributeName : UIFont.regularFont().withSize(12), NSForegroundColorAttributeName : UIColor.init(red: 146/255.0, green: 149/255.0, blue: 150/255.0, alpha: 1)]
            let monthsCompletedString = NSMutableAttributedString(string: "months completed", attributes: monthsCompletedAttributes)
            monthsAttributedString.append(monthsCompletedString)
            monthsCompletedLabel.attributedText = monthsAttributedString
            cell?.monthsProgressView.addSubview(monthsCompletedLabel)
            
            //MILES
            var mileage = ((self.vehiclesDetailsDict.value(forKey: "mileage")!) as AnyObject).floatValue
            
            let mileagePercentage = Float((Float(mileage!) / 36000) * 100)
            
            if mileage == nil {
                mileage = 0
            }
            
            //            let milesProgressViewWidth: CGFloat = cell!.monthsProgressView.frame.size.width
            //            let milesProgressViewHeight: CGFloat = cell!.monthsProgressView.frame.size.height
            
            let milesIndicator = MSSimpleGauge(frame: CGRect(x: 10, y: 20, width: (screenWidth/2) - 30, height: (screenWidth/3)))
            milesIndicator.fillArcFillColor = UIColor.AzureColor()
            milesIndicator.backgroundArcFillColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
            milesIndicator.backgroundGradient = nil
            milesIndicator.needleView.needleColor = UIColor.AzureColor()
            
            milesIndicator.startAngle = 0
            milesIndicator.endAngle = 180
            milesIndicator.value = Float(mileagePercentage)
            
            milesIndicator.arcThickness = 20
            cell?.milesProgressView.addSubview(milesIndicator)
            
            let milesCompletedLabel = UILabel(frame: CGRect(x: 10,y: 5,width: (screenWidth/2) - 30,height: 45))
            milesCompletedLabel.numberOfLines = 0
            milesCompletedLabel.textAlignment = .center
            let milesAttributedString = NSMutableAttributedString()
            let milessAttributes = [NSFontAttributeName : UIFont.boldFont().withSize(20), NSForegroundColorAttributeName : UIColor.AzureColor()]
            let milesString = NSMutableAttributedString(string: "\(Int(mileage!))", attributes: milessAttributes)
            milesAttributedString.append(milesString)
            let newLinesString = NSMutableAttributedString(string: "\n", attributes: monthsAttributes)
            milesAttributedString.append(newLinesString)
            let milesCompletedAttributes = [NSFontAttributeName : UIFont.regularFont().withSize(12), NSForegroundColorAttributeName : UIColor.init(red: 146/255.0, green: 149/255.0, blue: 150/255.0, alpha: 1)]
            let milesCompletedString = NSMutableAttributedString(string: "miles completed", attributes: milesCompletedAttributes)
            milesAttributedString.append(milesCompletedString)
            milesCompletedLabel.attributedText = milesAttributedString
            cell?.milesProgressView.addSubview(milesCompletedLabel)
            
            cell?.isUserInteractionEnabled = false
            
            return cell!
            
        case 3:
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell!.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell!.viewWithTag(102) as! UILabel
                
                cellTitle.text = "Vehicle identification no. (VIN)"
                cellSubTitle.text = self.vehiclesDetailsDict.value(forKey: "vin") as? String
                cell?.isUserInteractionEnabled = false
                return cell!
                
            case 1:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell!.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell!.viewWithTag(102) as! UILabel
                
                cellTitle.text = "Tag expiration"
                let tagDate = self.vehiclesDetailsDict.value(forKey: "tag_expiration_date") as! String
                cellSubTitle.text = tagDate.convertDateToString()
                cell?.isUserInteractionEnabled = false
                return cell!
            default:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell!.viewWithTag(101) as! UILabel
                let cellSubTitle: UILabel = cell!.viewWithTag(102) as! UILabel
                
                cellTitle.text = ""
                cellSubTitle.text = ""
                return cell!
            }
            
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleDocumentReuseIdentifier) as! VehicleDocumentTableViewCell
            
            let cellTitle: UILabel = cell.viewWithTag(111) as! UILabel
            cellTitle.text = "Insurance"
            //            let cellSubTitle: UIImageView = cell.viewWithTag(112) as! UIImageView
            
            //   let imageURLString = vehicleImagesArray[0].valueForKey("image_url") as! NSString
            
            //            cell.vehicleDocumentThumbnailImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
            //                cell.imageView!.alpha = 1;
            //
            //                }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
            
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleDocumentReuseIdentifier) as! VehicleDocumentTableViewCell
            
            let cellTitle: UILabel = cell.viewWithTag(111) as! UILabel
            cellTitle.text = "Extended Warranty"
            //            let cellSubTitle: UIImageView = cell.viewWithTag(112) as! UIImageView
            
            //     let imageURLString = vehicleImagesArray[0].valueForKey("image_url") as! NSString
            
            //                cell.vehicleDocumentThumbnailImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
            //                    cell.imageView!.alpha = 1;
            //
            //                    }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
            
        case 6:
            switch (indexPath as NSIndexPath).row {
            case 0:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleContactReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell!.viewWithTag(121) as! UILabel
                let cellSubTitle: UIButton = cell!.viewWithTag(122) as! UIButton
                
                cellTitle.text = "Car Manual"
                cellSubTitle.setImage(UIImage(named: "openInBrowserIcon"), for: UIControlState())
                cellSubTitle.addTarget(self, action: #selector(self.openBrowserButtonClicked), for: UIControlEvents.touchUpInside)
                return cell!
            case 1:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleContactReuseIdentifier) as UITableViewCell!
                let cellTitle: UILabel = cell!.viewWithTag(121) as! UILabel
                let cellSubTitle: UIButton = cell!.viewWithTag(122) as! UIButton
                
                cellTitle.text = "Roadside Assistance"
                cellSubTitle.setImage(UIImage(named: "roadAssistanceIcon"), for: UIControlState())
                return cell!
                
            default:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleContactReuseIdentifier) as UITableViewCell!
                return cell!
            }
            
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: vehicleBannerReuseIdentifier) as! VehicleDetailsTableViewCell!
            return cell!
        }
        
    }
    
    //    func rotateNeedleByAngle(angle: Float) {
    //        var rotatedTransform = self.needleView.layer.transform
    //        rotatedTransform = CATransform3DRotate(rotatedTransform, CGFloat((3.14 / 180) * (angle)), 0.0, 0.0, 1.0)
    //        self.needleView.layer.transform = rotatedTransform
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0:
            return 369
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                return 60
            default:
                return 0
            }
        case 2:
            return 230
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.00002
        default:
            return 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    // MARK:- CALCULATE MILES/MONTHS REMAINING
    
    func calculateNumberOfMonthsFromDates(_ firstDate: Date, secondDate: Date) -> CGFloat {
        
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: [])
        
        return CGFloat(components.day! / 30)
    }
    
    func calculateMonthsRemainingPercentage(_ warrentyMonthsUsed: Float) -> Float {
        
        let remainingMonthsPercentage = (warrentyMonthsUsed / 36) * 100
        
        return remainingMonthsPercentage
    }
    
    func calculateMilesRemainingPercentage(_ warrentyMilesUsed: Int, totalWarrentyMiles: Int) -> Int {
        
        let remainingMilesPercentage = (warrentyMilesUsed / totalWarrentyMiles) * 100
        
        return remainingMilesPercentage
    }
    
    // MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicleImagesArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let position: CGSize = CGSize(width: self.view.frame.size.width, height: 369)
        
        return position
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vehicleCollectionViewCellReuseIdentifier, for: indexPath) as! VehicleDetailsCollectionViewCell
        
        let imageURLString = self.vehicleImagesArray[(indexPath as NSIndexPath).row].value(forKey: "image_url") as! NSString
         cell.vehicleImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        cell.vehicleTitle.text = self.vehiclesDetailsDict.value(forKey: "name") as? String
        cell.vehicleName.text = String(format: "%@ %@ • %@", (self.vehiclesDetailsDict.value(forKey: "year") as? String)!, (self.vehiclesDetailsDict.value(forKey: "model") as? String)!, (self.vehiclesDetailsDict.value(forKey: "mileage") as? String)!)
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UISCROLLVIEW DELEGATE METHODS
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.width
        self.pageControl.currentPage = Int(bannerCollectionView.contentOffset.x / pageWidth)
    }
    
    //MARK:- VEHICLE DETAILS API
    
    func fetchVehicleDetails() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Vehicle Details API Called", label: "Fetching Vehicle Details", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let paramsDict: [ String : String] = ["vid": "7", "uid": "21"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/view", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
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
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editVehicleView" {
            
            let editVehicleViewController = (segue.destination as! EditVehicleViewController)
            editVehicleViewController.vehiclesDetailsDictionary = vehiclesDetailsDict
        }
        
        if segue.identifier == "CarManualWebView" {
            let manualWebView = (segue.destination as! WebViewController)
            manualWebView.webViewUrl = "http://www.coxenterprises.com/cox-companies/automotive.aspx#.V8_ASJN96NY"
        }
    }
    
    
}
