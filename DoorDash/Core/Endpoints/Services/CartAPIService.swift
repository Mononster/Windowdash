//
//  CartAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-09.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class CartAPIServiceError: DefaultError {

}

final class AddItemOptionRequestModel {
    let id: Int64
    let quantity: Int
    let nestedOptions: [AddItemOptionRequestModel]

    init(id: Int64, quantity: Int, nestedOptions: [AddItemOptionRequestModel]) {
        self.id = id
        self.quantity = quantity
        self.nestedOptions = nestedOptions
    }

    func convertToPostParams() -> [String: Any] {
        var result: [String: Any] = [:]
        result["id"] = id
        result["quantity"] = quantity
        result["options"] = nestedOptions.map { option in
            return option.convertToPostParams
        }
        return result
    }
}

final class AddItemToCartRequestModel {

    let storeID: String
    let itemID: String
    let cartID: String
    let subsititutionMethod: MenuItemSoldOutSubstitutionPreference
    let quantity: Int
    let options: [AddItemOptionRequestModel]
    let specialInstructions: String

    init(storeID: String,
         itemID: String,
         cartID: String,
         subsititutionMethod: MenuItemSoldOutSubstitutionPreference,
         quantity: Int,
         options: [AddItemOptionRequestModel],
         specialInstructions: String) {
        self.storeID = storeID
        self.itemID = itemID
        self.cartID = cartID
        self.subsititutionMethod = subsititutionMethod
        self.quantity = quantity
        self.options = options
        self.specialInstructions = specialInstructions
    }

    func convertToPostParams() -> [String: Any] {
        var result: [String: Any] = [:]
        result["quantity"] = quantity
        result["store"] = storeID
        result["substitution_preference"] = subsititutionMethod.rawValue
        result["item"] = itemID
        result["nested_options"] = options.map { option in
            return option.convertToPostParams()
        }
        result["special_instructions"] = specialInstructions
        return result
    }
}

final class CartAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return CartAPIServiceError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let cartAPIProvider = MoyaProvider<CartAPITarget>(manager: SessionManager.authSession)

    enum CartAPITarget: TargetType {
        case addToCart(request: AddItemToCartRequestModel)
        case getCurrentCartID
        case createCart
        case getCartDetail(request: FetchCartRequestModel)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .addToCart(let request):
                return "v2/order_carts/\(request.cartID)/order_items/"
            case .getCurrentCartID:
                return "v2/consumers/me/current_order_cart/"
            case .createCart:
                return "v2/order_carts/"
            case .getCartDetail(let request):
                return "v2/order_carts/\(request.cartID)/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .addToCart, .createCart:
                return .post
            case .getCurrentCartID, .getCartDetail:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .addToCart(let request):
                let params = request.convertToPostParams()
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .getCurrentCartID, .createCart:
                return .requestPlain
            case .getCartDetail(let request):
                let params = request.convertToQueryParams()
                return .requestParameters(
                    parameters: params,
                    encoding: CustomParameterEncoding.queryWithDuplicateKeys
                )
            }
        }

        var sampleData: Data {
            switch self {
            case .addToCart, .getCurrentCartID, .createCart, .getCartDetail:
                return Data()
            }
        }

        var headers: [String: String]? {
            return nil
        }
    }
}

extension CartAPIService {

    func addItemToCart(request: AddItemToCartRequestModel,
                       completion: @escaping (Error?) -> ()) {
        cartAPIProvider.request(.addToCart(request: request)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    let error = self.handleError(response: response)
                    completion(error)
                    return
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func getCurrentCartID(completion: @escaping (Int64?, Error?) -> ()) {
        cartAPIProvider.request(.getCurrentCartID) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    let error = self.handleError(response: response)
                    completion(nil, error)
                    return
                }
                guard let id = JSON(response.data)["id"].int64 else {
                    completion(nil, DefaultError.unknown)
                    return
                }
                completion(id, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func createCart(completion: @escaping (Int64?, Error?) -> ()) {
        cartAPIProvider.request(.createCart) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    let error = self.handleError(response: response)
                    completion(nil, error)
                    return
                }
                guard let id = JSON(response.data)["id"].int64 else {
                    completion(nil, DefaultError.unknown)
                    return
                }
                completion(id, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func fetchCart(request: FetchCartRequestModel,
                   completion: @escaping (Cart?, Error?) -> ()) {
        cartAPIProvider.request(.getCartDetail(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let cart = try response.map(Cart.self)
                    completion(cart, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}


