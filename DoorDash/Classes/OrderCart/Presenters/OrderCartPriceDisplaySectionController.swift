//
//  OrderCartPriceDisplaySectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class OrderCartPriceDisplayPresentingModel: NSObject, ListDiffable {

    let priceDisplays: [(String, String, Bool)]

    let promoUsedOnDelivery: Bool
    let taxAndFeeDetail: String
    let promoHintTitle: String?
    let promoDetail: String?

    init(priceDisplays: [(String, String, Bool)],
         promoUsedOnDelivery: Bool,
         taxAndFeeDetail: String,
         promoHintTitle: String?,
         promoDetail: String?) {
        self.priceDisplays = priceDisplays
        self.promoUsedOnDelivery = promoUsedOnDelivery
        self.taxAndFeeDetail = taxAndFeeDetail
        self.promoHintTitle = promoHintTitle
        self.promoDetail = promoDetail
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class OrderCartPriceDisplaySectionController: ListSectionController {

    private var model: OrderCartPriceDisplayPresentingModel?

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    override func numberOfItems() -> Int {
        return model?.promoHintTitle == nil ? 3 : 4
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: OrderCartPriceDisplayCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0, 1, 2:
            guard let cell = collectionContext?.dequeueReusableCell(of: OrderCartPriceDisplayCell.self, for: self, at: index) as? OrderCartPriceDisplayCell, let model = model, let priceDisplay = model.priceDisplays[safe: index] else {
                fatalError()
            }

            var promoText: String?
            if model.promoUsedOnDelivery && index == 2 {
                promoText = "Free"
            }
            cell.setupCell(title: priceDisplay.0,
                           price: priceDisplay.1,
                           showInfoIcon:priceDisplay.2,
                           promoAppliedText: promoText)
            return cell
        case 3:
            guard let cell = collectionContext?.dequeueReusableCell(of: OrderCartPromoHintCell.self, for: self, at: index) as? OrderCartPromoHintCell, let title = model?.promoHintTitle else {
                fatalError()
            }
            cell.setupCell(title: title)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? OrderCartPriceDisplayPresentingModel
    }
}

