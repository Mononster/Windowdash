//
//  PSDeliveryAddress+CoreDataProperties.swift
//  
//
//  Created by Marvin Zhan on 2018-09-18.
//
//

import Foundation
import CoreData


extension PSDeliveryAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSDeliveryAddress> {
        return NSFetchRequest<PSDeliveryAddress>(entityName: "PSDeliveryAddress")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: Int64
    @NSManaged public var timezone: String?
    @NSManaged public var state: String?
    @NSManaged public var shortName: String?
    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var driverInstructions: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var printableAddress: String?
    @NSManaged public var district: PSDistrict?
    @NSManaged public var user: PSUser?
}
