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
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        
        progressBar.type           = .flat
        progressBar.trackTintColor = UIColor.SlateColor().withAlphaComponent(0.4)
        
        let titleLabel             = UILabel(frame: CGRect(x:  0, y: 0, width: screenWidth/2, height: 15))
        titleLabel.text            = "Step 2 of 4"
        titleLabel.textAlignment   = .center
        titleLabel.font            = UIFont.boldFont().withSize(10)
        titleLabel.backgroundColor = UIColor.orange
        titleLabel.textColor       = UIColor.white
        
        progressBar.addSubview(titleLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        switch (indexPath as NSIndexPath).row {
            
        case 0:
            
            let vehicleInsuranceDetailsTableViewCell: VehicleInsuranceDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InsuranceExpirationDateCell", for: indexPath) as! VehicleInsuranceDetailsTableViewCell
            
            if let leftLabel = vehicleInsuranceDetailsTableViewCell.leftLabel {
                
                leftLabel.text = "Expiration Date"
            }
            
            if let insuranceExpireDate = insuranceExpirationDate {
                vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.setTitle(insuranceExpireDate, for: UIControlState())
            }
            
            vehicleInsuranceDetailsTableViewCell.insuranceExpirationDateButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.selectInsuranceExpirationExpirationDate(_:)), for: .touchUpInside)
            
            return vehicleInsuranceDetailsTableViewCell
            
        case 1:
            
            let insuranceDatePickerTableViewCell: DatePickerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! DatePickerTableViewCell
            
            insuranceDatePickerTableViewCell.doneButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.pickerDoneButtonAction), for: .touchUpInside)
            return insuranceDatePickerTableViewCell
            
        case 2:
            
            let insuranceCardTableViewCell: InsuranceCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCardTableViewCell", for: indexPath) as! InsuranceCardTableViewCell
            insuranceCardTableViewCell.uploadInsuranceCardPictureButton.addTarget(self, action: #selector(VehicleInsuranceDetailsViewController.uploadInsuranceCardPic), for: .touchUpInside)
            
            insuranceCardTableViewCell.insuranceCardsCollectionView.reloadData()
            
            return insuranceCardTableViewCell
            
        default: return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath as NSIndexPath).row {
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
    
    //MARK:- Action Selector Method
    
    func uploadInsuranceCardPic() {
        
        //        if insuranceCardImagesArray.count == 4  || insuranceCardImagesArray.count > 4 {
        //
        //            showAlertwithCancelButton("", message: "You can upload upto only four pictures", cancelButton: "OK")
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
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func selectInsuranceExpirationExpirationDate(_ sender: UIButton) {
        
        isDatePickerSelected = true
        vehicleInsuranceTableView.reloadData()
    }
    
    func pickerDoneButtonAction() {
        
        isDatePickerSelected = false
        
        if insuranceExpirationDate == nil || insuranceExpirationDate == "Select Date" || insuranceExpirationDate?.characters.count == 0 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: date)
            insuranceExpirationDate = dateString
        }
        vehicleInsuranceTableView.reloadData()
    }
    
    //MARK:- Image PickerView Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        insuranceCardImageView.image = image
        
        insuranceCardImagesArray.append(image!)
        
        vehicleInsuranceTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func callAddVehicleApi(_ sender: AnyObject) {
        
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
    
    @IBAction func datePickerChanged(_ datePicker: UIDatePicker) {
        
        let date                 = Date()
        datePicker.minimumDate   = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        insuranceExpirationDate = dateString
        vehicleInsuranceTableView.reloadData()
    }
    
    @IBAction func removeCard(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.insuranceCardImagesArray.remove(at: sender.tag)
            self.vehicleInsuranceTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- ADD VEHICLE API
    
    func callAddVehicleAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Add Vehicle API Called", label: "Add Vehicle", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            
            var base64VehicleImagesArray = [String]()
            for index in 0...(vehicleImagesArray.count - 1) {
                
                let eachImage: UIImage = vehicleImagesArray[index]
                //                let eachImageData: NSData = UIImagePNGRepresentation(eachImage)!
                let eachImageData = eachImage.highQualityJPEGNSData
                let base64ImageString: String = eachImageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                base64VehicleImagesArray.append(base64ImageString)
            }
            let vehicleImagesBase64String = base64VehicleImagesArray.joined(separator: ",")
            
            var base64InsurancecardsArray = [String]()
            for index in 0...(insuranceCardImagesArray.count - 1) {
                
                let eachImage: UIImage = insuranceCardImagesArray[index]
                //                let eachImageData: NSData = UIImagePNGRepresentation(eachImage)!
                let eachImageData = eachImage.highQualityJPEGNSData
                let base64ImageString: String = eachImageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                base64InsurancecardsArray.append(base64ImageString)
            }
            let insuranceCardImagesBase64String = base64InsurancecardsArray.joined(separator: ",")
            
            //            let fileURL = NSBundle.mainBundle().URLForResource("demo", withExtension: "docx")
            //            let data: NSData = NSData(contentsOfURL: fileURL!)!
            //            let insuranceBase64:String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            let expirationDate = insuranceExpirationDate!.convertStringToDate()
            let tagExpiryDate = tagExpirationDate!.convertStringToDate()

            
            let paramsDict: [String : String] = [
                "name": vehicleName!,
                "uid": userId,
                "dealer_id": "2",
                "vehicle_type": vehicleType!,
                "make": vehicleMake!,
                "vin": vinNumber!,
                "model": vehicleModel!,
                "year": vehiclePurchaseYear!,
                "color": "White",
                "waranty_from": "2015-01-10",
                "waranty_to": "2016-12-31",
                "extended_waranty_from": "3",
                "extended_waranty_to": "8",
                "insurance_expiration_date" : expirationDate,
                "tag_expiration_date" : tagExpiryDate,
                "kbb_price": "",
                "loan_amount": "",
                "emi": "",
                "interest": "",
                "loan_tenure": "",
                "mileage": milesDriven!,
                "style": "sedan",
                "trim": "vxi",
                "photo": vehicleImagesBase64String,
                "insurance_document": insuranceCardImagesBase64String,
                 "extended_waranty_document": ""] as Dictionary
            
            //          print(NSString(format: "Request: %@", paramsDict))
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/create", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    
                    if let JSON = response.result.value {
                        
                        //          print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        
                        let responseMessage = (JSON as AnyObject).value(forKey: "message") as! String
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        
                        if status == "True"  {
                            do {
                                let dict: AddVehicle = try AddVehicle(dictionary: JSON as! [AnyHashable: Any])
                                
                                print(dict)
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                            
                            let alertController = UIAlertController(title: "Success", message: responseMessage, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.delegate?.clearUIFields()
                                
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            alertController.addAction(defaultAction)
                            
                            DispatchQueue.main.async {
                                self.present(alertController, animated: true, completion: nil)
                            }
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
            showAlertwithCancelButton("No Internet Connection", message: "Make sure your device is connected to the internet.", cancelButton: "OK")
        }
    }
    
}

//MARK:- Image Extension to Compress Images

extension UIImage {
    
    var uncompressedPNGData: Foundation.Data {
        return UIImagePNGRepresentation(self)!
    }
    
    var highestQualityJPEGNSData: Foundation.Data {
        return UIImageJPEGRepresentation(self, 1.0)!
    }
    
    var highQualityJPEGNSData: Foundation.Data {
        return UIImageJPEGRepresentation(self, 0.75)!
    }
    
    var mediumQualityJPEGNSData: Foundation.Data {
        return UIImageJPEGRepresentation(self, 0.5)!
    }
    
    var lowQualityJPEGNSData: Foundation.Data {
        return UIImageJPEGRepresentation(self, 0.25)!
    }
    
    var lowestQualityJPEGNSData:Foundation.Data {
        return UIImageJPEGRepresentation(self, 0.0)!
    }
}
