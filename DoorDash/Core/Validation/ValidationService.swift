//
//  ValidationService.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

protocol ValidationResultPresentable {
    var message: String? { get }
    var isValid: Bool { get }
    var isVarifying: Bool { get }
}

enum ValidationResult<T>: ValidationResultPresentable {
    typealias Content = String

    case verifying(String)
    case ok(T)
    case empty
    case failed(message: String)

    var message: String? {
        switch self {
        case .ok, .empty:
            return nil
        case .failed(let message):
            return message
        case .verifying(let msg):
            return msg
        }
    }
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }

    var isVarifying: Bool {
        switch self {
        case .verifying:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: Equatable {}

func ==<T>(lhs: ValidationResult<T>, rhs: ValidationResult<T>) -> Bool {
    switch (lhs, rhs) {
    case (.ok, .ok):
        return true
    case (.empty, .empty):
        return true
    case (.failed(let lmsg), .failed(let rmsg)):
        return lmsg == rmsg
    case (.verifying(let lmsg), .verifying(let rmsg)):
        return lmsg == rmsg
    default:
        return false
    }
}

enum ValidationError: Error {
    case empty
    case notValid(message: String)
}


protocol ValidationServiceType {
    associatedtype Result
    associatedtype Value
    func validate(_ value: Value?, completion: @escaping (Result) -> ())
}

extension ValidationServiceType where Value == String {
    func charactersAndSpaceOnly(_ value: String?) -> ValidationResult<String> {
        let regex = "[A-Za-z\\s]+"
        let trimmedString = value?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmedString) else {
            return .failed(message: NSLocalizedString("user_name_validation_failed", comment: ""))
        }
        return .ok(value.unwrap())
    }

    func validatePassword(_ value: String?) -> ValidationResult<String> {
        let maybeTrimmedString = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmedString = maybeTrimmedString, !trimmedString.isEmpty else {
            return .failed(message: NSLocalizedString("password_validation_failed", comment: ""))
        }
        guard trimmedString.count >= 8 else {
            return .failed(message: NSLocalizedString("password_validation_failed", comment: ""))
        }

        return .ok(trimmedString)
    }
}

final class CharacterOnlyValidationService: ValidationServiceType {
    func validate(_ value: String?, completion: @escaping (ValidationResult<String>) -> ()) {
        completion(charactersAndSpaceOnly(value))
    }
}

enum AccountValidationResult: ValidationResultPresentable {

    typealias Content = String

    case verifying(String)
    case ok(String)
    case empty
    case exist(account: String, name: String)
    case failed(message: String)

    var message: String? {
        switch self {
        case .ok, .empty:
            return nil
        case .exist:
            return NSLocalizedString("account_exist", comment: "")
        case .failed(let message):
            return message
        case .verifying(let msg):
            return msg
        }
    }
}

extension AccountValidationResult {
    var isValid: Bool {
        switch self {
        case .ok, .exist:
            return true
        default:
            return false
        }
    }

    var isVarifying: Bool {
        switch self {
        case .verifying:
            return true
        default:
            return false
        }
    }
}

extension AccountValidationResult: Equatable {}

func ==(lhs: AccountValidationResult, rhs: AccountValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.ok(let value1), .ok(let value2)):
        return value1 == value2
    case (.empty, .empty):
        return true
    case (.exist(let user1), .exist(let user2)):
        return user1 == user2
    case (.failed(let message1), .failed(let message2)):
        return message1 == message2
    case (.verifying(let msg1), .verifying(let msg2)):
        return msg1 == msg2
    default:
        return false
    }
}


final class EmailValidationService: ValidationServiceType {

    func validate(_ value: String?, completion: @escaping (ValidationResult<String>) -> ()) {
        guard let notNilValue = value, !notNilValue.isEmpty else {
            completion(.empty)
            return
        }

        guard !notNilValue.containsWhitespace else {
            completion(.failed(message: NSLocalizedString("email_validation_failed", comment: "")))
            return
        }

        guard notNilValue.components(separatedBy: "@").count <= 2 else {
            completion(.failed(message: NSLocalizedString("email_validation_failed", comment: "")))
            return
        }
        // swiftlint:disable line_length
        let regex = "[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$" // Just do a simple client validation
        // swiftlint:enable line_length
        guard NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: notNilValue) else {
            completion(.failed(message: NSLocalizedString("email_validation_failed", comment: "")))
            return
        }

        completion(.ok(""))
    }
}

final class PasswordValidationService: ValidationServiceType {

    func validate(_ value: String?, completion: @escaping (ValidationResult<String>) -> ()) {
        completion(validatePassword(value))
    }
}


