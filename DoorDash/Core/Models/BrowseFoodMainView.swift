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
        case animatedCoverImageURL = "animated_cover_image_url"
    }

    let id: Int64
    let friendlyName: String
    let name: String
    let coverImageURL: URL?
    let animatedCoverImageURL: URL?

    init(id: Int64,
         friendlyName: String,
         name: String,
         coverImageURL: URL?,
         animatedCoverImageURL: URL?) {
        self.id = id
        self.friendlyName = friendlyName
        self.name = name
        self.coverImageURL = coverImageURL
        self.animatedCoverImageURL = animatedCoverImageURL
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CuisineCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let friendlyName: String = try values.decodeIfPresent(String.self, forKey: .friendlyName) ?? ""
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let coverImageURLRaw: String = try values.decodeIfPresent(String.self, forKey: .coverImageURL) ?? ""
        let coverImageURL = URL(string: coverImageURLRaw)
        let animatedImageURLRaw: String = try values.decodeIfPresent(String.self, forKey: .animatedCoverImageURL) ?? ""
        let animatedImageURL = URL(string: animatedImageURLRaw)
        self.init(id: id,
                  friendlyName: friendlyName,
                  name: name,
                  coverImageURL: coverImageURL,
                  animatedCoverImageURL: animatedImageURL)
    }


    func encode(to encoder: Encoder) throws {}
}

struct BrowseFoodSectionStore {
    let id: String
    let title: String
    let subTitle: String?
    let type: BrowseFoodMainViewSectionType
    let stores: [StoreViewModel]
    init(id: String,
         title: String,
         subTitle: String?,
         type: BrowseFoodMainViewSectionType,
         stores: [StoreViewModel]) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
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
