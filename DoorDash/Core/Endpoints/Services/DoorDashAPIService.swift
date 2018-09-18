//
//  DoorDashAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Alamofire
import Moya

public protocol DoorDashAPIService {
    typealias HTTPURLResponseErrorConverter = (HTTPURLResponse, String?) -> Error
    var error: HTTPURLResponseErrorConverter { get }
    var retryPredicate: RetryPredicate? { get }
}

extension DoorDashAPIService {
    public var retryPredicate: RetryPredicate? {
        return { error in
            guard let serviceError = error as? APIServiceError else {
                return false
            }
            return serviceError.retriable
        }
    }

    public func handleError(response: Response) -> Error {
        if let urlResponse = response.response {
            return self.error(urlResponse, String(data: response.data, encoding: String.Encoding.utf8))
        } else {
            return NSError(domain: "", code: response.statusCode, userInfo: nil)
        }
    }
}
