//
//  AuthenticateRequestAdapter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Alamofire

struct AuthenticatedRequestAdapter: RequestAdapter {

    static var excludedApiRequestsURL: Set<String> {
        return [
            "/v2/auth/token",
            "/v2/consumer/me"
        ]
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest

//        let uniqueVendorID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        request.addValue("\(uniqueVendorID)", forHTTPHeaderField: "X-Device-Token")
//        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
//        request.addValue("\(appVersion)", forHTTPHeaderField: "App-Version")
//
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("DoordashConsumer/3.0.90 (iPhone; iOS 11.4.1; Scale/3.00)", forHTTPHeaderField: "User-Agent")
        if let url = request.url, AuthenticatedRequestAdapter.excludedApiRequestsURL.contains(url.relativePath) {
            return request
        }

        guard let authToken = ApplicationEnvironment.current.authToken, !authToken.isEmpty else {
            return request
        }

        request.addValue("JWT \(authToken.tokenStr)", forHTTPHeaderField: "Authorization")
        return request
    }
}

