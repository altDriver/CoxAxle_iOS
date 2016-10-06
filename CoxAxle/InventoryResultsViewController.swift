//
//  InventoryResultsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 12/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import UIActivityIndicator_for_SDWebImage

class InventoryResultsViewController: GAITrackedViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertController_UIAlertView {
    
    let vehicleSearchListReuseIdentifier = "ResultsCollectionView"
    @IBOutlet var collectionView: UICollectionView!
    var make: String?
    var model: String?
    var trim: String?
    var color: String?
    var engineGroup: String?
    var style: String?
    var year: String?
    var price: String?
    var mileage: String?
    
    var searchName: String?
    var inventoryResultsArray: NSMutableArray = NSMutableArray()
    
    var pageNumber: Int!
    var currentCount: Int?
    var totalCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "InventoryResultsViewController"
        // Do any additional setup after loading the view.
        
        print(self.price)
        print(self.mileage)
         self.pageNumber = 1
        self.callListingAPI()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.triggerVerticalOffset = 100.0
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        self.collectionView.bottomRefreshControl = refreshControl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PAGINATION
    func refresh(refreshControl: UIRefreshControl) -> Void {
        
        if self.currentCount! < self.totalCount! {
            self.callListingAPI()
            
        }
        
        DispatchQueue.main.async {
            self.collectionView.bottomRefreshControl.endRefreshing()
        }
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func favoriteButtonClicked(selectedButton: UIButton) -> Void {
        let clickedDict = self.inventoryResultsArray[selectedButton.tag] as! NSDictionary
        print(clickedDict)
        self.callFavouriteCarAPI(dict: clickedDict, index: selectedButton.tag)
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.inventoryResultsArray.count > 0 {
            self.collectionView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            noDataLabel.text = "No Results Found!"
            noDataLabel.textColor = UIColor.init(red: 79/255.0, green: 90/255.0, blue: 113/255.0, alpha: 1)
            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            noDataLabel.textAlignment = .center
            self.collectionView.backgroundView = noDataLabel
        }
        return self.inventoryResultsArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let position: CGSize = CGSize(width: self.view.frame.size.width-30, height: Constant.iPhoneScreen.Ratio * 230)
        
        return position
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vehicleSearchListReuseIdentifier, for: indexPath) as! InventoryResultsCollectionViewCell
        
        cell.vehicleImageViewHeight.constant = Constant.iPhoneScreen.Ratio*150
        
        if let imageURLString = (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "images") as? NSString {
            
        cell.vehicleImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
        }
        else {
            cell.vehicleImageView.image = UIImage(named: "placeholder")
        }
        cell.vehicleType.text = (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "listingType") as? String
        let model = String(format: "%@ %@", (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "year") as! NSString, (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "make") as! String)
        cell.vehicleModel.text = model
        cell.vehiclePrice.text = String(format: "$%@", ((self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "derivedPrice") as? NSString)!)
        let trimArray = (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "bodyStyles") as! NSArray
        let trimDict = trimArray.object(at: 0) as! NSDictionary
        let miles = String(format: "%@ • %@", ((self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "mileage") as? NSString)!, trimDict.value(forKey: "name") as! String)
        cell.vehicleMiles.text = miles
        let like =  String(format: "%@", (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "like") as! NSString)
        if like == "0" {
            cell.favoriteButton.setImage(UIImage(named: "favourite"), for: UIControlState.normal)
        }
        else if like == "1" {
            cell.favoriteButton.setImage(UIImage(named: "favorite_selected"), for: UIControlState.normal)
        }
        cell.favoriteButton.addTarget(self, action: #selector(InventoryResultsViewController.favoriteButtonClicked(selectedButton:)), for: UIControlEvents.touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- AUTO TRADER LISTING API
    func callListingAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Auto Trader Listing API Called", label: "Auto Trader List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            
            let vehicleMake = self.make ?? ""
            let vehicleModel = self.model ?? ""
            let vehicleColor = self.color ?? ""
            let engineType = self.engineGroup ?? ""
            let vehicleStyle = self.style ?? ""
            let vehiclePrchasedYear = self.year ?? ""
            let vehicleSearchName = self.searchName ?? ""
            let vehiclePrice = self.price ?? ""
            let vehicleMileage = self.mileage ?? ""
            
            let paramsDict: [ String : String] = ["uid": userId,
                                                  "make": vehicleMake,
                                                  "model": vehicleModel,
                                                  "color": vehicleColor,
                                                  "engineGroup": engineType,
                                                  "style": vehicleStyle,
                                                  "year": vehiclePrchasedYear,
                                                  "search_name": vehicleSearchName,
                                                  "price": vehiclePrice,
                                                  "mileage": vehicleMileage,
                                                  "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"listing", method: .post, parameters: paramsDict).responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: AutoTraderResults = try AutoTraderResults(dictionary: JSON as! [NSObject : AnyObject])
                                
                                let dictArray = dict.response?.data as! Array<AnyObject>
                                self.inventoryResultsArray.addObjects(from: dictArray)
                                self.currentCount = self.inventoryResultsArray.count
                                self.totalCount = Int(dict.total_count)
                                
                                self.pageNumber = self.pageNumber + 1
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                let savedDict: [String:String] = ["searchName": "Acura", "price": "$10-$10,000", "mileage": "2000-5000", "subModel": "VXI • SUV", "savedTime": "Oct 6, 8:22 PM"] as Dictionary
                                
                                let savedArray: NSArray = NSArray(object: savedDict)
                                
                                print(savedArray)
                                
                                for i in 0 ..< savedArray.count {
                                    let dataModel: RecentSearches! = RecentSearches.fetchParticularRecord(rid: (savedArray[i] as! NSDictionary).value(forKey: "searchName") as! NSString, context: appDelegate.managedObjectContext)
        
                                    if dataModel == nil {
                                      let result =  RecentSearches.insertDictionary(dict: savedArray[i] as! NSDictionary, context: appDelegate.managedObjectContext)
                                        print(result)
                                    }
                                    else {
                                        RecentSearches.updateDictionary(dict: savedArray[i] as! NSDictionary, object: dataModel, context: appDelegate.managedObjectContext)
                                    }
                                }
        
                                if (appDelegate.managedObjectContext .hasChanges) {
                                    do {
                                        try appDelegate.managedObjectContext .save()
                                        print("Successfully Data Saved")
                                    } catch let error as NSError
                                    {
                                        NSLog("Unresolved error \(error), \(error.userInfo)")
                                    }
                                }

                                
                                DispatchQueue.main.async {
                                    
                                    self.collectionView.reloadData()
                                    
                                }
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
    
    //MARK:- FAVOURITE CAR API
    func callFavouriteCarAPI(dict: NSDictionary, index: Int) -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Favourite Cars API Called", label: "Favourite Cars", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let imageUrl = dict.value(forKey: "images") as? String ?? ""
            let vehicleType = dict.value(forKey: "listingType") as? String ?? ""
            let vehicleName = dict.value(forKey: "make") as? String ?? ""
            let trimArray = dict.value(forKey: "bodyStyles") as! NSArray
            let trimDict = trimArray.object(at: 0) as! NSDictionary
            let subModel = trimDict.value(forKey: "name") as? String ?? ""
            let miles: String = String(format: "%@", dict.value(forKey: "mileage") as! CVarArg)
            let price: String = String(format: "%@", dict.value(forKey: "derivedPrice") as! CVarArg)
            let year: String = String(format: "%@", dict.value(forKey: "year") as! CVarArg)
            
            
            
            let paramsDict: [ String : String] = ["uid": userId, "image_url": (imageUrl as String), "vehicle_type": (vehicleType as String), "vehicle_name": (vehicleName as String), "sub_model": (subModel as String), "miles": (miles as String), "price": (price as String), "year": (year as String), "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"savefavourite", method: .post, parameters: paramsDict).responseJSON
                { response in
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                             let successDict = (JSON as AnyObject).value(forKey: "response") as! NSDictionary
                            var dict = self.inventoryResultsArray[index] as! Dictionary<String, AnyObject>
                            dict.updateValue((successDict.value(forKey: "like") as? String)! as AnyObject, forKey: "like")
                            
                            self.inventoryResultsArray.replaceObject(at: index, with: dict)
                            
                            DispatchQueue.main.async {
                                loading.hide()
                                self.collectionView.reloadData()
                            }
                          
                        }
                        else {
                            loading.hide()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
