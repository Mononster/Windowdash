//
//  OrderCartEmptyDataSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class OrderCartEmptyDataPresentingModel: NSObject, ListDiffable {

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

final class OrderCartEmptyDataSectionController: ListSectionController {

    private var model: OrderCartEmptyDataPresentingModel?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: EmptyCartCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmptyCartCell.self, for: self, at: index) as? EmptyCartCell else {
            fatalError()
        }
        cell.setupCell(title: model?.title ?? "")
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? OrderCartEmptyDataPresentingModel
    }
}
