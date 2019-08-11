//
//  ConfirmActionSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class ConfirmActionPresentingModel: NSObject, ListDiffable {

    var isLoading: Bool
    let primaryButtonText: String
    let primaryButtonAction: (() -> Void)?

    init(isLoading: Bool,
         primaryButtonText: String,
         primaryButtonAction: (() -> Void)?) {
        self.isLoading = isLoading
        self.primaryButtonText = primaryButtonText
        self.primaryButtonAction = primaryButtonAction
    }

    func diffIdentifier() -> NSObjectProtocol {
        return primaryButtonText as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ConfirmActionPresentingModel else { return false }
        return primaryButtonText == object.primaryButtonText && isLoading == object.isLoading
    }
}

final class ConfirmActionSectionController: ListSectionController {

    private var model: ConfirmActionPresentingModel!

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = self.collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: ConfirmAddressButtonCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of:
            ConfirmAddressButtonCell.self, for: self, at: index)
            as? ConfirmAddressButtonCell else {
                fatalError()
        }
        cell.setupCell(buttonText: model.primaryButtonText, isLoading: model.isLoading)
        cell.actionButtonTapped = {
            self.model.isLoading = true
            self.model.primaryButtonAction?()
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? ConfirmActionPresentingModel
    }
}
