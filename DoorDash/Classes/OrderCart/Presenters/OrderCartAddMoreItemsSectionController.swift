//
//  OrderCartAddMoreItemsSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class OrderCartAddMoreItemsPresentingModel: NSObject, ListDiffable {

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

final class OrderCartAddMoreItemsSectionController: ListSectionController {

    private var model: OrderCartAddMoreItemsPresentingModel?

    var addMoreItemTapped: (() -> ())?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: OrderCartAddMoreItemCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OrderCartAddMoreItemCell.self, for: self, at: index) as? OrderCartAddMoreItemCell else {
            fatalError()
        }
        cell.setupCell(title: model?.title ?? "")
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? OrderCartAddMoreItemsPresentingModel
    }

    override func didSelectItem(at index: Int) {
        self.addMoreItemTapped?()
    }
}
