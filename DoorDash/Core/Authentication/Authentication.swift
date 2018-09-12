//
//  Authentication.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import KeychainAccess

public enum SecurityStorageValueKey: String {
    case userAccount = "account_name"
    case token = "account_token"
}

public enum AuthenticationError: Error {
    case accountNotExist
    case tokenNotExist
}

public enum AuthenticationState {
    case unknown
    case notAuthenticated
    case authenticated
}

public protocol SecurityStorageType {
    init(serviceName: String)
    func loadToken() -> AuthTokenType?
    func storeCredentials(_ account: String, token: String) -> Bool
    func cleanUp()
    func fetchCredentials() throws -> Credentials
}

public final class AuthenticationController: SecurityStorageType {

    private let keychainService: Keychain

    public init(serviceName: String) {
        keychainService = Keychain(service: serviceName).accessibility(.afterFirstUnlock)
    }

    public func loadToken() -> AuthTokenType? {
        do {
            let credentials = try fetchCredentials()
            return credentials.token
        } catch {
            return nil
        }
    }

    @discardableResult
    public func storeCredentials(_ account: String, token: String) -> Bool {
        do {
            try self.keychainService.set(account, key: SecurityStorageValueKey.userAccount.rawValue)
            try self.keychainService.set(token, key: account)
            return true
        } catch {
            try? self.keychainService.remove(SecurityStorageValueKey.userAccount.rawValue)
            try? self.keychainService.remove(account)
            return false
        }
    }

    public func cleanUp() {
        do {
            try self.keychainService.removeAll()
        } catch {
            log.error(error)
        }
    }

    public func fetchCredentials() throws -> Credentials {
        guard let account = try self.keychainService.get(SecurityStorageValueKey.userAccount.rawValue) else {
            throw AuthenticationError.accountNotExist
        }

        guard let token = try self.keychainService.get(account) else {
            throw AuthenticationError.tokenNotExist
        }

        return Credentials(account: account, token: AuthToken(token))
    }
}

