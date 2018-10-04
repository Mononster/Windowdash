//
//  StoreDetailMenuSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

enum StoreDetailMenuCellType {
    case menuSectionHeader
    case menuItem
    case separator
}

struct StoreDetailMenuItemPresentingModel {
    let name: String
    let itemDescription: String?
    let price: String
    let imageURL: URL?
    let popularTag: String?

    init(name: String,
         itemDescription: String?,
         imageURL: URL?,
         price: String,
         popularTag: String?) {
        self.name = name
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.price = price
        self.popularTag = popularTag
    }
}

struct StoreDetailMenuHeaderPresentingModel {
    let title: String
    let sectionDescription: String?

    init(title: String, sectionDescription: String?) {
        self.title = title
        self.sectionDescription = sectionDescription
    }
}

struct StoreDetailMenuItemModel {
    let type: StoreDetailMenuCellType
    let menuItem: StoreDetailMenuItemPresentingModel?
    let sectionHeader: StoreDetailMenuHeaderPresentingModel?

    init(type: StoreDetailMenuCellType,
         menuItem: StoreDetailMenuItemPresentingModel? = nil,
         sectionHeader: StoreDetailMenuHeaderPresentingModel? = nil) {
        self.type = type
        self.menuItem = menuItem
        self.sectionHeader = sectionHeader
    }
}

final class StoreDetailMenuPresentingModel: NSObject, ListDiffable {

    let menuTitles: [String]
    let menuItemModels: [StoreDetailMenuItemModel]

    init(menuTitles: [String],
         menuItemModels: [StoreDetailMenuItemModel]) {
        self.menuTitles = menuTitles
        self.menuItemModels = menuItemModels
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

protocol StoreDetailMenuSectionControllerDelegate: class {
    func navigatorButtonTapped(index: Int)
}

final class StoreDetailMenuSectionController: ListSectionController {

    private var model: StoreDetailMenuPresentingModel?
    var menuNavigator: SegmentNavigateView?

    weak var delegate: StoreDetailMenuSectionControllerDelegate?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return model?.menuItemModels.count ?? 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let item = model?.menuItemModels[safe: index] else {
            return CGSize.zero
        }
        return StoreDetailViewModel.getSizeForModel(item: item)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let model = model?.menuItemModels[safe: index] else {
            return UICollectionViewCell()
        }
        switch model.type {
        case .menuItem:
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreDetailMenuItemCell.self, for: self, at: index)
                as? StoreDetailMenuItemCell, let item = model.menuItem else {
                    fatalError()
            }
            cell.setupCell(itemName: item.name, itemPrice: item.price, itemDescription: item.itemDescription, imageURL: item.imageURL, popularTag: item.popularTag)
            return cell
        case .menuSectionHeader:
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreDetailMenuHeaderCell.self, for: self, at: index)
                as? StoreDetailMenuHeaderCell, let header = model.sectionHeader else {
                    fatalError()
            }
            let hideSeparator = index == 0 ? true : false
            cell.setupCell(title: header.title, description: header.sectionDescription, hideTopSeparator: hideSeparator)
            return cell
        case .separator:
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreDetailMenuSeparatorCell.self, for: self, at: index)
                as? StoreDetailMenuSeparatorCell else {
                    fatalError()
            }
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? StoreDetailMenuPresentingModel
    }
}

extension StoreDetailMenuSectionController: ListSupplementaryViewSource {
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
        return CGSize(width: width, height: StoreDetailMenuNavigatorCell.height)
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: StoreDetailMenuNavigatorCell.self,
            at: index) as? StoreDetailMenuNavigatorCell, let model = model else {
                fatalError()
        }
        cell.setupCell(navigatorTitles: model.menuTitles)
        menuNavigator = cell.segmentNavigateView
        menuNavigator?.buttonTapped = { index in
            self.delegate?.navigatorButtonTapped(index: index)
        }
        return cell
    }

    func adjustMenuNavigator(section: Int) {
        self.menuNavigator?.scrollTo(index: section)
    }
}
