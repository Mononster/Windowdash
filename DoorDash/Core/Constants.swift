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

    public enum GooglePlaceAPI: String {
        case autocomplete = "https://maps.googleapis.com/maps/api/place/autocomplete/"
    }

    enum GoogleMapsKey: String {
        case release = "AIzaSyCuMvN-uULAK0AGqUyfqwzAD78t5trETOo"
        case debug = "AIzaSyCuMvN-uULAK0AGqUyfqwzAD78t5trETOo1"
    }

    enum GooglePlaceKey: String {
        case release = "AIzaSyCD6SNm_AZKTI1fbQW2jdzcQQvHJ8bmNj4"
        case debug = "TODO"
    }
}
