//
//  PSUser+CoreDataProperties.swift
//  
//
//  Created by Marvin Zhan on 2018-09-18.
//
//

import Foundation
import CoreData


extension PSUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PSUser> {
        return NSFetchRequest<PSUser>(entityName: "PSUser")
    }

    @NSManaged public var remoteID: Int64
    @NSManaged public var phoneNumber: String?
    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var email: String?
    @NSManaged public var defaultAddress: PSDeliveryAddress?
    @NSManaged public var isGuest: Bool
}
