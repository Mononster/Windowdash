//
//  KeyValueStoreType.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

public protocol KeyValueStoreType {
    func set(_ value: Any?, forKey defaultName: String)
    func bool(forKey key: String) -> Bool
    func dictionary(forKey defaultName: String) -> [String : Any]?
    func integer(forKey key: String) -> Int
    func object(forKey defaultName: String) -> Any?
    func string(forKey key: String) -> String?
    @discardableResult
    func synchronize() -> Bool

    func removeObject(forKey key: String)
}

extension UserDefaults: KeyValueStoreType {

}

