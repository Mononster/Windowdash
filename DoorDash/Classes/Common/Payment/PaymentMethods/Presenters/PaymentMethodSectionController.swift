//
//  PaymentMethodSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class PaymentMethodPresentingModel: NSObject, ListDiffable {

    let id: Int64
    let title: String
    let subTitle: String
    let isSelected: Bool

    init(id: Int64,
         title: String,
         subTitle: String,
         isSelected: Bool) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.isSelected = isSelected
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class PaymentMethodsPresentingModel: NSObject, ListDiffable {

    let headerTitle: String
    let models: [PaymentMethodPresentingModel]

    init(models: [PaymentMethodPresentingModel], headerTitle: String) {
        self.headerTitle = headerTitle
        self.models = models
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}


final class PaymentMethodSectionController: ListSectionController {

    private var model: PaymentMethodsPresentingModel?

    var userTappedCell: ((Int64) -> ())?

    init(hideHeader: Bool) {
        super.init()
        if !hideHeader {
            supplementaryViewSource = self
        }
    }

    override func numberOfItems() -> Int {
        return model?.models.count ?? 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        return CGSize(width: collectionViewWidth,
                      height: PaymentMethodCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: PaymentMethodCell.self, for: self, at: index)
            as? PaymentMethodCell, let model = model?.models[safe: index] else {
                fatalError()
        }
        cell.setupCell(title: model.title, description: model.subTitle, isSelected: model.isSelected)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? PaymentMethodsPresentingModel
    }

    override func didSelectItem(at index: Int) {
        guard let model = model?.models[safe: index] else {
            return
        }
        self.userTappedCell?(model.id)
    }
}

extension PaymentMethodSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: PaymentMethodsPageTitleCell.height)
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: PaymentMethodsPageTitleCell.self,
            at: index) as? PaymentMethodsPageTitleCell, let headerTitle = model?.headerTitle else {
                fatalError()
        }
        cell.setupCell(title: headerTitle)
        return cell
    }
}

