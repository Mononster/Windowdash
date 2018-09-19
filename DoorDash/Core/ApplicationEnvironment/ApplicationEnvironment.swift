//
//  ApplicationEnvironment.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct ApplicationEnvironment {
    internal static let currentEnvironmentStorageKey = "com.DoorDash.AppEnvironment.current"
    internal static let currentUserStorageKey = "com.DoorDash.AppEnvironment.current.user"

    private static var internalEnvironmentStack: [Environment] = [Environment.production]
    static var current: Environment! {
        return internalEnvironmentStack.last
    }

    static private(set) var sessionManager: SessionManager = SessionManager.authSession

    static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        internalEnvironmentStack.remove(at: internalEnvironmentStack.count - 2)
    }

    public static func replaceCurrentEnvironment(
        authToken: AuthTokenType? = ApplicationEnvironment.current.authToken,
        passwordToken: AuthTokenType? = ApplicationEnvironment.current.passwordToken,
        currentUser: User? = ApplicationEnvironment.current.currentUser,
        networkConfig: NetworkConfigurationType = ApplicationEnvironment.current.networkConfig,
        userDefaults: KeyValueStoreType = ApplicationEnvironment.current.userDefaults,
        securityStorage: SecurityStorageType = ApplicationEnvironment.current.securityStorage,
        dataStore: DataStoreType = ApplicationEnvironment.current.dataStore,
        mainBundle: BundleType = ApplicationEnvironment.current.mainBundle) {
        let currentActiveUser = ApplicationEnvironment.current.currentUser
        let currentNetworkConfig = ApplicationEnvironment.current.networkConfig

        let newEnv = Environment(
            type: ApplicationEnvironment.current.type,
            googleMapsAPIKey: ApplicationEnvironment.current.googleMapsAPIKey,
            userDefaults: userDefaults,
            securityStorage: securityStorage,
            dataStore: dataStore,
            mainBundle: mainBundle,
            authToken: authToken,
            passwordToken: passwordToken,
            networkConfig: ApplicationEnvironment.current.networkConfig ,
            currentUser: currentUser)

        if currentUser != currentActiveUser {
            if let encodedUser = try? JSONEncoder().encode(currentUser) {
                newEnv.userDefaults.set(encodedUser, forKey: currentUserStorageKey)
            }
        }
        replaceCurrentEnvironment(newEnv)

        if !(networkConfig == currentNetworkConfig) {
            sessionManager.session.invalidateAndCancel()
            sessionManager = SessionManager.authSession
        }
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
            if let encodedUser = try? JSONEncoder().encode(user) {
                userDefaults.set(encodedUser, forKey: currentUserStorageKey)
            }
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
        if let userData = storage.object(forKey: currentUserStorageKey) as? Data {
            let decoder = JSONDecoder()
            user = try? decoder.decode(User.self, from: userData)
        }

        return env.login(currentUser: user, passwordToken: credentials.token, authToken: nil)
    }

    static func updateCurrentUser(updatedUser: User) {
        let stackCount = internalEnvironmentStack.count
        self.internalEnvironmentStack[stackCount - 1].updateUser(updatedUser: updatedUser)
        self.saveEnvironment(userDefaults: UserDefaults.standard)
    }

    static func login(credentials: Credentials, currentUser: User, authToken: AuthTokenType) {
        let authController = AuthenticationController(serviceName: current.mainBundle.identifier)
        if authController.storeCredentials(credentials.account, token: credentials.token.tokenStr) {
            replaceCurrentEnvironment(current.login(currentUser: currentUser, passwordToken: credentials.token, authToken: authToken))
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
