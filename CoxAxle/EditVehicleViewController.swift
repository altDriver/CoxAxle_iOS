//
//  EditVehicleViewController.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 09/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import YLProgressBar
import LGSemiModalNavController
import BRImagePicker

class EditVehicleViewController: UIViewController, UIAlertController_UIAlertView, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var progressBar               : YLProgressBar!
    @IBOutlet weak var addVehicleTableView  : UITableView!
    
    let semiModalViewController = LGSemiModalNavViewController()
    var imageView               = UIImageView()
    var imagePicker             = UIImagePickerController()
    let datesTableView          = UITableView()
    let vehicleMakeTableView    = UITableView()
    let vehiclesModelTableView  = UITableView()
    
    var newButton: UIButton!
    var usedButton: UIButton!
    var cpoButton: UIButton!
    var vehicleImagesArray: [AnyObject] = []
    var insuranceCardImagesArray = [UIImage]()
    
    var language                 : String?
    var vehicleName              : String?
    var vinNumber                : String?
    var milesDriven              : String?
    var vehiclePurchasedYear     : String?
    var vehicleMake              : String?
    var vehicleModel             : String?
    var tagExpirationDate        : String?
    var selectedVehicleType      : String?
    var selectedYear             : String?
    var selectedVehicleMake      : String?
    var selectedVehicleModel     : String?
    var insuranceExpirationDate  : String?
    var selectedTagExpirationDate: String?
    var vehicleImagesBase64String: String?
    var isValidationSuccess      : Bool?
    var isInsuranceCardSelected  : Bool?
    var vehicleImage             : UIImage?
    var vehiclesDetailsDictionary: NSDictionary?
    var editedVehicleImagesBase64String         : String?
    var oldVehicleImageBase64String             : String?
    var selectedInsuranceExpirationDate         : String?
    var isTagExpirationDatePickerSelected       : Bool?
    var isInsuranceExpirationDatePickerSelected : Bool?
    
    var vinTextField: UITextField!
    var vehicleNameTextField: UITextField!
    var milesDrivenTextField: UITextField!
    
    let yearsArray = ["2011", "2012", "2013", "2014", "2015", "2016"]
    let vehicleMakeArray = ["Accent", "Azera", "Elantra", "Santa Fe Sports", "Mrecedes", "Land Rover"]
    let vehiclesModelArray = ["Accent A2S", "Elantra EL1", "Santa Fe Sports SaFeX", "Mrecedes MQn", "Land Rover"]
    
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newButton  = UIButton()
        usedButton = UIButton()
        cpoButton  = UIButton()
        
        self.parseVehicleDetailsDictionary()
        self.setProgressBarProperties()
        self.setText()
        print(vehiclesDetailsDictionary!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseVehicleDetailsDictionary() {
        
        vehicleImagesArray = (vehiclesDetailsDictionary?.valueForKey("vechicle_image")!)! as! [UIImage]
        //        insuranceCardImagesArray = (vehiclesDetailsDictionary?.valueForKey("insurance_document")!)! as! [UIImage]
        vehicleName = vehiclesDetailsDictionary?.valueForKey("name") as? String
        selectedVehicleType = vehiclesDetailsDictionary?.valueForKey("vehicle_type") as? String
        vinNumber = vehiclesDetailsDictionary?.valueForKey("vin") as? String
        vehiclePurchasedYear = vehiclesDetailsDictionary?.valueForKey("year") as? String
        vehicleMake = vehiclesDetailsDictionary?.valueForKey("make") as? String
        vehicleModel = vehiclesDetailsDictionary?.valueForKey("model") as? String
        milesDriven = vehiclesDetailsDictionary?.valueForKey("mileage") as? String
        selectedTagExpirationDate = (vehiclesDetailsDictionary?.valueForKey("tag_expiration_date") as? String)?.convertDateToString()
        selectedInsuranceExpirationDate = (vehiclesDetailsDictionary?.valueForKey("insurance_expiration_date") as? String)?.convertDateToString()
    }
    
    func setText() -> Void {
        
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
    }
    
    func setProgressBarProperties() {
        
        progressBar.type           = .Flat
        self.progressBar.trackTintColor = UIColor.SlateColor().colorWithAlphaComponent(0.4)
        progressBar.hideStripes    = true
        
        let titleLabel             = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth / 4, height: 15))
        titleLabel.text            = "Step 1 of 4"
        titleLabel.textAlignment   = .Center
        titleLabel.font            = UIFont.boldFont().fontWithSize(10)
        titleLabel.backgroundColor = UIColor.orangeColor()
        titleLabel.textColor       = UIColor.whiteColor()
        
        progressBar.addSubview(titleLabel)
    }
    
    //MARK:- TABLEVIEW METHODS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 0 : return 13
        case 1 : return yearsArray.count
        case 2 : return vehicleMakeArray.count
        case 3 : return vehiclesModelArray.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        tableView.showsVerticalScrollIndicator = false
        
        switch tableView.tag {
            
        case 0:
            
            switch (indexPath.row) {
                
            case 0:
                
                let addVehicleImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddVehicleImageTableViewCell", forIndexPath: indexPath) as! AddVehicleImageTableViewCell
                
                addVehicleImageTableViewCell.uploadVehiclePictureButton.addTarget(self, action: #selector(EditVehicleViewController.uploadVehiclePic), forControlEvents: .TouchUpInside)
                let imagesArray = vehicleImagesArray as NSArray
                let imageURLString = imagesArray[0].valueForKey("image_url") as! NSString
                addVehicleImageTableViewCell.vehicleImageView.setImageWithURL(NSURL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, url) -> Void in
                    addVehicleImageTableViewCell.vehicleImageView.alpha = 1;
                    
                    }, usingActivityIndicatorStyle: UIActivityIndicatorViewStyle(rawValue: 2)!)
                
                cell = addVehicleImageTableViewCell
                
            case 1:
                
                let vehicleNameTableViewCell = tableView.dequeueReusableCellWithIdentifier("VehicleNameTableViewCell", forIndexPath: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .No
                
                self.vehicleNameTextField = vehicleNameTableViewCell.vehicleNameTextField
                
                guard let name = (self.vehicleNameTextField.text) where name != "" else {
                    
                    vehicleNameTableViewCell.vehicleNameTextField.text = vehicleName
                    cell = vehicleNameTableViewCell
                    break
                }
                vehicleNameTableViewCell.vehicleNameTextField.text = name
                
                cell = vehicleNameTableViewCell
                
            case 2:
                
                let vehicleTypeTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewUsedTableViewCell", forIndexPath: indexPath) as! VehicleTypeTableViewCell
                
                newButton = vehicleTypeTableViewCell.newVehicleButton
                usedButton = vehicleTypeTableViewCell.usedVehicleButton
                cpoButton = vehicleTypeTableViewCell.CPOVehicleButton
                
                if selectedVehicleType! == "New" || selectedVehicleType! == "NEW" {
                    selectedButtonProperties(newButton)
                    deselectOtherButtons(usedButton, button2: cpoButton)
                } else
                    if selectedVehicleType! == "Used" || selectedVehicleType! == "USED" {
                        selectedButtonProperties(usedButton)
                        deselectOtherButtons(newButton, button2: cpoButton)
                    } else
                        if selectedVehicleType! == "cpo" || selectedVehicleType! == "CPO" {
                            selectedButtonProperties(cpoButton)
                            deselectOtherButtons(newButton, button2: usedButton)
                }
                
                vehicleTypeTableViewCell.newVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.newVehicleTypeSelected), forControlEvents: .TouchUpInside)
                vehicleTypeTableViewCell.usedVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.usedVehicleTypeSelected), forControlEvents: .TouchUpInside)
                vehicleTypeTableViewCell.CPOVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.cpoVehicleTypeSelected), forControlEvents: .TouchUpInside)
                
                if vehicleTypeTableViewCell.newVehicleButton != nil {
                    vehicleTypeTableViewCell.newVehicleButton = newButton
                }
                if vehicleTypeTableViewCell.usedVehicleButton != nil {
                    vehicleTypeTableViewCell.usedVehicleButton = usedButton
                }
                if vehicleTypeTableViewCell.CPOVehicleButton != nil {
                    vehicleTypeTableViewCell.CPOVehicleButton = cpoButton
                }
                
                cell = vehicleTypeTableViewCell
                
            case 3:
                
                let vinTableViewCell = tableView.dequeueReusableCellWithIdentifier("VINTableViewCell", forIndexPath: indexPath) as! VehicleDetailTableViewCell
                
                let findVinButtonAttrinutes = [
                    NSFontAttributeName : UIFont.systemFontOfSize(11),
                    NSUnderlineStyleAttributeName : 1]
                let attributedString = NSMutableAttributedString(string:"")
                
                let buttonTitleString = NSMutableAttributedString(string:"Find My VIN", attributes: findVinButtonAttrinutes)
                vinTableViewCell.findMyVinButton.titleLabel?.numberOfLines = 2
                attributedString.appendAttributedString(buttonTitleString)
                vinTableViewCell.findMyVinButton.setAttributedTitle(attributedString, forState: .Normal)
                
                vinTableViewCell.findMyVinButton.addTarget(self, action: #selector(EditVehicleViewController.findMyVinNumber), forControlEvents: .TouchUpInside)
                
                vinTableViewCell.vinTextField.autocorrectionType = .No
                
                if let vin = vinNumber {
                    vinTableViewCell.vinTextField.text = vin
                }
                else {
                    
                    vinNumber = vinTableViewCell.vinTextField.text
                }
                vinTableViewCell.vinTextField.userInteractionEnabled = false
                self.vinTextField = vinTableViewCell.vinTextField
                cell = vinTableViewCell
                
            case 4:
                
                let selectYearTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectYearTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectYearTableViewCell.selectYearButton.addTarget(self, action: #selector(EditVehicleViewController.selectDate), forControlEvents: .TouchUpInside)
                
                if let purchasedYear = selectedYear {
                    selectYearTableViewCell.selectYearButton.setTitle(String(purchasedYear), forState: .Normal)
                } else {
                    selectYearTableViewCell.selectYearButton.setTitle(String(vehiclePurchasedYear!), forState: .Normal)
                }
                
                vehiclePurchasedYear = selectYearTableViewCell.selectYearButton.titleLabel?.text
                
                cell = selectYearTableViewCell
                
            case 5:
                
                let selectMakeTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectMakeTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectMakeTableViewCell.selectVehicleMakeButton.addTarget(self, action: #selector(EditVehicleViewController.selectVehicleMake), forControlEvents: .TouchUpInside)
                
                if let make = selectedVehicleMake {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(make), forState: .Normal)
                } else {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(vehicleMake!), forState: .Normal)
                }
                
                vehicleMake = selectMakeTableViewCell.selectVehicleMakeButton.titleLabel?.text
                
                cell = selectMakeTableViewCell
                
            case 6:
                
                let selectModelTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectModelTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectModelTableViewCell.selectVehicleModelButton.addTarget(self, action: #selector(EditVehicleViewController.selectVehicleModel), forControlEvents: .TouchUpInside)
                
                if let model = selectedVehicleModel {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(model), forState: .Normal)
                } else {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(vehicleModel!), forState: .Normal)
                }
                
                vehicleModel = selectModelTableViewCell.selectVehicleModelButton.titleLabel?.text
                
                cell = selectModelTableViewCell
                
            case 7:
                
                let milesDrivenTableViewCell = tableView.dequeueReusableCellWithIdentifier("MilesDrivenTableViewCell", forIndexPath: indexPath) as! VehicleDetailTableViewCell
                
                self.milesDrivenTextField = milesDrivenTableViewCell.milesDrivenTextField
                
                guard let name = (self.milesDrivenTextField.text) where name != "" else {
                    
                    milesDrivenTableViewCell.milesDrivenTextField.text = milesDriven
                    cell = milesDrivenTableViewCell
                    break
                }
                milesDrivenTableViewCell.milesDrivenTextField.text = name
                
                cell = milesDrivenTableViewCell
                
            case 8:
                
                let tagExpirationTableViewCell = tableView.dequeueReusableCellWithIdentifier("tagExpirationDateCell", forIndexPath: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                tagExpirationTableViewCell.leftLabel.text = "Tag Expiration"
                
                if let date = selectedTagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(String(date), forState: .Normal)
                }
                if let tagExpireDate = tagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(tagExpireDate, forState: .Normal)
                }
                tagExpirationTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(EditVehicleViewController.selectTagExpirationDate), forControlEvents: .TouchUpInside)
                
                cell = tagExpirationTableViewCell
                
            case 9:
                
                let datePickerTableViewCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerTableViewCell
                
                datePickerTableViewCell.doneButton.addTarget(self, action: #selector(EditVehicleViewController.tagPickerDoneButtonAction), forControlEvents: .TouchUpInside)
                
                cell = datePickerTableViewCell
                
            case 10:
                
                let vehicleInsuranceDetailsTableViewCell: VehicleInsuranceDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("InsuranceExpirationDateCell", forIndexPath: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                if let date = selectedInsuranceExpirationDate {
                    
                    vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(String(date), forState: .Normal)
                }
                
                if let insuranceExpireDate = insuranceExpirationDate {
                    
                    vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(insuranceExpireDate, forState: .Normal)
                }
                
                vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(EditVehicleViewController.selectInsuranceExpirationDate), forControlEvents: .TouchUpInside)
                
                cell = vehicleInsuranceDetailsTableViewCell
                
            case 11:
                
                let insuranceDatePickerTableViewCell: DatePickerTableViewCell = tableView.dequeueReusableCellWithIdentifier("insuranceDatePickerCell", forIndexPath: indexPath) as! DatePickerTableViewCell
                
                insuranceDatePickerTableViewCell.doneButton.addTarget(self, action: #selector(EditVehicleViewController.insurancePickerDoneButtonAction), forControlEvents: .TouchUpInside)
                cell = insuranceDatePickerTableViewCell
                
            case 12:
                
                let insuranceCardTableViewCell: InsuranceCardTableViewCell = tableView.dequeueReusableCellWithIdentifier("InsuranceCardTableViewCell", forIndexPath: indexPath) as! InsuranceCardTableViewCell
                insuranceCardTableViewCell.uploadInsuranceCardPictureButton.addTarget(self, action: #selector(EditVehicleViewController.uploadInsuranceCardPic), forControlEvents: .TouchUpInside)
                
                insuranceCardTableViewCell.insuranceCardsCollectionView.reloadData()
                
                cell = insuranceCardTableViewCell
                
            default:
                return cell
            }
            
        case 1:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
            cell.selectionStyle = .None
            let dateLabel = UILabel(frame: CGRect(x: 21, y: 20, width: screenWidth/2, height: 21))
            dateLabel.font = UIFont.regularFont().fontWithSize(17)
            dateLabel.textColor = UIColor.SlateColor()
            dateLabel.text = String(yearsArray[indexPath.row])
            cell.addSubview(dateLabel)
            dateLabel.tag = -1
            
            let checkBoxButton = UIButton(frame: CGRect(x: screenWidth - 40, y: 18, width: 25, height: 25))
            checkBoxButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            checkBoxButton.layer.cornerRadius = 0.5 * checkBoxButton.bounds.size.width
            checkBoxButton.tag = indexPath.row
            
            checkBoxButton.addTarget(self, action: #selector(EditVehicleViewController.yearSelected(_:)), forControlEvents: .TouchUpInside)
            
            cell.addSubview(checkBoxButton)
            
        case 2:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
            cell.selectionStyle = .None
            let vehicleMakeLabel = UILabel(frame: CGRect(x: 21, y: 20, width: screenWidth/2, height: 21))
            vehicleMakeLabel.font = UIFont.regularFont().fontWithSize(17)
            vehicleMakeLabel.textColor = UIColor.SlateColor()
            vehicleMakeLabel.text = String(vehicleMakeArray[indexPath.row])
            cell.addSubview(vehicleMakeLabel)
            
            let checkBoxButton = UIButton(frame: CGRect(x: screenWidth - 40, y: 18, width: 25, height: 25))
            checkBoxButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            checkBoxButton.layer.cornerRadius = 0.5 * checkBoxButton.bounds.size.width
            checkBoxButton.tag = indexPath.row
            checkBoxButton.addTarget(self, action: #selector(EditVehicleViewController.vehicleMakeSelected(_:)), forControlEvents: .TouchUpInside)
            
            cell.addSubview(checkBoxButton)
            
        case 3:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
            cell.selectionStyle = .None
            let vehicleModelLabel = UILabel(frame: CGRect(x: 21, y: 20, width: screenWidth/2, height: 21))
            vehicleModelLabel.font = UIFont.regularFont().fontWithSize(17)
            vehicleModelLabel.textColor = UIColor.SlateColor()
            vehicleModelLabel.text = String(vehiclesModelArray[indexPath.row])
            cell.addSubview(vehicleModelLabel)
            
            let checkBoxButton = UIButton(frame: CGRect(x: screenWidth - 40, y: 18, width: 25, height: 25))
            checkBoxButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            checkBoxButton.layer.cornerRadius = 0.5 * checkBoxButton.bounds.size.width
            checkBoxButton.tag = indexPath.row
            checkBoxButton.addTarget(self, action: #selector(EditVehicleViewController.vehicleModelSelected(_:)), forControlEvents: .TouchUpInside)
            
            cell.addSubview(checkBoxButton)
            
        default:
            return cell
        }
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.tag == 0 {
            switch indexPath.row {
            case 0: return 200
            case 9: return isTagExpirationDatePickerSelected == true ? 290 : 0
            case 11: return isInsuranceExpirationDatePickerSelected == true ? 290 : 0
            case 12: return 130
            default: return 60
            }
        }
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.tag == 0 ? 0 : 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenHeight, height: 60))
        prepareModalViewTitleLabel(titleLabel)
        
        switch tableView.tag {
            
        case 0: return UIView(frame: CGRectZero)
        case 1: titleLabel.text = "Select Year"
        return titleLabel
        case 2: titleLabel.text = "Select Make"
        return titleLabel
        case 3: titleLabel.text = "Select Model"
        return titleLabel
        default: return UIView(frame: CGRectZero)
        }
    }
    
    func prepareModalViewTitleLabel(titleLabel: UILabel) {
        
        titleLabel.textAlignment   = .Center
        titleLabel.font            = UIFont.boldFont().fontWithSize(17)
        titleLabel.textColor       = UIColor.SlateColor()
        titleLabel.backgroundColor = UIColor.whiteColor()
    }
    
    //MARK:- COLLECTION VIEW METHODS
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return insuranceCardImagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let insuranceCardsCollectionViewCell: InsuranceCardsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("InsuranceCardsCollectionViewCell", forIndexPath: indexPath) as! InsuranceCardsCollectionViewCell
        
        insuranceCardsCollectionViewCell.insuranceCardsImageView.tag = indexPath.row
        insuranceCardsCollectionViewCell.removeCardButton.tag = indexPath.row
        
        insuranceCardsCollectionViewCell.insuranceCardsImageView.image = insuranceCardImagesArray[indexPath.row]
        
        return insuranceCardsCollectionViewCell
    }
    
    //MARK:- ACTION SELECTOR METHODS
    
    func tagPickerDoneButtonAction() {
        
        isTagExpirationDatePickerSelected = false
        
        if tagExpirationDate == nil || tagExpirationDate == "Select Date" || tagExpirationDate?.characters.count == 0 {
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.stringFromDate(date)
            tagExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func insurancePickerDoneButtonAction() {
        
        isInsuranceExpirationDatePickerSelected = false
        
        if insuranceExpirationDate == nil || insuranceExpirationDate == "Select Date" || insuranceExpirationDate?.characters.count == 0 {
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.stringFromDate(date)
            insuranceExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func selectTagExpirationDate() {
        
        isTagExpirationDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 9, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func selectInsuranceExpirationDate() {
        
        isInsuranceExpirationDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 11, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func newVehicleTypeSelected() {
        
        selectedButtonProperties(newButton)
        deselectOtherButtons(usedButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func usedVehicleTypeSelected() {
        
        selectedButtonProperties(usedButton)
        deselectOtherButtons(newButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func cpoVehicleTypeSelected() {
        
        selectedButtonProperties(cpoButton)
        deselectOtherButtons(newButton, button2: usedButton)
        addVehicleTableView.reloadData()
    }
    
    func selectedButtonProperties(sender: UIButton) {
        
        sender.backgroundColor  = UIColor.vehicleTypeSelectedButtonBackgroundColor()
        sender.tintColor        = UIColor.SlateColor()
        sender.titleLabel?.font = UIFont.boldFont().fontWithSize(17)
        
        if sender.tag == 0 {
            selectedVehicleType     = "New"
        }
        
        if sender.tag == 1 {
            selectedVehicleType     = "Used"
        }
        
        if sender.tag == 2 {
            selectedVehicleType     = "CPO"
        }
    }
    
    func deselectOtherButtons(button1: UIButton, button2: UIButton) {
        
        button1.selected         = false
        button2.selected         = false
        button1.backgroundColor  = UIColor.whiteColor()
        button2.backgroundColor  = UIColor.whiteColor()
        button1.titleLabel?.font = UIFont.regularFont().fontWithSize(17)
        button2.titleLabel?.font = UIFont.regularFont().fontWithSize(17)
    }
    
    func findMyVinNumber() {
        
        let findMyVinViewController: FindMyVinViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FindMyVinView") as! FindMyVinViewController
        self.presentViewController(findMyVinViewController, animated: true, completion: nil)
    }
    
    func yearSelected(sender: UIButton) {
        
        selectedYear = yearsArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func vehicleMakeSelected(sender: UIButton) {
        
        selectedVehicleMake = vehicleMakeArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func vehicleModelSelected(sender: UIButton) {
        
        selectedVehicleModel = vehiclesModelArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func dismissModalAfterSelection(sender: UIButton) {
        
        sender.setImage(UIImage(named: "checkbox.png"), forState: .Normal)
        sender.backgroundColor = UIColor.whiteColor()
        addVehicleTableView.reloadData()
        self.semiModalViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UPLOAD IMAGE METHODS
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if isInsuranceCardSelected == false {
            //        if vehicleImagesArray.count == 5  || vehicleImagesArray.count > 5 {
            //
            //            showAlertwithCancelButton("", message: "You can upload upto only Five photos", cancelButton: "OK")
            //            picker.dismissViewControllerAnimated(true, completion: nil)
            //            return
            //        }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            imageView.image = image
            
            vehicleImagesArray.append(image)
            
            vehicleImage = imageView.image
            self.addVehicleTableView.reloadData()
            
        } else {
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            insuranceCardImagesArray.append(image)
            
            self.addVehicleTableView.reloadData()
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        isInsuranceCardSelected = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadVehiclePic() {
        
        //        if vehicleImagesArray.count == 5  || vehicleImagesArray.count > 5 {
        //
        //            showAlertwithCancelButton("Error", message: "You can upload upto only Five photos", cancelButton: "OK")
        //            return
        //        }
        
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.SlateColor()
        self.presentViewController(alert, animated: true, completion: nil)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .PhotoLibrary
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadInsuranceCardPic() {
        
        isInsuranceCardSelected = true
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.SlateColor()
        self.presentViewController(alert, animated: true, completion: nil)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .PhotoLibrary
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker
    
    func openGallery() {
        
        var imagesArray = [UIImage]()
        let imagePicker = BRImagePicker(presentingController: self)
        
        imagePicker.showPickerWithDataBlock({(data: [AnyObject]!) -> Void in
           
            for index in 0...data.count - 1 {
                imagesArray.append(data[index].image)
            }
            
            var base64ImagesArray = [String]()

            for index in 0...(imagesArray.count - 1) {
                
                let eachImage: UIImage = imagesArray[index]
                let eachImageData = NSData(data: UIImagePNGRepresentation(eachImage)!)
                let base64ImageString: String = eachImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                base64ImagesArray.append(base64ImageString)
            }
            self.editedVehicleImagesBase64String = base64ImagesArray.joinWithSeparator(",")
        })
    }
    
    //MARK:- UIBUTTON METHODS
    
    @IBAction func deleteVehicleButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this vehicle?", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.callDeleteVehicleAPI()
        })
        alertController.addAction(defaultAction)
        
        let otherAction = UIAlertAction(title: "NO", style: .Default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(otherAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.validateFields()
        self.callEditVehiclesAPI()
    }
    
    @IBAction func removeCard(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.insuranceCardImagesArray.removeAtIndex(sender.tag)
            self.addVehicleTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func validateFields() {
        
        if vehicleName?.isEmpty == true {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please enter vehicle name", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if milesDriven?.isEmpty == true {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please enter miles driven", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
    }
    
    func selectDate() {
        
        datesTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(1, tableView: datesTableView)
    }
    
    func selectVehicleMake() {
        
        vehicleMakeTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(2, tableView: vehicleMakeTableView)
    }
    
    func selectVehicleModel() {
        
        vehiclesModelTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(3, tableView: vehiclesModelTableView)
    }
    
    func createSemiModalViewController() {
        
        semiModalViewController.view.frame = CGRect(x: 0, y: screenWidth - 150, width: screenWidth , height: screenHeight - 150)
        
        semiModalViewController.backgroundShadeColor = UIColor.blackColor()
        semiModalViewController.animationSpeed       = 0.35
        semiModalViewController.tapDismissEnabled    = true
        semiModalViewController.backgroundShadeAlpha = 0.4
        semiModalViewController.scaleTransform       = CGAffineTransformMakeScale(1, 1)
    }
    
    func setTableViewPropertiesForModalView(tagValue: Int, tableView: UITableView) {
        
        tableView.tag   = tagValue
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight - 150)
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        semiModalViewController.view.addSubview(tableView)
        self.presentViewController(semiModalViewController, animated: true, completion: { _ in })
    }
    
    @IBAction func datePickerChanged(datePicker: UIDatePicker) {
        
        let date                 = NSDate()
        datePicker.minimumDate   = date
        let dateFormatter        = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString           = dateFormatter.stringFromDate(datePicker.date)
        tagExpirationDate        = dateString
        addVehicleTableView.reloadData()
    }
    
    @IBAction func insuranceDatePickerChanged(datePicker: UIDatePicker) {
        
        let date                 = NSDate()
        datePicker.minimumDate   = date
        let dateFormatter        = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString           = dateFormatter.stringFromDate(datePicker.date)
        insuranceExpirationDate  = dateString
        addVehicleTableView.reloadData()
    }
    
    //MARK:- EDIT VEHICLE API
    
    func callEditVehiclesAPI() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            self.addTracker()
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let vehImgBase64String = self.createVehicleImageBase64String()
            let vehInsuBase64String = self.createVehicleInsuranceBase64String()
            
            let idValuesArray = self.parseIdValues()
            let userId = idValuesArray[0]
            let vin = idValuesArray[1]
            let vehicleId = idValuesArray[2]
            let dealerId = idValuesArray[3]
            
            let vehicleDetailsArray = self.getVehicleDetails()
            let name = vehicleDetailsArray[0]
            let type = vehicleDetailsArray[1]
            let miles = vehicleDetailsArray[2]
            let year = vehicleDetailsArray[3]
            let make = vehicleDetailsArray[4]
            let model = vehicleDetailsArray[5]
            let insuExpirationDate = vehicleDetailsArray[6]
            let tagExpiryDate = vehicleDetailsArray[7]
            
            let paramsDict: [String : AnyObject] = ["vid": vehicleId,
                                                    "name": name,
                                                    "uid": userId,
                                                    "dealer_id": dealerId,
                                                    "vin": vin,
                                                    "vehicle_type": type,
                                                    "make": make,
                                                    "model": model,
                                                    "color": "Silver",
                                                    "photo": vehImgBase64String,
                                                    "waranty_from": "",
                                                    "waranty_to": "",
                                                    "insurance_expiration_date": insuExpirationDate,
                                                    "tag_expiration_date": tagExpiryDate,
                                                    "extended_waranty_from": "",
                                                    "extended_waranty_to": "",
                                                    "kbb_price": "1000",
                                                    "manual": "",
                                                    "loan_amount": "200",
                                                    "emi": "50",
                                                    "interest": "9",
                                                    "loan_tenure": "6",
                                                    "insurance_document": "",
                                                    "mileage": miles,
                                                    "style": "",
                                                    "trim": "",
                                                    "year": year] as Dictionary
            
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/update", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide ()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: EditVehicles = try EditVehicles(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict)
                                let message = JSON.valueForKey("message") as! String
                                self.showUpdateVehicleSuccessAlert(message)
                                
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
        } else {
            self.showInternetFailureAlert()
        }
    }
    
    func addTracker() {
        
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory("API", action: "Edit Vehicle API Called", label: "Edit Vehicle", value: nil).build()
        tracker.send(trackDictionary as AnyObject as! [NSObject : AnyObject])
    }
    
    func parseIdValues() -> [String] {
        
        let userId: String = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as! String
        let vin: String = self.vehiclesDetailsDictionary?.valueForKey("vin") as! String
        let vehicleId: String = (self.vehiclesDetailsDictionary?.valueForKey("id"))! as! String
        let dealerId: String = (self.vehiclesDetailsDictionary?.valueForKey("dealer_id"))! as! String
        
        return [userId, vin, vehicleId, dealerId]
    }
    
    func getVehicleDetails() -> [String] {
        
        let name: String = self.vehicleNameTextField.text!
        let type = String(selectedVehicleType!)
        let miles = milesDrivenTextField != nil ? milesDrivenTextField.text : milesDriven
        let year = selectedYear != nil ? selectedYear : vehiclePurchasedYear
        let make = selectedVehicleMake != nil ? selectedVehicleMake : vehicleMake
        let model = selectedVehicleModel != nil ? selectedVehicleModel : vehicleModel
        let insuExpirationDate = insuranceExpirationDate != nil ? (insuranceExpirationDate!.convertStringToDate()) : (selectedInsuranceExpirationDate?.convertStringToDate())
        let tagExpiryDate = tagExpirationDate != nil ? (tagExpirationDate!.convertStringToDate()) : (selectedTagExpirationDate?.convertStringToDate())
        
        return [name, type, miles!, year!, make!, model!, insuExpirationDate!, tagExpiryDate!]
    }
    
    func createVehicleImageBase64String() -> String {
        
        var base64VehicleImagesArray = [String]()
        for index in 0...(vehicleImagesArray.count - 1) {
            
            let imagePath = vehicleImagesArray[index].valueForKey("image_url")
            let imageData:NSData = imagePath!.dataUsingEncoding(NSUTF8StringEncoding)!
            let imageStringBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            base64VehicleImagesArray.append(imageStringBase64)
        }
        oldVehicleImageBase64String = base64VehicleImagesArray.joinWithSeparator(",")
        
        if editedVehicleImagesBase64String == nil {
            editedVehicleImagesBase64String = ""
        }
        if oldVehicleImageBase64String == nil {
            oldVehicleImageBase64String = ""
        }
        
        if editedVehicleImagesBase64String == "" {
            vehicleImagesBase64String = oldVehicleImageBase64String!
        } else {
            vehicleImagesBase64String = editedVehicleImagesBase64String! + "," + oldVehicleImageBase64String!
        }
        return vehicleImagesBase64String!
    }
    
    func createVehicleInsuranceBase64String() {
        
        //            var base64InsurancecardsArray = [String]()
        //            for index in 0...(insuranceCardImagesArray.count - 1) {
        //
        //                let imagePath = insuranceCardImagesArray[index].valueForKey("image_url")
        //                let imageData:NSData = imagePath!.dataUsingEncoding(NSUTF8StringEncoding)!
        //                let imageStringBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        //                base64InsurancecardsArray.append(imageStringBase64)
        //            }
        //            let insuranceCardImagesBase64String = base64InsurancecardsArray.joinWithSeparator(",")
    }
    
    func showUpdateVehicleSuccessAlert(message: String) {
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        
        alertController.addAction(defaultAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    //MARK:- DELETE VEHICLE API
    
    func callDeleteVehicleAPI() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let vehicleId: String = (vehiclesDetailsDictionary?.valueForKey("id"))! as! String
            let userId: String = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as! String
            let paramsDict: [ String : AnyObject] = ["vid": vehicleId,"uid": userId] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/delete", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            
                            let responseMessage = JSON.valueForKey("message") as! String
                            self.showDeleteVehicleSuccessAlert(responseMessage)
                        }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                        }
                    }
            }
        } else {
            self.showInternetFailureAlert()
        }
    }
    
    func showDeleteVehicleSuccessAlert(message: String) {
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        
        alertController.addAction(defaultAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func showInternetFailureAlert() {
        
        print("Internet connection FAILED")
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
        self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
    }
}
