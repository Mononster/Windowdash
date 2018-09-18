////
////  LoginViewModel.swift
////  UWLife
////
////  Created by Marvin Zhan on 2018-03-04.
////  Copyright © 2018 Monster. All rights reserved.
////
//
//import SwiftyJSON
//
//final class LoginViewModel {
//
//    let apiService: UserAPIService
//    let dataStore: DataStoreType
//
//    init(userAPIService: UserAPIService,
//         dataStore: DataStoreType) {
//        self.apiService = userAPIService
//        self.dataStore = dataStore
//    }
//
//    func loginUser(email: String,
//                   password: String,
//                   completion: @escaping (ValidationResult<String>) -> ()) {
//        apiService.login(email, password: password) { (user, token, error) in
//            if let error = error {
//                completion(.failed(message: error.localizedDescription))
//                return
//            }
//
//            if let user = user, let token = token {
//                //MARK: Not sure if saving to cache is useful
//                ApplicationEnvironment.login(
//                    credentials: Credentials(
//                        account: email,
//                        token: AuthToken(token)),
//                    currentUser: user)
//                try? user.savePersistently(to: self.dataStore)
//                completion(.ok(""))
//            } else {
//                completion(.failed(message: "Something went wrong..."))
//            }
//        }
//    }
//
//}
