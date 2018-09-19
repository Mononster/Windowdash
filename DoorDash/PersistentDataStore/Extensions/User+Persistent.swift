//
//  User+Persistent.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import CoreData

extension User: PersistentModel {
    public func savePersistently(to dataStore: DataStoreType) throws {
        guard self.validateModel() else {
            throw PersistentModelError.invalid
        }
        dataStore.performBackgroundTask { context in
            do {
                _ = self.insertOrUpdateTo(context)
                try context.save()
            } catch {
                log.error(error)
            }
        }
    }

    func validateModel() -> Bool {
        return true
    }

    public func insertOrUpdateTo(_ context: NSManagedObjectContext) -> PSUser {
        let user = PSUser(entity: PSUser.entity(), insertInto: context)
        user.remoteID = id
        user.phoneNumber = phoneNumber
        user.email = email
        user.firstName = firstName
        user.lastName = lastName
        return user
    }

    public static func revert(persistent: PSUser) throws -> User {
        return User(
            id: persistent.remoteID,
            phoneNumber: persistent.phoneNumber ?? "",
            lastName: persistent.lastName ?? "",
            firstName: persistent.firstName ?? "",
            email: persistent.email ?? "",
            defaultAddress: nil
        )
    }
}

extension User {
    static func currentUser(`in` context: NSManagedObjectContext, completion: @escaping (User?) -> ()) {
        let predicate = NSPredicate(format: "isCurrent = true")
        var realUser: User?
        User.fetch(with: predicate, in: context, completion: { psUser in
            if let psUser = psUser {
                realUser = try? User.revert(persistent: psUser)
            }
            completion(realUser)
        })
    }
}


