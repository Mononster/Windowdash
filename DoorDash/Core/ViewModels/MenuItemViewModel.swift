//
//  MenuItemViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class MenuItemViewModel {

    let model: MenuItem
    let priceDisplay: String
    let nameDisplay: String
    let itemDescriptionDisplay: String?
    let imageURL: URL?
    let isActive: Bool
    var isPopular: Bool = false

    init(item: MenuItem) {
        self.model = item
        self.priceDisplay = model.priceDisplay
        self.nameDisplay = model.name
        self.itemDescriptionDisplay = model.itemDescription
        self.imageURL = URL(string: model.imageURL)
        self.isActive = item.isActive
    }
}
