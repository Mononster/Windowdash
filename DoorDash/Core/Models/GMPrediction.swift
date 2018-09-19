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
