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

    let id: String
    let imageURL: URL
    let title: String
    let subTitle: String

    init(id: String, imageURL: URL, title: String, subTitle: String) {
        self.id = id
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
    let id: String
    let items: [StoreCarouselItem]
    let carouselDescription: String?
    let carouselTitle: String
    let maxTitleHeight: CGFloat
    let largeDisplayTitleHeight: CGFloat

    // MaxTitleHeight represents the max title height for two sub cells
    // largeDisplayTitleHeight represents the title height for top display cell.
    init(id: String,
         items: [StoreCarouselItem],
         carouselTitle: String,
         maxTitleHeight: CGFloat,
         largeDisplayTitleHeight: CGFloat,
         carouselDescription: String? = nil) {
        self.id = id
        self.items = items
        self.carouselTitle = carouselTitle
        self.carouselDescription = carouselDescription
        self.maxTitleHeight = maxTitleHeight
        self.largeDisplayTitleHeight = largeDisplayTitleHeight
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

    var seeAllButtonTapped: ((String, String, String?) -> ())?
    var didSelectItem: ((String) -> ())?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        if items?.items.count == 1 {
            return 1
        } else if items?.items.count == 3 {
            return 2
        }
        return 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 0
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        if index == 0 {
            height = StoreCarouselLargeDisplayCell.getHeight(titleHeight: items?.largeDisplayTitleHeight ?? 0)
        } else if index == 1 {
            height = StoreCarouselTwoStoresCell.getHeight(titleHeight: items?.maxTitleHeight ?? 0)
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreCarouselLargeDisplayCell.self,
                for: self,
                at: index) as? StoreCarouselLargeDisplayCell,
                let item = items?.items[safe: 0] else {
                    fatalError()
            }
            let model = (imageURL: item.imageURL, title: item.title, subTitle: item.subTitle)
            cell.setupCell(model: model)
            cell.didSelectItem = {
                self.didSelectItem?(item.id)
            }
            return cell
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreCarouselTwoStoresCell.self,
                for: self,
                at: index) as? StoreCarouselTwoStoresCell,
                let itemA = items?.items[safe: 1],
                let itemB = items?.items[safe: 2] else {
                    fatalError()
            }
            let modelA = (imageURL: itemA.imageURL, title: itemA.title, subTitle: itemA.subTitle)
            let modelB = (imageURL: itemB.imageURL, title: itemB.title, subTitle: itemB.subTitle)
            cell.setupCell(firstStoreModel: modelA, secondStoreModel: modelB)
            cell.didSelectItem = { index in
                if index == 0 {
                    self.didSelectItem?(itemA.id)
                } else {
                    self.didSelectItem?(itemB.id)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        items = object as? StoreCarouselItems
    }
}

extension StoreCarouselSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(atIndex: index)
        case UICollectionView.elementKindSectionFooter:
            return footerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        if elementKind == UICollectionView.elementKindSectionHeader {
            let height: CGFloat
            if items?.carouselDescription == nil {
                height = BrowseFoodSectionHeaderViewCell.calcHeight(containerWidth: width, title: items?.carouselTitle ?? "")
            } else {
                height = BrowseFoodHeaderWithSubTitleViewCell.height
            }
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: width, height: StoreCarouselFooterCell.height)
        }
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        if let descripiton = items?.carouselDescription {
            guard let cell = collectionContext?.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: self,
                class: BrowseFoodHeaderWithSubTitleViewCell.self,
                at: index) as? BrowseFoodHeaderWithSubTitleViewCell else {
                    fatalError()
            }
            cell.titleLabel.text = items?.carouselTitle.uppercased()
            cell.descriptionLabel.text = descripiton
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: self,
                class: BrowseFoodSectionHeaderViewCell.self,
                at: index) as? BrowseFoodSectionHeaderViewCell else {
                    fatalError()
            }
            cell.setupCell(title: items?.carouselTitle.uppercased() ?? "")
            return cell
        }
    }

    private func footerView(atIndex index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            for: self,
            class: StoreCarouselFooterCell.self,
            at: index) as? StoreCarouselFooterCell, let items = items else {
            fatalError()
        }
        view.seeAllButtonTapped = {
            self.seeAllButtonTapped?(items.id, items.carouselTitle, items.carouselDescription)
        }
        return view
    }
}
