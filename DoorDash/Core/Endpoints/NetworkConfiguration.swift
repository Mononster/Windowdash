//
//  NetworkConfiguration.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import Alamofire

public typealias RetryPredicate = (Error) -> Bool

public enum RetryPolicy {
    case immediately(maxCount: Int)
    case constantDelay(maxCount: Int, delay: TimeInterval)
    case exponentialDelay(maxCount: Int, inital: TimeInterval, multiplier: TimeInterval)
}

extension RetryPolicy {
    typealias PolicyParameters = (maxCount: Int, delay: TimeInterval)
    func parameters(_ currentRepetition: Int) -> PolicyParameters {
        switch self {
        case .immediately(let maxCount):
            return (maxCount: maxCount, delay: 0.0)
        case .constantDelay(let maxCount, let delay):
            return (maxCount: maxCount, delay: delay)
        case .exponentialDelay(let maxCount, let inital, let multiplier):
            let delay = currentRepetition == 1 ? inital : inital * pow(1 + multiplier, Double(currentRepetition - 1))
            return (maxCount: maxCount, delay: delay)
        }
    }
}

public func ==(lhs: RetryPolicy, rhs: RetryPolicy) -> Bool {
    switch (lhs, rhs) {
    case (.immediately(let lmax), .immediately(let rmax)):
        return lmax == rmax
    case (.constantDelay(let lmax, let ldelay), .constantDelay(let rmax, let rdelay)):
        return lmax == rmax && ldelay == rdelay
    case (.exponentialDelay(let lmax, let lInitial, let lMultiplier),
          .exponentialDelay(let rmax, let rInitial, let rMultiplier)):
        return lmax == rmax && lInitial == rInitial && lMultiplier == rMultiplier
    default:
        return false
    }
}

public protocol NetworkConfigurationType {
    var hostURL: URL { get }
    var retryPolicy: RetryPolicy { get }
    var timeoutInterval: TimeInterval { get }
}

public func ==(lhs: NetworkConfigurationType, rhs: NetworkConfigurationType) -> Bool {
    return lhs.hostURL == rhs.hostURL
        && lhs.timeoutInterval == rhs.timeoutInterval
        && lhs.retryPolicy == rhs.retryPolicy
}

public struct NetworkConfiguration: NetworkConfigurationType {
    public let timeoutInterval: TimeInterval
    public let retryPolicy: RetryPolicy
    public let hostURL: URL

    public init(
        timeOut: TimeInterval = 30,
        retryPolicy: RetryPolicy = .exponentialDelay(maxCount: 5, inital: 1.0, multiplier: 1.0),
        hostURL: URL) {
        self.timeoutInterval = timeOut
        self.retryPolicy = retryPolicy
        self.hostURL = hostURL
    }

    public static let latest: NetworkConfiguration = NetworkConfiguration(
        hostURL: URL(string: Constants.API.Endpoint.latest.rawValue)!)

    public static let production: NetworkConfiguration = NetworkConfiguration(
        hostURL: URL(string: Constants.API.Endpoint.production.rawValue)!)
}
