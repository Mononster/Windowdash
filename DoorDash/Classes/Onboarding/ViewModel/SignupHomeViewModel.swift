//
//  SignupHomeViewModel.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-04.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import IGListKit
import SwiftyJSON

enum SignupMode: String {
    case login = "Sign in"
    case register = "Sign Up"
}

enum SignInputFieldType: String {
    case firstName = "First Name"
    case lastName = "Last Name"
    case email = "Email"
    case phoneNumber = "Phone"
    case password = "Password"
}

extension SignInputFieldType: CaseIterable {}

final class SignupHomeViewModel {
    static let socailLoginIdentifier = "Social log in"
    private let userAPI: UserAPIService
    private let dataStore: DataStoreType
    //private let fbLoginManager: FBSDKLoginManager

    init(userAPI: UserAPIService,
         dataStore: DataStoreType) {
        self.userAPI = userAPI
        self.dataStore = dataStore
        //self.fbLoginManager = FBSDKLoginManager()
    }

    func getDataSource(mode: SignupMode) -> [ListDiffable] {
        if mode == .login {
            return [
                SignupHomeViewModel.socailLoginIdentifier as ListDiffable,
                SignInputFormModel(inputs: [.email, .password]),
                SignupButtonModel(mode: mode)
            ]
        } else {
            return [
                SignupHomeViewModel.socailLoginIdentifier as ListDiffable,
                SignInputFormModel(
                    inputs: [.firstName, .lastName, .email, .phoneNumber, .password]
                ),
                SignupButtonModel(mode: mode),
                SignupAgreementModel()
            ]
        }
    }

    func validateRegisterInputs(results: [SignInputFieldType: String]) -> (String, String)? {
        let baseErrorMsg = "Please add a "
        let baseErrorSubTitle = "Enter your "
        for type in SignInputFieldType.allCases {
            if results[type] == nil {
                // mising this type of inputs
                return (baseErrorMsg + type.rawValue.lowercased() + ".",
                        baseErrorSubTitle + type.rawValue.lowercased() + ".")
            }
        }
        let emailValidation = EmailValidationService() .validate(results[.email])
        if !emailValidation.isValid {
            return (emailValidation.message ?? "", "re-enter your email address.")
        }
        let phoneValidation = PhoneNumberValidationService().validate(results[.phoneNumber])
        if !phoneValidation.isValid {
            return ("We need a different phone number", phoneValidation.message ?? "")
        }
        let passwordValidation = PasswordValidationService().validate(results[.password])
        if !passwordValidation.isValid {
            return (passwordValidation.message ?? "", "Please re-enter your password")
        }
        return nil
    }

    func validateLoginInputs(results: [SignInputFieldType: String]) -> (String, String)? {
        if results[.email] == nil {
            return ("Oops", "We need your email!")
        }
        if results[.password] == nil {
            return ("Hey", "What's your password?")
        }
        return nil
    }

    func register(inputs: [SignInputFieldType: String],
                  completion: @escaping (String?) -> ()) {
        guard let firstName = inputs[.firstName],
            let lastName = inputs[.lastName],
            let phoneNumber = inputs[.phoneNumber],
            let email = inputs[.email],
            let password = inputs[.password] else {
            // Something is really wrong.
            fatalError()
        }

        let signupAcc = SignupTempAccount(
            type: .email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email
        )

        userAPI.register(signupAcc, password: password) { (user, error) in
            if let error = error as? UserAPIError {
                completion(error.errorMessage)
                return
            }
            
            self.login(email: email, password: password, completion: completion)
        }
    }

    func guestRegister(completion: @escaping (String?) -> ()) {
        let randomPassword = UUID().uuidString
        userAPI.guestRegister(password: randomPassword) { (user, error) in
            if let error = error as? UserAPIError {
                completion(error.errorMessage)
                return
            }
            guard let user = user else {
                completion("No user found, WTF happend?")
                return
            }
            let email = user.email
            self.login(email: email, password: randomPassword, completion: completion)
        }
    }

    func login(email: String,
               password: String,
               completion: @escaping (String?) -> ()) {
        userAPI.login(email: email, password: password) { (token, error) in
            if let error = error as? UserAPIError {
                completion(error.errorMessage)
                return
            }
            guard let token = token else {
                completion("Can't find auth token")
                return
            }
            self.userAPI.fetchUserProfile(token: AuthToken(token), completion: { (user, error) in
                if let user = user {
                    ApplicationEnvironment.login(
                        credentials: Credentials(
                            account: email,
                            token: AuthToken(password)),
                        currentUser: user,
                        authToken: AuthToken(token))
                    try? user.savePersistently(to: self.dataStore)
                    completion(nil)
                } else {
                    completion("v2-consumer-me, error when fetching user profile.")
                }
            })
        }
    }
}
