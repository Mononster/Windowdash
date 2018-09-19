//
//  PSDistrict+CoreDataProperties.swift
//  
//
//  Created by Marvin Zhan on 2018-09-18.
//
//

import Foundation
import CoreData


extension PSDistrict {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSDistrict> {
        return NSFetchRequest<PSDistrict>(entityName: "PSDistrict")
    }

    @NSManaged public var shortName: String?
    @NSManaged public var id: Int64
    @NSManaged public var isActive: Bool
    @NSManaged public var firstDeliveryPrice: Double
    @NSManaged public var name: String?

}
