//
//  OrderCartItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import SwipeCellKit

final class OrderCartItemPresentingModel: NSObject, ListDiffable {

    let itemID: Int64
    let itemRemoveID: Int64
    let itemName: String
    let itemOptions: String?
    let price: String
    let quantity: String

    init(itemID: Int64,
         itemRemoveID: Int64,
         itemName: String,
         itemOptions: String?,
         price: String,
         quantity: String) {
        self.itemID = itemID
        self.itemName = itemName
        self.itemRemoveID = itemRemoveID
        self.itemOptions = itemOptions
        self.price = price
        self.quantity = quantity
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class OrderCartItemSectionController: ListSectionController {

    private var model: OrderCartItemPresentingModel?

    var userRemovedItem: ((Int64) -> ())?
    var userTappedItem: ((Int64) -> ())?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let model = model else {
            return CGSize.zero
        }
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        let containerWidth = collectionViewWidth - OrderCartViewModel.UIStats.leadingSpace.rawValue - OrderCartViewModel.UIStats.trailingSpace.rawValue
        let descriptionHeight = HelperManager.textHeight(model.itemOptions, width: containerWidth, font: OrderCartItemCollectionViewCell.descriptionLabelFont)
        var height = descriptionHeight + OrderCartItemCollectionViewCell.heightWithoutDescription
        if model.itemOptions == nil {
            height -= 6
        }
        return CGSize(width: collectionViewWidth, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OrderCartItemCollectionViewCell.self, for: self, at: index) as? OrderCartItemCollectionViewCell, let model = model else {
            fatalError()
        }
        cell.delegate = self
        cell.setupCell(quantity: model.quantity,
                       itemName: model.itemName,
                       itemDescription: model.itemOptions,
                       price: model.price)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? OrderCartItemPresentingModel
    }

    override func didSelectItem(at index: Int) {
        guard let id = model?.itemID else {
            return
        }
        self.userTappedItem?(id)
    }
}

extension OrderCartItemSectionController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let delete = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            if let id = self.model?.itemRemoveID {
                self.userRemovedItem?(id)
            }
            action.fulfill(with: ExpansionFulfillmentStyle.reset)
        }
        delete.hidesWhenSelected = true
        delete.title = "Delete"
        delete.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        return [delete]
    }

    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.transitionStyle = .reveal
        options.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        return options
    }
}
