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

        var baseURL: URL {
            return URL(string: Constants.GooglePlaceAPI.autocomplete.rawValue)!
        }

        var path: String {
            switch self {
            case .predict:
                return "json"
            }
        }

        var method: Moya.Method {
            switch self {
            case .predict:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .predict(let input):
                var params: [String: Any] = [:]
                //?input=\(input)&sensor=true&key=\(key)&channel=consumer_ios&radius=100.000000&language=en"
                params["input"] = input
                params["sensor"] = "true"
                params["key"] = Constants.GooglePlaceKey.release.rawValue
                params["channel"] = "consumer_ios"
                params["radius"] = "100.000000"
                params["language"] = "en"
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }

        var sampleData: Data {
            switch self {
            case .predict:
                return Data()
            }
        }

        var headers: [String : String]? {
            return nil
        }
    }
}

extension GooglePlaceAPIService {
    /// Singup using email
    ///
    /// - Parameters:
    ///   - account: user current temp account
    ///   - password: password
    ///   - completion: Current User, Token, Error
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
}

