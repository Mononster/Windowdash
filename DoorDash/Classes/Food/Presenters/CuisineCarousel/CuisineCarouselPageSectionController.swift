//
//  CuisineCarouselPageSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CuisineCarouselPageSectionController: ListSectionController, ListAdapterDataSource {

    private var page: CuisinePage?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = (collectionContext?.containerSize.width ?? 0) - 2 * (BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 4)
        return CGSize(width: width, height: collectionContext?.containerSize.height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: CuisineCarouselPageCollectionViewCell.self,
            for: self,
            at: index) as? CuisineCarouselPageCollectionViewCell else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }

    override func didUpdate(to object: Any) {
        page = object as? CuisinePage
    }
}

extension CuisineCarouselPageSectionController {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in page?.items ?? [] {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CuisineItemSectonController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


