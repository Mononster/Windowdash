//
//  SessionManager+Extension.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import Alamofire

extension SessionManager {
    public static var authSession: SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ApplicationEnvironment.current.networkConfig.timeoutInterval
        let sessionManager = SessionManager(configuration: configuration)
        let authAdapter = AuthenticatedRequestAdapter()
        sessionManager.adapter = authAdapter
        configuration.httpShouldSetCookies = false
        return sessionManager
    }
}

