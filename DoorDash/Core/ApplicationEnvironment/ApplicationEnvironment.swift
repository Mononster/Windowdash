//
//  ApplicationEnvironment.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ApplicationEnvironment {
    internal static let currentEnvironmentStorageKey = "com.DoorDash.AppEnvironment.current"
    internal static let currentUserStorageKey = "com.DoorDash.AppEnvironment.current.user"

    private static var internalEnvironmentStack: [Environment] = [Environment.production]
    static var current: Environment! {
        return internalEnvironmentStack.last
    }

    static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        internalEnvironmentStack.remove(at: internalEnvironmentStack.count - 2)
    }

    public static func replaceCurrentEnvironment(
        authToken: AuthTokenType? = ApplicationEnvironment.current.authToken,
        currentUser: User? = ApplicationEnvironment.current.currentUser,
        userDefaults: KeyValueStoreType = ApplicationEnvironment.current.userDefaults,
        securityStorage: SecurityStorageType = ApplicationEnvironment.current.securityStorage,
        dataStore: DataStoreType = ApplicationEnvironment.current.dataStore,
        mainBundle: BundleType = ApplicationEnvironment.current.mainBundle) {
        let currentActiveUser = ApplicationEnvironment.current.currentUser

        let newEnv = Environment(
            type: ApplicationEnvironment.current.type,
            googleMapsAPIKey: ApplicationEnvironment.current.googleMapsAPIKey,
            userDefaults: userDefaults,
            securityStorage: securityStorage,
            dataStore: dataStore,
            mainBundle: mainBundle,
            authToken: authToken,
            currentUser: currentUser)

        if currentUser != currentActiveUser {
            //try? newEnv.userDefaults.set(currentUser?.toJSON(), forKey: currentUserStorageKey)
        }
        replaceCurrentEnvironment(newEnv)
    }

    static func pushEnvironment(_ env: Environment) {
        saveEnvironment(env, userDefaults: env.userDefaults)
        internalEnvironmentStack.append(env)
    }

    static func popEnvironment() -> Environment? {
        let last = internalEnvironmentStack.popLast()
        let next = current ?? .default
        saveEnvironment(next, userDefaults: next.userDefaults)
        return last
    }

    static func saveEnvironment(_ env: Environment = ApplicationEnvironment.current, userDefaults: KeyValueStoreType) {
        userDefaults.set(env.type.rawValue, forKey: currentEnvironmentStorageKey)
        if let user = env.currentUser {
            //try? userDefaults.set(user.toJSON(), forKey: currentUserStorageKey)
        }
        userDefaults.synchronize()
    }

    static func restore(from storage: KeyValueStoreType) -> Environment? {
        guard let typeString = storage.string(forKey: currentEnvironmentStorageKey) else {
            return nil
        }
        let type = EnvironmentType(rawValue: typeString)
        let env = Environment.for(type)
        guard let credentials = try? AuthenticationController(serviceName: current.mainBundle.identifier)
            .fetchCredentials() else {
                return env
        }

        var user: User? = nil
        if let userDictionary = storage.dictionary(forKey: currentUserStorageKey) {
            //user = try? User.from(JSON(userDictionary))
        }

        return env.login(token: credentials.token, currentUser: user)
    }

    static func updateCurrentUser(updatedUser: User) {
        let stackCount = internalEnvironmentStack.count
        self.internalEnvironmentStack[stackCount - 1].updateUser(updatedUser: updatedUser)
        self.saveEnvironment(userDefaults: UserDefaults.standard)
    }

    static func login(credentials: Credentials, currentUser: User) {
        let authController = AuthenticationController(serviceName: current.mainBundle.identifier)
        if authController.storeCredentials(credentials.account, token: credentials.token.tokenStr) {
            replaceCurrentEnvironment(current.login(token: credentials.token, currentUser: currentUser))
        }
    }

    static func logout() {
        let authController = current.securityStorage
        authController.cleanUp()
        let dataStore = current.dataStore
        dataStore.destroyAndRecreateDataStore()
        current.userDefaults.removeObject(forKey: currentUserStorageKey)
        replaceCurrentEnvironment(current.logout())
    }
}
