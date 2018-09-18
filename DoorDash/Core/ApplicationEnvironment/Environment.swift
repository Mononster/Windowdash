//
//  Environment.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

struct EnvironmentType: Equatable {
    let rawValue: String

    static let production = EnvironmentType(rawValue: "production")
    static let latest = EnvironmentType(rawValue: "latest")
    static func all() -> [EnvironmentType] {
        return [.production, .latest]
    }

    static func from(typeString: String) -> EnvironmentType {
        switch typeString {
        case "production":
            return .production
        default:
            fatalError("Not Supported EnvironmentType")
        }
    }
}

func ==(lhs: EnvironmentType, rhs: EnvironmentType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

struct Environment {
    let type: EnvironmentType
    let googleMapsAPIKey: String
    let dataStore: DataStoreType
    let userDefaults: KeyValueStoreType
    let securityStorage: SecurityStorageType
    let mainBundle: BundleType
    let authToken: AuthTokenType?
    var currentUser: User?
    let networkConfig: NetworkConfigurationType

    init(type: EnvironmentType,
         googleMapsAPIKey: String,
         userDefaults: KeyValueStoreType = UserDefaults.standard,
         securityStorage: SecurityStorageType = AuthenticationController(serviceName: Bundle.main.bundleIdentifier ?? ""),
         dataStore: DataStoreType = DataStore(),
         mainBundle: BundleType = Bundle.main,
         authToken: AuthTokenType? = nil,
         networkConfig: NetworkConfigurationType,
         currentUser: User? = nil) {

        self.type = type
        self.googleMapsAPIKey = googleMapsAPIKey
        self.userDefaults = userDefaults
        self.dataStore = dataStore
        self.securityStorage = securityStorage
        self.mainBundle = mainBundle
        self.authToken = authToken
        self.networkConfig = networkConfig
        self.currentUser = currentUser
    }

    static let production: Environment = Environment(
        type: .production,
        googleMapsAPIKey: Constants.GoogleMapsKey.release.rawValue,
        networkConfig: NetworkConfiguration.production
    )

    // TODO: Change to debug key when debug key is set up
    static let latest: Environment = Environment(
        type: .latest,
        googleMapsAPIKey: Constants.GoogleMapsKey.release.rawValue,
        networkConfig: NetworkConfiguration.latest
    )

    public static let `default`: Environment = .production

    public static func `for`(_ type: EnvironmentType) -> Environment {
        switch type {
        case EnvironmentType.production:
            return Environment.production
        case EnvironmentType.latest:
            return Environment.latest
        default:
            fatalError("Not supported Environment")
        }
    }

    func login(token: AuthTokenType, currentUser: User?) -> Environment {
        return Environment(type: type,
                           googleMapsAPIKey: googleMapsAPIKey,
                           userDefaults: userDefaults,
                           securityStorage: securityStorage,
                           dataStore: dataStore,
                           mainBundle: mainBundle,
                           authToken: token,
                           networkConfig: networkConfig,
                           currentUser: currentUser)
    }

    func logout() -> Environment {
        return Environment(type: type,
                           googleMapsAPIKey: googleMapsAPIKey,
                           userDefaults: userDefaults,
                           securityStorage: securityStorage,
                           dataStore: dataStore,
                           mainBundle: mainBundle,
                           authToken: nil,
                           networkConfig: networkConfig,
                           currentUser: nil)
    }

    mutating func updateUser(updatedUser: User) {
        self.currentUser = updatedUser
    }
}
