//
//  SignupTempAccount.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

enum SignupAccountType: String {
    case facebook
    case email
    case google
}

struct SignupTempAccount {
    let account: String
    let type: SignupAccountType
    let userName: String

    public init(account: String,
                type: SignupAccountType,
                userName: String) {
        self.account = account
        self.type = type
        self.userName = userName
    }

    public static let emailAccount: (_ email: String, _ userName: String) -> SignupTempAccount = { email, userName in
        return SignupTempAccount(account: email, type: .email, userName: userName)
    }

    public static let faceboolAccont: (_ email: String, _ userName: String) -> SignupTempAccount = {
        email, userName in
        return SignupTempAccount(account: email, type: .facebook, userName: userName)
    }
}
