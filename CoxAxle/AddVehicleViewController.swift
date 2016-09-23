//
//  AddVehicleViewController.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 24/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import YLProgressBar
import LGSemiModalNavController

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class AddVehicleViewController: GAITrackedViewController, UIAlertController_UIAlertView, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VehicleAddedDelegate, UITextFieldDelegate {
    
    var language: String?
    
    @IBOutlet var progressBar               : YLProgressBar!
    @IBOutlet weak var addVehicleTableView  : UITableView!
    
    let semiModalViewController = LGSemiModalNavViewController()
    var imageView               = UIImageView()
    var imagePicker             = UIImagePickerController()
    var datePicker               = UIDatePicker()
    let datesTableView          = UITableView()
    let vehicleMakeTableView    = UITableView()
    let vehiclesModelTableView  = UITableView()
    var newButton: UIButton!
    var usedButton: UIButton!
    var cpoButton : UIButton!
    var vehicleImagesArray = [UIImage]()
    
    
    var vehicleName              : String?
    var vinNumber                : String?
    var milesDriven              : String?
    var vehiclePurchasedYear     : String?
    var vehicleMake              : String?
    var vehicleModel             : String?
    var tagExpirationDate        : String?
    var vehicleImage             : UIImage?
    var selectedVehicleType      : String?
    var selectedYear             : String?
    var selectedVehicleMake      : String?
    var selectedVehicleModel     : String?
    var selectedTagExpirationDate: String?
    var isDatePickerSelected     : Bool?
    var isValidationSuccess      : Bool?
    
    var vehicleNameTextField: UITextField!
    var vinTextField: UITextField!
    var milesDrivenTextField: UITextField!
    var vehicleAdded: Bool!
    
    
    let yearsArray : [String]  = ["2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016"]
    let vehicleMakeArray    = ["Accent", "Azera", "Elantra", "Santa Fe Sports", "Mrecedes", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    let vehiclesModelArray  = ["Accent A2S", "Azera AZ3", "Elantra EL1", "Santa Fe Sports SaFeX", "Mrecedes MQn", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "AddVehicleViewController"
        self.vehicleAdded = false
        newButton = UIButton()
        usedButton = UIButton()
        cpoButton = UIButton()
        
        vehicleImage              = nil
        vehicleName               = nil
        selectedVehicleType       = nil
        vinNumber                 = nil
        vehiclePurchasedYear      = nil
        vehicleMake               = nil
        vehicleModel              = nil
        milesDriven               = nil
        selectedTagExpirationDate = nil
        
        setProgressBarProperties()
        self.setText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        case 0 : return 10
        case 1 : return yearsArray.count
        case 2 : return vehicleMakeArray.count
        case 3 : return vehiclesModelArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        switch tableView.tag {
            
        case 0:
            
            switch ((indexPath as NSIndexPath).row) {
                
            case 0:
                
                let addVehicleImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleImageTableViewCell", for: indexPath) as! AddVehicleImageTableViewCell
                
                addVehicleImageTableViewCell.uploadVehiclePictureButton.addTarget(self, action: #selector(AddVehicleViewController.uploadVehiclePic), for: .touchUpInside)
                
                let tapGestureForUpoadImage = UITapGestureRecognizer(target: self, action: #selector(AddVehicleViewController.uploadVehiclePic))
                addVehicleImageTableViewCell.vehicleImageView.isUserInteractionEnabled = true
                addVehicleImageTableViewCell.vehicleImageView.addGestureRecognizer(tapGestureForUpoadImage)
                
                if self.vehicleImagesArray.count > 0 {
                    addVehicleImageTableViewCell.vehicleImageView.image = imageView.image
                }
                else {
                    addVehicleImageTableViewCell.vehicleImageView.image = nil
                }
                
                return addVehicleImageTableViewCell
                
            case 1:
                
                let vehicleNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VehicleNameTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .no
                
                vehicleNameTableViewCell.vehicleNameTextField.tag = 1
                vehicleNameTableViewCell.vehicleNameTextField.delegate = self
                
                self.vehicleNameTextField = vehicleNameTableViewCell.vehicleNameTextField
                return vehicleNameTableViewCell
                
            case 2:
                
                let vehicleTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewUsedTableViewCell", for: indexPath) as! VehicleTypeTableViewCell
                
                newButton = vehicleTypeTableViewCell.newVehicleButton
                usedButton = vehicleTypeTableViewCell.usedVehicleButton
                cpoButton = vehicleTypeTableViewCell.CPOVehicleButton
                
                vehicleTypeTableViewCell.newVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.newVehicleTypeSelected(_:)), for: .touchUpInside)
                vehicleTypeTableViewCell.usedVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.usedVehicleTypeSelected(_:)), for: .touchUpInside)
                vehicleTypeTableViewCell.CPOVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.cpoVehicleTypeSelected(_:)), for: .touchUpInside)
                
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
                
                vinTableViewCell.findMyVinButton.addTarget(self, action: #selector(AddVehicleViewController.findMyVinNumber), for: .touchUpInside)
                
                vinTableViewCell.vinTextField.autocorrectionType = .no
                
                vinNumber = vinTableViewCell.vinTextField.text
                
                self.vinTextField = vinTableViewCell.vinTextField
                
                return vinTableViewCell
                
            case 4:
                
                let selectYearTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectYearTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectYearTableViewCell.selectYearButton.addTarget(self, action: #selector(AddVehicleViewController.selectDate), for: .touchUpInside)
                
                if let vehiclePurchasedYear = selectedYear {
                    selectYearTableViewCell.selectYearButton.setTitle(String(vehiclePurchasedYear), for: UIControlState())
                } else {
                    selectYearTableViewCell.selectYearButton.setTitle("Select Purchased year", for: UIControlState())
                }
                
                vehiclePurchasedYear = selectYearTableViewCell.selectYearButton.titleLabel?.text
                
                return selectYearTableViewCell
                
            case 5:
                
                let selectMakeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectMakeTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectMakeTableViewCell.selectVehicleMakeButton.addTarget(self, action: #selector(AddVehicleViewController.selectVehicleMake), for: .touchUpInside)
                
                if let vehicleMake = selectedVehicleMake {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(vehicleMake), for: UIControlState())
                } else {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle("Select Vehicle Make", for: UIControlState())
                }
                
                vehicleMake = selectMakeTableViewCell.selectVehicleMakeButton.titleLabel?.text
                
                return selectMakeTableViewCell
                
            case 6:
                
                let selectModelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectModelTableViewCell", for: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectModelTableViewCell.selectVehicleModelButton.addTarget(self, action: #selector(AddVehicleViewController.selectVehicleModel), for: .touchUpInside)
                
                if let vehicleModel = selectedVehicleModel {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(vehicleModel), for: UIControlState())
                } else {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle("Select Vehicle Model", for: UIControlState())
                }
                
                vehicleModel = selectModelTableViewCell.selectVehicleModelButton.titleLabel?.text
                
                return selectModelTableViewCell
                
            case 7:
                
                let milesDrivenTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MilesDrivenTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                milesDrivenTableViewCell.milesDrivenTextField.autocorrectionType = .no
                
                milesDrivenTableViewCell.milesDrivenTextField.tag = 2
                milesDrivenTableViewCell.milesDrivenTextField.delegate = self
                
                self.milesDrivenTextField = milesDrivenTableViewCell.milesDrivenTextField
                return milesDrivenTableViewCell
                
            case 8:
                
                let tagExpirationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tagExpirationDateCell", for: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                tagExpirationTableViewCell.leftLabel.text = "Tag Expiration"
                
                if let tagExpireDate = tagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(tagExpireDate, for: UIControlState())
                }
                tagExpirationTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(AddVehicleViewController.selectTagExpirationExpirationDate), for: .touchUpInside)
                print(tagExpirationTableViewCell.insuranceExpirationDateButton.titleLabel?.text)
                
                return tagExpirationTableViewCell
                
            case 9:
                
                let datePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! DatePickerTableViewCell
                
                datePickerTableViewCell.doneButton.addTarget(self, action: #selector(AddVehicleViewController.pickerDoneButtonAction), for: .touchUpInside)
                
                self.datePicker = datePickerTableViewCell.insuranceDatePicker
                
                return datePickerTableViewCell
                
            default:
                let vehicleNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VehicleNameTableViewCell", for: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .no
                
                // vehicleName = vehicleNameTableViewCell.vehicleNameTextField.text
                
                self.vehicleNameTextField = vehicleNameTableViewCell.vehicleNameTextField
                return vehicleNameTableViewCell
            }
            
        case 1:
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "NormalCell") as! SelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(yearsArray[(indexPath as NSIndexPath).row])
            cell?.cellValue.tag = -1
            
            cell?.selectionButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.selectionButton.layer.cornerRadius =  12.0
            cell?.selectionButton.tag = (indexPath as NSIndexPath).row
            
            cell?.selectionButton.addTarget(self, action: #selector(AddVehicleViewController.yearSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
        case 2:
            
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "NormalCell") as! SelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(vehicleMakeArray[(indexPath as NSIndexPath).row])
            
            cell?.selectionButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.selectionButton.layer.cornerRadius = 12.0
            cell?.selectionButton.tag = (indexPath as NSIndexPath).row
            cell?.selectionButton.addTarget(self, action: #selector(AddVehicleViewController.vehicleMakeSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
        case 3:
            
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "NormalCell") as! SelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(vehiclesModelArray[(indexPath as NSIndexPath).row])
            
            cell?.selectionButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.selectionButton.layer.cornerRadius = 12.0
            cell?.selectionButton.tag = (indexPath as NSIndexPath).row
            cell?.selectionButton.addTarget(self, action: #selector(AddVehicleViewController.vehicleModelSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
            
        default:
            let cell = self.addVehicleTableView.dequeueReusableCell(withIdentifier: "NormalCell") as! SelectionTableViewCell!
            cell?.selectionStyle = .none
            
            cell?.cellValue.text = String(yearsArray[(indexPath as NSIndexPath).row])
            cell?.cellValue.tag = -1
            
            cell?.selectionButton.backgroundColor = UIColor.uncheckButtonBackgroundColor()
            cell?.selectionButton.layer.cornerRadius =  12.0
            cell?.selectionButton.tag = (indexPath as NSIndexPath).row
            
            cell?.selectionButton.addTarget(self, action: #selector(AddVehicleViewController.yearSelected(_:)), for: .touchUpInside)
            
            cell?.layoutMargins = UIEdgeInsets.zero
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 0 {
            
            switch (indexPath as NSIndexPath).row {
                
            case 0: return 200
            case 9: return isDatePickerSelected == true ? 290 : 0
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
            
        case 0:
            return UIView(frame: CGRect.zero)
        case 1:
            titleLabel.text = "Select Year"
            return titleLabel
        case 2:
            titleLabel.text = "Select Make"
            return titleLabel
        case 3:
            titleLabel.text = "Select Model"
            return titleLabel
        default:
            return UIView(frame: CGRect.zero)
        }
    }
    
    func prepareModalViewTitleLabel(_ titleLabel: UILabel) {
        
        titleLabel.textAlignment   = .center
        titleLabel.font            = UIFont.boldFont().withSize(17)
        titleLabel.textColor       = UIColor.SlateColor()
        titleLabel.backgroundColor = UIColor.white
    }
    
    //MARK:- ACTION SELECTOR METHODS
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        if self.vehicleAdded == true {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VehicleAdded"), object: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func pickerDoneButtonAction() {
        
        isDatePickerSelected = false
        
        if tagExpirationDate == nil || tagExpirationDate == "Select Date" || tagExpirationDate?.characters.count == 0 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: date)
            tagExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func selectTagExpirationExpirationDate() {
        
        isDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRow(at: IndexPath(row: 9, section: 0), at: .bottom, animated: true)
    }
    
    func newVehicleTypeSelected(_ sender: UIButton) {
        
        selectedButtonProperties(newButton)
        deselectOtherButtons(usedButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func usedVehicleTypeSelected(_ sender: UIButton) {
        
        selectedButtonProperties(usedButton)
        deselectOtherButtons(newButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func cpoVehicleTypeSelected(_ sender: UIButton) {
        
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
    
    func uploadVehiclePic() {
        
        //        if vehicleImagesArray.count == 3  || vehicleImagesArray.count > 3 {
        //
        //            showAlertwithCancelButton("", message: "You can upload upto only Three photos", cancelButton: "OK")
        //            return
        //        }
        
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            self.openGallary()
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
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        
        let pickerController = DKImagePickerController()
        
        pickerController.maxSelectableCount = 5
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for asset in assets {
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    self.vehicleImagesArray.append(image!)
                    self.imageView.image = self.vehicleImagesArray[0]
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
    
    //MARK:- Vehicle Added delegate method
    
    func clearUIFields() {
        
        self.vehicleImagesArray.removeAll()
        self.vehicleNameTextField.text = ""
        self.vinTextField.text = ""
        self.milesDrivenTextField.text = ""
        
        self.selectedYear = "Select Purchased year"
        self.selectedVehicleMake = "Select Vehicle Make"
        self.selectedVehicleModel = "Select Vehicle Model"
        self.tagExpirationDate = "Select Date"
        
        self.newButton.isSelected = false
        self.newButton.backgroundColor = UIColor.white
        self.newButton.titleLabel?.font = UIFont.regularFont().withSize(17)
        self.usedButton.isSelected = false
        self.usedButton.backgroundColor = UIColor.white
        self.usedButton.titleLabel?.font = UIFont.regularFont().withSize(17)
        self.cpoButton.isSelected = false
        self.cpoButton.backgroundColor = UIColor.white
        self.cpoButton.titleLabel?.font = UIFont.regularFont().withSize(17)
        
        let date                 = Date()
        self.datePicker.minimumDate   = date
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        self.datePicker.setDate(Date(), animated: true)
        
        addVehicleTableView.reloadData()
        
        self.vehicleAdded = true
    }
    
    //MARK:- UIBUTTON METHODS
    
    @IBAction func gotoNextScene(_ sender: UIButton) {
        
        addVehicleTableView.reloadData()
        validateFields()
    }
    
    func validateFields() {
        
        if self.vehicleImagesArray.count <= 0  {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle image", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if vehicleName?.isEmpty == true || vehicleName == nil {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please enter vehicle name", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if selectedVehicleType?.characters.count < 3 {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle type", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if vinNumber?.characters.count != 16 {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please enter 16 digit VIN number", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if vehiclePurchasedYear == "Select Purchased year" {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle purchased year", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if vehicleMake == "Select Vehicle Make" {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle make", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        if vehicleModel == "Select Vehicle Model" {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle model", cancelButton: "OK")
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
        
        if tagExpirationDate == "Select Date" || tagExpirationDate == nil || tagExpirationDate?.characters.count == 0 {
            
            isValidationSuccess = false
            showAlertwithCancelButton("Error", message: "Please select vehicle tag expiration date", cancelButton: "OK")
            return
        } else {
            isValidationSuccess = true
        }
        
        self.performSegue(withIdentifier: "InsuranceDetailsView", sender: self)
    }
    
    //MARK:- NAVIGATE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if isValidationSuccess == true {
            
            if(segue.identifier == "InsuranceDetailsView") {
                
                let vehicleInsuranceDetailsViewController = (segue.destination as! VehicleInsuranceDetailsViewController)
                
                vehicleInsuranceDetailsViewController.delegate = self
                passValuesToInsuranceDetailScene(vehicleInsuranceDetailsViewController)
            }
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
    
    func passValuesToInsuranceDetailScene(_ nextViewController: VehicleInsuranceDetailsViewController) {
        
        nextViewController.vehicleImagesArray  = vehicleImagesArray
        nextViewController.vehicleName         = vehicleName!
        nextViewController.vehicleType         = selectedVehicleType!
        nextViewController.vinNumber           = vinNumber!
        nextViewController.vehiclePurchaseYear = selectedYear!
        nextViewController.vehicleMake         = selectedVehicleMake!
        nextViewController.vehicleModel        = vehicleModel!
        nextViewController.milesDriven         = milesDriven!
        nextViewController.tagExpirationDate   = tagExpirationDate!
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
    
}
