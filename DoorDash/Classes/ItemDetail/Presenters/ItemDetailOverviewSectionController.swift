//
//  ItemDetailOverviewSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class ItemDetailOverviewPresentingModel: NSObject, ListDiffable {

    let name: String
    let itemDescription: String?
    let popularTag: String?

    init(name: String,
         itemDescription: String?,
         popularTag: String?) {
        self.name = name
        self.itemDescription = itemDescription
        self.popularTag = popularTag
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class ItemDetailOverviewSectionController: ListSectionController {

    private var model: ItemDetailOverviewPresentingModel?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let model = model else {
            return CGSize.zero
        }
        return calcCellSize(name: model.name,
                            description: model.itemDescription,
                            popularTag: model.popularTag)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ItemDetailOverviewCell.self, for: self, at: 0) as? ItemDetailOverviewCell, let model = model else {
            fatalError()
        }
        cell.setupCell(itemName: model.name,
                       itemDescription: model.itemDescription,
                       popularTag: model.popularTag)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? ItemDetailOverviewPresentingModel
    }
}

extension ItemDetailOverviewSectionController {

    private func calcCellSize(name: String, description: String?, popularTag: String?) -> CGSize {
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        let containerWidth = collectionViewWidth - 2 * ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
        let nameHeight = HelperManager.textHeight(name, width: containerWidth, font: StoreDetailOverviewCell.nameFont)
        let descriptionHeight = HelperManager.textHeight(description, width: containerWidth, font: StoreDetailOverviewCell.descriptionFont)
        let popularTagHeight: CGFloat = popularTag == nil ? 16 : 20 + 15
        return CGSize(width: collectionViewWidth,
                      height: popularTagHeight + nameHeight + 16 + descriptionHeight + 12)
    }
}
