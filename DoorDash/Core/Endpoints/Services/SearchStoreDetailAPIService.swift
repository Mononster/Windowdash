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

    func convertToQueryParams() -> [String: Any] {
        var result: [String: Any] = [:]
//        result["extra"] = "stores.business_id"
//        result["limit"] = String(limit)
//        result["offset"] = String(offset)
//        if let sortOption = self.sortOption {
//            result["sort_options"] = "true"
//            result["order_type"] = sortOption.rawValue
//        }
//        if let query = self.query {
//            result["query"] = query
//            result["is_browse"] = "true"
//        }
//        if let curatedCateogryID = self.curatedCateogryID {
//            result["curated_category"] = curatedCateogryID
//            result["extra"] = "stores.is_consumer_subscription_eligible"
//        }
//        result["lat"] = String(latitude)
//        result["lng"] = String(longitude)
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

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .fetchStoreOverview(let request):
                return "v1/stores/\(request.storeID)/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .fetchStoreOverview:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .fetchStoreOverview(let request):
                let params = request.convertToQueryParams()
                //Task.req
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }

        var sampleData: Data {
            switch self {
            case .fetchStoreOverview:
                return Data()
            }
        }

        var headers: [String: String]? {
            return nil
        }
    }
}
