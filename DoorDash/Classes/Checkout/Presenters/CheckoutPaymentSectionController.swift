//
//  CheckoutPaymentSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class CheckoutPaymentPresentingModel: NSObject, ListDiffable {

    let dasherTipValue: String
    let dasherTips: [String]
    let currentSelectedTipIndex: Int
    let cardInfo: String

    init(dasherTipValue: String,
         dasherTips: [String],
         currentSelectedTipIndex: Int,
         cardInfo: String) {
        self.dasherTipValue = dasherTipValue
        self.dasherTips = dasherTips
        self.currentSelectedTipIndex = currentSelectedTipIndex
        self.cardInfo = cardInfo
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

protocol CheckoutPaymentSectionControllerDelegate: class {
    func showPaymentPage()
    func userChangedTipValue(index: Int)
}

final class CheckoutPaymentSectionController: ListSectionController {

    private var model: CheckoutPaymentPresentingModel?

    weak var delegate: CheckoutPaymentSectionControllerDelegate?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return 2
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height: CGFloat
        if index == 0 {
            height = CheckoutDasherTipCell.height
        } else {
            height = CheckoutDisplayInfoCell.height
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let model = model else { return UICollectionViewCell() }
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: CheckoutDasherTipCell.self, for: self, at: index) as?
                CheckoutDasherTipCell else {
                fatalError()
            }
            cell.setupCell(exactTipValue: model.dasherTipValue,
                           tipValues: model.dasherTips,
                           selectedIndex: model.currentSelectedTipIndex)
            cell.segmentControlChangedIndex = { index in
                self.delegate?.userChangedTipValue(index: index)
            }
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: CheckoutDisplayInfoCell.self, for: self, at: index) as? CheckoutDisplayInfoCell else {
                fatalError()
            }
            cell.setupCell(title: "Payment", value: model.cardInfo)
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? CheckoutPaymentPresentingModel
    }

    override func didSelectItem(at index: Int) {
        if index == 1 {
            self.delegate?.showPaymentPage()
        }
    }
}

extension CheckoutPaymentSectionController: ListSupplementaryViewSource {
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
        return CGSize(width: width, height: CheckoutSectionHeaderCell.height)
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: CheckoutSectionHeaderCell.self,
            at: index) as? CheckoutSectionHeaderCell else {
                fatalError()
        }
        cell.setupCell(title: "PAYMENT")
        return cell
    }
}

