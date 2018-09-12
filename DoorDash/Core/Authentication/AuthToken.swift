//
//  AuthToken.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

public protocol AuthTokenType {
    var tokenStr: String { get }
    var isEmpty: Bool { get }
}

public func == (lhs: AuthTokenType, rhs: AuthTokenType) -> Bool {
    return lhs.tokenStr == rhs.tokenStr
}

public func == (lhs: AuthTokenType?, rhs: AuthTokenType?) -> Bool {
    return type(of: lhs) == type(of: rhs) && lhs?.tokenStr == rhs?.tokenStr
}

public func != (lhs: AuthTokenType, rhs: AuthTokenType) -> Bool {
    return lhs.tokenStr != rhs.tokenStr
}

public func != (lhs: AuthTokenType?, rhs: AuthTokenType?) -> Bool {
    return type(of: lhs) != type(of: rhs) || lhs?.tokenStr != rhs?.tokenStr
}

public struct AuthToken: AuthTokenType, Equatable {
    public let tokenStr: String

    public init(_ token: String) {
        self.tokenStr = token
    }

    public var isEmpty: Bool {
        return tokenStr.isEmpty
    }
}

public func == (lhs: AuthToken, rhs: AuthToken) -> Bool {
    return lhs.tokenStr == rhs.tokenStr
}

public struct Credentials: Equatable {
    public let account: String
    public let token: AuthTokenType

    public var isEmpty: Bool {
        return account.isEmpty || token.isEmpty
    }

    public init(account: String, token: AuthTokenType) {
        self.account = account
        self.token = token
    }
}

public func == (lhs: Credentials, rhs: Credentials) -> Bool {
    return lhs.account == rhs.account && lhs.token == rhs.token
}

