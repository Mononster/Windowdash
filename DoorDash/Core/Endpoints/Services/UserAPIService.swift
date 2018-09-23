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
        case guestSignup(password: String)
        case fetchUserProfile(authToken: AuthToken)
        case updateDeliveryLocation(uid: String, location: GMDetailLocation)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .login:
                return "v2/auth/token/"
            case .fetchUserProfile:
                return "v2/consumer/me/"
            case .register, .guestSignup:
                return "v2/consumer/"
            case .updateDeliveryLocation(let uid, _):
                return "v2/consumer/\(uid)/address/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .login, .register, .guestSignup, .updateDeliveryLocation:
                return .post
            case .fetchUserProfile:
                return .get
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
            case .guestSignup(let password):
                return .requestParameters(
                    parameters: ["is_guest": 1,
                                 "password": password],
                    encoding: JSONEncoding.default)
            case .fetchUserProfile:
                return .requestPlain
            case .updateDeliveryLocation(_, let location):
                var paramters: [String: Any] = [:]
                if let lat = location.latitude {
                    paramters["manual_lat"] = lat
                }
                if let lng = location.longitude {
                    paramters["manual_lng"] = lng
                }
                if let instructions = location.dasherInstructions {
                    paramters["driver_instructions"] = instructions
                }
                paramters["printable_address"] = location.address
                paramters["subpremise"] = location.apartmentNumber ?? ""
                paramters["google_place_id"] = location.placeID
                return .requestParameters(
                    parameters: paramters,
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
            case .fetchUserProfile, .updateDeliveryLocation, .guestSignup:
                return Data()
            }
        }

        var headers: [String : String]? {
            switch self {
            case .fetchUserProfile(let token):
                return ["Authorization": "JWT \(token.tokenStr)"]
            default:
                return nil
            }
        }
    }
}

extension UserAPIService {
    func handleLoginErrors(response: Response) -> Error {
        if let json = try? JSON(data: response.data),
            let errorMsgs = json["non_field_errors"].array,
            let urlResponse = response.response {
            return self.error(urlResponse, errorMsgs.first?.string ?? "")
        } else {
            return NSError(domain: "", code: response.statusCode, userInfo: nil)
        }
    }

    func handleRegisterErrors(response: Response) -> Error {
        if let json = try? JSON(data: response.data),
            let urlResponse = response.response {
            return self.error(urlResponse, json["email"].string ?? "")
        } else {
            return NSError(domain: "", code: response.statusCode, userInfo: nil)
        }
    }
}

extension UserAPIService {
    
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
                        let error = self.handleRegisterErrors(response: response)
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

    func guestRegister(password: String, completion: @escaping (User?, Error?) -> ()) {
        userAPIProvider.request(.guestSignup(password: password)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 201 else {
                        let error = self.handleRegisterErrors(response: response)
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
                        let error = self.handleLoginErrors(response: response)
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

    func fetchUserProfile(token: AuthToken, completion: @escaping (User?, Error?) -> ()) {
        userAPIProvider.request(.fetchUserProfile(authToken: token)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
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

    func postUserDeliveryInfo(uid: String,
                              location: GMDetailLocation,
                              completion: @escaping (DeliveryAddress?, Error?) -> ()) {
        userAPIProvider.request(.updateDeliveryLocation(uid: uid, location: location)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let address = try response.map(DeliveryAddress.self)
                    completion(address, nil)
                } catch(let error) {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
