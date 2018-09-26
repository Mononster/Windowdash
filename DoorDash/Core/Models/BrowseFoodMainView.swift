//
//  BrowseFoodMainView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum BrowseFoodMainViewSectionType: String {
    case storeCrousel = "store_carousel"
    case cuisineCarousel = "cuisine_category_carousel"
}

struct BrowseFoodCuisineCategory: Codable {

    private enum CuisineCodingKeys: String, CodingKey {
        case id
        case friendlyName = "friendly_name"
        case name
        case coverImageURL = "cover_image_url"
    }

    let id: Int64
    let friendlyName: String
    let name: String
    let coverImageURL: URL?

    init(id: Int64, friendlyName: String, name: String, coverImageURL: URL?) {
        self.id = id
        self.friendlyName = friendlyName
        self.name = name
        self.coverImageURL = coverImageURL
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CuisineCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let friendlyName: String = try values.decodeIfPresent(String.self, forKey: .friendlyName) ?? ""
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let coverImageURLRaw: String = try values.decodeIfPresent(String.self, forKey: .coverImageURL) ?? ""
        let coverImageURL = URL(string: coverImageURLRaw)
        self.init(id: id,
                  friendlyName: friendlyName,
                  name: name,
                  coverImageURL: coverImageURL)
    }


    func encode(to encoder: Encoder) throws {}
}

struct BrowseFoodSectionStore {
    let title: String
    let type: BrowseFoodMainViewSectionType
    let stores: [Store]
    init(title: String, type: BrowseFoodMainViewSectionType, stores: [Store]) {
        self.title = title
        self.type = type
        self.stores = stores
    }
}

class BrowseFoodMainView {
    let cuisineCategories: [BrowseFoodCuisineCategory]
    let storeSections: [BrowseFoodSectionStore]
    var allRestaurants: [Store] = []

    init(cuisineCategories: [BrowseFoodCuisineCategory],
         storeSections: [BrowseFoodSectionStore]) {
        self.cuisineCategories = cuisineCategories
        self.storeSections = storeSections
    }
}
