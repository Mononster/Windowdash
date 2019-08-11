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

    struct AddressInfo: Codable {

        enum AddressInfoCodingKeys: String, CodingKey {
            case mainText = "main_text"
            case secondaryText = "secondary_text"
        }
        let mainText: String
        let secondaryText: String

        init(mainText: String, secondaryText: String) {
            self.mainText = mainText
            self.secondaryText = secondaryText
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: AddressInfoCodingKeys.self)
            let mainText: String = try values.decodeIfPresent(String.self, forKey: .mainText) ?? ""
            let secondaryText: String = try values.decodeIfPresent(String.self, forKey: .secondaryText) ?? ""
            self.init(mainText: mainText, secondaryText: secondaryText)
        }

        func encode(to encoder: Encoder) throws {}
    }

    public enum GMPredictionCodingKeys: String, CodingKey {
        case address = "description"
        case addressInfo = "structured_formatting"
        case referenceID = "reference"
    }

    let address: String
    let addressInfo: AddressInfo
    let referenceID: String?

    init(address: String,
         addressInfo: AddressInfo,
         referenceID: String?) {
        self.address = address
        self.addressInfo = addressInfo
        self.referenceID = referenceID
    }

    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GMPredictionCodingKeys.self)
        let address: String = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        let addressInfo: AddressInfo = try values.decode(AddressInfo.self, forKey: .addressInfo)
        let referenceID: String? = try values.decodeIfPresent(String.self, forKey: .referenceID)
        self.init(address: address, addressInfo: addressInfo, referenceID: referenceID)
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
    var dasherInstructions: String?
    var apartmentNumber: String?

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
