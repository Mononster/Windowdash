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
                SignupAgreementModel(),
                SignupButtonModel(mode: mode)
            ]
        }
    }
//
//    func fbLogin(permissions: [String],
//                 from viewController: UIViewController,
//                 completion: @escaping (AuthenticationState) -> ()) {
//        fbLoginManager.logIn(withReadPermissions: permissions, from: viewController)
//        { (loginResult, error) in
//            if let error = error {
//                log.info("Facebook login failed \(error)")
//                completion(AuthenticationState.notAuthenticated)
//                return
//            }
//            guard let result = loginResult,
//                let token = result.token,
//                let uid = token.userID else {
//                completion(AuthenticationState.notAuthenticated)
//                return
//            }
//
//            self.userAPI.thirdPartySignup(partnerName: "Facebook",
//                                          partnerSideId: uid,
//                                          authToken: token.tokenString,
//                                          completion:
//            { (user, token, error) in
//                guard let user = user, error == nil else {
//                    log.info("Facebool login failed, when connected to backend signup")
//                    completion(AuthenticationState.notAuthenticated)
//                    return
//                }
//
//                ApplicationEnvironment.login(
//                    credentials: Credentials(
//                        account: user.email!,
//                        token: AuthToken(token!)),
//                    currentUser: user)
//
//                try? user.savePersistently(to: self.dataStore)
//                completion(AuthenticationState.authenticated)
//            })
//        }
//    }
}
