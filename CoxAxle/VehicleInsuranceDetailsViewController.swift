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

class VehicleInsuranceDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    var vehiclePurchaseYear : Int?
    var vinNumber           : String?
    var milesDriven         : String?
    var vehicleImage        : UIImage?
    var tagExpirationDate   : String?
    var insuranceExpirationDate: String?
    var isDatePickerSelected: Bool?
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Insurance Details"
        //        vehicleInsuranceTableView.tableFooterView? = UIView(frame: CGRectZero)
        
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
            
            if insuranceCardImagesArray.count == 0 {
                
                insuranceCardTableViewCell.thumbnailButtonFirst.hidden  = true
                insuranceCardTableViewCell.thumbnailButtonSecond.hidden = true
                insuranceCardTableViewCell.thumbnailButtonThird.hidden  = true
                insuranceCardTableViewCell.thumbnailButtonFourth.hidden = true
            }
            
            if insuranceCardImagesArray.count == 1 {
                
                insuranceCardTableViewCell.thumbnailButtonFirst.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonSecond.hidden = true
                insuranceCardTableViewCell.thumbnailButtonThird.hidden  = true
                insuranceCardTableViewCell.thumbnailButtonFourth.hidden = true
            }
            
            if insuranceCardImagesArray.count == 2 {
                
                insuranceCardTableViewCell.thumbnailButtonFirst.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonSecond.hidden = false
                insuranceCardTableViewCell.thumbnailButtonThird.hidden  = true
                insuranceCardTableViewCell.thumbnailButtonFourth.hidden = true
            }
            
            if insuranceCardImagesArray.count == 3 {
                
                insuranceCardTableViewCell.thumbnailButtonFirst.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonSecond.hidden = false
                insuranceCardTableViewCell.thumbnailButtonThird.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonFourth.hidden = true
            }
            
            if insuranceCardImagesArray.count == 4 {
                
                insuranceCardTableViewCell.thumbnailButtonFirst.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonSecond.hidden = false
                insuranceCardTableViewCell.thumbnailButtonThird.hidden  = false
                insuranceCardTableViewCell.thumbnailButtonFourth.hidden = false
            }
            
            insuranceCardTableViewCell.thumbnailButtonFirst.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.removeThumbnail), forControlEvents: .TouchUpInside)
            
            insuranceCardTableViewCell.thumbnailButtonSecond.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.removeThumbnail), forControlEvents: .TouchUpInside)
            
            insuranceCardTableViewCell.thumbnailButtonThird.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.removeThumbnail), forControlEvents: .TouchUpInside)
            
            insuranceCardTableViewCell.thumbnailButtonFourth.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.removeThumbnail), forControlEvents: .TouchUpInside)
            
            insuranceCardTableViewCell.uploadInsuranceCardPictureButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.uploadInsuranceCardPic), forControlEvents: .TouchUpInside)
            
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
            return 143
        default:
            return 0
        }
    }
    
    //MARK:- Action Selector Method
    
    func uploadInsuranceCardPic() {
        
        if insuranceCardImagesArray.count == 4  || insuranceCardImagesArray.count > 4 {
            
            showAlertwithCancelButton("", message: "You can upload upto only four pictures", cancelButton: "OK")
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
    
    func removeThumbnail() {
        
        if insuranceCardImagesArray.count == 0 {
            return
        }
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.insuranceCardImagesArray.removeLast()
            self.vehicleInsuranceTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Image PickerView Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if insuranceCardImagesArray.count == 4  || insuranceCardImagesArray.count > 4 {
            
            showAlertwithCancelButton("", message: "You can upload upto only four photos", cancelButton: "OK")
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
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
        
        if insuranceCardImageView.image == nil {
            
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
    
    //MARK:- ADD VEHICLE API
    func callAddVehicleAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = NSUserDefaults.standardUserDefaults().objectForKey("UserId") as! String
            let image : UIImage = UIImage(named: "bannerBg.png")!
            
            //Now use image to create into NSData format
            let imageData:NSData = UIImagePNGRepresentation(image)!
            
            let strBase64:String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let fileURL = NSBundle.mainBundle().URLForResource("demo", withExtension: "docx")
            let data: NSData = NSData(contentsOfURL: fileURL!)!
            let insuranceBase64:String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
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
                                                    "kbb_price": "0001",
                                                    "manual": "",
                                                    "loan_amount": "100",
                                                    "emi": "50",
                                                    "interest": "7",
                                                    "loan_tenure": "3",
                                                    "mileage": milesDriven!,
                                                    "style": "sedan",
                                                    "trim": "vxi",
                                                    "photo": strBase64,
                                                    "insurance_document": insuranceBase64] as Dictionary
            
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/create", parameters: paramsDict)
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        
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
                            
                            self.showAlertwithCancelButton("Success", message: responseMessage, cancelButton: "OK")
                            
                            self.navigationController?.popViewControllerAnimated(true)
                            
                            //                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            //                            let controller = storyboard.instantiateViewControllerWithIdentifier("AddVehicleView") as! AddVehicleViewController
                            //                            self.presentViewController(controller, animated: true, completion: nil)
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
