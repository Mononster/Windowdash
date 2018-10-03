//
//  CuisineCarouselSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CuisineCarouselSectionController: ListSectionController, ListAdapterDataSource {

    private var pages: CuisinePages?
    var didSelectCuisine: ((BrowseFoodCuisineCategory) -> ())?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override func numberOfItems() -> Int {
        return 2
    }

    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 0
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        if index == 0 {
            height = BrowseFoodSectionHeaderViewCell.height
        } else {
            height = CuisineItemSectonController.heightWithoutImage + BrowseFoodViewModel.UIConfigure.getCuisineItemSize(collectionViewWidth: width)
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: BrowseFoodSectionHeaderViewCell.self,
                for: self,
                at: index) as? BrowseFoodSectionHeaderViewCell else {
                    fatalError()
            }
            cell.titleLabel.text = "CUISINES"
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: CuisineCarouselCollectionViewCell.self,
                for: self,
                at: index) as? CuisineCarouselCollectionViewCell else {
                    fatalError()
            }
            adapter.collectionView = cell.collectionView
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        pages = object as? CuisinePages
    }
}

extension CuisineCarouselSectionController: UICollectionViewDelegate {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for page in pages?.pages ?? [] {
            diffableItems.append(page)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = CuisineCarouselPageSectionController()
        controller.didSelectCuisine = didSelectCuisine
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

