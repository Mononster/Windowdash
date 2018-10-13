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
    let priceCents: Int64

    init(model: MenuItemOption) {
        self.model = model
        self.optionName = model.name
        self.priceDisplay = model.price.displayString
        if model.price.money.cents == 0 || model.price.displayString == "$0.00" {
            self.priceDisplay = nil
        }
        self.priceCents = model.price.money.cents
    }
}
