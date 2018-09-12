//
//  Dictionary+Operations.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

extension Dictionary {
    public func map<NewKey, NewValue>(_ transform: (Key, Value) throws -> (NewKey, NewValue)) rethrows -> [NewKey : NewValue] {
        var result: [NewKey : NewValue] = [:]
        for (key, value) in self {
            let (newKey, newValue) = try transform(key, value)
            result[newKey] = newValue
        }
        return result
    }

    public func flatMap<NewKey, NewValue>(_ transform: (Key, Value) throws -> (NewKey, NewValue)) -> [NewKey : NewValue] {
        var result: [NewKey : NewValue] = [:]
        for (key, value) in self {
            do {
                let (newKey, newValue) = try transform(key, value)
                result[newKey] = newValue
            } catch {
                #if DEBUG
                    print("\(error)")
                #endif
                continue
            }
        }
        return result
    }
}
