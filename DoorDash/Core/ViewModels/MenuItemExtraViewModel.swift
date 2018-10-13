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

        if self.questionDescription == nil && model.selectionMode == .multiSelect {
            if model.minNumOptions == 0 {
                self.questionDescription = "Select up to \(model.maxNumOptions) (Optional)"
            } else {
                self.questionDescription = "Select \(model.minNumOptions)"
            }
        }

        if model.maxNumOptions == 1 && options.count == 1 {
            self.questionDescription = nil
        }
    }
}
