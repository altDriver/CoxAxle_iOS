//
//  InventoryResultsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 12/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class InventoryResultsViewController: GAITrackedViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertController_UIAlertView {
    
    let vehicleSearchListReuseIdentifier = "ResultsCollectionView"
    @IBOutlet var collectionView: UICollectionView!
    var make: String?
    var model: String?
    var trim: String?
    var engineGroup: String?
    var style: String?
    var year: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "InventoryResultsViewController"
        // Do any additional setup after loading the view.
        self.callListingAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let position: CGSize = CGSize(width: self.view.frame.size.width-30, height: Constant.iPhoneScreen.Ratio * 230)
        
        return position
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vehicleSearchListReuseIdentifier, for: indexPath) as! InventoryResultsCollectionViewCell
        
        cell.vehicleImageViewHeight.constant = Constant.iPhoneScreen.Ratio*150
        
        cell.vehicleImageView.image = UIImage(named: "car1Img")
        cell.vehicleType.text = "NEW"
        cell.vehicleModel.text = "2010 Audi A3 2.0T"
        cell.vehiclePrice.text = "$48,500"
        cell.vehicleMiles.text = "23 Miles • Automatic • Sedan"
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
            let paramsDict: [ String : String] = ["uid": userId, "make": "ACURA", "model": (model! as String), "trim": (trim! as String), "engineGroup": (engineGroup! as String), "style": (style! as String), "year": (year! as String)] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"listing", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                       /* let status = JSON.valueForKey("status") as! String
                        if status == "True"  {
                            do {
                                //let dict: VehiclesList = try VehiclesList(dictionary: JSON as! [NSObject : AnyObject])
                                
                                dispatch_async(dispatch_get_main_queue(),{
                                    
                                    self.collectionView.reloadData()
                                    
                                })
                            }
                            catch let error as NSError {
                                NSLog("Unresolved error \(error), \(error.userInfo)")
                            }
                        }
                        else {
                            let errorMsg = JSON.valueForKey("message") as! String
                            self.showAlertwithCancelButton("Error", message: errorMsg, cancelButton: "OK")
                        }*/
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
