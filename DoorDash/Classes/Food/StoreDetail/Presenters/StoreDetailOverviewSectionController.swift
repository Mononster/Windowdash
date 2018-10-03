//
//  StoreDetailOverviewSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class StoreDetailOverviewPresentingModel: NSObject, ListDiffable {

    let name: String
    let storeDescription: String
    let rating: Double
    let ratingDisplay: String
    let deliveryFee: String
    let deliveryTime: String
    let deliveryDistance: String
    let offerPickUp: Bool

    init(name: String,
         storeDescription: String,
         rating: Double,
         ratingDisplay: String,
         deliveryFee: String,
         deliveryTime: String,
         deliveryDistance: String,
         offerPickUp: Bool) {
        self.name = name
        self.storeDescription = storeDescription
        self.rating = rating
        self.ratingDisplay = ratingDisplay
        self.deliveryFee = deliveryFee
        self.deliveryTime = deliveryTime
        self.deliveryDistance = deliveryDistance
        self.offerPickUp = offerPickUp
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class StoreDetailOverviewSectionController: ListSectionController {

    private var model: StoreDetailOverviewPresentingModel?

    override func numberOfItems() -> Int {
        return 2
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let name = model?.name, let description = model?.storeDescription else {
            return CGSize.zero
        }
        let collectionViewWidth = collectionContext?.containerSize.width ?? 0
        if index == 0 {
            let containerWidth = collectionViewWidth - 2 * StoreDetailViewModel.UIStats.leadingSpace
            let nameHeight = HelperManager.textHeight(name, width: containerWidth, font: StoreDetailOverviewCell.nameFont)
            let descriptionHeight = HelperManager.textHeight(description, width: containerWidth, font: StoreDetailOverviewCell.descriptionFont)
            return CGSize(width: collectionViewWidth,
                          height: StoreDetailOverviewCell.heightWithoutLabels + nameHeight + descriptionHeight)
        } else {
            return CGSize(width: collectionViewWidth,
                          height: StoreDetailDeliveryInfoCell.height)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreDetailOverviewCell.self, for: self, at: index)
                as? StoreDetailOverviewCell, let model = model else {
                fatalError()
            }
            cell.setupCell(
                name: model.name,
                description: model.storeDescription,
                ratingText: model.ratingDisplay,
                ratingNum: model.rating
            )
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(
                of: StoreDetailDeliveryInfoCell.self, for: self, at: index)
                as? StoreDetailDeliveryInfoCell, let model = model else {
                    fatalError()
            }
            cell.setupCell(deliveryFeeDisplay: model.deliveryFee,
                           timeDispaly: model.deliveryTime,
                           distanceDisplay: model.deliveryDistance,
                           offerPickUp: model.offerPickUp)
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? StoreDetailOverviewPresentingModel
    }
}
