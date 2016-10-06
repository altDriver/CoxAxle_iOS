//
//  InventorySearchViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 08/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import TTRangeSlider

class InventorySearchViewController: GAITrackedViewController, UIAlertController_UIAlertView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, TTRangeSliderDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet var inventorySearchTableView: UITableView!
    @IBOutlet var pkrView: UIPickerView!
    @IBOutlet var searchNameView: UIView!
    @IBOutlet var searchNameTextField: UITextField!
    @IBOutlet var saveSearchNameButton: UIButton!
    @IBOutlet var cancelSearchNameButton: UIButton!
    
    @IBOutlet var pickerMenuView: UIView!
    //MARK:- CELL REUSE IDENTIFIERS
    
    let basicFilterOptionsCellReuseIdentifier = "BasicFilterOptionsCell"
    let priceRangeCellReuseIdentifier = "PriceRangeCell"
    let selectMoreOptionsCellReuseIdentifier = "SelectMoreOptionsCell"
    let selectColorCellReuseIdentifier = "SelectColorCell"
    let pickerCellReuseIdentifier = "PickerCell"
    
    //MARK:- PROPERTIES
    
    var isMoreOptionsButtonSelected: Bool = false
    var isColorCellSelected: Bool = false
    var isBodyStyleCellSelected: Bool = false
    var isEngineTypeCellSelected: Bool = false
    var isPriceSliderSelected: Bool = false
    var isMileageSliderSelected: Bool = false
    
    var makesArray = [AnyObject]()
    var engineGroupsArray = [AnyObject]()
    var extColorGroupsArray = [AnyObject]()
    var intColorGroupsArray = [AnyObject]()
    var stylesArray = [AnyObject]()
    var yearsArray = [AnyObject]()
    var modelsArray = [AnyObject]()
    var trimsArray = [AnyObject]()
    
    var makeNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    var modelNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    var yearNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    var colorsNamesArray = [String]()
    var styleNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    var engineGroupsNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    var trimsNamesArray = [String]()//: NSMutableArray = NSMutableArray()
    
    //MARK:- SELECTED ASSETS
    
    var selectedMake: String?
    var selectedModel: String?
    var selectedYear: String?
    var selectedColor: String?
    var selectedStyle: String?
    var selectedEngineType: String?
    
    var selectedPriceMinValue: String?
    var selectedPriceMaxValue: String?
    var selectedMileageMinValue: String?
    var selectedMileageMaxValue: String?
    
    var searchName: String?
    
    //MARK:- VIEW LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenName = "InventorySearchViewController"
        self.inventorySearchTableView.tableFooterView = UIView()
        
        self.callSearchFiltersAPI()
        
        pkrView.backgroundColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
        
        self.searchNameView?.backgroundColor = UIColor.SlateColor().withAlphaComponent(0.7)
        self.searchNameView.isHidden = true
        pickerMenuView.isHidden = true
        
        self.setViewBorder(saveSearchNameButton)
        self.setViewBorder(searchNameTextField)
        self.setViewBorder(cancelSearchNameButton)
    }
    
    func setViewBorder(_ view: UIView) {
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUTTON ACTION METHODS
    
    @IBAction func makeButtonTapped(_ sender: AnyObject) {
        pickerMenuView.isHidden = false
        pkrView.tag = 1
        self.setData(tag: 1)
    }
    
    @IBAction func modelButtonTapped(_ sender: AnyObject) {
        pickerMenuView.isHidden = false
        pkrView.tag = 2
        self.setData(tag: 2)
    }
    
    @IBAction func yearButtonTapped(_ sender: AnyObject) {
        pickerMenuView.isHidden = false
        pkrView.tag = 3
        self.setData(tag: 3)
    }
    
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        if self.isValidationSuccessfull() == true {
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "InventorySearch", sender: self)
            }
            
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveSearchButtonClicked(_ sender: AnyObject) {
        
        if self.isValidationSuccessfull() == true {
            
            self.searchNameView.isHidden = false
            self.inventorySearchTableView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func saveSearchName(_ sender: AnyObject) {
        
        if self.searchNameTextField.text == nil || self.searchNameTextField.text?.characters.count == 0 || self.searchNameTextField.text == "" {
            
            self.showAlertwithCancelButton("Error", message: "Please enter Search name", cancelButton: "OK")
            return
        }
        self.searchName = self.searchNameTextField.text
        self.inventorySearchTableView.isUserInteractionEnabled = true
        self.searchNameTextField.resignFirstResponder()
        self.callSaveSearchApi(searchName: self.searchName!)
    }
    
    @IBAction func cancelSearchName(_ sender: AnyObject) {
        self.searchNameView.isHidden = true
        self.inventorySearchTableView.isUserInteractionEnabled = true
    }
    
    func isValidationSuccessfull() -> Bool {
        
        if self.selectedMake == nil && self.selectedModel == nil && self.selectedYear == nil && self.selectedColor == nil && self.selectedStyle == nil && self.selectedEngineType == nil {
            
            self.showAlertwithCancelButton("Error", message: "Please select atleast one of the filter options", cancelButton: "OK")
            return false
        }
        return true
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        pickerMenuView.isHidden = true
        
        self.inventorySearchTableView.reloadData()
    }
    
    func moreOptionsClicked() -> Void {
        isMoreOptionsButtonSelected = !isMoreOptionsButtonSelected
        isColorCellSelected = false
        isBodyStyleCellSelected = false
        isEngineTypeCellSelected = false
        
        if isMoreOptionsButtonSelected == true {
            self.inventorySearchTableView.reloadData()
            let indexPath = IndexPath(row: 6, section: 0)
            self.inventorySearchTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        }
        
        self.inventorySearchTableView.reloadData()
    }
    //MARK:- SETTING DATA
    
    func setData(tag: Int) -> Void {
        
        if tag == 1 {
            self.makeNamesArray.removeAll()
            if makesArray.count > 0 {
                for (_, value) in self.makesArray.enumerated() {
                    self.makeNamesArray.append(value.value(forKey: "name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Makes not available", cancelButton: "OK")
            }
        }
        else if tag == 2 {
            self.modelNamesArray.removeAll()
            if modelsArray.count > 0 {
                for (_, value) in self.modelsArray.enumerated() {
                    self.modelNamesArray.append(value.value(forKey: "name")! as! String)
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "Please select make", cancelButton: "OK")
                self.pickerMenuView.isHidden = true
            }
        } else if tag == 3 {
            self.yearNamesArray.removeAll()
            if yearsArray.count > 0 {
                for (_, value) in self.yearsArray.enumerated() {
                    self.yearNamesArray.append(String(describing: value))
                }
            }
            else {
                self.showAlertwithCancelButton("Alert", message: "No Years found for this model", cancelButton: "OK")
                self.pickerMenuView.isHidden = true
            }
        }
        else if tag == 4 {
            self.colorsNamesArray.removeAll()
            if extColorGroupsArray.count > 0 {
                for (_, value) in self.extColorGroupsArray.enumerated() {
                    self.colorsNamesArray.append(value.value(forKey: "name")! as! String)
                }
                
              //  self.selectedColor = self.colorsNamesArray[0]
            }
            else {
                //                self.showAlertwithCancelButton("Alert", message: "Please select color for this model", cancelButton: "OK")
            }
        }
        else if tag == 5 {
            self.styleNamesArray.removeAll()
            if stylesArray.count > 0 {
                for (_, value) in self.stylesArray.enumerated() {
                    self.styleNamesArray.append(value.value(forKey: "name")! as! String)
                }
                
              //  self.selectedStyle = self.styleNamesArray[0]
            }
            else {
                //                self.showAlertwithCancelButton("Alert", message: "No Styles found for this model", cancelButton: "OK")
            }
        }
        else if tag == 6 {
            self.engineGroupsNamesArray.removeAll()
            if engineGroupsArray.count > 0 {
                for (_, value) in self.engineGroupsArray.enumerated() {
                    self.engineGroupsNamesArray.append(value.value(forKey: "name")! as! String)
                }
                
             //   self.selectedEngineType = self.engineGroupsNamesArray[0]
            }
            else {
                //                self.showAlertwithCancelButton("Alert", message: "No Engine Groups found for this model", cancelButton: "OK")
            }
        }
        self.pkrView.reloadAllComponents()
    }
    
    //MARK:- SLIDER METHODS
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
        if isPriceSliderSelected == true {
            self.selectedPriceMinValue = String(selectedMinimum)
            self.selectedPriceMaxValue = String(selectedMaximum)
        }
        if isMileageSliderSelected == true {
            self.selectedMileageMinValue = String(selectedMinimum)
            self.selectedMileageMaxValue = String(selectedMaximum)
        }
    }
    
    //MARK:- Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 121
        case 1,2: return 125
        case 3: return 61
        case 4,6,8: return isMoreOptionsButtonSelected == true ? 61 : 0
        case 5: return isColorCellSelected == true ? 156 : 0
        case 7: return isBodyStyleCellSelected == true ? 156 : 0
        case 9: return isEngineTypeCellSelected == true ? 156 : 0
            
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: basicFilterOptionsCellReuseIdentifier) as! BasicFilterOptionsTableViewCell!
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.selectMakeButton.setTitle(self.selectedMake ?? "Make", for: .normal)
            cell?.selectModelButton.setTitle(self.selectedModel ?? "Model", for: .normal)
            cell?.selectYearButton.setTitle(self.selectedYear ?? "Year", for: .normal)
            
            cell?.selectMakeDropdownButton.addTarget(self, action: #selector(InventorySearchViewController.makeButtonTapped(_:)), for: .touchUpInside)
            cell?.selectModelDropdownButton.addTarget(self, action: #selector(InventorySearchViewController.modelButtonTapped(_:)), for: .touchUpInside)
            cell?.selectYearDropdownButton.addTarget(self, action: #selector(InventorySearchViewController.yearButtonTapped(_:)), for: .touchUpInside)
            
            return cell!
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: priceRangeCellReuseIdentifier) as! PriceRangeTableViewCell!
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.rangeSliderCustom.minValue = 0
            cell?.rangeSliderCustom.maxValue = 100000
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.positivePrefix = "$"
            cell?.rangeSliderCustom.numberFormatterOverride = formatter
            
            if selectedPriceMinValue != nil {
                
                cell?.rangeSliderCustom.selectedMinimum = NSString(string: self.selectedPriceMinValue!).floatValue
            } else {
                cell?.rangeSliderCustom.selectedMinimum = 0
                self.selectedPriceMinValue = "0.0"
            }
            if selectedPriceMaxValue != nil {
                
                cell?.rangeSliderCustom.selectedMaximum = NSString(string: self.selectedPriceMaxValue!).floatValue
            } else {
                cell?.rangeSliderCustom.selectedMaximum = 100000
                self.selectedPriceMaxValue = "100000.00"
            }
            
            cell?.sliderTitleLabel.text = "Price"
            
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: priceRangeCellReuseIdentifier) as! PriceRangeTableViewCell!
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.rangeSliderCustom.minValue = 0
            cell?.rangeSliderCustom.maxValue = 50000
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            formatter.positivePrefix = ""
            cell?.rangeSliderCustom.numberFormatterOverride = formatter
            
            if selectedMileageMinValue != nil {
                cell?.rangeSliderCustom.selectedMinimum = NSString(string: self.selectedMileageMinValue!).floatValue
            } else {
                cell?.rangeSliderCustom.selectedMinimum = 0
                self.selectedMileageMinValue = "0.0"
            }
            if selectedMileageMaxValue != nil {
                cell?.rangeSliderCustom.selectedMaximum = NSString(string: self.selectedMileageMaxValue!).floatValue
            } else {
                cell?.rangeSliderCustom.selectedMaximum = 50000
                self.selectedMileageMaxValue = "50000.00"
            }
            
            cell?.sliderTitleLabel.text = "Mileage"
            
            return cell!
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: selectMoreOptionsCellReuseIdentifier) as! MoreOptionsTableViewCell!
            
            if isMoreOptionsButtonSelected == true {
                cell?.moreOptionsTitleLabel.text = "Fewer Options"
                cell?.moreOptionsButton.setImage(UIImage(named: "addVehicleBtnMinus.png"), for: .normal)
            } else {
                cell?.moreOptionsTitleLabel.text = "Select More Options"
                cell?.moreOptionsButton.setImage(UIImage(named: "addVehicleBtnPlus.png"), for: .normal)
            }
            
            cell?.moreOptionsButton.addTarget(self, action: #selector(InventorySearchViewController.moreOptionsClicked), for: .touchUpInside)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: selectColorCellReuseIdentifier) as! ColorBodyEngineTableViewCell!
            cell?.colorBodyEngineLabel.text = "Color"
            
            if isColorCellSelected == true {
                cell?.disclosureButton.setImage(UIImage(named: "downArrow.png"), for: .normal)
            } else {
                cell?.disclosureButton.setImage(UIImage(named: "learnMoreArrow.png"), for: .normal)
            }
            
            cell?.selectedValue.text = self.selectedColor
            return cell!
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: pickerCellReuseIdentifier) as! InventorySearchPickerTableViewCell!
            
            cell?.pickerView.backgroundColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
            cell?.pickerView.isHidden = false
            cell?.pickerView.tag = 4
            self.setData(tag: 4)
            
            return cell!
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: selectColorCellReuseIdentifier) as! ColorBodyEngineTableViewCell!
            cell?.colorBodyEngineLabel.text = "Body Style"
            
            if isBodyStyleCellSelected == true {
                cell?.disclosureButton.setImage(UIImage(named: "downArrow.png"), for: .normal)
            } else {
                cell?.disclosureButton.setImage(UIImage(named: "learnMoreArrow.png"), for: .normal)
            }
            
            cell?.selectedValue.text = self.selectedStyle
            return cell!
            
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: pickerCellReuseIdentifier) as! InventorySearchPickerTableViewCell!
            
            cell?.pickerView.backgroundColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
            cell?.pickerView.isHidden = false
            cell?.pickerView.tag = 5
            self.setData(tag: 5)
            
            return cell!
            
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: selectColorCellReuseIdentifier) as! ColorBodyEngineTableViewCell!
            cell?.colorBodyEngineLabel.text = "Engine Type"
            
            if isEngineTypeCellSelected == true {
                cell?.disclosureButton.setImage(UIImage(named: "downArrow.png"), for: .normal)
            } else {
                cell?.disclosureButton.setImage(UIImage(named: "learnMoreArrow.png"), for: .normal)
            }
            
            cell?.selectedValue.text = self.selectedEngineType
            return cell!
            
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: pickerCellReuseIdentifier) as! InventorySearchPickerTableViewCell!
            
            cell?.pickerView.backgroundColor = UIColor.vehicleTypeSelectedButtonBackgroundColor()
            cell?.pickerView.isHidden = false
            cell?.pickerView.tag = 6
            self.setData(tag: 6)
            
            return cell!
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            
            isColorCellSelected = !isColorCellSelected
            isBodyStyleCellSelected = false
            isEngineTypeCellSelected = false
            
            if isColorCellSelected == true {
                if self.selectedColor == nil {
                   self.selectedColor = self.colorsNamesArray[0]
                }
                self.inventorySearchTableView.reloadData()
                let indexPath = IndexPath(row: 5, section: 0)
                self.inventorySearchTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        case 6:
            
            isBodyStyleCellSelected = !isBodyStyleCellSelected
            isColorCellSelected = false
            isEngineTypeCellSelected = false
            
            if isBodyStyleCellSelected == true {
                if self.selectedStyle == nil {
                   self.selectedStyle = self.styleNamesArray[0]
                }
                self.inventorySearchTableView.reloadData()
                let indexPath = IndexPath(row: 7, section: 0)
                self.inventorySearchTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        case 8:
            
            isEngineTypeCellSelected = !isEngineTypeCellSelected
            isColorCellSelected = false
            isBodyStyleCellSelected = false
            
            if isEngineTypeCellSelected == true {
                if self.selectedEngineType == nil {
                     self.selectedEngineType = self.engineGroupsNamesArray[0]
                }
                self.inventorySearchTableView.reloadData()
                let indexPath = IndexPath(row: 9, section: 0)
                self.inventorySearchTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        default:
            return
        }
        tableView.reloadData()
    }
    
    //MARK:- Picker View Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView.tag == 1 {
            return self.makeNamesArray.count
        }
        else if pickerView.tag == 2 {
            return self.modelNamesArray.count
        }
        else if pickerView.tag == 3 {
            return self.yearNamesArray.count
        }
        else if pickerView.tag == 4 {
            return self.extColorGroupsArray.count
        }
        else if pickerView.tag == 5 {
            return self.styleNamesArray.count
        }
        else {
            return self.engineGroupsNamesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let pickerTextColor = [NSForegroundColorAttributeName : UIColor.SlateColor(), NSFontAttributeName: UIFont.regularFont().withSize(30)]
        
        if pickerView.tag == 1 {
            let makesAttributedText = NSAttributedString(string: self.makeNamesArray[row], attributes: pickerTextColor)
            return makesAttributedText
        }
        else if pickerView.tag == 2 {
            let modelsAttributedText = NSAttributedString(string: self.modelNamesArray[row], attributes: pickerTextColor)
            return modelsAttributedText
        }
        else if pickerView.tag == 3 {
            let yearsAttributedText = NSAttributedString(string: self.yearNamesArray[row], attributes: pickerTextColor)
            return yearsAttributedText
        }
        else if pickerView.tag == 4 {
            let yearsAttributedText = NSAttributedString(string: self.colorsNamesArray[row], attributes: pickerTextColor)
            return yearsAttributedText
        }
        else if pickerView.tag == 5 {
            let yearsAttributedText = NSAttributedString(string: self.styleNamesArray[row], attributes: pickerTextColor)
            return yearsAttributedText
        }
        else {
            let yearsAttributedText = NSAttributedString(string: self.engineGroupsNamesArray[row], attributes: pickerTextColor)
            return yearsAttributedText
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            self.selectedMake = self.makeNamesArray[row]
            self.modelsArray = self.makesArray[row].value(forKey: "models") as! Array<AnyObject>
            self.setData(tag: 1)
        }
            
        else if pickerView.tag == 2 {
            self.selectedModel = self.modelNamesArray[row]
            if self.modelsArray[row].value(forKey: "trims") != nil {
                self.trimsArray = self.modelsArray[row].value(forKey: "trims") as! Array<AnyObject>
                self.setData(tag: 2)
            }
            else {
                self.trimsArray = [AnyObject]()
            }
            
        } else if pickerView.tag == 3 {
            self.selectedYear = self.yearNamesArray[row]
            self.setData(tag: 3)
        }
            
        else if pickerView.tag == 4 {
            self.selectedColor = self.colorsNamesArray[row]
           // self.isColorCellSelected = false
            self.inventorySearchTableView.reloadData()
        }
            
        else if pickerView.tag == 5 {
            self.selectedStyle = self.styleNamesArray[row]
           // self.isBodyStyleCellSelected = false
            self.inventorySearchTableView.reloadData()
        }
            
        else {
            self.selectedEngineType = self.engineGroupsNamesArray[row]
           // self.isEngineTypeCellSelected = false
            self.inventorySearchTableView.reloadData()
        }
        
       // pickerView.isHidden = true
       // self.inventorySearchTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InventorySearch" {
            
            let searchDetails = (segue.destination as! InventoryResultsViewController)
            
            searchDetails.make = self.selectedMake ?? ""
            searchDetails.model = self.selectedModel ?? ""
            searchDetails.year = self.selectedYear ?? ""
            searchDetails.color = self.selectedColor ?? ""
            searchDetails.style = self.selectedStyle ?? ""
            searchDetails.engineGroup = self.selectedEngineType ?? ""
            searchDetails.price = String(format: "%@-%@", self.selectedPriceMinValue!, self.selectedPriceMaxValue!) 
            searchDetails.mileage = String(format: "%@-%@", self.selectedMileageMinValue!, self.selectedMileageMaxValue!) 
        }
    }
    
    //MARK:- AUTO TRADER SEARCH FILTERS API
    
    func callSearchFiltersAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            self.addSearchFilterTracker()
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            Alamofire.request(Constant.API.kBaseUrlPath+"searchfilters", method: .get, parameters: nil).responseJSON
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
            self.showInternetFailureAlert()
        }
    }
    
    func callSaveSearchApi(searchName: String) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            self.addSaveSearchTracker()
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let make = self.selectedMake ?? ""
            let model = self.selectedModel ?? ""
            let year = self.selectedYear ?? ""
            let color = self.selectedColor ?? ""
            let style = self.selectedStyle ?? ""
            let engine = self.selectedEngineType ?? ""
            let price = String(format: "%@-%@", self.selectedPriceMinValue!, self.selectedPriceMaxValue!)
            let mileage = String(format: "%@-%@", self.selectedMileageMinValue!, self.selectedMileageMaxValue!)
            
            let paramsDict: [ String : String] = ["uid": userId,
                                                  "make": make,
                                                  "model": model,
                                                  "year": year,
                                                  "color": color,
                                                  "style": style,
                                                  "engineGroup": engine,
                                                  "search_name": searchName,
                                                  "price": price,
                                                  "mileage": mileage,
                                                  "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"savesearch", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                
                                let dict: SaveSearch = try SaveSearch(dictionary: JSON as! [AnyHashable: Any])
                                let message = dict.message
                                self.showAlertwithCancelButton("Success", message: (message as? NSString)!, cancelButton: "OK")
                                self.searchNameView.isHidden = true
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
            self.showInternetFailureAlert()
        }
    }
    
    func addSearchFilterTracker() {
        
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Auto Trader Search Filters API Called", label: "Auto Trader Search Filters", value: nil).build()
        tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
    }
    
    func addSaveSearchTracker() {
        
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Save Search API Called", label: "Save Search", value: nil).build()
        tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
    }
    
    func showInternetFailureAlert() {
        
        print("Internet connection FAILED")
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
        self.present(vc as! UIViewController, animated: true, completion: nil)
    }
}
