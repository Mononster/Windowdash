//
//  StoreDetailSwitchMenuSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class StoreDetailSwitchMenuPresentingModel: NSObject, ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

protocol StoreDetailSwitchMenuSectionControllerDelegate: class {
    func userTappedSwitchMenu()
}

final class StoreDetailSwitchMenuSectionController: ListSectionController {

    private var model: StoreDetailSwitchMenuPresentingModel?

    weak var delegate: StoreDetailSwitchMenuSectionControllerDelegate?

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        return CGSize(width: collectionViewWidth,
                      height: StoreDetailSwitchMenuCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: StoreDetailSwitchMenuCell.self, for: self, at: index)
            as? StoreDetailSwitchMenuCell else {
                fatalError()
        }
        cell.userTappedSwitchMenu = {
            self.delegate?.userTappedSwitchMenu()
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? StoreDetailSwitchMenuPresentingModel
    }
}

