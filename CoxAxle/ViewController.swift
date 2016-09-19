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

let constantObj = Constant()
let placeHolderColor = UIColor(red: 177.0/255.0, green: 175.0/255.0, blue: 176.0/255.0, alpha: 1.0)


class ViewController: GAITrackedViewController, EAIntroDelegate, UIAlertController_UIAlertView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    @IBOutlet weak var createAnAccountButton: UIButton!
    
    var language: String?
    
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "ViewController"
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaults.standard.bool(forKey: "SHOW_INTRODUCTORY") {
        // INTRODUCTORY SCREENS
        
        let page1: EAIntroPage = EAIntroPage()
        page1.title = "Title 1"
        page1.desc = "Description 1"
        page1.bgImage = UIImage(named: "backgroundImg")
        page1.titleIconView = UIImageView(image: UIImage(named: "kingston_honda"))
        
        let page2: EAIntroPage = EAIntroPage()
        page2.title = "Title 2"
        page2.desc = "Description 2"
        page2.bgImage = UIImage(named: "backgroundImg")
        page2.titleIconView = UIImageView(image: UIImage(named: "kingston_honda"))
        
        let page3: EAIntroPage = EAIntroPage()
        page3.title = "Title 3"
        page3.desc = "Description 3"
        page3.bgImage = UIImage(named: "backgroundImg")
        page3.titleIconView = UIImageView(image: UIImage(named: "kingston_honda"))
        
        let intro: EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
        intro.delegate = self
        
        [intro.show(in: self.view, animateDuration: 0.0)]
        }
        
        self.setText()
      
        
        self.callDealersListAPI()
        
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
        self.continueAsGuestButton.setTitle("Continue as Guest".localized(self.language!), for: UIControlState())
        self.createAnAccountButton.setTitle("Don’t have an account? Sign up".localized(self.language!), for: UIControlState())
    }
    
    
    //MARK- UIBUTON ACTIONS
      @IBAction func loginButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
    @IBAction func continueAsGuestClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoggedIn", sender: self)
    }
    
    @IBAction func createAnAccountClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateAccount", sender: self)
    }

    //MARK:- DEALERS LIST API
    func callDealersListAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Dealers List API Called", label: "Fetching Dealers List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading".localized(self.language!))
            self.view.addSubview(loading)
            let paramsDict: [ String : String] = ["dl_id": "3"] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"dealers/contact", method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                              do {
                             let dict: DealersList = try DealersList(dictionary: JSON as! [AnyHashable: Any])

                             print(dict.response)
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
    
}

