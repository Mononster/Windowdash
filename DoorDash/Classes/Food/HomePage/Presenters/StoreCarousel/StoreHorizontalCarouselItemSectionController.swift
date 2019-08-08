//
//  StoreHorizontalCarouselItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 6/26/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class StoreHorizontalCarouselItemSectionController: ListSectionController {

    private var item: StoreHorizontalCarouselItem!
    var didSelectItem: ((String) -> ())?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = StoreCarouselDisplayCell.width
        let height: CGFloat = StoreCarouselDisplayCell.getHeight()
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: StoreCarouselDisplayCell.self,
            for: self,
            at: index) as? StoreCarouselDisplayCell else {
                fatalError()
        }
        let model = (imageURL: item.imageURL, title: item.title, subTitle: item.subTitle)
        cell.setupCell(model: model)
        cell.didSelectItem = {
            self.didSelectItem?(self.item.id)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? StoreHorizontalCarouselItem
    }
}
