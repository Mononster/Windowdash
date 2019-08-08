//
//  PaymentAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-28.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class PaymentAPIServiceError: DefaultError {

}

final class PaymentAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return DefaultError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let paymentAPIProvider = MoyaProvider<PaymentAPITarget>(manager: SessionManager.authSession)

    enum PaymentAPITarget: TargetType {
        case addCard(stpToken: String)
        case fetchCards
        case updateDefaultCard(id: String)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .addCard, .fetchCards:
                return "v2/consumer/me/payment_card/"
            case .updateDefaultCard:
                return "v2/consumer/me/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .addCard:
                return .post
            case .fetchCards:
                return .get
            case .updateDefaultCard:
                return .patch
            }
        }

        var task: Task {
            switch self {
            case .addCard(let token):
                let params = ["stripe_token": token]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .fetchCards:
                return .requestPlain
            case .updateDefaultCard(let id):
                let params = ["default_card": ["id": id]]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            }
        }

        var sampleData: Data {
            switch self {
            case .addCard, .fetchCards, .updateDefaultCard:
                return Data()
            }
        }

        var headers: [String: String]? {
            switch self {
            case .updateDefaultCard:
                guard let token = ApplicationEnvironment.current.authToken?.tokenStr else {
                    fatalError("User should have a token at this point.")
                }
                return ["Authorization": "JWT \(token)"]
            default:
                return nil
            }
        }
    }
}

extension PaymentAPIService {

    func addPaymentCard(token: String,
                        completion: @escaping (PaymentMethod?, Error?) -> ()) {
        paymentAPIProvider.request(.addCard(stpToken: token)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let paymentMethod = try response.map(PaymentMethod.self)
                    completion(paymentMethod, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func fetchPaymentMethods(completion: @escaping ([PaymentMethod], Error?) -> ()) {
        paymentAPIProvider.request(.fetchCards) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion([], error)
                        return
                    }
                    let paymentMethods = try response.map([PaymentMethod].self)
                    completion(paymentMethods, nil)
                } catch {
                    completion([], error)
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }

    func updateDefaultCard(id: Int64, completion: @escaping (User?, Error?) -> ()) {
        paymentAPIProvider.request(.updateDefaultCard(id: String(id))) { (result) in
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
}


