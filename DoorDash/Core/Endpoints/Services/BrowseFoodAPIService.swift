//
//  BrowseFoodAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import Alamofire

final public class BrowseFoodAPIServiceError: DefaultError {
    public static let noMoreStores: DefaultError = DefaultError(code: 400)
}

final class FetchAllStoresRequestModel {
    let limit: Int
    let offset: Int
    let latitude: Double
    let longitude: Double
    let sortOption: BrowseFoodSortOptionType?
    let query: String?
    let curatedCateogryID: String?

    init(limit: Int = 50,
         offset: Int,
         latitude: Double,
         longitude: Double,
         sortOption: BrowseFoodSortOptionType?,
         query: String? = nil,
         curatedCateogryID: String? = nil) {
        self.limit = limit
        self.offset = offset
        self.latitude = latitude
        self.longitude = longitude
        self.sortOption = sortOption
        self.query = query
        self.curatedCateogryID = curatedCateogryID
    }

    func convertToQueryParams() -> [String: Any] {
        var result: [String: Any] = [:]
        result["extra"] = "stores.business_id"
        result["limit"] = String(limit)
        result["offset"] = String(offset)
        if let sortOption = self.sortOption {
            result["sort_options"] = "true"
            result["order_type"] = sortOption.rawValue
        }
        if let query = self.query {
            result["query"] = query
            result["is_browse"] = "true"
        }
        if let curatedCateogryID = self.curatedCateogryID {
            result["curated_category"] = curatedCateogryID
            result["extra"] = "stores.is_consumer_subscription_eligible"
        }
        result["lat"] = String(latitude)
        result["lng"] = String(longitude)
        return result
    }
}

final class FetchAllStoresResponseModel {
    let nextOffset: Int?
    let stores: [Store]

    init(nextOffset: Int?, stores: [Store]) {
        self.nextOffset = nextOffset
        self.stores = stores
    }
}

final class BrowseFoodAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return UserAPIError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let browseFoodAPIProvider = MoyaProvider<BrowseFoodAPITarget>(manager: SessionManager.authSession)

    enum BrowseFoodAPITarget: TargetType {
        case fetchFrontEndLayout(latitude: Double, longitude: Double)
        case fetchAllStores(request: FetchAllStoresRequestModel)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .fetchAllStores:
                return "v2/store_search/"
            case .fetchFrontEndLayout:
                return "v1/frontend_layouts/consumer_homepage/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .fetchAllStores, .fetchFrontEndLayout:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .fetchAllStores(let model):
                let params = model.convertToQueryParams()
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            case .fetchFrontEndLayout(let latitude, let longitude):
                var params: [String: Any] = [:]
                params["lat"] = String(latitude)
                params["lng"] = String(longitude)
                params["show_nested"] = String(true)
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }

        var sampleData: Data {
            switch self {
            case .fetchAllStores, .fetchFrontEndLayout:
                return Data()
            }
        }

        var headers: [String: String]? {
            return nil
        }
    }
}

extension BrowseFoodAPIService {
    func fetchAllStores(request: FetchAllStoresRequestModel,
                        completion: @escaping (FetchAllStoresResponseModel?, Error?) -> ()) {
        browseFoodAPIProvider.request(.fetchAllStores(request: request)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200,
                    let dataJSON = try? JSON(data: response.data) else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                }
                guard let storesArray = dataJSON["stores"].array, storesArray.count > 0 else {
                    completion(nil, BrowseFoodAPIServiceError.unknown)
                    return
                }
                let nextOffset = dataJSON["next_offset"].int
                var stores: [Store] = []
                for storeJSON in storesArray {
                    if let store = try? JSONDecoder().decode(
                        Store.self, from: storeJSON.rawData()) {
                        stores.append(store)
                    }
                }
                let model = FetchAllStoresResponseModel(nextOffset: nextOffset, stores: stores)
                completion(model, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func fetchPageLayout(userLat: Double,
                         userLng: Double,
                         completion: @escaping (BrowseFoodMainView?, Error?) -> ()) {
        browseFoodAPIProvider.request(.fetchFrontEndLayout(latitude: userLat, longitude: userLng)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200,
                    let dataJSON = try? JSON(data: response.data) else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                }
                guard let jsonArray = dataJSON.array, jsonArray.count > 0 else {
                    print("No data? WTF?")
                    completion(nil, DefaultError.unknown)
                    return
                }
                let mainView = self.parsePageLayout(jsonArray: jsonArray)
                completion(mainView, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func parsePageLayout(jsonArray: [JSON]) -> BrowseFoodMainView {
        var cuisineCategories: [BrowseFoodCuisineCategory] = []
        var storeSecitons: [BrowseFoodSectionStore] = []
        for json in jsonArray {
            guard let type = BrowseFoodMainViewSectionType(
                rawValue: json["name"].string ?? "") else {
                    continue
            }
            let dataJSON = json["data"]
            if type == .cuisineCarousel, let categoryJSONs = dataJSON["categories"].array {
                for categoryJSON in categoryJSONs {
                    if let cusineCategory = try? JSONDecoder().decode(
                        BrowseFoodCuisineCategory.self, from: categoryJSON.rawData()
                        ) {
                        cuisineCategories.append(cusineCategory)
                    }
                }
                continue
            }
            if let storeJSONs = dataJSON["stores"].array,
                let title = dataJSON["title"].string,
                let id = dataJSON["id"].int {
                var stores: [Store] = []
                for storeJSON in storeJSONs {
                    do {
                        let store = try JSONDecoder().decode(Store.self, from: storeJSON.rawData())
                        stores.append(store)
                    } catch let error {
                        print(error)
                        continue
                    }
                }
                let subTitle = dataJSON["description"].string
                storeSecitons.append(
                    BrowseFoodSectionStore(
                        id: String(id),
                        title: title,
                        subTitle: subTitle,
                        type: type,
                        stores: stores.map { store in
                            StoreViewModel(store: store)
                        }
                    )
                )
            }
        }
        let mainView = BrowseFoodMainView(
            cuisineCategories: cuisineCategories, storeSections: storeSecitons
        )
        return mainView
    }
}


