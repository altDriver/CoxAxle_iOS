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
import SDWebImage

class EditVehicleViewController: UIViewController, UIAlertController_UIAlertView, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
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
    var selectedVehicleImagesArray: [AnyObject] = []
    var insuranceCardImagesArray = [UIImage]()
    var fromVehicleImage: Bool!
    
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
    var loading: UIActivityIndicatorView_ActivityClass?
    
    let yearsArray = ["2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016"]
    let vehicleMakeArray = ["Accent", "Azera", "Elantra", "Santa Fe Sports", "Mrecedes", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    let vehiclesModelArray = ["Accent A2S", "Azera AZ3", "Elantra EL1", "Santa Fe Sports SaFeX", "Mrecedes MQn", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        
        vehicleImagesArray = (vehiclesDetailsDictionary?.value(forKey: "vechicle_image")!)! as! [UIImage]
        //        insuranceCardImagesArray = (vehiclesDetailsDictionary?.valueForKey("insurance_document")!)! as! [UIImage]
        vehicleName = vehiclesDetailsDictionary?.value(forKey: "name") as? String
        selectedVehicleType = vehiclesDetailsDictionary?.value(forKey: "vehicle_type") as? String
        vinNumber = vehiclesDetailsDictionary?.value(forKey: "vin") as? String
        vehiclePurchasedYear = vehiclesDetailsDictionary?.value(forKey: "year") as? String
        vehicleMake = vehiclesDetailsDictionary?.value(forKey: "make") as? String
        vehicleModel = vehiclesDetailsDictionary?.value(forKey: "model") as? String
        milesDriven = vehiclesDetailsDictionary?.value(forKey: "mileage") as? String
        selectedTagExpirationDate = (vehiclesDetailsDictionary?.value(forKey: "tag_expiration_date") as? String)?.convertDateToString()
        selectedInsuranceExpirationDate = (vehiclesDetailsDictionary?.value(forKey: "insurance_expiration_date") as? String)?.convertDateToString()
    }
    
    func setText() -> Void {
        
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
    }
    
    func setProgressBarProperties() {
        
        progressBar.type           = .flat
        self.progressBar.trackTintColor = UIColor.SlateColor().withAlphaComponent(0.4)
        progressBar.hideStripes    = true
        
        let titleLabel             = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth / 4, height: 15))
        titleLabel.text            = "Step 1 of 4"
        titleLabel.textAlignment   = .center
        titleLabel.font            = UIFont.boldFont().withSize(10)
        titleLabel.backgroundColor = UIColor.orange
        titleLabel.textColor       = UIColor.white
        
        progressBar.addSubview(titleLabel)
    }
    
    //MARK:- TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView.tag {
        case 0 : return 13
        case 1 : return yearsArray.count
        case 2 : return vehicleMakeArray.count
        case 3 : return vehiclesModelArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        tableView.showsVerticalScrollIndicator = false
        
        switch tableView.tag {
            
        case 0:
            
            switch ((indexPath as NSIndexPath).row) {
                
            case 0:
                
                let addVehicleImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleImageTableViewCell", for: indexPath) as! AddVehicleImageTableViewCell
                
                addVehicleImageTableViewCell.uploadVehiclePictureButton.addTarget(self, action: #selector(EditVehicleViewController.uploadVehiclePic), for: .touchUpInside)
                
                let tapGestureForUpoadImage = UITapGestureRecognizer(target: self, action: #selector(EditVehicleViewController.uploadVehiclePic))
                addVehicleImageTableViewCell.vehicleImageView.isUserInteractionEnabled = true
                addVehicleImageTableViewCell.vehicleImageView.addGestureRecognizer(tapGestureForUpoadImage)
                
                let imagesArray = vehicleImagesArray as NSArray
                let imageURLString = (imagesArray[0] as AnyObject).value(forKey: "image_url") as! NSString
                 addVehicleImageTableViewCell.vehicleImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                
                return addVehicleImageTableViewCell
            case 1:
                
                let vehicleNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VehicleNameTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .no
                
                vehicleNameTableViewCell.vehicleNameTextField.delegate = self;
                
                self.vehicleNameTextField = vehicleNameTableViewCell.vehicleNameTextField
                
                guard let name = (self.vehicleNameTextField.text) , name != "" else {
                    
                    vehicleNameTableViewCell.vehicleNameTextField.text = vehicleName
                    
                    break
                }
                vehicleNameTableViewCell.vehicleNameTextField.text = name
                
                
                return vehicleNameTableViewCell
                
            case 2:
                
                let vehicleTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewUsedTableViewCell", for: indexPath) as! VehicleTypeTableViewCell
                
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
                
                vehicleTypeTableViewCell.newVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.newVehicleTypeSelected), for: .touchUpInside)
                vehicleTypeTableViewCell.usedVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.usedVehicleTypeSelected), for: .touchUpInside)
                vehicleTypeTableViewCell.CPOVehicleButton.addTarget(self, action: #selector(EditVehicleViewController.cpoVehicleTypeSelected), for: .touchUpInside)
                
                if vehicleTypeTableViewCell.newVehicleButton != nil {
                    vehicleTypeTableViewCell.newVehicleButton = newButton
                }
                if vehicleTypeTableViewCell.usedVehicleButton != nil {
                    vehicleTypeTableViewCell.usedVehicleButton = usedButton
                }
                if vehicleTypeTableViewCell.CPOVehicleButton != nil {
                    vehicleTypeTableViewCell.CPOVehicleButton = cpoButton
                }
                
                
                return vehicleTypeTableViewCell
            case 3:
                
                let vinTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VINTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                let findVinButtonAttrinutes = [
                    NSFontAttributeName : UIFont.systemFont(ofSize: 11),
                    NSUnderlineStyleAttributeName : 1] as [String : Any]
                let attributedString = NSMutableAttributedString(string:"")
                
                let buttonTitleString = NSMutableAttributedString(string:"Find My VIN", attributes: findVinButtonAttrinutes)
                vinTableViewCell.findMyVinButton.titleLabel?.numberOfLines = 2
                attributedString.append(buttonTitleString)
                vinTableViewCell.findMyVinButton.setAttributedTitle(attributedString, for: UIControlState())
                
                vinTableViewCell.findMyVinButton.addTarget(self, action: #selector(EditVehicleViewController.findMyVinNumber), for: .touchUpInside)
                
                vinTableViewCell.vinTextField.autocorrectionType = .no
                
                if let vin = vinNumber {
                    vinTableViewCell.vinTextField.text = vin
                }
                else {
                    
                    vinNumber = vinTableViewCell.vinTextField.text
                }
                vinTableViewCell.vinTextField.isUserInteractionEnabled = false
                self.vinTextField = vinTableViewCell.vinTextField
                
                return vinTableViewCell
            case 4:
                
                let selectYearTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectYearTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectYearTableViewCell.selectYearButton.addTarget(self, action: #selector(EditVehicleViewController.selectDate), for: .touchUpInside)
                
                if let purchasedYear = selectedYear {
                    selectYearTableViewCell.selectYearButton.setTitle(String(purchasedYear), for: UIControlState())
                } else {
                    selectYearTableViewCell.selectYearButton.setTitle(String(vehiclePurchasedYear!), for: UIControlState())
                }
                
                vehiclePurchasedYear = selectYearTableViewCell.selectYearButton.titleLabel?.text
                
                
                return selectYearTableViewCell
            case 5:
                
                let selectMakeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectMakeTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectMakeTableViewCell.selectVehicleMakeButton.addTarget(self, action: #selector(EditVehicleViewController.selectVehicleMake), for: .touchUpInside)
                
                if let make = selectedVehicleMake {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(make), for: UIControlState())
                } else {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(vehicleMake!), for: UIControlState())
                }
                
                vehicleMake = selectMakeTableViewCell.selectVehicleMakeButton.titleLabel?.text
                
                
                return selectMakeTableViewCell
            case 6:
                
                let selectModelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectModelTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectModelTableViewCell.selectVehicleModelButton.addTarget(self, action: #selector(EditVehicleViewController.selectVehicleModel), for: .touchUpInside)
                
                if let model = selectedVehicleModel {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(model), for: UIControlState())
                } else {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(vehicleModel!), for: UIControlState())
                }
                
                vehicleModel = selectModelTableViewCell.selectVehicleModelButton.titleLabel?.text
                
                
                return selectModelTableViewCell
            case 7:
                
                let milesDrivenTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MilesDrivenTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                self.milesDrivenTextField = milesDrivenTableViewCell.milesDrivenTextField
                
                guard let name = (self.milesDrivenTextField.text) , name != "" else {
                    
                    milesDrivenTableViewCell.milesDrivenTextField.text = milesDriven
                    
                    break
                }
                milesDrivenTableViewCell.milesDrivenTextField.text = name
                milesDrivenTableViewCell.milesDrivenTextField.delegate = self
                
                
                return milesDrivenTableViewCell
            case 8:
                
                let tagExpirationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tagExpirationDateCell", for: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                tagExpirationTableViewCell.leftLabel.text = "Tag Expiration"
                
                if let date = selectedTagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(String(date), for: UIControlState())
                }
                if let tagExpireDate = tagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(tagExpireDate, for: UIControlState())
                }
                tagExpirationTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(EditVehicleViewController.selectTagExpirationDate), for: .touchUpInside)
                
                return tagExpirationTableViewCell
            case 9:
                
                let datePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! DatePickerTableViewCell
                
                datePickerTableViewCell.doneButton.addTarget(self, action: #selector(EditVehicleViewController.tagPickerDoneButtonAction), for: .touchUpInside)
                
                
                return datePickerTableViewCell
            case 10:
                
                let vehicleInsuranceDetailsTableViewCell: VehicleInsuranceDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InsuranceExpirationDateCell", for: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                if let date = selectedInsuranceExpirationDate {
                    
                    vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(String(date), for: UIControlState())
                }
                
                if let insuranceExpireDate = insuranceExpirationDate {
                    
                    vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(insuranceExpireDate, for: UIControlState())
                }
                
                vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(EditVehicleViewController.selectInsuranceExpirationDate), for: .touchUpInside)
                
                
                return vehicleInsuranceDetailsTableViewCell
            case 11:
                
                let insuranceDatePickerTableViewCell: DatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "insuranceDatePickerCell", for: indexPath) as! DatePickerTableViewCell
                
                insuranceDatePickerTableViewCell.doneButton.addTarget(self, action: #selector(EditVehicleViewController.insurancePickerDoneButtonAction), for: .touchUpInside)
                return insuranceDatePickerTableViewCell
            case 12:
                
                let insuranceCardTableViewCell: InsuranceCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCardTableViewCell", for: indexPath) as! InsuranceCardTableViewCell
                insuranceCardTableViewCell.uploadInsuranceCardPictureButton.addTarget(self, action: #selector(EditVehicleViewController.uploadInsuranceCardPic), for: .touchUpInside)
                
                insuranceCardTableViewCell.insuranceCardsCollectionView.reloadData()
                
                
                return insuranceCardTableViewCell
            default:
                let vehicleNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VehicleNameTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .no
                
                vehicleNameTableViewCell.vehicleNameTextField.delegate = self;
                
                self.vehicleNameTextField = vehicleNameTableViewCell.vehicleNameTextField
                
                guard let name = (self.vehicleNameTextField.text) , name != "" else {
                    
                    vehicleNameTableViewCell.vehicleNameTextField.text = vehicleName
                    
                    break
                }
                vehicleNameTableViewCell.vehicleNameTextField.text = name
                
                
                return vehicleNameTableViewCell
            }
            
            
        case 1:
            
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "DefaultCell") as! EditSelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(yearsArray[(indexPath as NSIndexPath).row])
            
            cell?.cellValue.tag = -1
            
            cell?.cellButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.cellButton.layer.cornerRadius = 12.0
            cell?.cellButton.tag = (indexPath as NSIndexPath).row
            
            cell?.cellButton.addTarget(self, action: #selector(EditVehicleViewController.yearSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
            
            
        case 2:
            
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "DefaultCell") as! EditSelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(vehicleMakeArray[(indexPath as NSIndexPath).row])
            
            cell?.cellButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.cellButton.layer.cornerRadius = 12.0
            cell?.cellButton.tag = (indexPath as NSIndexPath).row
            cell?.cellButton.addTarget(self, action: #selector(EditVehicleViewController.vehicleMakeSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
            
            
        case 3:
            
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "DefaultCell") as! EditSelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(vehiclesModelArray[(indexPath as NSIndexPath).row])
            
            
            cell?.cellButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.cellButton.layer.cornerRadius = 12.0
            cell?.cellButton.tag = (indexPath as NSIndexPath).row
            cell?.cellButton.addTarget(self, action: #selector(EditVehicleViewController.vehicleModelSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
            
            
        default:
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "DefaultCell") as! EditSelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(yearsArray[(indexPath as NSIndexPath).row])
            
            cell?.cellValue.tag = -1
            
            cell?.cellButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.cellButton.layer.cornerRadius = 12.0
            cell?.cellButton.tag = (indexPath as NSIndexPath).row
            
            cell?.cellButton.addTarget(self, action: #selector(EditVehicleViewController.yearSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
            
        }
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 0 {
            switch (indexPath as NSIndexPath).row {
            case 0: return 200
            case 9: return isTagExpirationDatePickerSelected == true ? 290 : 0
            case 11: return isInsuranceExpirationDatePickerSelected == true ? 290 : 0
            case 12: return 130
            default: return 60
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.tag == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenHeight, height: 60))
        prepareModalViewTitleLabel(titleLabel)
        
        switch tableView.tag {
            
        case 0: return UIView(frame: CGRect.zero)
        case 1: titleLabel.text = "Select Year"
        return titleLabel
        case 2: titleLabel.text = "Select Make"
        return titleLabel
        case 3: titleLabel.text = "Select Model"
        return titleLabel
        default: return UIView(frame: CGRect.zero)
        }
    }
    
    func prepareModalViewTitleLabel(_ titleLabel: UILabel) {
        
        titleLabel.textAlignment   = .center
        titleLabel.font            = UIFont.boldFont().withSize(17)
        titleLabel.textColor       = UIColor.SlateColor()
        titleLabel.backgroundColor = UIColor.white
    }
    
    //MARK:- COLLECTION VIEW METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return insuranceCardImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let insuranceCardsCollectionViewCell: InsuranceCardsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsuranceCardsCollectionViewCell", for: indexPath) as! InsuranceCardsCollectionViewCell
        
        insuranceCardsCollectionViewCell.insuranceCardsImageView.tag = (indexPath as NSIndexPath).row
        insuranceCardsCollectionViewCell.removeCardButton.tag = (indexPath as NSIndexPath).row
        
        insuranceCardsCollectionViewCell.insuranceCardsImageView.image = insuranceCardImagesArray[(indexPath as NSIndexPath).row]
        
        return insuranceCardsCollectionViewCell
    }
    
    //MARK:- ACTION SELECTOR METHODS
    
    func tagPickerDoneButtonAction() {
        
        isTagExpirationDatePickerSelected = false
        
        if tagExpirationDate == nil || tagExpirationDate == "Select Date" || tagExpirationDate?.characters.count == 0 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: date)
            tagExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func insurancePickerDoneButtonAction() {
        
        isInsuranceExpirationDatePickerSelected = false
        
        if insuranceExpirationDate == nil || insuranceExpirationDate == "Select Date" || insuranceExpirationDate?.characters.count == 0 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: date)
            insuranceExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func selectTagExpirationDate() {
        
        isTagExpirationDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRow(at: IndexPath(row: 9, section: 0), at: .bottom, animated: true)
    }
    
    func selectInsuranceExpirationDate() {
        
        isInsuranceExpirationDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRow(at: IndexPath(row: 11, section: 0), at: .bottom, animated: true)
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
    
    func selectedButtonProperties(_ sender: UIButton) {
        
        sender.backgroundColor  = UIColor.vehicleTypeSelectedButtonBackgroundColor()
        sender.tintColor        = UIColor.SlateColor()
        sender.titleLabel?.font = UIFont.boldFont().withSize(17)
        
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
    
    func deselectOtherButtons(_ button1: UIButton, button2: UIButton) {
        
        button1.isSelected         = false
        button2.isSelected         = false
        button1.backgroundColor  = UIColor.white
        button2.backgroundColor  = UIColor.white
        button1.titleLabel?.font = UIFont.regularFont().withSize(17)
        button2.titleLabel?.font = UIFont.regularFont().withSize(17)
    }
    
    func findMyVinNumber() {
        
        let findMyVinViewController: FindMyVinViewController = self.storyboard?.instantiateViewController(withIdentifier: "FindMyVinView") as! FindMyVinViewController
        self.present(findMyVinViewController, animated: true, completion: nil)
    }
    
    func yearSelected(_ sender: UIButton) {
        
        selectedYear = yearsArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func vehicleMakeSelected(_ sender: UIButton) {
        
        selectedVehicleMake = vehicleMakeArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func vehicleModelSelected(_ sender: UIButton) {
        
        selectedVehicleModel = vehiclesModelArray[sender.tag]
        dismissModalAfterSelection(sender)
    }
    
    func dismissModalAfterSelection(_ sender: UIButton) {
        
        sender.setImage(UIImage(named: "checkbox.png"), for: UIControlState())
        sender.backgroundColor = UIColor.white
        addVehicleTableView.reloadData()
        self.semiModalViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UPLOAD IMAGE METHODS
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if isInsuranceCardSelected == false {
            //        if vehicleImagesArray.count == 5  || vehicleImagesArray.count > 5 {
            //
            //            showAlertwithCancelButton("", message: "You can upload upto only Five photos", cancelButton: "OK")
            //            picker.dismissViewControllerAnimated(true, completion: nil)
            //            return
            //        }
            
            picker.dismiss(animated: true, completion: nil)
            let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            imageView.image = image
            
            vehicleImagesArray.append(image)
            
            vehicleImage = imageView.image
            self.addVehicleTableView.reloadData()
            
        } else {
            
            picker.dismiss(animated: true, completion: nil)
            let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            if self.fromVehicleImage == true {
               self.selectedVehicleImagesArray.append(image)
            }
            else {
            insuranceCardImagesArray.append(image)
            }
            
            self.addVehicleTableView.reloadData()
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        isInsuranceCardSelected = false
        dismiss(animated: true, completion: nil)
    }
    
    func uploadVehiclePic() {
        
        //        if vehicleImagesArray.count == 5  || vehicleImagesArray.count > 5 {
        //
        //            showAlertwithCancelButton("Error", message: "You can upload upto only Five photos", cancelButton: "OK")
        //            return
        //        }
        
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openCamera(isVehicleImage: true)
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.SlateColor()
        self.present(alert, animated: true, completion: nil)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera(isVehicleImage:Bool) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            
            self.fromVehicleImage = isVehicleImage
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadInsuranceCardPic() {
        
        isInsuranceCardSelected = true
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openCamera(isVehicleImage: false)
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.SlateColor()
        self.present(alert, animated: true, completion: nil)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker
    
    func openGallery() {
        
        self.selectedVehicleImagesArray.removeAll()
        let pickerController = DKImagePickerController()
        
        pickerController.maxSelectableCount = 5
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for asset in assets {
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    
                    self.selectedVehicleImagesArray.append(image!)
                    self.addVehicleTableView.reloadData()
            
                })
            }
        }
        
        self.present(pickerController, animated: true) {
            
        }
    }
    //MARK:- UITextField Delegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            vehicleName = textField.text
        }
        else {
            milesDriven = textField.text
        }
    }
    
    
    //MARK:- UIBUTTON METHODS
    
    @IBAction func deleteVehicleButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this vehicle?", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            self.callDeleteVehicleAPI()
        })
        alertController.addAction(defaultAction)
        
        let otherAction = UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(otherAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        
        self.validateFields()
        
        if isValidationSuccess == true {
            
            DispatchQueue.main.async {
                
                print("This is run on the main queue, after the previous code in outer block")
                self.loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
                self.view.addSubview(self.loading!)
            }
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                self.callEditVehiclesAPI()
                
            }
            
        }
    }
    
    @IBAction func removeCard(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.insuranceCardImagesArray.remove(at: sender.tag)
            self.addVehicleTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        self.vehicleNameTextField.resignFirstResponder()
        if self.milesDrivenTextField != nil {
            self.milesDrivenTextField.resignFirstResponder()
        }
        datesTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(1, tableView: datesTableView)
    }
    
    func selectVehicleMake() {
        self.vehicleNameTextField.resignFirstResponder()
        if self.milesDrivenTextField != nil {
            self.milesDrivenTextField.resignFirstResponder()
        }
        vehicleMakeTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(2, tableView: vehicleMakeTableView)
    }
    
    func selectVehicleModel() {
        self.vehicleNameTextField.resignFirstResponder()
        if self.milesDrivenTextField != nil {
            self.milesDrivenTextField.resignFirstResponder()
        }
        vehiclesModelTableView.reloadData()
        createSemiModalViewController()
        setTableViewPropertiesForModalView(3, tableView: vehiclesModelTableView)
    }
    
    func createSemiModalViewController() {
        
        semiModalViewController.view.frame = CGRect(x: 0, y: screenWidth - 150, width: screenWidth , height: screenHeight - 150)
        
        semiModalViewController.backgroundShadeColor = UIColor.black
        semiModalViewController.animationSpeed       = 0.35
        semiModalViewController.isTapDismissEnabled    = true
        semiModalViewController.backgroundShadeAlpha = 0.4
        semiModalViewController.scaleTransform       = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func setTableViewPropertiesForModalView(_ tagValue: Int, tableView: UITableView) {
        
        tableView.tag   = tagValue
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight - 150)
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        semiModalViewController.view.addSubview(tableView)
        self.present(semiModalViewController, animated: true, completion: { _ in })
    }
    
    @IBAction func datePickerChanged(_ datePicker: UIDatePicker) {
        
        let date                 = Date()
        datePicker.minimumDate   = date
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString           = dateFormatter.string(from: datePicker.date)
        tagExpirationDate        = dateString
        addVehicleTableView.reloadData()
    }
    
    @IBAction func insuranceDatePickerChanged(_ datePicker: UIDatePicker) {
        
        let date                 = Date()
        datePicker.minimumDate   = date
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString           = dateFormatter.string(from: datePicker.date)
        insuranceExpirationDate  = dateString
        addVehicleTableView.reloadData()
    }
    
    //MARK:- EDIT VEHICLE API
    
    func callEditVehiclesAPI() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            self.addTracker()
            
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
            
            let paramsDict: [String : String] = ["vid": vehicleId,
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
            
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/update", method: .post, parameters: paramsDict).responseJSON
                { response in
                    self.loading?.hide ()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: EditVehicles = try EditVehicles(dictionary: JSON as! [AnyHashable: Any])
                                
                                print(dict)
                                let message = (JSON as AnyObject).value(forKey: "message") as! String
                                self.showUpdateVehicleSuccessAlert(message)
                                
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        else {
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
                        }
                    }
            }
        } else {
            self.showInternetFailureAlert()
        }
    }
    
    func addTracker() {
        
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Edit Vehicle API Called", label: "Edit Vehicle", value: nil).build()
        tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
    }
    
    func parseIdValues() -> [String] {
        
        let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
        let vin: String = self.vehiclesDetailsDictionary?.value(forKey: "vin") as! String
        let vehicleId: String = (self.vehiclesDetailsDictionary?.value(forKey: "id"))! as! String
        let dealerId: String = (self.vehiclesDetailsDictionary?.value(forKey: "dealer_id"))! as! String
        
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
        
        return [name, type!, miles!, year!, make!, model!, insuExpirationDate!, tagExpiryDate!]
    }
    
    func createVehicleImageBase64String() -> String {
        
//        var base64VehicleImagesArray = [String]()
//        for index in 0...(vehicleImagesArray.count - 1) {
//            
//            let imagePath = vehicleImagesArray[index].value(forKey: "image_url")
//            let imageData:Foundation.Data = (imagePath! as! String).data(using: String.Encoding.utf8)!
//            let imageStringBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
//            base64VehicleImagesArray.append(imageStringBase64)
//        }
//        oldVehicleImageBase64String = base64VehicleImagesArray.joined(separator: ",")
    
        var base64StrArr = [String]()
        if self.selectedVehicleImagesArray.count > 0 {
        for index in 0...(self.selectedVehicleImagesArray.count - 1) {
            
            let eachImage: UIImage = self.selectedVehicleImagesArray[index] as! UIImage
            let eachImageData: Foundation.Data = (data: UIImagePNGRepresentation(eachImage)!)
            let base64ImageString: String = eachImageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            base64StrArr.append(base64ImageString)
        }
        self.editedVehicleImagesBase64String = base64StrArr.joined(separator: ",")
        }
        if editedVehicleImagesBase64String == nil {
            editedVehicleImagesBase64String = ""
        }
        if oldVehicleImageBase64String == nil {
            oldVehicleImageBase64String = ""
        }
        
        if editedVehicleImagesBase64String == "" {
            vehicleImagesBase64String = ""
        } else {
            vehicleImagesBase64String = editedVehicleImagesBase64String!
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
    
    func showUpdateVehicleSuccessAlert(_ message: String) {
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    //MARK:- DELETE VEHICLE API
    
    func callDeleteVehicleAPI() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let vehicleId: String = (vehiclesDetailsDictionary?.value(forKey: "id"))! as! String
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["vid": vehicleId,"uid": userId] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/delete", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            
                            let responseMessage = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showDeleteVehicleSuccessAlert(responseMessage)
                        }
                        else {
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
                        }
                    }
            }
        } else {
            self.showInternetFailureAlert()
        }
    }
    
    func showDeleteVehicleSuccessAlert(_ message: String) {
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.navigationController!.popToRootViewController(animated: true)
        })
        
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func showInternetFailureAlert() {
        
        print("Internet connection FAILED")
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
        self.present(vc as! UIViewController, animated: true, completion: nil)
    }
}
