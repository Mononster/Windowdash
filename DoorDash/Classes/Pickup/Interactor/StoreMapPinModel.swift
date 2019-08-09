//
//  StoreMapPinModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

final class StoreMapPinModel: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    var title: String?

    let model: StoreViewModel

    init(coordinate: CLLocationCoordinate2D, title: String?, model: StoreViewModel) {
        self.coordinate = coordinate
        self.title = title
        self.model = model
    }
}
