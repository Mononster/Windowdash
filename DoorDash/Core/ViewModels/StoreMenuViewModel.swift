//
//  StoreMenuViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class StoreMenuViewModel {

    let model: StoreMenu
    let nameDisplay: String
    let menuTitles: [String]
    let categories: [MenuCategoryViewModel]

    init(menu: StoreMenu) {
        self.model = menu
        self.categories = model.categories.map { category in
            return MenuCategoryViewModel(category: category)
        }
        self.nameDisplay = model.name
        self.menuTitles = categories.map { category in
            return category.categoryNameDisplay
        }
    }
}
