//
//  StoreMenu.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

struct MenuItem: Codable {

    enum MenuItemCodingKeys: String, CodingKey {
        case id
        case name
        case itemDescription = "description"
        case imageURL = "image_url"
        case priceMonetaryFields = "price_monetary_fields"
    }

    public enum MoneyFieldCodingKeys: String, CodingKey {
        case unitAmount = "unit_amount"
        case displayString = "display_string"
    }

    let id: Int64
    let name: String
    let itemDescription: String?
    let imageURL: String
    let price: Money
    let priceDisplay: String

    init(id: Int64,
         name: String,
         itemDescription: String?,
         imageURL: String,
         price: Money,
         priceDisplay: String) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.price = price
        self.priceDisplay = priceDisplay
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MenuItemCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let itemDescription: String? = try values.decodeIfPresent(String.self, forKey: .itemDescription)
        let imageURL: String = try values.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        let moneyContainer = try values.nestedContainer(keyedBy: MoneyFieldCodingKeys.self, forKey: .priceMonetaryFields)
        let moneyCents: Int64 = try moneyContainer.decodeIfPresent(Int64.self, forKey: .unitAmount) ?? 0
        let moneyDisplayString: String = try moneyContainer.decodeIfPresent(String.self, forKey: .displayString) ?? "$0.00"
        self.init(id: id,
                  name: name,
                  itemDescription: itemDescription,
                  imageURL: imageURL,
                  price: Money(cents: moneyCents, currency: .USD),
                  priceDisplay: moneyDisplayString)
    }

    func encode(to encoder: Encoder) throws {}
}

struct MenuCategory: Codable {
    enum MenuCategoryCodingKeys: String, CodingKey {
        case id
        case name
        case title
        case items = "items"
        case subTitle = "subtitle"
    }

    let id: Int64
    let name: String
    let title: String
    let subTitle: String?
    let items: [MenuItem]

    init(id: Int64,
         name: String,
         title: String,
         subTitle: String?,
         items: [MenuItem]) {
        self.id = id
        self.name = name
        self.title = title
        self.subTitle = subTitle
        self.items = items
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MenuCategoryCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let title: String = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        let items: [MenuItem] = try values.decodeIfPresent([MenuItem].self, forKey: .items) ?? []
        let subTitle: String? = try values.decodeIfPresent(String.self, forKey: .subTitle)
        self.init(id: id, name: name, title: title, subTitle: subTitle, items: items)
    }

    func encode(to encoder: Encoder) throws {}
}

struct StoreMenu: Codable {

    enum StoreMenuCodingKeys: String, CodingKey {
        case id
        case subTitle = "subtitle"
        case name
        case featuredItems = "featured_items"
        case popularItems = "popular_items"
        case categories
    }

    let id: Int64
    let name: String
    let subTitle: String
    let featuredItems: [MenuItem]
    let popularItems: [MenuItem]
    let categories: [MenuCategory]

    init(id: Int64,
         name: String,
         subTitle: String,
         featuredItems: [MenuItem],
         popularItems: [MenuItem],
         categories: [MenuCategory]) {
        self.id = id
        self.name = name
        self.subTitle = subTitle
        self.featuredItems = featuredItems
        self.popularItems = popularItems
        self.categories = categories
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: StoreMenuCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let subTitle: String = try values.decodeIfPresent(String.self, forKey: .subTitle) ?? ""
        let featuredItems: [MenuItem] = try values.decodeIfPresent([MenuItem].self, forKey: .featuredItems) ?? []
        let popularItems: [MenuItem] = try values.decodeIfPresent([MenuItem].self, forKey: .popularItems) ?? []
        let categories: [MenuCategory] = try values.decodeIfPresent([MenuCategory].self, forKey: .categories) ?? []
        self.init(id: id,
                  name: name,
                  subTitle: subTitle,
                  featuredItems: featuredItems,
                  popularItems: popularItems,
                  categories: categories)
    }

    func encode(to encoder: Encoder) throws {}
}
