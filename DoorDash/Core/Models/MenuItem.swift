//
//  MenuItem.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

public enum MoneyFieldCodingKeys: String, CodingKey {
    case currency
    case unitAmount = "unit_amount"
    case displayString = "display_string"
}

enum MenuItemExtraSelectionMode: String {
    case singleSelect = "single_select"
    case multiSelect = "multi_select"
}

struct MenuItemOption: Codable {

    enum MenuItemOptionCodingKeys: String, CodingKey {
        case id
        case name
        case optionDescription = "description"
        case priceMonetaryFields = "price_monetary_fields"
    }

    let id: Int64
    let name: String
    let optionDescription: String?
    let price: Money
    let priceDisplay: String

    init(id: Int64,
         name: String,
         optionDescription: String?,
         price: Money,
         priceDisplay: String) {
        self.id = id
        self.name = name
        self.optionDescription = optionDescription
        self.price = price
        self.priceDisplay = priceDisplay
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MenuItemOptionCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let optionDescription: String? = try values.decodeIfPresent(String.self, forKey: .optionDescription)
        let moneyContainer = try values.nestedContainer(keyedBy: MoneyFieldCodingKeys.self, forKey: .priceMonetaryFields)
        let moneyCents: Int64 = try moneyContainer.decodeIfPresent(Int64.self, forKey: .unitAmount) ?? 0
        let currency = try moneyContainer.decodeIfPresent(String.self, forKey: .currency) ?? "USD"
        let moneyDisplayString: String = try moneyContainer.decodeIfPresent(String.self, forKey: .displayString) ?? "$0.00"
        self.init(id: id,
                  name: name,
                  optionDescription: optionDescription,
                  price: Money(cents: moneyCents, currency: Currency(rawValue: currency) ?? .USD),
                  priceDisplay: moneyDisplayString)
    }

    func encode(to encoder: Encoder) throws {}
}

struct MenuItemExtra: Codable {

    enum MenuItemExtraCodingKeys: String, CodingKey {
        case id
        case name
        case extraDescription = "description"
        case options
        case selectionMode = "selection_mode"
        case maxNumOptions = "max_num_options"
        case minNumOptions = "min_num_options"
        case numFreeOptions = "num_free_options"
    }

    let id: Int64
    let name: String
    let extraDescription: String?
    let selectionMode: MenuItemExtraSelectionMode
    let maxNumOptions: Int64
    let minNumOptions: Int64
    let numFreeOptions: Int64
    let options: [MenuItemOption]

    init(id: Int64,
         name: String,
         extraDescription: String?,
         selectionMode: MenuItemExtraSelectionMode,
         maxNumOptions: Int64,
         minNumOptions: Int64,
         numFreeOptions: Int64,
         options: [MenuItemOption]) {
        self.id = id
        self.name = name
        self.extraDescription = extraDescription
        self.selectionMode = selectionMode
        self.maxNumOptions = maxNumOptions
        self.minNumOptions = minNumOptions
        self.numFreeOptions = numFreeOptions
        self.options = options
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MenuItemExtraCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let extraDescription: String? = try values.decodeIfPresent(String.self, forKey: .extraDescription)
        let selectionModeRaw: String = try values.decodeIfPresent(String.self, forKey: .selectionMode) ?? ""
        let selectionMode = MenuItemExtraSelectionMode(rawValue: selectionModeRaw) ?? .singleSelect
        let maxNumOptions: Int64 = try values.decodeIfPresent(Int64.self, forKey: .maxNumOptions) ?? 0
        let minNumOptions: Int64 = try values.decodeIfPresent(Int64.self, forKey: .minNumOptions) ?? 0
        let numFreeOptions: Int64 = try values.decodeIfPresent(Int64.self, forKey: .numFreeOptions) ?? 0
        let options: [MenuItemOption] = try values.decodeIfPresent([MenuItemOption].self, forKey: .options) ?? []
        self.init(id: id,
                  name: name,
                  extraDescription: extraDescription,
                  selectionMode: selectionMode,
                  maxNumOptions: maxNumOptions,
                  minNumOptions: minNumOptions,
                  numFreeOptions: numFreeOptions,
                  options: options)
    }

    func encode(to encoder: Encoder) throws {}
}

struct MenuItem: Codable {

    enum MenuItemCodingKeys: String, CodingKey {
        case id
        case name
        case itemDescription = "description"
        case imageURL = "image_url"
        case priceMonetaryFields = "price_monetary_fields"
        case isActive = "is_active"
        case isPopular = "is_popular"
        case extras = "extras"
    }

    let id: Int64
    let name: String
    let itemDescription: String?
    let imageURL: String
    let price: Money
    let priceDisplay: String
    let isActive: Bool
    let isPopular: Bool?
    let extras: [MenuItemExtra]

    init(id: Int64,
         name: String,
         itemDescription: String?,
         imageURL: String,
         price: Money,
         priceDisplay: String,
         isActive: Bool,
         isPopular: Bool?,
         extras: [MenuItemExtra]) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.price = price
        self.priceDisplay = priceDisplay
        self.isActive = isActive
        self.extras = extras
        self.isPopular = isPopular
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
        let isActive: Bool = try values.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        let isPopular: Bool? = try values.decodeIfPresent(Bool.self, forKey: .isPopular)
        let extras: [MenuItemExtra] = try values.decodeIfPresent([MenuItemExtra].self, forKey: .extras) ?? []
        self.init(id: id,
                  name: name,
                  itemDescription: itemDescription,
                  imageURL: imageURL,
                  price: Money(cents: moneyCents, currency: .USD),
                  priceDisplay: moneyDisplayString,
                  isActive: isActive,
                  isPopular: isPopular,
                  extras: extras)
    }

    func encode(to encoder: Encoder) throws {}
}
