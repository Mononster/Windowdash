//
//  StoreHorizontalCarouselSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 6/26/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

typealias StoreHorizontalCarouselModelAlias = (imageURL: URL?, title: String, subTitle: String)

final class StoreHorizontalCarouselItem: NSObject, ListDiffable {

    let id: String
    let imageURL: URL?
    let title: String
    let subTitle: String

    init(id: String, imageURL: URL?, title: String, subTitle: String) {
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

final class StoreHorizontalCarouselItems: NSObject, ListDiffable {

    let id: String
    let items: [StoreHorizontalCarouselItem]
    let carouselTitle: String
    let carouselDescription: String?
    let lastSection: Bool

    init(id: String,
         items: [StoreHorizontalCarouselItem],
         carouselTitle: String,
         carouselDescription: String?,
         lastSection: Bool) {
        self.id = id
        self.items = items
        self.carouselTitle = carouselTitle
        self.carouselDescription = carouselDescription
        self.lastSection = lastSection
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreHorizontalCarouselSectionController: ListSectionController {

    private var items: StoreHorizontalCarouselItems!

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    var seeAllButtonTapped: ((String, String, String?) -> ())?
    var didSelectItem: ((String) -> ())?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        let height: CGFloat = StoreCarouselDisplayCell.getHeight()
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: StoreHorizontalCarouselCollectionViewCell.self,
            for: self,
            at: index) as? StoreHorizontalCarouselCollectionViewCell else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        cell.separator.isHidden = items.lastSection
        return cell
    }

    override func didUpdate(to object: Any) {
        items = object as? StoreHorizontalCarouselItems
    }
}

extension StoreHorizontalCarouselSectionController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in items?.items ?? [] {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = StoreHorizontalCarouselItemSectionController()
        controller.didSelectItem = didSelectItem
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension StoreHorizontalCarouselSectionController: ListSupplementaryViewSource {

    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = BrowseFoodSectionHeaderViewCell.calcHeight(containerWidth: width, title: items?.carouselTitle ?? "")
        return CGSize(width: width, height: height)
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: BrowseFoodSectionHeaderViewCell.self,
            at: index) as? BrowseFoodSectionHeaderViewCell else {
                fatalError()
        }
        cell.setupCell(title: items?.carouselTitle ?? "")
        cell.seeAllButtonTapped = {
            self.seeAllButtonTapped?(self.items.id, self.items.carouselTitle, self.items.carouselDescription)
        }
        return cell
    }
}

