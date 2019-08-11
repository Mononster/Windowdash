//
//  SearchAddressItemsSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class SearchAddressItemsPresentingModel: NSObject, ListDiffable {

    let items: [SearchAddressItemModel]

    init(items: [SearchAddressItemModel]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SearchAddressItemsPresentingModel else { return false }
        return items == object.items
    }
}

final class SearchAddressItemsSectionController: ListSectionController {

    private var model: SearchAddressItemsPresentingModel!
    var didSelectAddress: ((SearchAddressItemModel) -> Void)?

    override func numberOfItems() -> Int {
        return model.items.count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let item = model.items[index]
        let width = collectionContext?.containerSize.width ?? 0
        let height = SearchAddressItemCell.calcHeight(
            containerWidth: width,
            title: item.placeName,
            subText: item.placeAddress,
            description: item.instruction,
            selected: item.selected
        )
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let item = model.items[index]
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchAddressItemCell.self, for: self, at: index) as? SearchAddressItemCell else {
            fatalError()
        }
        cell.setupCell(title: item.placeName, subText: item.placeAddress, description: item.instruction, selected: item.selected)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SearchAddressItemsPresentingModel
    }

    override func didSelectItem(at index: Int) {
        guard let item = model.items[safe: index] else {
            return
        }
        didSelectAddress?(item)
    }
}
