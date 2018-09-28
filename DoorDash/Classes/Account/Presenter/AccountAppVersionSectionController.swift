//
//  AccountAppVersionSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class AccountAppVersionSectionController: ListSectionController {

    private var models: [UserAccountPagePresentingModel]?

    override init() {
        super.init()
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = UserAccountPageVersionCell.height
        return CGSize(width: width, height: height)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let model = models?[safe: index] else {
            return UICollectionViewCell()
        }
        guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageVersionCell.self, for: self, at: index) as? UserAccountPageVersionCell else {
            fatalError()
        }
        cell.setupCell(version: model.title)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.models = (object as? UserAccountPageSectionModel)?.models
    }

    override func didSelectItem(at index: Int) {

    }
}



