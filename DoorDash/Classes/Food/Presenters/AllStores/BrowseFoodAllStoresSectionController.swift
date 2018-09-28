//
//  BrowseFoodAllStoresSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class BrowseFoodAllStoresSectionController: ListSectionController, ListAdapterDataSource {

    private var item: BrowseFoodAllStoreItem?
    weak var edgeSwipeBackGesture: UIGestureRecognizer?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    init(addInset: Bool) {
        super.init()
        if addInset {
            self.inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
    }

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
        if item?.closeTimeDisplay != nil {
            height += BrowseFoodStoreDispalyCell.closeTimeHeight
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: BrowseFoodStoreDispalyCell.self,
            for: self,
            at: index) as? BrowseFoodStoreDispalyCell, let item = item else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        if let gesture = edgeSwipeBackGesture {
            cell.collectionView.panGestureRecognizer.require(toFail: gesture)
        }
        cell.updateUI(menuExists: item.menuItems.count != 0,
                      closeTimeExists: item.closeTimeDisplay != nil,
                      isClosed: item.isClosed)
        cell.setupCell(
            storeName: item.storeName,
            priceAndCuisine: item.priceAndCuisine,
            rating: item.rating,
            shouldHighlightRating: item.shouldHighlightRating,
            ratingDescription: item.ratingDescription,
            deliveryTime: item.deliveryTime,
            deliveryCost: item.deliveryCost,
            closeTime: item.closeTimeDisplay
        )
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


