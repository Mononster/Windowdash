//
//  BrowseFoodSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class SubletTitleCellModel: NSObject, ListDiffable {
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

final class BrowseFoodSectionController: ListSectionController {

    private var titleAndPlaceType: SubletTitleCellModel?

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = SubletStatusTitleCell.heightWithoutTitle + 20
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SubletStatusTitleCell.self, for: self, at: index) as? SubletStatusTitleCell else {
            fatalError()
        }
        cell.placeTypeText = titleAndPlaceType?.title
        cell.titleText = titleAndPlaceType?.title
        return cell
    }

    override func didUpdate(to object: Any) {
        titleAndPlaceType = object as? SubletTitleCellModel
    }

    override func didSelectItem(at index: Int) {
    }
}
