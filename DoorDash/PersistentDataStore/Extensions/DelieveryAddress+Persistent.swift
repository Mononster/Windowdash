//
//  DelieveryAddress+Persistent.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import CoreData

extension DeliveryAddress: PersistentModel {
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

    public func insertOrUpdateTo(_ context: NSManagedObjectContext) -> PSDeliveryAddress {
        let deliveryAddress = PSDeliveryAddress(entity: PSDeliveryAddress.entity(), insertInto: context)
        let psDistrict = district?.insertOrUpdateTo(context)
        psDistrict?.deliveryAddress = deliveryAddress
        deliveryAddress.id = id
        deliveryAddress.city = city
        deliveryAddress.driverInstructions = driverInstructions
        deliveryAddress.lattitude = latitude
        deliveryAddress.longitude = longitude
        deliveryAddress.printableAddress = printableAddress
        deliveryAddress.shortName = shortName
        deliveryAddress.state = state
        deliveryAddress.zipCode = zipCode
        deliveryAddress.timezone = timezone
        deliveryAddress.district = psDistrict
        return deliveryAddress
    }

    public static func revert(persistent: PSDeliveryAddress) throws -> DeliveryAddress {
        var district: District? = nil
        if let psDistrict = persistent.district {
            district = try District.revert(persistent: psDistrict)
        }
        return DeliveryAddress(
            city: persistent.city ?? "",
            id: persistent.id,
            timezone: persistent.timezone ?? "",
            state: persistent.state ?? "",
            street: "",
            shortName: persistent.shortName ?? "",
            latitude: persistent.lattitude,
            longitude: persistent.longitude,
            driverInstructions: persistent.driverInstructions,
            zipCode: persistent.zipCode ?? "",
            printableAddress: persistent.printableAddress ?? "",
            district: district
        )
    }
}

