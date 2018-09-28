//
//  AccountNotificationsSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class AccountNotificationsSectionController: ListSectionController {

    private var models: [UserAccountPagePresentingModel]?

    override init() {
        super.init()
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        var height: CGFloat = 0
        if index == 0 {
            height = UserAccountPageSubTitleCell.height
        } else {
            height = UserAccountPageTitleAndToggleCell.height
        }
        return CGSize(width: width, height: height)
    }

    override func numberOfItems() -> Int {
        return 1 + (models?.count ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageSubTitleCell.self, for: self, at: index) as? UserAccountPageSubTitleCell else {
                fatalError()
            }
            cell.setupCell(title: "NOTIFICATIONS")
            return cell
        } else {
            guard let model = models?[safe: index - 1] else {
                return UICollectionViewCell()
            }
            guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageTitleAndToggleCell.self, for: self, at: index) as? UserAccountPageTitleAndToggleCell else {
                fatalError()
            }
            cell.setupCell(title: model.title, isOn: model.toggleOn ?? false)
            cell.separator.isHidden = index == models?.count ? true : false
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        self.models = (object as? UserAccountPageSectionModel)?.models
    }

    override func didSelectItem(at index: Int) {

    }
}


