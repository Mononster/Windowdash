//
//  DoordashLocator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit
import SwiftLocation

private let shouldSimulateLocationKey = "com.Locator.ShouldSimulate"
private let simulatedLatitudeKey = "com.Locator.Simluated.Latitude"
private let simulatedLongitudeKey = "com.Locator.Simluated.Longitude"

// A wrapper for SwiftLocation so we can have more custom behaviors based on the library
final class DoordashLocator {

    var shouldUseSimulatedLocation: Bool = false
    var simulatedLocation: Location?
    var userLastLocation: Location?
    private var observerToken: UInt64?

    static let manager: DoordashLocator = DoordashLocator()

    private init() {
        let shouldSimulate = UserDefaults.standard.bool(forKey: shouldSimulateLocationKey)
        let storedLatitude = UserDefaults.standard.double(forKey: simulatedLatitudeKey)
        let storedLongitude = UserDefaults.standard.double(forKey: simulatedLongitudeKey)
        if shouldSimulate {
            shouldUseSimulatedLocation = true
            simulatedLocation = Location(latitude: storedLatitude, longitude: storedLongitude)
        }
    }

    func currentPosition(accuracy: Accuracy,
                         timeout: Timeout? = nil,
                         onSuccess: @escaping LocationRequest.Success,
                         onFail: @escaping LocationRequest.Failure) {
        if shouldUseSimulatedLocation, let simulatedLocation = simulatedLocation {
            onSuccess(CLLocation(latitude: simulatedLocation.latitude, longitude: simulatedLocation.longitude))
            return
        }
        Locator.currentPosition(accuracy: accuracy, onSuccess: { location in
            onSuccess(location)
            self.userLastLocation = Location.from(coordinate: location.coordinate)
        }, onFail: onFail)
    }

    func isLocationEnabled() -> Bool {
        return Locator.state == .available
    }

    func requestLocation() {
        Locator.requestAuthorizationIfNeeded()
    }

    func listenLocationAuthState(completion: @escaping (Bool) -> ()) {
        observerToken = Locator.events.listen { status in
            completion(status == .authorizedAlways || status == .authorizedWhenInUse)
        }
    }

    func removeLocationAuthObserver() {
        guard let token = observerToken else {
            return
        }
        Locator.events.remove(token: token)
    }
}

extension DoordashLocator {

    func setSimulatedLocation(_ location: Location) {
        shouldUseSimulatedLocation = true
        simulatedLocation = location
        saveSimulatedLocation(location)
    }

    func stopSimulatingLocation() {
        shouldUseSimulatedLocation = false
        simulatedLocation = nil
        saveSimulatedLocation(nil)
    }

    func saveSimulatedLocation(_ location: Location?) {
        if let location = location {
            UserDefaults.standard.set(location.latitude, forKey: simulatedLatitudeKey)
            UserDefaults.standard.set(location.longitude, forKey: simulatedLongitudeKey)
            UserDefaults.standard.set(true, forKey: shouldSimulateLocationKey)
        } else {
            UserDefaults.standard.set(0, forKey: simulatedLatitudeKey)
            UserDefaults.standard.set(0, forKey: simulatedLongitudeKey)
            UserDefaults.standard.set(false, forKey: shouldSimulateLocationKey)
        }
    }
}


