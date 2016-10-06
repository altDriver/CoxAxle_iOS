//
//  RecentSearches+CoreDataClass.swift
//  CoxAxle
//
//  Created by Prudhvi on 06/10/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
import CoreData


public class RecentSearches: NSManagedObject {

    class func insertDictionary(dict:NSDictionary, context:NSManagedObjectContext) -> RecentSearches {
        let dataObj = NSEntityDescription.insertNewObject(forEntityName: "RecentSearches", into: context) as! RecentSearches
        
        dataObj.searchName = dict["searchName"] as? String
        dataObj.price = dict["price"] as? String
        dataObj.mileage = dict["mileage"] as? String
        dataObj.subModel = dict["subModel"] as? String
        dataObj.savedTime = dict["savedTime"] as? String
        
        return dataObj
    }
    
    class func updateDictionary(dict:NSDictionary, object:NSManagedObject, context:NSManagedObjectContext) -> Void  {
        let dataObj = object as! RecentSearches
        
        dataObj.searchName = dict["searchName"] as? String
        dataObj.price = dict["price"] as? String
        dataObj.mileage = dict["mileage"] as? String
        dataObj.subModel = dict["subModel"] as? String
        dataObj.savedTime = dict["savedTime"] as? String
    }
    
    class func fetchdatawithRequest() -> NSFetchRequest<RecentSearches> {
        let fetchRequest: NSFetchRequest<RecentSearches> = NSFetchRequest.init(entityName: "RecentSearches")
        return fetchRequest
    }
    
    class func fetchAllDatawithRequest() -> NSFetchRequest<RecentSearches> {
        let fetchRequest: NSFetchRequest<RecentSearches> = self.fetchdatawithRequest()
        //  var descriptor: NSSortDescriptor = NSSortDescriptor.init(key: "trackName", ascending: true)
        //  var sortDescriptors: NSArray = NSArray(objects: descriptor)
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "trackName", ascending: true)]
        return fetchRequest
    }

    class func fetchParticularRecord(rid: NSString, context:NSManagedObjectContext) -> RecentSearches! {
        
        let fetchRequest: NSFetchRequest<RecentSearches> = NSFetchRequest.init(entityName: "RecentSearches")
        let predicate: NSPredicate = NSPredicate(format: "searchName == %@", rid)
        
        fetchRequest.predicate = predicate
        do {
            let lastReviewed: NSArray = try context.fetch(fetchRequest) as NSArray
            
            if lastReviewed.count > 0 {
                return lastReviewed.lastObject as! RecentSearches
            }
            
            
        }
        catch let error as NSError
        {
            NSLog("Unresolved error \(error), \(error.userInfo)")
        }
        return nil
    }
}
