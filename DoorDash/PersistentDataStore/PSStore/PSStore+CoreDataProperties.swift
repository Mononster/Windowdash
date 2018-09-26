//
//  PSStore+CoreDataProperties.swift
//  
//
//  Created by Marvin Zhan on 2018-09-23.
//
//

import Foundation
import CoreData


extension PSStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSStore> {
        return NSFetchRequest<PSStore>(entityName: "PSStore")
    }

    @NSManaged public var id: Int64
    @NSManaged public var numRatings: Int64
    @NSManaged public var averageRating: Double
    @NSManaged public var storeDescription: String?
    @NSManaged public var priceRange: Int64
    @NSManaged public var name: String?
    @NSManaged public var nextCloseTime: Date?
    @NSManaged public var nextOpenTime: Date?
}
