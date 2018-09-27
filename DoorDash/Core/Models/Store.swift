//
//  Store.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwiftDate

public struct Store {

    public struct Menu: Codable {

        public enum MenuCodingKeys: String, CodingKey {
            case popularItems = "popular_items"
        }

        public let items: [PopularItem]?

        public struct PopularItem: Codable {

            public enum PopularItemKeys: String, CodingKey {
                case imageURL = "img_url"
            }

            public let url: String?

            public init(url: String?) {
                self.url = url
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: PopularItemKeys.self)
                let urlString: String? = try values.decodeIfPresent(String.self, forKey: .imageURL)
                self.init(url: urlString)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: PopularItemKeys.self)
                try container.encode(url, forKey: .imageURL)
            }
        }

        public init(items: [PopularItem]?) {
            self.items = items
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: MenuCodingKeys.self)
            let items: [PopularItem]? = try values.decodeIfPresent([PopularItem].self, forKey: .popularItems)
            self.init(items: items)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: MenuCodingKeys.self)
            try container.encode(items, forKey: .popularItems)
        }
    }
    public enum StoreCodingKeys: String, CodingKey {
        case id
        case numRatings = "num_ratings"
        case averageRating = "average_rating"
        case storeDescription = "description"
        case priceRange = "price_range"
        case name
        case nextCloseTime = "next_close_time"
        case nextOpenTime = "next_open_time"
        case headerImageURL = "header_img_url"
        case menus = "menus"
    }

    public let id: Int64
    public let numRatings: Int64
    public let averageRating: Double
    public let storeDescription: String
    public let priceRange: Int64
    public let name: String
    public let nextCloseTime: Date
    public let nextOpenTime: Date
    public let headerImageURL: String?
    public let menus: [Menu]?

    public init(id: Int64,
                numRatings: Int64,
                averageRating: Double,
                storeDescription: String,
                priceRange: Int64,
                name: String,
                nextCloseTime: Date,
                nextOpenTime: Date,
                headerImageURL: String?,
                menus: [Menu]?) {
        self.id = id
        self.numRatings = numRatings
        self.averageRating = averageRating
        self.storeDescription = storeDescription
        self.priceRange = priceRange
        self.name = name
        self.nextCloseTime = nextCloseTime
        self.nextOpenTime = nextOpenTime
        self.headerImageURL = headerImageURL
        self.menus = menus
    }
}

extension Store: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: StoreCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let numRatings: Int64 = try values.decodeIfPresent(Int64.self, forKey: .numRatings) ?? 0
        let averageRating: Double = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? -1
        let storeDescription: String = try values.decodeIfPresent(String.self, forKey: .storeDescription) ?? ""
        let priceRange: Int64 = try values.decodeIfPresent(Int64.self, forKey: .priceRange) ?? 0
        let name: String = try values.decode(String.self, forKey: .name)
        let nextCloseTimeRaw: String = try values.decodeIfPresent(String.self, forKey: .nextCloseTime) ?? ""
        let nextCloseTime = nextCloseTimeRaw.toISODate()?.date ?? Date()
        let nextOpenTimeRaw: String = try values.decodeIfPresent(String.self, forKey: .nextOpenTime) ?? ""
        let nextOpenTime = nextOpenTimeRaw.toISODate()?.date ?? Date()
        let headerImageURL: String? = try values.decodeIfPresent(String.self, forKey: .headerImageURL)
        let menus: [Store.Menu]? = try values.decodeIfPresent([Menu].self, forKey: .menus)
        self.init(id: id,
                  numRatings: numRatings,
                  averageRating: averageRating,
                  storeDescription: storeDescription,
                  priceRange: priceRange,
                  name: name,
                  nextCloseTime: nextCloseTime,
                  nextOpenTime: nextOpenTime,
                  headerImageURL: headerImageURL,
                  menus: menus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StoreCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(numRatings, forKey: .numRatings)
        try container.encode(averageRating, forKey: .averageRating)
        try container.encode(priceRange, forKey: .priceRange)
        try container.encode(storeDescription, forKey: .storeDescription)
        try container.encode(name, forKey: .name)
        try container.encode(nextCloseTime, forKey: .nextCloseTime)
        try container.encode(nextOpenTime, forKey: .nextOpenTime)
        try container.encodeIfPresent(menus, forKey: .menus)
    }
}
