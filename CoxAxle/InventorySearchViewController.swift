//
//  InventoryViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 08/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class InventoryViewController: GAITrackedViewController, UIAlertController_UIAlertView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var makesArray = [AnyObject]()
    var engineGroupsArray = [AnyObject]()
    var extColorGroupsArray = [AnyObject]()
    var intColorGroupsArray = [AnyObject]()
    var stylesArray = [AnyObject]()
    var yearsArray = [AnyObject]()
    
    var modelsArray = [AnyObject]()
    var trimsArray = [AnyObject]()
    
    var makeNamesArray: NSMutableArray = NSMutableArray()
    var modelNamesArray: NSMutableArray = NSMutableArray()
    var trimsNamesArray: NSMutableArray = NSMutableArray()

    @IBOutlet var makeTextField: UITextField!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var modelTextField: UITextField!
    
    @IBOutlet var trimTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenName = "InventoryViewController"
        self.callSearchFiltersAPI()
        
        pickerView.hidden = true;
        makeTextField.placeholder = "Select Make"
        modelTextField.placeholder = "Select Model"
        trimTextField.placeholder = "Select Trim"
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- FETCH AUTO TRADER SEARCH FILTERS API
    func callSearchFiltersAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEventWithCategory("API", action: "Fetching Auto Trader Search Filters API Called", label: "Auto Trader Search Filters", value: nil).build()
            tracker.send(trackDictionary as AnyObject as! [NSObject : AnyObject])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            Alamofire.request(.GET, Constant.API.kBaseUrlPath+"searchfilters")
                .responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                let dict: AutoTraderSearchFilters = try AutoTraderSearchFilters(dictionary: JSON as! [NSObject : AnyObject])
                                self.makesArray = dict.response?.makes as! Array<AnyObject>
                                self.engineGroupsArray = dict.response?.engineGroups as! Array<AnyObject>
                                self.extColorGroupsArray = dict.response?.extColorGroups as! Array<AnyObject>
                                self.intColorGroupsArray = dict.response?.intColorGroups as! Array<AnyObject>
                                self.stylesArray = dict.response?.styles as! Array<AnyObject>
                                self.yearsArray = dict.response?.years as! Array<AnyObject>
                                
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
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("NoInternetConnection")
            self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- SETTING DATA
    func setData() -> Void {
        if pickerView.tag == 1 {
            self.makeNamesArray.removeAllObjects()
            if makesArray.count > 0 {
            for (index, value) in self.makesArray.enumerate() {
                self.makeNamesArray.addObject(value.valueForKey("name")! as! String)
            }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Makes not available", cancelButton: "OK")
            }
        }
        else if pickerView.tag == 2 {
            self.modelNamesArray.removeAllObjects()
            if modelsArray.count > 0 {
            for (index, value) in self.modelsArray.enumerate() {
                self.modelNamesArray.addObject(value.valueForKey("name")! as! String)
            }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Please select make", cancelButton: "OK")
            }
        }
        else {
            self.trimsNamesArray.removeAllObjects()
            if trimsArray.count > 0 {
                for (index, value) in self.trimsArray.enumerate() {
                    self.trimsNamesArray.addObject(value.valueForKey("name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Please select model or no trims found for this model", cancelButton: "OK")
            }
        }
        
        self.pickerView.reloadAllComponents()
       
    }
    
  
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 1 {
            return self.makeNamesArray.count
        }
        else if pickerView.tag == 2 {
            return self.modelNamesArray.count
        }
        else {
            return self.trimsNamesArray.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.makeNamesArray[row] as? String
        }
        else if pickerView.tag == 2 {
            return self.modelNamesArray[row] as? String
        }
        else {
            return self.trimsNamesArray[row] as? String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            makeTextField.text = self.makeNamesArray[row] as? String
            self.modelsArray = self.makesArray[row].valueForKey("models") as! Array<AnyObject>
            self.setData()
        }
        else if pickerView.tag == 2 {
            modelTextField.text = self.modelNamesArray[row] as? String
            if self.modelsArray[row].valueForKey("trims") != nil {
             self.trimsArray = self.modelsArray[row].valueForKey("trims") as! Array<AnyObject>
            self.setData()
            }
            else {
                self.trimsArray = [AnyObject]()
            }
        }
        else {
            trimTextField.text = self.trimsNamesArray[row] as? String
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        pickerView.hidden = false
        if textField == makeTextField {
            pickerView.tag = 1
        }
        else if textField == modelTextField {
            pickerView.tag = 2
        }
        else {
            pickerView.tag = 3
        }
        self.setData()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pickerView.hidden = true;
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
