//
//  RatingFilterSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/6/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class RatingFilterPresentingModel: NSObject, ListDiffable {

    let displayValues: [String]
    var selectedValue: String

    init(displayValues: [String], selectedValue: String) {
        self.displayValues = displayValues
        self.selectedValue = selectedValue
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class RatingFilterSectionController: ListSectionController {

    private var model: RatingFilterPresentingModel!

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: RatingFilterCell.Constants().height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: RatingFilterCell.self,
            for: self,
            at: index) as? RatingFilterCell else {
                fatalError()
        }
        cell.setupCell(values: model.displayValues, defaultValue: model.selectedValue)
        cell.didUpdatedValue = { [weak self] val in
            self?.model.selectedValue = val
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? RatingFilterPresentingModel
    }

    func getSelectedValue() -> String {
        return model.selectedValue
    }
}
