//
//  InventorySearchViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 08/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class InventorySearchViewController: GAITrackedViewController, UIAlertController_UIAlertView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    var engineGroupsNamesArray: NSMutableArray = NSMutableArray()
    var styleNamesArray: NSMutableArray = NSMutableArray()
    var yearNamesArray: NSMutableArray = NSMutableArray()

    @IBOutlet var makeTextField: UITextField!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var modelTextField: UITextField!
    
    @IBOutlet var trimTextField: UITextField!
    
    @IBOutlet var engineGroupTextField: UITextField!
    
    @IBOutlet var styleTextField: UITextField!
    
    @IBOutlet var yearTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenName = "InventorySearchViewController"
        self.callSearchFiltersAPI()
        
        pickerView.isHidden = true;
        makeTextField.placeholder = "Select Make"
        modelTextField.placeholder = "Select Model"
        trimTextField.placeholder = "Select Trim"
        engineGroupTextField.placeholder = "Select Engine"
        styleTextField.placeholder = "Select Style"
        yearTextField.placeholder = "Select Year"
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIBUTTON ACTIONS
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.performSegue(withIdentifier: "InventorySearch", sender: self)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- FETCH AUTO TRADER SEARCH FILTERS API
    func callSearchFiltersAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Auto Trader Search Filters API Called", label: "Auto Trader Search Filters", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            Alamofire.request(Constant.API.kBaseUrlPath+"searchfilters", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: AutoTraderSearchFilters = try AutoTraderSearchFilters(dictionary: JSON as! [AnyHashable: Any])
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
                            let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
                        }
                    }
            }
        }
        else {
            print("Internet connection FAILED")
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- SETTING DATA
    func setData() -> Void {
        if pickerView.tag == 1 {
            self.makeNamesArray.removeAllObjects()
            if makesArray.count > 0 {
            for (index, value) in self.makesArray.enumerated() {
                self.makeNamesArray.add(value.value(forKey: "name")! as! String)
            }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Makes not available", cancelButton: "OK")
            }
        }
        else if pickerView.tag == 2 {
            self.modelNamesArray.removeAllObjects()
            if modelsArray.count > 0 {
            for (index, value) in self.modelsArray.enumerated() {
                self.modelNamesArray.add(value.value(forKey: "name")! as! String)
            }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Please select make", cancelButton: "OK")
            }
        }
        else if pickerView.tag == 3 {
            self.trimsNamesArray.removeAllObjects()
            if trimsArray.count > 0 {
                for (index, value) in self.trimsArray.enumerated() {
                    self.trimsNamesArray.add(value.value(forKey: "name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Please select model or no trims found for this model", cancelButton: "OK")
            }
        }
        else if pickerView.tag == 4 {
            self.engineGroupsNamesArray.removeAllObjects()
            if engineGroupsArray.count > 0 {
                for (index, value) in self.engineGroupsArray.enumerated() {
                    self.engineGroupsNamesArray.add(value.value(forKey: "name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "No Engine Groups found for this model", cancelButton: "OK")
            }
        }
        else if pickerView.tag == 5 {
            self.styleNamesArray.removeAllObjects()
            if stylesArray.count > 0 {
                for (index, value) in self.stylesArray.enumerated() {
                    self.styleNamesArray.add(value.value(forKey: "name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "No Styles found for this model", cancelButton: "OK")
            }
        }
        else {
            self.yearNamesArray.removeAllObjects()
            if yearsArray.count > 0 {
                for (index, value) in self.yearsArray.enumerated() {
                    self.yearNamesArray.add(String(describing: value))
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "No Years found for this model", cancelButton: "OK")
            }
        }
        
        self.pickerView.reloadAllComponents()
       
    }
    
  
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 1 {
            return self.makeNamesArray.count
        }
        else if pickerView.tag == 2 {
            return self.modelNamesArray.count
        }
        else if pickerView.tag == 3 {
            return self.trimsNamesArray.count
        }
        else if pickerView.tag == 4 {
            return self.engineGroupsNamesArray.count
        }
        else if pickerView.tag == 5 {
            return self.styleNamesArray.count
        }
        else {
            return self.yearNamesArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.makeNamesArray[row] as? String
        }
        else if pickerView.tag == 2 {
            return self.modelNamesArray[row] as? String
        }
        else if pickerView.tag == 3 {
            return self.trimsNamesArray[row] as? String
        }
        else if pickerView.tag == 4 {
            return self.engineGroupsNamesArray[row] as? String
        }
        else if pickerView.tag == 5 {
            return self.styleNamesArray[row] as? String
        }
        else {
            return self.yearNamesArray[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            makeTextField.text = self.makeNamesArray[row] as? String
            self.modelsArray = self.makesArray[row].value(forKey: "models") as! Array<AnyObject>
            self.setData()
        }
        else if pickerView.tag == 2 {
            modelTextField.text = self.modelNamesArray[row] as? String
            if self.modelsArray[row].value(forKey: "trims") != nil {
             self.trimsArray = self.modelsArray[row].value(forKey: "trims") as! Array<AnyObject>
            self.setData()
            }
            else {
                self.trimsArray = [AnyObject]()
            }
        }
        else if pickerView.tag == 3 {
            trimTextField.text = self.trimsNamesArray[row] as? String
        }
        else if pickerView.tag == 4 {
            engineGroupTextField.text = self.engineGroupsNamesArray[row] as? String
        }
        else if pickerView.tag == 5 {
            styleTextField.text = self.styleNamesArray[row] as? String
        }
        else {
            yearTextField.text = self.yearNamesArray[row] as? String
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        if textField == makeTextField {
            pickerView.tag = 1
        }
        else if textField == modelTextField {
            pickerView.tag = 2
        }
        else if textField == trimTextField {
            pickerView.tag = 3
        }
        else if textField == engineGroupTextField {
            pickerView.tag = 4
        }
        else if textField == styleTextField {
            pickerView.tag = 5
        }
        else {
            pickerView.tag = 6
        }
        self.setData()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerView.isHidden = true;
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "InventorySearch" {
            let searchDetails = (segue.destination as! InventoryResultsViewController)
            searchDetails.make = self.makeTextField.text
            searchDetails.model = self.modelTextField.text
            searchDetails.trim = self.trimTextField.text
            searchDetails.engineGroup = self.engineGroupTextField.text
            searchDetails.style = self.styleTextField.text
            searchDetails.year = self.yearTextField.text
        }
    }

}
