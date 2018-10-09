//
//  ItemDetailAddInstructionSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class ItemDetailAddInstructionPresentingModel: NSObject, ListDiffable {

    var instructions: String?

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class ItemDetailAddInstructionSectionController: ListSectionController {

    private var model: ItemDetailAddInstructionPresentingModel?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: ItemDetailAddInstructionsCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ItemDetailAddInstructionsCell.self, for: self, at: 0) as? ItemDetailAddInstructionsCell else {
            fatalError()
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? ItemDetailAddInstructionPresentingModel
    }
}
