//
//  VehicleInsuranceDetailsViewController.swift
//  CoxAxle
//
//  Created by Nilesh Pol on 29/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import YLProgressBar
import Alamofire

protocol VehicleAddedDelegate {
    
    func clearUIFields()
}

class VehicleInsuranceDetailsViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Properties
    
    @IBOutlet var progressBar               : YLProgressBar!
    @IBOutlet var vehicleInsuranceTableView : UITableView!
    
    var imagePicker = UIImagePickerController()
    var insuranceCardImageView   = UIImageView()
    var insuranceCardImagesArray = [UIImage]()
    
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var vehicleName         : String?
    var vehicleType         : String?
    var vehicleMake         : String?
    var vehicleModel        : String?
    var vehiclePurchaseYear : String?
    var vinNumber           : String?
    var milesDriven         : String?
    var tagExpirationDate   : String?
    var insuranceExpirationDate: String?
    var isDatePickerSelected: Bool?
    var vehicleImagesArray  = [UIImage]()
    
    var delegate: VehicleAddedDelegate?
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "VehicleInsuranceDetailsViewController"
        self.navigationItem.title = "Insurance Details"
        
        setProgressBarProperties()
    }
    
    func setProgressBarProperties() {
        
        progressBar.type           = .Flat
        progressBar.trackTintColor = UIColor.SlateColor().colorWithAlphaComponent(0.4)
        
        let titleLabel             = UILabel(frame: CGRect(x:  0, y: 0, width: screenWidth/2, height: 15))
        titleLabel.text            = "Step 2 of 4"
        titleLabel.textAlignment   = .Center
        titleLabel.font            = UIFont.boldFont().fontWithSize(10)
        titleLabel.backgroundColor = UIColor.orangeColor()
        titleLabel.textColor       = UIColor.whiteColor()
        
        progressBar.addSubview(titleLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        switch indexPath.row {
            
        case 0:
            
            let vehicleInsuranceDetailsTableViewCell: VehicleInsuranceDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("InsuranceExpirationDateCell", forIndexPath: indexPath) as! VehicleInsuranceDetailsTableViewCell
            
            if let leftLabel = vehicleInsuranceDetailsTableViewCell.leftLabel {
                
                leftLabel.text = "Expiration Date"
            }
            
            if let insuranceExpireDate = insuranceExpirationDate {
                vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(insuranceExpireDate, forState: .Normal)
            }
            
            vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.selectInsuranceExpirationExpirationDate(_:)), forControlEvents: .TouchUpInside)
            
            return vehicleInsuranceDetailsTableViewCell
            
        case 1:
            
            let insuranceDatePickerTableViewCell: DatePickerTableViewCell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerTableViewCell
            
            insuranceDatePickerTableViewCell.doneButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.pickerDoneButtonAction), forControlEvents: .TouchUpInside)
            return insuranceDatePickerTableViewCell
            
        case 2:
            
            let insuranceCardTableViewCell: InsuranceCardTableViewCell = tableView.dequeueReusableCellWithIdentifier("InsuranceCardTableViewCell", forIndexPath: indexPath) as! InsuranceCardTableViewCell
            insuranceCardTableViewCell.uploadInsuranceCardPictureButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.uploadInsuranceCardPic), forControlEvents: .TouchUpInside)
            
            insuranceCardTableViewCell.insuranceCardsCollectionView.reloadData()
            
            return insuranceCardTableViewCell
            
        default: return cell
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            if isDatePickerSelected == true {
                return 290
            } else {
                return 0
            }
        case 2:
            return 130
        default:
            return 0
        }
    }
    
    //MARK:- CollectionView Method
    
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
    
    //MARK:- Action Selector Method
    
    func uploadInsuranceCardPic() {
        
        //        if insuranceCardImagesArray.count == 4  || insuranceCardImagesArray.count > 4 {
        //
        //            showAlertwithCancelButton("", message: "You can upload upto only four pictures", cancelButton: "OK")
        //            return
        //        }
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
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func selectInsuranceExpirationExpirationDate(sender: UIButton) {
        
        isDatePickerSelected = true
        vehicleInsuranceTableView.reloadData()
    }
    
    func pickerDoneButtonAction() {
        
        isDatePickerSelected = false
        
        if insuranceExpirationDate == nil || insuranceExpirationDate == "Select Date" || insuranceExpirationDate?.characters.count == 0 {
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.stringFromDate(date)
            insuranceExpirationDate = dateString
        }
        vehicleInsuranceTableView.reloadData()
    }
    
    //MARK:- Image PickerView Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        insuranceCardImageView.image = image
        
        insuranceCardImagesArray.append(image!)
        
        vehicleInsuranceTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func callAddVehicleApi(sender: AnyObject) {
        
        if insuranceExpirationDate == "Select Date" || insuranceExpirationDate == nil || insuranceExpirationDate?.characters.count == 0 {
            
            showAlertwithCancelButton("Error", message: "Please select insurance expiration date", cancelButton: "OK")
            return
        }
        
        if insuranceCardImageView.image == nil || insuranceCardImagesArray.count == 0 {
            
            showAlertwithCancelButton("Error", message: "Please upload insurance card", cancelButton: "OK")
            return
        }
        
        callAddVehicleAPI()
    }
    
    @IBAction func datePickerChanged(datePicker: UIDatePicker) {
        
        let date                 = NSDate()
        datePicker.minimumDate   = date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        insuranceExpirationDate = dateString
        vehicleInsuranceTableView.reloadData()
    }
    
    @IBAction func removeCard(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.insuranceCardImagesArray.removeAtIndex(sender.tag)
            self.vehicleInsuranceTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK:- ADD VEHICLE API
    
    func callAddVehicleAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as! String
            
            var base64VehicleImagesArray = [String]()
            for index in 0...(vehicleImagesArray.count - 1) {
                
                let eachImage: UIImage = vehicleImagesArray[index]
                //                let eachImageData: NSData = UIImagePNGRepresentation(eachImage)!
                let eachImageData = eachImage.highQualityJPEGNSData
                let base64ImageString: String = eachImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                base64VehicleImagesArray.append(base64ImageString)
            }
            let vehicleImagesBase64String = base64VehicleImagesArray.joinWithSeparator(",")
            
            var base64InsurancecardsArray = [String]()
            for index in 0...(insuranceCardImagesArray.count - 1) {
                
                let eachImage: UIImage = insuranceCardImagesArray[index]
                //                let eachImageData: NSData = UIImagePNGRepresentation(eachImage)!
                let eachImageData = eachImage.highQualityJPEGNSData
                let base64ImageString: String = eachImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                base64InsurancecardsArray.append(base64ImageString)
            }
            let insuranceCardImagesBase64String = base64InsurancecardsArray.joinWithSeparator(",")
            
            //            let fileURL = NSBundle.mainBundle().URLForResource("demo", withExtension: "docx")
            //            let data: NSData = NSData(contentsOfURL: fileURL!)!
            //            let insuranceBase64:String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let paramsDict: [String : AnyObject] = [
                "name": vehicleName!,
                "uid": userId,
                "dealer_id": "2",
                "vehicle_type": vehicleType!,
                "make": vehicleMake!,
                "vin": vinNumber!,
                "model": vehicleModel!,
                "year": vehiclePurchaseYear!,
                "color": "White",
                "waranty_from": "5",
                "waranty_to": "10",
                "extended_waranty_from": "3",
                "extended_waranty_to": "8",
                "expiration_date" : insuranceExpirationDate!,
                "insurance_card" : "rt",
                "tag_expiration_date" : tagExpirationDate!,
                "kbb_price": "0001",
                "manual": "xyz",
                "loan_amount": "100",
                "emi": "50",
                "interest": "7",
                "loan_tenure": "3",
                "mileage": milesDriven!,
                "style": "sedan",
                "trim": "vxi",
                "photo": vehicleImagesBase64String,
                "insurance_document": insuranceCardImagesBase64String] as Dictionary
            
            //          print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/create", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    
                    if let JSON = response.result.value {
                        
                        //          print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        
                        let responseMessage = JSON.valueForKey("message") as! String
                        let status = JSON.valueForKey("status") as! String
                        
                        if status == "True"  {
                            do {
                                let dict: AddVehicle = try AddVehicle(dictionary: JSON as! [NSObject : AnyObject])
                                
                                print(dict)
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                            
                            let alertController = UIAlertController(title: "Success", message: responseMessage, preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                                
                                self.delegate?.clearUIFields()
                                
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                            
                            alertController.addAction(defaultAction)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(alertController, animated: true, completion: nil)
                            })
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
            showAlertwithCancelButton("No Internet Connection", message: "Make sure your device is connected to the internet.", cancelButton: "OK")
        }
    }
    
}

//MARK:- Image Extension to Compress Images

extension UIImage {
    
    var uncompressedPNGData: NSData {
        return UIImagePNGRepresentation(self)!
    }
    
    var highestQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 1.0)!
    }
    
    var highQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.75)!
    }
    
    var mediumQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.5)!
    }
    
    var lowQualityJPEGNSData: NSData {
        return UIImageJPEGRepresentation(self, 0.25)!
    }
    
    var lowestQualityJPEGNSData:NSData {
        return UIImageJPEGRepresentation(self, 0.0)!
    }
}