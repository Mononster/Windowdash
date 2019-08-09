//
//  Location.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

public typealias Meter = CLLocationDistance

public struct Location {
    public typealias Distance = (Location) -> Bool

    public static let origin = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
    public let horizontalAccuracy: CLLocationAccuracy

    public var displayText: String {
        return String(latitude) + ", " + String(longitude)
    }

    public init(latitude: CLLocationDegrees,
                longitude: CLLocationDegrees,
                horizontalAccuracy: CLLocationAccuracy? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.horizontalAccuracy = horizontalAccuracy ?? 0.0
    }

    public var isValid: Bool {
        return latitude > -85 && latitude < 85
    }

    public static func from(coordinate: CLLocationCoordinate2D) -> Location {
        return Location(latitude: coordinate.latitude,
                        longitude: coordinate.longitude)
    }

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    public func location(_ location: Location, didChangeMoreThanRange range: Double) -> Bool {
        let coreLocation1 = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let coreLocation2 = CLLocation(latitude: latitude, longitude: longitude)
        return coreLocation2.distance(from: coreLocation1) > range
    }

    public func `in`(range: Double) -> Distance {
        return { location2 in
            let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
            let other = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
            return selfLocation.distance(from: other) < range
        }
    }

    public func distance(from location: Location) -> Meter {
        let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let other = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return selfLocation.distance(from: other)
    }
}

extension Location: Codable {
    private enum AttributeKeys: String, CodingKey {
        case lng
        case longitude
        case lat
        case latitude
        case horizontalAccuracy
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AttributeKeys.self)

        guard let longitude =
            try container.decodeIfPresent(CLLocationDegrees.self, forKey: .lng)
                ?? container.decodeIfPresent(CLLocationDegrees.self, forKey: .longitude),
            let latitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .lat)
                ?? container.decodeIfPresent(CLLocationDegrees.self, forKey: .latitude) else {
                    let decodingErrorContext = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "No lat or lng found")
                    throw DecodingError.valueNotFound(Double.self, decodingErrorContext)
        }

        let horizontalAccuracy = try container.decodeIfPresent(CLLocationAccuracy.self, forKey: .latitude)

        self.init(latitude: latitude,
                  longitude: longitude,
                  horizontalAccuracy: horizontalAccuracy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AttributeKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(horizontalAccuracy, forKey: .horizontalAccuracy)
    }
}

extension Location: Hashable {

    public func hash(into hasher: inout Hasher) {
        let prec: Double = 100
        let value = Int(latitude * prec * prec * 100 + longitude * prec)
        value.hash(into: &hasher)
    }
}

extension Location: Equatable {}

public func == (lhs: Location, rhs: Location) -> Bool {
    let epsilon = 0.000005
    return abs(lhs.latitude - rhs.latitude) < epsilon && abs(lhs.longitude - rhs.longitude) < epsilon
}
