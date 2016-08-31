//
//  CreateAccount.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class CreateAccount: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView{
    
    let cellReuseIdentifier = "RegisterCell"
    var language: String?
    
    @IBOutlet weak var tableView: UITableView!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        self.setText()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAccount.setText), name: "LanguageChanged", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = NSUserDefaults.standardUserDefaults().objectForKey("CurrentLanguage") as? String
        self.title = "Register".localized(self.language!)
        
        self.tableView.reloadData()
    }
    
    //MARK:- UITableView Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
             return 3
        case 1:
             return 13
        case 2:
             return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personal Information".localized(self.language!)
        case 1:
            return "Vehicle Information".localized(self.language!)
        case 2:
            return "Address".localized(self.language!)
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        let textField: UITextField = cell.viewWithTag(200) as! UITextField
        
        
        switch indexPath.section {
        case 0:
        
            switch indexPath.row {
            case 0:
                textField.placeholder = "Name".localized(self.language!)
                textField.attributedPlaceholder = NSAttributedString(string:"Name".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
                
            case 1:
                 textField.placeholder = "Email or Phone number".localized(self.language!)
                 textField.attributedPlaceholder = NSAttributedString(string:"Email or Phone number".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
                
            case 2:
                 textField.placeholder = "Password".localized(self.language!)
                 textField.attributedPlaceholder = NSAttributedString(string:"Password".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
                
            default:
                break
            }
            
        break
            
        case 1:
            
            switch indexPath.row {
            case 0:
                  textField.placeholder = "VIN".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"VIN".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 1:
                  textField.placeholder = "Dongle Details (Optional)".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Dongle Details (Optional)".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 2:
                  textField.placeholder = "Warranty (Optional)".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Warranty (Optional)".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 3:
                  textField.placeholder = "Extended Warranty (Optional)".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Extended Warranty (Optional)".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 4:
                  textField.placeholder = "Loan Amount Details (Optional)".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Loan Amount Details (Optional)".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 5:
                  textField.placeholder = "Finance / Lease / Own Vehicle".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Finance / Lease / Own Vehicle".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 6:
                  textField.placeholder = "Tag Renewal Date (Optional)".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Tag Renewal Date (Optional)".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 7:
                  textField.placeholder = "Make".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Make".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 8:
                  textField.placeholder = "Model".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Model".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 9:
                  textField.placeholder = "Year".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Year".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 10:
                  textField.placeholder = "Color".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Color".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 11:
                  textField.placeholder = "Trim".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Trim".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            case 12:
                  textField.placeholder = "Mileage".localized(self.language!)
                  textField.attributedPlaceholder = NSAttributedString(string:"Mileage".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            default:
                
            break
            }
            
        break
            
        case 2:
            
            switch indexPath.row {
            case 0:
                 textField.placeholder = "Zip Code".localized(self.language!)
                 textField.attributedPlaceholder = NSAttributedString(string:"Zip Code".localized(self.language!), attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            break
            default:
            break
            }
        
        break
            
        default: break
    
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
        
    }

    // MARK:- UIBUTTON ACTIONS
    @IBAction func registerClicked(sender: UIButton) {
        self.callRegisterationAPI()
    }
    
    
    // MARK:- REGISTERATION API
    
    func callRegisterationAPI() -> Void {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let fileURL = NSBundle.mainBundle().URLForResource("demo", withExtension: "docx")
            let data: NSData = NSData(contentsOfURL: fileURL!)!
            let insuranceBase64:String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
             let paramsDict: [String : AnyObject] = ["first_name": "Adam", "last_name": "Kalluru", "password": "qwerty", "email": "adam.kalluru1@vensaiinc.com", "phone": "1234567890", "user_type": "user", "dealer_code": "KH001", "dl_expiry_date": "5", "photo": "iVBORw0KGgoAAAANSUhEUgAAAyAAAAH0CAYAAADFQEl4AAAAAXNSR0IArs4c6QAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAD6AAAAKAAAAPoAAAD6AABVRo42IZsAAEAASURBVHgB7N0HfBvl", "vin": "KFHIDO456LGDFNL748", "dongle_name": "WIFI", "waranty_from": "1", "waranty_to": "7", "extended_waranty_from": "3", "extended_waranty_to": "6", "loan_amount": "1000", "emi": "100", "interest": "9", "loan_tenure": "6", "language": "EN", "tag_renewal_date": "9", "color": "Silver", "hypothecate": "self", "make": "2015", "mileage": "12345", "model": "luxury", "style": "semi", "trim": "vxi", "vehicle_type": "Sedan", "year": "2016", "zip_code": "500020", "insurance_document": insuranceBase64, "manual": ""] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))

            
            Alamofire.request(.POST, Constant.API.kBaseUrlPath+"register", parameters: paramsDict)
                .responseJSON { response in
                
                loading.hide()
                    
                    if let JSON = response.result.value {
                        
                    print(NSString(format: "Response: %@", JSON as! NSDictionary))
                    let status = JSON.valueForKey("status") as! String
                    if status == "True" {
                        do {
                            let dict: Register = try Register(dictionary: JSON as! [NSObject : AnyObject])
                            
                            print(dict.response!.data)
                        }
                        catch let error as NSError {
                            NSLog("Unresolved error \(error), \(error.userInfo)")
                        }
                        
                        let mainVcIntial = constantObj.SetIntialMainViewController("HomeVC")
                        UIApplication.sharedApplication().keyWindow?.rootViewController = mainVcIntial
                    }
                    else
                    {
                        let errorMsg = JSON.valueForKey("message") as! String
                        self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                    }
                    }

            }
            
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
        
    }
}
