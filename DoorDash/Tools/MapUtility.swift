//
//  MapUtility.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

final class MapUtility {

    private let mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
    }

    func getCenterCoordinate() -> CLLocationCoordinate2D {
        return mapView.centerCoordinate
    }
}

