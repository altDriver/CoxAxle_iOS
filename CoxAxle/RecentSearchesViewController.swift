//
//  RecentSearchesViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 06/10/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class RecentSearchesViewController: UIViewController {

    var recentSearchesArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRecentSearches()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FETCH DATA FROM DATABASE
    func fetchRecentSearches() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            try self.recentSearchesArray = [appDelegate.managedObjectContext.execute(RecentSearches.fetchAllDatawithRequest())]
                
                
                //appDelegate.managedObjectContext.executeFetchRequest(RecentSearches.fetchAllDatawithRequest() as! NSArray)
            
            print(self.recentSearchesArray.count)
        } catch let error as NSError
        {
            NSLog("Unresolved error \(error), \(error.userInfo)")
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
