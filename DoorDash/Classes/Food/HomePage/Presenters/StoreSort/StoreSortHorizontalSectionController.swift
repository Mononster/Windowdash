//
//  StoreSortHorizontalSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class StoreSortItemPresentingModel: NSObject, ListDiffable {

    let id: String
    let kind: StoreFilterType
    var title: String
    var displayValue: String
    let selections: [String]
    var selected: Bool
    var selectedValues: [String]

    init(id: String,
         kind: StoreFilterType,
         title: String,
         selected: Bool,
         displayValue: String,
         selections: [String] = [],
         selectedValues: [String] = []) {
        self.id = id
        self.kind = kind
        self.title = title
        self.selected = selected
        self.displayValue = displayValue
        self.selections = selections
        self.selectedValues = selectedValues
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreSortHorizontalPresentingModel: NSObject, ListDiffable {

    let items: [StoreSortItemPresentingModel]

    init(items: [StoreSortItemPresentingModel]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreSortHorizontalSectionController: ListSectionController {

    private var model: StoreSortHorizontalPresentingModel?
    var openSelectionView: ((StoreSortItemPresentingModel) -> Void)?
    var didSelectItem: ((StoreSortItemPresentingModel) -> ())?

    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override init() {
        super.init()
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = collectionContext?.containerSize.width ?? 0
        let height = StoreSortBaseCell.Constants().containerHeight
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
        cell.setupCell(inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? StoreSortHorizontalPresentingModel
    }

    func selectSortItem(_ selectedItem: StoreSortItemPresentingModel, selected: Bool) {
        for item in self.model?.items ?? [] {
            if selectedItem.id == item.id {
                item.selected = selected
            }
        }
        self.adapter.reloadData(completion: nil)
    }
}

extension StoreSortHorizontalSectionController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in model?.items ?? [] {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = StoreSortItemSectionController()
        controller.openSelectionView = openSelectionView
        // Loop through all items, check if user is de-selecting category
        // if yes, pass back nil, otherwise pass the actual cusine type.
        controller.didSelectItem = { selectedItem in
            self.selectSortItem(selectedItem, selected: !selectedItem.selected)
            self.didSelectItem?(selectedItem)
        }
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
