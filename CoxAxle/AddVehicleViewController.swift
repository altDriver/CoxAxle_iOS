//
//  AddVehicleViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class AddVehicleViewController: UIViewController, UIAlertController_UIAlertView {
    var language: String?
    
     //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setText()
       // self.addVehicleButtonClicked()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    func addVehicleButtonClicked() -> Void {
        self.callAddVehicleAPI()
    }
    
    //MARK:- ADD VEHICLE API
    func callAddVehicleAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let token: String = NSUserDefaults.standardUserDefaults().objectForKey("Token") as! String
          let image : UIImage = UIImage(named: "carImg")!
         //Now use image to create into NSData format
         let imageData:NSData = UIImagePNGRepresentation(image)!
         
         let strBase64:String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
        let fileURL = NSBundle.mainBundle().URLForResource("demo", withExtension: "docx")
        let data: NSData = NSData(contentsOfURL: fileURL!)!
        let insuranceBase64:String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
         
         let paramsDict: [ String : AnyObject] = ["name": "Audi A4", "token": token, "uid": "21", "dealer_id": "2", "vin": "5J6RE3H74AL049454", "vehicle_type": "Volvo", "make": "Audi", "model": "Sub", "color": "White", "photo": strBase64, "waranty_from": "5", "waranty_to": "10", "extended_waranty_from": "3", "extended_waranty_to": "8", "kbb_price": "100", "loan_amount": "100", "emi": "50", "interest": "7", "loan_tenure": "3", "mileage": "54321", "style": "sedan", "trim": "vxi", "year": "2015", "insurance_document": insuranceBase64, "manual": ""] as Dictionary
         print(NSString(format: "Request: %@", paramsDict))
            
            
         Alamofire.request(.POST, Constant.API.kBaseUrlPath+"vehicle/create", parameters: paramsDict)
         .responseJSON { response in
         loading.hide()
         if let JSON = response.result.value {
         
            print(NSString(format: "Response: %@", JSON as! NSDictionary))
            let sessionStatus = JSON.valueForKey("session_status") as! String
            if sessionStatus == "1" {
            let status = JSON.valueForKey("status") as! String
            if status == "True"  {
                do {
                    let dict: AddVehicle = try AddVehicle(dictionary: JSON as! [NSObject : AnyObject])
                    
                    print(dict)
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
            else {
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SESSION_EXPIRED")
                NSUserDefaults.standardUserDefaults().synchronize()
                let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("SessionExpired")
                self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
            }
        }
    }
        }
        else {
            print("Internet connection FAILED")
            showAlertwithCancelButton("No Internet Connection", message: "Make sure your device is connected to the internet.", cancelButton: "OK")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
