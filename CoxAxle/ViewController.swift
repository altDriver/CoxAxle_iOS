//
//  ViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 21/07/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire
import EAIntroView
import SDWebImage

let constantObj = Constant()
let placeHolderColor = UIColor(red: 177.0/255.0, green: 175.0/255.0, blue: 176.0/255.0, alpha: 1.0)


class ViewController: GAITrackedViewController, EAIntroDelegate, UIAlertController_UIAlertView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAnAccountButton: UIButton!
    
    var language: String?
    var dealerDictionary: DealersInfoResponse?
    
    @IBOutlet var logoImageView: UIImageView!
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "ViewController"
        self.callDealersListAPI()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SET TEXT
    func setText() -> Void {
        self.language = UserDefaults.standard.object(forKey: "CurrentLanguage") as? String
        self.loginButton .setTitle("Login".localized(self.language!), for: UIControlState())
        self.createAnAccountButton.setTitle("Don’t have an account? Sign up".localized(self.language!), for: UIControlState())
    }
    
    
    //MARK- UIBUTON ACTIONS
      @IBAction func loginButtonClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "Login", sender: self)
        }
    }
    
    
    @IBAction func createAnAccountClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
           self.performSegue(withIdentifier: "CreateAccount", sender: self)
        }
    }
    
    //MARK:- DEALERS LIST API
    func callDealersListAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Dealers List API Called", label: "Fetching Dealers List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let paramsDict: [ String : String] = ["dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"dealers/dealersinfo", method: .post, parameters: paramsDict).responseJSON { response in
                loading.hide()
                if let JSON = response.result.value {
                    
                    print(NSString(format: "Response: %@", JSON as! NSDictionary))
                    let status = (JSON as AnyObject).value(forKey: "status") as! String
                    if status == "True"  {
                        do {
                            let dict: DealerInfo = try DealerInfo(dictionary: JSON as! [AnyHashable: Any])
                            
                            self.dealerDictionary = dict.response! as DealersInfoResponse
                            
                            let main = self.dealerDictionary?.value(forKey: "main_contact_number") as! String
                            let sales = self.dealerDictionary?.value(forKey: "sale_contact") as! String
                            let service = self.dealerDictionary?.value(forKey: "service_desk_contact") as! String
                            let collision = self.dealerDictionary?.value(forKey: "collision_desk_contact") as! String
                            
                            UserDefaults.standard.set(main, forKey: "Dealer_Main")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set(sales, forKey: "Dealer_Sales")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set(service, forKey: "Dealer_Services")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set(collision, forKey: "Dealer_Collision")
                            UserDefaults.standard.synchronize()
                            
                            print(self.dealerDictionary)
                             let imageURLString = self.dealerDictionary?.value(forKey: "dealer_logo") as! NSString
                             let dealerFBLink = self.dealerDictionary?.value(forKey: "dealer_fb_page_link") as! NSString
                             let dealerTWLink = self.dealerDictionary?.value(forKey: "dealer_twiter_page_link") as! NSString
                            
                            UserDefaults.standard.set(imageURLString, forKey: "Dealer_Logo")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set(dealerFBLink, forKey: "Dealer_FB")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set(dealerTWLink, forKey: "Dealer_TW")
                            UserDefaults.standard.synchronize()
                            
                            self.logoImageView.sd_setImage(with: NSURL(string: imageURLString as String) as URL!, completed: {
                                (image, error, cacheType, url) in
                                // do your custom logic here
                                self.logoImageView.image = image
                                self.showIntroductoryScreens(logoImage: self.logoImageView.image!)
                            })
                            
                            
                        }
                        catch let error as NSError {
                            NSLog("Unresolved error \(error), \(error.userInfo)")
                        }
                    }
                    else {
                        let errorMsg = (JSON as AnyObject).value(forKey: "message") as! String
                        self.showAlertwithCancelButton("Error", message: errorMsg as NSString, cancelButton: "OK".localized(self.language!) as NSString)
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
    
    
    func showIntroductoryScreens(logoImage: UIImage) -> Void {
        if UserDefaults.standard.bool(forKey: "SHOW_INTRODUCTORY") {
            // INTRODUCTORY SCREENS
            
            let page1: EAIntroPage = EAIntroPage()
            page1.title = "Title 1"
            page1.desc = "Description 1"
            page1.bgImage = UIImage(named: "backgroundImg")
            page1.titleIconView = UIImageView(image: logoImage)
            
            
            let page2: EAIntroPage = EAIntroPage()
            page2.title = "Title 2"
            page2.desc = "Description 2"
            page2.bgImage = UIImage(named: "backgroundImg")
            page2.titleIconView = UIImageView(image: logoImage)
            
            let page3: EAIntroPage = EAIntroPage()
            page3.title = "Title 3"
            page3.desc = "Description 3"
            page3.bgImage = UIImage(named: "backgroundImg")
            page3.titleIconView = UIImageView(image: logoImage)

            
            let intro: EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
            intro.delegate = self
            
            [intro.show(in: self.view, animateDuration: 0.0)]
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Login" {
            let logo = (segue.destination as! LoginViewController)
            logo.logoImageStr = self.dealerDictionary?.value(forKey: "dealer_logo") as? String
        }
        else  if segue.identifier == "CreateAccount" {
            let logo = (segue.destination as! CreateAccount)
            logo.logoImage = self.dealerDictionary?.value(forKey: "dealer_logo") as? String
        }
        
    }
    
    
}

