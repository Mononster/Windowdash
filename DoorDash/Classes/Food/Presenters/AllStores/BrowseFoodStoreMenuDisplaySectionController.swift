//
//  BrowseFoodStoreMenuDisplaySectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

enum MenuCollectionViewLayoutKind {
    case centerTwoItems
    case centerOneItem
}

final class BrowseFoodStoreMenuDisplaySectionController: ListSectionController {

    private var menuItem: BrowseFoodAllStoreMenuItem?
    private let layoutKind: MenuCollectionViewLayoutKind

    init(layoutKind: MenuCollectionViewLayoutKind) {
        self.layoutKind = layoutKind
        super.init()
        self.inset = UIEdgeInsets(
            top: 0, left: 0,
            bottom: 0, right: BrowseFoodViewModel.UIConfigure.menuCollectionViewSpacing
        )
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var width: CGFloat = (collectionContext?.containerSize.width ?? 0) - 2 * BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        if layoutKind == .centerTwoItems {
            width = (width - BrowseFoodViewModel.UIConfigure.menuCollectionViewSpacing) / 2
        }
        return CGSize(width: width,
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
