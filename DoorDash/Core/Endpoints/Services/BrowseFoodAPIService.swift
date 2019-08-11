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

final class StoreFilterRequestModel {

    let values: [String: Any]

    init(values: [String: Any]) {
        self.values = values
    }

    func toEncodedURLParam() -> String {
        let jsonString = JSON(values).rawString(options: []) ?? ""
        return jsonString
    }
}

final class FetchAllStoresRequestModel {
    let limit: Int
    let offset: Int
    let latitude: Double
    let longitude: Double
    let sortOption: BrowseFoodSortOptionType?
    let query: String?
    let curatedCateogryID: String?

    var filters: [StoreFilterRequestModel] = []

    init(limit: Int = 50,
         offset: Int,
         latitude: Double,
         longitude: Double,
         sortOption: BrowseFoodSortOptionType?,
         query: String? = nil,
         curatedCateogryID: String? = nil,
         filters: [StoreFilterRequestModel] = []) {
        self.limit = limit
        self.offset = offset
        self.latitude = latitude
        self.longitude = longitude
        self.sortOption = sortOption
        self.query = query
        self.curatedCateogryID = curatedCateogryID
        self.filters = filters
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
        if !filters.isEmpty {
            result["filter"] = filters.map { $0.toEncodedURLParam() }
        }
        return result
    }
}

final class FetchAllStoresResponseModel {
    let nextOffset: Int?
    let numStores: Int
    let isFiltered: Bool
    let stores: [Store]

    init(nextOffset: Int?, numStores: Int, isFiltered: Bool, stores: [Store]) {
        self.nextOffset = nextOffset
        self.numStores = numStores
        self.isFiltered = isFiltered
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
        case filterStoreSearch(request: FetchAllStoresRequestModel)
        case fetchFilters(latitude: Double, longitude: Double)

        var baseURL: URL {
            return ApplicationEnvironment.current.networkConfig.hostURL
        }

        var path: String {
            switch self {
            case .fetchAllStores:
                return "v2/store_search/"
            case .fetchFrontEndLayout:
                return "v2/frontend_layouts/consumer_homepage/"
            case .filterStoreSearch:
                return "v1/store_feed/"
            case .fetchFilters:
                return "v1/consumer_search_filters/"
            }
        }

        var method: Moya.Method {
            switch self {
            case .fetchAllStores, .fetchFrontEndLayout, .filterStoreSearch,
                 .fetchFilters:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .fetchAllStores(let model):
                let params = model.convertToQueryParams()
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            case .filterStoreSearch(let model):
                let params = model.convertToQueryParams()
                return .requestParameters(parameters: params, encoding: CustomParameterEncoding.queryWithDuplicateKeys)
            case .fetchFrontEndLayout(let latitude, let longitude):
                var params: [String: Any] = [:]
                params["lat"] = String(latitude)
                params["lng"] = String(longitude)
                params["show_nested"] = String(true)
                params["display_limits"] = 7
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            case .fetchFilters(let latitude, let longitude):
                var params: [String: Any] = [:]
                params["lat"] = String(latitude)
                params["lng"] = String(longitude)
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }

        var sampleData: Data {
            switch self {
            case .fetchAllStores, .fetchFrontEndLayout, .filterStoreSearch,
                 .fetchFilters:
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
                        isFiltered: Bool,
                        completion: @escaping (FetchAllStoresResponseModel?, Error?) -> ()) {
        browseFoodAPIProvider.request(.filterStoreSearch(request: request)) { (result) in
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
                let numStores = dataJSON["num_results"].int
                var stores: [Store] = []
                for storeJSON in storesArray {
                    if let store = try? JSONDecoder().decode(
                        Store.self, from: storeJSON.rawData()) {
                        stores.append(store)
                    }
                }
                let model = FetchAllStoresResponseModel(
                    nextOffset: nextOffset,
                    numStores: numStores ?? 0,
                    isFiltered: isFiltered,
                    stores: stores
                )
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

extension BrowseFoodAPIService {

    func fetchFilterOptions(userLat: Double,
                            userLng: Double,
                            completion: @escaping (ConsumerSearchFilter?, Error?) -> ()) {
        browseFoodAPIProvider.request(.fetchFilters(latitude: userLat, longitude: userLng)) { (result) in
            switch result {
            case .success(let response):
                do {
                    guard response.statusCode == 200 else {
                        let error = self.handleError(response: response)
                        completion(nil, error)
                        return
                    }
                    let consumerFilter = try response.map(ConsumerSearchFilter.self)
                    completion(consumerFilter, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
