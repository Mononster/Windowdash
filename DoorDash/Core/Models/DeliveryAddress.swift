//
//  DeliveryAddress.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-11.
//  Copyright © 2018 Monster. All rights reserved.
//

/*
 "default_address": {
 "city": "San Francisco",
 "manual_lng": null,
 "district": {
 "shortname": "IRCH",
 "first_delivery_price": 0,
 "is_active": true,
 "id": 114,
 "name": "Inner Richmond"
 },
 "subpremise": "",
 "object_type": "consumer.address",
 "street": "750 7th Avenue",
 "id": 46648010,
 "timezone": "US/Pacific",
 "printable_address": "750 7th Ave, San Francisco, CA 94118, USA",
 "state": "CA",
 "shortname": "750 7th Ave",
 "submarket": "San Francisco",
 "lat": 37.7743771,
 "driver_instructions": "",
 "lng": -122.4646919,
 "submarket_id": 6,
 "manual_lat": null,
 "market": "Northern California",
 "zip_code": "94118"
 },
 */

import SwiftyJSON
import CoreLocation

public struct District: Codable {

    public enum DistrictCodingKeys: String, CodingKey {
        case id
        case shortName = "shortname"
        case name
        case isActive = "is_active"
        case firstDeliveryPrice = "first_delivery_price"
    }

    public let shortName: String
    public let name: String
    public let id: Int64
    public let isActive: Bool
    public let firstDeliveryPrice: Double

    init(shortName: String,
         name: String,
         id: Int64,
         isActive: Bool,
         firstDeliveryPrice: Double) {
        self.shortName = shortName
        self.name = name
        self.id = id
        self.isActive = isActive
        self.firstDeliveryPrice = firstDeliveryPrice
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DistrictCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let shortName: String = try values.decode(String.self, forKey: .shortName)
        let name: String = try values.decode(String.self, forKey: .name)
        let isActive: Bool = try values.decode(Bool.self, forKey: .isActive)
        let firstDeliveryPrice: Double = (try? values.decode(Double.self, forKey: .firstDeliveryPrice)) ?? 0
        self.init(shortName: shortName,
                  name: name,
                  id: id,
                  isActive: isActive,
                  firstDeliveryPrice: firstDeliveryPrice)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DistrictCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(shortName, forKey: .shortName)
        try container.encode(name, forKey: .name)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(firstDeliveryPrice, forKey: .firstDeliveryPrice)
    }
}

public struct DeliveryAddress {

    public enum DeliveryAddressCodingKeys: String, CodingKey {
        case city
        case id
        case timezone
        case state
        case shortName = "shortname"
        case latitude = "lat"
        case longitude = "lng"
        case driverInstructions = "driver_instructions"
        case zipCode = "zip_code"
        case printableAddress = "printable_address"
        case district
    }

    public let city: String
    public let id: Int64
    public let timezone: String
    public let state: String
    public let shortName: String
    public let latitude: CLLocationDegrees
    public let longitude: CLLocationDegrees
    public let driverInstructions: String
    public let zipCode: String
    public let printableAddress: String
    public let district: District?

    public init(city: String,
                id: Int64,
                timezone: String,
                state: String,
                shortName: String,
                latitude: CLLocationDegrees,
                longitude: CLLocationDegrees,
                driverInstructions: String,
                zipCode: String,
                printableAddress: String,
                district: District?) {
        self.city = city
        self.id = id
        self.timezone = timezone
        self.state = state
        self.shortName = shortName
        self.latitude = latitude
        self.longitude = longitude
        self.driverInstructions = driverInstructions
        self.zipCode = zipCode
        self.printableAddress = printableAddress
        self.district = district
    }
}

extension DeliveryAddress: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DeliveryAddressCodingKeys.self)
        let city: String = try values.decode(String.self, forKey: .city)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let timezone: String = try values.decode(String.self, forKey: .timezone)
        let state: String = try values.decode(String.self, forKey: .state)
        let shortName: String = try values.decode(String.self, forKey: .shortName)
        let latitudeDouble: Double = (try? values.decode(Double.self, forKey: .latitude)) ?? 0
        let longitudeDouble: Double = (try? values.decode(Double.self, forKey: .longitude)) ?? 0
        let latitude: CLLocationDegrees = CLLocationDegrees(latitudeDouble)
        let longitude: CLLocationDegrees = CLLocationDegrees(longitudeDouble)
        let driverInstructions: String = (try? values.decode(String.self, forKey: .id)) ?? ""
        let printableAddress: String = (try? values.decode(String.self, forKey: .printableAddress)) ?? ""
        let zipCode: String = try values.decode(String.self, forKey: .zipCode)
        let district: District? = try? values.decode(District.self, forKey: .district)
        self.init(city: city,
                  id: id,
                  timezone: timezone,
                  state: state,
                  shortName: shortName,
                  latitude: latitude,
                  longitude: longitude,
                  driverInstructions: driverInstructions,
                  zipCode: zipCode,
                  printableAddress: printableAddress,
                  district: district)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DeliveryAddressCodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(id, forKey: .id)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(state, forKey: .state)
        try container.encode(shortName, forKey: .shortName)
        try container.encode(Double(latitude), forKey: .latitude)
        try container.encode(Double(longitude), forKey: .latitude)
        try container.encode(driverInstructions, forKey: .driverInstructions)
        try container.encode(zipCode, forKey: .zipCode)
        try container.encode(printableAddress, forKey: .printableAddress)
        try container.encodeIfPresent(district, forKey: .district)
    }
}

extension DeliveryAddress: Equatable { }

public func == (lhs: DeliveryAddress, rhs: DeliveryAddress) -> Bool {
    return lhs.id == rhs.id
}


