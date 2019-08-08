//
//  Filter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-11-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

enum StoreFilterType: String {
    case sort = "sort"
    case range = "range"
    case binary = "binary"
    case collection = "collection"
}

struct StoreFilterInfo: Codable {

    enum FilterInfoCodingKeys: String, CodingKey {
        case defaultValues = "default_values"
        case displayName = "display_name"
        case id
        case filterType = "filter_type"
        case allowedValues = "allowed_values"
    }

    let defaultValues: [String]
    let displayName: String
    let id: String
    let filterType: StoreFilterType
    let allowedValues: [String]

    init(defaultValues: [String],
         displayName: String,
         id: String,
         filterType: StoreFilterType,
         allowedValues: [String]) {
        self.defaultValues = defaultValues
        self.displayName = displayName
        self.id = id
        self.filterType = filterType
        self.allowedValues = allowedValues
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FilterInfoCodingKeys.self)
        let id: String = try values.decode(String.self, forKey: .id)
        let displayName: String = try values.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        let defaultValues: [String] = try values.decodeIfPresent([String].self, forKey: .defaultValues) ?? []
        let allowedValues: [String] = try values.decodeIfPresent([String].self, forKey: .allowedValues) ?? []
        let filterTypeRaw: String = try values.decodeIfPresent(String.self, forKey: .filterType) ?? ""
        let filterType = StoreFilterType(rawValue: filterTypeRaw) ?? .binary
        self.init(defaultValues: defaultValues, displayName: displayName, id: id, filterType: filterType, allowedValues: allowedValues)
    }

    func encode(to encoder: Encoder) throws {}
}

struct ConsumerSearchFilter: Codable {

    enum ConsumerSearchFilterCodingKeys: String, CodingKey {
        case cuisines
        case filters
    }

    let filters: [StoreFilterInfo]

    init(filters: [StoreFilterInfo]) {
        self.filters = filters
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConsumerSearchFilterCodingKeys.self)
        let filters: [StoreFilterInfo] = try values.decodeIfPresent([StoreFilterInfo].self, forKey: .filters) ?? []
        self.init(filters: filters)
    }

    func encode(to encoder: Encoder) throws {}
}
