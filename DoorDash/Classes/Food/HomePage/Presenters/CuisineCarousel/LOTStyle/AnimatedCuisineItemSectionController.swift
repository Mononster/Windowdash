//
//  AnimatedCuisineItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-11-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class AnimatedCuisineItemSectionController: ListSectionController {

    private var cuisineItem: CuisineItem?
    static var heightWithoutImage: CGFloat = 4 + 18 + 20
    var didSelectCuisine: ((BrowseFoodCuisineCategory) -> ())?

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let itemWidth: CGFloat = BrowseFoodViewModel
            .UIConfigure.getAnimatedCuisineItemSize(collectionViewWidth: width)
        return CGSize(width: itemWidth,
                      height: collectionContext?.containerSize.height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AnimatedCuisineItemCell.self, for: self, at: index) as? AnimatedCuisineItemCell, let item = cuisineItem else {
            fatalError()
        }
        cell.setupCell(imageURL: item.imageURL, title: item.title, selected: item.selected)
        return cell
    }

    override func didUpdate(to object: Any) {
        cuisineItem = object as? CuisineItem
    }

    override func didSelectItem(at index: Int) {
        guard let cuisine = self.cuisineItem?.cuisine else {
            return
        }
        self.didSelectCuisine?(cuisine)
    }
}


