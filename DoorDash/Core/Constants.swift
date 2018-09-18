//
//  APIConstants.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-04-15.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

enum Constants {

    public enum API {
        public enum Endpoint: String {
            case latest = "https://api-latest.doordash.com/"
            case production = "https://api.doordash.com/"
        }
    }

    enum GoogleMapsKey: String {
        case release = "AIzaSyCuMvN-uULAK0AGqUyfqwzAD78t5trETOo"
        case debug = "AIzaSyCuMvN-uULAK0AGqUyfqwzAD78t5trETOo1"
    }
}
