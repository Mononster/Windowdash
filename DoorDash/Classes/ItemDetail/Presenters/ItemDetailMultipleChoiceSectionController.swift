//
//  ItemDetailMultipleChoiceSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class ItemDetailOptionPresentingModel {
    let optionName: String
    let price: String?
    var isSelected: Bool = false

    init(optionName: String, price: String?) {
        self.optionName = optionName
        self.price = price
    }
}

final class ItemDetailMultipleChoicePresentingModel: NSObject, ListDiffable {

    let options: [ItemDetailOptionPresentingModel]
    let questionName: String
    let questionDescription: String?
    let isRequired: Bool
    let minNumberOptions: Int64
    let maxNumberOptions: Int64
    let selectionMode: MenuItemExtraSelectionMode

    var numSelectedOptions: Int {
        var count = 0
        for option in options {
            if option.isSelected { count += 1 }
        }
        return count
    }

    init(mode: MenuItemExtraSelectionMode,
         name: String,
         description: String?,
         isRequired: Bool,
         minNumberOptions: Int64,
         maxNumberOptions: Int64,
         options: [ItemDetailOptionPresentingModel]) {
        self.selectionMode = mode
        self.questionName = name.uppercased()
        self.questionDescription = description
        self.isRequired = isRequired
        self.minNumberOptions = minNumberOptions
        self.maxNumberOptions = maxNumberOptions
        self.options = options
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class ItemDetailMultipleChoiceSectionController: ListSectionController {

    private var model: ItemDetailMultipleChoicePresentingModel?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return model?.options.count ?? 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: ItemDetailOptionCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ItemDetailOptionCell.self, for: self, at: 0) as? ItemDetailOptionCell, let model = model, let option = model.options[safe: index] else {
            fatalError()
        }
        cell.setupCell(mode: model.selectionMode,
                       optionName: option.optionName,
                       price: option.price,
                       selected: option.isSelected)
        cell.cellTapped = { isSelected in
            if model.selectionMode == .singleSelect {
                self.updateCellSelectedState()
            }
            option.isSelected = isSelected
            cell.updateCell(selected: isSelected)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? ItemDetailMultipleChoicePresentingModel
    }

    private func updateCellSelectedState() {
        for cell in self.collectionContext?.visibleCells(for: self) ?? [] {
            if let optionCell = cell as? ItemDetailOptionCell {
                optionCell.updateCell(selected: false)
            }
        }
        for option in self.model?.options ?? [] {
            option.isSelected = false
        }
    }

    override func didSelectItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self)
            as? ItemDetailOptionCell, let model = model, let option = model.options[safe: index] else {
            return
        }
        if model.selectionMode == .singleSelect && !cell.cellSelected {
            self.updateCellSelectedState()
            option.isSelected = true
            cell.updateCell(selected: true)
        }
        
        if model.selectionMode == .multiSelect {
            // not exceeeding max number of choices or it is selected (so we deselect it)
            guard model.numSelectedOptions < model.maxNumberOptions || option.isSelected else {
                cell.presentInvalidSeletion()
                return
            }
            cell.updateCell(selected: !cell.cellSelected)
            option.isSelected = !option.isSelected
        }
    }
}

extension ItemDetailMultipleChoiceSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: calcHeaderHeight())
    }

    func calcHeaderHeight() -> CGFloat {
        let width = collectionContext?.containerSize.width ?? 0
        let containerWidth = width - 2 * ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
        var height: CGFloat = 32 + 20 + 16
        if let description = model?.questionDescription {
            let textHeight = HelperManager.textHeight(description, width: containerWidth, font: ItemDetailOptionHeaderCell.descriptionLabelFont)
            height += textHeight + 8
        }
        return height
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: ItemDetailOptionHeaderCell.self,
            at: index) as? ItemDetailOptionHeaderCell, let model = model else {
                fatalError()
        }
        cell.setupCell(name: model.questionName,
                       description: model.questionDescription,
                       isRequired: model.isRequired)
        return cell
    }
}
