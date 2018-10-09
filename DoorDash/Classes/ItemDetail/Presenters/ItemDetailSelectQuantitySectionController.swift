//
//  ItemDetailSelectQuantitySectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class ItemDetailSelectQuantityPresentingModel: NSObject, ListDiffable {

    private let minQuantity: Int
    private let maxQuantity: Int

    var quantity: Int
    var quantityDisplay: String
    var isAddDisable: Bool = false
    var isMinusDisable: Bool = false

    init(quantity: Int, maxQuantity: Int, minQuantity: Int) {
        self.quantity = quantity
        self.minQuantity = minQuantity
        self.maxQuantity = maxQuantity
        self.quantityDisplay = String(quantity)
        self.isMinusDisable = quantity <= minQuantity
        self.isAddDisable = quantity >= maxQuantity
    }

    func increaseQuantity() {
        self.quantity += 1
        updateState(currQuantity: quantity)
    }

    func decreaseQuantity() {
        self.quantity -= 1
        updateState(currQuantity: quantity)
    }

    private func updateState(currQuantity: Int) {
        self.quantityDisplay = String(quantity)
        self.isMinusDisable = currQuantity <= minQuantity
        self.isAddDisable = currQuantity >= maxQuantity
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class ItemDetailSelectQuantitySectionController: ListSectionController {

    private var model: ItemDetailSelectQuantityPresentingModel?

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: ItemDetailSelectNumberCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: ItemDetailSelectNumberCell.self,
            for: self,
            at: 0) as? ItemDetailSelectNumberCell, let model = model else {
            fatalError()
        }
        cell.adjustQuantityView.setupView(numberOfItems: model.quantityDisplay,
                                          isMinusButtonDisabled: model.isMinusDisable,
                                          isAddButtonDisabled: model.isAddDisable)
        cell.adjustQuantityView.addButtonTapped = {
            model.increaseQuantity()
            cell.adjustQuantityView.setupView(numberOfItems: model.quantityDisplay,
                                              isMinusButtonDisabled: model.isMinusDisable,
                                              isAddButtonDisabled: model.isAddDisable)
        }
        cell.adjustQuantityView.minusButtonTapped = {
            model.decreaseQuantity()
            cell.adjustQuantityView.setupView(numberOfItems: model.quantityDisplay,
                                              isMinusButtonDisabled: model.isMinusDisable,
                                              isAddButtonDisabled: model.isAddDisable)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? ItemDetailSelectQuantityPresentingModel
    }
}
