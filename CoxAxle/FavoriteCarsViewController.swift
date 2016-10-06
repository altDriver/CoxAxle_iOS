//
//  FavoriteCarsViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 22/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import UIActivityIndicator_for_SDWebImage

class FavoriteCarsViewController: GAITrackedViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertController_UIAlertView {
    
    let FavoriteCarsListReuseIdentifier = "FavoriteCarsReuseCollectionView"
    var favoriteCarsArray = [AnyObject]()

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "FavoriteCarsViewController"
        self.callFetchFavoriteCarsAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.favoriteCarsArray.count > 0 {
            self.collectionView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            noDataLabel.text = "No Favorite Cars Found!"
            noDataLabel.textColor = UIColor.init(red: 79/255.0, green: 90/255.0, blue: 113/255.0, alpha: 1)
            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            noDataLabel.textAlignment = .center
            self.collectionView.backgroundView = noDataLabel
        }

        return self.favoriteCarsArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let position: CGSize = CGSize(width: self.view.frame.size.width-30, height: Constant.iPhoneScreen.Ratio * 230)
        
        return position
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCarsListReuseIdentifier, for: indexPath) as! InventoryResultsCollectionViewCell
        
        cell.vehicleImageViewHeight.constant = Constant.iPhoneScreen.Ratio*150
        
        if let imageURLString = self.favoriteCarsArray[indexPath.row].value(forKey: "image_url") as? NSString {
            
            cell.vehicleImageView.setImageWith(URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
        }
        else {
            cell.vehicleImageView.image = UIImage(named: "placeholder")
        }
        cell.vehicleType.text = self.favoriteCarsArray[indexPath.row].value(forKey: "vehicle_type") as? String
        let model = String(format: "%@ %@", self.favoriteCarsArray[indexPath.row].value(forKey: "year") as! NSString , self.favoriteCarsArray[indexPath.row].value(forKey: "vehicle_name") as! String)  //,
        cell.vehicleModel.text = model
        cell.vehiclePrice.text = String(format: "$%@", (self.favoriteCarsArray[indexPath.row].value(forKey: "price") as? NSString)!)
        let miles = String(format: "%@ • %@", (self.favoriteCarsArray[indexPath.row].value(forKey: "miles") as? NSString)!, self.favoriteCarsArray[indexPath.row].value(forKey: "vehicle_name") as! String)
        cell.vehicleMiles.text = miles
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- FETCH FAVORITE CARS
    func callFetchFavoriteCarsAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Favorite Cars List API Called", label: "Favorite Cars List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId, "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"favouritelist", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: FavoriteCars = try FavoriteCars(dictionary: JSON as! [AnyHashable: Any])
                                
                                
                                self.favoriteCarsArray = dict.response?.data as! Array<AnyObject>
                                print(self.favoriteCarsArray)
                                DispatchQueue.main.async{
                                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
