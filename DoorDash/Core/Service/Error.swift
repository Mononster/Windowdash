//
//  Error.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ErrorDisplayable {
    var errorTitle: String { get }
    var errorMessage: String { get }
}

public protocol APIServiceError: Error, ErrorDisplayable {
    init(code: Int, responseBody: String?)
    var retriable: Bool { get }
    var status: String? { get }
}

extension APIServiceError {

}

open class DefaultError: APIServiceError {
    public enum ErrorKind {
        case badRequest
        case notAuthorized
        case forbidden
        case notFound
        case conflict
        case tooMany
        case unprocessable
        case serverError
        case unknown
    }

    public let kind: ErrorKind
    public let responseBodyString: String?

    public var errorTitle: String {
        switch kind {
        case .notAuthorized, .forbidden:
            return NSLocalizedString("api_error_403_title", comment: "")
        case .tooMany:
            return NSLocalizedString("api_error_429_title", comment: "")
        case .badRequest:
            if let responseBody = responseBodyString {
                let errorJson = JSON.init(parseJSON: responseBody)
                let title = errorJson["errors"][0]["title"].string
                return title ?? NSLocalizedString("error_title", comment: "")
            }
            return NSLocalizedString("error_title", comment: "")
        default:
            return NSLocalizedString("error_title", comment: "")
        }
    }

    public var errorMessage: String {
        switch kind {
        case .notAuthorized, .forbidden:
            return NSLocalizedString("api_error_403_message", comment: "")
        case .tooMany:
            return NSLocalizedString("api_error_429_message", comment: "")
        case .serverError:
            return NSLocalizedString("error_general_message", comment: "")
        case .badRequest:
            if let responseBody = responseBodyString {
                let errorJson = JSON.init(parseJSON: responseBody)
                let detail = errorJson["errors"][0]["detail"].string
                if let message = detail {
                    return message
                } else {
                    if isValidJSON(responseBody) {
                        return NSLocalizedString("error_general_message", comment: "")
                    }
                    return responseBody
                }
            }
            return NSLocalizedString("error_general_message", comment: "")
        default:
            guard let responseBody = responseBodyString else {
                return NSLocalizedString("error_general_message", comment: "")
            }
            if isValidJSON(responseBody) {
                return NSLocalizedString("error_general_message", comment: "")
            } else {
                return responseBody
            }
        }
    }

    public var status: String? {
        switch kind {
        case .badRequest:
            if let responseBody = responseBodyString {
                let errorJson = JSON.init(parseJSON: responseBody)
                let status = errorJson["errors"][0]["status"].string
                return status
            }
            return nil
        default:
            return nil
        }
    }

    public var retriable: Bool {
        switch kind {
        case .serverError:
            return true
        default:
            return false
        }
    }

    required public init(code: Int, responseBody: String? = nil) {
        responseBodyString = responseBody
        switch code {
        case 400:
            kind = .badRequest
        case 401:
            kind = .notAuthorized
        case 403:
            kind = .forbidden
        case 404:
            kind = .notFound
        case 409:
            kind = .conflict
        case 422:
            kind = .unprocessable
        case 429:
            kind = .tooMany
        case 500..<599:
            kind = .serverError
        default:
            kind = .unknown
        }
    }

    public static let unknown: DefaultError = DefaultError(code: 600)
    public static let notAuthorized: DefaultError = DefaultError(code: 401)

    public func isValidJSON(_ errorString: String) -> Bool {
        let jsonData = errorString.data(using: String.Encoding.utf8)
        return JSONSerialization.isValidJSONObject(jsonData as Any)
    }
}
