//
//  PersistentModel.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import CoreData

public enum PersistentModelError: Error {
    case invalid
    case persistentFailed
    case convertBackFailed
}

public protocol PersistentModel {
    associatedtype PersistentType
    associatedtype Context

    func savePersistently(to dataStore: DataStoreType) throws
    func insertOrUpdateTo(_ context: Context) -> PersistentType
    static func revert(persistent: PersistentType) throws -> Self
    static func fetch(with predicate: NSPredicate?, relationshipKeysForFetching: [String]?, sortDescriptors: [NSSortDescriptor]?, `in` context: Context, completion: @escaping (PersistentType?) -> ())
}

extension PersistentModel where Context: NSManagedObjectContext, PersistentType: NSManagedObject {

    public static var entityName: String? {
        return PersistentType.entity().name
    }

    public static func fetch(with predicate: NSPredicate?,
                             relationshipKeysForFetching: [String]? = nil,
                             sortDescriptors: [NSSortDescriptor]? = nil,
                             `in` context: Context,
                             completion: @escaping (PersistentType?) -> ()) {
        var ret: PersistentType?
        context.perform {
            do {
                let fetchRequest = PersistentType.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                fetchRequest.relationshipKeyPathsForPrefetching = relationshipKeysForFetching
                let result = try context.fetch(fetchRequest)
                if let first = result.first as? PersistentType {
                    ret = first
                }
                completion(ret)
            } catch {
                log.error(error)
                completion(nil)
            }
        }
    }
}

