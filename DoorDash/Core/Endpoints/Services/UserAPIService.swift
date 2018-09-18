//
//  UserAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class UserAPIError: DefaultError {

    override public var errorTitle: String {
        let title = super.errorTitle
        switch self.kind {
        case .unprocessable:
            return NSLocalizedString("malformed", comment: "")
        default:
            return title
        }
    }

    override public var errorMessage: String {
        let message = super.errorMessage
        switch self.kind {
        case .unprocessable:
            return NSLocalizedString("malformed_message", comment: "")
        default:
            return message
        }
    }
}

class UserAPIService: DoorDashAPIService {
    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return UserAPIError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let userAPIProvider = MoyaProvider<UserAPITarget>(manager: SessionManager.authSession)

    struct Account {
        let accountIdentifier: SignupTempAccount
        let password: String?

        func convertToRequest() -> [String : String] {
            var params: [String : String] = [:]
            switch accountIdentifier.type {
            case .email:
                params["email"] = accountIdentifier.email
                params["phone_number"] = accountIdentifier.phoneNumber
                params["password"] = password
                params["first_name"] = accountIdentifier.firstName
                params["last_name"] = accountIdentifier.lastName
            case .facebook, .google:
                fatalError("Google login shouldn't use \(Account.self)")
            }
            return params
        }
    }

    enum UserAPITarget: TargetType {
        case login(email: String, password: String)
        case register(account: Account)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .login:
                return "v2/auth/token/"
            case .register:
                return "v2/consumer/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .login:
                return .post
            case .register:
                return .post
            }
        }
        var task: Task {
            switch self {
            case .login(let email, let password):
                return .requestParameters(
                    parameters: ["email": email, "password": password],
                    encoding: JSONEncoding.default
                )
            case .register(let account):
                return .requestParameters(
                    parameters: account.convertToRequest(),
                    encoding: JSONEncoding.default
                )
            }
        }

        var sampleData: Data {
            switch self {
            case .login(let email, let password):
                return "{\"email\": \"\(email)\", \"password\": \"\(password)\"}"
                    .data(using: String.Encoding.utf8)!
            case .register(let account):
                return "{\"email\": \"\(account.accountIdentifier.email)\", \"phone_number\": \"\(account.accountIdentifier.phoneNumber)\", \"password\": \"\(account.password ?? "")\", \"last_name\": \"\(account.accountIdentifier.lastName)\", \"last_name\": \"\(account.accountIdentifier.lastName)\"}".data(using: String.Encoding.utf8)!
            }
        }

        var headers: [String : String]? {
            return ["Content-Type": "application/json",
                    "User-Agent": "DoordashConsumer/3.0.90 (iPhone; iOS 11.4.1; Scale/3.00)",
                    "Accept": "application/json"
            ]
        }
    }
}

extension UserAPIService {
    /// Singup using email
    ///
    /// - Parameters:
    ///   - account: user current temp account
    ///   - password: password
    ///   - completion: Current User, Token, Error
    func register(_ account: SignupTempAccount,
                  password: String,
                  completion: @escaping (User?, Error?) -> ()) {
        let apiAccount = Account(
            accountIdentifier: account,
            password: password)
        userAPIProvider.request(.register(account: apiAccount)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 201 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let user = try response.map(User.self)
                    completion(user, nil)
                } catch(let error) {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func login(email: String,
               password: String,
               completion: @escaping (String?, Error?) -> ()) {
        userAPIProvider.request(.login(email: email, password: password)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let tokenDict = try response.map([String: String].self)
                    if let token = tokenDict["token"] {
                        completion(token, nil)
                    } else {
                        completion(nil, DefaultError.notAuthorized)
                    }
                } catch(let error) {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
