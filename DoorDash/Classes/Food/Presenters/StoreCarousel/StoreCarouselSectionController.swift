//
//  StoreCarouselSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class StoreCarouselItem: NSObject, ListDiffable {

    let imageURL: URL
    let title: String
    let subTitle: String

    init(imageURL: URL, title: String, subTitle: String) {
        self.imageURL = imageURL
        self.title = title
        self.subTitle = subTitle
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreCarouselItems: NSObject, ListDiffable {
    let items: [StoreCarouselItem]
    let carouselDescription: String?
    let carouselTitle: String
    let maxTitleHeight: CGFloat

    init(items: [StoreCarouselItem],
         carouselTitle: String,
         maxTitleHeight: CGFloat,
         carouselDescription: String? = nil) {
        self.items = items
        self.carouselTitle = carouselTitle
        self.carouselDescription = carouselDescription
        self.maxTitleHeight = maxTitleHeight
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreCarouselSectionController: ListSectionController {

    private var items: StoreCarouselItems?

    override func numberOfItems() -> Int {
        var numItem = 1
        if items?.items.count == 1 {
            numItem += 1
        } else if items?.items.count == 3 {
            numItem += 2
        }
        return numItem
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 0
        var width: CGFloat = (collectionContext?.containerSize.width ?? 0)
        if index == 0 {
            if items?.carouselDescription == nil {
                height = BrowseFoodSectionHeaderViewCell.height
            } else {
                height = BrowseFoodHeaderWithSubTitleViewCell.height
            }
        } else if index == 1 {
            height = StoreCarouselLargeDisplayCell.height
            width = width - 2 * 18
        } else if index == 2 {
            height = StoreCarouselTwoStoresCell.getHeight(titleHeight: items?.maxTitleHeight ?? 0)
            width = width - 2 * 18
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            if let descripiton = items?.carouselDescription {
                guard let cell = collectionContext?.dequeueReusableCell(
                    of: BrowseFoodHeaderWithSubTitleViewCell.self,
                    for: self,
                    at: index) as? BrowseFoodHeaderWithSubTitleViewCell else {
                        fatalError()
                }
                cell.titleLabel.text = items?.carouselTitle
                cell.descriptionLabel.text = descripiton
                return cell
            } else {
                guard let cell = collectionContext?.dequeueReusableCell(
                    of: BrowseFoodSectionHeaderViewCell.self,
                    for: self,
                    at: index) as? BrowseFoodSectionHeaderViewCell else {
                        fatalError()
                }
                cell.titleLabel.text = items?.carouselTitle
                return cell
            }
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreCarouselLargeDisplayCell.self,
                for: self,
                at: index) as? StoreCarouselLargeDisplayCell,
                let item = items?.items[safe: index - 1] else {
                    fatalError()
            }
            let model = (imageURL: item.imageURL, title: item.title, subTitle: item.subTitle)
            cell.setupCell(model: model)
            return cell
        } else if index == 2 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreCarouselTwoStoresCell.self,
                for: self,
                at: index) as? StoreCarouselTwoStoresCell,
                let itemA = items?.items[safe: index - 1],
                let itemB = items?.items[safe: index - 2] else {
                    fatalError()
            }
            let modelA = (imageURL: itemA.imageURL, title: itemA.title, subTitle: itemA.subTitle)
            let modelB = (imageURL: itemB.imageURL, title: itemB.title, subTitle: itemB.subTitle)
            cell.setupCell(firstStoreModel: modelA, secondStoreModel: modelB)
            return cell
        }
        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        items = object as? StoreCarouselItems
    }
}
