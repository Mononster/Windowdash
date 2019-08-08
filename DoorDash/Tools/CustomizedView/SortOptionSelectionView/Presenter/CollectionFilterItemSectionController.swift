//
//  CollectionFilterItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/5/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CollectionFilterItemSectionController: ListSectionController {

    private var model: CollectionFilterItemPresentingModel!
    var didSelectItem: ((CollectionFilterItemPresentingModel) -> ())?

    static let spaceBetweenIems: CGFloat = 12

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CollectionFilterItemSectionController.spaceBetweenIems)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let size: CGFloat = CollectionFilterItemCell.Constants().size
        return CGSize(width: size, height: size)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: CollectionFilterItemCell.self,
            for: self,
            at: index) as? CollectionFilterItemCell else {
                fatalError()
        }
        cell.setupCell(title: model.displayValue, selected: model.isSelected)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? CollectionFilterItemPresentingModel
    }

    override func didSelectItem(at index: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.didSelectItem?(model)
    }
}
