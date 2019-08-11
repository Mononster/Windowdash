//
//  SearchAddressEmptyResultSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class SearchAddressEmptyResultPresentingModel: NSObject, ListDiffable {

    let emptyText: String

    init(emptyText: String) {
        self.emptyText = emptyText
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class SearchAddressEmptyResultSectionController: ListSectionController {

    private var model: SearchAddressEmptyResultPresentingModel!

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = SearchAddressEmptyResultCell.caclHeight(containerWidth: width, text: model.emptyText)
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchAddressEmptyResultCell.self, for: self, at: index) as? SearchAddressEmptyResultCell else {
            fatalError()
        }
        cell.setupCell(text: model.emptyText)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SearchAddressEmptyResultPresentingModel
    }
}
