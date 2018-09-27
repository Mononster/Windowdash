//
//  BrowseFoodAllStoresSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class BrowseFoodAllStoreMenuItem: NSObject, ListDiffable {

    let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoreItem: NSObject, ListDiffable {
    let menuItems: [BrowseFoodAllStoreMenuItem]
    let storeName: String
    let priceAndCuisine: String
    let rating: String
    let deliveryTime: String
    let deliveryCost: String

    init(menuItems: [BrowseFoodAllStoreMenuItem],
         storeName: String,
         priceAndCuisine: String,
         rating: String,
         deliveryTime: String,
         deliveryCost: String) {
        self.menuItems = menuItems
        self.storeName = storeName
        self.priceAndCuisine = priceAndCuisine
        self.rating = rating
        self.deliveryTime = deliveryTime
        self.deliveryCost = deliveryCost
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoreItems: NSObject, ListDiffable {
    var items: [BrowseFoodAllStoreItem]

    init(items: [BrowseFoodAllStoreItem]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoresSectionController: ListSectionController, ListAdapterDataSource {

    private var item: BrowseFoodAllStoreItem?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 0
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        if item?.menuItems.count == 0 {
            height = BrowseFoodStoreDispalyCell.heightWithoutMenu
        } else {
            height = BrowseFoodStoreDispalyCell.heightWithMenu
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: BrowseFoodStoreDispalyCell.self,
            for: self,
            at: index) as? BrowseFoodStoreDispalyCell else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? BrowseFoodAllStoreItem
    }
}

extension BrowseFoodAllStoresSectionController {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for menuItem in item?.menuItems ?? [] {
            diffableItems.append(menuItem)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return BrowseFoodStoreMenuDisplaySectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


