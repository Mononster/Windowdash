//
//  SearchStoreDetailAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 9/28/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class SearchStoreDetailAPIServiceError: DefaultError {

}

struct FetchStoreOverviewRequestModel {

    let storeID: String

    init(storeID: String) {
        self.storeID = storeID
    }

    func convertToQueryParams() -> [String: [String]] {
        var result: [String: [String]] = [:]
        result["extra"] = ["business", "business.tags", "service_rate", "description", "status", "is_newly_added", "delivery_fee_monetary_fields", "sos_delivery_fee", "num_ratings", "average_rating", "merchant_promotions", "is_good_for_group_orders", "offers_pickup", "offers_delivery", "asap_time", "distance_from_consumer", "is_good_for_group_orders", "is_consumer_subscription_eligible", "price_range", "store_disclaimers"
        ]
        result["consumer"] = ["me"]
        result["expand"] = ["business.tags"]
        return result
    }
}

enum FetchStoreMenuRequestType {
    case shortVersion
    case fullVersion
}

struct FetchStoreMenuRequestModel {

    let storeID: String
    let type: FetchStoreMenuRequestType

    init(storeID: String, type: FetchStoreMenuRequestType) {
        self.storeID = storeID
        self.type = type
    }

    //https://api.doordash.com/v1/stores/7249/menus/?
    func convertToQueryParams() -> [String: [String]] {
        var result: [String: [String]] = [:]
        result["extra"] = ["categories", "featured_items", "featured_items.image_url", "popular_items", "popular_items.image_url", "weekly_hours", "categories.num_items", "sells_alcohol", "num_items", "num_product_codes", "categories.items.image_url", "categories.items"]
        result["expand"] = ["categories"]
        if type == .fullVersion {
            result["show_nested"] = ["true"]
        } else {
            result["current"] = ["true"]
        }
        return result
    }
}

final class SearchStoreDetailAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return DefaultError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let searchStoreAPIProvider = MoyaProvider<SearchStoreAPITarget>(manager: SessionManager.authSession)

    enum SearchStoreAPITarget: TargetType {
        case fetchStoreOverview(request: FetchStoreOverviewRequestModel)
        case fetchStoreMenus(request: FetchStoreMenuRequestModel)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .fetchStoreOverview(let request):
                return "v1/stores/\(request.storeID)/"
            case .fetchStoreMenus(let request):
                return "v1/stores/\(request.storeID)/menus/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .fetchStoreOverview, .fetchStoreMenus:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .fetchStoreOverview(let request):
                let params = request.convertToQueryParams()
                return .requestParameters(
                    parameters: params,
                    encoding: CustomParameterEncoding.queryWithDuplicateKeys
                )
            case .fetchStoreMenus(let request):
                let params = request.convertToQueryParams()
                return .requestParameters(
                    parameters: params,
                    encoding: CustomParameterEncoding.queryWithDuplicateKeys
                )
            }
        }

        var sampleData: Data {
            switch self {
            case .fetchStoreOverview, .fetchStoreMenus:
                return Data()
            }
        }

        var headers: [String: String]? {
            return nil
        }
    }
}

extension SearchStoreDetailAPIService {

    func fetchStoreOverview(request: FetchStoreOverviewRequestModel,
                            completion: @escaping (Store?, Error?) -> ()) {
        searchStoreAPIProvider.request(.fetchStoreOverview(request: request)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let store = try response.map(Store.self)
                    completion(store, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func fetchStoreMenu(request: FetchStoreMenuRequestModel,
                        completion: @escaping ([StoreMenu], Error?) -> ()) {
        searchStoreAPIProvider.request(.fetchStoreMenus(request: request)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion([], error)
                        return
                    }
                    let menus = try response.map([StoreMenu].self)
                    completion(menus, nil)
                } catch {
                    completion([], error)
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }
}
