//
//  StoreItemDetailAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class SearchStoreItemAPIServiceError: DefaultError {

}

struct FetchStoreItemRequestModel {

    let storeID: String
    let itemID: String

    init(storeID: String, itemID: String) {
        self.storeID = storeID
        self.itemID = itemID
    }

    func convertToQueryParams() -> [String: [String]] {
        var result: [String: [String]] = [:]
        result["extra"] = [
            "price_monetary_fields",
            "price_monetary_fields.currency",
            "price_monetary_fields.decimal_places",
            "extras.options.price_monetary_fields.currency",
            "extras.options.price_monetary_fields.decimal_places",
            "special_instructions_max_length",
            "extras.options.extras",
            "menu_version",
            "image_url",
            "is_popular",
            "tags"
        ]
        result["expand"] = ["tags", "tags.group"]
        result["photo_resolution"] = ["high"]
        result["show_nested"] = ["true"]
        return result
    }
}

final class SearchStoreItemAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return DefaultError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let searchItemAPIProvider = MoyaProvider<SearchStoreItemAPITarget>(manager: SessionManager.authSession)

    enum SearchStoreItemAPITarget: TargetType {
        case fetchItem(request: FetchStoreItemRequestModel)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .fetchItem(let request):
                return "v1/stores/\(request.storeID)/items/\(request.itemID)/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .fetchItem:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .fetchItem(let request):
                let params = request.convertToQueryParams()
                return .requestParameters(
                    parameters: params,
                    encoding: CustomParameterEncoding.queryWithDuplicateKeys
                )
            }
        }

        var sampleData: Data {
            switch self {
            case .fetchItem:
                return Data()
            }
        }

        var headers: [String: String]? {
            return nil
        }
    }
}

extension SearchStoreItemAPIService {

    func fetchStoreOverview(request: FetchStoreItemRequestModel,
                            completion: @escaping (MenuItem?, Error?) -> ()) {
        searchItemAPIProvider.request(.fetchItem(request: request)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let item = try response.map(MenuItem.self)
                    completion(item, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

