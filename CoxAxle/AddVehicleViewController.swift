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

class AddVehicleViewController: UIViewController, UIAlertController_UIAlertView, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var language: String?
    
    @IBOutlet var progressBar               : YLProgressBar!
    @IBOutlet weak var addVehicleTableView  : UITableView!
    
    let semiModalViewController = LGSemiModalNavViewController()
    var imageView               = UIImageView()
    var imagePicker             = UIImagePickerController()
    let datesTableView          = UITableView()
    let vehicleMakeTableView    = UITableView()
    let vehiclesModelTableView  = UITableView()
    var newButton        = UIButton()
    var usedButton       = UIButton()
    var cpoButton        = UIButton()
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
    var selectedYear             : Int?
    var selectedVehicleMake      : String?
    var selectedVehicleModel     : String?
    var selectedTagExpirationDate: String?
    var isDatePickerSelected     : Bool?
    
    let yearsArray          = [2007,2008,2009,2010,2011,2012,2013,2014,2015,2016]
    let vehicleMakeArray    = ["Accent", "Azera", "Elantra", "Santa Fe Sports", "Mrecedes", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    let vehiclesModelArray  = ["Accent A2S", "Azera AZ3", "Elantra EL1", "Santa Fe Sports SaFeX", "Mrecedes MQn", "Land Rover","Accent", "Azera", "Elantra", "Santa Fe"]
    
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //MARK:- LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newButton.tag = 0
        usedButton.tag = 1
        cpoButton.tag = 2
        
        setProgressBarProperties()
        self.setText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText() -> Void {
        
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
    }
    
    func setProgressBarProperties() {
        
        progressBar.type           = .Flat
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
            
        case 0 : return 10
        case 1 : return yearsArray.count
        case 2 : return vehicleMakeArray.count
        case 3 : return vehiclesModelArray.count
        default: return 0
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch tableView.tag {
            
        case 0:
            
            switch (indexPath.row) {
                
            case 0:
                
                let addVehicleImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddVehicleImageTableViewCell", forIndexPath: indexPath) as! AddVehicleImageTableViewCell
                
                addVehicleImageTableViewCell.uploadVehiclePictureButton.addTarget(self, action: #selector(AddVehicleViewController.uploadVehiclePic), forControlEvents: .TouchUpInside)
                
                addVehicleImageTableViewCell.vehicleImageView.image = imageView.image
                
                cell = addVehicleImageTableViewCell
                
            case 1:
                
                let vehicleNameTableViewCell = tableView.dequeueReusableCellWithIdentifier("VehicleNameTableViewCell", forIndexPath: indexPath) as! VehicleDetailTableViewCell
                
                vehicleNameTableViewCell.vehicleNameTextField.autocorrectionType = .No
                
                vehicleName = vehicleNameTableViewCell.vehicleNameTextField.text
                
                cell = vehicleNameTableViewCell
                
            case 2:
                
                let vehicleTypeTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewUsedTableViewCell", forIndexPath: indexPath) as! VehicleTypeTableViewCell
                
                newButton = vehicleTypeTableViewCell.newVehicleButton
                usedButton = vehicleTypeTableViewCell.usedVehicleButton
                cpoButton = vehicleTypeTableViewCell.CPOVehicleButton
                
                vehicleTypeTableViewCell.newVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.newVehicleTypeSelected(_:)), forControlEvents: .TouchUpInside)
                vehicleTypeTableViewCell.usedVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.usedVehicleTypeSelected(_:)), forControlEvents: .TouchUpInside)
                vehicleTypeTableViewCell.CPOVehicleButton.addTarget(self, action: #selector(AddVehicleViewController.cpoVehicleTypeSelected(_:)), forControlEvents: .TouchUpInside)
                
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
                
                vinTableViewCell.vinTextField.autocorrectionType = .No
                
                vinNumber = vinTableViewCell.vinTextField.text
                
                cell = vinTableViewCell
                
            case 4:
                
                let selectYearTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectYearTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectYearTableViewCell.selectYearButton.addTarget(self, action: #selector(AddVehicleViewController.selectDate), forControlEvents: .TouchDragInside)
                
                if let vehiclePurchasedYear = selectedYear {
                    selectYearTableViewCell.selectYearButton.setTitle(String(vehiclePurchasedYear), forState: .Normal)
                } else {
                    selectYearTableViewCell.selectYearButton.setTitle("Select Purchased year", forState: .Normal)
                }
                
                vehiclePurchasedYear = selectYearTableViewCell.selectYearButton.titleLabel?.text
                
                cell = selectYearTableViewCell
                
            case 5:
                
                let selectMakeTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectMakeTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectMakeTableViewCell.selectVehicleMakeButton.addTarget(self, action: #selector(AddVehicleViewController.selectVehicleMake), forControlEvents: .TouchDragInside)
                
                if let vehicleMake = selectedVehicleMake {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle(String(vehicleMake), forState: .Normal)
                } else {
                    selectMakeTableViewCell.selectVehicleMakeButton.setTitle("Select Vehicle Make", forState: .Normal)
                }
                
                vehicleMake = selectMakeTableViewCell.selectVehicleMakeButton.titleLabel?.text
                
                cell = selectMakeTableViewCell
                
            case 6:
                
                let selectModelTableViewCell = tableView.dequeueReusableCellWithIdentifier("SelectModelTableViewCell", forIndexPath: indexPath) as! VehicleDetailSelectionTableViewCell
                
                selectModelTableViewCell.selectVehicleModelButton.addTarget(self, action: #selector(AddVehicleViewController.selectVehicleModel), forControlEvents: .TouchDragInside)
                
                if let vehicleModel = selectedVehicleModel {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle(String(vehicleModel), forState: .Normal)
                } else {
                    selectModelTableViewCell.selectVehicleModelButton.setTitle("Select Vehicle Model", forState: .Normal)
                }
                
                vehicleModel = selectModelTableViewCell.selectVehicleModelButton.titleLabel?.text
                
                cell = selectModelTableViewCell
                
            case 7:
                
                let milesDrivenTableViewCell = tableView.dequeueReusableCellWithIdentifier("MilesDrivenTableViewCell", forIndexPath: indexPath) as! VehicleDetailTableViewCell
                
                milesDrivenTableViewCell.milesDrivenTextField.autocorrectionType = .No
                
                milesDriven = milesDrivenTableViewCell.milesDrivenTextField.text
                
                cell = milesDrivenTableViewCell
                
            case 8:
                
                let tagExpirationTableViewCell = tableView.dequeueReusableCellWithIdentifier("tagExpirationDateCell", forIndexPath: indexPath) as! VehicleInsuranceDetailsTableViewCell
                
                tagExpirationTableViewCell.leftLabel.text = "Tag Expiration"
                
                if let tagExpireDate = tagExpirationDate {
                    
                    tagExpirationTableViewCell.insuranceExpirationDateButton.setTitle(tagExpireDate, forState: .Normal)
                }
                tagExpirationTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(AddVehicleViewController.selectTagExpirationExpirationDate), forControlEvents: .TouchUpInside)
                cell = tagExpirationTableViewCell
                
            case 9:
                
                let datePickerTableViewCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerTableViewCell
                
                datePickerTableViewCell.doneButton.addTarget(self, action: #selector(AddVehicleViewController.pickerDoneButtonAction), forControlEvents: .TouchUpInside)
                
                cell = datePickerTableViewCell
                
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
            
            checkBoxButton.addTarget(self, action: #selector(AddVehicleViewController.yearSelected(_:)), forControlEvents: .TouchUpInside)
            
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
            checkBoxButton.addTarget(self, action: #selector(AddVehicleViewController.vehicleMakeSelected(_:)), forControlEvents: .TouchUpInside)
            
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
            checkBoxButton.addTarget(self, action: #selector(AddVehicleViewController.vehicleModelSelected(_:)), forControlEvents: .TouchUpInside)
            
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
                
            case 0:
                return 200
                
            case 9:
                
                if isDatePickerSelected == true {
                    return 290
                } else {
                    return 0
                }
                
            default:
                return 60
            }
        }
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.tag == 0 {
            return 0
        }
        return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenHeight, height: 60))
        prepareModalViewTitleLabel(titleLabel)
        
        switch tableView.tag {
            
        case 0:
            return UIView(frame: CGRectZero)
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
            return UIView(frame: CGRectZero)
        }
    }
    
    func prepareModalViewTitleLabel(titleLabel: UILabel) {
        
        titleLabel.textAlignment   = .Center
        titleLabel.font            = UIFont.boldFont().fontWithSize(17)
        titleLabel.textColor       = UIColor.SlateColor()
        titleLabel.backgroundColor = UIColor.whiteColor()
    }
    
    //MARK:- ACTION SELECTOR METHODS
    
    func pickerDoneButtonAction() {
        
        isDatePickerSelected = false
        
        if tagExpirationDate == nil || tagExpirationDate == "Select Date" || tagExpirationDate?.characters.count == 0 {
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.stringFromDate(date)
            tagExpirationDate = dateString
        }
        addVehicleTableView.reloadData()
    }
    
    func selectTagExpirationExpirationDate() {
        
        isDatePickerSelected = true
        addVehicleTableView.reloadData()
        self.addVehicleTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 9, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func newVehicleTypeSelected(sender: UIButton) {
        
        selectedButtonProperties(newButton)
        deselectOtherButtons(usedButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func usedVehicleTypeSelected(sender: UIButton) {
        
        selectedButtonProperties(usedButton)
        deselectOtherButtons(newButton, button2: cpoButton)
        addVehicleTableView.reloadData()
    }
    
    func cpoVehicleTypeSelected(sender: UIButton) {
        
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
    
    func uploadVehiclePic() {
        
        if vehicleImagesArray.count == 3  || vehicleImagesArray.count > 3 {
            
            showAlertwithCancelButton("", message: "You Can Upload Upto Only Three Photos", cancelButton: "OK")
            return
        }
        
        let alert:UIAlertController=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Camera Roll", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            self.openGallary()
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
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- UPLOAD IMAGE METHODS
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if vehicleImagesArray.count == 3  || vehicleImagesArray.count > 3 {
            
            showAlertwithCancelButton("", message: "You Can Upload Upto Only Three Photos", cancelButton: "OK")
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        vehicleImagesArray.append(image!)
        
        vehicleImage = imageView.image
        addVehicleTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UIBUTTON METHODS
    
    @IBAction func gotoNextScene(sender: UIButton) {
        
        addVehicleTableView.reloadData()
        
                if vehicleImage == nil {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Image", cancelButton: "OK")
                    return
                }
        
                if vehicleName?.isEmpty == true {
        
                    showAlertwithCancelButton("Error", message: "Please Enter Vehicle Name", cancelButton: "OK")
                    return
                }
        
                if selectedVehicleType?.characters.count < 3 {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Type", cancelButton: "OK")
                    return
                }
        
                if vinNumber?.characters.count != 16 {
        
                    showAlertwithCancelButton("Error", message: "Please Enter 16 digit VIN Number", cancelButton: "OK")
                    return
                }
        
                if vehiclePurchasedYear == "Select Purchased year" {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Purchased Year", cancelButton: "OK")
                    return
                }
        
                if vehicleMake == "Select Vehicle Make" {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Make", cancelButton: "OK")
                    return
                }
        
                if vehicleModel == "Select Vehicle Model" {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Model", cancelButton: "OK")
                    return
                }
        
                if milesDriven?.isEmpty == true {
        
                    showAlertwithCancelButton("Error", message: "Please Enter Miles Driven", cancelButton: "OK")
                    return
                }
        
                if tagExpirationDate == "Select Date" || tagExpirationDate == nil || tagExpirationDate?.characters.count == 0 {
        
                    showAlertwithCancelButton("Error", message: "Please Select Vehicle Tag Expiration Date", cancelButton: "OK")
                    return
                }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let vehicleInsuranceDetailsViewConreoller = storyBoard.instantiateViewControllerWithIdentifier("vehicleInsuranceDetailsView") as! VehicleInsuranceDetailsViewController
        
        passValuesToInsuranceDetailScene(vehicleInsuranceDetailsViewConreoller)
        
        self.navigationController?.pushViewController(vehicleInsuranceDetailsViewConreoller, animated: true)
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
    
    func passValuesToInsuranceDetailScene(nextViewController: VehicleInsuranceDetailsViewController) {
        
            nextViewController.vehicleImage        = vehicleImage!
            nextViewController.vehicleName         = vehicleName!
            nextViewController.vehicleType         = selectedVehicleType!
            nextViewController.vinNumber           = vinNumber!
            nextViewController.vehiclePurchaseYear = selectedYear!
            nextViewController.vehicleMake         = selectedVehicleMake!
            nextViewController.vehicleModel        = vehicleModel!
            nextViewController.milesDriven         = milesDriven!
            nextViewController.tagExpirationDate   = tagExpirationDate!
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
    
}
