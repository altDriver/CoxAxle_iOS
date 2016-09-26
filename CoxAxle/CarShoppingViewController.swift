//
//  CarShoppingViewController.swift
//  CoxAxle
//
//  Created by Prudhvi on 20/09/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import UIKit

class CarShoppingViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource {
    
    let shoppingReuseIdentifier = "ShoppingCell"
    let carShoppingArray  = ["Dealer Inventory", "Saved Searches", "Favorite Cars", "Calculators", "Vehicle Values"]
    var logoImage: [UIImage] = [
        UIImage(named: "blueCar")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(named: "savedCarsIcon")!,
        UIImage(named: "searchCarsIcon")!,
        UIImage(),
        UIImage(),
        UIImage(),
        UIImage(named: "carValueIcon")!,
        UIImage(),
        UIImage(),]
    @IBOutlet var tableView: UITableView!
    
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
    let cells = SwiftyAccordionCells()

    override func viewDidLoad() {
        super.viewDidLoad()
         self.screenName = "CarShoppingViewController"
        // Do any additional setup after loading the view.
        self.setup()
        self.tableView.estimatedRowHeight = 74
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SETUP
    func setup() {
        
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Dealer Inventory" as AnyObject))
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Saved Searches" as AnyObject))
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Favorite Cars" as AnyObject))
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Calculators" as AnyObject))
        self.cells.append(SwiftyAccordionCells.Item(value: "Payment Calculator" as AnyObject))
        self.cells.append(SwiftyAccordionCells.Item(value: "Affordability Calculator" as AnyObject))
        self.cells.append(SwiftyAccordionCells.Item(value: "Lease vs. Purchase Calculator" as AnyObject))
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "Vehicle Values" as AnyObject))
        self.cells.append(SwiftyAccordionCells.Item(value: "Price New/Used  Cars" as AnyObject))
        self.cells.append(SwiftyAccordionCells.Item(value: "My Car’s Value" as AnyObject))
    }
 
    
    //MARK:- UITABLEVIEW DATA SOURCE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        let value = item.value as? String
        let isChecked = item.isChecked as Bool
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: shoppingReuseIdentifier) as UITableViewCell!
        
        let cellImageView: UIImageView = cell.viewWithTag(251) as! UIImageView
        let cellTitle: UILabel = cell.viewWithTag(252) as! UILabel
        
        cellImageView.image = self.logoImage[indexPath.row] as UIImage
        cellTitle.text = value
        
        if item as? SwiftyAccordionCells.HeaderItem != nil {
            cell.backgroundColor = UIColor.clear
            cellTitle.font = UIFont(name: "HelveticaNeue", size: 17.0)
            switch indexPath.row {
            case 3,7:
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            default:
                cell.accessoryType = UITableViewCellAccessoryType.none
                break
            }
        } else {
            
            cellTitle.font = UIFont(name: "HelveticaNeue", size: 14.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            if isChecked {
               // cell.accessoryType = .checkmark
            } else {
                //cell.accessoryType = .none
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            switch indexPath.row {
            case 2:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "FavoriteCars", sender: self)
                }
                break
            default:
                break
            }
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
        } else {
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.tableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.none
                    cells.items[selectedItemIndex].isChecked = false
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            return 74
        } else if (item.isHidden) {
            return 0
        } else {
            return 74
        }
    }
    
    //MARK:- UIBUTTON ACTIONS
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        if let frostView = self.view{
            frostView.endEditing(true)
        }
        
        if let frostingViewController = self.frostedViewController{
            frostingViewController.view.endEditing(true)
            frostingViewController.presentMenuViewController()
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
