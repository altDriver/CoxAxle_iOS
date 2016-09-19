//
//  VehiclesViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 17/08/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class VehiclesViewController: GAITrackedViewController, UIAlertController_UIAlertView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let vehicleListReuseIdentifier = "VehiclesListCell"
    
    @IBOutlet var collectionView: UICollectionView!
    var language: String?
    var vehiclesListArray = [AnyObject]()
    var fromXTime: Bool!

    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
         self.screenName = "VehiclesViewController"
        
        let viewControllers = self.navigationController!.viewControllers as NSArray
        for VC in viewControllers {
            if((VC as AnyObject).isKind(of: LandingScreen.self)){
                self.navigationItem.leftBarButtonItems = nil
                //  self.navigationController?.navigationBar.topItem?.title = ""
                
                var image = UIImage(named: "back")
                
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(VehiclesViewController.backClicked(_:)))
                
                break
            }
        }

         self.setText()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "SESSION_EXPIRED") {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "SessionExpired")
            self.present(vc as! UIViewController, animated: true, completion: nil)
        }
        
//        if NSUserDefaults.standardUserDefaults().boolForKey("CALL_API") {
//            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "CALL_API")
//            NSUserDefaults.standardUserDefaults().synchronize()
            self.fetchVehiclesListAPI()
      //  }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func addVehicleButtonClicked(_ sender: UIButton) {
        if self.vehiclesListArray.count >= 5 {
            self.showAlertwithCancelButton("Alert", message: "You can't add more than 5 vehicles. Please delete vehicles before adding a vehicle", cancelButton: "OK")
        }
        else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.performSegue(withIdentifier: "AddVehicle", sender: self)
        }
        
    }
    
    func backClicked(_ sender:UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        if let frostView = self.view{
            frostView.endEditing(true)
        }
        
        if let frostingViewController = self.frostedViewController{
            frostingViewController.view.endEditing(true)
            frostingViewController.presentMenuViewController()
        }
    }
    //MARK:- UICOLLECTIONVIEW DATA SOURCE METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehiclesListArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
            let position: CGSize = CGSize(width: self.view.frame.size.width-30, height: Constant.iPhoneScreen.Ratio * 230)
            
            return position
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vehicleListReuseIdentifier, for: indexPath) as! VehiclesListCollectionViewCell
            
        let imageArray = self.vehiclesListArray[(indexPath as NSIndexPath).row].value(forKey: "vechicle_image") as! NSArray
        let imageURLString = (imageArray[0] as AnyObject).value(forKey: "image_url") as! NSString
        cell.carImageView.sd_setImage(with: URL(string: imageURLString as String), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions(rawValue: UInt(0)), completed: { (image, error, cacheType, url) -> Void in
            cell.carImageView.alpha = 1;
            
        })
        cell.carName.text = self.vehiclesListArray[(indexPath as NSIndexPath).row].value(forKey: "name") as? String
        cell.carAppointmentDate.text = String(format: "%@ %@ • %@ Miles", (self.vehiclesListArray[(indexPath as NSIndexPath).row].value(forKey: "year") as? String)!, (self.vehiclesListArray[(indexPath as NSIndexPath).row].value(forKey: "model") as? String)!, (self.vehiclesListArray[(indexPath as NSIndexPath).row].value(forKey: "mileage") as? String)!)
            return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        if (fromXTime != nil) {
            self.performSegue(withIdentifier: "XTImeWebView", sender: indexPath)
        }
        else {
            self.performSegue(withIdentifier: "VehicleDetails", sender: indexPath)
        }
    }
    
    
    //MARK:- FETCH VEHICLES LIST API
    func fetchVehiclesListAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Vehicles List API Called", label: "Vehicles List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
             let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"vehicle/list", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                            if status == "True"  {
                                do {
                                    let dict: VehiclesList = try VehiclesList(dictionary: JSON as! [AnyHashable: Any])
                                    
                                    
                                    self.vehiclesListArray = dict.response?.data as! Array<AnyObject>
                                    print(self.vehiclesListArray)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VehicleDetails" {
            let indexPath = sender as! IndexPath
            let vehicleDetails = (segue.destination as! VehicleDetailsViewController)
            vehicleDetails.vehiclesDetailsDict = self.vehiclesListArray[(indexPath as NSIndexPath).row] as! NSDictionary
        }
        else if segue.identifier == "XTImeWebView" {
            let indexPath = sender as! IndexPath
            let xTimeWebView = (segue.destination as! XtimeViewController)
            let xTimeDict = self.vehiclesListArray[(indexPath as NSIndexPath).row] as! NSDictionary
            xTimeWebView.vinNumber = xTimeDict.value(forKey: "vin") as? String

        }
    }
    

}
