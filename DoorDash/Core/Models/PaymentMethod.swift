//
//  PaymentMethod.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-28.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import CoreData

public enum CardBrand: String {
    case unknown = "Unknown"
    case visa = "Visa"
    case masterCard = "MasterCard"
    case discover = "Discover"
    case americanExpress = "American Express"
    case JCB = "JCB"
    case dinersClub = "Diners Club"
}

extension CardBrand: Codable {
    public enum CodingKeys: String, CodingKey {
        case brand
    }
}

public struct PaymentMethod {
    public let id: Int64
    public let hasExistingCard: Bool
    public let lastFour: String
    public let expMonth: String?
    public let expYear: String?
    public let brand: CardBrand

    init(id: Int64,
         lastFour: String,
         expMonth: String?,
         expYear: String?,
         hasExistingCard: Bool,
         brand: CardBrand) {
        self.id = id
        self.hasExistingCard = hasExistingCard
        self.lastFour = lastFour
        self.expYear = expYear
        self.expMonth = expMonth
        self.brand = brand
    }
}

extension PaymentMethod: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case last4
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case hasExistingCard = "has_existing_card"
        case brand = "type"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let lastFour: String = try values.decode(String.self, forKey: .last4)
        let expMonth: String? = try values.decodeIfPresent(String.self, forKey: .expMonth)
        let expYear: String? = try values.decodeIfPresent(String.self, forKey: .expYear)
        let hasExistingCard: Bool = try values.decodeIfPresent(Bool.self, forKey: .hasExistingCard) ?? false
        let brand: CardBrand = try values.decode(CardBrand.self, forKey: .brand)
        self.init(id: id,
                  lastFour: lastFour,
                  expMonth: expMonth,
                  expYear: expYear,
                  hasExistingCard: hasExistingCard,
                  brand: brand)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lastFour, forKey: .last4)
        try container.encodeIfPresent(expMonth, forKey: .expMonth)
        try container.encodeIfPresent(expYear, forKey: .expYear)
        try container.encode(hasExistingCard, forKey: .hasExistingCard)
        try container.encode(brand, forKey: .brand)
    }
}

extension PaymentMethod: Equatable {}

public func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
    return lhs.id == rhs.id
}
