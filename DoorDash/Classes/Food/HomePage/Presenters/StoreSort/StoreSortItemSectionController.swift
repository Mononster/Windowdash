//
//  StoreSortItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class StoreSortItemSectionController: ListSectionController {

    private var item: StoreSortItemPresentingModel!
    var openSelectionView: ((StoreSortItemPresentingModel) -> Void)?
    var didSelectItem: ((StoreSortItemPresentingModel) -> ())?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth: CGFloat
        switch item.kind {
        case .binary, .sort:
            cellWidth = StoreSortBinaryCell.calcWidth(text: item.title)
        case .collection:
            cellWidth = StoreSortPriceRangeCell.calcWidth(text: item.title)
        case .range:
            cellWidth = StoreSortRatingCell.calcWidth(text: item.title)
        }
        let height: CGFloat = StoreSortBaseCell.Constants().containerHeight
        return CGSize(width: cellWidth, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellType: StoreSortBaseCell.Type
        switch item.kind {
        case .binary, .sort:
            cellType = StoreSortBinaryCell.self
        case .collection:
            cellType = StoreSortPriceRangeCell.self
        case .range:
            cellType = StoreSortRatingCell.self
        }
        guard let cell = collectionContext?.dequeueReusableCell(
            of: cellType,
            for: self,
            at: index) as? StoreSortBaseCell else {
                fatalError()
        }
        cell.setupCell(title: item.title, selected: item.selected)
        cell.dropDownButtonTapped = { [weak self] in
            guard let `self` = self else { return }
            self.openSelectionView?(self.item)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? StoreSortItemPresentingModel
    }

    override func didSelectItem(at index: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.didSelectItem?(item)
    }
}
