//
//  RecentSearches+CoreDataProperties.swift
//  CoxAxle
//
//  Created by Prudhvi on 06/10/16.
//  Copyright © 2016 Prudhvi. All rights reserved.
//

import Foundation
import CoreData


extension RecentSearches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearches> {
        return NSFetchRequest<RecentSearches>(entityName: "RecentSearches");
    }

    @NSManaged public var searchName: String?
    @NSManaged public var price: String?
    @NSManaged public var mileage: String?
    @NSManaged public var subModel: String?
    @NSManaged public var savedTime: String?

}
