//
//  NetworkGlobalFunction.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Moya
import SwiftyJSON
import enum Result.Result
import Alamofire

public protocol NetworkResponseModel {
    static func from(_ data: JSON) throws -> Self
}

public func networkResponseHandler<T: NetworkResponseModel>(result: Result<Moya.Response, MoyaError>,
                                                            errorHandler: (Response) -> Error,
                                                            completion: @escaping (T?, Error?) -> ()) {
    switch result {
    case .success(let response):
        do {
            guard response.statusCode == 200,
                let dataJSON = try? JSON(data: response.data) else {
                    let error = errorHandler(response)
                    completion(nil, error)
                    return
            }
            let model = try T.from(dataJSON)
            completion(model, nil)
        } catch(let error) {
            completion(nil, error)
        }
    case .failure(let error):
        completion(nil, error)
    }
}
