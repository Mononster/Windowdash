//
//  AccountDetailsSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class AccountDetailsSectionController: ListSectionController {

    private var models: [UserAccountPagePresentingModel]?

    override init() {
        super.init()
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        var height: CGFloat = 0
        if index == 0 {
            height = UserAccountPageTitleCell.height
        } else {
            height = UserAccountPageTitleWithDescriptionCell.height
        }
        return CGSize(width: width, height: height)
    }

    override func numberOfItems() -> Int {
        return 1 + (models?.count ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageTitleCell.self, for: self, at: index) as? UserAccountPageTitleCell else {
                fatalError()
            }
            return cell
        } else {
            guard let model = models?[safe: index - 1] else {
                return UICollectionViewCell()
            }
            switch model.type {
            case .basicInfo, .paymentCards, .addresses:
                guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageTitleWithDescriptionCell.self, for: self, at: index) as? UserAccountPageTitleWithDescriptionCell else {
                    fatalError()
                }
                cell.setupCell(title: model.title, description: model.subTitle)
                return cell
            case .linkFacebook, .deliverySupport, .accountCredits, .referFriends:
                guard let cell = collectionContext?.dequeueReusableCell(of: UserAccountPageTitleAndValueCell.self, for: self, at: index) as? UserAccountPageTitleAndValueCell else {
                    fatalError()
                }
                if model.type == .referFriends {
                    cell.setupCell(title: model.title, value: model.subTitle, titleColor: ApplicationDependency.manager.theme.colors.doorDashRed)
                } else {
                    cell.setupCell(title: model.title, value: model.subTitle)
                }
                cell.separator.isHidden = index == models?.count ? true : false
                return cell
            default: break
            }
        }
        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        self.models = (object as? UserAccountPageSectionModel)?.models
    }

    override func didSelectItem(at index: Int) {

    }
}

