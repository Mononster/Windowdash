//
//  AuthenticateRequestAdapter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Alamofire

struct AuthenticatedRequestAdapter: RequestAdapter {

    private static var excludedApiRequestsURL: Set<String> {
        return []
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest

//        let uniqueVendorID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        request.addValue("\(uniqueVendorID)", forHTTPHeaderField: "X-Device-Token")
//        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
//        request.addValue("\(appVersion)", forHTTPHeaderField: "App-Version")
//
//        if let url = request.url, AuthenticatedRequestAdapter.excludedApiRequestsURL.contains(url.relativePath) {
//            return request
//        }
//        guard let authToken = ApplicationEnvironment.current.authToken, !authToken.isEmpty else {
//            return request
//        }
//
//        request.addValue("Bearer \(authToken.tokenStr)", forHTTPHeaderField: "Authorization")
        return request
    }
}

