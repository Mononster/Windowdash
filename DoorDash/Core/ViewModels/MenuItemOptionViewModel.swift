//
//  MenuItemOptionViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

final class MenuItemOptionViewModel {

    let model: MenuItemOption
    let optionName: String
    var priceDisplay: String?

    init(model: MenuItemOption) {
        self.model = model
        self.optionName = model.name
        self.priceDisplay = model.priceDisplay
        if model.price.centsAmount == 0 || model.priceDisplay == "$0.00" {
            self.priceDisplay = nil
        }
    }
}
