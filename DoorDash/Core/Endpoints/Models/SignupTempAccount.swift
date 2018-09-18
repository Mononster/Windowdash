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
    let type: SignupAccountType
    let email: String
    let phoneNumber: String
    let lastName: String
    let firstName: String

    public init(type: SignupAccountType,
                firstName: String,
                lastName: String,
                phoneNumber: String,
                email: String) {
        self.type = type
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
