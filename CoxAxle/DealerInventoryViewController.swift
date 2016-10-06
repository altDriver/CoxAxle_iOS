//
//  DealerInventoryViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 29/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import UIActivityIndicator_for_SDWebImage

class DealerInventoryViewController: GAITrackedViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertController_UIAlertView  {
    
    let vehicleSearchListReuseIdentifier = "DealerCollectionView"
    @IBOutlet var collectionView: UICollectionView!
    var make: String?
    var model: String?
    var trim: String?
    var color: String?
    var engineGroup: String?
    var style: String?
    var year: String?
    
    var searchName: String?
    var inventoryResultsArray: NSMutableArray = NSMutableArray()
    
    var pageNumber: Int!
    var currentCount: Int?
    var totalCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "DealerInventoryViewController"
        // Do any additional setup after loading the view.
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
    
    @IBAction func filtersButtonClicked(_ sender: UIButton) {
         self.performSegue(withIdentifier: "Inventory", sender: self)
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
        let model = String(format: "%@ %@", (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "year") as! String, (self.inventoryResultsArray[indexPath.row] as AnyObject).value(forKey: "make") as! String)
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
        if like == "1" {
            cell.favoriteButton.setImage(UIImage(named: "favorite_selected"), for: UIControlState.normal)
        }
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(InventoryResultsViewController.favoriteButtonClicked(selectedButton:)), for: UIControlEvents.touchUpInside)
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
            
            let page = String(self.pageNumber)
            
            let paramsDict: [ String : String] = ["uid": userId,
                                                  "make": vehicleMake,
                                                  "model": vehicleModel,
                                                  "color": vehicleColor,
                                                  "engineGroup": engineType,
                                                  "style": vehicleStyle,
                                                  "year": vehiclePrchasedYear,
                                                  "search_name": vehicleSearchName,
                                                  "dealer_code": Constant.Dealer.DealerCode,
                                                  "page": page as String] as Dictionary
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
            let listingID = dict.value(forKey: "listing_id") as! String
            
            
            let paramsDict: [ String : String] = ["uid": userId, "listing_id": listingID, "dealer_code": Constant.Dealer.DealerCode] as Dictionary
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
    
//    func callListingAPIONBackgroundThread() -> Void {
//        if Reachability.isConnectedToNetwork() == true {
//            print("Internet connection OK")
//            let tracker = GAI.sharedInstance().defaultTracker
//            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Auto Trader Listing API Called", label: "Auto Trader List", value: nil).build()
//            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
//            
//            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
//            
//            let vehicleMake = self.make ?? ""
//            let vehicleModel = self.model ?? ""
//            let vehicleColor = self.color ?? ""
//            let engineType = self.engineGroup ?? ""
//            let vehicleStyle = self.style ?? ""
//            let vehiclePrchasedYear = self.year ?? ""
//            let vehicleSearchName = self.searchName ?? ""
//            
//            let paramsDict: [ String : String] = ["uid": userId,
//                                                  "make": vehicleMake,
//                                                  "model": vehicleModel,
//                                                  "color": vehicleColor,
//                                                  "engineGroup": engineType,
//                                                  "style": vehicleStyle,
//                                                  "year": vehiclePrchasedYear,
//                                                  "search_name": vehicleSearchName,
//                                                  "dealer_code": Constant.Dealer.DealerCode] as Dictionary
//            print(NSString(format: "Request: %@", paramsDict))
//            
//            Alamofire.request(Constant.API.kBaseUrlPath+"listing", method: .post, parameters: paramsDict).responseJSON { response in
//                if let JSON = response.result.value {
//                    
//                    print(NSString(format: "Response: %@", JSON as! NSDictionary))
//                    let status = (JSON as AnyObject).value(forKey: "status") as! String
//                    if status == "True"  {
//                        do {
//                            let dict: AutoTraderResults = try AutoTraderResults(dictionary: JSON as! [NSObject : AnyObject])
//                            
//                            let dictArray = dict.response?.data as! Array<AnyObject>
//                            self.inventoryResultsArray.addObjects(from: dictArray)
//                            self.currentCount = self.inventoryResultsArray.count
//                            self.totalCount = Int(dict.total_count)
//                            
//                            self.pageNumber = self.pageNumber + 1
//
//                            DispatchQueue.main.async{
//                                
//                                self.collectionView.reloadData()
//                                
//                            }
//                        }
//                        catch let error as NSError {
//                            NSLog("Unresolved error \(error), \(error.userInfo)")
//                        }
//                    }
//                    else {
//                        let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
//                        self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK")
//                    }
//                }
//            }
//        }
//        else {
//            print("Internet connection FAILED")
//            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "NoInternetConnection")
//            self.present(vc as! UIViewController, animated: true, completion: nil)
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
