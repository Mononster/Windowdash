//
//  CuratedCategoryHeaderSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 9/28/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class CuratedCategoryHeaderModel: NSObject, ListDiffable {

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

final class CuratedCategoryHeaderSectionController: ListSectionController {

    private var model: CuratedCategoryHeaderModel?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: CuratedCategoryHeaderCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CuratedCategoryHeaderCell.self, for: self, at: index) as? CuratedCategoryHeaderCell, let model = model else {
            fatalError()
        }
        cell.titleLabel.text = model.title
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? CuratedCategoryHeaderModel
    }
}

