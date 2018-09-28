//
//  BrowseFoodAllStoreHeaderSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class BrowseFoodAllStoreHeaderSectionController: ListSectionController {

    private var model: BrowseFoodAllStoreHeaderModel?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: BrowseFoodSectionHeaderViewCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: BrowseFoodSectionHeaderViewCell.self, for: self, at: index) as? BrowseFoodSectionHeaderViewCell, let model = model else {
            fatalError()
        }
        cell.titleLabel.text = model.title
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? BrowseFoodAllStoreHeaderModel
    }
}

