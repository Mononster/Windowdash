//
//  MenuCategoryViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class MenuCategoryViewModel {

    let model: MenuCategory
    let categoryNameDisplay: String
    let descriptionDisplay: String?
    let items: [MenuItemViewModel]

    init(category: MenuCategory) {
        self.model = category
        self.items = category.items.map { item in
            return MenuItemViewModel(item: item)
        }
        self.categoryNameDisplay = model.title
        self.descriptionDisplay = model.subTitle
    }
}
