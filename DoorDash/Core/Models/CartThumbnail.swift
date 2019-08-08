//
//  CartThumbnail.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

struct CartThumbnail: Codable {

    enum CartThumbnailCodingKeys: String, CodingKey {
        case id
        case isEmpty = "is_empty"
        case title
        case quantity
    }

    let id: Int64
    let isEmpty: Bool
    let title: String
    let quantity: String

    init(id: Int64, isEmpty: Bool, title: String, quantity: String) {
        self.id = id
        self.isEmpty = isEmpty
        self.title = title
        self.quantity = quantity
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CartThumbnailCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let title: String = try values.decode(String.self, forKey: .title)
        let quantity: String = try values.decode(String.self, forKey: .quantity)
        let isEmpty: Bool = try values.decode(Bool.self, forKey: .isEmpty)
        self.init(id: id, isEmpty: isEmpty, title: title, quantity: quantity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CartThumbnailCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isEmpty, forKey: .isEmpty)
        try container.encode(title, forKey: .title)
        try container.encode(quantity, forKey: .quantity)
    }
}
