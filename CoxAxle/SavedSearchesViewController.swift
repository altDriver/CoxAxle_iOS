//
//  SavedSearchesViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 19/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit
import Alamofire

class SavedSearchesViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIAlertController_UIAlertView {

    @IBOutlet var tableView: UITableView!
    
    let savedSearchesCellReuseIdentifier = "SavedSearchesCell"
    var savedSearchesArray  = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "SavedSearchesViewController"
        // Do any additional setup after loading the view.
        self.callFetchSavedSearchesAPI()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UITABLE VIEW DATA SOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.savedSearchesArray.count > 0 {
            self.tableView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "No Saved Searches Found!"
            noDataLabel.textColor = UIColor.init(red: 79/255.0, green: 90/255.0, blue: 113/255.0, alpha: 1)
            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
        }

        return savedSearchesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCell(withIdentifier: savedSearchesCellReuseIdentifier) as! SavedSearchTableViewCell!
        
        cell?.searchName.text = savedSearchesArray[indexPath.row].value(forKey: "name") as? String
        let time = (savedSearchesArray[indexPath.row].value(forKey: "date") as? String)?.convertDate()
       cell?.searchTime.text = String(format: "Saved on %@", time!)
        cell?.searchDeleteButton.addTarget(self, action: #selector(SavedSearchesViewController.deleteSearch(sender:)), for: UIControlEvents.touchUpInside)
        cell?.searchDeleteButton.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "SavedSearchResults", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK:- FETCH SAVED SEARCHES LIST
    func callFetchSavedSearchesAPI() -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Fetching Saved Searches List API Called", label: "Saved Searches List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let paramsDict: [ String : String] = ["uid": userId, "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"savedsearch", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: SavedSearchesList = try SavedSearchesList(dictionary: JSON as! [AnyHashable: Any])
                            
                                self.savedSearchesArray = dict.response?.data as! Array<AnyObject>
                                print(self.savedSearchesArray)
                                DispatchQueue.main.async{
                                    
                                    self.tableView.reloadData()
                                    
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
    
    func callDeleteSearchAPI(deleteDict: NSDictionary) -> Void {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            let tracker = GAI.sharedInstance().defaultTracker
            let trackDictionary = GAIDictionaryBuilder.createEvent(withCategory: "API", action: "Delete Saved Searches List API Called", label: "Delete Saved Searches List", value: nil).build()
            tracker?.send(trackDictionary as AnyObject as! [AnyHashable: Any])
            
            let loading = UIActivityIndicatorView_ActivityClass(text: "Loading")
            self.view.addSubview(loading)
            let userId: String = UserDefaults.standard.object(forKey: "UserId") as! String
            let searchName = deleteDict.value(forKey: "name") as! String
            let paramsDict: [ String : String] = ["uid": userId, "search_name": searchName, "dealer_code": Constant.Dealer.DealerCode] as Dictionary
            print(NSString(format: "Request: %@", paramsDict))
            
            Alamofire.request(Constant.API.kBaseUrlPath+"removesearch", method: .post, parameters: paramsDict).responseJSON
                { response in
                    loading.hide()
                    if let JSON = response.result.value {
                        
                        print(NSString(format: "Response: %@", JSON as! NSDictionary))
                        let status = (JSON as AnyObject).value(forKey: "status") as! String
                        if status == "True"  {
                            do {
                                let dict: SavedSearchesList = try SavedSearchesList(dictionary: JSON as! [AnyHashable: Any])
                                
                                self.savedSearchesArray = dict.response?.data as! Array<AnyObject>
                                print(self.savedSearchesArray)
                                DispatchQueue.main.async{
                                    
                                    self.tableView.reloadData()
                                    
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
    
    //MARK:- UIBUTTON ACTIONS
    func deleteSearch(sender: UIButton) -> Void {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this search?", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            let dict = self.savedSearchesArray[sender.tag] as! NSDictionary
            self.callDeleteSearchAPI(deleteDict: dict)
        })
        alertController.addAction(defaultAction)
        
        let otherAction = UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
        })
        alertController.addAction(otherAction)
        
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
       
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SavedSearchResults" {
            let indexPath = sender as! IndexPath
            let savedSearchResults = (segue.destination as! InventoryResultsViewController)
            savedSearchResults.searchName = savedSearchesArray[indexPath.row].value(forKey: "name") as? String
    }
        
    }

}
