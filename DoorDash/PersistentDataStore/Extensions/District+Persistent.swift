//
//  District+Persistent.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import CoreData

extension District: PersistentModel {
    public func savePersistently(to dataStore: DataStoreType) throws {
        guard self.validateModel() else {
            throw PersistentModelError.invalid
        }
        dataStore.performBackgroundTask { context in
            do {
                _ = self.insertOrUpdateTo(context)
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try context.save()
            } catch {
                print("\(error)")
            }
        }
    }

    func validateModel() -> Bool {
        return true
    }

    public func insertOrUpdateTo(_ context: NSManagedObjectContext) -> PSDistrict {
        let district = PSDistrict(entity: PSDistrict.entity(), insertInto: context)
        district.id = id
        district.isActive = isActive
        district.name = name
        district.shortName = shortName
        district.firstDeliveryPrice = firstDeliveryPrice
        return district
    }

    public static func revert(persistent: PSDistrict) throws -> District {
        return District(shortName: persistent.shortName ?? "",
                        name: persistent.name ?? "",
                        id: persistent.id,
                        isActive: persistent.isActive,
                        firstDeliveryPrice: persistent.firstDeliveryPrice)
    }
}


