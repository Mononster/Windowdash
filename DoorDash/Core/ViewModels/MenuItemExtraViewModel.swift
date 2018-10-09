//
//  MenuItemExtraViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

final class MenuItemExtraViewModel {
    let model: MenuItemExtra
    let questionName: String
    var questionDescription: String?
    let isRequired: Bool
    let options: [MenuItemOptionViewModel]

    init(model: MenuItemExtra) {
        self.model = model
        self.questionName = model.name
        self.options = model.options.map { option in
            return MenuItemOptionViewModel(model: option)
        }
        isRequired = self.model.minNumOptions > 0
        setup(model: model)
    }

    func setup(model: MenuItemExtra) {
        if let description = model.extraDescription, description == "" {
            self.questionDescription = nil
        } else {
            self.questionDescription = model.extraDescription
        }

        if self.questionDescription == nil
            && model.minNumOptions == 0
            && model.selectionMode == .multiSelect
            && model.maxNumOptions == 1 {
            self.questionDescription = "Select up to 1 (Optional)"
        }
    }
}
