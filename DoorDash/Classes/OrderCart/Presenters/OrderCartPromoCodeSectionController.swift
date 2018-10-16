//
//  OrderCartPromoCodeSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class OrderCartPromoCodePresentingModel: NSObject, ListDiffable {

    let title: String

    init(title: String) {
        self.title = title
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class OrderCartPromoCodeSectionController: ListSectionController {

    private var model: OrderCartPromoCodePresentingModel?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: OrderCartPromoCodeItemCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OrderCartPromoCodeItemCell.self, for: self, at: index) as? OrderCartPromoCodeItemCell else {
            fatalError()
        }
        cell.setupCell(title: model?.title ?? "")
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? OrderCartPromoCodePresentingModel
    }
}

