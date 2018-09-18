////
////  CreateAccountViewModel.swift
////  UWLife
////
////  Created by Marvin Zhan on 2018-03-03.
////  Copyright © 2018 Monster. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//
//final class CreateAccountViewModel {
//
//    private let apiService: UserAPIService
//    private let dataStore: DataStoreType
//
//    init(userAPIService: UserAPIService,
//         dataStore: DataStoreType) {
//        self.apiService = userAPIService
//        self.dataStore = dataStore
//    }
//
//    func validate(account: SignupTempAccount,
//                  password: String,
//                  completion: @escaping (ValidationResult<String>) -> ()) {
//        let validation = EmailValidationService(userAPIService: apiService)
//        let nameValidationResult = validation.charactersAndSpaceOnly(account.userName)
//        let passwordValidationResult = validation.validatePassword(password)
//        // validate name first
//        guard nameValidationResult.isValid else {
//            completion(nameValidationResult)
//            return
//        }
//
//        guard passwordValidationResult.isValid else {
//            completion(passwordValidationResult)
//            return
//        }
//
//        validation.validate(account.account, completion: completion)
//    }
//
//    func registerUser(account: SignupTempAccount,
//                      password: String,
//                      completion: @escaping (Bool) -> ()) {
//        apiService.signup(account, password: password) { (user, token, error) in
//            if let error = error {
//                log.info(error)
//                completion(false)
//                return
//            }
//
//            guard let user = user, let token = token else {
//                log.error("User doesn't exist")
//                completion(false)
//                return
//            }
//
//            ApplicationEnvironment.login(
//                credentials: Credentials(
//                    account: account.account,
//                    token: AuthToken(token)),
//                currentUser: user)
//            try? user.savePersistently(to: self.dataStore)
//            completion(true)
//        }
//    }
//}
