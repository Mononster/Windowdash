//
//  GooglePlaceAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//


import Moya
import SwiftyJSON
import Alamofire

final public class GooglePlaceAPIServiceError: DefaultError {

}

class GooglePlaceAPIService: DoorDashAPIService {

    var error: DoorDashAPIService.HTTPURLResponseErrorConverter {
        return { response, responseBody in
            return UserAPIError(code: response.statusCode, responseBody: responseBody)
        }
    }

    let googlePlaceAPIProvider = MoyaProvider<GooglePlaceAPITarget>()

    enum GooglePlaceAPITarget: TargetType {
        case predict(input: String)
        case fetchDetail(referenceID: String)

        var baseURL: URL {
            return URL(string: Constants.GooglePlaceAPI.base.rawValue)!
        }

        var path: String {
            switch self {
            case .predict:
                return "autocomplete/json"
            case .fetchDetail:
                return "details/json"
            }
        }

        var method: Moya.Method {
            switch self {
            case .predict, .fetchDetail:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .predict(let input):
                var params: [String: Any] = [:]
                params["input"] = input
                params["sensor"] = "true"
                params["key"] = Constants.GooglePlaceKey.release.rawValue
                params["channel"] = "consumer_ios"
                params["radius"] = "100.000000"
                params["language"] = "en"
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            case .fetchDetail(let referenceID):
                var params: [String: Any] = [:]
                params["reference"] = referenceID
                params["sensor"] = "true"
                params["key"] = Constants.GooglePlaceKey.release.rawValue
                params["language"] = "en"
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }

        var sampleData: Data {
            switch self {
            case .predict, .fetchDetail:
                return Data()
            }
        }

        var headers: [String : String]? {
            return nil
        }
    }
}

extension GooglePlaceAPIService {
    func fetchPredictions(input: String,
                          completion: @escaping ([GMPrediction]) -> ()) -> Cancellable {
        return googlePlaceAPIProvider.request(.predict(input: input)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200,
                    let dataJSON = JSON(response.data)["predictions"].array else {
                    let error = self.handleError(response: response)
                    print(error)
                    completion([])
                    return
                }
                var predictions: [GMPrediction] = []
                for json in dataJSON {
                    if let prediction = try? JSONDecoder().decode(GMPrediction.self, from: json.rawData()) {
                        predictions.append(prediction)
                    }
                }
                completion(predictions)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }

    func fetchDetailPlace(referenceID: String,
                          completion: @escaping (GMDetailLocation?) -> ()) {
        googlePlaceAPIProvider.request(.fetchDetail(referenceID: referenceID)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    let error = self.handleError(response: response)
                    print(error)
                    completion(nil)
                    return
                }
                let dataJSON = JSON(response.data)["result"]
                let location = try? JSONDecoder().decode(GMDetailLocation.self, from: dataJSON.rawData())
                completion(location)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}

