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

    private var model: BrowseFoodAllStoreHeaderModel!

    override func sizeForItem(at index: Int) -> CGSize {
        let constants = BrowseFoodAllStoresHeaderView.Constants()
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: model.showSeparator ? constants.height : constants.heightWithoutSeparator)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: BrowseFoodAllStoresHeaderView.self, for: self, at: index) as? BrowseFoodAllStoresHeaderView, let model = model else {
            fatalError()
        }
        cell.setupCell(text: model.title, showSeparator: model.showSeparator)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? BrowseFoodAllStoreHeaderModel
    }
}
