//
//  SearchAddressItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class SearchAddressItemPresentingModel: NSObject, ListDiffable {

    let item: SearchAddressItemModel

    init(item: SearchAddressItemModel) {
        self.item = item
    }

    func diffIdentifier() -> NSObjectProtocol {
        return item.id as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SearchAddressItemPresentingModel else { return false }
        return item == object.item
    }
}

final class SearchAddressItemSectionController: ListSectionController {

    private var model: SearchAddressItemPresentingModel!
    var didSelectAddress: ((SearchAddressItemModel) -> Void)?

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let item = model.item
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
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchAddressItemCell.self, for: self, at: index) as? SearchAddressItemCell else {
            fatalError()
        }
        cell.stopAnimation()
        cell.setupCell(title: model.item.placeName, subText: model.item.placeAddress, description: model.item.instruction, selected: model.item.selected)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SearchAddressItemPresentingModel
    }

    override func didSelectItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? SearchAddressItemCell else {
            return
        }
        if model.item.referenceID == nil {
            cell.startAnimation()
        }
        didSelectAddress?(model.item)
    }
}
