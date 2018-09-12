//
//  ApplicationCache.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import Cache
import SwiftyJSON

/// Wrapper for Cache model
/// Supports the caching functionalities of the app
class ApplicationCache {

    static let manager = ApplicationCache()
    private var storage: Storage<Data>?

    private init() {
        let diskConfig = DiskConfig(name: "DoorDash: " + ApplicationEnvironment.current.type.rawValue)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 50, totalCostLimit: 0)
        self.storage = try? Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }

    func clearAll() {
        try? self.storage?.removeAll()
    }

    func getDataJSON(with key: String) -> JSON? {
        guard let storage = storage else {
            log.error("Storage has not been initilized")
            return nil
        }
        let events = try? storage.object(forKey: key)

        guard let data = events else {
            return nil
        }
        return try? JSON.init(data: data)
    }


    func saveToStorage(data: Data, key: String) {
        storage?.async.setObject(data.self, forKey: key, completion: { (result) in
            switch result {
            case .value:
                break
            //print("Saved to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func getTime(key: String) -> Date? {
        guard let storage = storage else {
            log.error("Storage has not been initilized")
            return nil
        }
        let dateStorage = storage.transform(transformer: TransformerFactory.forCodable(ofType: Date.self))
        let time = try? dateStorage.object(forKey: key)
        return time
    }

    func saveTime(time: Date, key: String) {
        let dateStorage = storage?.transform(transformer: TransformerFactory.forCodable(ofType: Date.self))
        dateStorage?.async.setObject(time, forKey: key, completion: { (result) in
            switch result {
            case .value:
                log.info("Saved time to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func getInt(key: String) -> Int? {
        guard let storage = storage else {
            log.error("Storage has not been initilized")
            return nil
        }
        let intStorage = storage.transform(transformer: TransformerFactory.forCodable(ofType: Int.self))
        let res = try? intStorage.object(forKey: key)
        return res
    }

    func saveInt(val: Int, key: String) {
        let intStorage = storage?.transform(transformer: TransformerFactory.forCodable(ofType: Int.self))
        intStorage?.async.setObject(val, forKey: key, completion: { (result) in
            switch result {
            case .value:
                log.info("Saved bool to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func getBool(key: String) -> Bool? {
        guard let storage = storage else {
            log.error("Storage has not been initilized")
            return nil
        }
        let boolStorage = storage.transform(transformer: TransformerFactory.forCodable(ofType: Bool.self))
        let bool = try? boolStorage.object(forKey: key)
        return bool
    }

    func saveBool(bool: Bool, key: String) {
        let boolStorage = storage?.transform(transformer: TransformerFactory.forCodable(ofType: Bool.self))
        boolStorage?.async.setObject(bool, forKey: key, completion: { (result) in
            switch result {
            case .value:
                log.info("Saved bool to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func getString(key: String) -> String? {
        guard let storage = storage else {
            log.info("Storage has not been initilized")
            return nil
        }
        let stringStorage = storage.transform(transformer: TransformerFactory.forCodable(ofType: String.self))
        let res = try? stringStorage.object(forKey: key)
        return res
    }

    func saveString(val: String, key: String) {
        let stringStorage = storage?.transform(transformer: TransformerFactory.forCodable(ofType: String.self))
        stringStorage?.async.setObject(val, forKey: key, completion: { (result) in
            switch result {
            case .value:
                log.info("Saved string to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func saveArray(array: [String], key: String) {
        let arrayStorage = storage?.transform(transformer: TransformerFactory.forCodable(ofType: [String].self))
        arrayStorage?.async.setObject(array, forKey: key, completion: { (result) in
            switch result {
            case .value:
                log.info("Saved [String] to cache successfully key = \(key)")
            case .error:
                log.error("Error when saving to cache.")
            }
        })
    }

    func getArray(key: String) -> [String]? {
        guard let storage = storage else {
            log.error("Storage has not been initilized")
            return nil
        }
        let arrayStorage = storage.transform(transformer: TransformerFactory.forCodable(ofType: [String].self))
        let array = try? arrayStorage.object(forKey: key)
        return array
    }
}


