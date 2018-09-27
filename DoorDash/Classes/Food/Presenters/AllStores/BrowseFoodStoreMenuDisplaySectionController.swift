//
//  BrowseFoodStoreMenuDisplaySectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class BrowseFoodStoreMenuDisplaySectionController: ListSectionController {

    private var menuItem: BrowseFoodAllStoreMenuItem?

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: collectionContext?.containerSize.height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: BrowseFoodStoreMenuImageCell.self, for: self, at: index) as? BrowseFoodStoreMenuImageCell, let url = menuItem?.imageURL else {
            fatalError()
        }
        cell.setupCell(imageURL: url)
        return cell
    }

    override func didUpdate(to object: Any) {
        menuItem = object as? BrowseFoodAllStoreMenuItem
    }
}
