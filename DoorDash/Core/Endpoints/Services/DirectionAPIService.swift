//
//  DirectionAPIService.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

struct Direction {
    let steps: [Location]
    let travelTime: TimeInterval
    let travelDistance: Meter
}

final class DirectionAPIService {

    func calculateDirection(from startPoint: Location,
                            to endPoint: Location,
                            completion: @escaping (Direction?) -> Void) {
        let directionRequest = MKDirections.Request()
        directionRequest.transportType = .walking
        let startItem = self.mapItem(from: startPoint)
        let endItem = self.mapItem(from: endPoint)
        directionRequest.source = startItem
        directionRequest.destination = endItem
        let directions = MKDirections(request: directionRequest)
        directions.calculate { maybeResponse, error in
            guard error == nil else {
                log.error(error)
                return
            }
            guard let response = maybeResponse, let route = response.routes.first else {
                return
            }
            let steps = route.steps.map { step in
                return Location.from(coordinate: step.polyline.coordinate)
            }
            let direction = Direction(steps: steps, travelTime: route.expectedTravelTime, travelDistance: route.distance)
            completion(direction)
        }
    }

    private func mapItem(from location: Location) -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: location.coordinate)
        let item = MKMapItem(placemark: placeMark)
        return item
    }
}

