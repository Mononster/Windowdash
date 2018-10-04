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
    let subTitleDisplay: String
    let nameDisplay: String
    let menuTitles: [String]
    let categories: [MenuCategoryViewModel]

    init(menu: StoreMenu) {
        self.model = menu
        self.categories = model.categories.map { category in
            return MenuCategoryViewModel(category: category)
        }
        self.subTitleDisplay = model.subTitle
        self.nameDisplay = model.name
        self.menuTitles = categories.map { category in
            return category.categoryNameDisplay
        }

        if let popularCategory = categories.first, popularCategory.model.id == 1 {
            for i in 1..<categories.count {
                for item in categories[i].items {
                    for popularItem in popularCategory.items {
                        if popularItem.model.id == item.model.id {
                            item.isPopular = true
                        }
                    }
                }
            }
        }
    }
}
