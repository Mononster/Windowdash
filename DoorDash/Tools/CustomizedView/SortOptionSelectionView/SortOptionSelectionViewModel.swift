//
//  SortOptionSelectionViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

final class SortOptionSelectionViewModel {

    let model: StoreSortItemPresentingModel
    let viewResult: ((StoreSortItemPresentingModel) -> Void)?

    init(model: StoreSortItemPresentingModel,
         viewResult: ((StoreSortItemPresentingModel) -> Void)?) {
        self.model = model
        self.viewResult = viewResult
    }

    func applyFilter(selection: [String]) {
        model.selectedValues = selection
        viewResult?(model)
    }
}
