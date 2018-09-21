//
//  GMPrediction.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class QueriedAddresses: NSObject, ListDiffable {

    let predictions: [GMPrediction]
    init(predictions: [GMPrediction]) {
        self.predictions = predictions
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class GMPrediction: NSObject, Codable {

    public enum GMPredictionCodingKeys: String, CodingKey {
        case address = "description"
        case referenceID = "reference"
    }

    let address: String
    let referenceID: String?

    init(address: String,
         referenceID: String?) {
        self.address = address
        self.referenceID = referenceID
    }

    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GMPredictionCodingKeys.self)
        let address: String = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        let referenceID: String? = try values.decodeIfPresent(String.self, forKey: .referenceID)
        self.init(address: address, referenceID: referenceID)
    }
}

final class GMDetailLocation: NSObject, Codable {

    private enum GMDetailLocationCodingKeys: String, CodingKey {
        case address = "formatted_address"
        case placeID = "place_id"
        case geometry = "geometry"
    }

    private enum GeometryKeys: String, CodingKey {
        case location = "location"
    }

    private enum LocationKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }

    let address: String
    let placeID: String
    var latitude: Double?
    var longitude: Double?

    init(address: String,
         placeID: String,
         latitude: Double?,
         longitude: Double?) {
        self.address = address
        self.placeID = placeID
        self.latitude = latitude
        self.longitude = longitude
    }

    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GMDetailLocationCodingKeys.self)
        let address: String = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        let placeID: String = try values.decode(String.self, forKey: .placeID)
        let geometryContainer = try? values.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        let locationContainer = try? geometryContainer?.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        let lat: Double? = try locationContainer??.decodeIfPresent(Double.self, forKey: .latitude)
        let lng: Double? = try locationContainer??.decodeIfPresent(Double.self, forKey: .longitude)
        self.init(address: address, placeID: placeID, latitude: lat, longitude: lng)
    }
}
