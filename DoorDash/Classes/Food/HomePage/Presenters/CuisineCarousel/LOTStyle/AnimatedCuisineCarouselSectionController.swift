//
//  AnimatedCuisineCarouselSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-11-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class AnimatedCuisineCarouselSectionController: ListSectionController, ListAdapterDataSource {

    private var page: CuisinePage?
    var didSelectCuisine: ((BrowseFoodCuisineCategory?) -> ())?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        let height = AnimatedCuisineItemSectionController.heightWithoutImage + BrowseFoodViewModel.UIConfigure.getCuisineItemSize(collectionViewWidth: width)
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: HorizontalCarouselCollectionViewCell.self,
            for: self,
            at: index) as? HorizontalCarouselCollectionViewCell else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }

    override func didUpdate(to object: Any) {
        page = object as? CuisinePage
    }
}

extension AnimatedCuisineCarouselSectionController: UICollectionViewDelegate {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in page?.items ?? [] {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = AnimatedCuisineItemSectionController()
        // Loop through all items, check if user is de-selecting category
        // if yes, pass back nil, otherwise pass the actual cusine type.
        controller.didSelectCuisine = { cuisine in
            var deselect: Bool = false
            for item in self.page?.items ?? [] {
                if cuisine.id != item.cuisine.id {
                    item.selected = false
                } else {
                    if item.selected {
                        deselect = true
                    }
                    item.selected = !item.selected
                }
            }
            self.adapter.reloadData(completion: nil)
            self.didSelectCuisine?(deselect ? nil : cuisine)
        }
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


