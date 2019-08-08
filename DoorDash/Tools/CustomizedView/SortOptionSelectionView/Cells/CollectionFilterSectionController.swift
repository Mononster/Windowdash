//
//  CollectionFilterSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/5/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CollectionFilterItemPresentingModel: NSObject, ListDiffable {

    let displayValue: String
    var isSelected: Bool

    init(displayValue: String, isSelected: Bool) {
        self.displayValue = displayValue
        self.isSelected = isSelected
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class CollectionFilterPresentingModel: NSObject, ListDiffable {

    let items: [CollectionFilterItemPresentingModel]

    init(items: [CollectionFilterItemPresentingModel]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class CollectionFilterSectionController: ListSectionController, ListAdapterDataSource {

    private var model: CollectionFilterPresentingModel!
    private var totalCellWidth: CGFloat = 0

    var didSelectItem: ((CollectionFilterItemPresentingModel) -> ())?

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
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: CollectionFilterContainerView.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: CollectionFilterContainerView.self,
            for: self,
            at: index) as? CollectionFilterContainerView else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        let collectionViewHeight = collectionContext?.containerSize.height ?? 0
        let totalItemSpaceCount = model.items.count - 1
        let totalSpacingWidth: CGFloat = CollectionFilterItemSectionController.spaceBetweenIems * CGFloat(totalItemSpaceCount)
        if totalCellWidth + totalSpacingWidth < collectionViewWidth - 24 {
            let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            cell.collectionView.contentInset = UIEdgeInsets(
                top: (collectionViewHeight - CollectionFilterItemCell.Constants().size) / 2,
                left: leftInset,
                bottom: 0,
                right: rightInset
            )
        }
        adapter.reloadData(completion: nil)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? CollectionFilterPresentingModel
        let numOfItems = CGFloat(model.items.count)
        totalCellWidth = numOfItems * CollectionFilterItemCell.Constants().size
    }

    func getSelectedData() -> [String] {
        var result: [String] = []
        for item in model.items where item.isSelected {
            result.append(item.displayValue)
        }
        return result
    }
}

extension CollectionFilterSectionController {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in model.items {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = CollectionFilterItemSectionController()
        controller.didSelectItem = { selectedItem in
            for item in self.model?.items ?? [] {
                if selectedItem.displayValue == item.displayValue {
                    item.isSelected.toggle()
                }
            }
            self.adapter.reloadData(completion: nil)
            self.didSelectItem?(selectedItem)
        }
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
